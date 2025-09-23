-- Fix: Improve complete_interaction function to handle interactions without outcomes
-- This provides a fallback mechanism for interactions that don't have explicit outcomes

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
    
    -- Check if interaction has choices
    has_choices := (interaction_record.choices IS NOT NULL AND 
                   interaction_record.choices != '[]'::JSONB AND 
                   jsonb_array_length(interaction_record.choices) > 0);
    
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
        
        -- Handle event unlocks
        IF outcome_record.effects ? 'unlock_events' THEN
            UPDATE public.story_events
            SET is_unlocked = true
            WHERE id = ANY((SELECT array_agg(elem::UUID) FROM jsonb_array_elements_text(outcome_record.effects->'unlock_events') as elem))
            AND id NOT IN (SELECT unnest(completed_events::UUID[]) FROM public.user_progress WHERE user_id = user_uuid);
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
