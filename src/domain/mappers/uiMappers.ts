import {
  ChoiceType,
  EventType,
  InteractionType,
} from "@/src/domain/types/enums";
import {
  AvailableEventDto,
  CharacterDto,
  CompleteInteractionDto,
  EventInteractionDto,
  EventOutcomeDto,
  GameEffectsDto,
  ItemDto,
  LocationDto,
  StoryChapterDto,
  StoryEventDto,
  UserGameStateDto,
  WorldMapDto,
} from "@/src/domain/types/rpc";
import { Json } from "@/src/domain/types/supabase";
import {
  CompleteInteractionUI,
  EventInteractionUI,
  EventOutcomeUI,
  GameEffectsUI,
  InventoryItemUI,
  LocationUI,
  StoryEventUI,
  UserGameStateUI,
  WorldRegionUI,
} from "@/src/domain/types/ui";

/**
 * Convert Json stats to Record<string, number | string> format
 * Handles the conversion from Json type to UI-compatible stats format
 */
export const convertJsonStatsToRecord = (
  stats: Json | null | undefined
): Record<string, number | string> => {
  if (!stats) return {};

  // If stats is already an object with string keys and number/string values, return it directly
  if (typeof stats === "object" && stats !== null && !Array.isArray(stats)) {
    const result: Record<string, number | string> = {};
    for (const [key, value] of Object.entries(stats)) {
      if (typeof value === "number" || typeof value === "string") {
        result[key] = value;
      }
    }
    return result;
  }

  // For other cases (string, number, boolean, array), return empty object
  return {};
};

/**
 * Map EventInteractionDto to EventInteractionUI
 * Converts Dto properties to UI format (camelCase)
 */
export const mapEventInteractionDtoToUI = (
  dto: EventInteractionDto
): EventInteractionUI => {
  return {
    id: dto.id,
    interactionType: dto.interactionType as InteractionType,
    title: dto.title,
    description: dto.description,
    dialogueText: dto.dialogueText,
    characterSpeaker: dto.characterSpeaker,
    characterAvatar: dto.characterAvatar,
    choices: (dto.choices || []).map((choice) => ({
      ...choice,
      type: choice.type as ChoiceType,
    })),
  };
};

/**
 * Map array of EventInteractionDto to EventInteractionUI[]
 */
export const mapEventInteractionsDtoToUI = (
  dtos: EventInteractionDto[]
): EventInteractionUI[] => {
  return dtos.map(mapEventInteractionDtoToUI);
};

/**
 * Map WorldMapDto to WorldRegionUI
 * Converts WorldMap Dto to UI format for regions
 */
export const mapWorldMapDtoToUI = (dto: WorldMapDto): WorldRegionUI => {
  return {
    id: dto.id,
    name: dto.name,
    description: dto.description,
    imageUrl: dto.imageUrl,
    isUnlocked: false, // This will be set based on user game state
    locationsCount: dto.locations.length,
    unlockedLocationsCount: 0, // This will be calculated based on user game state
  };
};

/**
 * Map array of WorldMapDto to WorldRegionUI[]
 */
export const mapWorldMapsDtoToUI = (dtos: WorldMapDto[]): WorldRegionUI[] => {
  return dtos.map(mapWorldMapDtoToUI);
};

/**
 * Map AvailableEventDto to StoryEventUI
 * Converts AvailableEvent Dto to UI format for story events
 */
export const mapAvailableEventDtoToUI = (
  dto: AvailableEventDto
): StoryEventUI => {
  return {
    eventId: dto.eventId,
    eventTitle: dto.eventTitle,
    eventDescription: dto.eventDescription,
    eventType: dto.eventType as EventType,
    chapterTitle: dto.chapterTitle,
    locationName: dto.locationName,
    interactionsCount: dto.interactionsCount,
    chapterDisplayOrder: dto.chapterDisplayOrder,
    eventDisplayOrder: dto.eventDisplayOrder,
  };
};

/**
 * Map array of AvailableEventDto to StoryEventUI[]
 */
export const mapAvailableEventsDtoToUI = (
  dtos: AvailableEventDto[]
): StoryEventUI[] => {
  return dtos.map(mapAvailableEventDtoToUI);
};

/**
 * Map LocationDto to LocationUI
 * Converts Location Dto to UI format
 */
export const mapLocationDtoToUI = (dto: LocationDto): LocationUI => {
  return {
    id: dto.id,
    worldRegionId: dto.worldRegionId,
    name: dto.name,
    description: dto.description,
    locationType: dto.locationType,
    imageUrl: dto.imageUrl,
    isUnlocked: false, // This will be set based on user game state
  };
};

/**
 * Map array of LocationDto to LocationUI[]
 */
export const mapLocationsDtoToUI = (dtos: LocationDto[]): LocationUI[] => {
  return dtos.map(mapLocationDtoToUI);
};

/**
 * Map UserGameStateDto to UserGameStateUI
 * Converts UserGameState Dto to UI format with proper camelCase properties
 */
export const mapUserGameStateDtoToUI = (
  dto: UserGameStateDto
): UserGameStateUI => {
  return {
    id: dto.id,
    userId: dto.userId,
    currentWorldMapId: null, // Not provided by RPC, set to null
    currentLocationId: dto.currentLocationId,
    currentChapterId: dto.currentChapterId,
    currentEventId: dto.currentEventId,
    completedChapters: dto.completedChapters,
    completedEvents: dto.completedEvents,
    completedInteractions: dto.completedInteractions.map((item) => ({
      eventId: item.eventId,
      interactionId: item.interactionId,
      choiceKey: item.choiceKey,
      completedAt: item.completedAt,
    })),
    unlockedWorldRegions: dto.unlockedWorldRegions,
    unlockedLocations: dto.unlockedLocations,
    unlockedChapters: dto.unlockedChapters,
    unlockedEvents: dto.unlockedEvents,
    activeQuests: dto.activeQuests as unknown as Record<
      string,
      string | number
    >[],
    gameFlags: dto.gameFlags as unknown as Record<string, string | number>[],
    gameSettings: dto.gameSettings as unknown as Record<
      string,
      string | number
    >[],
    gameStats: dto.gameStats as unknown as Record<string, string | number>,
    playerLevel: dto.playerLevel,
    playerExperience: dto.playerExperience,
    partyMembers: dto.partyMembers.map((member) => ({
      name: "",
      description: "",
      avatarUrl: "",
      isActive: member.isActive,
      joinedAt: member.joinedAt,
      characterId: member.characterId,
      currentStats: member.currentStats,
      partyPosition: member.partyPosition,
      equipment: {
        weapon: {
          id: member.equipment.weapon,
          name: "",
          description: "",
          itemType: "",
          rarity: "",
          stats: {},
          imageUrl: "",
        },
        armor: {
          id: member.equipment.armor,
          name: "",
          description: "",
          itemType: "",
          rarity: "",
          stats: {},
          imageUrl: "",
        },
        accessory: {
          id: member.equipment.accessory,
          name: "",
          description: "",
          itemType: "",
          rarity: "",
          stats: {},
          imageUrl: "",
        },
      },
    })),
    characterRelationships: dto.characterRelationships as unknown as Record<
      string,
      string | number
    >[],
    playerPosition: dto.playerPosition as unknown as Record<
      string,
      string | number
    >,
    inventory: (dto.inventory as unknown as InventoryItemUI[]) || [],
    achievements: dto.achievements as unknown as Record<
      string,
      string | number
    >[],
    playHistory: dto.playHistory as unknown as Record<
      string,
      string | number
    >[],
    lastPlayedAt: dto.lastPlayedAt,
  };
};

/**
 * Map CompleteInteractionDto to CompleteInteractionUI
 * Converts database schema format to UI-friendly format
 */
export const mapCompleteInteractionToUI = (
  schema: CompleteInteractionDto,
  masterItems?: ItemDto[],
  masterCharacters?: CharacterDto[],
  worldRegions?: WorldRegionUI[],
  allLocations?: LocationUI[],
  masterEvents?: StoryEventDto[],
  masterChapters?: StoryChapterDto[]
): CompleteInteractionUI => {
  return {
    success: schema.success,
    nextEventId: schema.nextEventId,
    effects: schema.effects
      ? mapGameEffectsToUI(
          schema.effects,
          masterItems,
          masterCharacters,
          worldRegions,
          allLocations,
          masterEvents,
          masterChapters
        )
      : undefined,
    choiceKey: schema.choiceKey,
    autoUnlockedLocations: schema.autoUnlockedLocations,
    autoUnlockedRegions: schema.autoUnlockedRegions,
    eventOutcome: schema.eventOutcome
      ? mapEventOutcomeDtoToUI(
          schema.eventOutcome,
          masterItems,
          masterCharacters,
          worldRegions,
          allLocations,
          masterEvents,
          masterChapters
        )
      : undefined,
    error: schema.error,
  };
};

/**
 * Map GameEffects (snake_case from RPC) to GameEffectsUI (camelCase for UI)
 * Converts database schema format to UI-friendly format
 */
export const mapGameEffectsToUI = (
  effects: GameEffectsDto,
  masterItems?: ItemDto[],
  masterCharacters?: CharacterDto[],
  worldRegions?: WorldRegionUI[],
  allLocations?: LocationUI[],
  masterEvents?: StoryEventDto[],
  masterChapters?: StoryChapterDto[]
): GameEffectsUI => {
  // Enrich items with master data if available
  const enrichedItems = effects.items?.map((item) => {
    const masterItem = masterItems?.find((mi) => mi.id === item.id);
    return {
      id: item.id,
      name: masterItem?.name || item.id, // Fallback to ID if name not found
      description: masterItem?.description,
      itemType: masterItem?.itemType || "",
      rarity: masterItem?.rarity || "",
      imageUrl: masterItem?.imageUrl || "",
      quantity: item.quantity,
    };
  });

  // Enrich party joins with master character data if available
  const enrichedPartyJoins = effects.partyJoins?.map((characterId) => {
    const masterCharacter = masterCharacters?.find(
      (mc) => mc.id === characterId
    );
    return {
      id: characterId,
      name: masterCharacter?.name || characterId, // Fallback to ID if name not found
      description: masterCharacter?.description || "",
      characterType: masterCharacter?.characterType || "",
      avatarUrl: masterCharacter?.avatarUrl || "",
    };
  });

  // Enrich unlock regions with world region data if available
  const enrichedUnlockRegions = effects.unlockRegions?.map((regionId) => {
    const worldRegion = worldRegions?.find((wr) => wr.id === regionId);
    return {
      id: regionId,
      name: worldRegion?.name || regionId, // Fallback to ID if name not found
      description: worldRegion?.description || "",
      imageUrl: worldRegion?.imageUrl || "",
      locationsCount: worldRegion?.locationsCount || 0,
      unlockedLocationsCount: worldRegion?.unlockedLocationsCount || 0,
    };
  });

  // Enrich unlock locations with location data if available
  const enrichedUnlockLocations = effects.unlockLocations?.map((locationId) => {
    const location = allLocations?.find((loc) => loc.id === locationId);
    const worldRegion = worldRegions?.find(
      (wr) => wr.id === location?.worldRegionId
    );
    return {
      id: locationId,
      name: location?.name || locationId, // Fallback to ID if name not found
      description: location?.description || "",
      locationType: location?.locationType || "",
      imageUrl: location?.imageUrl || "",
      worldRegionId: location?.worldRegionId || "",
      worldRegionName: worldRegion?.name,
    };
  });

  // Enrich unlock events with master event data if available
  const enrichedUnlockEvents = effects.unlockEvents?.map((eventId) => {
    const masterEvent = masterEvents?.find((me) => me.id === eventId);
    return {
      id: eventId,
      title: masterEvent?.title || eventId, // Fallback to ID if title not found
      description: masterEvent?.description || "",
      eventType: masterEvent?.eventType || "",
      chapterId: masterEvent?.chapterId || "",
      locationId: masterEvent?.locationId || "",
    };
  });

  // Enrich unlock chapters with master chapter data if available
  const enrichedUnlockChapters = effects.unlockChapters?.map((chapterId) => {
    const masterChapter = masterChapters?.find((mc) => mc.id === chapterId);
    return {
      id: chapterId,
      chapterNumber: masterChapter?.chapterNumber || 0,
      title: masterChapter?.title || chapterId, // Fallback to ID if title not found
      description: masterChapter?.description || "",
      displayOrder: masterChapter?.displayOrder || 0,
    };
  });

  return {
    relationship: effects.relationship,
    unlockEvents: enrichedUnlockEvents,
    unlockChapters: enrichedUnlockChapters,
    unlockLocations: enrichedUnlockLocations,
    unlockRegions: enrichedUnlockRegions,
    partyJoins: enrichedPartyJoins,
    items: enrichedItems,
    experience: effects.experience,
    gold: effects.gold,
  };
};

/**
 * Map EventOutcomeDto to EventOutcomeUI
 * Since DTO is already in camelCase, this is mainly for type safety
 */
export const mapEventOutcomeDtoToUI = (
  dto: EventOutcomeDto,
  masterItems?: ItemDto[],
  masterCharacters?: CharacterDto[],
  worldRegions?: WorldRegionUI[],
  allLocations?: LocationUI[],
  masterEvents?: StoryEventDto[],
  masterChapters?: StoryChapterDto[]
): EventOutcomeUI => {
  return {
    id: dto.id,
    interactionId: dto.interactionId,
    choiceKey: dto.choiceKey,
    title: dto.title,
    description: dto.description,
    outcomeType: dto.outcomeType,
    effects: dto.effects
      ? mapGameEffectsToUI(
          dto.effects,
          masterItems,
          masterCharacters,
          worldRegions,
          allLocations,
          masterEvents,
          masterChapters
        )
      : undefined,
    nextEventId: dto.nextEventId,
  };
};
