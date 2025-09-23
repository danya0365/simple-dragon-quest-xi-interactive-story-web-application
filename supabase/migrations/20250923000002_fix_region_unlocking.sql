-- Fix Region Unlocking Issues
-- Created: 2025-09-23
-- Author: Marosdee Uma
-- Description: Fix region unlocking logic and user progress initialization

-- Step 1: Add unlocked_regions column to user_progress table
ALTER TABLE public.user_progress 
ADD COLUMN IF NOT EXISTS unlocked_regions JSONB DEFAULT '[]'::JSONB;

-- Step 2: Fix get_world_map_for_user function to check regions instead of locations
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
            -- Check if region is unlocked by user progress OR if it's inherently unlocked
            wm.is_unlocked = true 
            OR (
                up.unlocked_regions IS NOT NULL 
                AND wm.id::text = ANY(SELECT jsonb_array_elements_text(up.unlocked_regions))
            )
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
    GROUP BY wm.id, wm.name, wm.description, wm.image_url, wm.is_unlocked, up.unlocked_locations, up.unlocked_regions
    ORDER BY wm.display_order;
END;
$$;

-- Step 3: Fix initialize_user_progress function to include regions
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
    
    -- Get first unlocked region
    SELECT id INTO first_region_id
    FROM public.world_map
    WHERE is_unlocked = true
    ORDER BY display_order
    LIMIT 1;
    
    -- Get protagonist character
    SELECT id INTO protagonist_id
    FROM public.characters
    WHERE character_type = 'party_member' AND (name ILIKE '%hero%' OR name ILIKE '%protagonist%')
    LIMIT 1;
    
    -- Create user progress with unlocked regions
    INSERT INTO public.user_progress (
        user_id,
        current_chapter_id,
        current_location_id,
        completed_events,
        unlocked_locations,
        unlocked_regions,
        unlocked_chapters,
        game_stats
    ) VALUES (
        user_uuid,
        first_chapter_id,
        first_location_id,
        '[]'::JSONB,
        jsonb_build_array(first_location_id::text),
        jsonb_build_array(COALESCE(first_region_id::text, '')),
        jsonb_build_array(first_chapter_id::text),
        jsonb_build_object('play_time', 0, 'completion_percentage', 0)
    ) ON CONFLICT (user_id) DO UPDATE SET
        unlocked_regions = CASE 
            WHEN user_progress.unlocked_regions IS NULL OR jsonb_array_length(user_progress.unlocked_regions) = 0
            THEN jsonb_build_array(COALESCE(first_region_id::text, ''))
            ELSE user_progress.unlocked_regions
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

-- Step 4: Create function to unlock regions
CREATE OR REPLACE FUNCTION public.unlock_region(user_uuid UUID, region_id UUID)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    -- Add region to unlocked_regions if not already there
    UPDATE public.user_progress
    SET unlocked_regions = 
        CASE 
            WHEN unlocked_regions IS NULL THEN jsonb_build_array(region_id::text)
            WHEN NOT (region_id::text = ANY(SELECT jsonb_array_elements_text(unlocked_regions))) 
            THEN unlocked_regions || region_id::text
            ELSE unlocked_regions
        END
    WHERE user_id = user_uuid;
    
    RETURN jsonb_build_object('success', true, 'message', 'Region unlocked');
END;
$$;

-- Step 5: Update existing users to have proper unlocked regions
UPDATE public.user_progress 
SET unlocked_regions = jsonb_build_array('11111111-1111-1111-1111-111111111001') -- Cobblestone region ID
WHERE unlocked_regions IS NULL OR jsonb_array_length(unlocked_regions) = 0;
