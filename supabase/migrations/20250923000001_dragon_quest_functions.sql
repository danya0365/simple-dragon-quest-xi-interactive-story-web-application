-- Dragon Quest XI API Functions
-- Created: 2025-09-23
-- Author: Marosdee Uma
-- Description: API functions for Dragon Quest XI Interactive Story Web Application


-- =============================================================================
-- Initialize user progress with comprehensive initialization
-- =============================================================================

CREATE OR REPLACE FUNCTION public.initialize_user_progress(p_user_uuid UUID)
RETURNS JSONB AS $$
DECLARE
    v_progress_record RECORD;
    
    -- Dynamic queries for default content (FIX: Query from database instead of hardcoded values)
    v_hero_character_id UUID;
    v_rusty_sword_item_id UUID;
    v_chapter_1_id UUID;
    v_morning_at_home_event_id UUID;
    v_heros_house_location_id UUID;
    
    -- Variables to store unlocked content arrays
    v_unlocked_world_maps UUID[];
    v_unlocked_locations UUID[];
    v_unlocked_chapters UUID[];
    v_unlocked_events UUID[];
BEGIN
    -- Check if user progress already exists
    SELECT * INTO v_progress_record FROM public.user_progress WHERE user_id = p_user_uuid;
    
    IF v_progress_record IS NOT NULL THEN
        -- User progress already exists, return all columns as JSONB object
        RETURN to_jsonb(v_progress_record);
    END IF;
    
    -- Get default content from database with unlock_requirements = '{}' (FIX: Dynamic queries)
    -- Hero character (first party member with empty join requirements)
    SELECT id INTO v_hero_character_id
    FROM public.characters 
    WHERE join_requirements = '{}'::JSONB AND is_party_member = true
    ORDER BY display_order
    LIMIT 1;
    
    -- Rusty sword item (first weapon with no specific requirements)
    SELECT id INTO v_rusty_sword_item_id
    FROM public.items 
    WHERE item_type = 'weapon'
    ORDER BY id
    LIMIT 1;
    
    -- Chapter 1 (first chapter with empty unlock requirements)
    SELECT id INTO v_chapter_1_id
    FROM public.story_chapters 
    WHERE unlock_requirements = '{}'::JSONB
    ORDER BY display_order
    LIMIT 1;
    
    -- Morning at home event (first event with empty unlock requirements)
    SELECT id INTO v_morning_at_home_event_id
    FROM public.story_events 
    WHERE unlock_requirements = '{}'::JSONB
    ORDER BY display_order
    LIMIT 1;
    
    -- Hero's house location (first location with empty unlock requirements)
    SELECT id INTO v_heros_house_location_id
    FROM public.locations 
    WHERE unlock_requirements = '{}'::JSONB
    ORDER BY display_order
    LIMIT 1;
    
    -- Get unlocked content from each table separately (FIX: No more UNION ALL mixing)
    -- World Maps with empty requirements
    SELECT COALESCE(ARRAY_AGG(id ORDER BY display_order), ARRAY[]::UUID[])
    INTO v_unlocked_world_maps
    FROM public.world_map 
    WHERE unlock_requirements = '{}'::JSONB;
    
    -- Locations with empty requirements  
    SELECT COALESCE(ARRAY_AGG(id ORDER BY display_order), ARRAY[]::UUID[])
    INTO v_unlocked_locations
    FROM public.locations 
    WHERE unlock_requirements = '{}'::JSONB;
    
    -- Chapters with empty requirements
    SELECT COALESCE(ARRAY_AGG(id ORDER BY display_order), ARRAY[]::UUID[])
    INTO v_unlocked_chapters
    FROM public.story_chapters 
    WHERE unlock_requirements = '{}'::JSONB;
    
    -- Events with empty requirements
    SELECT COALESCE(ARRAY_AGG(id ORDER BY display_order), ARRAY[]::UUID[])
    INTO v_unlocked_events
    FROM public.story_events 
    WHERE unlock_requirements = '{}'::JSONB;
    
    -- Insert new user progress with comprehensive initialization (FIX: Proper data types)
    INSERT INTO public.user_progress (
        user_id,
        
        -- Current state
        current_chapter_id,
        current_location_id,
        current_event_id,
        
        -- Player progression
        player_level,
        player_experience,
        
        -- Game content - UNLOCKED (FIX: Convert UUID arrays to JSONB)
        unlocked_world_maps,
        unlocked_locations,
        unlocked_chapters,
        unlocked_events,
        
        -- Completed content (empty for new user)
        completed_chapters,
        completed_events,
        
        -- Player inventory and equipment
        inventory,
        
        -- Party members
        party_members,
        
        -- Character relationships
        character_relationships,
        
        -- Player position
        player_position,
        
        -- Achievements (empty for new user)
        achievements,
        
        -- Play history (empty for new user)
        play_history,
        
        -- Active content
        active_quests,
        game_flags,
        
        -- Game statistics and save data
        game_stats,
        game_settings,
        save_data,
        
        -- Timestamps
        last_played_at,
        created_at,
        updated_at
    ) VALUES (
        p_user_uuid,
        
        -- Current state
        v_chapter_1_id,                    -- Start with Chapter 1: The Darkspawn
        v_heros_house_location_id,        -- Start at Hero's House
        v_morning_at_home_event_id,       -- Start with Morning at Home event
        
        -- Player progression
        1,                                 -- Level 1
        0,                                 -- 0 experience
        
        -- Game content - UNLOCKED (FIX: Convert UUID arrays to JSONB)
        to_jsonb(v_unlocked_world_maps),  -- World Maps as JSONB array
        to_jsonb(v_unlocked_locations),   -- Locations as JSONB array
        to_jsonb(v_unlocked_chapters),    -- Chapters as JSONB array
        to_jsonb(v_unlocked_events),      -- Events as JSONB array
        
        -- Completed content (empty for new user)
        '[]'::JSONB,                      -- No completed chapters (JSONB format)
        '[]'::JSONB,                      -- No completed events (JSONB format)
        
        -- Player inventory and equipment
        ARRAY[
            jsonb_build_object(
                'item_id', v_rusty_sword_item_id,
                'quantity', 1,
                'obtained_at', NOW(),
                'equipped', true,
                'slot', 'weapon'
            )
        ]::JSONB[],
        
        -- Party members
        ARRAY[
            jsonb_build_object(
                'character_id', v_hero_character_id,
                'joined_at', NOW(),
                'current_stats', jsonb_build_object(
                    'hp', 100,
                    'mp', 50,
                    'level', 1,
                    'attack', 15,
                    'defense', 10
                ),
                'equipment', jsonb_build_object(
                    'weapon', v_rusty_sword_item_id
                ),
                'is_active', true,
                'party_position', 1
            )
        ]::JSONB[],
        
        -- Character relationships
        jsonb_build_object(
            'grandpa', 50,                -- Good relationship with Grandpa
            'erik', 0,                    -- Haven't met Erik yet
            'king_carnelian', 0           -- Haven't met King yet
        ),
        
        -- Player position
        jsonb_build_object(
            'x', 100,
            'y', 200,
            'map_id', v_heros_house_location_id
        ),
        
        -- Achievements (empty for new user)
        ARRAY[]::JSONB[],
        
        -- Play history (empty for new user)
        ARRAY[]::JSONB[],
        
        -- Active content
        '[]'::JSONB,                      -- No active quests initially (JSONB format)
        jsonb_build_object(
            'tutorial_completed', false,
            'met_grandpa', false,
            'ceremony_started', false,
            'game_started', true
        ),
        
        -- Game statistics and save data
        jsonb_build_object(
            'play_time', 0,
            'interactions_completed', 0,
            'events_completed', 0,
            'chapters_completed', 0,
            'completion_percentage', 0.0,
            'last_save_time', NOW()
        ),
        jsonb_build_object(
            'sound_volume', 0.8,
            'music_volume', 0.6,
            'difficulty', 'normal',
            'language', 'th',
            'text_speed', 'normal'
        ),
        jsonb_build_object(
            'last_checkpoint', 'game_start',
            'auto_save_enabled', true
        ),
        
        -- Timestamps
        NOW(),                            -- last_played_at
        NOW(),                            -- created_at
        NOW()                             -- updated_at
    );
    
    -- Get the complete user progress record
    SELECT * INTO v_progress_record FROM public.user_progress WHERE user_id = p_user_uuid;
    
    -- Return all columns as JSONB object
    RETURN to_jsonb(v_progress_record);
EXCEPTION
    WHEN OTHERS THEN
        -- Log error and re-raise
        RAISE EXCEPTION 'Failed to initialize user progress for user %: %', p_user_uuid, SQLERRM;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


-- =============================================================================
-- Function to get user game state with comprehensive data
-- =============================================================================
CREATE OR REPLACE FUNCTION public.get_user_game_state_for_user_progress(p_user_progress_uuid UUID)
RETURNS JSONB
LANGUAGE sql
AS $$
    SELECT to_jsonb(game_state)
    FROM (
        SELECT 
            up.id,
            up.user_id,
            up.current_chapter_id,
            COALESCE(sc.title, 'Unknown Chapter') as current_chapter_title,
            up.current_location_id,
            COALESCE(sl.name, 'Unknown Location') as current_location_name,
            up.current_event_id,
            COALESCE(se.title, 'Unknown Event') as current_event_title,
            up.player_level,
            up.player_experience,
            up.unlocked_world_maps,
            up.unlocked_locations,
            up.unlocked_chapters,
            up.unlocked_events,
            up.completed_chapters,
            up.completed_events,
            up.inventory,
            up.party_members,
            up.character_relationships,
            up.player_position,
            up.game_flags,
            up.game_stats,
            up.last_played_at
        FROM public.user_progress up
        LEFT JOIN public.story_chapters sc ON up.current_chapter_id = sc.id
        LEFT JOIN public.locations sl ON up.current_location_id = sl.id
        LEFT JOIN public.story_events se ON up.current_event_id = se.id
        WHERE up.id = p_user_progress_uuid
    ) AS game_state;
$$;

-- =============================================================================
-- Function to get available events for a user_progress
-- =============================================================================
CREATE OR REPLACE FUNCTION public.get_available_events_for_user_progress(p_user_progress_uuid UUID)
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
    LEFT JOIN public.user_progress up ON up.id = p_user_progress_uuid
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

-- =============================================================================
-- Function to get completed events for a user_progress
-- =============================================================================
CREATE OR REPLACE FUNCTION public.get_completed_events_for_user_progress(p_user_progress_uuid UUID)
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
    LEFT JOIN public.user_progress up ON up.id = p_user_progress_uuid
    WHERE 
        -- Event must be unlocked by user (in unlocked_events array)
        up.unlocked_events IS NOT NULL
        AND se.id = ANY((SELECT jsonb_array_elements_text(up.unlocked_events))::UUID[])
        -- Event must be completed
        AND (
            up.completed_events IS NOT NULL 
            AND se.id = ANY((SELECT jsonb_array_elements_text(up.completed_events))::UUID[])
        )
    GROUP BY se.id, se.title, se.description, se.event_type, sc.title, l.name
    ORDER BY se.display_order;
END;
$$;

-- =============================================================================
-- Function to complete an interaction and update user progress
-- =============================================================================
CREATE OR REPLACE FUNCTION public.complete_interaction_for_user_progress(
    p_user_progress_uuid UUID,
    p_interaction_uuid UUID,
    p_choice_data JSONB DEFAULT '{}'::JSONB
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
    WHERE id = p_interaction_uuid;
    
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
    WHERE id = p_user_progress_uuid;
    
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
    WHERE interaction_id = p_interaction_uuid
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
            p_interaction_uuid,
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
        AND id != p_interaction_uuid
        AND display_order = (SELECT display_order FROM public.event_interactions WHERE id = p_interaction_uuid) + 1
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
            WHERE id = p_user_progress_uuid;
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
            WHERE id = p_user_progress_uuid;
        END IF;
        
        -- Handle location unlocks
        IF outcome_record.effects ? 'unlock_locations' THEN
            UPDATE public.user_progress
            SET unlocked_locations = unlocked_locations || outcome_record.effects->'unlock_locations'
            WHERE id = p_user_progress_uuid;
        END IF;
        
        -- Handle chapter unlocks
        IF outcome_record.effects ? 'unlock_chapters' THEN
            UPDATE public.user_progress
            SET unlocked_chapters = unlocked_chapters || outcome_record.effects->'unlock_chapters'
            WHERE id = p_user_progress_uuid;
        END IF;
        
        -- Handle event unlocks
        IF outcome_record.effects ? 'unlock_events' THEN
            UPDATE public.user_progress
            SET unlocked_events = unlocked_events || outcome_record.effects->'unlock_events'
            WHERE id = p_user_progress_uuid;
        END IF;
    END IF;
    
    -- Mark event as completed if this was the final interaction
    IF NOT EXISTS (
        SELECT 1 FROM public.event_interactions ei
        WHERE ei.event_id = event_record.id
        AND ei.id != p_interaction_uuid
        AND ei.is_available = true
    ) THEN
        -- Add event to completed events
        UPDATE public.user_progress
        SET 
            completed_events = completed_events || jsonb_build_array(event_record.id),
            last_played_at = NOW()
        WHERE id = p_user_progress_uuid;
        
        -- Note: We don't update story_events.is_completed anymore
        -- Event completion is tracked in user_progress.completed_events only
    END IF;
    
    -- Build result
    result := jsonb_build_object(
        'success', true,
        'transaction_id', transaction_id,
        'interaction_id', p_interaction_uuid,
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


-- =============================================================================
-- Function to get world map with unlock status for user_progress
-- =============================================================================
CREATE OR REPLACE FUNCTION public.get_world_map_for_user_progress(p_user_progress_uuid UUID)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    RETURN jsonb_build_object(
        'unlocked_world_maps', 
        (SELECT unlocked_world_maps FROM public.user_progress WHERE id = p_user_progress_uuid),
        'unlocked_locations', 
        (SELECT unlocked_locations FROM public.user_progress WHERE id = p_user_progress_uuid)
    );
END;
$$;

-- =============================================================================
-- Function to get event interactions for user_progress
-- =============================================================================
CREATE OR REPLACE FUNCTION public.get_event_interactions_for_user_progress(
    p_user_progress_uuid UUID,
    p_event_uuid UUID
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
    WHERE se.id = p_event_uuid;
    
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
    WHERE ei.event_id = p_event_uuid
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
