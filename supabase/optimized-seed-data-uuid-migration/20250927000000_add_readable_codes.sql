-- Add readable code columns for easier reference in seed data
-- Created: 2025-09-27
-- Author: Marosdee Uma
-- Description: Migration to add readable code columns for easier seed data management

-- Add readable code column to world_regions
ALTER TABLE public.world_regions 
ADD COLUMN code VARCHAR(50) UNIQUE,
ADD COLUMN CONSTRAINT world_regions_code_check CHECK (code ~ '^[a-z0-9_-]+$');

-- Add readable code column to locations
ALTER TABLE public.locations 
ADD COLUMN code VARCHAR(50) UNIQUE,
ADD COLUMN CONSTRAINT locations_code_check CHECK (code ~ '^[a-z0-9_-]+$');

-- Add readable code column to story_chapters
ALTER TABLE public.story_chapters 
ADD COLUMN code VARCHAR(50) UNIQUE,
ADD COLUMN CONSTRAINT story_chapters_code_check CHECK (code ~ '^[a-z0-9_-]+$');

-- Add readable code column to story_events
ALTER TABLE public.story_events 
ADD COLUMN code VARCHAR(50) UNIQUE,
ADD COLUMN CONSTRAINT story_events_code_check CHECK (code ~ '^[a-z0-9_-]+$');

-- Add readable code column to characters
ALTER TABLE public.characters 
ADD COLUMN code VARCHAR(50) UNIQUE,
ADD COLUMN CONSTRAINT characters_code_check CHECK (code ~ '^[a-z0-9_-]+$');

-- Add readable code column to items
ALTER TABLE public.items 
ADD COLUMN code VARCHAR(50) UNIQUE,
ADD COLUMN CONSTRAINT items_code_check CHECK (code ~ '^[a-z0-9_-]+$');

-- Add readable code column to event_interactions
ALTER TABLE public.event_interactions 
ADD COLUMN code VARCHAR(50) UNIQUE,
ADD COLUMN CONSTRAINT event_interactions_code_check CHECK (code ~ '^[a-z0-9_-]+$');

-- Add readable code column to event_outcomes
ALTER TABLE public.event_outcomes 
ADD COLUMN code VARCHAR(50) UNIQUE,
ADD COLUMN CONSTRAINT event_outcomes_code_check CHECK (code ~ '^[a-z0-9_-]+$');

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_world_regions_code ON public.world_regions(code);
CREATE INDEX IF NOT EXISTS idx_locations_code ON public.locations(code);
CREATE INDEX IF NOT EXISTS idx_story_chapters_code ON public.story_chapters(code);
CREATE INDEX IF NOT EXISTS idx_story_events_code ON public.story_events(code);
CREATE INDEX IF NOT EXISTS idx_characters_code ON public.characters(code);
CREATE INDEX IF NOT EXISTS idx_items_code ON public.items(code);
CREATE INDEX IF NOT EXISTS idx_event_interactions_code ON public.event_interactions(code);
CREATE INDEX IF NOT EXISTS idx_event_outcomes_code ON public.event_outcomes(code);

-- Add comments for documentation
COMMENT ON COLUMN public.world_regions.code IS 'Readable unique code for easier reference (e.g., cobblestone, heliodor_region)';
COMMENT ON COLUMN public.locations.code IS 'Readable unique code for easier reference (e.g., luminary_house, village_square)';
COMMENT ON COLUMN public.story_chapters.code IS 'Readable unique code for easier reference (e.g., ch01_luminary_awakening)';
COMMENT ON COLUMN public.story_events.code IS 'Readable unique code for easier reference (e.g., birthday_awakening, morning_training)';
COMMENT ON COLUMN public.characters.code IS 'Readable unique code for easier reference (e.g., luminary, gemma, chalky)';
COMMENT ON COLUMN public.items.code IS 'Readable unique code for easier reference (e.g., cobblestone_sword, healing_herb)';
COMMENT ON COLUMN public.event_interactions.code IS 'Readable unique code for easier reference (e.g., talk_to_chalky, examine_decorations)';
COMMENT ON COLUMN public.event_outcomes.code IS 'Readable unique code for easier reference (e.g., ready_choice, thankful_choice)';
