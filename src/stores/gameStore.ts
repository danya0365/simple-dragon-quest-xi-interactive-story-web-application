import { Json } from "@/src/domain/types/supabase";
import { 
  WorldMapSchema,
  AvailableEventSchema,
  UserGameStateSchema,
  InitializeUserProgressSchema,
  CompleteInteractionSchema,
  EventInteractionSchema,
  DeleteUserProgressSchema
} from "@/src/domain/types/rpc";
import { 
  WorldMapDto,
  UserGameStateDto,
  CompleteInteractionDto,
  EventInteractionDto,
  LocationDto,
  CharacterData,
  DeleteUserProgressDto
} from "@/src/domain/types/rpc";
import {
  mapWorldMapToDto,
  mapAvailableEventToDto,
  mapUserGameStateToDto,
  mapInitializeUserProgressToDto,
  mapCompleteInteractionToDto,
  mapEventInteractionToDto,
  mapDeleteUserProgressToDto
} from "@/src/domain/mappers/rpcMappers";
import {
  mapAvailableEventDtoToUI,
  mapEventInteractionDtoToUI,
  mapUserGameStateDtoToUI
} from "@/src/domain/mappers/uiMappers";
import { createClientSupabaseClient } from "@/src/infrastructure/config/supabase-client-client";
import { create } from "zustand";
import { persist } from "zustand/middleware";

// Import UI types for frontend components
import type {
  EventInteractionUI,
  WorldRegionUI,
  LocationUI,
  StoryEventUI,
  PartyMemberUI,
  InventoryItemUI,
  UserGameStateUI
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


interface GameState {
  // World and location data
  worldRegions: WorldRegionUI[];
  currentLocation: LocationUI | null;
  allLocations: LocationUI[];
  availableLocations: LocationUI[];
  availableEvents: StoryEventUI[];

  // User progress
  userGameState: UserGameStateUI | null;
  userProgressId: string | null;

  // UI state
  loading: boolean;
  error: string | null;
  currentView:
    | "world_map"
    | "location"
    | "event"
    | "event_interaction"
    | "inventory"
    | "party";
  selectedRegionId: string | null;
  selectedLocationId: string | null;
  selectedEventId: string | null;
}

interface GameActions {
  // Data loading
  loadWorldMap: () => Promise<void>;
  loadLocationsForRegion: (regionId: string) => Promise<void>;
  loadAvailableEvents: (locationId: string) => Promise<void>;
  loadUserGameState: (userProgressId?: string) => Promise<void>;
  loadEventInteractions: (eventId: string) => Promise<EventInteraction[] | null>;
  completeInteraction: (
    interactionId: string,
    choiceData?: Json
  ) => Promise<CompleteInteractionDto>;
  initializeUserProgress: (userId: string) => Promise<void>;
  deleteUserProgress: (userId: string) => Promise<DeleteUserProgressDto>;
  loadUserInventory: () => Promise<void>;
  loadCharacters: () => Promise<void>;
  
  // Helper functions
  isLocationUnlocked: (locationId: string) => boolean;
  
  // Navigation
  setCurrentView: (view: GameState["currentView"]) => void;
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
      userGameState: null,
      userProgressId: null,
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
          const allLocationsData = allWorldMaps.flatMap((worldMap: WorldMapDto) =>
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
            const unlockedLocationsInMap = worldMap.locations.filter((loc: LocationDto) =>
              unlockedLocationIds.has(loc.id)
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
              imageUrl: location.imageUrl || '',
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
          const newAvailableEvents = availableEventsSchemas.map(mapAvailableEventToDto);

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

          const userGameStateSchema =
            data as unknown as UserGameStateSchema;
          const userGameStateDto = mapUserGameStateToDto(userGameStateSchema);
          const mappedUserGameState = mapUserGameStateResponseToUserGameState(
            userGameStateDto
          );

          set({
            userGameState: mappedUserGameState,
            loading: false,
          });
        } catch (err) {
          console.error("Error loading user game state:", err);
          
          // Check if we should initialize user progress (only once)
          const state = get();
          if (!state.userGameState && !state.error?.includes('กำลังสร้างข้อมูลผู้เล่นใหม่')) {
            console.log("Attempting to initialize user progress...");
            try {
              // Get current user ID from auth
              const { data: { user }, error: authError } = await supabase.auth.getUser();
              if (authError || !user) {
                throw new Error('ไม่พบข้อมูลผู้ใช้');
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
          const rpcResponseSchemas = data as unknown as EventInteractionSchema[];
          const rpcResponseDtos = rpcResponseSchemas.map(mapEventInteractionToDto);
          
          // Map the response to frontend format
          const mappedInteractions = mapEventInteractionsResponseToEventInteractions(rpcResponseDtos);

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
        const { userGameState } = get();
        if (!userGameState) {
          set({ error: "ไม่พบข้อมูลผู้เล่น" });
          return {
            success: false,
            error: "ไม่พบข้อมูลผู้เล่น"
          };
        }
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
          const result = mapCompleteInteractionToDto(resultSchema);

          if (result.success && !result.error) {
            // Reload game state after successful interaction
            await get().loadUserGameState();
            const { selectedLocationId } = get();
            if (selectedLocationId) {
              await get().loadAvailableEvents(selectedLocationId);
            }

            // If there's a next event, navigate to it
            if (result.nextEventId) {
              set({ selectedEventId: result.nextEventId });
            } else {
              // If no next event, go back to location view
              set({ selectedEventId: null, currentView: "location" });
            }
            
            set({ loading: false });
            return result;
          } else {
            set({ loading: false });
            return result;
          }
        } catch (err) {
          console.error("Error completing interaction:", err);
          set({
            error: "ไม่สามารถดำเนินการโต้ตอบได้",
            loading: false,
          });
          return {
            success: false,
            error: err instanceof Error ? err.message : "ไม่สามารถดำเนินการโต้ตอบได้"
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

      setCurrentView: (
        view:
          | "world_map"
          | "location"
          | "event"
          | "event_interaction"
          | "inventory"
          | "party"
      ) => {
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
            const responseSchema = data as unknown as InitializeUserProgressSchema;
            const responseDto = mapInitializeUserProgressToDto(responseSchema);
            if (responseDto.id) {
              console.log("User progress initialized with ID:", responseDto.id);
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
          const { data, error } = await supabase.rpc(
            "delete_user_progress",
            {
              p_user_uuid: userId,
            }
          );

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
            
            console.log("User progress deleted successfully:", responseDto.message);
            return responseDto;
          }
          
          throw new Error("No data returned from delete_user_progress");
        } catch (error) {
          console.error("Error calling delete_user_progress:", error);
          throw error;
        }
      },

      loadUserInventory: async () => {
        const supabase = createClientSupabaseClient();
        set({ loading: true, error: null });

        try {
          const { data, error } = await supabase.rpc('get_all_items');
          
          if (error) throw error;
          
          const items = data as unknown as Array<{
            id: string;
            name: string;
            description: string;
            item_type: string;
            rarity: string;
            image_url: string;
          }>;
          
          // Update user game state with inventory
          const { userGameState } = get();
          if (userGameState) {
            // Map items with userGameState inventory to get actual quantities and data
            const userInventory = userGameState.inventory as unknown as Array<{
              item_id: string;
              quantity: number;
              obtained_at: string;
              equipped?: boolean;
              slot?: string;
            }> || [];
            
            const inventoryItems = items.map(item => {
              const userItem = userInventory.find(ui => ui.item_id === item.id);
              return {
                itemId: item.id,
                name: item.name,
                description: item.description,
                itemType: item.item_type,
                rarity: item.rarity,
                imageUrl: item.image_url,
                quantity: userItem?.quantity || 0,
                obtainedAt: userItem?.obtained_at || new Date().toISOString(),
                equipped: userItem?.equipped || false,
                slot: userItem?.slot || null
              };
            }).filter(item => item.quantity > 0); // Only show items user actually has
            
            set({
              userGameState: {
                ...userGameState,
                inventory: inventoryItems
              }
            });
          }
          
          set({ loading: false });
        } catch (err) {
          console.error('Error loading inventory:', err);
          set({
            error: 'ไม่สามารถโหลดข้อมูลไอเทมได้',
            loading: false
          });
        }
      },

      loadCharacters: async () => {
        const supabase = createClientSupabaseClient();
        set({ loading: true, error: null });

        try {
          const { data, error } = await supabase.rpc('get_all_characters');
          
          if (error) throw error;
          
          const characters = data as unknown as CharacterData[];
          
          // Update user game state with character master data
          const { userGameState } = get();
          if (userGameState) {
            // Get existing party members from user game state
            const existingPartyMembers = userGameState.partyMembers as unknown as Array<{
              character_id: string;
              joined_at: string;
              current_stats: Record<string, number | string>;
              equipment: Record<string, string | null>;
              is_active: boolean;
              party_position: number;
              name?: string;
              description?: string;
              avatar_url?: string;
            }> || [];
            
            // Enrich party members with character master data
            const enrichedPartyMembers = existingPartyMembers.map(partyMember => {
              const masterCharacter = characters.find(c => c.id === partyMember.character_id);
              return {
                characterId: partyMember.character_id,
                name: masterCharacter?.name || partyMember.name || 'Unknown Character',
                description: masterCharacter?.description || partyMember.description || 'No description available',
                avatarUrl: masterCharacter?.avatar_url || partyMember.avatar_url || '/placeholder-avatar.png',
                currentStats: partyMember.current_stats,
                equipment: partyMember.equipment,
                partyPosition: partyMember.party_position,
                joinedAt: partyMember.joined_at
              };
            });
            
            set({
              userGameState: {
                ...userGameState,
                partyMembers: enrichedPartyMembers
              }
            });
          }
          
          set({ loading: false });
        } catch (err) {
          console.error('Error loading characters:', err);
          set({
            error: 'ไม่สามารถโหลดข้อมูลตัวละครได้',
            loading: false
          });
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
