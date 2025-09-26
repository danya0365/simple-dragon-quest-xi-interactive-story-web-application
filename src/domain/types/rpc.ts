// Database Schema Types (from RPC responses) - snake_case
export interface EventOutcomeSchema {
  id: string;
  interaction_id: string;
  choice_key: string;
  outcome_text: string;
  description: string | null;
  effects: Record<string, unknown>;
  next_event_id: string | null;
}

export interface CompleteInteractionSchema {
  success: boolean;
  next_event_id?: string | null;
  effects?: Record<string, unknown>;
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
  completed_interactions: Record<string, unknown>[];
  inventory: Record<string, unknown>[];
  party_members: Record<string, unknown>[];
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
  completed_interactions: Record<string, unknown>[];
  inventory: Record<string, unknown>[];
  party_members: Record<string, unknown>[];
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
  outcomeText: string;
  description: string | null;
  effects: Record<string, unknown>;
  nextEventId: string | null;
}

export interface CompleteInteractionDto {
  success: boolean;
  nextEventId?: string | null;
  effects?: Record<string, unknown>;
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
  completedInteractions: Record<string, unknown>[];
  inventory: Record<string, unknown>[];
  partyMembers: Record<string, unknown>[];
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
  completedInteractions: Record<string, unknown>[];
  inventory: Record<string, unknown>[];
  partyMembers: Record<string, unknown>[];
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

export type RpcUserGameStateResponse = UserGameStateSchema;
export type RpcInitializeUserProgressResponse = InitializeUserProgressSchema;
