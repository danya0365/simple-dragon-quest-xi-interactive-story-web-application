import { createClientSupabaseClient } from "@/src/infrastructure/config/supabase-client-client";
import { create } from "zustand";
import { persist } from "zustand/middleware";

type WorldMapUnlockStatusRpcResponse = {
  id: string;
  name: string;
  description: string;
  image_url: string;
  unlock_requirements: Record<string, unknown>;
  display_order: number;
  is_initial_user_progress: boolean;
  locations: LocationData[];
};

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

type AvailableEventsRpcResponse = {
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

// Mapping function to convert UserGameStateResponse to UserGameState
function mapUserGameStateResponseToUserGameState(
  response: UserGameStateRpcResponse
): UserGameState {
  return {
    user_id: response.user_id,
    current_world_map_id: null, // Not provided by RPC, set to null
    current_location_id: response.current_location_id,
    current_chapter_id: response.current_chapter_id,
    current_event_id: response.current_event_id,
    completed_chapters: response.completed_chapters,
    completed_events: response.completed_events,
    unlocked_world_maps: response.unlocked_world_maps,
    unlocked_locations: response.unlocked_locations,
    unlocked_chapters: response.unlocked_chapters,
    unlocked_events: response.unlocked_events,
    active_quests: response.active_quests as unknown as Record<string, string | number>[],
    game_flags: response.game_flags as unknown as Record<string, string | number>[],
    game_settings: response.game_settings as unknown as Record<string, string | number>[],
    game_stats: response.game_stats as unknown as Record<string, string | number>,
    player_level: response.player_level,
    player_experience: response.player_experience,
    party_members: response.party_members as unknown as PartyMember[],
    character_relationships: response.character_relationships as unknown as Record<
      string,
      string | number
    >[],
    player_position: response.player_position as unknown as Record<
      string,
      string | number
    >,
    inventory: response.inventory as unknown as InventoryItem[],
    achievements: response.achievements as unknown as Record<string, string | number>[],
    play_history: response.play_history as unknown as Record<string, string | number>[],
    last_played_at: response.last_played_at,
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

interface WorldMapData {
  id: string;
  name: string;
  description: string;
  image_url: string;
  unlock_requirements: Record<string, unknown>;
  display_order: number;
  is_initial_user_progress: boolean;
  locations: LocationData[];
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
  user_id: string;
  current_world_map_id: string | null;
  current_location_id: string | null;
  current_chapter_id: string | null;
  current_event_id: string | null;

  completed_chapters: string[];
  completed_events: string[];

  unlocked_world_maps: string[];
  unlocked_locations: string[];
  unlocked_chapters: string[];
  unlocked_events: string[];

  active_quests: Record<string, number | string>[];
  game_flags: Record<string, number | string>[];
  game_settings: Record<string, number | string>[];

  game_stats: Record<string, number | string>;
  player_level: number;
  player_experience: number;
  party_members: PartyMember[];
  character_relationships: Record<string, number | string>[];
  player_position: Record<string, number | string>;

  inventory: InventoryItem[];

  achievements: Record<string, number | string>[];
  play_history: Record<string, number | string>[];
  last_played_at: string;
}

interface GameState {
  // World and location data
  worldRegions: WorldRegion[];
  currentLocation: Location | null;
  availableEvents: StoryEvent[];

  // User progress
  userGameState: UserGameState | null;

  // UI state
  loading: boolean;
  error: string | null;
  currentView: "world_map" | "location" | "event" | "inventory" | "party";
  selectedRegionId: string | null;
  selectedEventId: string | null;
}

interface GameActions {
  // Data loading
  loadWorldMap: (userProgressId: string) => Promise<void>;
  loadAvailableEvents: (userProgressId: string) => Promise<void>;
  loadUserGameState: (userProgressId: string) => Promise<void>;
  loadEventInteractions: (
    userProgressId: string,
    eventId: string
  ) => Promise<unknown>;

  // Game interactions
  completeInteraction: (
    userProgressId: string,
    interactionId: string,
    choiceData?: Record<string, unknown>
  ) => Promise<void>;

  // Navigation
  setCurrentView: (view: GameState["currentView"]) => void;
  setSelectedRegion: (regionId: string | null) => void;
  setSelectedEvent: (eventId: string | null) => void;
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
      availableEvents: [],
      userGameState: null,
      loading: false,
      error: null,
      currentView: "world_map",
      selectedRegionId: null,
      selectedEventId: null,

      // Actions
      loadWorldMap: async (userProgressId: string) => {
        set({ loading: true, error: null });
        const supabase = createClientSupabaseClient();

        try {
          // Get all world maps and locations (complete catalog)
          const { data: allWorldMapsData, error: allMapsError } =
            await supabase.rpc("get_world_maps");

          if (allMapsError) throw allMapsError;

          // Get user's unlocked world maps and locations
          const { data: unlockedWorldMapsData, error: unlockedMapsError } =
            await supabase.rpc("get_world_map_for_user_progress", {
              p_user_progress_uuid: userProgressId,
            });

          if (unlockedMapsError) throw unlockedMapsError;

          const allWorldMaps =
            allWorldMapsData as unknown as WorldMapsRpcResponse[];
          const unlockedWorldMaps =
            unlockedWorldMapsData as unknown as WorldMapUnlockStatusRpcResponse[];

          // Create hash maps for quick lookup of unlocked status
          const unlockedWorldMapIds = new Set(
            unlockedWorldMaps.map((map) => map.id)
          );
          const unlockedLocationIds = new Set(
            unlockedWorldMaps.flatMap((map) =>
              map.locations.map((loc) => loc.id)
            )
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

      loadAvailableEvents: async (userProgressId: string) => {
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

          const newAvailableEvents =
            data as unknown as AvailableEventsRpcResponse[];

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

      loadUserGameState: async (userProgressId: string) => {
        set({ loading: true, error: null });
        const supabase = createClientSupabaseClient();

        try {
          const { data, error } = await supabase.rpc(
            "get_user_game_state_for_user_progress",
            {
              p_user_progress_uuid: userProgressId,
            }
          );

          if (error) throw error;

          const userGameStateResponse =
            data as unknown as UserGameStateRpcResponse;
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

      loadEventInteractions: async (
        userProgressId: string,
        eventId: string
      ) => {
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

          set({ loading: false });
          return data as unknown;
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
        userProgressId: string,
        interactionId: string,
        choiceData: Record<string, unknown> | undefined
      ) => {
        set({ loading: true, error: null });
        const supabase = createClientSupabaseClient();

        try {
          const { data, error } = await supabase.rpc(
            "complete_interaction_for_user_progress",
            {
              p_user_progress_uuid: userProgressId,
              p_interaction_uuid: interactionId,
              p_choice_data: choiceData as any,
            }
          );

          if (error) throw error;

          const result = data as any;
          if (result?.success) {
            // Reload game state after successful interaction
            await get().loadUserGameState(userProgressId);
            await get().loadAvailableEvents(userProgressId);

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

      setCurrentView: (view) => set({ currentView: view }),
      setSelectedRegion: (regionId) => set({ selectedRegionId: regionId }),
      setSelectedEvent: (eventId) => set({ selectedEventId: eventId }),
      setCurrentLocation: (location) => set({ currentLocation: location }),
      setLoading: (loading) => set({ loading }),
      setError: (error) => set({ error }),

      reset: () =>
        set({
          worldRegions: [],
          currentLocation: null,
          availableEvents: [],
          userGameState: null,
          loading: false,
          error: null,
          currentView: "world_map",
          selectedRegionId: null,
          selectedEventId: null,
        }),
    }),
    {
      name: "dragon-quest-game",
      partialize: (state) => ({
        currentView: state.currentView,
        selectedRegionId: state.selectedRegionId,
        selectedEventId: state.selectedEventId,
      }),
    }
  )
);
