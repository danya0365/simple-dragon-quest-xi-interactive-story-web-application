"use client";

import { AvailableEventsView } from "@/src/presentation/components/game/AvailableEventsView";
import { CompletedEventsView } from "@/src/presentation/components/game/CompletedEventsView";
import { EventInteractionView } from "@/src/presentation/components/game/EventInteractionView";
import { EventView } from "@/src/presentation/components/game/EventView";
import { InventoryView } from "@/src/presentation/components/game/InventoryView";
import { LocationView } from "@/src/presentation/components/game/LocationView";
import { PartyView } from "@/src/presentation/components/game/PartyView";
import { WorldMapView } from "@/src/presentation/components/game/WorldMapView";
import { useAuthStore } from "@/src/stores/authStore";
import { useGameStore, type GameView } from "@/src/stores/gameStore";
import { useRouter } from "next/navigation";
import { useEffect, useState } from "react";

export function StoryMapView() {
  const router = useRouter();
  const { user, signOut, loading: authLoading, isInitialized } = useAuthStore();
  const {
    currentView,
    userGameState,
    loading: gameLoading,
    loadUserGameState,
    initializeUserProgress,
    deleteUserProgress,
    loadAvailableEventsForUserProgress,
    setCurrentView,
    reset: resetGameStore,
  } = useGameStore();

  const [showUserMenu, setShowUserMenu] = useState(false);
  const [progressInitialized, setProgressInitialized] = useState(false);
  const [progressError, setProgressError] = useState<string | null>(null);
  const [isDeletingProgress, setIsDeletingProgress] = useState(false);

  // Initialize user progress and game data
  useEffect(() => {
    const initializeProgress = async () => {
      if (user?.id && !progressInitialized && !userGameState?.id) {
        try {
          // Initialize user progress first
          await initializeUserProgress(user.id);
          setProgressInitialized(true);
          setProgressError(null);
        } catch (error) {
          console.error("Failed to initialize user progress:", error);
          setProgressError(
            "ไม่สามารถเริ่มต้นความคืบหน้าเกมได้ กรุณาลองใหม่อีกครั้ง"
          );
        }
      }
    };

    initializeProgress();
  }, [
    user?.id,
    progressInitialized,
    userGameState?.id,
    initializeUserProgress,
  ]);

  // Load user game state when progress is initialized
  useEffect(() => {
    if (userGameState?.id && progressInitialized) {
      loadUserGameState();
    }
  }, [userGameState?.id, progressInitialized, loadUserGameState]);

  // Redirect if not authenticated
  useEffect(() => {
    if (!user) {
      router.push("/login");
    }
  }, [user, router]);

  const handleSignOut = async () => {
    await signOut();
    resetGameStore();
    router.push("/");
  };

  const handleViewChange = (view: GameView) => {
    setCurrentView(view);

    // Load available events for user progress when switching to available_event view
    if (view === "available_event") {
      loadAvailableEventsForUserProgress();
    }
  };

  // Show loading while initializing or if not properly initialized
  if (authLoading || !isInitialized) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-blue-900 via-purple-900 to-indigo-900 flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-yellow-400 mx-auto mb-4"></div>
          <p className="text-white text-lg">กำลังโหลด...</p>
        </div>
      </div>
    );
  }

  // Show loading while initializing user progress
  if (user && !progressInitialized && !userGameState?.id && !progressError) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-blue-900 via-purple-900 to-indigo-900 flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-yellow-400 mx-auto mb-4"></div>
          <p className="text-white text-lg">กำลังเริ่มต้นความคืบหน้าเกม...</p>
        </div>
      </div>
    );
  }

  // Show error if user progress initialization failed
  if (progressError) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-blue-900 via-purple-900 to-indigo-900 flex items-center justify-center">
        <div className="text-center max-w-md mx-auto p-6">
          <div className="text-red-400 text-6xl mb-4">⚠️</div>
          <h2 className="text-white text-xl font-bold mb-2">เกิดข้อผิดพลาด</h2>
          <p className="text-blue-200 mb-6">{progressError}</p>
          <button
            onClick={() => {
              setProgressError(null);
              setProgressInitialized(false);
            }}
            className="bg-yellow-500 hover:bg-yellow-600 text-blue-900 font-bold py-2 px-6 rounded-lg transition-colors"
          >
            ลองใหม่อีกครั้ง
          </button>
        </div>
      </div>
    );
  }

  // Redirect if no user
  if (!user) {
    return null;
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-900 via-purple-900 to-indigo-900">
      {/* Header */}
      <header className="bg-black/20 backdrop-blur-md border-b border-white/10">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex items-center justify-between h-16">
            {/* Logo */}
            <div className="flex items-center">
              <h1 className="text-2xl font-bold text-yellow-400 font-serif">
                Dragon Quest XI
              </h1>
              <span className="ml-2 text-blue-200 text-sm">
                Interactive Story
              </span>
            </div>

            {/* Navigation */}
            <nav className="hidden md:flex space-x-4">
              <button
                onClick={() => handleViewChange("world_map")}
                className={`px-3 py-2 rounded-lg transition-all duration-200 transform hover:scale-105 ${
                  currentView === "world_map"
                    ? "bg-yellow-500/20 text-yellow-300 border border-yellow-500/50 shadow-lg"
                    : "text-blue-200 hover:text-white hover:bg-white/10"
                }`}
              >
                🗺️ แผนที่โลก
              </button>
              <button
                onClick={() => handleViewChange("inventory")}
                className={`px-3 py-2 rounded-lg transition-all duration-200 transform hover:scale-105 ${
                  currentView === "inventory"
                    ? "bg-yellow-500/20 text-yellow-300 border border-yellow-500/50 shadow-lg"
                    : "text-blue-200 hover:text-white hover:bg-white/10"
                }`}
              >
                🎒 กระเป๋า
              </button>
              <button
                onClick={() => handleViewChange("party")}
                className={`px-3 py-2 rounded-lg transition-all duration-200 transform hover:scale-105 ${
                  currentView === "party"
                    ? "bg-yellow-500/20 text-yellow-300 border border-yellow-500/50 shadow-lg"
                    : "text-blue-200 hover:text-white hover:bg-white/10"
                }`}
              >
                👥 ปาร์ตี้
              </button>
            </nav>

            {/* Mobile Navigation */}
            <nav className="md:hidden flex space-x-2">
              <button
                onClick={() => handleViewChange("world_map")}
                className={`p-2 rounded-lg transition-all duration-200 ${
                  currentView === "world_map"
                    ? "bg-yellow-500/20 text-yellow-300 border border-yellow-500/50"
                    : "text-blue-200 hover:text-white hover:bg-white/10"
                }`}
                title="แผนที่โลก"
              >
                🗺️
              </button>
              <button
                onClick={() => handleViewChange("available_event")}
                className={`p-2 rounded-lg transition-all duration-200 ${
                  currentView === "available_event"
                    ? "bg-yellow-500/20 text-yellow-300 border border-yellow-500/50"
                    : "text-blue-200 hover:text-white hover:bg-white/10"
                }`}
                title="เหตุการณ์ทั้งหมด"
              >
                ⚡
              </button>
              <button
                onClick={() => handleViewChange("inventory")}
                className={`p-2 rounded-lg transition-all duration-200 ${
                  currentView === "inventory"
                    ? "bg-yellow-500/20 text-yellow-300 border border-yellow-500/50"
                    : "text-blue-200 hover:text-white hover:bg-white/10"
                }`}
                title="กระเป๋า"
              >
                🎒
              </button>
              <button
                onClick={() => handleViewChange("party")}
                className={`p-2 rounded-lg transition-all duration-200 ${
                  currentView === "party"
                    ? "bg-yellow-500/20 text-yellow-300 border border-yellow-500/50"
                    : "text-blue-200 hover:text-white hover:bg-white/10"
                }`}
                title="ปาร์ตี้"
              >
                👥
              </button>
            </nav>

            {/* User Menu */}
            <div className="relative">
              <button
                onClick={() => setShowUserMenu(!showUserMenu)}
                className="flex items-center space-x-2 text-blue-200 hover:text-white transition-colors"
              >
                <div className="w-8 h-8 bg-gradient-to-br from-yellow-400 to-yellow-500 rounded-full flex items-center justify-center">
                  <span className="text-blue-900 font-bold text-sm">
                    {user.email?.charAt(0).toUpperCase()}
                  </span>
                </div>
                <span className="hidden sm:block">{user.email}</span>
                <span className="text-xs">▼</span>
              </button>

              {showUserMenu && (
                <div className="absolute right-0 mt-2 w-48 bg-white/10 backdrop-blur-md rounded-lg border border-white/20 shadow-lg z-50">
                  <div className="p-2">
                    <button
                      onClick={handleSignOut}
                      className="w-full text-left px-3 py-2 text-red-300 hover:text-red-200 hover:bg-red-500/10 rounded-lg transition-colors"
                    >
                      🚪 ออกจากระบบ
                    </button>
                  </div>
                </div>
              )}
            </div>
          </div>
        </div>
      </header>

      {/* Main Content */}
      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4 lg:py-8">
        <div className="grid grid-cols-1 lg:grid-cols-4 gap-4 lg:gap-8">
          {/* Sidebar - Game Stats */}
          <div className="lg:col-span-1 order-2 lg:order-1 space-y-4 lg:space-y-6">
            {/* User Progress Card */}
            <div className="bg-white/10 backdrop-blur-md rounded-lg border border-white/20 p-6">
              <h3 className="text-yellow-400 font-bold mb-4">ความคืบหน้า</h3>

              {gameLoading ? (
                <div className="text-center">
                  <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-yellow-400 mx-auto mb-2"></div>
                  <p className="text-blue-200 text-sm">กำลังโหลด...</p>
                </div>
              ) : userGameState ? (
                <div className="space-y-3">
                  <div className="flex flex-col items-start justify-start gap-2">
                    <span className="text-blue-300 text-sm">
                      เหตุการณ์ที่เสร็จแล้ว:
                    </span>
                    <button
                      className="text-white font-medium"
                      onClick={() => handleViewChange("completed_event")}
                    >
                      {userGameState.completedEvents?.length || 0}
                    </button>
                  </div>
                  <div className="flex flex-col items-start justify-start gap-2">
                    <span className="text-blue-300 text-sm">
                      สมาชิกปาร์ตี้:
                    </span>
                    <button
                      className="text-white font-medium"
                      onClick={() => handleViewChange("party")}
                    >
                      {userGameState.partyMembers?.length || 0}
                    </button>
                  </div>
                  <div className="flex flex-col items-start justify-start gap-2">
                    <span className="text-blue-300 text-sm">ไอเทม:</span>
                    <button
                      className="text-white font-medium"
                      onClick={() => handleViewChange("inventory")}
                    >
                      {userGameState.inventory?.length || 0}
                    </button>
                  </div>
                  {userGameState.lastPlayedAt && (
                    <div className="flex flex-col items-start justify-start gap-2">
                      <span className="text-blue-300 text-sm">เล่นล่าสุด:</span>
                      <p className="text-white text-sm">
                        {new Date(
                          userGameState.lastPlayedAt
                        ).toLocaleDateString("th-TH")}
                      </p>
                    </div>
                  )}
                </div>
              ) : (
                <p className="text-blue-200 text-sm">ไม่มีข้อมูลความคืบหน้า</p>
              )}
            </div>

            {/* Quick Actions */}
            <div className="bg-white/10 backdrop-blur-md rounded-lg border border-white/20 p-6">
              <h3 className="text-yellow-400 font-bold mb-4">การดำเนินการ</h3>
              <div className="space-y-2">
                <button
                  onClick={() => handleViewChange("world_map")}
                  className="w-full text-left px-3 py-2 text-blue-200 hover:text-white hover:bg-white/10 rounded-lg transition-colors"
                >
                  🗺️ ไปแผนที่โลก
                </button>
                <button
                  onClick={() => handleViewChange("available_event")}
                  className="w-full text-left px-3 py-2 text-blue-200 hover:text-white hover:bg-white/10 rounded-lg transition-colors"
                >
                  ⚡ เหตุการณ์ทั้งหมด (เหมือนโกงเกม)
                </button>
                <button
                  onClick={async () => {
                    if (!user?.id) return;

                    try {
                      setIsDeletingProgress(true);
                      await deleteUserProgress(user.id);
                      setProgressError(null);
                      setProgressInitialized(false);
                    } catch (error) {
                      console.error("Failed to delete user progress:", error);
                      setProgressError(
                        "ไม่สามารถลบความคืบหน้าเกมได้ กรุณาลองใหม่อีกครั้ง"
                      );
                    } finally {
                      setIsDeletingProgress(false);
                    }
                  }}
                  disabled={isDeletingProgress}
                  className="w-full text-left px-3 py-2 text-blue-200 hover:text-white hover:bg-white/10 rounded-lg transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
                >
                  {isDeletingProgress
                    ? "⏳ กำลังลบความคืบหน้า..."
                    : "🔄 ลองเริ่มต้นความคืบหน้าใหม่"}
                </button>
                <button
                  onClick={() => userGameState?.id && loadUserGameState()}
                  className="w-full text-left px-3 py-2 text-blue-200 hover:text-white hover:bg-white/10 rounded-lg transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
                  disabled={!userGameState?.id}
                >
                  🔄 รีเฟรชข้อมูล
                </button>
              </div>
            </div>
          </div>

          {/* Main Game Area */}
          <div className="lg:col-span-3 order-1 lg:order-2">
            <div className="bg-white/5 backdrop-blur-sm rounded-lg border border-white/10 p-4 lg:p-6 min-h-[500px]">
              {currentView === "world_map" && <WorldMapView />}
              {currentView === "location" && <LocationView />}
              {currentView === "event" && <EventView />}
              {currentView === "event_interaction" && <EventInteractionView />}
              {currentView === "available_event" && <AvailableEventsView />}
              {currentView === "completed_event" && <CompletedEventsView />}
              {currentView === "inventory" && <InventoryView />}
              {currentView === "party" && <PartyView />}
            </div>
          </div>
        </div>
      </main>

      {/* Click outside to close user menu */}
      {showUserMenu && (
        <div
          className="fixed inset-0 z-40"
          onClick={() => setShowUserMenu(false)}
        ></div>
      )}
    </div>
  );
}
