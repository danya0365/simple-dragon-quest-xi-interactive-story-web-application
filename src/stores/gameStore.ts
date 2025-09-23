import { create } from "zustand";
import { persist } from "zustand/middleware";
import { createClientSupabaseClient } from "@/src/infrastructure/config/supabase-client-client";

// Types for game state
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
  current_stats: Record<string, any>;
  equipment: Record<string, any>;
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
  current_chapter_id: string | null;
  current_location_id: string | null;
  completed_events: string[];
  unlocked_locations: string[];
  unlocked_chapters: string[];
  game_stats: Record<string, any>;
  party_members: PartyMember[];
  inventory: InventoryItem[];
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
  currentView: 'world_map' | 'location' | 'event' | 'inventory' | 'party';
  selectedRegionId: string | null;
  selectedEventId: string | null;
}

interface GameActions {
  // Data loading
  loadWorldMap: (userId: string) => Promise<void>;
  loadAvailableEvents: (userId: string) => Promise<void>;
  loadUserGameState: (userId: string) => Promise<void>;
  
  // Game interactions
  completeInteraction: (userId: string, interactionId: string, choiceData?: any) => Promise<void>;
  
  // Navigation
  setCurrentView: (view: GameState['currentView']) => void;
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
      currentView: 'world_map',
      selectedRegionId: null,
      selectedEventId: null,

      // Actions
      loadWorldMap: async (userId: string) => {
        set({ loading: true, error: null });
        const supabase = createClientSupabaseClient();

        try {
          const { data, error } = await supabase.rpc('get_world_map_for_user', {
            user_uuid: userId
          });

          if (error) throw error;

          set({
            worldRegions: data || [],
            loading: false
          });
        } catch (error) {
          console.error('Error loading world map:', error);
          set({
            error: 'ไม่สามารถโหลดแผนที่โลกได้',
            loading: false
          });
        }
      },

      loadAvailableEvents: async (userId: string) => {
        set({ loading: true, error: null });
        const supabase = createClientSupabaseClient();

        try {
          const { data, error } = await supabase.rpc('get_available_events', {
            user_uuid: userId
          });

          if (error) throw error;

          set({
            availableEvents: data || [],
            loading: false
          });
        } catch (error) {
          console.error('Error loading available events:', error);
          set({
            error: 'ไม่สามารถโหลดเหตุการณ์ได้',
            loading: false
          });
        }
      },

      loadUserGameState: async (userId: string) => {
        set({ loading: true, error: null });
        const supabase = createClientSupabaseClient();

        try {
          const { data, error } = await supabase.rpc('get_user_game_state', {
            user_uuid: userId
          });

          if (error) throw error;

          set({
            userGameState: data,
            loading: false
          });
        } catch (error) {
          console.error('Error loading user game state:', error);
          set({
            error: 'ไม่สามารถโหลดสถานะเกมได้',
            loading: false
          });
        }
      },

      completeInteraction: async (userId: string, interactionId: string, choiceData = {}) => {
        set({ loading: true, error: null });
        const supabase = createClientSupabaseClient();

        try {
          const { data, error } = await supabase.rpc('complete_interaction', {
            user_uuid: userId,
            interaction_uuid: interactionId,
            choice_data: choiceData
          });

          if (error) throw error;

          if (data?.success) {
            // Reload game state after successful interaction
            await get().loadUserGameState(userId);
            await get().loadAvailableEvents(userId);
            
            // If there's a next event, navigate to it
            if (data.next_event_id) {
              set({ selectedEventId: data.next_event_id });
            }
          } else {
            throw new Error(data?.error || 'การโต้ตอบไม่สำเร็จ');
          }

          set({ loading: false });
        } catch (error) {
          console.error('Error completing interaction:', error);
          set({
            error: 'ไม่สามารถดำเนินการโต้ตอบได้',
            loading: false
          });
        }
      },

      setCurrentView: (view) => set({ currentView: view }),
      setSelectedRegion: (regionId) => set({ selectedRegionId: regionId }),
      setSelectedEvent: (eventId) => set({ selectedEventId: eventId }),
      setCurrentLocation: (location) => set({ currentLocation: location }),
      setLoading: (loading) => set({ loading }),
      setError: (error) => set({ error }),

      reset: () => set({
        worldRegions: [],
        currentLocation: null,
        availableEvents: [],
        userGameState: null,
        loading: false,
        error: null,
        currentView: 'world_map',
        selectedRegionId: null,
        selectedEventId: null,
      }),
    }),
    {
      name: 'dragon-quest-game',
      partialize: (state) => ({
        currentView: state.currentView,
        selectedRegionId: state.selectedRegionId,
        selectedEventId: state.selectedEventId,
      }),
    }
  )
);
