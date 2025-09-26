import { createClientSupabaseClient } from "@/src/infrastructure/config/supabase-client-client";
import type { Session, User } from "@supabase/supabase-js";
import { create } from "zustand";
import { persist } from "zustand/middleware";
import { useGameStore } from "./gameStore";

interface AuthState {
  user: User | null;
  session: Session | null;
  loading: boolean;
  isInitialized: boolean;
  _authSubscription?: { unsubscribe: () => void } | null;
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
  validateSession: () => Promise<boolean>;
  clearAuthState: () => void;
}

type AuthStore = AuthState & AuthActions;

export const useAuthStore = create<AuthStore>()(
  persist(
    (set, get) => ({
      // State
      user: null,
      session: null,
      loading: true,
      isInitialized: false,
      _authSubscription: null,

      // Actions
      setUser: (user) => set({ user }),
      setSession: (session) => set({ session }),
      setLoading: (loading) => set({ loading }),
      setInitialized: (initialized) => set({ isInitialized: initialized }),

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
            // Validate session is still active
            const isValid = await get().validateSession();
            if (isValid) {
              set({
                user: session.user,
                session: session,
                loading: false,
                isInitialized: true,
              });
            } else {
              // Session expired, clear auth state
              get().clearAuthState();
            }
          } else {
            set({
              user: null,
              session: null,
              loading: false,
              isInitialized: true,
            });
          }

          // Listen for auth changes
          const { data: { subscription } } = supabase.auth.onAuthStateChange(async (event, session) => {
            console.log('Auth state changed:', event, session ? 'Session exists' : 'No session');
            
            switch (event) {
              case 'SIGNED_IN':
                if (session) {
                  set({
                    user: session.user,
                    session: session,
                    loading: false,
                    isInitialized: true,
                  });
                }
                break;
              case 'SIGNED_OUT':
                get().clearAuthState();
                break;
              case 'TOKEN_REFRESHED':
                if (session) {
                  set({
                    user: session.user,
                    session: session,
                    loading: false,
                    isInitialized: true,
                  });
                }
                break;
              case 'USER_UPDATED':
                if (session) {
                  set({
                    user: session.user,
                    session: session,
                    loading: false,
                    isInitialized: true,
                  });
                }
                break;
              default:
                // For any other event, validate the session
                if (session) {
                  const isValid = await get().validateSession();
                  if (isValid) {
                    set({
                      user: session.user,
                      session: session,
                      loading: false,
                      isInitialized: true,
                    });
                  } else {
                    get().clearAuthState();
                  }
                } else {
                  get().clearAuthState();
                }
                break;
            }
          });

          // Store subscription for cleanup
          set({ _authSubscription: subscription });
        } catch (error) {
          console.error("Error initializing auth:", error);
          set({
            user: null,
            session: null,
            loading: false,
            isInitialized: true,
          });
        }
      },

      validateSession: async () => {
        const supabase = createClientSupabaseClient();
        try {
          const { data: { user }, error } = await supabase.auth.getUser();
          
          if (error || !user) {
            console.log('Session validation failed:', error?.message || 'No user found');
            return false;
          }
          
          return true;
        } catch (error) {
          console.error('Error validating session:', error);
          return false;
        }
      },

      clearAuthState: () => {
        // Clean up auth subscription if it exists
        const { _authSubscription } = get();
        if (_authSubscription) {
          _authSubscription.unsubscribe();
        }
        
        // Reset game store
        useGameStore.getState().reset();
        
        set({
          user: null,
          session: null,
          loading: false,
          isInitialized: true,
          _authSubscription: undefined,
        });
      },
    }),
    {
      name: "dragon-quest-auth",
      partialize: (state) => ({
        user: state.user,
        session: state.session,
        isInitialized: state.isInitialized,
        // Exclude _authSubscription from persistence
      }),
      // Reset loading state on hydration and validate session
      onRehydrateStorage: () => (state) => {
        if (state) {
          state.loading = false;
          
          // Validate session after hydration
          if (state.session && state.user) {
            setTimeout(async () => {
              const isValid = await state.validateSession();
              if (!isValid) {
                state.clearAuthState();
              }
            }, 0);
          }
        }
      },
    }
  )
);
