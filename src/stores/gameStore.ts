import { Json } from "@/src/domain/types/supabase";
import { supabase } from "@/src/infrastructure/config/supabase-browser-client";
import { create } from "zustand";

// Database types (from Supabase)
interface MapObjectSchema {
  id: string;
  map_id: string;
  name: string;
  object_type: string;
  object_subtype?: string | null;
  position_x: number | null;
  position_y: number | null;
  properties?: Json | null;
  character_id?: string | null;
  item_id?: string | null;
  is_interactive: boolean | null;
  interaction_id?: string | null;
  display_order: number;
  created_at: string | null;
  updated_at: string | null;
}

interface MapSchema {
  id: string;
  name: string;
  description?: string | null;
  image_url?: string | null;
  map_type: string;
  map_subtype?: string | null | undefined;
  position_x?: number | null;
  position_y?: number | null;
  size_width?: number | null;
  size_height?: number | null;
  linked_map_id?: string | null;
  unlock_requirements?: Json | null;
  display_order: number;
  is_accessible: boolean | null;
  is_initial_user_progress: boolean | null;
  is_alway_hide_until_unlock: boolean | null;
  parent_id?: string | null;
  created_at: string | null;
  updated_at: string | null;
}

interface UserGameStateSchema {
  id: string;
  user_id: string;
  name: string;
  current_chapter_id: string | null;
  current_map_id: string | null;
  current_event_id: string | null;
  player_level: number | null;
  player_experience: number | null;
  unlocked_maps: Json | null;
  unlocked_chapters: Json | null;
  unlocked_events: Json | null;
  completed_chapters: Json | null;
  completed_events: Json | null;
  completed_interactions: Json | null;
  inventory: Json | null;
  party_members: Json | null;
  character_relationships: Json | null;
  player_position: Json | null;
  game_flags: Json | null;
  game_settings: Json | null;
  game_stats: Json | null;
  active_quests: Json | null;
  achievements: Json | null;
  play_history: Json | null;
  save_data: Json | null;
  last_played_at: string | null;
  created_at: string | null;
  updated_at: string | null;
}

// DTO interfaces for UI layer
export interface MapObjectPropertiesDto {
  spriteUrl?: string;
  description?: string;
  [key: string]: any;
}

export interface MapObjectDto {
  id: string;
  mapId: string;
  name: string;
  objectType: string;
  objectSubtype?: string | null;
  positionX: number | null;
  positionY: number | null;
  properties?: MapObjectPropertiesDto | null;
  characterId?: string | null;
  itemId?: string | null;
  isInteractive: boolean | null;
  interactionId?: string | null;
  displayOrder: number;
  createdAt: string | null;
  updatedAt: string | null;
}

export interface MapDto {
  id: string;
  name: string;
  description?: string | null;
  imageUrl?: string | null;
  mapType: string;
  mapSubtype?: string | null;
  positionX?: number | null;
  positionY?: number | null;
  sizeWidth?: number | null;
  sizeHeight?: number | null;
  linkedMapId?: string | null;
  unlockRequirements?: any | null;
  displayOrder: number;
  isAccessible: boolean | null;
  isInitialUserProgress: boolean | null;
  isAlwaysHideUntilUnlock: boolean | null;
  parentId?: string | null;
  createdAt: string | null;
  updatedAt: string | null;
}

export interface InventoryItemDto {
  id: string;
  name: string;
  quantity: number;
  [key: string]: any;
}

export interface CompletedInteractionDto {
  interaction_id: string;
  event_id: string;
  completed_at: string;
}

export interface PartyMemberDto {
  id: string;
  name: string;
  level: number;
  [key: string]: any;
}

export interface UserGameStateDto {
  id: string;
  userId: string;
  name: string;
  currentChapterId: string | null;
  currentMapId: string | null;
  currentEventId: string | null;
  playerLevel: number | null;
  playerExperience: number | null;
  unlockedMaps: string[];
  unlockedChapters: string[];
  unlockedEvents: string[];
  completedChapters: string[];
  completedEvents: string[];
  completedInteractions: CompletedInteractionDto[];
  inventory: InventoryItemDto[];
  partyMembers: PartyMemberDto[];
  characterRelationships: Record<string, any>;
  playerPosition: Record<string, any>;
  gameFlags: Record<string, any>;
  gameSettings: Record<string, any>;
  gameStats: Record<string, any>;
  activeQuests: any[];
  achievements: Record<string, any>;
  playHistory: Record<string, any>;
  saveData: Record<string, any>;
  lastPlayedAt: string | null;
  createdAt: string | null;
  updatedAt: string | null;
}

interface GameState {
  userGameState: UserGameStateDto | null;
  maps: MapDto[];
  mapObjects: MapObjectDto[];
  currentMap: MapDto | null;
  selectedMapObject: MapObjectDto | null;
  loading: boolean;
  error: string | null;

  // Actions
  loadUserGameState: (userProgressId?: string) => Promise<void>;
  loadMaps: () => Promise<void>;
  loadMapObjects: () => Promise<void>;
  setCurrentMap: (mapId: string) => void;
  selectMapObject: (mapObject: MapObjectDto | null) => void;
  interactWithMapObject: (mapObjectId: string) => Promise<void>;
  navigateToMap: (mapId: string) => Promise<void>;
  isMapUnlocked: (mapId: string) => boolean;
  isMapAccessible: (mapId: string) => boolean;
  initializeUserProgress: (userId: string) => Promise<void>;
}

// Mapping functions to convert database schema to DTO
const mapMapSchemaToMapDto = (dbMap: MapSchema): MapDto => {
  return {
    id: dbMap.id,
    name: dbMap.name,
    description: dbMap.description,
    imageUrl: dbMap.image_url,
    mapType: dbMap.map_type,
    mapSubtype: dbMap.map_subtype,
    positionX: dbMap.position_x,
    positionY: dbMap.position_y,
    sizeWidth: dbMap.size_width,
    sizeHeight: dbMap.size_height,
    linkedMapId: dbMap.linked_map_id,
    unlockRequirements: dbMap.unlock_requirements,
    displayOrder: dbMap.display_order,
    isAccessible: dbMap.is_accessible,
    isInitialUserProgress: dbMap.is_initial_user_progress,
    isAlwaysHideUntilUnlock: dbMap.is_alway_hide_until_unlock,
    parentId: dbMap.parent_id,
    createdAt: dbMap.created_at,
    updatedAt: dbMap.updated_at,
  };
};

const mapMapObjectSchemaToMapObjectDto = (
  dbMapObject: MapObjectSchema
): MapObjectDto => {
  return {
    id: dbMapObject.id,
    mapId: dbMapObject.map_id,
    name: dbMapObject.name,
    objectType: dbMapObject.object_type,
    objectSubtype: dbMapObject.object_subtype,
    positionX: dbMapObject.position_x,
    positionY: dbMapObject.position_y,
    properties: dbMapObject.properties
      ? ({
          spriteUrl: (dbMapObject.properties as any).sprite_url,
          description: (dbMapObject.properties as any).description,
        } as MapObjectPropertiesDto)
      : null,
    characterId: dbMapObject.character_id,
    itemId: dbMapObject.item_id,
    isInteractive: dbMapObject.is_interactive,
    interactionId: dbMapObject.interaction_id,
    displayOrder: dbMapObject.display_order,
    createdAt: dbMapObject.created_at,
    updatedAt: dbMapObject.updated_at,
  };
};

const mapUserGameStateSchemaToUserGameStateDto = (
  dbUserGameState: UserGameStateSchema
): UserGameStateDto => {
  // Helper function to safely convert Json to string[]
  const jsonToStringArray = (json: Json | null): string[] => {
    if (!json) return [];
    try {
      const parsed = typeof json === "string" ? JSON.parse(json) : json;
      return Array.isArray(parsed) ? parsed.map(String) : [];
    } catch {
      return [];
    }
  };

  // Helper function to safely convert Json to CompletedInteractionDto[]
  const jsonToCompletedInteractions = (
    json: Json | null
  ): CompletedInteractionDto[] => {
    if (!json) return [];
    try {
      const parsed = typeof json === "string" ? JSON.parse(json) : json;
      return Array.isArray(parsed) ? parsed : [];
    } catch {
      return [];
    }
  };

  // Helper function to safely convert Json to InventoryItemDto[]
  const jsonToInventory = (json: Json | null): InventoryItemDto[] => {
    if (!json) return [];
    try {
      const parsed = typeof json === "string" ? JSON.parse(json) : json;
      return Array.isArray(parsed) ? parsed : [];
    } catch {
      return [];
    }
  };

  // Helper function to safely convert Json to PartyMemberDto[]
  const jsonToPartyMembers = (json: Json | null): PartyMemberDto[] => {
    if (!json) return [];
    try {
      const parsed = typeof json === "string" ? JSON.parse(json) : json;
      return Array.isArray(parsed) ? parsed : [];
    } catch {
      return [];
    }
  };

  // Helper function to safely convert Json to Record<string, any>
  const jsonToRecord = (json: Json | null): Record<string, any> => {
    if (!json) return {};
    try {
      const parsed = typeof json === "string" ? JSON.parse(json) : json;
      return typeof parsed === "object" && parsed !== null ? parsed : {};
    } catch {
      return {};
    }
  };

  // Helper function to safely convert Json to any[]
  const jsonToArray = (json: Json | null): any[] => {
    if (!json) return [];
    try {
      const parsed = typeof json === "string" ? JSON.parse(json) : json;
      return Array.isArray(parsed) ? parsed : [];
    } catch {
      return [];
    }
  };

  return {
    id: dbUserGameState.id,
    userId: dbUserGameState.user_id,
    name: dbUserGameState.name || "Default Save",
    currentChapterId: dbUserGameState.current_chapter_id,
    currentMapId: dbUserGameState.current_map_id,
    currentEventId: dbUserGameState.current_event_id,
    playerLevel: dbUserGameState.player_level,
    playerExperience: dbUserGameState.player_experience,
    unlockedMaps: jsonToStringArray(dbUserGameState.unlocked_maps),
    unlockedChapters: jsonToStringArray(dbUserGameState.unlocked_chapters),
    unlockedEvents: jsonToStringArray(dbUserGameState.unlocked_events),
    completedChapters: jsonToStringArray(dbUserGameState.completed_chapters),
    completedEvents: jsonToStringArray(dbUserGameState.completed_events),
    completedInteractions: jsonToCompletedInteractions(
      dbUserGameState.completed_interactions
    ),
    inventory: jsonToInventory(dbUserGameState.inventory),
    partyMembers: jsonToPartyMembers(dbUserGameState.party_members),
    characterRelationships: jsonToRecord(
      dbUserGameState.character_relationships
    ),
    playerPosition: jsonToRecord(dbUserGameState.player_position),
    gameFlags: jsonToRecord(dbUserGameState.game_flags),
    gameSettings: jsonToRecord(dbUserGameState.game_settings),
    gameStats: jsonToRecord(dbUserGameState.game_stats),
    activeQuests: jsonToArray(dbUserGameState.active_quests),
    achievements: jsonToRecord(dbUserGameState.achievements),
    playHistory: jsonToRecord(dbUserGameState.play_history),
    saveData: jsonToRecord(dbUserGameState.save_data),
    lastPlayedAt: dbUserGameState.last_played_at,
    createdAt: dbUserGameState.created_at,
    updatedAt: dbUserGameState.updated_at,
  };
};

export const useGameStore = create<GameState>((set, get) => ({
  userGameState: null,
  maps: [],
  mapObjects: [],
  currentMap: null,
  selectedMapObject: null,
  loading: false,
  error: null,

  loadUserGameState: async (userProgressId?: string) => {
    set({ loading: true, error: null });

    try {
      let progressId = userProgressId;

      // If no userProgressId is provided, fetch the current user's progress ID
      if (!progressId) {
        const {
          data: { user },
          error: userError,
        } = await supabase.auth.getUser();

        if (userError || !user) {
          console.error("Error getting user:", userError);
          set({ loading: false, error: "User not authenticated" });
          return;
        }

        // Query the user_game_states table directly using user_id
        const { data: userProgress, error: progressError } = await supabase
          .from("user_game_states")
          .select("id")
          .eq("user_id", user.id)
          .single();

        if (progressError || !userProgress) {
          console.error("Error getting user progress:", progressError);

          // Try to initialize user progress
          try {
            const { data: initData, error: initError } = await supabase.rpc(
              "initialize_user_game_states",
              {
                p_user_id: user.id,
              }
            );

            if (initError) {
              console.error("Error initializing user progress:", initError);
              set({
                loading: false,
                error: "Failed to initialize user progress",
              });
              return;
            }

            if (initData && typeof initData === "object" && initData !== null) {
              // Extract the user progress ID from the response with proper type checking
              const response = initData as Record<string, unknown>;
              if (
                "id" in response &&
                typeof response.id === "string" &&
                response.id.trim() !== ""
              ) {
                console.log("User progress initialized with ID:", response.id);
                progressId = response.id;
              } else {
                console.error(
                  "Invalid RPC response: missing or invalid id property",
                  initData
                );
                set({
                  loading: false,
                  error: "Failed to get initialized user progress ID",
                });
                return;
              }
            } else {
              console.error(
                "Invalid RPC response: expected object but got",
                initData
              );
              set({
                loading: false,
                error: "Invalid response from initialize_user_progress",
              });
              return;
            }
          } catch (error) {
            console.error("Error calling initialize_user_progress:", error);
            set({
              loading: false,
              error: "Failed to initialize user progress",
            });
            return;
          }
        } else {
          // Only set progressId from userProgress if we didn't initialize it
          progressId = userProgress.id;
        }
      }

      // Ensure progressId is defined
      if (!progressId) {
        console.error("No user progress ID found");
        set({ loading: false, error: "User progress ID not found" });
        return;
      }

      const { data, error: rpcError } = await supabase.rpc(
        "get_user_game_states_by_id",
        {
          p_user_game_state_uuid: progressId,
        }
      );

      if (rpcError) {
        set({ loading: false, error: rpcError.message });
        return;
      }

      if (
        data &&
        typeof data === "object" &&
        !Array.isArray(data) &&
        data !== null
      ) {
        try {
          const gameState = mapUserGameStateSchemaToUserGameStateDto(
            data as unknown as UserGameStateSchema
          );
          set({
            userGameState: gameState,
            loading: false,
          });
        } catch (transformError) {
          console.error("Error transforming game state data:", transformError);
          set({ loading: false, error: "Failed to process game state data" });
        }
      } else {
        console.error("Invalid game state data received:", data);
        set({ loading: false, error: "Invalid game state data received" });
      }
    } catch (err) {
      console.error("Error loading user game state:", err);
      set({ loading: false, error: "Failed to load game state" });
    }
  },

  loadMaps: async () => {
    set({ loading: true, error: null });

    try {
      const { data, error } = await supabase
        .from("maps")
        .select("*")
        .order("display_order");

      if (error) {
        set({ loading: false, error: error.message });
        return;
      }

      const mappedMaps = data ? data.map(mapMapSchemaToMapDto) : [];
      set({
        maps: mappedMaps,
        loading: false,
      });

      // Set current map if not already set
      const currentState = get();
      if (!currentState.currentMap && data && data.length > 0) {
        const userMapId = currentState.userGameState?.currentMapId;
        const currentMap =
          mappedMaps.find((map) => map.id === userMapId) || mappedMaps[0];
        set({ currentMap });
      }
    } catch (err) {
      console.error("Error loading maps:", err);
      set({ loading: false, error: "Failed to load maps" });
    }
  },

  loadMapObjects: async () => {
    set({ loading: true, error: null });

    try {
      const { data, error } = await supabase
        .from("map_objects")
        .select("*")
        .order("position_x");

      if (error) {
        set({ loading: false, error: error.message });
        return;
      }

      const mappedMapObjects = data
        ? data.map(mapMapObjectSchemaToMapObjectDto)
        : [];
      set({
        mapObjects: mappedMapObjects,
        loading: false,
      });
    } catch (err) {
      console.error("Error loading map objects:", err);
      set({ loading: false, error: "Failed to load map objects" });
    }
  },

  setCurrentMap: (mapId: string) => {
    const { maps } = get();
    const map = maps.find((m) => m.id === mapId);
    if (map) {
      set({ currentMap: map });
    }
  },

  selectMapObject: (mapObject: MapObjectDto | null) => {
    set({ selectedMapObject: mapObject });
  },

  interactWithMapObject: async (mapObjectId: string) => {
    const { mapObjects, currentMap } = get();
    const mapObject = mapObjects.find((mo) => mo.id === mapObjectId);

    if (!mapObject || !currentMap) {
      set({ error: "Invalid map object or current map" });
      return;
    }

    // Check if map object belongs to current map
    if (mapObject.mapId !== currentMap.id) {
      set({ error: "Map object not in current map" });
      return;
    }

    // Handle interaction based on object type
    if (mapObject.objectType === "sub_map" && mapObject.interactionId) {
      await get().navigateToMap(mapObject.interactionId);
    } else {
      // For other interaction types, you can extend this logic
      console.log("Interacting with map object:", mapObject);
      set({ selectedMapObject: mapObject });
    }
  },

  navigateToMap: async (mapId: string) => {
    const { maps, userGameState } = get();
    const targetMap = maps.find((m) => m.id === mapId);

    if (!targetMap) {
      set({ error: "Map not found" });
      return;
    }

    // Check if map is unlocked
    if (!get().isMapUnlocked(mapId)) {
      set({ error: "Map is locked" });
      return;
    }

    try {
      // Get current user
      const {
        data: { user },
      } = await supabase.auth.getUser();
      if (!user) {
        set({ error: "User not authenticated" });
        return;
      }

      // Get user game state ID
      const { data: userGameState } = await supabase
        .from("user_game_states")
        .select("id")
        .eq("user_id", user.id)
        .single();

      if (!userGameState?.id) {
        set({ error: "User game state not found" });
        return;
      }

      // Update current map in user game state
      const { error: updateError } = await supabase
        .from("user_game_states")
        .update({ current_map_id: mapId })
        .eq("id", userGameState.id);

      if (updateError) {
        set({ error: updateError.message });
        return;
      }

      // Update store state
      set({
        currentMap: targetMap,
        selectedMapObject: null,
      });
    } catch (err) {
      console.error("Error navigating to map:", err);
      set({ error: "Failed to navigate to map" });
    }
  },

  isMapUnlocked: (mapId: string) => {
    const { userGameState } = get();
    return userGameState?.unlockedMaps.includes(mapId) || false;
  },

  isMapAccessible: (mapId: string) => {
    const { maps } = get();
    const map = maps.find((m) => m.id === mapId);
    return map?.isAccessible || false;
  },

  initializeUserProgress: async (userId: string) => {
    set({ loading: true, error: null });

    try {
      // Call the initialize_user_progress function
      const { data, error } = await supabase.rpc(
        "initialize_user_game_states",
        {
          p_user_id: userId,
        }
      );

      if (error) {
        console.error("Error initializing user progress:", error);
        set({ loading: false, error: error.message });
        return;
      }

      if (data) {
        // Extract the user progress ID from the response
        const response = data as unknown as { id: string };
        if (response.id) {
          console.log("User progress initialized with ID:", response.id);
          // Load the complete user game state after initialization
          await get().loadUserGameState(response.id);
        }
      }
    } catch (error) {
      console.error("Error calling initialize_user_progress:", error);
      set({ loading: false, error: "Failed to initialize user progress" });
    }
  },
}));
