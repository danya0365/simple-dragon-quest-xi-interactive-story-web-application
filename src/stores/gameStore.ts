import {
  mapAvailableEventToDto,
  mapCharacterToDto,
  mapCompleteInteractionToDto,
  mapDeleteUserProgressToDto,
  mapEventInteractionToDto,
  mapInitializeUserProgressToDto,
  mapItemToDto,
  mapStoryChapterToDto,
  mapStoryEventToDto,
  mapUserGameStateToDto,
  mapWorldMapToDto,
} from "@/src/domain/mappers/rpcMappers";
import {
  convertJsonStatsToRecord,
  mapAvailableEventDtoToUI,
  mapCompleteInteractionToUI,
  mapEventInteractionDtoToUI,
  mapUserGameStateDtoToUI,
} from "@/src/domain/mappers/uiMappers";
import {
  AvailableEventSchema,
  CharacterDto,
  CharacterSchema,
  CompleteInteractionSchema,
  DeleteUserProgressDto,
  DeleteUserProgressSchema,
  EventInteractionDto,
  EventInteractionSchema,
  InitializeUserProgressSchema,
  ItemDto,
  ItemSchema,
  LocationDto,
  StoryChapterDto,
  StoryChapterSchema,
  StoryEventDto,
  StoryEventSchema,
  UserGameStateDto,
  UserGameStateSchema,
  WorldMapDto,
  WorldMapSchema,
} from "@/src/domain/types/rpc";
import { Json } from "@/src/domain/types/supabase";
import { createClientSupabaseClient } from "@/src/infrastructure/config/supabase-client-client";
import { create } from "zustand";
import { persist } from "zustand/middleware";

// Import UI types for frontend components
import type {
  CompleteInteractionUI,
  EventInteractionUI,
  InventoryItemUI,
  LocationUI,
  PartyMemberUI,
  StoryEventUI,
  UserGameStateUI,
  WorldRegionUI,
} from "@/src/domain/types/ui";

// Mapping function to convert EventInteractionDto to EventInteractionUI
const mapEventInteractionsResponseToEventInteractions = (
  responses: EventInteractionDto[]
): EventInteractionUI[] => {
  return responses.map((response) => mapEventInteractionDtoToUI(response));
};

// Mapping function to convert UserGameStateDto to UserGameStateUI
function mapUserGameStateResponseToUserGameState(
  response: UserGameStateDto
): UserGameStateUI {
  return mapUserGameStateDtoToUI(response);
}

// Export UI types for backward compatibility
export type EventInteraction = EventInteractionUI;
export type WorldRegion = WorldRegionUI;
export type Location = LocationUI;
export type StoryEvent = StoryEventUI;
export type PartyMember = PartyMemberUI;
export type InventoryItem = InventoryItemUI;
export type UserGameState = UserGameStateUI;

// Game view types for better type safety and maintainability
export type GameView =
  | "world_map"
  | "location"
  | "event"
  | "event_interaction"
  | "available_event"
  | "completed_event"
  | "completed_event_detail"
  | "inventory"
  | "party";

interface GameState {
  // World and location data
  worldRegions: WorldRegionUI[];
  currentLocation: LocationUI | null;
  allLocations: LocationUI[];
  availableLocations: LocationUI[];
  availableEvents: StoryEventUI[];
  completedEvents: StoryEventUI[];

  // User progress
  userGameState: UserGameStateUI | null;
  userProgressId: string | null;

  // Master data cache
  masterCharacters: CharacterDto[];
  masterItems: ItemDto[];
  masterChapters: StoryChapterDto[];
  masterEvents: StoryEventDto[];
  masterDataLoaded: boolean;

  // UI state
  loading: boolean;
  error: string | null;
  currentView: GameView;
  selectedRegionId: string | null;
  selectedLocationId: string | null;
  selectedEventId: string | null;
}

interface GameActions {
  // Data loading
  loadWorldMap: () => Promise<void>;
  loadLocationsForRegion: (regionId: string) => Promise<void>;
  loadAvailableEvents: (locationId: string) => Promise<void>;
  loadAvailableEventsForUserProgress: () => Promise<void>;
  loadCompletedEventsForUserProgress: () => Promise<void>;
  loadUserGameState: (userProgressId?: string) => Promise<void>;
  loadEventInteractions: (
    eventId: string
  ) => Promise<EventInteraction[] | null>;
  completeInteraction: (
    interactionId: string,
    choiceData?: Json
  ) => Promise<CompleteInteractionUI>;
  initializeUserProgress: (userId: string) => Promise<void>;
  deleteUserProgress: (userId: string) => Promise<DeleteUserProgressDto>;
  loadUserInventory: () => Promise<void>;
  loadCharacters: () => Promise<void>;

  // Master data loading
  loadMasterData: () => Promise<void>;
  ensureMasterDataLoaded: () => Promise<void>;

  // Helper functions
  isLocationUnlocked: (locationId: string) => boolean;

  // Navigation
  setCurrentView: (view: GameView) => void;
  setSelectedRegion: (regionId: string | null) => void;
  setSelectedLocationId: (locationId: string | null) => void;
  setSelectedEventId: (eventId: string | null) => void;
  setCurrentLocation: (location: Location | null) => void;

  // State management
  setLoading: (loading: boolean) => void;
  setError: (error: string | null) => void;
  reset: () => void;
}

type GameStore = GameState & GameActions;

export const useGameStore = create<GameStore>()(
  persist(
    (set, get) => ({
      // Initial state
      worldRegions: [],
      currentLocation: null,
      allLocations: [],
      availableLocations: [],
      availableEvents: [],
      completedEvents: [],
      userGameState: null,
      userProgressId: null,
      masterCharacters: [],
      masterItems: [],
      masterChapters: [],
      masterEvents: [],
      masterDataLoaded: false,
      loading: false,
      error: null,
      currentView: "world_map",
      selectedRegionId: null,
      selectedLocationId: null,
      selectedEventId: null,

      // Actions
      loadWorldMap: async () => {
        const { userGameState } = get();
        if (!userGameState) {
          set({ error: "ไม่พบข้อมูลผู้เล่น" });
          return;
        }
        set({ loading: true, error: null });
        const supabase = createClientSupabaseClient();

        try {
          // Get all world maps and locations (complete catalog)
          const { data: allWorldMapsData, error: allMapsError } =
            await supabase.rpc("get_world_regions");

          if (allMapsError) throw allMapsError;

          const allWorldMapsSchemas =
            allWorldMapsData as unknown as WorldMapSchema[];
          const allWorldMaps = allWorldMapsSchemas.map(mapWorldMapToDto);

          // Use unlocked data from userGameState
          const unlockedWorldMapIds = new Set(
            userGameState.unlockedWorldRegions
          );
          const unlockedLocationIds = new Set(userGameState.unlockedLocations);

          // Extract all locations data
          const allLocationsData = allWorldMaps.flatMap(
            (worldMap: WorldMapDto) =>
              worldMap.locations.map((location: LocationDto) => ({
                id: location.id,
                worldRegionId: location.worldRegionId,
                name: location.name,
                description: location.description,
                imageUrl: location.imageUrl,
                locationType: location.locationType,
                unlockRequirements: location.unlockRequirements,
                displayOrder: location.displayOrder,
                isInitialUserProgress: location.isInitialUserProgress,
                isAlwayHideUntilUnlock: location.isAlwayHideUntilUnlock,
                isUnlocked: unlockedLocationIds.has(location.id),
              }))
          );

          // Transform the data to match our WorldRegionUI interface
          const transformedData = allWorldMaps.map((worldMap: WorldMapDto) => {
            const isWorldMapUnlocked = unlockedWorldMapIds.has(worldMap.id);
            const unlockedLocationsInMap = worldMap.locations.filter(
              (loc: LocationDto) => unlockedLocationIds.has(loc.id)
            );

            return {
              id: worldMap.id,
              name: worldMap.name,
              description: worldMap.description,
              imageUrl: worldMap.imageUrl,
              isUnlocked: isWorldMapUnlocked,
              locationsCount: worldMap.locations.length,
              unlockedLocationsCount: unlockedLocationsInMap.length,
            };
          });

          set({
            worldRegions: transformedData,
            allLocations: allLocationsData,
            loading: false,
          });
        } catch (err) {
          console.error("Error loading world map:", err);
          set({
            error: "ไม่สามารถโหลดแผนที่โลกได้",
            loading: false,
          });
        }
      },

      loadLocationsForRegion: async (regionId: string) => {
        const { userGameState, allLocations } = get();
        if (!userGameState) {
          set({ error: "ไม่พบข้อมูลผู้เล่น" });
          return;
        }

        set({ loading: true, error: null });

        try {
          // Filter locations for the selected region from allLocations data
          const unlockedLocationIds = new Set(userGameState.unlockedLocations);
          const availableLocations = allLocations
            .filter((location) => location.worldRegionId === regionId)
            .filter((location) => unlockedLocationIds.has(location.id))
            .map((location) => ({
              id: location.id,
              worldRegionId: location.worldRegionId,
              name: location.name,
              description: location.description,
              locationType: location.locationType,
              imageUrl: location.imageUrl || "",
              isUnlocked: true, // Since we filtered by unlocked locations
            }));

          set({
            availableLocations,
            loading: false,
          });
        } catch (err) {
          console.error("Error loading locations:", err);
          set({
            error: "ไม่สามารถโหลดสถานที่ได้",
            loading: false,
          });
        }
      },

      // Helper function to check if a location is unlocked
      isLocationUnlocked: (locationId: string) => {
        const { userGameState } = get();
        if (!userGameState) return false;
        return userGameState.unlockedLocations.includes(locationId);
      },

      loadAvailableEvents: async (locationId: string) => {
        const { userGameState } = get();
        if (!userGameState) {
          set({ error: "ไม่พบข้อมูลผู้เล่น" });
          return;
        }
        const userProgressId = userGameState.id;
        set({ loading: true, error: null });
        const supabase = createClientSupabaseClient();

        try {
          const { data, error } = await supabase.rpc(
            "get_available_events_for_location",
            {
              p_user_progress_uuid: userProgressId,
              p_location_uuid: locationId,
            }
          );

          if (error) throw error;

          const availableEventsSchemas =
            data as unknown as AvailableEventSchema[];
          const newAvailableEvents = availableEventsSchemas.map(
            mapAvailableEventToDto
          );

          // Map AvailableEventDto to StoryEventUI using UI mapper
          const mappedEvents = newAvailableEvents.map(mapAvailableEventDtoToUI);

          set({
            availableEvents: mappedEvents,
            loading: false,
          });
        } catch (err) {
          console.error("Error loading available events:", err);
          set({
            error: "ไม่สามารถโหลดเหตุการณ์ได้",
            loading: false,
          });
        }
      },

      loadAvailableEventsForUserProgress: async () => {
        const { userGameState } = get();
        if (!userGameState) {
          set({ error: "ไม่พบข้อมูลผู้เล่น" });
          return;
        }
        const userProgressId = userGameState.id;
        set({ loading: true, error: null });
        const supabase = createClientSupabaseClient();

        try {
          const { data, error } = await supabase.rpc(
            "get_available_events_for_user_progress",
            {
              p_user_progress_uuid: userProgressId,
            }
          );

          if (error) throw error;

          const availableEventsSchemas =
            data as unknown as AvailableEventSchema[];
          const newAvailableEvents = availableEventsSchemas.map(
            mapAvailableEventToDto
          );

          // Map AvailableEventDto to StoryEventUI using UI mapper
          const mappedEvents = newAvailableEvents.map(mapAvailableEventDtoToUI);

          set({
            availableEvents: mappedEvents,
            loading: false,
          });
        } catch (err) {
          console.error(
            "Error loading available events for user progress:",
            err
          );
          set({
            error: "ไม่สามารถโหลดเหตุการณ์ที่มีได้",
            loading: false,
          });
        }
      },

      loadCompletedEventsForUserProgress: async () => {
        const { userGameState } = get();
        if (!userGameState) {
          set({ error: "ไม่พบข้อมูลผู้เล่น" });
          return;
        }
        const userProgressId = userGameState.id;
        set({ loading: true, error: null });
        const supabase = createClientSupabaseClient();

        try {
          const { data, error } = await supabase.rpc(
            "get_completed_events_for_user_progress",
            {
              p_user_progress_uuid: userProgressId,
            }
          );

          if (error) throw error;

          const completedEventsSchemas =
            data as unknown as AvailableEventSchema[];
          const newCompletedEvents = completedEventsSchemas.map(
            mapAvailableEventToDto
          );

          // Map AvailableEventDto to StoryEventUI using UI mapper
          const mappedEvents = newCompletedEvents.map(mapAvailableEventDtoToUI);

          set({
            completedEvents: mappedEvents,
            loading: false,
          });
        } catch (err) {
          console.error(
            "Error loading completed events for user progress:",
            err
          );
          set({
            error: "ไม่สามารถโหลดเหตุการณ์ที่ทำเสร็จแล้ว",
            loading: false,
          });
        }
      },

      loadUserGameState: async (userProgressId?: string) => {
        // If no userProgressId provided, try to get it from userGameState
        const { userGameState } = get();
        const progressId = userProgressId || userGameState?.id;

        if (!progressId) {
          set({ error: "ไม่พบข้อมูลผู้เล่น" });
          return;
        }
        set({ loading: true, error: null });
        const supabase = createClientSupabaseClient();

        try {
          const { data, error } = await supabase.rpc(
            "get_user_game_state_for_user_progress",
            {
              p_user_progress_uuid: progressId,
            }
          );

          if (error) throw error;

          const userGameStateSchema = data as unknown as UserGameStateSchema;
          const userGameStateDto = mapUserGameStateToDto(userGameStateSchema);
          const mappedUserGameState =
            mapUserGameStateResponseToUserGameState(userGameStateDto);

          set({
            userGameState: mappedUserGameState,
            loading: false,
          });
        } catch (err) {
          console.error("Error loading user game state:", err);

          // Check if we should initialize user progress (only once)
          const state = get();
          if (
            !state.userGameState &&
            !state.error?.includes("กำลังสร้างข้อมูลผู้เล่นใหม่")
          ) {
            try {
              // Get current user ID from auth
              const {
                data: { user },
                error: authError,
              } = await supabase.auth.getUser();
              if (authError || !user) {
                throw new Error("ไม่พบข้อมูลผู้ใช้");
              }

              // Initialize user progress
              await get().initializeUserProgress(user.id);
              return; // Exit after initialization
            } catch (initError) {
              console.error("Error initializing user progress:", initError);
              set({
                error: "ไม่สามารถโหลดสถานะเกมได้ กำลังสร้างข้อมูลผู้เล่นใหม่",
                loading: false,
              });
            }
          } else {
            set({
              error: "ไม่สามารถโหลดสถานะเกมได้",
              loading: false,
            });
          }
        }
      },

      loadEventInteractions: async (eventId: string) => {
        const { userGameState } = get();
        if (!userGameState) {
          set({ error: "ไม่พบข้อมูลผู้เล่น" });
          return null;
        }
        const userProgressId = userGameState.id;
        set({ loading: true, error: null });
        const supabase = createClientSupabaseClient();

        try {
          const { data, error } = await supabase.rpc(
            "get_event_interactions_for_user_progress",
            {
              p_user_progress_uuid: userProgressId,
              p_event_uuid: eventId,
            }
          );

          if (error) throw error;

          // API returns array of interactions directly
          const rpcResponseSchemas =
            data as unknown as EventInteractionSchema[];
          const rpcResponseDtos = rpcResponseSchemas.map(
            mapEventInteractionToDto
          );

          // Map the response to frontend format
          const mappedInteractions =
            mapEventInteractionsResponseToEventInteractions(rpcResponseDtos);

          set({ loading: false });
          return mappedInteractions;
        } catch (err: unknown) {
          console.error("Error loading event interactions:", err);
          set({
            error: "ไม่สามารถโหลดการโต้ตอบได้",
            loading: false,
          });
          return null;
        }
      },

      completeInteraction: async (interactionId: string, choiceData?: Json) => {
        const { userGameState, ensureMasterDataLoaded } = get();
        if (!userGameState) {
          set({ error: "ไม่พบข้อมูลผู้เล่น" });
          return {
            success: false,
            error: "ไม่พบข้อมูลผู้เล่น",
          };
        }
        await ensureMasterDataLoaded();
        const userProgressId = userGameState.id;
        set({ loading: true, error: null });
        const supabase = createClientSupabaseClient();

        try {
          const { data, error } = await supabase.rpc(
            "complete_interaction_for_user_progress",
            {
              p_user_progress_uuid: userProgressId,
              p_interaction_uuid: interactionId,
              p_choice_data: choiceData || null,
            }
          );

          if (error) throw error;

          const resultSchema = data as unknown as CompleteInteractionSchema;
          const resultDto = mapCompleteInteractionToDto(resultSchema);
          const { masterItems, masterCharacters, worldRegions, allLocations, masterEvents, masterChapters } =
            get();
          const resultUI = mapCompleteInteractionToUI(
            resultDto,
            masterItems,
            masterCharacters,
            worldRegions,
            allLocations,
            masterEvents,
            masterChapters
          );

          if (resultDto.success && !resultDto.error) {
            // Reload game state after successful interaction
            await get().loadUserGameState();

            set({ loading: false });
            return resultUI;
          } else {
            set({ loading: false });
            return resultUI;
          }
        } catch (err) {
          console.error("Error completing interaction:", err);
          set({
            error: "ไม่สามารถดำเนินการโต้ตอบได้",
            loading: false,
          });
          return {
            success: false,
            error:
              err instanceof Error
                ? err.message
                : "ไม่สามารถดำเนินการโต้ตอบได้",
          };
        }
      },

      setSelectedLocationId: (locationId: string | null) => {
        set({ selectedLocationId: locationId });
      },

      setSelectedLocation: (location: Location | null) => {
        set({ currentLocation: location });
      },

      setSelectedEventId: (eventId: string | null) => {
        set({ selectedEventId: eventId });
      },

      setCurrentView: (view: GameView) => {
        set({ currentView: view });
      },

      setSelectedRegion: (regionId: string | null) => {
        set({ selectedRegionId: regionId });
      },

      setCurrentLocation: (location: Location | null) => {
        set({ currentLocation: location });
      },

      setLoading: (loading: boolean) => {
        set({ loading });
      },

      setError: (error: string | null) => {
        set({ error });
      },

      reset: () => {
        set({
          worldRegions: [],
          currentLocation: null,
          allLocations: [],
          availableLocations: [],
          availableEvents: [],
          completedEvents: [],
          userGameState: null,
          userProgressId: null,
          loading: false,
          error: null,
          currentView: "world_map",
          selectedRegionId: null,
          selectedLocationId: null,
          selectedEventId: null,
        });
      },

      initializeUserProgress: async (userId: string) => {
        const supabase = createClientSupabaseClient();

        try {
          // Call the initialize_user_progress function
          const { data, error } = await supabase.rpc(
            "initialize_user_progress",
            {
              p_user_uuid: userId,
            }
          );

          if (error) {
            console.error("Error initializing user progress:", error);
            throw error;
          }

          if (data) {
            // Extract the user progress ID from the response
            const responseSchema =
              data as unknown as InitializeUserProgressSchema;
            const responseDto = mapInitializeUserProgressToDto(responseSchema);
            if (responseDto.id) {
              // Load the complete user game state after initialization
              await get().loadUserGameState(responseDto.id);
            }
          }
        } catch (error) {
          console.error("Error calling initialize_user_progress:", error);
          throw error;
        }
      },

      deleteUserProgress: async (userId: string) => {
        const supabase = createClientSupabaseClient();

        try {
          // Call the delete_user_progress function
          const { data, error } = await supabase.rpc("delete_user_progress", {
            p_user_uuid: userId,
          });

          if (error) {
            console.error("Error deleting user progress:", error);
            throw error;
          }

          if (data) {
            // Extract the response data
            const responseSchema = data as unknown as DeleteUserProgressSchema;
            const responseDto = mapDeleteUserProgressToDto(responseSchema);

            // Reset the game state in the store
            get().reset();

            return responseDto;
          }

          throw new Error("No data returned from delete_user_progress");
        } catch (error) {
          console.error("Error calling delete_user_progress:", error);
          throw error;
        }
      },

      loadUserInventory: async () => {
        const { ensureMasterDataLoaded } = get();
        set({ loading: true, error: null });

        try {
          await ensureMasterDataLoaded();

          const { masterItems } = get();

          // Use cached master data instead of making API call
          const itemDtos = masterItems;

          // Update user game state with inventory
          const { userGameState } = get();
          if (userGameState) {
            // Map items with userGameState inventory to get actual quantities and data
            const userInventory = userGameState.inventory;

            const inventoryItems = itemDtos
              .map((item) => {
                const userItem = userInventory.find(
                  (ui) => ui.itemId === item.id
                );
                return {
                  itemId: item.id,
                  name: item.name || "",
                  description: item.description || "",
                  itemType: item.itemType || "",
                  rarity: item.rarity || "",
                  imageUrl: item.imageUrl || "",
                  quantity: userItem?.quantity || 0,
                  obtainedAt: userItem?.obtainedAt || new Date().toISOString(),
                  equipped: userItem?.equipped || false,
                  slot: userItem?.slot || null,
                };
              })
              .filter((item) => item.quantity > 0); // Only show items user actually has

            set({
              userGameState: {
                ...userGameState,
                inventory: inventoryItems,
              },
            });
          }

          set({ loading: false });
        } catch (err) {
          console.error("Error loading inventory:", err);
          set({
            error: "ไม่สามารถโหลดข้อมูลไอเทมได้",
            loading: false,
          });
        }
      },

      loadCharacters: async () => {
        const { ensureMasterDataLoaded } = get();
        set({ loading: true, error: null });

        try {
          await ensureMasterDataLoaded();

          const { masterCharacters, masterItems } = get();
          // Use cached master data instead of making API calls
          const characterDtos = masterCharacters;
          const itemDtos = masterItems;

          // Update user game state with character master data
          const { userGameState } = get();
          if (userGameState) {
            // Get existing party members from user game state
            const existingPartyMembers = userGameState.partyMembers;

            // Enrich party members with character master data
            const enrichedPartyMembers = existingPartyMembers.map(
              (partyMember) => {
                const masterCharacter = characterDtos.find(
                  (c) => c.id === partyMember.characterId
                );
                const masterWeapon = itemDtos.find(
                  (c) => c.id === partyMember.equipment.weapon.id
                );
                const masterArmor = itemDtos.find(
                  (c) => c.id === partyMember.equipment.armor.id
                );
                const masterAccessory = itemDtos.find(
                  (c) => c.id === partyMember.equipment.accessory.id
                );
                return {
                  characterId: partyMember.characterId,
                  name:
                    masterCharacter?.name ||
                    partyMember.name ||
                    "Unknown Character",
                  description:
                    masterCharacter?.description ||
                    partyMember.description ||
                    "No description available",
                  avatarUrl:
                    masterCharacter?.avatarUrl ||
                    partyMember.avatarUrl ||
                    "/placeholder-avatar.png",
                  currentStats: partyMember.currentStats,
                  equipment: {
                    weapon: {
                      id: masterWeapon?.id || "",
                      name: masterWeapon?.name || "",
                      description: masterWeapon?.description || "",
                      itemType: masterWeapon?.itemType || "",
                      rarity: masterWeapon?.rarity || "",
                      stats: convertJsonStatsToRecord(masterWeapon?.stats),
                      imageUrl: masterWeapon?.imageUrl || "",
                    },
                    armor: {
                      id: masterArmor?.id || "",
                      name: masterArmor?.name || "",
                      description: masterArmor?.description || "",
                      itemType: masterArmor?.itemType || "",
                      rarity: masterArmor?.rarity || "",
                      stats: convertJsonStatsToRecord(masterArmor?.stats),
                      imageUrl: masterArmor?.imageUrl || "",
                    },
                    accessory: {
                      id: masterAccessory?.id || "",
                      name: masterAccessory?.name || "",
                      description: masterAccessory?.description || "",
                      itemType: masterAccessory?.itemType || "",
                      rarity: masterAccessory?.rarity || "",
                      stats: convertJsonStatsToRecord(masterAccessory?.stats),
                      imageUrl: masterAccessory?.imageUrl || "",
                    },
                  },
                  partyPosition: partyMember.partyPosition,
                  joinedAt: partyMember.joinedAt,
                };
              }
            );

            set({
              userGameState: {
                ...userGameState,
                partyMembers: enrichedPartyMembers,
              },
            });
          }

          set({ loading: false });
        } catch (err) {
          console.error("Error loading characters:", err);
          set({
            error: "ไม่สามารถโหลดข้อมูลตัวละครได้",
            loading: false,
          });
        }
      },

      // Master data loading functions
      loadMasterData: async () => {
        const supabase = createClientSupabaseClient();
        set({ loading: true, error: null });

        try {
          // Load characters
          const { data: characterData, error: characterError } =
            await supabase.rpc("get_all_characters");

          if (characterError) throw characterError;

          const characterSchemas =
            characterData as unknown as CharacterSchema[];
          const characterDtos = characterSchemas.map(mapCharacterToDto);

          // Load items
          const { data: itemData, error: itemError } = await supabase.rpc(
            "get_all_items"
          );

          if (itemError) throw itemError;

          const itemSchemas = itemData as unknown as ItemSchema[];
          const itemDtos = itemSchemas.map(mapItemToDto);

          // Load chapters
          const { data: chapterData, error: chapterError } = await supabase.rpc(
            "get_all_chapters"
          );

          if (chapterError) throw chapterError;

          const chapterSchemas = chapterData as unknown as StoryChapterSchema[];
          const chapterDtos = chapterSchemas.map(mapStoryChapterToDto);

          // Load events
          const { data: eventData, error: eventError } = await supabase.rpc(
            "get_all_events"
          );

          if (eventError) throw eventError;

          const eventSchemas = eventData as unknown as StoryEventSchema[];
          const eventDtos = eventSchemas.map(mapStoryEventToDto);

          // Update store with master data
          set({
            masterCharacters: characterDtos,
            masterItems: itemDtos,
            masterChapters: chapterDtos,
            masterEvents: eventDtos,
            masterDataLoaded: true,
            loading: false,
          });
        } catch (err) {
          console.error("Error loading master data:", err);
          set({
            error: "ไม่สามารถโหลดข้อมูลหลักได้",
            loading: false,
          });
        }
      },

      ensureMasterDataLoaded: async () => {
        const { masterDataLoaded, loadMasterData } = get();
        if (!masterDataLoaded) {
          await loadMasterData();
        }
      },
    }),
    {
      name: "dragon-quest-game",
      partialize: (state) => ({
        userGameState: state.userGameState,
        currentLocation: state.currentLocation,
        currentView: state.currentView,
      }),
    }
  )
);
