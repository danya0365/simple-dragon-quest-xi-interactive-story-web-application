-- =============================================================================
-- Function to complete interaction for user progress (REFACTORED WITH DEBUG & RETURN NEW VALUES)
-- Handles choice processing, effects application, state updates, auto location/region unlock, and auto next event progression
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
    v_current_unlocked_chapters JSONB;
    v_current_completed_events JSONB;
    v_new_events_to_unlock JSONB;
    v_auto_unlock_locations JSONB DEFAULT '[]'::jsonb;
    v_auto_unlock_regions JSONB DEFAULT '[]'::jsonb;
    v_auto_unlock_chapters JSONB DEFAULT '[]'::jsonb;
    v_event_record RECORD;
    v_outcome_found BOOLEAN DEFAULT false;
    v_experience_gain INTEGER DEFAULT 0;
    v_current_chapter_id UUID;
    v_current_display_order INTEGER;
    v_next_event_in_chapter UUID;
    v_next_chapter_id UUID;
    v_first_event_in_next_chapter UUID;
    
    -- New variables for calculated values
    v_new_completed_interactions JSONB;
    v_new_unlocked_regions JSONB;
    v_new_unlocked_locations JSONB;
    v_new_unlocked_chapters JSONB;
    v_new_unlocked_events JSONB;
    v_new_completed_events JSONB;
    v_new_player_experience INTEGER;
    v_new_character_relationships JSONB;
    v_new_inventory JSONB;
    v_new_party_members JSONB;
    v_new_game_stats JSONB;
    v_new_current_event_id UUID;
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
    IF p_choice_data IS NOT NULL AND p_choice_data->>'choice_key' IS NOT NULL THEN
        v_choice_key := p_choice_data->>'choice_key';
    ELSE
        v_choice_key := 'default';
    END IF;
    
    -- Try to get outcome for this choice (may not exist)
    SELECT * INTO v_outcome
    FROM public.event_outcomes
    WHERE interaction_id = p_interaction_uuid
    AND choice_key = v_choice_key;

    -- Check if outcome was found using FOUND variable (more reliable)
    v_outcome_found := FOUND;
    
    -- Initialize default values if outcome not found
    IF NOT v_outcome_found THEN
        v_effects := '{}'::jsonb;
        v_next_event_id := NULL;
        RAISE NOTICE 'DEBUG: No outcome found for interaction %, continuing without outcome effects', p_interaction_uuid;
    ELSE
        -- Extract effects from the outcome
        v_effects := COALESCE(v_outcome.effects, '{}'::jsonb);
        
        -- Get next event ID if available
        v_next_event_id := v_outcome.next_event_id;
        
        -- Get experience gain if available
        IF v_effects->'experience' IS NOT NULL THEN
            v_experience_gain := (v_effects->>'experience')::INTEGER;
        END IF;
    END IF;
    
    -- DEBUG: Log effects and next_event_id
    RAISE NOTICE 'DEBUG: Outcome found: %', v_outcome_found;
    RAISE NOTICE 'DEBUG: Effects: %', v_effects;
    RAISE NOTICE 'DEBUG: Next event ID from outcome: %', v_next_event_id;
    RAISE NOTICE 'DEBUG: Experience gain: %', v_experience_gain;
    
    -- Check if all interactions in this event are completed
    SELECT COUNT(*) INTO v_total_interactions
    FROM public.event_interactions
    WHERE event_id = v_interaction.event_id;
    
    SELECT COUNT(*) INTO v_completed_interactions
    FROM jsonb_array_elements(v_user_progress.completed_interactions) AS completed_interaction
    WHERE completed_interaction->>'event_id' = v_interaction.event_id::TEXT;
    
    RAISE NOTICE 'DEBUG: Event ID: %', v_interaction.event_id;
    RAISE NOTICE 'DEBUG: Total interactions: %', v_total_interactions;
    RAISE NOTICE 'DEBUG: Completed interactions (before current): %', v_completed_interactions;
    
    v_all_interactions_completed := (v_completed_interactions + 1) >= v_total_interactions;
    
    RAISE NOTICE 'DEBUG: All interactions completed: %', v_all_interactions_completed;
    
    -- Store current unlocked content before update
    v_current_unlocked_events := COALESCE(v_user_progress.unlocked_events, '[]'::jsonb);
    v_current_unlocked_locations := COALESCE(v_user_progress.unlocked_locations, '[]'::jsonb);
    v_current_unlocked_regions := COALESCE(v_user_progress.unlocked_world_regions, '[]'::jsonb);
    v_current_unlocked_chapters := COALESCE(v_user_progress.unlocked_chapters, '[]'::jsonb);
    v_current_completed_events := COALESCE(v_user_progress.completed_events, '[]'::jsonb);
    
    -- Prepare events to unlock: combine from effects AND next_event_id
    v_new_events_to_unlock := COALESCE(v_effects->'unlock_events', '[]'::jsonb);
    
    -- Add next_event_id to events to unlock if it exists from outcome
    IF v_next_event_id IS NOT NULL THEN
        v_new_events_to_unlock := v_new_events_to_unlock || to_jsonb(v_next_event_id::text);
        RAISE NOTICE 'DEBUG: Adding next_event_id from outcome to unlock: %', v_next_event_id;
    END IF;
    
    -- =============================================================================
    -- CALCULATE NEW VALUES (before UPDATE)
    -- =============================================================================

    -- Calculate new completed_events
    v_new_completed_events := CASE 
        WHEN v_all_interactions_completed
        THEN (
            SELECT jsonb_agg(DISTINCT value) 
            FROM (
                SELECT value FROM jsonb_array_elements(COALESCE(v_user_progress.completed_events, '[]'::jsonb))
                UNION
                SELECT to_jsonb(v_interaction.event_id::text)
            ) t
        )
        ELSE v_user_progress.completed_events
    END;

    -- =============================================================================
    -- AUTO NEXT EVENT PROGRESSION LOGIC
    -- =============================================================================
    IF v_all_interactions_completed AND v_next_event_id IS NULL THEN
    
        RAISE NOTICE 'DEBUG: All interactions completed AND next_event_id is NULL - finding next event automatically';
        RAISE NOTICE 'DEBUG: Current event_id: %', v_interaction.event_id;
        
        -- Get current event's chapter and display order
        SELECT chapter_id, display_order 
        INTO v_current_chapter_id, v_current_display_order
        FROM public.story_events
        WHERE id = v_interaction.event_id;
        
        RAISE NOTICE 'DEBUG: Current event chapter_id: %, display_order: %', 
            v_current_chapter_id, v_current_display_order;
        
        -- Try to find next event in same chapter
        SELECT id INTO v_next_event_in_chapter
        FROM public.story_events
        WHERE chapter_id = v_current_chapter_id
        AND display_order > v_current_display_order
        ORDER BY display_order ASC
        LIMIT 1;
        
        IF v_next_event_in_chapter IS NOT NULL THEN
            -- มี event ถัดไปใน chapter เดียวกัน
            v_next_event_id := v_next_event_in_chapter;
            RAISE NOTICE 'DEBUG: Found next event in same chapter: %', v_next_event_id;
            
        ELSE
            -- ไม่มี event ถัดไปใน chapter เดียวกัน -> หา chapter ถัดไป
            RAISE NOTICE 'DEBUG: No more events in current chapter, looking for next chapter';
            
            SELECT id INTO v_next_chapter_id
            FROM public.story_chapters
            WHERE display_order > (
                SELECT display_order 
                FROM public.story_chapters 
                WHERE id = v_current_chapter_id
            )
            ORDER BY display_order ASC
            LIMIT 1;
            
            IF v_next_chapter_id IS NOT NULL THEN
                RAISE NOTICE 'DEBUG: Found next chapter: %', v_next_chapter_id;
                
                -- หา event แรกใน chapter ถัดไป
                SELECT id INTO v_first_event_in_next_chapter
                FROM public.story_events
                WHERE chapter_id = v_next_chapter_id
                ORDER BY display_order ASC
                LIMIT 1;
                
                IF v_first_event_in_next_chapter IS NOT NULL THEN
                    v_next_event_id := v_first_event_in_next_chapter;
                    RAISE NOTICE 'DEBUG: Found first event in next chapter: %', v_next_event_id;
                    
                    -- 🔥 ปลดล็อก chapter ใหม่
                    IF NOT (v_current_unlocked_chapters @> to_jsonb(v_next_chapter_id::text)) THEN
                        v_auto_unlock_chapters := v_auto_unlock_chapters || to_jsonb(v_next_chapter_id::text);
                        RAISE NOTICE 'DEBUG: Auto-unlocking next chapter: %', v_next_chapter_id;
                    END IF;
                ELSE
                    RAISE NOTICE 'DEBUG: Next chapter has no events';
                END IF;
            ELSE
                RAISE NOTICE 'DEBUG: No more chapters available - story completed!';
            END IF;
        END IF;
        
        -- 🔥 เพิ่ม next_event_id เข้า unlock list
        IF v_next_event_id IS NOT NULL THEN
            IF NOT (v_current_unlocked_events @> to_jsonb(v_next_event_id::text)) THEN
                IF NOT (v_new_events_to_unlock @> to_jsonb(v_next_event_id::text)) THEN
                    v_new_events_to_unlock := v_new_events_to_unlock || to_jsonb(v_next_event_id::text);
                    RAISE NOTICE 'DEBUG: Auto-unlocking next event: %', v_next_event_id;
                END IF;
            END IF;
        END IF;
        
    END IF;
    
    -- =============================================================================
    -- AUTO-UNLOCK LOGIC
    -- =============================================================================
    IF jsonb_typeof(v_new_events_to_unlock) = 'array' AND jsonb_array_length(v_new_events_to_unlock) > 0 THEN
        FOR v_event_record IN 
            SELECT 
                se.id as event_id,
                se.location_id,
                se.chapter_id,
                l.world_region_id
            FROM jsonb_array_elements_text(v_new_events_to_unlock) AS event_uuid_text
            JOIN public.story_events se ON se.id = event_uuid_text::uuid
            LEFT JOIN public.locations l ON l.id = se.location_id
        LOOP
            IF v_event_record.location_id IS NOT NULL THEN
                IF NOT (v_current_unlocked_locations @> to_jsonb(v_event_record.location_id::text)) THEN
                    v_auto_unlock_locations := v_auto_unlock_locations || to_jsonb(v_event_record.location_id::text);
                    RAISE NOTICE 'DEBUG: Auto-unlocking location: %', v_event_record.location_id;
                END IF;
            END IF;
            
            IF v_event_record.world_region_id IS NOT NULL THEN
                IF NOT (v_current_unlocked_regions @> to_jsonb(v_event_record.world_region_id::text)) THEN
                    v_auto_unlock_regions := v_auto_unlock_regions || to_jsonb(v_event_record.world_region_id::text);
                    RAISE NOTICE 'DEBUG: Auto-unlocking world region: %', v_event_record.world_region_id;
                END IF;
            END IF;
            
            IF v_event_record.chapter_id IS NOT NULL THEN
                IF NOT (v_current_unlocked_chapters @> to_jsonb(v_event_record.chapter_id::text)) THEN
                    v_auto_unlock_chapters := v_auto_unlock_chapters || to_jsonb(v_event_record.chapter_id::text);
                    RAISE NOTICE 'DEBUG: Auto-unlocking chapter: %', v_event_record.chapter_id;
                END IF;
            END IF;
        END LOOP;
    END IF;
    
    
    -- Calculate new completed_interactions
    v_new_completed_interactions := v_user_progress.completed_interactions || 
        jsonb_build_array(
            jsonb_build_object(
                'interaction_id', p_interaction_uuid,
                'event_id', v_interaction.event_id,
                'choice_key', v_choice_key,
                'completed_at', NOW()
            )
        );
    
    -- Calculate new unlocked_world_regions
    v_new_unlocked_regions := CASE 
        WHEN (v_effects->'unlock_regions' IS NOT NULL AND jsonb_typeof(v_effects->'unlock_regions') = 'array' AND jsonb_array_length(v_effects->'unlock_regions') > 0)
             OR jsonb_array_length(v_auto_unlock_regions) > 0
        THEN (
            SELECT jsonb_agg(DISTINCT value) 
            FROM (
                SELECT value FROM jsonb_array_elements(COALESCE(v_user_progress.unlocked_world_regions, '[]'::jsonb))
                UNION
                SELECT value FROM jsonb_array_elements(COALESCE(v_effects->'unlock_regions', '[]'::jsonb))
                UNION
                SELECT value FROM jsonb_array_elements(v_auto_unlock_regions)
            ) t
        )
        ELSE v_user_progress.unlocked_world_regions 
    END;
    
    -- Calculate new unlocked_locations
    v_new_unlocked_locations := CASE 
        WHEN (v_effects->'unlock_locations' IS NOT NULL AND jsonb_typeof(v_effects->'unlock_locations') = 'array' AND jsonb_array_length(v_effects->'unlock_locations') > 0)
             OR jsonb_array_length(v_auto_unlock_locations) > 0
        THEN (
            SELECT jsonb_agg(DISTINCT value) 
            FROM (
                SELECT value FROM jsonb_array_elements(COALESCE(v_user_progress.unlocked_locations, '[]'::jsonb))
                UNION
                SELECT value FROM jsonb_array_elements(COALESCE(v_effects->'unlock_locations', '[]'::jsonb))
                UNION
                SELECT value FROM jsonb_array_elements(v_auto_unlock_locations)
            ) t
        )
        ELSE v_user_progress.unlocked_locations 
    END;
    
    -- Calculate new unlocked_chapters
    v_new_unlocked_chapters := CASE 
        WHEN (v_effects->'unlock_chapters' IS NOT NULL AND jsonb_typeof(v_effects->'unlock_chapters') = 'array' AND jsonb_array_length(v_effects->'unlock_chapters') > 0)
             OR jsonb_array_length(v_auto_unlock_chapters) > 0
        THEN (
            SELECT jsonb_agg(DISTINCT value) 
            FROM (
                SELECT value FROM jsonb_array_elements(COALESCE(v_user_progress.unlocked_chapters, '[]'::jsonb))
                UNION
                SELECT value FROM jsonb_array_elements(COALESCE(v_effects->'unlock_chapters', '[]'::jsonb))
                UNION
                SELECT value FROM jsonb_array_elements(v_auto_unlock_chapters)
            ) t
        )
        ELSE v_user_progress.unlocked_chapters 
    END;
    
    -- Calculate new unlocked_events
    v_new_unlocked_events := CASE 
        WHEN jsonb_array_length(v_new_events_to_unlock) > 0
        THEN (
            SELECT jsonb_agg(DISTINCT value) 
            FROM (
                SELECT value FROM jsonb_array_elements(v_current_unlocked_events)
                UNION
                SELECT value FROM jsonb_array_elements(v_new_events_to_unlock)
            ) t
        )
        ELSE v_user_progress.unlocked_events
    END;
    
    -- Calculate new player_experience
    v_new_player_experience := CASE
        WHEN v_experience_gain > 0
        THEN COALESCE(v_user_progress.player_experience, 0) + v_experience_gain
        ELSE v_user_progress.player_experience
    END;
    
    -- Calculate new character_relationships
    v_new_character_relationships := CASE 
        WHEN v_effects->'relationship' IS NOT NULL 
        THEN v_user_progress.character_relationships || v_effects->'relationship'
        ELSE v_user_progress.character_relationships 
    END;
    
    -- Calculate new inventory
    v_new_inventory := CASE 
        WHEN v_effects->'items' IS NOT NULL AND jsonb_typeof(v_effects->'items') = 'array' AND jsonb_array_length(v_effects->'items') > 0
        THEN (
            v_user_progress.inventory || (
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
        ELSE v_user_progress.inventory 
    END;
    
    -- Calculate new party_members
    v_new_party_members := CASE 
        WHEN v_effects->'party_join' IS NOT NULL 
        THEN (
            v_user_progress.party_members || jsonb_build_array(
                jsonb_build_object(
                    'character_id', (v_effects->>'party_join')::UUID,
                    'joined_at', NOW(),
                    'current_stats', (SELECT stats FROM public.characters WHERE id = (v_effects->>'party_join')::UUID),
                    'equipment', '{}'::jsonb,
                    'is_active', true,
                    'party_position', COALESCE(jsonb_array_length(v_user_progress.party_members), 0) + 1
                )
            )
        )
        ELSE v_user_progress.party_members 
    END;
    
    -- Calculate new game_stats
    v_new_game_stats := jsonb_set(
        v_user_progress.game_stats,
        ARRAY['interactions_completed'],
        to_jsonb(COALESCE((v_user_progress.game_stats->>'interactions_completed')::INTEGER, 0) + 1)
    );
    
    -- Calculate new current_event_id
    v_new_current_event_id := CASE
        WHEN v_next_event_id IS NOT NULL THEN v_next_event_id
        ELSE v_user_progress.current_event_id
    END;
    
    -- =============================================================================
    -- DEBUG NEW VALUES BEFORE UPDATE
    -- =============================================================================
    RAISE NOTICE 'DEBUG NEW VALUES BEFORE UPDATE:';
    RAISE NOTICE '  - new_completed_interactions count: %', jsonb_array_length(v_new_completed_interactions);
    RAISE NOTICE '  - new_unlocked_regions: %', v_new_unlocked_regions;
    RAISE NOTICE '  - new_unlocked_locations: %', v_new_unlocked_locations;
    RAISE NOTICE '  - new_unlocked_chapters: %', v_new_unlocked_chapters;
    RAISE NOTICE '  - new_unlocked_events: %', v_new_unlocked_events;
    RAISE NOTICE '  - new_completed_events: %', v_new_completed_events;
    RAISE NOTICE '  - new_player_experience: %', v_new_player_experience;
    RAISE NOTICE '  - new_character_relationships: %', v_new_character_relationships;
    RAISE NOTICE '  - new_inventory count: %', jsonb_array_length(v_new_inventory);
    RAISE NOTICE '  - new_party_members count: %', jsonb_array_length(v_new_party_members);
    RAISE NOTICE '  - new_game_stats: %', v_new_game_stats;
    RAISE NOTICE '  - new_current_event_id: %', v_new_current_event_id;
    
    -- =============================================================================
    -- UPDATE USER PROGRESS
    -- =============================================================================
    UPDATE public.user_progress
    SET 
        completed_interactions = v_new_completed_interactions,
        unlocked_world_regions = v_new_unlocked_regions,
        unlocked_locations = v_new_unlocked_locations,
        unlocked_chapters = v_new_unlocked_chapters,
        unlocked_events = v_new_unlocked_events,
        completed_events = v_new_completed_events,
        player_experience = v_new_player_experience,
        character_relationships = v_new_character_relationships,
        inventory = v_new_inventory,
        party_members = v_new_party_members,
        game_stats = v_new_game_stats,
        current_event_id = v_new_current_event_id,
        updated_at = NOW(),
        last_played_at = NOW()
    WHERE id = p_user_progress_uuid;
    
    -- =============================================================================
    -- RETURN SUCCESS RESPONSE WITH USER PROGRESS UPDATE
    -- =============================================================================
    RETURN jsonb_build_object(
        'success', v_success,
        'outcome_found', v_outcome_found,
        'next_event_id', v_next_event_id,
        'effects', v_effects,
        'choice_key', v_choice_key,
        'experience_gained', v_experience_gain,
        'auto_unlocked_locations', v_auto_unlock_locations,
        'auto_unlocked_regions', v_auto_unlock_regions,
        'auto_unlocked_chapters', v_auto_unlock_chapters,
        'unlocked_events', v_new_events_to_unlock,
        'all_interactions_completed', v_all_interactions_completed,
        'user_progress_update', jsonb_build_object(
            'completed_interactions', v_new_completed_interactions,
            'unlocked_world_regions', v_new_unlocked_regions,
            'unlocked_locations', v_new_unlocked_locations,
            'unlocked_chapters', v_new_unlocked_chapters,
            'unlocked_events', v_new_unlocked_events,
            'completed_events', v_new_completed_events,
            'player_experience', v_new_player_experience,
            'character_relationships', v_new_character_relationships,
            'inventory', v_new_inventory,
            'party_members', v_new_party_members,
            'game_stats', v_new_game_stats,
            'current_event_id', v_new_current_event_id
        ),
        'event_outcome', CASE 
            WHEN v_outcome_found THEN jsonb_build_object(
                'id', v_outcome.id,
                'interaction_id', v_outcome.interaction_id,
                'choice_key', v_outcome.choice_key,
                'title', v_outcome.title,
                'description', v_outcome.description,
                'outcome_type', v_outcome.outcome_type,
                'effects', v_outcome.effects,
                'next_event_id', v_outcome.next_event_id
            )
            ELSE NULL
        END
    );
    
EXCEPTION
    WHEN OTHERS THEN
        v_success := false;
        v_error_message := 'Failed to complete interaction: ' || SQLERRM;
        RETURN jsonb_build_object('success', v_success, 'error', v_error_message);
END;
$$;

-- =============================================================================
-- Function to get event outcome for a specific interaction and choice
-- Returns the event outcome data from public.event_outcomes table
-- =============================================================================
CREATE OR REPLACE FUNCTION public.get_event_outcome(
    p_interaction_uuid UUID,
    p_choice_data JSONB DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_interaction RECORD;
    v_outcome RECORD;
    v_choice_key TEXT;
    v_success BOOLEAN DEFAULT true;
    v_error_message TEXT;
    v_outcome_found BOOLEAN DEFAULT false;
    -- DEBUG variables
    v_debug_info JSONB;
    v_all_outcomes INTEGER;
    v_available_choice_keys TEXT[];
    v_specific_outcome_exists BOOLEAN;
    v_specific_outcome_id UUID;
BEGIN
    -- DEBUG: Initialize debug information
    v_debug_info := jsonb_build_object(
        'input_interaction_uuid', p_interaction_uuid,
        'input_choice_data', p_choice_data
    );
    
    -- Get interaction data to validate it exists
    SELECT * INTO v_interaction
    FROM public.event_interactions
    WHERE id = p_interaction_uuid;
    
    IF v_interaction IS NULL THEN
        v_success := false;
        v_error_message := 'Interaction not found';
        v_debug_info := v_debug_info || jsonb_build_object(
            'interaction_found', false,
            'error', v_error_message
        );
        RETURN jsonb_build_object('success', v_success, 'error', v_error_message, 'debug_info', v_debug_info);
    END IF;
    
    -- DEBUG: Store interaction found info
    v_debug_info := v_debug_info || jsonb_build_object(
        'interaction_found', true,
        'interaction_id', v_interaction.id
    );
    
    -- Determine choice key (either from choice_data or default)
    IF p_choice_data IS NOT NULL AND p_choice_data->>'choice_key' IS NOT NULL THEN
        v_choice_key := p_choice_data->>'choice_key';
    ELSE
        v_choice_key := 'default';
    END IF;
    
    -- DEBUG: Store choice key info
    v_debug_info := v_debug_info || jsonb_build_object(
        'determined_choice_key', v_choice_key
    );
    
    -- DEBUG: Check what outcomes exist for this interaction
    SELECT COUNT(*) INTO v_all_outcomes
    FROM public.event_outcomes
    WHERE interaction_id = p_interaction_uuid;
    
    -- DEBUG: Get all available choice_keys for this interaction
    SELECT ARRAY_AGG(DISTINCT choice_key) INTO v_available_choice_keys
    FROM public.event_outcomes
    WHERE interaction_id = p_interaction_uuid;
    
    -- DEBUG: Check if the specific outcome we're looking for actually exists
    SELECT EXISTS(
        SELECT 1 FROM public.event_outcomes
        WHERE interaction_id = p_interaction_uuid
        AND choice_key = v_choice_key
    ) INTO v_specific_outcome_exists;
    
    SELECT id INTO v_specific_outcome_id
    FROM public.event_outcomes
    WHERE interaction_id = p_interaction_uuid
    AND choice_key = v_choice_key
    LIMIT 1;
    
    v_debug_info := v_debug_info || jsonb_build_object(
        'specific_outcome_exists_in_table', v_specific_outcome_exists,
        'specific_outcome_id_from_direct_query', v_specific_outcome_id
    );
    
    -- DEBUG: Store outcomes info
    v_debug_info := v_debug_info || jsonb_build_object(
        'total_outcomes_for_interaction', v_all_outcomes,
        'available_choice_keys', v_available_choice_keys
    );
    
    -- Get outcome for this interaction and choice
    SELECT * INTO v_outcome
    FROM public.event_outcomes
    WHERE interaction_id = p_interaction_uuid
    AND choice_key = v_choice_key;
    
    -- DEBUG: Check v_outcome IMMEDIATELY after query
    v_debug_info := v_debug_info || jsonb_build_object(
        'v_outcome_immediately_after_query', CASE 
            WHEN v_outcome IS NULL THEN 'NULL'
            ELSE 'NOT_NULL'
        END
    );
    
    -- Check if outcome was found using FOUND variable (more reliable)
    v_outcome_found := FOUND;
    
    -- DEBUG: Store v_outcome_found immediately after check
    v_debug_info := v_debug_info || jsonb_build_object(
        'v_outcome_found_immediately_after_check', v_outcome_found,
        'found_variable_value', FOUND
    );
    
    -- DEBUG: Store query result info
    IF v_outcome IS NULL THEN
        v_debug_info := v_debug_info || jsonb_build_object(
            'outcome_found_by_query', false,
            'query_details', jsonb_build_object(
                'interaction_id', p_interaction_uuid,
                'choice_key_used', v_choice_key
            )
        );
    ELSE
        v_debug_info := v_debug_info || jsonb_build_object(
            'outcome_found_by_query', true,
            'found_outcome_id', v_outcome.id,
            'found_outcome_choice_key', v_outcome.choice_key
        );
    END IF;
    
    -- DEBUG: Check v_outcome AGAIN before final return
    v_debug_info := v_debug_info || jsonb_build_object(
        'v_outcome_before_final_return', CASE 
            WHEN v_outcome IS NULL THEN 'NULL'
            ELSE 'NOT_NULL'
        END
    );
    
    -- DEBUG: Also store the final v_outcome_found value
    v_debug_info := v_debug_info || jsonb_build_object(
        'final_outcome_found_value', v_outcome_found
    );
    
    -- Return the outcome data or null if not found
    RETURN jsonb_build_object(
        'success', v_success,
        'outcome_found', v_outcome_found,
        'interaction_id', p_interaction_uuid,
        'choice_key', v_choice_key,
        'event_outcome', CASE 
            WHEN v_outcome_found THEN jsonb_build_object(
                'id', v_outcome.id,
                'interaction_id', v_outcome.interaction_id,
                'choice_key', v_outcome.choice_key,
                'title', v_outcome.title,
                'description', v_outcome.description,
                'outcome_type', v_outcome.outcome_type,
                'effects', v_outcome.effects,
                'next_event_id', v_outcome.next_event_id
            )
            ELSE NULL
        END,
        'debug_info', v_debug_info
    );
    
EXCEPTION
    WHEN OTHERS THEN
        v_success := false;
        v_error_message := 'Failed to get event outcome: ' || SQLERRM;
        RETURN jsonb_build_object('success', v_success, 'error', v_error_message);
END;
$$;