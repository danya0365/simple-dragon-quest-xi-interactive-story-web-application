import { createClientSupabaseClient } from "@/src/infrastructure/config/supabase-client-client";
import type { Session, User } from "@supabase/supabase-js";
import { create } from "zustand";
import { persist } from "zustand/middleware";
import { useGameStore } from "./gameStore";

interface AuthState {
  user: User | null;
  session: Session | null;
  loading: boolean;
}

interface AuthActions {
  setUser: (user: User | null) => void;
  setSession: (session: Session | null) => void;
  setLoading: (loading: boolean) => void;
  signIn: (email: string, password: string) => Promise<{ error?: string }>;
  signUp: (email: string, password: string) => Promise<{ error?: string }>;
  signOut: () => Promise<void>;
}

type AuthStore = AuthState & AuthActions;

export const useAuthStore = create<AuthStore>()(
  persist(
    (set, get) => ({
      // State
      user: null,
      session: null,
      loading: true,

      // Actions
      setUser: (user) => set({ user }),
      setSession: (session) => set({ session }),
      setLoading: (loading) => set({ loading }),

      signIn: async (email: string, password: string) => {
        set({ loading: true });
        const supabase = createClientSupabaseClient();

        try {
          const { data, error } = await supabase.auth.signInWithPassword({
            email,
            password,
          });

          if (error) {
            set({ loading: false });
            return { error: error.message };
          }

          if (data.user && data.session) {
            set({
              user: data.user,
              session: data.session,
              loading: false,
            });

            // Initialize user progress if this is first time
            await useGameStore.getState().initializeUserProgress(data.user.id);
          }

          return {};
        } catch (err) {
          console.error("Sign in error:", err);
          set({ loading: false });
          return { error: "เกิดข้อผิดพลาดในการเข้าสู่ระบบ" };
        }
      },

      signUp: async (email: string, password: string) => {
        set({ loading: true });
        const supabase = createClientSupabaseClient();

        try {
          const { data, error } = await supabase.auth.signUp({
            email,
            password,
          });

          if (error) {
            set({ loading: false });
            return { error: error.message };
          }

          if (data.user) {
            // Note: User might need to confirm email first
            set({ loading: false });
            return {};
          }

          set({ loading: false });
          return { error: "เกิดข้อผิดพลาดในการสมัครสมาชิก" };
        } catch (err) {
          console.error("Sign up error:", err);
          set({ loading: false });
          return { error: "เกิดข้อผิดพลาดในการสมัครสมาชิก" };
        }
      },

      signOut: async () => {
        set({ loading: true });
        const supabase = createClientSupabaseClient();

        try {
          await supabase.auth.signOut();
          set({
            user: null,
            session: null,
            loading: false,
          });
        } catch (error) {
          console.error("Error signing out:", error);
          set({ loading: false });
        }
      },

      initialize: async () => {
        set({ loading: true });
        const supabase = createClientSupabaseClient();

        try {
          // Get initial session
          const {
            data: { session },
          } = await supabase.auth.getSession();

          if (session) {
            set({
              user: session.user,
              session: session,
              loading: false,
            });
          } else {
            set({
              user: null,
              session: null,
              loading: false,
            });
          }

          // Listen for auth changes
          supabase.auth.onAuthStateChange(async (event, session) => {
            if (session) {
              set({
                user: session.user,
                session: session,
                loading: false,
              });
            } else {
              set({
                user: null,
                session: null,
                loading: false,
              });
            }
          });
        } catch (error) {
          console.error("Error initializing auth:", error);
          set({
            user: null,
            session: null,
            loading: false,
          });
        }
      },
    }),
    {
      name: "dragon-quest-auth",
      partialize: (state) => ({
        user: state.user,
        session: state.session,
      }),
      // Reset loading state on hydration
      onRehydrateStorage: () => (state) => {
        if (state) {
          state.loading = false;
        }
      },
    }
  )
);
