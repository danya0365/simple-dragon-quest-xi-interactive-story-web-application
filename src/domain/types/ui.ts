// UI Types for frontend components - all properties in camelCase
import { ChoiceType, EventType, InteractionType } from "./enums";

export interface EventInteractionUI {
  id: string;
  interactionType: InteractionType;
  title: string;
  description: string;
  dialogueText: string;
  characterSpeaker: string;
  characterAvatar?: string;
  choices: Array<{
    id: string;
    text: string;
    type: ChoiceType;
    description?: string;
  }>;
}

export interface WorldRegionUI {
  id: string;
  name: string;
  description: string;
  imageUrl: string;
  isUnlocked: boolean;
  locationsCount: number;
  unlockedLocationsCount: number;
}

export interface LocationUI {
  id: string;
  worldRegionId: string;
  name: string;
  description: string;
  locationType: string;
  imageUrl: string;
  isUnlocked: boolean;
}

export interface StoryEventUI {
  eventId: string;
  eventTitle: string;
  eventDescription: string;
  eventType: EventType;
  chapterTitle: string;
  locationName: string;
  interactionsCount: number;
}

export interface PartyMemberUI {
  characterId: string;
  name: string;
  description: string;
  avatarUrl: string;
  currentStats: Record<string, number | string>;
  equipment: Record<string, string | null>;
  partyPosition: number;
  joinedAt: string;
}

export interface InventoryItemUI {
  itemId: string;
  name: string;
  description: string;
  itemType: string;
  rarity: string;
  imageUrl: string;
  quantity: number;
  obtainedAt: string;
}

export interface CharacterMasterDataUI {
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

export interface UserGameStateUI {
  id: string;
  userId: string;
  currentWorldMapId: string | null;
  currentLocationId: string | null;
  currentChapterId: string | null;
  currentEventId: string | null;
  completedChapters: string[];
  completedEvents: string[];
  completedInteractions: CompletedInteractionUI[];
  unlockedWorldRegions: string[];
  unlockedLocations: string[];
  unlockedChapters: string[];
  unlockedEvents: string[];
  activeQuests: Record<string, string | number>[];
  gameFlags: Record<string, string | number>[];
  gameSettings: Record<string, string | number>[];
  gameStats: Record<string, string | number>;
  playerLevel: number;
  playerExperience: number;
  partyMembers: PartyMemberUI[];
  characterRelationships: Record<string, string | number>[];
  playerPosition: Record<string, string | number>;
  inventory: InventoryItemUI[];
  achievements: Record<string, string | number>[];
  playHistory: Record<string, string | number>[];
  lastPlayedAt: string;
}

export interface CompletedInteractionUI {
  eventId: string;
  interactionId: string;
  completedAt: string;
}
