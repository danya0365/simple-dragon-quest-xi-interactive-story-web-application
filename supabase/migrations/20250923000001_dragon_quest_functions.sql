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
    
    -- Get default content from database with is_initial_user_progress = true (SIMPLIFIED: Use is_initial_user_progress flag)
    -- Hero character (initial party member)
    SELECT id INTO v_hero_character_id
    FROM public.characters 
    WHERE is_initial_user_progress = true
    ORDER BY created_at
    LIMIT 1;
    
    -- Rusty sword item (initial equipment)
    SELECT id INTO v_rusty_sword_item_id
    FROM public.items 
    WHERE is_initial_user_progress = true
    ORDER BY created_at
    LIMIT 1;
    
    -- Chapter 1 (initial chapter)
    SELECT id INTO v_chapter_1_id
    FROM public.story_chapters 
    WHERE is_initial_user_progress = true
    ORDER BY display_order
    LIMIT 1;
    
    -- Morning at home event (initial event)
    SELECT id INTO v_morning_at_home_event_id
    FROM public.story_events 
    WHERE is_initial_user_progress = true
    ORDER BY display_order
    LIMIT 1;
    
    -- Hero's house location (initial location)
    SELECT id INTO v_heros_house_location_id
    FROM public.locations 
    WHERE is_initial_user_progress = true
    ORDER BY display_order
    LIMIT 1;
    
    -- Get unlocked content from each table separately (SIMPLIFIED: Use is_initial_user_progress flag)
    -- World Regions with initial user progress flag
    SELECT COALESCE(ARRAY_AGG(id ORDER BY display_order), ARRAY[]::UUID[])
    INTO v_unlocked_world_maps
    FROM public.world_regions 
    WHERE is_initial_user_progress = true;
    
    -- Locations with initial user progress flag
    SELECT COALESCE(ARRAY_AGG(id ORDER BY display_order), ARRAY[]::UUID[])
    INTO v_unlocked_locations
    FROM public.locations 
    WHERE is_initial_user_progress = true;
    
    -- Chapters with initial user progress flag
    SELECT COALESCE(ARRAY_AGG(id ORDER BY display_order), ARRAY[]::UUID[])
    INTO v_unlocked_chapters
    FROM public.story_chapters 
    WHERE is_initial_user_progress = true;
    
    -- Events with initial user progress flag
    SELECT COALESCE(ARRAY_AGG(id ORDER BY display_order), ARRAY[]::UUID[])
    INTO v_unlocked_events
    FROM public.story_events 
    WHERE is_initial_user_progress = true;
    
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
        unlocked_world_regions,
        unlocked_locations,
        unlocked_chapters,
        unlocked_events,
        
        -- Completed content (empty for new user)
        completed_chapters,
        completed_events,
        completed_interactions,
        
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
        to_jsonb(v_unlocked_world_maps),  -- World Regions as JSONB array
        to_jsonb(v_unlocked_locations),   -- Locations as JSONB array
        to_jsonb(v_unlocked_chapters),    -- Chapters as JSONB array
        to_jsonb(v_unlocked_events),      -- Events as JSONB array
        
        -- Completed content (empty for new user)
        '[]'::JSONB,                      -- No completed chapters (JSONB format)
        '[]'::JSONB,                      -- No completed events (JSONB format)
        '[]'::JSONB,                      -- No completed interactions (JSONB format)
        
        -- Player inventory and equipment
        to_jsonb(ARRAY[
            jsonb_build_object(
                'item_id', v_rusty_sword_item_id,
                'quantity', 1,
                'obtained_at', NOW(),
                'equipped', true,
                'slot', 'weapon'
            )
        ]),
        
        -- Party members
        to_jsonb(ARRAY[
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
        ]),
        
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
        to_jsonb(ARRAY[]::TEXT[]),
        
        -- Play history (empty for new user)
        to_jsonb(ARRAY[]::TEXT[]),
        
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
            up.unlocked_world_regions,
            up.unlocked_locations,
            up.unlocked_chapters,
            up.unlocked_events,
            up.completed_chapters,
            up.completed_events,
            up.completed_interactions,
            up.inventory,
            up.party_members,
            up.character_relationships,
            up.player_position,
            up.achievements,
            up.play_history,
            up.active_quests,
            up.game_flags,
            up.game_stats,
            up.game_settings,
            up.save_data,
            up.last_played_at,
            up.created_at,
            up.updated_at
        FROM public.user_progress up
        LEFT JOIN public.story_chapters sc ON up.current_chapter_id = sc.id
        LEFT JOIN public.locations sl ON up.current_location_id = sl.id
        LEFT JOIN public.story_events se ON up.current_event_id = se.id
        WHERE up.id = p_user_progress_uuid
    ) AS game_state;
$$;


-- =============================================================================
-- Function to get all world regions with all locations (no user progress filtering)
-- Uses hash map approach with joins and jsonb_object_agg for better performance
-- =============================================================================
CREATE OR REPLACE FUNCTION public.get_world_regions()
RETURNS JSONB
LANGUAGE sql
SECURITY DEFINER
AS $$
    WITH world_regions_data AS (
        SELECT 
            wr.id,
            wr.name,
            wr.description,
            wr.image_url,
            wr.unlock_requirements,
            wr.display_order,
            wr.is_initial_user_progress,
            wr.is_alway_hide_until_unlock
        FROM public.world_regions wr
        ORDER BY wr.display_order, wr.name
    ),
    locations_data AS (
        SELECT 
            loc.id,
            loc.world_region_id,
            loc.name,
            loc.description,
            loc.image_url,
            loc.location_type,
            loc.unlock_requirements,
            loc.display_order,
            loc.is_initial_user_progress,
            loc.is_alway_hide_until_unlock
        FROM public.locations loc
        ORDER BY loc.display_order, loc.name
    ),
    locations_by_world_region AS (
        SELECT 
            loc.world_region_id,
            COALESCE(jsonb_agg(
                jsonb_build_object(
                    'id', loc.id,
                    'world_region_id', loc.world_region_id,
                    'name', loc.name,
                    'description', loc.description,
                    'image_url', loc.image_url,
                    'location_type', loc.location_type,
                    'unlock_requirements', loc.unlock_requirements,
                    'display_order', loc.display_order,
                    'is_initial_user_progress', loc.is_initial_user_progress,
                    'is_alway_hide_until_unlock', loc.is_alway_hide_until_unlock
                )
            ), '[]'::jsonb) as locations
        FROM locations_data loc
        GROUP BY loc.world_region_id
    )
    SELECT COALESCE(jsonb_agg(
        jsonb_build_object(
            'id', wr.id,
            'name', wr.name,
            'description', wr.description,
            'image_url', wr.image_url,
            'unlock_requirements', wr.unlock_requirements,
            'display_order', wr.display_order,
            'is_initial_user_progress', wr.is_initial_user_progress,
            'is_alway_hide_until_unlock', wr.is_alway_hide_until_unlock,
            'locations', COALESCE(lbr.locations, '[]'::jsonb)
        )
    ), '[]'::jsonb)
    FROM world_regions_data wr
    LEFT JOIN locations_by_world_region lbr ON wr.id = lbr.world_region_id;
$$;

-- =============================================================================
-- Function to get available events for user progress
-- Returns events that are unlocked but not completed
-- =============================================================================
CREATE OR REPLACE FUNCTION public.get_available_events_for_user_progress(p_user_progress_uuid UUID)
RETURNS JSONB
LANGUAGE sql
SECURITY DEFINER
AS $$
    WITH user_progress_data AS (
        SELECT 
            unlocked_events,
            completed_events,
            current_location_id
        FROM public.user_progress 
        WHERE id = p_user_progress_uuid
    ),
    available_events AS (
        SELECT 
            se.id as event_id,
            se.title as event_title,
            se.description as event_description,
            se.event_type,
            sc.title as chapter_title,
            sl.name as location_name,
            COUNT(ei.id) as interactions_count
        FROM public.story_events se
        JOIN public.story_chapters sc ON se.chapter_id = sc.id
        LEFT JOIN public.locations sl ON se.location_id = sl.id
        LEFT JOIN public.event_interactions ei ON se.id = ei.event_id
        JOIN user_progress_data upd ON se.id = ANY(SELECT jsonb_array_elements_text(upd.unlocked_events)::UUID)
        WHERE NOT se.id = ANY(SELECT jsonb_array_elements_text(upd.completed_events)::UUID)
        GROUP BY se.id, se.title, se.description, se.event_type, sc.title, sl.name
        ORDER BY se.display_order, se.title
    )
    SELECT COALESCE(jsonb_agg(
        jsonb_build_object(
            'event_id', ae.event_id,
            'event_title', ae.event_title,
            'event_description', ae.event_description,
            'event_type', ae.event_type,
            'chapter_title', ae.chapter_title,
            'location_name', ae.location_name,
            'interactions_count', ae.interactions_count
        )
    ), '[]'::jsonb)
    FROM available_events ae;
$$;

-- =============================================================================
-- Function to get completed events for user progress
-- Returns events that have been completed by the user
-- =============================================================================
CREATE OR REPLACE FUNCTION public.get_completed_events_for_user_progress(p_user_progress_uuid UUID)
RETURNS JSONB
LANGUAGE sql
SECURITY DEFINER
AS $$
    WITH user_progress_data AS (
        SELECT 
            unlocked_events,
            completed_events,
            current_location_id
        FROM public.user_progress 
        WHERE id = p_user_progress_uuid
    ),
    completed_events AS (
        SELECT 
            se.id as event_id,
            se.title as event_title,
            se.description as event_description,
            se.event_type,
            sc.title as chapter_title,
            sl.name as location_name,
            COUNT(ei.id) as interactions_count
        FROM public.story_events se
        JOIN public.story_chapters sc ON se.chapter_id = sc.id
        LEFT JOIN public.locations sl ON se.location_id = sl.id
        LEFT JOIN public.event_interactions ei ON se.id = ei.event_id
        JOIN user_progress_data upd ON se.id = ANY(SELECT jsonb_array_elements_text(upd.completed_events)::UUID)
        GROUP BY se.id, se.title, se.description, se.event_type, sc.title, sl.name
        ORDER BY se.display_order, se.title
    )
    SELECT COALESCE(jsonb_agg(
        jsonb_build_object(
            'event_id', ce.event_id,
            'event_title', ce.event_title,
            'event_description', ce.event_description,
            'event_type', ce.event_type,
            'chapter_title', ce.chapter_title,
            'location_name', ce.location_name,
            'interactions_count', ce.interactions_count
        )
    ), '[]'::jsonb)
    FROM completed_events ce;
$$;

-- =============================================================================
-- Function to get available events for a specific location
-- Returns events that are unlocked but not completed for a specific location
-- =============================================================================
CREATE OR REPLACE FUNCTION public.get_available_events_for_location(p_user_progress_uuid UUID, p_location_uuid UUID)
RETURNS JSONB
LANGUAGE sql
SECURITY DEFINER
AS $$
    WITH user_progress_data AS (
        SELECT 
            unlocked_events,
            completed_events
        FROM public.user_progress 
        WHERE id = p_user_progress_uuid
    ),
    available_events AS (
        SELECT 
            se.id as event_id,
            se.title as event_title,
            se.description as event_description,
            se.event_type,
            sc.title as chapter_title,
            sl.name as location_name,
            COUNT(ei.id) as interactions_count
        FROM public.story_events se
        JOIN public.story_chapters sc ON se.chapter_id = sc.id
        LEFT JOIN public.locations sl ON se.location_id = sl.id
        LEFT JOIN public.event_interactions ei ON se.id = ei.event_id
        JOIN user_progress_data upd ON se.id = ANY(SELECT jsonb_array_elements_text(upd.unlocked_events)::UUID)
        WHERE NOT se.id = ANY(SELECT jsonb_array_elements_text(upd.completed_events)::UUID)
        AND se.location_id = p_location_uuid
        GROUP BY se.id, se.title, se.description, se.event_type, sc.title, sl.name
        ORDER BY se.display_order, se.title
    )
    SELECT COALESCE(jsonb_agg(
        jsonb_build_object(
            'event_id', ae.event_id,
            'event_title', ae.event_title,
            'event_description', ae.event_description,
            'event_type', ae.event_type,
            'chapter_title', ae.chapter_title,
            'location_name', ae.location_name,
            'interactions_count', ae.interactions_count
        )
    ), '[]'::jsonb)
    FROM available_events ae;
$$;

-- =============================================================================
-- Function to get event interactions for user progress
-- Returns all interactions for a specific event with availability status
-- =============================================================================
CREATE OR REPLACE FUNCTION public.get_event_interactions_for_user_progress(p_user_progress_uuid UUID, p_event_uuid UUID)
RETURNS JSONB
LANGUAGE sql
SECURITY DEFINER
AS $$
    WITH user_progress_data AS (
        SELECT 
            game_flags,
            character_relationships,
            inventory,
            player_level
        FROM public.user_progress 
        WHERE id = p_user_progress_uuid
    ),
    event_interactions_data AS (
        SELECT 
            ei.id,
            ei.interaction_type,
            ei.title,
            ei.description,
            ei.dialogue_text,
            ei.character_speaker,
            ei.choices,
            ei.requirements,
            ei.is_available,
            ei.display_order
        FROM public.event_interactions ei
        WHERE ei.event_id = p_event_uuid
        ORDER BY ei.display_order, ei.title
    )
    SELECT COALESCE(jsonb_agg(
        jsonb_build_object(
            'id', eid.id,
            'interaction_type', eid.interaction_type,
            'title', eid.title,
            'description', eid.description,
            'dialogue_text', eid.dialogue_text,
            'character_speaker', eid.character_speaker,
            'choices', eid.choices,
            'requirements', eid.requirements,
            'is_available', eid.is_available,
            'display_order', eid.display_order
        )
    ), '[]'::jsonb)
    FROM event_interactions_data eid;
$$;

-- =============================================================================
-- Function to get all items from items table
-- =============================================================================
CREATE OR REPLACE FUNCTION public.get_all_items()
RETURNS JSONB
LANGUAGE sql
SECURITY DEFINER
AS $$
    SELECT COALESCE(
        (SELECT JSONB_AGG(
            JSONB_BUILD_OBJECT(
                'id', id,
                'name', name,
                'description', description,
                'item_type', item_type,
                'rarity', rarity,
                'image_url', image_url
            )
        )
        FROM public.items
        ),
        '[]'::JSONB
    ) AS items;
$$;

-- =============================================================================
-- Function to get all characters from characters table
-- =============================================================================
CREATE OR REPLACE FUNCTION public.get_all_characters()
RETURNS JSONB
LANGUAGE sql
SECURITY DEFINER
AS $$
    SELECT COALESCE(
        (SELECT JSONB_AGG(
            JSONB_BUILD_OBJECT(
                'id', id,
                'name', name,
                'description', description,
                'character_type', character_type,
                'avatar_url', avatar_url,
                'stats', stats,
                'abilities', abilities,
                'join_requirements', join_requirements,
                'is_joinable', is_joinable
            )
        )
        FROM public.characters
        ),
        '[]'::JSONB
    ) AS characters;
$$;

-- =============================================================================
-- Delete user progress function
-- =============================================================================

CREATE OR REPLACE FUNCTION public.delete_user_progress(p_user_uuid UUID)
RETURNS JSONB AS $$
DECLARE
    v_deleted_records INTEGER;
    v_success BOOLEAN := true;
    v_error_message TEXT;
BEGIN
    -- Check if user is authenticated and trying to delete their own progress
    IF auth.uid() IS NULL THEN
        RAISE EXCEPTION 'Authentication required';
    END IF;
    
    IF auth.uid() != p_user_uuid THEN
        RAISE EXCEPTION 'You can only delete your own progress';
    END IF;
    
    -- Delete user progress record
    DELETE FROM public.user_progress 
    WHERE user_id = p_user_uuid;
    
    GET DIAGNOSTICS v_deleted_records = ROW_COUNT;
    
    -- Return success response
    RETURN jsonb_build_object(
        'success', v_success,
        'deleted_records', v_deleted_records,
        'message', 'User progress deleted successfully'
    );
    
EXCEPTION
    WHEN OTHERS THEN
        v_success := false;
        v_error_message := 'Failed to delete user progress: ' || SQLERRM;
        RETURN jsonb_build_object('success', v_success, 'error', v_error_message);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
