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
    ORDER BY display_order
    LIMIT 1;
    
    -- Rusty sword item (initial equipment)
    SELECT id INTO v_rusty_sword_item_id
    FROM public.items 
    WHERE is_initial_user_progress = true
    ORDER BY display_order
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
    -- World Maps with initial user progress flag
    SELECT COALESCE(ARRAY_AGG(id ORDER BY display_order), ARRAY[]::UUID[])
    INTO v_unlocked_world_maps
    FROM public.world_map 
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