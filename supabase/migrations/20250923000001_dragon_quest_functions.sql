-- Dragon Quest XI API Functions
-- Created: 2025-09-23
-- Author: Marosdee Uma
-- Description: API functions for Dragon Quest XI Interactive Story Web Application

-- Function to get available events for a user
CREATE OR REPLACE FUNCTION public.get_available_events(user_uuid UUID)
RETURNS TABLE (
    event_id UUID,
    event_title VARCHAR(255),
    event_description TEXT,
    event_type VARCHAR(50),
    chapter_title VARCHAR(255),
    location_name VARCHAR(255),
    interactions_count BIGINT
) 
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        se.id as event_id,
        se.title as event_title,
        se.description as event_description,
        se.event_type,
        sc.title as chapter_title,
        l.name as location_name,
        COUNT(ei.id) as interactions_count
    FROM public.story_events se
    LEFT JOIN public.story_chapters sc ON se.chapter_id = sc.id
    LEFT JOIN public.locations l ON se.location_id = l.id
    LEFT JOIN public.event_interactions ei ON se.id = ei.event_id
    LEFT JOIN public.user_progress up ON up.user_id = user_uuid
    WHERE 
        -- Event must be unlocked by user (in unlocked_events array)
        up.unlocked_events IS NOT NULL
        AND se.id = ANY((SELECT jsonb_array_elements_text(up.unlocked_events))::UUID[])
        -- Event must not be completed yet
        AND (
            up.completed_events IS NULL 
            OR NOT (se.id = ANY((SELECT jsonb_array_elements_text(up.completed_events))::UUID[]))
        )
    GROUP BY se.id, se.title, se.description, se.event_type, sc.title, l.name
    ORDER BY se.display_order;
END;
$$;

-- Function to complete an interaction and update user progress

CREATE OR REPLACE FUNCTION public.complete_interaction(
    user_uuid UUID,
    interaction_uuid UUID,
    choice_data JSONB DEFAULT '{}'::JSONB
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    interaction_record RECORD;
    event_record RECORD;
    outcome_record RECORD;
    user_progress_record RECORD;
    result JSONB;
    has_choices BOOLEAN;
    next_event_to_unlock UUID;
    transaction_id UUID;
BEGIN
    -- Generate transaction ID for error tracking
    transaction_id := gen_random_uuid();
    
    -- Initialize result with transaction ID
    result := jsonb_build_object(
        'success', false,
        'transaction_id', transaction_id,
        'errors', '[]'::JSONB
    );
    -- Get interaction details
    SELECT * INTO interaction_record
    FROM public.event_interactions
    WHERE id = interaction_uuid;
    
    IF NOT FOUND THEN
        result := jsonb_set(result, '{success}', 'false');
        result := jsonb_set(result, '{errors}', 
            result->'errors' || jsonb_build_array(
                jsonb_build_object(
                    'type', 'validation_error',
                    'message', 'Interaction not found',
                    'transaction_id', transaction_id
                )
            ));
        RETURN result;
    END IF;
    
    -- Get event details
    SELECT * INTO event_record
    FROM public.story_events
    WHERE id = interaction_record.event_id;
    
    IF NOT FOUND THEN
        result := jsonb_set(result, '{success}', 'false');
        result := jsonb_set(result, '{errors}', 
            result->'errors' || jsonb_build_array(
                jsonb_build_object(
                    'type', 'validation_error',
                    'message', 'Event not found for this interaction',
                    'transaction_id', transaction_id
                )
            ));
        RETURN result;
    END IF;
    
    -- Get user progress (must exist)
    SELECT * INTO user_progress_record
    FROM public.user_progress
    WHERE user_id = user_uuid;
    
    IF NOT FOUND THEN
        result := jsonb_set(result, '{success}', 'false');
        result := jsonb_set(result, '{errors}', 
            result->'errors' || jsonb_build_array(
                jsonb_build_object(
                    'type', 'validation_error',
                    'message', 'User progress not found. Please initialize user progress first.',
                    'transaction_id', transaction_id
                )
            ));
        RETURN result;
    END IF;
    
    -- Check if interaction has choices
    has_choices := (interaction_record.choices IS NOT NULL AND 
                   interaction_record.choices != '[]'::JSONB AND 
                   jsonb_array_length(interaction_record.choices) > 0);
    
    -- Find matching outcome based on choice
    SELECT * INTO outcome_record
    FROM public.event_outcomes
    WHERE interaction_id = interaction_uuid
    AND (
        choice_data->>'choice_key' IS NULL 
        OR choice_key = choice_data->>'choice_key'
        OR choice_key IS NULL
    )
    LIMIT 1;
    
    -- If no outcome found and interaction has no choices, create a default outcome
    IF outcome_record IS NULL AND NOT has_choices THEN
        -- Create a default outcome record
        outcome_record := ROW(
            gen_random_uuid(),
            interaction_uuid,
            'default',
            'story',
            'Default Action',
            'Interaction completed successfully',
            '{}'::JSONB,
            NULL,
            NOW(),
            NOW()
        )::public.event_outcomes;
        
        -- For simple interactions, automatically unlock the next interaction in the same event
        SELECT id INTO next_event_to_unlock
        FROM public.event_interactions
        WHERE event_id = event_record.id
        AND id != interaction_uuid
        AND display_order = (SELECT display_order FROM public.event_interactions WHERE id = interaction_uuid) + 1
        LIMIT 1;
        
        -- If there's a next interaction, check if it's the last one in this event
        IF next_event_to_unlock IS NOT NULL THEN
            -- Check if this is the last interaction in the event
            IF NOT EXISTS (
                SELECT 1 FROM public.event_interactions ei
                WHERE ei.event_id = event_record.id
                AND ei.id != next_event_to_unlock
                AND ei.display_order > (SELECT display_order FROM public.event_interactions WHERE id = next_event_to_unlock)
            ) THEN
                -- This is the last interaction, so return the event_id instead of interaction_id
                outcome_record.next_event_id := event_record.id;
            ELSE
                -- There are more interactions, so return the next interaction_id
                outcome_record.next_event_id := next_event_to_unlock;
            END IF;
        END IF;
    END IF;
    
    -- Process outcome effects
    IF outcome_record.effects IS NOT NULL THEN
        -- Handle party member joining (CENTRALIZED)
        IF outcome_record.effects ? 'party_join' THEN
            UPDATE public.user_progress
            SET party_members = party_members || jsonb_build_array(
                jsonb_build_object(
                    'character_id', (outcome_record.effects->>'party_join')::UUID,
                    'joined_at', NOW(),
                    'current_stats', (SELECT stats FROM public.characters WHERE id = (outcome_record.effects->>'party_join')::UUID),
                    'equipment', '{}',
                    'is_active', true,
                    'party_position', COALESCE(
                        (SELECT MAX((member->>'party_position')::INTEGER) + 1 
                         FROM jsonb_array_elements(party_members) AS member),
                        1
                    )
                )
            )
            WHERE user_id = user_uuid;
        END IF;
        
        -- Handle item rewards (CENTRALIZED)
        IF outcome_record.effects ? 'items' THEN
            UPDATE public.user_progress
            SET inventory = (
                SELECT jsonb_agg(
                    CASE 
                        WHEN (existing_item->>'item_id')::UUID = (new_item->>'id')::UUID THEN
                            jsonb_build_object(
                                'item_id', existing_item->>'item_id',
                                'quantity', (existing_item->>'quantity')::INTEGER + COALESCE((new_item->>'quantity')::INTEGER, 1),
                                'obtained_at', existing_item->>'obtained_at',
                                'equipped', COALESCE(existing_item->>'equipped', 'false')::BOOLEAN,
                                'slot', existing_item->>'slot'
                            )
                        ELSE
                            existing_item
                    END
                )
                FROM (
                    SELECT * FROM jsonb_array_elements(inventory) AS existing_item
                    UNION ALL
                    SELECT jsonb_build_object(
                        'item_id', (item->>'id')::UUID,
                        'quantity', COALESCE((item->>'quantity')::INTEGER, 1),
                        'obtained_at', NOW(),
                        'equipped', false,
                        'slot', NULL
                    ) AS existing_item
                    FROM jsonb_array_elements(outcome_record.effects->'items') AS item
                    WHERE NOT EXISTS (
                        SELECT 1 FROM jsonb_array_elements(inventory) AS existing_item
                        WHERE (existing_item->>'item_id')::UUID = (item->>'id')::UUID
                    )
                ) AS combined_items
            )
            WHERE user_id = user_uuid;
        END IF;
        
        -- Handle location unlocks
        IF outcome_record.effects ? 'unlock_locations' THEN
            UPDATE public.user_progress
            SET unlocked_locations = unlocked_locations || outcome_record.effects->'unlock_locations'
            WHERE user_id = user_uuid;
        END IF;
        
        -- Handle chapter unlocks
        IF outcome_record.effects ? 'unlock_chapters' THEN
            UPDATE public.user_progress
            SET unlocked_chapters = unlocked_chapters || outcome_record.effects->'unlock_chapters'
            WHERE user_id = user_uuid;
        END IF;
        
        -- Handle event unlocks
        IF outcome_record.effects ? 'unlock_events' THEN
            UPDATE public.user_progress
            SET unlocked_events = unlocked_events || outcome_record.effects->'unlock_events'
            WHERE user_id = user_uuid;
        END IF;
    END IF;
    
    -- Mark event as completed if this was the final interaction
    IF NOT EXISTS (
        SELECT 1 FROM public.event_interactions ei
        WHERE ei.event_id = event_record.id
        AND ei.id != interaction_uuid
        AND ei.is_available = true
    ) THEN
        -- Add event to completed events
        UPDATE public.user_progress
        SET 
            completed_events = completed_events || jsonb_build_array(event_record.id),
            last_played_at = NOW()
        WHERE user_id = user_uuid;
        
        -- Note: We don't update story_events.is_completed anymore
        -- Event completion is tracked in user_progress.completed_events only
    END IF;
    
    -- Build result
    result := jsonb_build_object(
        'success', true,
        'transaction_id', transaction_id,
        'interaction_id', interaction_uuid,
        'event_id', event_record.id,
        'outcome', row_to_json(outcome_record),
        'next_event_id', outcome_record.next_event_id,
        'errors', '[]'::JSONB
    );
    
    RETURN result;
    
EXCEPTION
    WHEN OTHERS THEN
        -- Error handling - rollback จะเกิดขึ้นอัตโนมัติ
        result := jsonb_set(result, '{success}', 'false');
        result := jsonb_set(result, '{errors}', 
            result->'errors' || jsonb_build_array(
                jsonb_build_object(
                    'type', 'internal_error',
                    'message', SQLERRM,
                    'transaction_id', transaction_id
                )
            ));
        RETURN result;
END;
$$;

-- Function to get user's current game state (CENTRALIZED)
CREATE OR REPLACE FUNCTION public.get_user_game_state(user_uuid UUID)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    progress_record RECORD;
    result JSONB;
BEGIN
    -- Get user progress
    SELECT * INTO progress_record
    FROM public.user_progress
    WHERE user_id = user_uuid;
    
    -- If no progress found, return default state
    IF NOT FOUND THEN
        RETURN jsonb_build_object(
            'user_id', user_uuid,
            'current_chapter_id', NULL,
            'current_location_id', NULL,
            'current_event_id', NULL,
            'player_level', 1,
            'player_experience', 0,
            'unlocked_world_maps', '[]'::JSONB,
            'unlocked_locations', '[]'::JSONB,
            'unlocked_chapters', '[]'::JSONB,
            'unlocked_events', '[]'::JSONB,
            'completed_chapters', '[]'::JSONB,
            'completed_events', '[]'::JSONB,
            'inventory', '[]'::JSONB,
            'party_members', '[]'::JSONB,
            'character_relationships', '{}'::JSONB,
            'player_position', '{}'::JSONB,
            'achievements', '[]'::JSONB,
            'play_history', '[]'::JSONB,
            'active_quests', '[]'::JSONB,
            'game_flags', '{}'::JSONB,
            'game_stats', '{}'::JSONB,
            'game_settings', '{}'::JSONB,
            'save_data', '{}'::JSONB,
            'last_played_at', NOW(),
            'created_at', NOW(),
            'updated_at', NOW()
        );
    END IF;
    
    -- Build result with all centralized data
    result := jsonb_build_object(
        'user_id', progress_record.user_id,
        'current_chapter_id', progress_record.current_chapter_id,
        'current_location_id', progress_record.current_location_id,
        'current_event_id', progress_record.current_event_id,
        'player_level', progress_record.player_level,
        'player_experience', progress_record.player_experience,
        'unlocked_world_maps', COALESCE(progress_record.unlocked_world_maps, '[]'::JSONB),
        'unlocked_locations', COALESCE(progress_record.unlocked_locations, '[]'::JSONB),
        'unlocked_chapters', COALESCE(progress_record.unlocked_chapters, '[]'::JSONB),
        'unlocked_events', COALESCE(progress_record.unlocked_events, '[]'::JSONB),
        'completed_chapters', COALESCE(progress_record.completed_chapters, '[]'::JSONB),
        'completed_events', COALESCE(progress_record.completed_events, '[]'::JSONB),
        'inventory', COALESCE(progress_record.inventory, '[]'::JSONB),
        'party_members', COALESCE(progress_record.party_members, '[]'::JSONB),
        'character_relationships', COALESCE(progress_record.character_relationships, '{}'::JSONB),
        'player_position', COALESCE(progress_record.player_position, '{}'::JSONB),
        'achievements', COALESCE(progress_record.achievements, '[]'::JSONB),
        'play_history', COALESCE(progress_record.play_history, '[]'::JSONB),
        'active_quests', COALESCE(progress_record.active_quests, '[]'::JSONB),
        'game_flags', COALESCE(progress_record.game_flags, '{}'::JSONB),
        'game_stats', COALESCE(progress_record.game_stats, '{}'::JSONB),
        'game_settings', COALESCE(progress_record.game_settings, '{}'::JSONB),
        'save_data', COALESCE(progress_record.save_data, '{}'::JSONB),
        'last_played_at', progress_record.last_played_at,
        'created_at', progress_record.created_at,
        'updated_at', progress_record.updated_at
    );
    
    RETURN result;
END;
$$;

-- Function to initialize new user's game progress
CREATE OR REPLACE FUNCTION public.initialize_user_progress(user_uuid UUID)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    first_chapter_id UUID;
    first_location_id UUID;
    first_region_id UUID;
    protagonist_id UUID;
BEGIN
    -- Get first chapter and location
    SELECT id INTO first_chapter_id
    FROM public.story_chapters
    WHERE chapter_number = 1
    LIMIT 1;
    
    -- Fix: Get first location with display_order = 1 (not 0)
    SELECT id INTO first_location_id
    FROM public.locations
    WHERE display_order = 1
    LIMIT 1;
    
    -- Get first unlocked world map
    SELECT id INTO first_region_id
    FROM public.world_map
    WHERE display_order = 1
    ORDER BY display_order
    LIMIT 1;
    
    -- Get protagonist character
    SELECT id INTO protagonist_id
    FROM public.characters
    WHERE character_type = 'party_member' AND (name ILIKE '%hero%' OR name ILIKE '%protagonist%')
    LIMIT 1;
    
    -- Create user progress with all required fields
    INSERT INTO public.user_progress (
        user_id,
        current_chapter_id,
        current_location_id,
        player_level,
        player_experience,
        unlocked_world_maps,
        unlocked_locations,
        unlocked_chapters,
        unlocked_events,
        completed_chapters,
        completed_events,
        inventory,
        equipment,
        active_quests,
        game_flags,
        game_stats,
        game_settings,
        save_data
    ) VALUES (
        user_uuid,
        first_chapter_id,
        first_location_id,
        1,
        0,
        jsonb_build_array(COALESCE(first_region_id, ''::UUID)),
        jsonb_build_array(first_location_id),
        jsonb_build_array(first_chapter_id),
        '[]'::JSONB,
        '[]'::JSONB,
        '[]'::JSONB,
        '[]'::JSONB,
        '{}'::JSONB,
        '[]'::JSONB,
        '{}'::JSONB,
        jsonb_build_object('play_time', 0, 'completion_percentage', 0),
        '{}'::JSONB,
        '{}'::JSONB
    ) ON CONFLICT (user_id) DO UPDATE SET
        unlocked_world_maps = CASE 
            WHEN user_progress.unlocked_world_maps IS NULL OR jsonb_array_length(user_progress.unlocked_world_maps) = 0
            THEN jsonb_build_array(COALESCE(first_region_id, ''::UUID))
            ELSE user_progress.unlocked_world_maps
        END;
    
    -- Add protagonist to party if exists
    IF protagonist_id IS NOT NULL THEN
        INSERT INTO public.user_party_members (
            user_id,
            character_id,
            party_position,
            current_stats
        ) VALUES (
            user_uuid,
            protagonist_id,
            1,
            jsonb_build_object('hp', 100, 'mp', 50, 'level', 1)
        ) ON CONFLICT (user_id, character_id) DO NOTHING;
    END IF;
    
    RETURN jsonb_build_object('success', true, 'message', 'User progress initialized');
END;
$$;

-- Function to unlock world maps
CREATE OR REPLACE FUNCTION public.unlock_region(user_uuid UUID, region_id UUID)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    -- Add region to unlocked_world_maps if not already there
    UPDATE public.user_progress
    SET unlocked_world_maps = 
        CASE 
            WHEN unlocked_world_maps IS NULL THEN jsonb_build_array(region_id::text)
            WHEN NOT (region_id::text = ANY(SELECT jsonb_array_elements_text(unlocked_world_maps))) 
            THEN unlocked_world_maps || region_id::text
            ELSE unlocked_world_maps
        END
    WHERE user_id = user_uuid;
    
    RETURN jsonb_build_object('success', true, 'message', 'World map unlocked');
END;
$$;

-- Function to get world map with unlock status for user
CREATE OR REPLACE FUNCTION public.get_world_map_for_user(user_uuid UUID)
RETURNS TABLE (
    region_id UUID,
    region_name VARCHAR(255),
    region_description TEXT,
    region_image_url VARCHAR(500),
    is_unlocked BOOLEAN,
    locations_count BIGINT,
    unlocked_locations_count BIGINT
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        wm.id as region_id,
        wm.name as region_name,
        wm.description as region_description,
        wm.image_url as region_image_url,
        (
            -- Check if region is unlocked by user progress
            up.unlocked_world_maps IS NOT NULL 
            AND wm.id = ANY((SELECT jsonb_array_elements_text(up.unlocked_world_maps))::UUID[])
        ) as is_unlocked,
        COUNT(l.id) as locations_count,
        COUNT(CASE 
            WHEN up.unlocked_locations IS NOT NULL 
            AND l.id = ANY((SELECT jsonb_array_elements_text(up.unlocked_locations))::UUID[])
            THEN 1 
        END) as unlocked_locations_count
    FROM public.world_map wm
    LEFT JOIN public.locations l ON wm.id = l.world_map_id
    LEFT JOIN public.user_progress up ON up.user_id = user_uuid
    GROUP BY wm.id, wm.name, wm.description, wm.image_url, up.unlocked_locations, up.unlocked_world_maps
    ORDER BY wm.display_order;
END;
$$;

-- Function to get event interactions
CREATE OR REPLACE FUNCTION public.get_event_interactions(
    user_uuid UUID,
    event_uuid UUID
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    event_record RECORD;
    interactions JSONB;
    result JSONB;
BEGIN
    -- Get event details
    SELECT se.*, sc.title as chapter_title, l.name as location_name
    INTO event_record
    FROM public.story_events se
    JOIN public.story_chapters sc ON se.chapter_id = sc.id
    LEFT JOIN public.locations l ON se.location_id = l.id
    WHERE se.id = event_uuid;
    
    IF NOT FOUND THEN
        RETURN jsonb_build_object('error', 'Event not found');
    END IF;
    
    -- Get available interactions for this event
    SELECT jsonb_agg(
        jsonb_build_object(
            'id', ei.id,
            'interaction_type', ei.interaction_type,
            'title', ei.title,
            'description', ei.description,
            'dialogue_text', ei.dialogue_text,
            'character_speaker', ei.character_speaker,
            'character_avatar', 
                CASE 
                    WHEN ei.character_speaker IS NOT NULL THEN
                        (SELECT avatar_url FROM public.characters c WHERE c.name = ei.character_speaker LIMIT 1)
                    ELSE NULL
                END,
            'choices', (
                SELECT jsonb_agg(
                    jsonb_build_object(
                        'id', eo.id,
                        'text', eo.title,
                        'type', eo.outcome_type,
                        'description', eo.description
                    )
                )
                FROM public.event_outcomes eo
                WHERE eo.interaction_id = ei.id
            )
        ) ORDER BY ei.display_order
    ) INTO interactions
    FROM public.event_interactions ei
    WHERE ei.event_id = event_uuid
    AND ei.is_available = true;
    
    -- Build result
    result := jsonb_build_object(
        'event', jsonb_build_object(
            'id', event_record.id,
            'title', event_record.title,
            'description', event_record.description,
            'event_type', event_record.event_type,
            'chapter_title', event_record.chapter_title,
            'location_name', event_record.location_name
        ),
        'interactions', COALESCE(interactions, '[]'::jsonb)
    );
    
    RETURN result;
END;
$$;

-- Grant execute permissions to authenticated users
GRANT EXECUTE ON FUNCTION public.get_available_events(UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION public.complete_interaction(UUID, UUID, JSONB) TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_user_game_state(UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION public.initialize_user_progress(UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_world_map_for_user(UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_event_interactions(UUID, UUID) TO authenticated;
