import { create } from "zustand";
import { persist } from "zustand/middleware";
import { createClientSupabaseClient } from "@/src/infrastructure/config/supabase-client-client";
import type { User, Session } from "@supabase/supabase-js";

interface AuthState {
  user: User | null;
  session: Session | null;
  loading: boolean;
  initialized: boolean;
}

interface AuthActions {
  setUser: (user: User | null) => void;
  setSession: (session: Session | null) => void;
  setLoading: (loading: boolean) => void;
  setInitialized: (initialized: boolean) => void;
  signIn: (email: string, password: string) => Promise<{ error?: string }>;
  signUp: (email: string, password: string) => Promise<{ error?: string }>;
  signOut: () => Promise<void>;
  initialize: () => Promise<void>;
  initializeUserProgress: () => Promise<void>;
}

type AuthStore = AuthState & AuthActions;

export const useAuthStore = create<AuthStore>()(
  persist(
    (set, get) => ({
      // State
      user: null,
      session: null,
      loading: true,
      initialized: false,

      // Actions
      setUser: (user) => set({ user }),
      setSession: (session) => set({ session }),
      setLoading: (loading) => set({ loading }),
      setInitialized: (initialized) => set({ initialized }),

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
            await get().initializeUserProgress();
          }

          return {};
        } catch (error) {
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
        } catch (error) {
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
              initialized: true,
            });
          } else {
            set({
              user: null,
              session: null,
              loading: false,
              initialized: true,
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

              // Initialize user progress for new users
              if (event === "SIGNED_IN") {
                await get().initializeUserProgress();
              }
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
            initialized: true,
          });
        }
      },

      initializeUserProgress: async () => {
        const { user } = get();
        if (!user) return;

        const supabase = createClientSupabaseClient();

        try {
          // Call the initialize_user_progress function
          const { error } = await supabase.rpc("initialize_user_progress", {
            user_uuid: user.id,
          });

          if (error) {
            console.error("Error initializing user progress:", error);
          }
        } catch (error) {
          console.error("Error calling initialize_user_progress:", error);
        }
      },
    }),
    {
      name: "dragon-quest-auth",
      partialize: (state) => ({
        user: state.user,
        session: state.session,
        initialized: state.initialized,
      }),
    }
  )
);
