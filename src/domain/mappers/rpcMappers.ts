import {
  AvailableEventSchema,
  CompletedInteractionSchema,
  CompleteInteractionSchema,
  DeleteUserProgressSchema,
  EventInteractionSchema,
  EventOutcomeSchema,
  InitializeUserProgressSchema,
  LocationSchema,
  UserGameStateSchema,
  WorldMapSchema,
} from "@/src/domain/types/rpc";

import {
  AvailableEventDto,
  CompleteInteractionDto,
  DeleteUserProgressDto,
  EventInteractionDto,
  EventOutcomeDto,
  InitializeUserProgressDto,
  LocationDto,
  UserGameStateDto,
  WorldMapDto,
} from "@/src/domain/types/rpc";

/**
 * Map EventOutcomeSchema to EventOutcomeDto
 * Converts snake_case properties to camelCase
 */
export const mapEventOutcomeToDto = (
  schema: EventOutcomeSchema
): EventOutcomeDto => {
  return {
    id: schema.id,
    interactionId: schema.interaction_id,
    choiceKey: schema.choice_key,
    title: schema.title,
    description: schema.description,
    outcomeType: schema.outcome_type,
    effects: schema.effects,
    nextEventId: schema.next_event_id,
  };
};

/**
 * Map CompleteInteractionSchema to CompleteInteractionDto
 * Converts snake_case properties to camelCase
 */
export const mapCompleteInteractionToDto = (
  schema: CompleteInteractionSchema
): CompleteInteractionDto => {
  return {
    success: schema.success,
    nextEventId: schema.next_event_id,
    effects: schema.effects,
    choiceKey: schema.choice_key,
    autoUnlockedLocations: schema.auto_unlocked_locations,
    autoUnlockedRegions: schema.auto_unlocked_regions,
    eventOutcome: schema.event_outcome
      ? mapEventOutcomeToDto(schema.event_outcome)
      : undefined,
    error: schema.error,
  };
};

/**
 * Map EventInteractionSchema to EventInteractionDto
 * Converts snake_case properties to camelCase
 */
export const mapEventInteractionToDto = (
  schema: EventInteractionSchema
): EventInteractionDto => {
  return {
    id: schema.id,
    title: schema.title,
    description: schema.description,
    dialogueText: schema.dialogue_text,
    characterSpeaker: schema.character_speaker,
    characterAvatar: schema.character_avatar,
    choices: schema.choices,
    interactionType: schema.interaction_type,
    isAvailable: schema.is_available,
    requirements: schema.requirements,
    displayOrder: schema.display_order,
  };
};

/**
 * Map LocationSchema to LocationDto
 * Converts snake_case properties to camelCase
 */
export const mapLocationToDto = (schema: LocationSchema): LocationDto => {
  return {
    id: schema.id,
    worldRegionId: schema.world_region_id,
    name: schema.name,
    description: schema.description,
    imageUrl: schema.image_url,
    locationType: schema.location_type,
    unlockRequirements: schema.unlock_requirements,
    displayOrder: schema.display_order,
    isInitialUserProgress: schema.is_initial_user_progress,
    isAlwayHideUntilUnlock: schema.is_alway_hide_until_unlock,
  };
};

/**
 * Map WorldMapSchema to WorldMapDto
 * Converts snake_case properties to camelCase
 */
export const mapWorldMapToDto = (schema: WorldMapSchema): WorldMapDto => {
  return {
    id: schema.id,
    name: schema.name,
    description: schema.description,
    imageUrl: schema.image_url,
    displayOrder: schema.display_order,
    isInitialUserProgress: schema.is_initial_user_progress,
    isAlwayHideUntilUnlock: schema.is_alway_hide_until_unlock,
    unlockRequirements: schema.unlock_requirements,
    locations: schema.locations.map(mapLocationToDto),
  };
};
/**
 * Map AvailableEventSchema to AvailableEventDto
 * Converts snake_case properties to camelCase
 */
export const mapAvailableEventToDto = (
  schema: AvailableEventSchema
): AvailableEventDto => {
  return {
    eventId: schema.event_id,
    eventTitle: schema.event_title,
    eventDescription: schema.event_description,
    eventType: schema.event_type,
    chapterTitle: schema.chapter_title,
    locationName: schema.location_name,
    interactionsCount: schema.interactions_count,
  };
};

/**
 * Map UserGameStateSchema to UserGameStateDto
 * Converts snake_case properties to camelCase
 */
export const mapUserGameStateToDto = (
  schema: UserGameStateSchema
): UserGameStateDto => {
  return {
    id: schema.id,
    userId: schema.user_id,
    currentChapterId: schema.current_chapter_id,
    currentChapterTitle: schema.current_chapter_title,
    currentLocationId: schema.current_location_id,
    currentLocationName: schema.current_location_name,
    currentEventId: schema.current_event_id,
    currentEventTitle: schema.current_event_title,
    playerLevel: schema.player_level,
    playerExperience: schema.player_experience,
    unlockedWorldRegions: schema.unlocked_world_regions,
    unlockedLocations: schema.unlocked_locations,
    unlockedChapters: schema.unlocked_chapters,
    unlockedEvents: schema.unlocked_events,
    completedChapters: schema.completed_chapters,
    completedEvents: schema.completed_events,
    completedInteractions: schema.completed_interactions.map(
      (interaction: CompletedInteractionSchema) => ({
        eventId: interaction.event_id,
        interactionId: interaction.interaction_id,
        completedAt: interaction.completed_at,
      })
    ),
    inventory: schema.inventory,
    partyMembers: schema.party_members,
    characterRelationships: schema.character_relationships,
    playerPosition: schema.player_position,
    achievements: schema.achievements,
    playHistory: schema.play_history,
    activeQuests: schema.active_quests,
    gameFlags: schema.game_flags,
    gameStats: schema.game_stats,
    gameSettings: schema.game_settings,
    saveData: schema.save_data,
    lastPlayedAt: schema.last_played_at,
    createdAt: schema.created_at,
    updatedAt: schema.updated_at,
  };
};

/**
 * Map InitializeUserProgressSchema to InitializeUserProgressDto
 * Converts snake_case properties to camelCase
 */
export const mapInitializeUserProgressToDto = (
  schema: InitializeUserProgressSchema
): InitializeUserProgressDto => {
  return {
    id: schema.id,
    userId: schema.user_id,
    currentChapterId: schema.current_chapter_id,
    currentLocationId: schema.current_location_id,
    currentEventId: schema.current_event_id,
    playerLevel: schema.player_level,
    playerExperience: schema.player_experience,
    unlockedWorldRegions: schema.unlocked_world_regions,
    unlockedLocations: schema.unlocked_locations,
    unlockedChapters: schema.unlocked_chapters,
    unlockedEvents: schema.unlocked_events,
    completedChapters: schema.completed_chapters,
    completedEvents: schema.completed_events,
    completedInteractions: schema.completed_interactions.map(
      (interaction: CompletedInteractionSchema) => ({
        eventId: interaction.event_id,
        interactionId: interaction.interaction_id,
        completedAt: interaction.completed_at,
      })
    ),
    inventory: schema.inventory,
    partyMembers: schema.party_members,
    characterRelationships: schema.character_relationships,
    playerPosition: schema.player_position,
    gameFlags: schema.game_flags,
    gameStats: schema.game_stats,
    lastPlayedAt: schema.last_played_at,
    createdAt: schema.created_at,
    updatedAt: schema.updated_at,
  };
};

/**
 * Map DeleteUserProgressSchema to DeleteUserProgressDto
 * Converts snake_case properties to camelCase
 */
export const mapDeleteUserProgressToDto = (
  schema: DeleteUserProgressSchema
): DeleteUserProgressDto => {
  return {
    success: schema.success,
    deletedRecords: schema.deleted_records,
    message: schema.message,
    error: schema.error,
  };
};
