-- Validation functions for seed data integrity
-- These functions help prevent data integrity issues in the future

-- Function to validate interactions and their outcomes
CREATE OR REPLACE FUNCTION public.validate_interactions_outcomes()
RETURNS TABLE(
    interaction_id UUID,
    interaction_title TEXT,
    has_choices BOOLEAN,
    has_outcomes BOOLEAN,
    has_default_outcome BOOLEAN,
    outcome_count INTEGER,
    is_valid BOOLEAN,
    issues TEXT[]
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    interaction_rec RECORD;
    choice_count INTEGER;
    outcome_count INTEGER;
    default_outcome_count INTEGER;
    issues_array TEXT[];
BEGIN
    FOR interaction_rec IN SELECT id, title, choices FROM public.event_interactions
    LOOP
        -- Check if interaction has choices
        choice_count := CASE 
            WHEN interaction_rec.choices IS NULL OR interaction_rec.choices = '[]'::JSONB 
            THEN 0 
            ELSE jsonb_array_length(interaction_rec.choices) 
        END;
        
        -- Count outcomes for this interaction
        SELECT COUNT(*) INTO outcome_count
        FROM public.event_outcomes
        WHERE interaction_id = interaction_rec.id;
        
        -- Count default outcomes for this interaction
        SELECT COUNT(*) INTO default_outcome_count
        FROM public.event_outcomes
        WHERE interaction_id = interaction_rec.id
        AND choice_id = 'default';
        
        -- Initialize issues array
        issues_array := ARRAY[]::TEXT[];
        
        -- Validation rules
        IF choice_count = 0 AND outcome_count = 0 THEN
            issues_array := array_append(issues_array, 'Interaction without choices must have at least one outcome');
        END IF;
        
        IF choice_count = 0 AND default_outcome_count = 0 AND outcome_count > 0 THEN
            issues_array := array_append(issues_array, 'Interaction without choices should have a default outcome');
        END IF;
        
        IF choice_count > 0 AND outcome_count = 0 THEN
            issues_array := array_append(issues_array, 'Interaction with choices must have outcomes');
        END IF;
        
        IF choice_count > 0 AND outcome_count < choice_count THEN
            issues_array := array_append(issues_array, 'Number of outcomes should match number of choices');
        END IF;
        
        -- Return validation result
        RETURN QUERY SELECT 
            interaction_rec.id,
            interaction_rec.title,
            choice_count > 0,
            outcome_count > 0,
            default_outcome_count > 0,
            outcome_count,
            array_length(issues_array, 1) IS NULL OR array_length(issues_array, 1) = 0,
            issues_array;
    END LOOP;
END;
$$;

-- Function to validate story flow completeness
CREATE OR REPLACE FUNCTION public.validate_story_flow()
RETURNS TABLE(
    chapter_id UUID,
    chapter_title TEXT,
    event_count INTEGER,
    unlocked_event_count INTEGER,
    completed_event_count INTEGER,
    has_starting_event BOOLEAN,
    has_ending_events BOOLEAN,
    is_valid BOOLEAN,
    issues TEXT[]
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    chapter_rec RECORD;
    event_count INTEGER;
    unlocked_event_count INTEGER;
    completed_event_count INTEGER;
    starting_event_count INTEGER;
    ending_event_count INTEGER;
    issues_array TEXT[];
BEGIN
    FOR chapter_rec IN SELECT id, title FROM public.story_chapters
    LOOP
        -- Count events in this chapter
        SELECT COUNT(*) INTO event_count
        FROM public.story_events
        WHERE chapter_id = chapter_rec.id;
        
        -- Count unlocked events
        SELECT COUNT(*) INTO unlocked_event_count
        FROM public.story_events
        WHERE chapter_id = chapter_rec.id AND is_unlocked = true;
        
        -- Count completed events (for testing purposes)
        SELECT COUNT(*) INTO completed_event_count
        FROM public.story_events
        WHERE chapter_id = chapter_rec.id AND is_completed = true;
        
        -- Count starting events (first event in chapter)
        SELECT COUNT(*) INTO starting_event_count
        FROM public.story_events
        WHERE chapter_id = chapter_rec.id AND display_order = 1 AND is_unlocked = true;
        
        -- Count ending events (events that unlock next chapter)
        SELECT COUNT(*) INTO ending_event_count
        FROM public.story_events se
        LEFT JOIN public.event_interactions ei ON se.id = ei.event_id
        LEFT JOIN public.event_outcomes eo ON ei.id = eo.interaction_id
        LEFT JOIN public.story_events next_se ON eo.next_event_id = next_se.id
        WHERE se.chapter_id = chapter_rec.id
        AND next_se.chapter_id != chapter_rec.id;
        
        -- Initialize issues array
        issues_array := ARRAY[]::TEXT[];
        
        -- Validation rules
        IF event_count = 0 THEN
            issues_array := array_append(issues_array, 'Chapter must have at least one event');
        END IF;
        
        IF starting_event_count = 0 THEN
            issues_array := array_append(issues_array, 'Chapter should have a starting unlocked event');
        END IF;
        
        IF chapter_rec.display_order > 1 AND unlocked_event_count = 0 THEN
            issues_array := array_append(issues_array, 'Non-first chapter should have unlockable events');
        END IF;
        
        -- Return validation result
        RETURN QUERY SELECT 
            chapter_rec.id,
            chapter_rec.title,
            event_count,
            unlocked_event_count,
            completed_event_count,
            starting_event_count > 0,
            ending_event_count > 0,
            array_length(issues_array, 1) IS NULL OR array_length(issues_array, 1) = 0,
            issues_array;
    END LOOP;
END;
$$;

-- Function to auto-generate missing default outcomes
CREATE OR REPLACE FUNCTION public.generate_missing_default_outcomes()
RETURNS TABLE(
    interaction_id UUID,
    interaction_title TEXT,
    generated_outcome_id UUID,
    status TEXT
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    interaction_rec RECORD;
    new_outcome_id UUID;
    next_interaction_id UUID;
BEGIN
    FOR interaction_rec IN 
        SELECT ei.id, ei.title, ei.event_id, ei.display_order
        FROM public.event_interactions ei
        WHERE (ei.choices IS NULL OR ei.choices = '[]'::JSONB OR jsonb_array_length(ei.choices) = 0)
        AND NOT EXISTS (
            SELECT 1 FROM public.event_outcomes eo 
            WHERE eo.interaction_id = ei.id AND eo.choice_id = 'default'
        )
    LOOP
        -- Generate new UUID for outcome
        new_outcome_id := gen_random_uuid();
        
        -- Find next interaction in the same event
        SELECT id INTO next_interaction_id
        FROM public.event_interactions
        WHERE event_id = interaction_rec.event_id
        AND id != interaction_rec.id
        AND display_order = interaction_rec.display_order + 1
        LIMIT 1;
        
        -- Insert default outcome
        INSERT INTO public.event_outcomes (
            id, interaction_id, choice_id, outcome_type, title, description, effects, next_event_id
        ) VALUES (
            new_outcome_id,
            interaction_rec.id,
            'default',
            'story',
            'Default Action',
            'Interaction completed successfully',
            '{}',
            next_interaction_id
        );
        
        -- Return result
        RETURN QUERY SELECT 
            interaction_rec.id,
            interaction_rec.title,
            new_outcome_id,
            'Generated default outcome';
    END LOOP;
END;
$$;

-- Grant execute permissions
GRANT EXECUTE ON FUNCTION public.validate_interactions_outcomes() TO authenticated;
GRANT EXECUTE ON FUNCTION public.validate_story_flow() TO authenticated;
GRANT EXECUTE ON FUNCTION public.generate_missing_default_outcomes() TO authenticated;
