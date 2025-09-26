-- Dragon Quest XI Interactive Story Database Schema
-- Created: 2025-09-23
-- Author: Marosdee Uma
-- Description: Database schema for Dragon Quest XI Interactive Story Web Application
-- Updated: 2025-09-24 - Fixed state redundancy by using user state only

-- Enable UUID extension if not already enabled
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Maps Table (Unified hierarchical map system - replaces world_regions and locations)
-- เก็บข้อมูลแผนที่ทั้งหมดในระบบแบบ hierarchy (Content only, no user state)
CREATE TABLE IF NOT EXISTS public.maps (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    parent_id UUID REFERENCES public.maps(id) ON DELETE CASCADE,
    -- Unlimited nesting: World → Region → Town → Building → Room → Sub-room
    
    name VARCHAR(255) NOT NULL,
    description TEXT,
    image_url VARCHAR(500),
    
    -- Map classification
    map_type VARCHAR(50) NOT NULL, -- world, location, interior
    map_subtype VARCHAR(50), -- region, dungeon, town, castle, house, landmark, room, etc.
    
    -- Position and size
    position_x INTEGER DEFAULT 0,
    position_y INTEGER DEFAULT 0,
    size_width INTEGER DEFAULT 100,
    size_height INTEGER DEFAULT 100,
    
    -- Map linking (for location-to-map connections)
    linked_map_id UUID REFERENCES public.maps(id) ON DELETE SET NULL,
    -- Links this location to its interior map (e.g., Hero House → Hero Bedroom)
    
    -- Unlock system
    unlock_requirements JSONB DEFAULT '{}',
    -- Requirements to unlock this map
    -- Format: {"level": integer, "completed_chapters": [uuid], "flags": {string: any}}
    -- Example: {"level": 3, "completed_chapters": ["33333333-3333-3333-3333-333333333001"], "flags": {"reached_heliodor": true}}
    
    display_order INTEGER NOT NULL DEFAULT 0,
    is_accessible BOOLEAN DEFAULT true,
    -- Indicates if this map is accessible to the user
    is_initial_user_progress BOOLEAN DEFAULT false,
    -- Indicates if this map is part of initial user progress setup
    is_alway_hide_until_unlock BOOLEAN DEFAULT false,
    -- Indicates if this map should be hidden until unlocked
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Story Chapters Table
-- เก็บข้อมูลบทต่าง ๆ ของเรื่อง (Content only, no user state)
CREATE TABLE IF NOT EXISTS public.story_chapters (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    chapter_number INTEGER NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    unlock_requirements JSONB DEFAULT '{}',
    -- Requirements to unlock this story chapter
    -- Format: {"level": integer, "completed_chapters": [uuid], "flags": {string: any}}
    -- Example: {"level": 1, "completed_chapters": ["33333333-3333-3333-3333-333333333001"], "flags": {"ceremony_completed": true}}
    display_order INTEGER NOT NULL DEFAULT 0,
    is_initial_user_progress BOOLEAN DEFAULT false,
    -- Indicates if this story chapter is part of initial user progress setup
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Story Events Table
-- เก็บข้อมูลเหตุการณ์ต่าง ๆ ในเรื่อง (Content only, no user state)
CREATE TABLE IF NOT EXISTS public.story_events (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    chapter_id UUID NOT NULL REFERENCES public.story_chapters(id) ON DELETE CASCADE,
    map_id UUID REFERENCES public.maps(id) ON DELETE SET NULL, -- Changed from location_id
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    event_type VARCHAR(50) DEFAULT 'story', -- story, battle, dialogue, choice, etc.
    unlock_requirements JSONB DEFAULT '{}',
    -- Requirements to unlock this story event
    -- Format: {"level": integer, "completed_events": [uuid], "items": [uuid], "flags": {string: any}}
    -- Example: {"level": 1, "completed_events": ["66666666-6666-6666-6666-666666666001"], "flags": {"met_grandpa": true}}
    completion_requirements JSONB DEFAULT '{}',
    -- Requirements to complete this story event
    -- Format: {"interactions_completed": [uuid], "choices_made": [string], "items_used": [uuid]}
    -- Example: {"interactions_completed": ["77777777-7777-7777-7777-777777777001"], "choices_made": ["friendly"]}
    rewards JSONB DEFAULT '{}',
    -- Rewards for completing this story event
    -- Format: {"experience": integer, "gold": integer, "items": [{"id": uuid, "quantity": integer}]}
    -- Example: {"experience": 100, "gold": 50, "items": [{"id": "55555555-5555-5555-5555-555555555001", "quantity": 1}]}
    display_order INTEGER NOT NULL DEFAULT 0,
    is_initial_user_progress BOOLEAN DEFAULT false,
    -- Indicates if this story event is part of initial user progress setup
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
    choices JSONB DEFAULT '[]',
    -- Array of choice options for player interaction
    -- Format: [{"id": string, "text": string, "type": string, "requirements": {}}]
    -- Example: [{"id": "friendly", "text": "ยินดีที่ได้รู้จัก ฉันชื่อ Hero", "type": "friendly", "requirements": {}}]
    requirements JSONB DEFAULT '{}',
    -- Requirements for this interaction to be available
    -- Format: {"level": integer, "items": [uuid], "flags": {string: any}}
    -- Example: {"level": 1, "items": ["55555555-5555-5555-5555-555555555001"], "flags": {"met_king": true}}
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
    choice_key VARCHAR(100), -- ID of the choice that leads to this outcome
    outcome_type VARCHAR(50) DEFAULT 'story', -- story, reward, unlock, party_join, etc.
    title VARCHAR(255),
    description TEXT,
    effects JSONB DEFAULT '{}',
    -- Effects that occur when this outcome is triggered
    -- Format: {
    --   "relationship": {character_name: integer},
    --   "unlock_events": [uuid],
    --   "unlock_chapters": [uuid],
    --   "unlock_locations": [uuid],
    --   "unlock_regions": [uuid],
    --   "party_join": uuid,
    --   "items": [{"id": uuid, "quantity": integer}],
    --   "experience": integer,
    --   "gold": integer
    -- }
    -- Example: {"relationship": {"erik": 10}, "unlock_events": ["66666666-6666-6666-6666-666666666005"], "items": [{"id": "55555555-5555-5555-5555-555555555005", "quantity": 1}]}
    next_event_id UUID REFERENCES public.story_events(id) ON DELETE SET NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Characters Table
-- เก็บข้อมูลตัวละครในเกม (Content only, no user state)
CREATE TABLE IF NOT EXISTS public.characters (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    character_type VARCHAR(50) DEFAULT 'npc', -- party_member, npc, enemy, etc.
    avatar_url VARCHAR(500),
    stats JSONB DEFAULT '{}',
    -- Character base stats
    -- Format: {"hp": integer, "mp": integer, "level": integer, "attack": integer, "defense": integer}
    -- Example: {"hp": 100, "mp": 50, "level": 1, "attack": 15, "defense": 10}
    abilities JSONB DEFAULT '[]',
    -- Array of character abilities/skills
    -- Format: [{"id": string, "name": string, "description": string, "mp_cost": integer}]
    -- Example: [{"id": "sword_strike", "name": "Sword Strike", "description": "Basic sword attack", "mp_cost": 0}]
    join_requirements JSONB DEFAULT '{}',
    -- Requirements for character to join party
    -- Format: {"level": integer, "completed_events": [uuid], "flags": {string: any}}
    -- Example: {"level": 5, "completed_events": ["66666666-6666-6666-6666-666666666001"], "flags": {"erik_trust": 10}}
    is_joinable BOOLEAN DEFAULT false,
    is_initial_user_progress BOOLEAN DEFAULT false,
    -- Indicates if this character is part of initial user progress setup
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
    stats JSONB DEFAULT '{}',
    -- Item stats and attributes
    -- Format: {"attack": integer, "defense": integer, "hp_bonus": integer, "mp_bonus": integer, "critical": integer}
    -- Example: {"attack": 5, "critical": 15}
    effects JSONB DEFAULT '{}',
    -- Special effects of the item
    -- Format: {"heal": integer, "unlock": string, "buff": {string: any}, "duration": integer}
    -- Example: {"heal": 30, "unlock": "prison_door"}
    image_url VARCHAR(500),
    is_tradeable BOOLEAN DEFAULT true,
    is_consumable BOOLEAN DEFAULT false,
    is_initial_user_progress BOOLEAN DEFAULT false,
    -- Indicates if this item is part of initial user progress setup
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Map Objects Table (NPCs, items, interactive elements within maps)
-- เก็บข้อมูลออบเจกต์ต่าง ๆ ภายในแผนที่ (Content only, no user state)
CREATE TABLE IF NOT EXISTS public.map_objects (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    map_id UUID NOT NULL REFERENCES public.maps(id) ON DELETE CASCADE,
    
    name VARCHAR(255) NOT NULL,
    object_type VARCHAR(50) NOT NULL, -- npc, item, interactive, decoration, portal
    object_subtype VARCHAR(50), -- character, weapon, door, chest, etc.
    
    -- Position within map
    position_x INTEGER NOT NULL,
    position_y INTEGER NOT NULL,
    
    -- Object properties
    properties JSONB DEFAULT '{}',
    -- Format: {"dialogue": "text", "can_interact": true, "inventory": [], "stats": {}}
    
    -- Link to master data (optional)
    character_id UUID REFERENCES public.characters(id) ON DELETE SET NULL,
    item_id UUID REFERENCES public.items(id) ON DELETE SET NULL,
    
    -- Interaction settings
    is_interactive BOOLEAN DEFAULT true,
    interaction_id UUID REFERENCES public.event_interactions(id) ON DELETE SET NULL,
    
    display_order INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- User Game States Table
-- เก็บความคืบหน้าของผู้เล่นแต่ละคน (Multiple save slots with names)
CREATE TABLE IF NOT EXISTS public.user_game_states (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL DEFAULT 'Default Save',
    
    -- Current state (updated for maps)
    current_chapter_id UUID REFERENCES public.story_chapters(id) ON DELETE SET NULL,
    current_map_id UUID REFERENCES public.maps(id) ON DELETE SET NULL, -- Changed from current_location_id
    current_event_id UUID REFERENCES public.story_events(id) ON DELETE SET NULL,
    
    -- Player progression
    player_level INTEGER DEFAULT 1,
    player_experience INTEGER DEFAULT 0,
    
    -- Game content (updated for unified maps)
    unlocked_maps JSONB DEFAULT '[]',
    -- Array of unlocked map UUIDs (replaces separate world_regions and locations)
    -- Format: [uuid]
    -- Example: ["map-world-uuid", "map-cobblestone-uuid", "map-hero-house-uuid"]
    unlocked_chapters JSONB DEFAULT '[]',
    -- Array of unlocked chapter UUIDs
    -- Format: [uuid]
    -- Example: ["33333333-3333-3333-3333-333333333001", "33333333-3333-3333-3333-333333333002"]
    unlocked_events JSONB DEFAULT '[]',
    -- Array of unlocked event UUIDs
    -- Format: [uuid]
    -- Example: ["66666666-6666-6666-6666-666666666001", "66666666-6666-6666-6666-666666666002"]
    
    -- Completed content
    completed_chapters JSONB DEFAULT '[]',
    -- Array of completed chapter UUIDs
    -- Format: [uuid]
    -- Example: ["33333333-3333-3333-3333-333333333001"]
    completed_events JSONB DEFAULT '[]',
    -- Array of completed event UUIDs
    -- Format: [uuid]
    -- Example: ["66666666-6666-6666-6666-666666666001", "66666666-6666-6666-6666-666666666002"]
    
    completed_interactions JSONB DEFAULT '[]',
    -- Array of completed interaction data with timestamps and event associations
    -- Format: [{"interaction_id": uuid, "event_id": uuid, "completed_at": timestamp}]
    -- Example: [{"interaction_id": "77777777-7777-7777-7777-777777777001", "event_id": "66666666-6666-6666-6666-666666666001", "completed_at": "2025-01-01T00:00:00Z"}]
    
    -- Player inventory and equipment (CENTRALIZED)
    inventory JSONB DEFAULT '[]',
    -- Array of items with detailed inventory data
    -- Format: [{"item_id": uuid, "quantity": integer, "obtained_at": timestamp, "equipped": boolean, "slot": string}]
    -- Example: [{"item_id": "55555555-5555-5555-5555-555555555001", "quantity": 1, "obtained_at": "2025-01-01T00:00:00Z", "equipped": true, "slot": "weapon"}]
    
    -- Party members (CENTRALIZED)
    party_members JSONB DEFAULT '[]',
    -- Array of party member data with full details
    -- Format: [{"character_id": uuid, "joined_at": timestamp, "current_stats": {}, "equipment": {}, "is_active": boolean, "party_position": integer}]
    -- Example: [{"character_id": "44444444-4444-4444-4444-444444444001", "joined_at": "2025-01-01T00:00:00Z", "current_stats": {"hp": 120, "mp": 60}, "equipment": {"weapon": "uuid"}, "is_active": true, "party_position": 1}]
    
    -- Character relationships
    character_relationships JSONB DEFAULT '{}',
    -- Character relationship levels and flags
    -- Format: {"erik": 15, "grandpa": 50, "king": -10}
    
    -- Player position (enhanced for nested maps)
    player_position JSONB DEFAULT '{}',
    -- Current player position in the game world with nested map support
    -- Format: {"x": 100, "y": 200, "map_id": "uuid", "parent_map_path": [uuid]}
    -- Example: {"x": 2, "y": 2, "map_id": "hero-bedroom-uuid", "parent_map_path": ["world-uuid", "cobblestone-uuid", "hero-house-uuid"]}
    
    -- Achievements
    achievements JSONB DEFAULT '[]',
    -- Unlocked achievements and completion data
    -- Format: [{"id": uuid, "unlocked_at": timestamp}]
    
    -- Play history
    play_history JSONB DEFAULT '[]',
    -- Historical record of completed events and choices
    -- Format: [{"event_id": uuid, "completed_at": timestamp, "choices": [string]}]
    
    -- Active content
    active_quests JSONB DEFAULT '[]',
    -- Array of active quest/event UUIDs
    -- Format: [uuid]
    -- Example: ["66666666-6666-6666-6666-666666666003", "66666666-6666-6666-6666-666666666004"]
    game_flags JSONB DEFAULT '{}',
    -- Story flags and variables for branching narratives
    -- Format: {flag_name: any}
    -- Example: {"met_king": true, "erik_trust": 10, "completed_tutorial": false}
    
    -- Game statistics and save data
    game_stats JSONB DEFAULT '{}',
    -- Player game statistics and progress tracking
    -- Format: {"play_time": integer, "interactions_completed": integer, "events_completed": integer, "completion_percentage": float}
    -- Example: {"play_time": 3600, "interactions_completed": 25, "events_completed": 8, "completion_percentage": 15.5}
    game_settings JSONB DEFAULT '{}',
    -- Player preferences and game settings
    -- Format: {"sound_volume": float, "music_volume": float, "difficulty": string, "language": string}
    -- Example: {"sound_volume": 0.8, "music_volume": 0.6, "difficulty": "normal", "language": "th"}
    save_data JSONB DEFAULT '{}',
    -- Additional save data for custom game state
    -- Format: {custom_data: any}
    -- Example: {"last_checkpoint": "checkpoint-uuid", "player_position": {"x": 100, "y": 200}}
    
    -- Timestamps
    last_played_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    UNIQUE(user_id, name)
);

-- REMOVED: User Party Members Table - Data centralized to user_game_states.party_members
-- REMOVED: User Inventory Table - Data centralized to user_game_states.inventory

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_maps_parent_id ON public.maps(parent_id);
CREATE INDEX IF NOT EXISTS idx_maps_linked_map_id ON public.maps(linked_map_id);
CREATE INDEX IF NOT EXISTS idx_maps_type ON public.maps(map_type);
CREATE INDEX IF NOT EXISTS idx_story_events_chapter_id ON public.story_events(chapter_id);
CREATE INDEX IF NOT EXISTS idx_story_events_map_id ON public.story_events(map_id);
CREATE INDEX IF NOT EXISTS idx_event_interactions_event_id ON public.event_interactions(event_id);
CREATE INDEX IF NOT EXISTS idx_event_outcomes_interaction_id ON public.event_outcomes(interaction_id);
CREATE INDEX IF NOT EXISTS idx_map_objects_map_id ON public.map_objects(map_id);
CREATE INDEX IF NOT EXISTS idx_user_game_states_user_id ON public.user_game_states(user_id);
CREATE INDEX IF NOT EXISTS idx_user_game_states_current_map_id ON public.user_game_states(current_map_id);

-- Create GIN indexes for JSONB fields in user_game_states for better performance
CREATE INDEX IF NOT EXISTS idx_user_game_states_unlocked_maps ON public.user_game_states USING GIN (unlocked_maps);
CREATE INDEX IF NOT EXISTS idx_user_game_states_unlocked_chapters ON public.user_game_states USING GIN (unlocked_chapters);
CREATE INDEX IF NOT EXISTS idx_user_game_states_unlocked_events ON public.user_game_states USING GIN (unlocked_events);
CREATE INDEX IF NOT EXISTS idx_user_game_states_completed_chapters ON public.user_game_states USING GIN (completed_chapters);
CREATE INDEX IF NOT EXISTS idx_user_game_states_completed_events ON public.user_game_states USING GIN (completed_events);
CREATE INDEX IF NOT EXISTS idx_user_game_states_completed_interactions ON public.user_game_states USING GIN (completed_interactions);
CREATE INDEX IF NOT EXISTS idx_user_game_states_inventory ON public.user_game_states USING GIN (inventory);
CREATE INDEX IF NOT EXISTS idx_user_game_states_party_members ON public.user_game_states USING GIN (party_members);
CREATE INDEX IF NOT EXISTS idx_user_game_states_character_relationships ON public.user_game_states USING GIN (character_relationships);
CREATE INDEX IF NOT EXISTS idx_user_game_states_player_position ON public.user_game_states USING GIN (player_position);
CREATE INDEX IF NOT EXISTS idx_user_game_states_achievements ON public.user_game_states USING GIN (achievements);
CREATE INDEX IF NOT EXISTS idx_user_game_states_play_history ON public.user_game_states USING GIN (play_history);
CREATE INDEX IF NOT EXISTS idx_user_game_states_game_flags ON public.user_game_states USING GIN (game_flags);
CREATE INDEX IF NOT EXISTS idx_user_game_states_game_stats ON public.user_game_states USING GIN (game_stats);

-- Create updated_at triggers for all tables
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Apply updated_at triggers
CREATE TRIGGER update_maps_updated_at BEFORE UPDATE ON public.maps FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER update_story_chapters_updated_at BEFORE UPDATE ON public.story_chapters FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER update_story_events_updated_at BEFORE UPDATE ON public.story_events FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER update_event_interactions_updated_at BEFORE UPDATE ON public.event_interactions FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER update_event_outcomes_updated_at BEFORE UPDATE ON public.event_outcomes FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER update_characters_updated_at BEFORE UPDATE ON public.characters FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER update_items_updated_at BEFORE UPDATE ON public.items FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER update_map_objects_updated_at BEFORE UPDATE ON public.map_objects FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER update_user_game_states_updated_at BEFORE UPDATE ON public.user_game_states FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
