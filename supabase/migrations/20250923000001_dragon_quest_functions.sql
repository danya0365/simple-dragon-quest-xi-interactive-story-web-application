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
        se.is_unlocked = true 
        AND se.is_completed = false
        AND (
            up.completed_events IS NULL 
            OR NOT (se.id::text = ANY(SELECT jsonb_array_elements_text(up.completed_events)))
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
BEGIN
    -- Get interaction details
    SELECT * INTO interaction_record
    FROM public.event_interactions
    WHERE id = interaction_uuid;
    
    IF NOT FOUND THEN
        RETURN jsonb_build_object('success', false, 'error', 'Interaction not found');
    END IF;
    
    -- Get event details
    SELECT * INTO event_record
    FROM public.story_events
    WHERE id = interaction_record.event_id;
    
    -- Get or create user progress
    SELECT * INTO user_progress_record
    FROM public.user_progress
    WHERE user_id = user_uuid;
    
    IF NOT FOUND THEN
        INSERT INTO public.user_progress (user_id, completed_events, unlocked_locations, unlocked_chapters)
        VALUES (user_uuid, '[]'::JSONB, '[]'::JSONB, '[]'::JSONB)
        RETURNING * INTO user_progress_record;
    END IF;
    
    -- Find matching outcome based on choice
    SELECT * INTO outcome_record
    FROM public.event_outcomes
    WHERE interaction_id = interaction_uuid
    AND (
        choice_data->>'choice_id' IS NULL 
        OR choice_id = choice_data->>'choice_id'
        OR choice_id IS NULL
    )
    LIMIT 1;
    
    -- Process outcome effects
    IF outcome_record.effects IS NOT NULL THEN
        -- Handle party member joining
        IF outcome_record.effects ? 'party_join' THEN
            INSERT INTO public.user_party_members (user_id, character_id, party_position)
            SELECT 
                user_uuid,
                (outcome_record.effects->>'party_join')::UUID,
                COALESCE(
                    (SELECT MAX(party_position) + 1 FROM public.user_party_members WHERE user_id = user_uuid),
                    1
                )
            ON CONFLICT (user_id, character_id) DO NOTHING;
        END IF;
        
        -- Handle item rewards
        IF outcome_record.effects ? 'items' THEN
            INSERT INTO public.user_inventory (user_id, item_id, quantity)
            SELECT 
                user_uuid,
                (item->>'id')::UUID,
                COALESCE((item->>'quantity')::INTEGER, 1)
            FROM jsonb_array_elements(outcome_record.effects->'items') as item
            ON CONFLICT (user_id, item_id) 
            DO UPDATE SET quantity = public.user_inventory.quantity + EXCLUDED.quantity;
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
            completed_events = completed_events || jsonb_build_array(event_record.id::text),
            last_played_at = NOW()
        WHERE user_id = user_uuid;
        
        -- Mark event as completed
        UPDATE public.story_events
        SET is_completed = true
        WHERE id = event_record.id;
    END IF;
    
    -- Build result
    result := jsonb_build_object(
        'success', true,
        'interaction_id', interaction_uuid,
        'event_id', event_record.id,
        'outcome', row_to_json(outcome_record),
        'next_event_id', outcome_record.next_event_id
    );
    
    RETURN result;
END;
$$;

-- Function to get user's current game state
CREATE OR REPLACE FUNCTION public.get_user_game_state(user_uuid UUID)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    progress_record RECORD;
    party_members JSONB;
    inventory JSONB;
    result JSONB;
BEGIN
    -- Get user progress
    SELECT * INTO progress_record
    FROM public.user_progress
    WHERE user_id = user_uuid;
    
    -- Get party members with character details
    SELECT jsonb_agg(
        jsonb_build_object(
            'character_id', upm.character_id,
            'name', c.name,
            'description', c.description,
            'avatar_url', c.avatar_url,
            'current_stats', upm.current_stats,
            'equipment', upm.equipment,
            'party_position', upm.party_position,
            'joined_at', upm.joined_at
        ) ORDER BY upm.party_position
    ) INTO party_members
    FROM public.user_party_members upm
    JOIN public.characters c ON upm.character_id = c.id
    WHERE upm.user_id = user_uuid AND upm.is_active = true;
    
    -- Get inventory with item details
    SELECT jsonb_agg(
        jsonb_build_object(
            'item_id', ui.item_id,
            'name', i.name,
            'description', i.description,
            'item_type', i.item_type,
            'rarity', i.rarity,
            'image_url', i.image_url,
            'quantity', ui.quantity,
            'obtained_at', ui.obtained_at
        )
    ) INTO inventory
    FROM public.user_inventory ui
    JOIN public.items i ON ui.item_id = i.id
    WHERE ui.user_id = user_uuid;
    
    -- Build result
    result := jsonb_build_object(
        'user_id', user_uuid,
        'current_chapter_id', progress_record.current_chapter_id,
        'current_location_id', progress_record.current_location_id,
        'completed_events', COALESCE(progress_record.completed_events, '[]'::JSONB),
        'unlocked_locations', COALESCE(progress_record.unlocked_locations, '[]'::JSONB),
        'unlocked_chapters', COALESCE(progress_record.unlocked_chapters, '[]'::JSONB),
        'game_stats', COALESCE(progress_record.game_stats, '{}'::JSONB),
        'party_members', COALESCE(party_members, '[]'::JSONB),
        'inventory', COALESCE(inventory, '[]'::JSONB),
        'last_played_at', progress_record.last_played_at
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
    protagonist_id UUID;
BEGIN
    -- Get first chapter and location
    SELECT id INTO first_chapter_id
    FROM public.story_chapters
    WHERE chapter_number = 1
    LIMIT 1;
    
    SELECT id INTO first_location_id
    FROM public.locations
    WHERE display_order = 1
    LIMIT 1;
    
    -- Get protagonist character
    SELECT id INTO protagonist_id
    FROM public.characters
    WHERE character_type = 'party_member' AND name ILIKE '%hero%' OR name ILIKE '%protagonist%'
    LIMIT 1;
    
    -- Create user progress
    INSERT INTO public.user_progress (
        user_id,
        current_chapter_id,
        current_location_id,
        completed_events,
        unlocked_locations,
        unlocked_chapters,
        game_stats
    ) VALUES (
        user_uuid,
        first_chapter_id,
        first_location_id,
        '[]'::JSONB,
        jsonb_build_array(first_location_id::text),
        jsonb_build_array(first_chapter_id::text),
        jsonb_build_object('play_time', 0, 'completion_percentage', 0)
    ) ON CONFLICT (user_id) DO NOTHING;
    
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
            up.unlocked_locations IS NULL 
            OR wm.id::text = ANY(SELECT jsonb_array_elements_text(up.unlocked_locations))
        ) as is_unlocked,
        COUNT(l.id) as locations_count,
        COUNT(CASE 
            WHEN up.unlocked_locations IS NOT NULL 
            AND l.id::text = ANY(SELECT jsonb_array_elements_text(up.unlocked_locations))
            THEN 1 
        END) as unlocked_locations_count
    FROM public.world_map wm
    LEFT JOIN public.locations l ON wm.id = l.world_map_id
    LEFT JOIN public.user_progress up ON up.user_id = user_uuid
    GROUP BY wm.id, wm.name, wm.description, wm.image_url, up.unlocked_locations
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
            'character_speaker', c.name,
            'character_avatar', c.avatar_url,
            'choices', (
                SELECT jsonb_agg(
                    jsonb_build_object(
                        'id', eo.id,
                        'text', eo.choice_text,
                        'type', eo.outcome_type,
                        'description', eo.description
                    )
                )
                FROM public.event_outcomes eo
                WHERE eo.interaction_id = ei.id
                ORDER BY eo.choice_order
            )
        ) ORDER BY ei.interaction_order
    ) INTO interactions
    FROM public.event_interactions ei
    LEFT JOIN public.characters c ON ei.character_id = c.id
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
