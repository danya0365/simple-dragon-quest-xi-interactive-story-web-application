export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export type Database = {
  public: {
    Tables: {
      characters: {
        Row: {
          abilities: Json | null
          avatar_url: string | null
          character_type: string | null
          created_at: string | null
          description: string | null
          id: string
          is_initial_user_progress: boolean | null
          is_joinable: boolean | null
          join_requirements: Json | null
          name: string
          stats: Json | null
          updated_at: string | null
        }
        Insert: {
          abilities?: Json | null
          avatar_url?: string | null
          character_type?: string | null
          created_at?: string | null
          description?: string | null
          id?: string
          is_initial_user_progress?: boolean | null
          is_joinable?: boolean | null
          join_requirements?: Json | null
          name: string
          stats?: Json | null
          updated_at?: string | null
        }
        Update: {
          abilities?: Json | null
          avatar_url?: string | null
          character_type?: string | null
          created_at?: string | null
          description?: string | null
          id?: string
          is_initial_user_progress?: boolean | null
          is_joinable?: boolean | null
          join_requirements?: Json | null
          name?: string
          stats?: Json | null
          updated_at?: string | null
        }
        Relationships: []
      }
      event_interactions: {
        Row: {
          character_speaker: string | null
          choices: Json | null
          created_at: string | null
          description: string | null
          dialogue_text: string | null
          display_order: number
          event_id: string
          id: string
          interaction_type: string
          is_available: boolean | null
          requirements: Json | null
          title: string
          updated_at: string | null
        }
        Insert: {
          character_speaker?: string | null
          choices?: Json | null
          created_at?: string | null
          description?: string | null
          dialogue_text?: string | null
          display_order?: number
          event_id: string
          id?: string
          interaction_type: string
          is_available?: boolean | null
          requirements?: Json | null
          title: string
          updated_at?: string | null
        }
        Update: {
          character_speaker?: string | null
          choices?: Json | null
          created_at?: string | null
          description?: string | null
          dialogue_text?: string | null
          display_order?: number
          event_id?: string
          id?: string
          interaction_type?: string
          is_available?: boolean | null
          requirements?: Json | null
          title?: string
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "event_interactions_event_id_fkey"
            columns: ["event_id"]
            isOneToOne: false
            referencedRelation: "story_events"
            referencedColumns: ["id"]
          },
        ]
      }
      event_outcomes: {
        Row: {
          choice_key: string | null
          created_at: string | null
          description: string | null
          effects: Json | null
          id: string
          interaction_id: string
          next_event_id: string | null
          outcome_type: string | null
          title: string | null
          updated_at: string | null
        }
        Insert: {
          choice_key?: string | null
          created_at?: string | null
          description?: string | null
          effects?: Json | null
          id?: string
          interaction_id: string
          next_event_id?: string | null
          outcome_type?: string | null
          title?: string | null
          updated_at?: string | null
        }
        Update: {
          choice_key?: string | null
          created_at?: string | null
          description?: string | null
          effects?: Json | null
          id?: string
          interaction_id?: string
          next_event_id?: string | null
          outcome_type?: string | null
          title?: string | null
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "event_outcomes_interaction_id_fkey"
            columns: ["interaction_id"]
            isOneToOne: false
            referencedRelation: "event_interactions"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "event_outcomes_next_event_id_fkey"
            columns: ["next_event_id"]
            isOneToOne: false
            referencedRelation: "story_events"
            referencedColumns: ["id"]
          },
        ]
      }
      items: {
        Row: {
          created_at: string | null
          description: string | null
          effects: Json | null
          id: string
          image_url: string | null
          is_consumable: boolean | null
          is_initial_user_progress: boolean | null
          is_tradeable: boolean | null
          item_type: string | null
          name: string
          rarity: string | null
          stats: Json | null
          updated_at: string | null
        }
        Insert: {
          created_at?: string | null
          description?: string | null
          effects?: Json | null
          id?: string
          image_url?: string | null
          is_consumable?: boolean | null
          is_initial_user_progress?: boolean | null
          is_tradeable?: boolean | null
          item_type?: string | null
          name: string
          rarity?: string | null
          stats?: Json | null
          updated_at?: string | null
        }
        Update: {
          created_at?: string | null
          description?: string | null
          effects?: Json | null
          id?: string
          image_url?: string | null
          is_consumable?: boolean | null
          is_initial_user_progress?: boolean | null
          is_tradeable?: boolean | null
          item_type?: string | null
          name?: string
          rarity?: string | null
          stats?: Json | null
          updated_at?: string | null
        }
        Relationships: []
      }
      map_objects: {
        Row: {
          character_id: string | null
          created_at: string | null
          display_order: number
          id: string
          interaction_id: string | null
          is_interactive: boolean | null
          item_id: string | null
          map_id: string
          name: string
          object_subtype: string | null
          object_type: string
          position_x: number
          position_y: number
          properties: Json | null
          updated_at: string | null
        }
        Insert: {
          character_id?: string | null
          created_at?: string | null
          display_order?: number
          id?: string
          interaction_id?: string | null
          is_interactive?: boolean | null
          item_id?: string | null
          map_id: string
          name: string
          object_subtype?: string | null
          object_type: string
          position_x: number
          position_y: number
          properties?: Json | null
          updated_at?: string | null
        }
        Update: {
          character_id?: string | null
          created_at?: string | null
          display_order?: number
          id?: string
          interaction_id?: string | null
          is_interactive?: boolean | null
          item_id?: string | null
          map_id?: string
          name?: string
          object_subtype?: string | null
          object_type?: string
          position_x?: number
          position_y?: number
          properties?: Json | null
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "map_objects_character_id_fkey"
            columns: ["character_id"]
            isOneToOne: false
            referencedRelation: "characters"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "map_objects_interaction_id_fkey"
            columns: ["interaction_id"]
            isOneToOne: false
            referencedRelation: "event_interactions"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "map_objects_item_id_fkey"
            columns: ["item_id"]
            isOneToOne: false
            referencedRelation: "items"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "map_objects_map_id_fkey"
            columns: ["map_id"]
            isOneToOne: false
            referencedRelation: "maps"
            referencedColumns: ["id"]
          },
        ]
      }
      maps: {
        Row: {
          created_at: string | null
          description: string | null
          display_order: number
          id: string
          image_url: string | null
          is_accessible: boolean | null
          is_alway_hide_until_unlock: boolean | null
          is_initial_user_progress: boolean | null
          linked_map_id: string | null
          map_subtype: string | null
          map_type: string
          name: string
          parent_id: string | null
          position_x: number | null
          position_y: number | null
          size_height: number | null
          size_width: number | null
          unlock_requirements: Json | null
          updated_at: string | null
        }
        Insert: {
          created_at?: string | null
          description?: string | null
          display_order?: number
          id?: string
          image_url?: string | null
          is_accessible?: boolean | null
          is_alway_hide_until_unlock?: boolean | null
          is_initial_user_progress?: boolean | null
          linked_map_id?: string | null
          map_subtype?: string | null
          map_type: string
          name: string
          parent_id?: string | null
          position_x?: number | null
          position_y?: number | null
          size_height?: number | null
          size_width?: number | null
          unlock_requirements?: Json | null
          updated_at?: string | null
        }
        Update: {
          created_at?: string | null
          description?: string | null
          display_order?: number
          id?: string
          image_url?: string | null
          is_accessible?: boolean | null
          is_alway_hide_until_unlock?: boolean | null
          is_initial_user_progress?: boolean | null
          linked_map_id?: string | null
          map_subtype?: string | null
          map_type?: string
          name?: string
          parent_id?: string | null
          position_x?: number | null
          position_y?: number | null
          size_height?: number | null
          size_width?: number | null
          unlock_requirements?: Json | null
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "maps_linked_map_id_fkey"
            columns: ["linked_map_id"]
            isOneToOne: false
            referencedRelation: "maps"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "maps_parent_id_fkey"
            columns: ["parent_id"]
            isOneToOne: false
            referencedRelation: "maps"
            referencedColumns: ["id"]
          },
        ]
      }
      profile_roles: {
        Row: {
          granted_at: string | null
          granted_by: string | null
          id: string
          profile_id: string
          role: Database["public"]["Enums"]["profile_role"]
        }
        Insert: {
          granted_at?: string | null
          granted_by?: string | null
          id?: string
          profile_id: string
          role?: Database["public"]["Enums"]["profile_role"]
        }
        Update: {
          granted_at?: string | null
          granted_by?: string | null
          id?: string
          profile_id?: string
          role?: Database["public"]["Enums"]["profile_role"]
        }
        Relationships: [
          {
            foreignKeyName: "profile_roles_profile_id_fkey"
            columns: ["profile_id"]
            isOneToOne: true
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      profiles: {
        Row: {
          address: string | null
          auth_id: string
          avatar_url: string | null
          bio: string | null
          created_at: string | null
          date_of_birth: string | null
          full_name: string | null
          gender: string | null
          id: string
          is_active: boolean
          last_login: string | null
          login_count: number
          phone: string | null
          preferences: Json
          privacy_settings: Json
          social_links: Json | null
          updated_at: string | null
          username: string | null
          verification_status: string
        }
        Insert: {
          address?: string | null
          auth_id: string
          avatar_url?: string | null
          bio?: string | null
          created_at?: string | null
          date_of_birth?: string | null
          full_name?: string | null
          gender?: string | null
          id?: string
          is_active?: boolean
          last_login?: string | null
          login_count?: number
          phone?: string | null
          preferences?: Json
          privacy_settings?: Json
          social_links?: Json | null
          updated_at?: string | null
          username?: string | null
          verification_status?: string
        }
        Update: {
          address?: string | null
          auth_id?: string
          avatar_url?: string | null
          bio?: string | null
          created_at?: string | null
          date_of_birth?: string | null
          full_name?: string | null
          gender?: string | null
          id?: string
          is_active?: boolean
          last_login?: string | null
          login_count?: number
          phone?: string | null
          preferences?: Json
          privacy_settings?: Json
          social_links?: Json | null
          updated_at?: string | null
          username?: string | null
          verification_status?: string
        }
        Relationships: []
      }
      story_chapters: {
        Row: {
          chapter_number: number
          created_at: string | null
          description: string | null
          display_order: number
          id: string
          is_initial_user_progress: boolean | null
          title: string
          unlock_requirements: Json | null
          updated_at: string | null
        }
        Insert: {
          chapter_number: number
          created_at?: string | null
          description?: string | null
          display_order?: number
          id?: string
          is_initial_user_progress?: boolean | null
          title: string
          unlock_requirements?: Json | null
          updated_at?: string | null
        }
        Update: {
          chapter_number?: number
          created_at?: string | null
          description?: string | null
          display_order?: number
          id?: string
          is_initial_user_progress?: boolean | null
          title?: string
          unlock_requirements?: Json | null
          updated_at?: string | null
        }
        Relationships: []
      }
      story_events: {
        Row: {
          chapter_id: string
          completion_requirements: Json | null
          created_at: string | null
          description: string
          display_order: number
          event_type: string | null
          id: string
          is_initial_user_progress: boolean | null
          map_id: string | null
          rewards: Json | null
          title: string
          unlock_requirements: Json | null
          updated_at: string | null
        }
        Insert: {
          chapter_id: string
          completion_requirements?: Json | null
          created_at?: string | null
          description: string
          display_order?: number
          event_type?: string | null
          id?: string
          is_initial_user_progress?: boolean | null
          map_id?: string | null
          rewards?: Json | null
          title: string
          unlock_requirements?: Json | null
          updated_at?: string | null
        }
        Update: {
          chapter_id?: string
          completion_requirements?: Json | null
          created_at?: string | null
          description?: string
          display_order?: number
          event_type?: string | null
          id?: string
          is_initial_user_progress?: boolean | null
          map_id?: string | null
          rewards?: Json | null
          title?: string
          unlock_requirements?: Json | null
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "story_events_chapter_id_fkey"
            columns: ["chapter_id"]
            isOneToOne: false
            referencedRelation: "story_chapters"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "story_events_map_id_fkey"
            columns: ["map_id"]
            isOneToOne: false
            referencedRelation: "maps"
            referencedColumns: ["id"]
          },
        ]
      }
      user_game_states: {
        Row: {
          achievements: Json | null
          active_quests: Json | null
          character_relationships: Json | null
          completed_chapters: Json | null
          completed_events: Json | null
          completed_interactions: Json | null
          created_at: string | null
          current_chapter_id: string | null
          current_event_id: string | null
          current_map_id: string | null
          game_flags: Json | null
          game_settings: Json | null
          game_stats: Json | null
          id: string
          inventory: Json | null
          last_played_at: string | null
          name: string
          party_members: Json | null
          play_history: Json | null
          player_experience: number | null
          player_level: number | null
          player_position: Json | null
          save_data: Json | null
          unlocked_chapters: Json | null
          unlocked_events: Json | null
          unlocked_maps: Json | null
          updated_at: string | null
          user_id: string
        }
        Insert: {
          achievements?: Json | null
          active_quests?: Json | null
          character_relationships?: Json | null
          completed_chapters?: Json | null
          completed_events?: Json | null
          completed_interactions?: Json | null
          created_at?: string | null
          current_chapter_id?: string | null
          current_event_id?: string | null
          current_map_id?: string | null
          game_flags?: Json | null
          game_settings?: Json | null
          game_stats?: Json | null
          id?: string
          inventory?: Json | null
          last_played_at?: string | null
          name?: string
          party_members?: Json | null
          play_history?: Json | null
          player_experience?: number | null
          player_level?: number | null
          player_position?: Json | null
          save_data?: Json | null
          unlocked_chapters?: Json | null
          unlocked_events?: Json | null
          unlocked_maps?: Json | null
          updated_at?: string | null
          user_id: string
        }
        Update: {
          achievements?: Json | null
          active_quests?: Json | null
          character_relationships?: Json | null
          completed_chapters?: Json | null
          completed_events?: Json | null
          completed_interactions?: Json | null
          created_at?: string | null
          current_chapter_id?: string | null
          current_event_id?: string | null
          current_map_id?: string | null
          game_flags?: Json | null
          game_settings?: Json | null
          game_stats?: Json | null
          id?: string
          inventory?: Json | null
          last_played_at?: string | null
          name?: string
          party_members?: Json | null
          play_history?: Json | null
          player_experience?: number | null
          player_level?: number | null
          player_position?: Json | null
          save_data?: Json | null
          unlocked_chapters?: Json | null
          unlocked_events?: Json | null
          unlocked_maps?: Json | null
          updated_at?: string | null
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "user_game_states_current_chapter_id_fkey"
            columns: ["current_chapter_id"]
            isOneToOne: false
            referencedRelation: "story_chapters"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "user_game_states_current_event_id_fkey"
            columns: ["current_event_id"]
            isOneToOne: false
            referencedRelation: "story_events"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "user_game_states_current_map_id_fkey"
            columns: ["current_map_id"]
            isOneToOne: false
            referencedRelation: "maps"
            referencedColumns: ["id"]
          },
        ]
      }
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      complete_interaction_for_user_game_state: {
        Args: {
          p_user_game_state_uuid: string
          p_interaction_uuid: string
          p_choice_data?: Json
        }
        Returns: Json
      }
      create_profile: {
        Args: { username: string; full_name?: string; avatar_url?: string }
        Returns: string
      }
      get_active_profile: {
        Args: Record<PropertyKey, never>
        Returns: {
          address: string | null
          auth_id: string
          avatar_url: string | null
          bio: string | null
          created_at: string | null
          date_of_birth: string | null
          full_name: string | null
          gender: string | null
          id: string
          is_active: boolean
          last_login: string | null
          login_count: number
          phone: string | null
          preferences: Json
          privacy_settings: Json
          social_links: Json | null
          updated_at: string | null
          username: string | null
          verification_status: string
        }[]
      }
      get_active_profile_id: {
        Args: Record<PropertyKey, never>
        Returns: string
      }
      get_active_profile_role: {
        Args: Record<PropertyKey, never>
        Returns: Database["public"]["Enums"]["profile_role"]
      }
      get_all_characters: {
        Args: Record<PropertyKey, never>
        Returns: Json
      }
      get_all_items: {
        Args: Record<PropertyKey, never>
        Returns: Json
      }
      get_auth_user_by_id: {
        Args: { p_id: string }
        Returns: Json
      }
      get_available_events_for_user_game_states: {
        Args: { p_user_game_state_uuid: string }
        Returns: Json
      }
      get_available_events_for_user_game_states_at_map: {
        Args: { p_user_game_state_uuid: string; p_map_uuid: string }
        Returns: Json
      }
      get_event_interactions_for_user_game_states: {
        Args: { p_user_game_state_uuid: string; p_event_uuid: string }
        Returns: Json
      }
      get_paginated_users: {
        Args: { p_page?: number; p_limit?: number }
        Returns: Json
      }
      get_profile_role: {
        Args: { profile_id: string }
        Returns: Database["public"]["Enums"]["profile_role"]
      }
      get_user_game_states_by_id: {
        Args: { p_user_game_state_uuid: string }
        Returns: Json
      }
      get_user_profiles: {
        Args: Record<PropertyKey, never>
        Returns: {
          address: string | null
          auth_id: string
          avatar_url: string | null
          bio: string | null
          created_at: string | null
          date_of_birth: string | null
          full_name: string | null
          gender: string | null
          id: string
          is_active: boolean
          last_login: string | null
          login_count: number
          phone: string | null
          preferences: Json
          privacy_settings: Json
          social_links: Json | null
          updated_at: string | null
          username: string | null
          verification_status: string
        }[]
      }
      initialize_user_game_states: {
        Args: { p_user_id: string; p_name?: string }
        Returns: Json
      }
      is_admin: {
        Args: Record<PropertyKey, never>
        Returns: boolean
      }
      is_moderator_or_admin: {
        Args: Record<PropertyKey, never>
        Returns: boolean
      }
      is_service_role: {
        Args: Record<PropertyKey, never>
        Returns: boolean
      }
      migrate_profile_roles: {
        Args: Record<PropertyKey, never>
        Returns: undefined
      }
      set_profile_active: {
        Args: { profile_id: string }
        Returns: boolean
      }
      set_profile_role: {
        Args: {
          target_profile_id: string
          new_role: Database["public"]["Enums"]["profile_role"]
        }
        Returns: boolean
      }
    }
    Enums: {
      profile_role: "user" | "moderator" | "admin"
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
}

type DefaultSchema = Database[Extract<keyof Database, "public">]

export type Tables<
  DefaultSchemaTableNameOrOptions extends
    | keyof (DefaultSchema["Tables"] & DefaultSchema["Views"])
    | { schema: keyof Database },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof Database
  }
    ? keyof (Database[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
        Database[DefaultSchemaTableNameOrOptions["schema"]]["Views"])
    : never = never,
> = DefaultSchemaTableNameOrOptions extends { schema: keyof Database }
  ? (Database[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
      Database[DefaultSchemaTableNameOrOptions["schema"]]["Views"])[TableName] extends {
      Row: infer R
    }
    ? R
    : never
  : DefaultSchemaTableNameOrOptions extends keyof (DefaultSchema["Tables"] &
        DefaultSchema["Views"])
    ? (DefaultSchema["Tables"] &
        DefaultSchema["Views"])[DefaultSchemaTableNameOrOptions] extends {
        Row: infer R
      }
      ? R
      : never
    : never

export type TablesInsert<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof Database },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof Database
  }
    ? keyof Database[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends { schema: keyof Database }
  ? Database[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Insert: infer I
    }
    ? I
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Insert: infer I
      }
      ? I
      : never
    : never

export type TablesUpdate<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof Database },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof Database
  }
    ? keyof Database[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends { schema: keyof Database }
  ? Database[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Update: infer U
    }
    ? U
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Update: infer U
      }
      ? U
      : never
    : never

export type Enums<
  DefaultSchemaEnumNameOrOptions extends
    | keyof DefaultSchema["Enums"]
    | { schema: keyof Database },
  EnumName extends DefaultSchemaEnumNameOrOptions extends {
    schema: keyof Database
  }
    ? keyof Database[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"]
    : never = never,
> = DefaultSchemaEnumNameOrOptions extends { schema: keyof Database }
  ? Database[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"][EnumName]
  : DefaultSchemaEnumNameOrOptions extends keyof DefaultSchema["Enums"]
    ? DefaultSchema["Enums"][DefaultSchemaEnumNameOrOptions]
    : never

export type CompositeTypes<
  PublicCompositeTypeNameOrOptions extends
    | keyof DefaultSchema["CompositeTypes"]
    | { schema: keyof Database },
  CompositeTypeName extends PublicCompositeTypeNameOrOptions extends {
    schema: keyof Database
  }
    ? keyof Database[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"]
    : never = never,
> = PublicCompositeTypeNameOrOptions extends { schema: keyof Database }
  ? Database[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"][CompositeTypeName]
  : PublicCompositeTypeNameOrOptions extends keyof DefaultSchema["CompositeTypes"]
    ? DefaultSchema["CompositeTypes"][PublicCompositeTypeNameOrOptions]
    : never

export const Constants = {
  public: {
    Enums: {
      profile_role: ["user", "moderator", "admin"],
    },
  },
} as const

