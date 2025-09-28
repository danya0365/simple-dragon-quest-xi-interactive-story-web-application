-- Helper functions for working with readable codes
-- Created: 2025-09-27
-- Author: Marosdee Uma
-- Description: Functions to convert between readable codes and UUIDs

-- Function to generate UUID from readable code (for consistent UUID generation)
CREATE OR REPLACE FUNCTION public.generate_uuid_from_code(code VARCHAR)
RETURNS UUID
AS $$
BEGIN
    -- Generate consistent UUID based on code using MD5 hash
    -- This ensures the same code always generates the same UUID
    RETURN uuid_generate_v5(uuid_nil(), code::text);
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- Function to get UUID by code from world_regions
CREATE OR REPLACE FUNCTION public.get_world_region_id_by_code(code VARCHAR)
RETURNS UUID
AS $$
BEGIN
    RETURN id FROM public.world_regions WHERE world_regions.code = code LIMIT 1;
END;
$$ LANGUAGE plpgsql STABLE;

-- Function to get UUID by code from locations
CREATE OR REPLACE FUNCTION public.get_location_id_by_code(code VARCHAR)
RETURNS UUID
AS $$
BEGIN
    RETURN id FROM public.locations WHERE locations.code = code LIMIT 1;
END;
$$ LANGUAGE plpgsql STABLE;

-- Function to get UUID by code from story_chapters
CREATE OR REPLACE FUNCTION public.get_story_chapter_id_by_code(code VARCHAR)
RETURNS UUID
AS $$
BEGIN
    RETURN id FROM public.story_chapters WHERE story_chapters.code = code LIMIT 1;
END;
$$ LANGUAGE plpgsql STABLE;

-- Function to get UUID by code from story_events
CREATE OR REPLACE FUNCTION public.get_story_event_id_by_code(code VARCHAR)
RETURNS UUID
AS $$
BEGIN
    RETURN id FROM public.story_events WHERE story_events.code = code LIMIT 1;
END;
$$ LANGUAGE plpgsql STABLE;

-- Function to get UUID by code from characters
CREATE OR REPLACE FUNCTION public.get_character_id_by_code(code VARCHAR)
RETURNS UUID
AS $$
BEGIN
    RETURN id FROM public.characters WHERE characters.code = code LIMIT 1;
END;
$$ LANGUAGE plpgsql STABLE;

-- Function to get UUID by code from items
CREATE OR REPLACE FUNCTION public.get_item_id_by_code(code VARCHAR)
RETURNS UUID
AS $$
BEGIN
    RETURN id FROM public.items WHERE items.code = code LIMIT 1;
END;
$$ LANGUAGE plpgsql STABLE;

-- Function to get UUID by code from event_interactions
CREATE OR REPLACE FUNCTION public.get_event_interaction_id_by_code(code VARCHAR)
RETURNS UUID
AS $$
BEGIN
    RETURN id FROM public.event_interactions WHERE event_interactions.code = code LIMIT 1;
END;
$$ LANGUAGE plpgsql STABLE;

-- Function to get UUID by code from event_outcomes
CREATE OR REPLACE FUNCTION public.get_event_outcome_id_by_code(code VARCHAR)
RETURNS UUID
AS $$
BEGIN
    RETURN id FROM public.event_outcomes WHERE event_outcomes.code = code LIMIT 1;
END;
$$ LANGUAGE plpgsql STABLE;

-- Function to insert world_region with code (returns UUID)
CREATE OR REPLACE FUNCTION public.insert_world_region_with_code(
    code VARCHAR,
    name VARCHAR,
    description TEXT DEFAULT NULL,
    image_url VARCHAR DEFAULT NULL,
    unlock_requirements JSONB DEFAULT '{}',
    display_order INTEGER DEFAULT 0,
    is_initial_user_progress BOOLEAN DEFAULT false,
    is_alway_hide_until_unlock BOOLEAN DEFAULT false
)
RETURNS UUID
AS $$
DECLARE
    region_id UUID;
BEGIN
    region_id := public.generate_uuid_from_code(code);
    
    INSERT INTO public.world_regions (
        id, code, name, description, image_url, unlock_requirements, 
        display_order, is_initial_user_progress, is_alway_hide_until_unlock
    ) VALUES (
        region_id, code, name, description, image_url, unlock_requirements,
        display_order, is_initial_user_progress, is_alway_hide_until_unlock
    ) ON CONFLICT (id) DO UPDATE SET
        code = EXCLUDED.code,
        name = EXCLUDED.name,
        description = EXCLUDED.description,
        image_url = EXCLUDED.image_url,
        unlock_requirements = EXCLUDED.unlock_requirements,
        display_order = EXCLUDED.display_order,
        is_initial_user_progress = EXCLUDED.is_initial_user_progress,
        is_alway_hide_until_unlock = EXCLUDED.is_alway_hide_until_unlock;
    
    RETURN region_id;
END;
$$ LANGUAGE plpgsql;

-- Function to insert location with code (returns UUID)
CREATE OR REPLACE FUNCTION public.insert_location_with_code(
    code VARCHAR,
    world_region_code VARCHAR,
    name VARCHAR,
    description TEXT DEFAULT NULL,
    location_type VARCHAR DEFAULT 'town',
    unlock_requirements JSONB DEFAULT '{}',
    display_order INTEGER DEFAULT 0,
    is_initial_user_progress BOOLEAN DEFAULT false,
    is_alway_hide_until_unlock BOOLEAN DEFAULT false
)
RETURNS UUID
AS $$
DECLARE
    location_id UUID;
    region_id UUID;
BEGIN
    location_id := public.generate_uuid_from_code(code);
    region_id := public.get_world_region_id_by_code(world_region_code);
    
    IF region_id IS NULL THEN
        RAISE EXCEPTION 'World region with code % not found', world_region_code;
    END IF;
    
    INSERT INTO public.locations (
        id, code, world_region_id, name, description, location_type, unlock_requirements,
        display_order, is_initial_user_progress, is_alway_hide_until_unlock
    ) VALUES (
        location_id, code, region_id, name, description, location_type, unlock_requirements,
        display_order, is_initial_user_progress, is_alway_hide_until_unlock
    ) ON CONFLICT (id) DO UPDATE SET
        code = EXCLUDED.code,
        world_region_id = EXCLUDED.world_region_id,
        name = EXCLUDED.name,
        description = EXCLUDED.description,
        location_type = EXCLUDED.location_type,
        unlock_requirements = EXCLUDED.unlock_requirements,
        display_order = EXCLUDED.display_order,
        is_initial_user_progress = EXCLUDED.is_initial_user_progress,
        is_alway_hide_until_unlock = EXCLUDED.is_alway_hide_until_unlock;
    
    RETURN location_id;
END;
$$ LANGUAGE plpgsql;
