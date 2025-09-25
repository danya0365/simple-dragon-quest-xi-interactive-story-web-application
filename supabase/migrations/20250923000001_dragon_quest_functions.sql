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
-- Function to get world map with unlock status for user_progress
-- Uses hash map approach with CTEs and joins for better performance
-- =============================================================================
CREATE OR REPLACE FUNCTION public.get_world_regions_for_user_progress(p_user_progress_uuid UUID)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_unlocked_world_maps UUID[];
    v_unlocked_locations UUID[];
BEGIN
    -- Get unlocked world regions and locations from user progress
    SELECT unlocked_world_regions, unlocked_locations 
    INTO v_unlocked_world_maps, v_unlocked_locations
    FROM public.user_progress 
    WHERE id = p_user_progress_uuid;
    
    -- Return comprehensive world map structure using hash map approach
    RETURN (
        WITH unlocked_world_regions_data AS (
            SELECT 
                wr.id,
                wr.name,
                wr.description,
                wr.image_url,
                wr.unlock_requirements,
                wr.display_order,
                wr.is_initial_user_progress
            FROM public.world_regions wr
            WHERE wr.id = ANY(v_unlocked_world_maps)
            ORDER BY wr.display_order, wr.name
        ),
        unlocked_locations_data AS (
            SELECT 
                loc.id,
                loc.world_map_id,
                loc.name,
                loc.description,
                loc.image_url,
                loc.location_type,
                loc.unlock_requirements,
                loc.display_order,
                loc.is_initial_user_progress
            FROM public.locations loc
            WHERE loc.id = ANY(v_unlocked_locations)
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
                        'is_initial_user_progress', loc.is_initial_user_progress
                    )
                ), '[]'::jsonb) as locations
            FROM unlocked_locations_data loc
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
                'locations', COALESCE(lbr.locations, '[]'::jsonb)
            )
        ), '[]'::jsonb)
        FROM unlocked_world_regions_data wr
        LEFT JOIN locations_by_world_region lbr ON wr.id = lbr.world_region_id
    );
END;
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
            wr.is_initial_user_progress
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
            loc.is_initial_user_progress
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
                    'is_initial_user_progress', loc.is_initial_user_progress
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
        AND (se.location_id IS NULL OR se.location_id = upd.current_location_id)
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
-- Function to complete interaction for user progress (FIXED VERSION WITH AUTO UNLOCK)
-- Handles choice processing, effects application, state updates, and auto location/region unlock
-- =============================================================================
CREATE OR REPLACE FUNCTION public.complete_interaction_for_user_progress(
    p_user_progress_uuid UUID,
    p_interaction_uuid UUID,
    p_choice_data JSONB DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_user_progress RECORD;
    v_interaction RECORD;
    v_outcome RECORD;
    v_choice_key TEXT;
    v_effects JSONB;
    v_updated_progress JSONB;
    v_next_event_id UUID;
    v_success BOOLEAN DEFAULT true;
    v_error_message TEXT;
    v_all_interactions_completed BOOLEAN DEFAULT false;
    v_total_interactions INTEGER;
    v_completed_interactions INTEGER;
    v_current_unlocked_events JSONB;
    v_current_unlocked_locations JSONB;
    v_current_unlocked_regions JSONB;
    v_new_events_to_unlock JSONB;
    v_auto_unlock_locations JSONB DEFAULT '[]'::jsonb;
    v_auto_unlock_regions JSONB DEFAULT '[]'::jsonb;
    v_event_record RECORD;
BEGIN
    -- Get user progress data
    SELECT * INTO v_user_progress 
    FROM public.user_progress 
    WHERE id = p_user_progress_uuid;
    
    IF v_user_progress IS NULL THEN
        v_success := false;
        v_error_message := 'User progress not found';
        RETURN jsonb_build_object('success', v_success, 'error', v_error_message);
    END IF;
    
    -- Get interaction data
    SELECT * INTO v_interaction
    FROM public.event_interactions
    WHERE id = p_interaction_uuid;
    
    IF v_interaction IS NULL THEN
        v_success := false;
        v_error_message := 'Interaction not found';
        RETURN jsonb_build_object('success', v_success, 'error', v_error_message);
    END IF;
    
    -- Determine choice key (either from choice_data or default)
    IF p_choice_data IS NOT NULL AND p_choice_data->>'choice_id' IS NOT NULL THEN
        v_choice_key := p_choice_data->>'choice_id';
    ELSE
        v_choice_key := 'default';
    END IF;
    
    -- Get outcome for this choice
    SELECT * INTO v_outcome
    FROM public.event_outcomes
    WHERE interaction_id = p_interaction_uuid
    AND (choice_key = v_choice_key OR choice_key IS NULL);
    
    IF v_outcome IS NULL THEN
        v_success := false;
        v_error_message := 'Outcome not found for choice: ' || v_choice_key;
        RETURN jsonb_build_object('success', v_success, 'error', v_error_message);
    END IF;
    
    -- Extract effects from the outcome
    IF v_outcome.effects IS NOT NULL THEN
        v_effects := v_outcome.effects;
    ELSE
        v_effects := '{}'::jsonb;
    END IF;
    
    -- Get next event ID if available
    IF v_outcome.next_event_id IS NOT NULL THEN
        v_next_event_id := v_outcome.next_event_id;
    END IF;
    
    -- DEBUG: Log effects and next_event_id
    RAISE NOTICE 'DEBUG: Effects: %', v_effects;
    RAISE NOTICE 'DEBUG: Next event ID: %', v_next_event_id;
    
    -- Check if all interactions in this event are completed
    -- Get total number of interactions for this event
    SELECT COUNT(*) INTO v_total_interactions
    FROM public.event_interactions
    WHERE event_id = v_interaction.event_id;
    
    -- Get number of completed interactions for this event
    SELECT COUNT(*) INTO v_completed_interactions
    FROM jsonb_array_elements(v_user_progress.completed_interactions) AS completed_interaction
    WHERE completed_interaction->>'event_id' = v_interaction.event_id::TEXT;
    
    -- DEBUG: Log interaction counts
    RAISE NOTICE 'DEBUG: Event ID: %', v_interaction.event_id;
    RAISE NOTICE 'DEBUG: Total interactions: %', v_total_interactions;
    RAISE NOTICE 'DEBUG: Completed interactions (before current): %', v_completed_interactions;
    
    -- Check if all interactions are completed (including the current one)
    v_all_interactions_completed := (v_completed_interactions + 1) >= v_total_interactions;
    
    -- DEBUG: Log completion result
    RAISE NOTICE 'DEBUG: All interactions completed: %', v_all_interactions_completed;
    
    -- Store current unlocked content before update
    v_current_unlocked_events := COALESCE(v_user_progress.unlocked_events, '[]'::jsonb);
    v_current_unlocked_locations := COALESCE(v_user_progress.unlocked_locations, '[]'::jsonb);
    v_current_unlocked_regions := COALESCE(v_user_progress.unlocked_world_regions, '[]'::jsonb);
    
    -- Get new events to unlock from effects
    v_new_events_to_unlock := COALESCE(v_effects->'unlock_events', '[]'::jsonb);
    
    -- AUTO-UNLOCK LOGIC: For each new event, find its location and world region
    IF jsonb_typeof(v_new_events_to_unlock) = 'array' AND jsonb_array_length(v_new_events_to_unlock) > 0 THEN
        FOR v_event_record IN 
            SELECT 
                se.id as event_id,
                se.location_id,
                l.world_region_id
            FROM jsonb_array_elements_text(v_new_events_to_unlock) AS event_uuid_text
            JOIN public.story_events se ON se.id = event_uuid_text::uuid
            LEFT JOIN public.locations l ON l.id = se.location_id
        LOOP
            -- Auto-unlock location if event has a location
            IF v_event_record.location_id IS NOT NULL THEN
                -- Check if location is not already unlocked
                IF NOT (v_current_unlocked_locations @> to_jsonb(v_event_record.location_id::text)) THEN
                    v_auto_unlock_locations := v_auto_unlock_locations || to_jsonb(v_event_record.location_id::text);
                    RAISE NOTICE 'DEBUG: Auto-unlocking location: %', v_event_record.location_id;
                END IF;
            END IF;
            
            -- Auto-unlock world region if location has a world region
            IF v_event_record.world_region_id IS NOT NULL THEN
                -- Check if world region is not already unlocked
                IF NOT (v_current_unlocked_regions @> to_jsonb(v_event_record.world_region_id::text)) THEN
                    v_auto_unlock_regions := v_auto_unlock_regions || to_jsonb(v_event_record.world_region_id::text);
                    RAISE NOTICE 'DEBUG: Auto-unlocking world region: %', v_event_record.world_region_id;
                END IF;
            END IF;
        END LOOP;
    END IF;
    
    -- Update user progress with effects and auto-unlocks
    UPDATE public.user_progress
    SET 
        -- Track completed interactions
        completed_interactions = completed_interactions || 
            jsonb_build_array(
                jsonb_build_object(
                    'interaction_id', p_interaction_uuid,
                    'event_id', v_interaction.event_id,
                    'completed_at', NOW()
                )
            ),
        
        -- Update unlocked content with proper null handling and array deduplication
        unlocked_world_regions = CASE 
            -- Merge manual unlocks from effects AND auto-unlocks
            WHEN (v_effects->'unlock_regions' IS NOT NULL AND jsonb_typeof(v_effects->'unlock_regions') = 'array' AND jsonb_array_length(v_effects->'unlock_regions') > 0)
                 OR jsonb_array_length(v_auto_unlock_regions) > 0
            THEN (
                SELECT jsonb_agg(DISTINCT value) 
                FROM (
                    SELECT value FROM jsonb_array_elements(COALESCE(unlocked_world_regions, '[]'::jsonb))
                    UNION
                    SELECT value FROM jsonb_array_elements(COALESCE(v_effects->'unlock_regions', '[]'::jsonb))
                    UNION
                    SELECT value FROM jsonb_array_elements(v_auto_unlock_regions)
                ) t
            )
            ELSE unlocked_world_regions 
        END,
        
        unlocked_locations = CASE 
            -- Merge manual unlocks from effects AND auto-unlocks
            WHEN (v_effects->'unlock_locations' IS NOT NULL AND jsonb_typeof(v_effects->'unlock_locations') = 'array' AND jsonb_array_length(v_effects->'unlock_locations') > 0)
                 OR jsonb_array_length(v_auto_unlock_locations) > 0
            THEN (
                SELECT jsonb_agg(DISTINCT value) 
                FROM (
                    SELECT value FROM jsonb_array_elements(COALESCE(unlocked_locations, '[]'::jsonb))
                    UNION
                    SELECT value FROM jsonb_array_elements(COALESCE(v_effects->'unlock_locations', '[]'::jsonb))
                    UNION
                    SELECT value FROM jsonb_array_elements(v_auto_unlock_locations)
                ) t
            )
            ELSE unlocked_locations 
        END,
        
        unlocked_chapters = CASE 
            WHEN v_effects->'unlock_chapters' IS NOT NULL AND jsonb_typeof(v_effects->'unlock_chapters') = 'array' AND jsonb_array_length(v_effects->'unlock_chapters') > 0
            THEN (
                SELECT jsonb_agg(DISTINCT value) 
                FROM (
                    SELECT value FROM jsonb_array_elements(COALESCE(unlocked_chapters, '[]'::jsonb))
                    UNION
                    SELECT value FROM jsonb_array_elements(v_effects->'unlock_chapters')
                ) t
            )
            ELSE unlocked_chapters 
        END,
        
        unlocked_events = CASE 
            WHEN v_effects->'unlock_events' IS NOT NULL AND jsonb_typeof(v_effects->'unlock_events') = 'array' AND jsonb_array_length(v_effects->'unlock_events') > 0
            THEN (
                SELECT jsonb_agg(DISTINCT value) 
                FROM (
                    SELECT value FROM jsonb_array_elements(v_current_unlocked_events)
                    UNION
                    SELECT value FROM jsonb_array_elements(v_effects->'unlock_events')
                ) t
            )
            ELSE unlocked_events -- Keep existing value if no new events to unlock
        END,
        
        -- Update completed events ONLY when ALL interactions are completed
        completed_events = CASE 
            -- Mark event as completed ONLY when ALL interactions in the event are completed
            WHEN v_all_interactions_completed
            THEN (
                SELECT jsonb_agg(DISTINCT value) 
                FROM (
                    SELECT value FROM jsonb_array_elements(COALESCE(completed_events, '[]'::jsonb))
                    UNION
                    SELECT to_jsonb(v_interaction.event_id::text)
                ) t
            )
            ELSE completed_events -- Keep existing completed_events unchanged
        END,
        
        -- Update character relationships with proper merging
        character_relationships = CASE 
            WHEN v_effects->'relationship' IS NOT NULL 
            THEN character_relationships || v_effects->'relationship'
            ELSE character_relationships 
        END,
        
        -- Update inventory with proper item handling
        inventory = CASE 
            WHEN v_effects->'items' IS NOT NULL AND jsonb_typeof(v_effects->'items') = 'array' AND jsonb_array_length(v_effects->'items') > 0
            THEN (
                inventory || (
                    SELECT jsonb_agg(
                        jsonb_build_object(
                            'item_id', (item->>'id')::UUID,
                            'quantity', (item->>'quantity')::INTEGER,
                            'obtained_at', NOW(),
                            'equipped', false,
                            'slot', NULL
                        )
                    )
                    FROM jsonb_array_elements(v_effects->'items') item
                )
            )
            ELSE inventory 
        END,
        
        -- Update party members
        party_members = CASE 
            WHEN v_effects->'party_join' IS NOT NULL 
            THEN (
                party_members || jsonb_build_array(
                    jsonb_build_object(
                        'character_id', (v_effects->>'party_join')::UUID,
                        'joined_at', NOW(),
                        'current_stats', (SELECT stats FROM public.characters WHERE id = (v_effects->>'party_join')::UUID),
                        'equipment', '{}'::jsonb,
                        'is_active', true,
                        'party_position', COALESCE(jsonb_array_length(party_members), 0) + 1
                    )
                )
            )
            ELSE party_members 
        END,
        
        -- Update game stats
        game_stats = jsonb_set(
            game_stats,
            ARRAY['interactions_completed'],
            to_jsonb(COALESCE((game_stats->>'interactions_completed')::INTEGER, 0) + 1)
        ),
        
        -- Update current event if there's a next event
        current_event_id = COALESCE(v_next_event_id, current_event_id),
        
        -- Update timestamps
        updated_at = NOW(),
        last_played_at = NOW()
    WHERE id = p_user_progress_uuid;
    
    -- Return success response with auto-unlock information
    RETURN jsonb_build_object(
        'success', v_success,
        'next_event_id', v_next_event_id,
        'effects', v_effects,
        'choice_key', v_choice_key,
        'auto_unlocked_locations', v_auto_unlock_locations,
        'auto_unlocked_regions', v_auto_unlock_regions
    );
    
EXCEPTION
    WHEN OTHERS THEN
        v_success := false;
        v_error_message := 'Failed to complete interaction: ' || SQLERRM;
        RETURN jsonb_build_object('success', v_success, 'error', v_error_message);
END;
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