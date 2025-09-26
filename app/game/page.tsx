"use client";

import { MapView } from "@/src/presentation/components/game/MapView";
import { useGameStore } from "@/src/stores/gameStore";
import { useEffect } from "react";

export default function GamePage() {
  const {
    userGameState,
    loading,
    error,
    loadUserGameState,
    loadMaps,
    loadMapObjects,
  } = useGameStore();

  useEffect(() => {
    // Load initial game data when component mounts
    const initializeGame = async () => {
      await loadUserGameState();
      await loadMaps();
      await loadMapObjects();
    };

    initializeGame();
  }, [loadUserGameState, loadMaps, loadMapObjects]);

  if (loading) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-blue-900 via-purple-900 to-indigo-900 flex items-center justify-center">
        <div className="text-white text-xl">กำลังโหลดเกม...</div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-red-900 via-purple-900 to-indigo-900 flex items-center justify-center">
        <div className="text-white text-xl">เกิดข้อผิดพลาด: {error}</div>
      </div>
    );
  }

  if (!userGameState) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-blue-900 via-purple-900 to-indigo-900 flex items-center justify-center">
        <div className="text-white text-xl">ไม่พบข้อมูลเกม</div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-900 via-purple-900 to-indigo-900">
      <MapView />
    </div>
  );
}
