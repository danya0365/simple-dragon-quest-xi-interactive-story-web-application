import { createClientSupabaseClient } from "@/src/infrastructure/config/supabase-client-client";
import { create } from "zustand";
import { persist } from "zustand/middleware";

type WorldMapsRpcResponse = {
  id: string;
  name: string;
  description: string;
  image_url: string;
  unlock_requirements: Record<string, unknown>;
  display_order: number;
  is_initial_user_progress: boolean;
  locations: LocationData[];
};

type AvailableEventsResponse = {
  event_id: string;
  event_title: string;
  event_description: string;
  event_type: string;
  chapter_title: string;
  location_name: string;
  interactions_count: number;
};

type UserGameStateRpcResponse = {
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
  unlocked_world_maps: string[];
  unlocked_locations: string[];
  unlocked_chapters: string[];
  unlocked_events: string[];
  completed_chapters: string[];
  completed_events: string[];
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
};

type InitializeUserProgressResponse = {
  id: string;
  user_id: string;
  current_chapter_id: string | null;
  current_location_id: string | null;
  current_event_id: string | null;
  player_level: number;
  player_experience: number;
  unlocked_world_maps: string[];
  unlocked_locations: string[];
  unlocked_chapters: string[];
  unlocked_events: string[];
  completed_chapters: string[];
  completed_events: string[];
  inventory: Record<string, unknown>[];
  party_members: Record<string, unknown>[];
  character_relationships: Record<string, unknown>;
  player_position: Record<string, unknown>;
  game_flags: Record<string, unknown>;
  game_stats: Record<string, unknown>;
  last_played_at: string;
  created_at: string;
  updated_at: string;
};

// Mapping function to convert UserGameStateResponse to UserGameState
function mapUserGameStateResponseToUserGameState(
  response: UserGameStateRpcResponse
): UserGameState {
  return {
    id: response.id,
    userId: response.user_id,
    currentWorldMapId: null, // Not provided by RPC, set to null
    currentLocationId: response.current_location_id,
    currentChapterId: response.current_chapter_id,
    currentEventId: response.current_event_id,
    completedChapters: response.completed_chapters,
    completedEvents: response.completed_events,
    unlockedWorldMaps: response.unlocked_world_maps,
    unlockedLocations: response.unlocked_locations,
    unlockedChapters: response.unlocked_chapters,
    unlockedEvents: response.unlocked_events,
    activeQuests: response.active_quests as unknown as Record<
      string,
      string | number
    >[],
    gameFlags: response.game_flags as unknown as Record<
      string,
      string | number
    >[],
    gameSettings: response.game_settings as unknown as Record<
      string,
      string | number
    >[],
    gameStats: response.game_stats as unknown as Record<
      string,
      string | number
    >,
    playerLevel: response.player_level,
    playerExperience: response.player_experience,
    partyMembers: response.party_members as unknown as PartyMember[],
    characterRelationships:
      response.character_relationships as unknown as Record<
        string,
        string | number
      >[],
    playerPosition: response.player_position as unknown as Record<
      string,
      string | number
    >,
    inventory: response.inventory as unknown as InventoryItem[],
    achievements: response.achievements as unknown as Record<
      string,
      string | number
    >[],
    playHistory: response.play_history as unknown as Record<
      string,
      string | number
    >[],
    lastPlayedAt: response.last_played_at,
  };
}

interface LocationData {
  id: string;
  world_map_id: string;
  name: string;
  description: string;
  image_url: string;
  location_type: string;
  unlock_requirements: Record<string, unknown>;
  display_order: number;
  is_initial_user_progress: boolean;
}

interface WorldRegion {
  id: string;
  name: string;
  description: string;
  image_url: string;
  is_unlocked: boolean;
  locations_count: number;
  unlocked_locations_count: number;
}

interface Location {
  id: string;
  world_map_id: string;
  name: string;
  description: string;
  location_type: string;
  is_unlocked: boolean;
}

interface StoryEvent {
  event_id: string;
  event_title: string;
  event_description: string;
  event_type: string;
  chapter_title: string;
  location_name: string;
  interactions_count: number;
}

interface PartyMember {
  character_id: string;
  name: string;
  description: string;
  avatar_url: string;
  current_stats: Record<string, number | string>;
  equipment: Record<string, string | null>;
  party_position: number;
  joined_at: string;
}

interface InventoryItem {
  item_id: string;
  name: string;
  description: string;
  item_type: string;
  rarity: string;
  image_url: string;
  quantity: number;
  obtained_at: string;
}

interface UserGameState {
  id: string;
  userId: string;
  currentWorldMapId: string | null;
  currentLocationId: string | null;
  currentChapterId: string | null;
  currentEventId: string | null;

  completedChapters: string[];
  completedEvents: string[];

  unlockedWorldMaps: string[];
  unlockedLocations: string[];
  unlockedChapters: string[];
  unlockedEvents: string[];

  activeQuests: Record<string, number | string>[];
  gameFlags: Record<string, number | string>[];
  gameSettings: Record<string, number | string>[];

  gameStats: Record<string, number | string>;
  playerLevel: number;
  playerExperience: number;
  partyMembers: PartyMember[];
  characterRelationships: Record<string, number | string>[];
  playerPosition: Record<string, number | string>;

  inventory: InventoryItem[];

  achievements: Record<string, number | string>[];
  playHistory: Record<string, number | string>[];
  lastPlayedAt: string;
}

interface GameState {
  // World and location data
  worldRegions: WorldRegion[];
  currentLocation: Location | null;
  allLocations: LocationData[];
  availableLocations: Location[];
  availableEvents: StoryEvent[];

  // User progress
  userGameState: UserGameState | null;
  userProgressId: string | null;

  // UI state
  loading: boolean;
  error: string | null;
  currentView: "world_map" | "location" | "event" | "inventory" | "party";
  selectedRegionId: string | null;
  selectedLocationId: string | null;
  selectedEventId: string | null;
}

interface GameActions {
  // Data loading
  loadWorldMap: () => Promise<void>;
  loadLocationsForRegion: (regionId: string) => Promise<void>;
  loadAvailableEvents: () => Promise<void>;
  loadUserGameState: (userProgressId?: string) => Promise<void>;
  loadEventInteractions: (eventId: string) => Promise<unknown>;
  completeInteraction: (
    interactionId: string,
    choiceData?: Record<string, unknown>
  ) => Promise<void>;
  initializeUserProgress: (userId: string) => Promise<void>;
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
            await supabase.rpc("get_world_maps");

          if (allMapsError) throw allMapsError;

          const allWorldMaps =
            allWorldMapsData as unknown as WorldMapsRpcResponse[];

          // Use unlocked data from userGameState
          const unlockedWorldMapIds = new Set(userGameState.unlockedWorldMaps);
          const unlockedLocationIds = new Set(userGameState.unlockedLocations);

          // Extract all locations data
          const allLocationsData = allWorldMaps.flatMap((worldMap) =>
            worldMap.locations.map((location) => ({
              id: location.id,
              world_map_id: location.world_map_id,
              name: location.name,
              description: location.description,
              image_url: location.image_url,
              location_type: location.location_type,
              unlock_requirements: location.unlock_requirements,
              display_order: location.display_order,
              is_initial_user_progress: location.is_initial_user_progress,
            }))
          );

          // Transform the data to match our WorldRegion interface
          const transformedData = allWorldMaps.map((worldMap) => {
            const isWorldMapUnlocked = unlockedWorldMapIds.has(worldMap.id);
            const unlockedLocationsInMap = worldMap.locations.filter((loc) =>
              unlockedLocationIds.has(loc.id)
            );

            return {
              id: worldMap.id,
              name: worldMap.name,
              description: worldMap.description,
              image_url: worldMap.image_url,
              is_unlocked: isWorldMapUnlocked,
              locations_count: worldMap.locations.length,
              unlocked_locations_count: unlockedLocationsInMap.length,
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
            .filter((location) => location.world_map_id === regionId)
            .filter((location) => unlockedLocationIds.has(location.id))
            .map((location) => ({
              id: location.id,
              world_map_id: location.world_map_id,
              name: location.name,
              description: location.description,
              location_type: location.location_type,
              is_unlocked: true, // Since we filtered by unlocked locations
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

      loadAvailableEvents: async () => {
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

          const newAvailableEvents = data as unknown as AvailableEventsResponse[];

          set({
            availableEvents: newAvailableEvents,
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

          const userGameStateResponse = data as unknown as UserGameStateRpcResponse;
          const mappedUserGameState = mapUserGameStateResponseToUserGameState(
            userGameStateResponse
          );

          set({
            userGameState: mappedUserGameState,
            loading: false,
          });
        } catch (err) {
          console.error("Error loading user game state:", err);
          set({
            error: "ไม่สามารถโหลดสถานะเกมได้",
            loading: false,
          });
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

          const eventInteractions = data as unknown as { event: StoryEvent; interactions: any[]; };

          set({ loading: false });
          return eventInteractions;
        } catch (err: unknown) {
          console.error("Error loading event interactions:", err);
          set({
            error: "ไม่สามารถโหลดการโต้ตอบได้",
            loading: false,
          });
          return null;
        }
      },

      completeInteraction: async (
        interactionId: string,
        choiceData?: Record<string, unknown>
      ) => {
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
            "complete_interaction_for_user_progress",
            {
              p_user_progress_uuid: userProgressId,
              p_interaction_uuid: interactionId,
              p_choice_data: choiceData || {} as Record<string, unknown>,
            }
          );

          if (error) throw error;

          const result = data as unknown as { success: boolean; message: string; next_event_id?: string; error?: string; };

          if (result.success && !result.error) {
            // Reload game state after successful interaction
            await get().loadUserGameState();
            await get().loadAvailableEvents();

            // If there's a next event, navigate to it
            if (result.next_event_id) {
              set({ selectedEventId: result.next_event_id });
            } else {
              // If no next event, go back to location view
              set({ selectedEventId: null, currentView: "location" });
            }
          } else {
            throw new Error(result?.error || "การโต้ตอบไม่สำเร็จ");
          }

          set({ loading: false });
        } catch (err) {
          console.error("Error completing interaction:", err);
          set({
            error: "ไม่สามารถดำเนินการโต้ตอบได้",
            loading: false,
          });
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

      setCurrentView: (view: "world_map" | "location" | "event" | "inventory" | "party") => {
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
            const response = data as unknown as InitializeUserProgressResponse;
            if (response.id) {
              console.log("User progress initialized with ID:", response.id);
              // Load the complete user game state after initialization
              await get().loadUserGameState(response.id);
            }
          }
        } catch (error) {
          console.error("Error calling initialize_user_progress:", error);
          throw error;
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
