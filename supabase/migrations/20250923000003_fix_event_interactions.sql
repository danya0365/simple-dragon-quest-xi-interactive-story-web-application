-- Fix Event Interactions Function
-- Created: 2025-09-23
-- Author: Marosdee Uma
-- Description: Fix get_event_interactions function to use correct column names

-- Fix the get_event_interactions function to use character_speaker instead of character_id
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

-- Grant execute permission
GRANT EXECUTE ON FUNCTION public.get_event_interactions(UUID, UUID) TO authenticated;
