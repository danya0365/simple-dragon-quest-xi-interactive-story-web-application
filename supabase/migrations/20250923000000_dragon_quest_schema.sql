-- Dragon Quest XI Interactive Story Database Schema
-- Created: 2025-09-23
-- Author: Marosdee Uma
-- Description: Database schema for Dragon Quest XI Interactive Story Web Application

-- Enable UUID extension if not already enabled
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- World Map Table
-- เก็บข้อมูลแผนที่โลกและภูมิภาคต่าง ๆ
CREATE TABLE IF NOT EXISTS public.world_map (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    image_url VARCHAR(500),
    unlock_requirements JSONB DEFAULT '{}',
    is_unlocked BOOLEAN DEFAULT false,
    display_order INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Locations Table
-- เก็บข้อมูลสถานที่ต่าง ๆ ในแต่ละภูมิภาค
CREATE TABLE IF NOT EXISTS public.locations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    world_map_id UUID NOT NULL REFERENCES public.world_map(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    image_url VARCHAR(500),
    location_type VARCHAR(50) DEFAULT 'town', -- town, dungeon, field, castle, etc.
    unlock_requirements JSONB DEFAULT '{}',
    is_unlocked BOOLEAN DEFAULT false,
    display_order INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Story Chapters Table
-- เก็บข้อมูลบทต่าง ๆ ของเรื่อง
CREATE TABLE IF NOT EXISTS public.story_chapters (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    chapter_number INTEGER NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    unlock_requirements JSONB DEFAULT '{}',
    is_unlocked BOOLEAN DEFAULT false,
    is_completed BOOLEAN DEFAULT false,
    display_order INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Story Events Table
-- เก็บข้อมูลเหตุการณ์ต่าง ๆ ในเรื่อง
CREATE TABLE IF NOT EXISTS public.story_events (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    chapter_id UUID NOT NULL REFERENCES public.story_chapters(id) ON DELETE CASCADE,
    location_id UUID REFERENCES public.locations(id) ON DELETE SET NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    event_type VARCHAR(50) DEFAULT 'story', -- story, battle, dialogue, choice, etc.
    unlock_requirements JSONB DEFAULT '{}',
    completion_requirements JSONB DEFAULT '{}',
    rewards JSONB DEFAULT '{}',
    is_unlocked BOOLEAN DEFAULT false,
    is_completed BOOLEAN DEFAULT false,
    display_order INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Event Interactions Table
-- เก็บข้อมูลการโต้ตอบในแต่ละเหตุการณ์
CREATE TABLE IF NOT EXISTS public.event_interactions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    event_id UUID NOT NULL REFERENCES public.story_events(id) ON DELETE CASCADE,
    interaction_type VARCHAR(50) NOT NULL, -- talk, examine, choose, battle, etc.
    title VARCHAR(255) NOT NULL,
    description TEXT,
    dialogue_text TEXT,
    character_speaker VARCHAR(255),
    choices JSONB DEFAULT '[]', -- Array of choice options
    requirements JSONB DEFAULT '{}',
    is_available BOOLEAN DEFAULT true,
    display_order INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Event Outcomes Table
-- เก็บผลลัพธ์ของการเลือกในแต่ละ interaction
CREATE TABLE IF NOT EXISTS public.event_outcomes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    interaction_id UUID NOT NULL REFERENCES public.event_interactions(id) ON DELETE CASCADE,
    choice_id VARCHAR(100), -- ID of the choice that leads to this outcome
    outcome_type VARCHAR(50) DEFAULT 'story', -- story, reward, unlock, party_join, etc.
    title VARCHAR(255),
    description TEXT,
    effects JSONB DEFAULT '{}', -- What happens as a result
    next_event_id UUID REFERENCES public.story_events(id) ON DELETE SET NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Characters Table
-- เก็บข้อมูลตัวละครในเกม
CREATE TABLE IF NOT EXISTS public.characters (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    character_type VARCHAR(50) DEFAULT 'npc', -- party_member, npc, enemy, etc.
    avatar_url VARCHAR(500),
    stats JSONB DEFAULT '{}', -- HP, MP, Level, etc.
    abilities JSONB DEFAULT '[]', -- Array of abilities/skills
    join_requirements JSONB DEFAULT '{}',
    is_party_member BOOLEAN DEFAULT false,
    is_available BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Items Table
-- เก็บข้อมูลไอเทมต่าง ๆ
CREATE TABLE IF NOT EXISTS public.items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    item_type VARCHAR(50) DEFAULT 'misc', -- weapon, armor, consumable, key_item, misc
    rarity VARCHAR(20) DEFAULT 'common', -- common, rare, epic, legendary
    stats JSONB DEFAULT '{}', -- Attack, Defense, etc.
    effects JSONB DEFAULT '{}', -- Special effects
    image_url VARCHAR(500),
    is_tradeable BOOLEAN DEFAULT true,
    is_consumable BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- User Progress Table
-- เก็บความคืบหน้าของผู้เล่นแต่ละคน
CREATE TABLE IF NOT EXISTS public.user_progress (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    current_chapter_id UUID REFERENCES public.story_chapters(id) ON DELETE SET NULL,
    current_location_id UUID REFERENCES public.locations(id) ON DELETE SET NULL,
    completed_events JSONB DEFAULT '[]', -- Array of completed event IDs
    unlocked_regions JSONB DEFAULT '[]'::JSONB,
    unlocked_locations JSONB DEFAULT '[]', -- Array of unlocked location IDs
    unlocked_chapters JSONB DEFAULT '[]', -- Array of unlocked chapter IDs
    game_stats JSONB DEFAULT '{}', -- Play time, completion percentage, etc.
    save_data JSONB DEFAULT '{}', -- Additional save data
    last_played_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id)
);

-- User Party Members Table
-- เก็บข้อมูลสมาชิกในปาร์ตี้ของผู้เล่นแต่ละคน
CREATE TABLE IF NOT EXISTS public.user_party_members (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    character_id UUID NOT NULL REFERENCES public.characters(id) ON DELETE CASCADE,
    joined_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    current_stats JSONB DEFAULT '{}', -- Current HP, MP, Level, etc.
    equipment JSONB DEFAULT '{}', -- Equipped items
    is_active BOOLEAN DEFAULT true,
    party_position INTEGER DEFAULT 1, -- Position in party (1-4)
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, character_id)
);

-- User Inventory Table
-- เก็บข้อมูลไอเทมในกระเป๋าของผู้เล่นแต่ละคน
CREATE TABLE IF NOT EXISTS public.user_inventory (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    item_id UUID NOT NULL REFERENCES public.items(id) ON DELETE CASCADE,
    quantity INTEGER NOT NULL DEFAULT 1,
    obtained_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, item_id)
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_locations_world_map_id ON public.locations(world_map_id);
CREATE INDEX IF NOT EXISTS idx_story_events_chapter_id ON public.story_events(chapter_id);
CREATE INDEX IF NOT EXISTS idx_story_events_location_id ON public.story_events(location_id);
CREATE INDEX IF NOT EXISTS idx_event_interactions_event_id ON public.event_interactions(event_id);
CREATE INDEX IF NOT EXISTS idx_event_outcomes_interaction_id ON public.event_outcomes(interaction_id);
CREATE INDEX IF NOT EXISTS idx_user_progress_user_id ON public.user_progress(user_id);
CREATE INDEX IF NOT EXISTS idx_user_party_members_user_id ON public.user_party_members(user_id);
CREATE INDEX IF NOT EXISTS idx_user_party_members_character_id ON public.user_party_members(character_id);
CREATE INDEX IF NOT EXISTS idx_user_inventory_user_id ON public.user_inventory(user_id);
CREATE INDEX IF NOT EXISTS idx_user_inventory_item_id ON public.user_inventory(item_id);

-- Create updated_at triggers for all tables
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Apply updated_at triggers
CREATE TRIGGER update_world_map_updated_at BEFORE UPDATE ON public.world_map FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER update_locations_updated_at BEFORE UPDATE ON public.locations FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER update_story_chapters_updated_at BEFORE UPDATE ON public.story_chapters FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER update_story_events_updated_at BEFORE UPDATE ON public.story_events FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER update_event_interactions_updated_at BEFORE UPDATE ON public.event_interactions FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER update_event_outcomes_updated_at BEFORE UPDATE ON public.event_outcomes FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER update_characters_updated_at BEFORE UPDATE ON public.characters FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER update_items_updated_at BEFORE UPDATE ON public.items FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER update_user_progress_updated_at BEFORE UPDATE ON public.user_progress FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER update_user_party_members_updated_at BEFORE UPDATE ON public.user_party_members FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER update_user_inventory_updated_at BEFORE UPDATE ON public.user_inventory FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
