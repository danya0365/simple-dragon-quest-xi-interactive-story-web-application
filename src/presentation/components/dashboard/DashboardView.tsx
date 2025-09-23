"use client";

import { EventInteractionView } from "@/src/presentation/components/game/EventInteractionView";
import { LocationView } from "@/src/presentation/components/game/LocationView";
import { WorldMapView } from "@/src/presentation/components/game/WorldMapView";
import { useAuthStore } from "@/src/stores/authStore";
import { useGameStore } from "@/src/stores/gameStore";
import { useRouter } from "next/navigation";
import { useEffect, useState } from "react";

export function DashboardView() {
  const router = useRouter();
  const { user, signOut, loading: authLoading, initialized } = useAuthStore();
  const {
    currentView,
    userGameState,
    loading: gameLoading,
    loadUserGameState,
    setCurrentView,
    reset: resetGameStore,
  } = useGameStore();

  const [showUserMenu, setShowUserMenu] = useState(false);

  // Initialize user data
  useEffect(() => {
    if (user?.id && initialized) {
      loadUserGameState(user.id);
    }
  }, [user?.id, initialized, loadUserGameState]);

  // Redirect if not authenticated
  useEffect(() => {
    if (!authLoading && initialized && !user) {
      router.push("/login");
    }
  }, [user, authLoading, initialized, router]);

  const handleSignOut = async () => {
    await signOut();
    resetGameStore();
    router.push("/");
  };

  const handleViewChange = (view: typeof currentView) => {
    setCurrentView(view);
  };

  useEffect(() => {
    console.log(authLoading, initialized);
  }, [authLoading, initialized]);

  // Show loading while initializing
  if (authLoading || !initialized) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-blue-900 via-purple-900 to-indigo-900 flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-yellow-400 mx-auto mb-4"></div>
          <p className="text-white text-lg">กำลังโหลด...</p>
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
            <nav className="hidden md:flex space-x-6">
              <button
                onClick={() => handleViewChange("world_map")}
                className={`px-3 py-2 rounded-lg transition-colors ${
                  currentView === "world_map"
                    ? "bg-yellow-500/20 text-yellow-300 border border-yellow-500/50"
                    : "text-blue-200 hover:text-white hover:bg-white/10"
                }`}
              >
                🗺️ แผนที่โลก
              </button>
              <button
                onClick={() => handleViewChange("inventory")}
                className={`px-3 py-2 rounded-lg transition-colors ${
                  currentView === "inventory"
                    ? "bg-yellow-500/20 text-yellow-300 border border-yellow-500/50"
                    : "text-blue-200 hover:text-white hover:bg-white/10"
                }`}
              >
                🎒 กระเป๋า
              </button>
              <button
                onClick={() => handleViewChange("party")}
                className={`px-3 py-2 rounded-lg transition-colors ${
                  currentView === "party"
                    ? "bg-yellow-500/20 text-yellow-300 border border-yellow-500/50"
                    : "text-blue-200 hover:text-white hover:bg-white/10"
                }`}
              >
                👥 ปาร์ตี้
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
      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="grid grid-cols-1 lg:grid-cols-4 gap-8">
          {/* Sidebar - Game Stats */}
          <div className="lg:col-span-1 space-y-6">
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
                  <div>
                    <span className="text-blue-300 text-sm">
                      เหตุการณ์ที่เสร็จแล้ว:
                    </span>
                    <p className="text-white font-medium">
                      {userGameState.completed_events?.length || 0}
                    </p>
                  </div>
                  <div>
                    <span className="text-blue-300 text-sm">
                      สมาชิกปาร์ตี้:
                    </span>
                    <p className="text-white font-medium">
                      {userGameState.party_members?.length || 0}
                    </p>
                  </div>
                  <div>
                    <span className="text-blue-300 text-sm">ไอเทม:</span>
                    <p className="text-white font-medium">
                      {userGameState.inventory?.length || 0}
                    </p>
                  </div>
                  {userGameState.last_played_at && (
                    <div>
                      <span className="text-blue-300 text-sm">เล่นล่าสุด:</span>
                      <p className="text-white text-sm">
                        {new Date(
                          userGameState.last_played_at
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
                  onClick={() => user?.id && loadUserGameState(user.id)}
                  className="w-full text-left px-3 py-2 text-blue-200 hover:text-white hover:bg-white/10 rounded-lg transition-colors"
                >
                  🔄 รีเฟรชข้อมูล
                </button>
              </div>
            </div>
          </div>

          {/* Main Game Area */}
          <div className="lg:col-span-3">
            {currentView === "world_map" && <WorldMapView />}
            {currentView === "location" && <LocationView />}
            {currentView === "event" && <EventInteractionView />}
            {currentView === "inventory" && (
              <div className="text-center py-12">
                <div className="text-blue-400 text-6xl mb-4">🎒</div>
                <p className="text-blue-200 font-medium mb-2">กระเป๋า</p>
                <p className="text-blue-300">
                  ฟีเจอร์นี้จะพร้อมใช้งานเร็วๆ นี้
                </p>
              </div>
            )}
            {currentView === "party" && (
              <div className="text-center py-12">
                <div className="text-blue-400 text-6xl mb-4">👥</div>
                <p className="text-blue-200 font-medium mb-2">ปาร์ตี้</p>
                <p className="text-blue-300">
                  ฟีเจอร์นี้จะพร้อมใช้งานเร็วๆ นี้
                </p>
              </div>
            )}
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
