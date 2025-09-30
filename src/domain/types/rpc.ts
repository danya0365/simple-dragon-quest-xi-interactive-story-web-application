// Database Schema Types (from RPC responses) - snake_case
import { Json } from "./supabase";

// Party Member Schema (snake_case from database)
export interface PartyMemberSchema {
  equipment: {
    weapon: string;
    armor: string;
    accessory: string;
  };
  is_active: boolean;
  joined_at: string;
  character_id: string;
  current_stats: {
    hp: number;
    mp: number;
    level: number;
    attack: number;
    defense: number;
  };
  party_position: number;
}

// Party Member DTO (camelCase for frontend use)
export interface PartyMemberDto {
  equipment: {
    weapon: string;
    armor: string;
    accessory: string;
  };
  isActive: boolean;
  joinedAt: string;
  characterId: string;
  currentStats: {
    hp: number;
    mp: number;
    level: number;
    attack: number;
    defense: number;
  };
  partyPosition: number;
}

// Game Effects Types - matches database schema
export type GameEffects = {
  relationship?: Record<string, number>; // {character_name: integer}
  unlock_events?: string[]; // [uuid]
  unlock_chapters?: string[]; // [uuid]
  unlock_locations?: string[]; // [uuid]
  unlock_regions?: string[]; // [uuid]
  party_join?: string; // uuid
  items?: Array<{
    id: string; // uuid
    quantity?: number; // integer, defaults to 1
  }>;
  experience?: number; // integer
  gold?: number; // integer
};

// Game Effects Types - camelCase version for DTO layer
export type GameEffectsDto = {
  relationship?: Record<string, number>; // {characterName: integer}
  unlockEvents?: string[]; // [uuid]
  unlockChapters?: string[]; // [uuid]
  unlockLocations?: string[]; // [uuid]
  unlockRegions?: string[]; // [uuid]
  partyJoin?: string; // uuid
  items?: Array<{
    id: string; // uuid
    quantity?: number; // integer, defaults to 1
  }>;
  experience?: number; // integer
  gold?: number; // integer
};

export interface EventOutcomeSchema {
  id: string;
  interaction_id: string;
  choice_key: string;
  title: string;
  description: string | null;
  outcome_type: string;
  effects: GameEffects;
  next_event_id: string | null;
}

export interface CompleteInteractionSchema {
  success: boolean;
  next_event_id?: string | null;
  effects?: GameEffects;
  choice_key?: string;
  auto_unlocked_locations?: string[];
  auto_unlocked_regions?: string[];
  event_outcome?: EventOutcomeSchema;
  error?: string;
}

export interface EventInteractionSchema {
  id: string;
  title: string;
  description: string;
  dialogue_text: string;
  character_speaker: string;
  character_avatar?: string;
  choices: Array<{
    id: string;
    text: string;
    type: string;
    description?: string;
  }>;
  interaction_type: string;
  is_available: boolean;
  requirements: Record<string, unknown>;
  display_order: number;
}

export interface WorldMapSchema {
  id: string;
  name: string;
  description: string;
  image_url: string;
  unlock_requirements: Record<string, unknown>;
  display_order: number;
  is_initial_user_progress: boolean;
  is_alway_hide_until_unlock: boolean;
  locations: LocationSchema[];
}

export interface LocationSchema {
  id: string;
  world_region_id: string;
  name: string;
  description: string;
  image_url: string;
  location_type: string;
  unlock_requirements: Record<string, unknown>;
  display_order: number;
  is_initial_user_progress: boolean;
  is_alway_hide_until_unlock: boolean;
}

export interface CompletedInteractionSchema {
  event_id: string;
  interaction_id: string;
  choice_key: string;
  completed_at: string;
}

export interface AvailableEventSchema {
  event_id: string;
  event_title: string;
  event_description: string;
  event_type: string;
  chapter_title: string;
  location_name: string;
  interactions_count: number;
}

export interface UserGameStateSchema {
  id: string;
  user_id: string;
  current_chapter_id: string | null;
  current_chapter_title: string;
  current_location_id: string | null;
  current_location_name: string;
  current_event_id: string | null;
  current_event_title: string;
  player_level: number;
  player_experience: number;
  unlocked_world_regions: string[];
  unlocked_locations: string[];
  unlocked_chapters: string[];
  unlocked_events: string[];
  completed_chapters: string[];
  completed_events: string[];
  completed_interactions: CompletedInteractionSchema[];
  inventory: InventoryEntrySchema[];
  party_members: PartyMemberSchema[];
  character_relationships: Record<string, unknown>;
  player_position: Record<string, unknown>;
  achievements: Record<string, unknown>[];
  play_history: Record<string, unknown>[];
  active_quests: Record<string, unknown>[];
  game_flags: Record<string, unknown>;
  game_stats: Record<string, unknown>;
  game_settings: Record<string, unknown>;
  save_data: Record<string, unknown>;
  last_played_at: string;
  created_at: string;
  updated_at: string;
}

export interface InitializeUserProgressSchema {
  id: string;
  user_id: string;
  current_chapter_id: string | null;
  current_location_id: string | null;
  current_event_id: string | null;
  player_level: number;
  player_experience: number;
  unlocked_world_regions: string[];
  unlocked_locations: string[];
  unlocked_chapters: string[];
  unlocked_events: string[];
  completed_chapters: string[];
  completed_events: string[];
  completed_interactions: CompletedInteractionSchema[];
  inventory: InventoryEntrySchema[];
  party_members: PartyMemberSchema[];
  character_relationships: Record<string, unknown>;
  player_position: Record<string, unknown>;
  game_flags: Record<string, unknown>;
  game_stats: Record<string, unknown>;
  last_played_at: string;
  created_at: string;
  updated_at: string;
}

export interface DeleteUserProgressSchema {
  success: boolean;
  deleted_records: number;
  message?: string;
  error?: string;
}

// DTO Types (mapped from schema for frontend use) - camelCase
export interface EventOutcomeDto {
  id: string;
  interactionId: string;
  choiceKey: string;
  title: string;
  description: string | null;
  outcomeType: string;
  effects: GameEffectsDto;
  nextEventId: string | null;
}

export interface CompleteInteractionDto {
  success: boolean;
  nextEventId?: string | null;
  effects?: GameEffectsDto;
  choiceKey?: string;
  autoUnlockedLocations?: string[];
  autoUnlockedRegions?: string[];
  eventOutcome?: EventOutcomeDto;
  error?: string;
}

export interface EventInteractionDto {
  id: string;
  title: string;
  description: string;
  dialogueText: string;
  characterSpeaker: string;
  characterAvatar?: string;
  choices: Array<{
    id: string;
    text: string;
    type: string;
    description?: string;
  }>;
  interactionType: string;
  isAvailable: boolean;
  requirements: Record<string, unknown>;
  displayOrder: number;
}

export interface WorldMapDto {
  id: string;
  name: string;
  description: string;
  imageUrl: string;
  unlockRequirements: Record<string, unknown>;
  displayOrder: number;
  isInitialUserProgress: boolean;
  isAlwayHideUntilUnlock: boolean;
  locations: LocationDto[];
}

export interface LocationDto {
  id: string;
  worldRegionId: string;
  name: string;
  description: string;
  imageUrl: string;
  locationType: string;
  unlockRequirements: Record<string, unknown>;
  displayOrder: number;
  isInitialUserProgress: boolean;
  isAlwayHideUntilUnlock: boolean;
}

export interface AvailableEventDto {
  eventId: string;
  eventTitle: string;
  eventDescription: string;
  eventType: string;
  chapterTitle: string;
  locationName: string;
  interactionsCount: number;
  chapterDisplayOrder: number;
  eventDisplayOrder: number;
}

export interface CompletedInteractionDto {
  eventId: string;
  interactionId: string;
  choiceKey: string;
  completedAt: string;
}

export interface UserGameStateDto {
  id: string;
  userId: string;
  currentChapterId: string | null;
  currentChapterTitle: string;
  currentLocationId: string | null;
  currentLocationName: string;
  currentEventId: string | null;
  currentEventTitle: string;
  playerLevel: number;
  playerExperience: number;
  unlockedWorldRegions: string[];
  unlockedLocations: string[];
  unlockedChapters: string[];
  unlockedEvents: string[];
  completedChapters: string[];
  completedEvents: string[];
  completedInteractions: CompletedInteractionDto[];
  inventory: InventoryEntryDto[];
  partyMembers: PartyMemberDto[];
  characterRelationships: Record<string, unknown>;
  playerPosition: Record<string, unknown>;
  achievements: Record<string, unknown>[];
  playHistory: Record<string, unknown>[];
  activeQuests: Record<string, unknown>[];
  gameFlags: Record<string, unknown>;
  gameStats: Record<string, unknown>;
  gameSettings: Record<string, unknown>;
  saveData: Record<string, unknown>;
  lastPlayedAt: string;
  createdAt: string;
  updatedAt: string;
}

export interface InitializeUserProgressDto {
  id: string;
  userId: string;
  currentChapterId: string | null;
  currentLocationId: string | null;
  currentEventId: string | null;
  playerLevel: number;
  playerExperience: number;
  unlockedWorldRegions: string[];
  unlockedLocations: string[];
  unlockedChapters: string[];
  unlockedEvents: string[];
  completedChapters: string[];
  completedEvents: string[];
  completedInteractions: CompletedInteractionDto[];
  inventory: InventoryEntryDto[];
  partyMembers: PartyMemberDto[];
  characterRelationships: Record<string, unknown>;
  playerPosition: Record<string, unknown>;
  gameFlags: Record<string, unknown>;
  gameStats: Record<string, unknown>;
  lastPlayedAt: string;
  createdAt: string;
  updatedAt: string;
}

export interface DeleteUserProgressDto {
  success: boolean;
  deletedRecords: number;
  message?: string;
  error?: string;
}

// Legacy RPC type aliases for backward compatibility
export type RpcEventOutcome = EventOutcomeSchema;
export type RpcCompleteInteractionResponse = CompleteInteractionSchema;
export type RpcEventInteractionResponse = EventInteractionSchema;
export type RpcWorldMapResponse = WorldMapSchema;
export type RpcLocationData = LocationSchema;
export type RpcAvailableEventResponse = AvailableEventSchema;
export interface CharacterData {
  id: string;
  name: string;
  description: string;
  character_type: string;
  avatar_url: string;
  stats: Record<string, number | string>;
  abilities: Array<{
    id: string;
    name: string;
    description: string;
    mp_cost: number;
  }>;
  join_requirements: Record<string, unknown>;
  is_joinable: boolean;
}

// Character Schema (snake_case from database)
export interface CharacterSchema {
  id: string;
  name: string;
  description: string;
  character_type: string;
  avatar_url: string;
  stats: Record<string, number | string>;
  abilities: Array<{
    id: string;
    name: string;
    description: string;
    mp_cost: number;
  }>;
  join_requirements: Record<string, unknown>;
  is_joinable: boolean;
}

// Character DTO (camelCase for frontend use)
export interface CharacterDto {
  id: string;
  name: string;
  description: string;
  characterType: string;
  avatarUrl: string;
  stats: Record<string, number | string>;
  abilities: Array<{
    id: string;
    name: string;
    description: string;
    mpCost: number;
  }>;
  joinRequirements: Record<string, unknown>;
  isJoinable: boolean;
}

// Inventory Entry Schema (snake_case from database)
export interface InventoryEntrySchema {
  slot: string | null;
  item_id: string;
  equipped: boolean;
  quantity: number;
  obtained_at: string;
}

// Item Schema (snake_case from database)
export interface ItemSchema {
  id: string;
  name: string;
  description: string | null;
  effects: Json | null;
  image_url: string | null;
  is_consumable: boolean | null;
  is_initial_user_progress: boolean | null;
  is_tradeable: boolean | null;
  item_type: string | null;
  rarity: string | null;
  stats: Json | null;
  created_at: string | null;
  updated_at: string | null;
}

// Item DTO (camelCase for frontend use)
export interface ItemDto {
  id: string;
  name: string;
  description: string | null;
  effects: Json | null;
  imageUrl: string | null;
  isConsumable: boolean | null;
  isInitialUserProgress: boolean | null;
  isTradeable: boolean | null;
  itemType: string | null;
  rarity: string | null;
  stats: Json | null;
  createdAt: string | null;
  updatedAt: string | null;
}

// Inventory Entry DTO (camelCase for frontend use)
export interface InventoryEntryDto {
  slot: string | null;
  itemId: string;
  equipped: boolean;
  quantity: number;
  obtainedAt: string;
  name: string;
  description: string;
  itemType: string;
  rarity: string;
  imageUrl: string;
}

export type RpcUserGameStateResponse = UserGameStateSchema;
export type RpcInitializeUserProgressResponse = InitializeUserProgressSchema;
