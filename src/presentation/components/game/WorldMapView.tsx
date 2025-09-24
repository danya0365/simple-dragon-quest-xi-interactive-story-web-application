"use client";

import { useGameStore } from "@/src/stores/gameStore";
import { useEffect } from "react";

export function WorldMapView() {
  const {
    worldRegions,
    loading,
    error,
    selectedRegionId,
    userGameState,
    loadWorldMap,
    loadLocationsForRegion,
    setSelectedRegion,
    setCurrentView,
  } = useGameStore();

  const handleRegionClick = async (regionId: string) => {
    setSelectedRegion(regionId);
    await loadLocationsForRegion(regionId);
    setCurrentView("location");
  };

  useEffect(() => {
    if (userGameState?.id) {
      loadWorldMap();
    }
  }, [userGameState?.id, loadWorldMap]);

  useEffect(() => {
    console.log(worldRegions);
  }, [worldRegions]);

  if (loading) {
    return (
      <div className="flex items-center justify-center min-h-[400px]">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-yellow-400 mx-auto mb-4"></div>
          <p className="text-blue-200">กำลังโหลดแผนที่โลก...</p>
        </div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="flex items-center justify-center min-h-[400px]">
        <div className="text-center">
          <div className="text-red-400 text-6xl mb-4">⚠️</div>
          <p className="text-red-400 font-medium mb-2">เกิดข้อผิดพลาด</p>
          <p className="text-blue-200 mb-4">{error}</p>
          <button
            onClick={() => loadWorldMap()}
            className="bg-yellow-500 hover:bg-yellow-600 text-blue-900 px-4 py-2 rounded-lg font-medium transition-colors"
          >
            ลองใหม่อีกครั้ง
          </button>
        </div>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="text-center">
        <h2 className="text-3xl font-bold text-yellow-400 mb-2 font-serif">
          แผนที่โลก Dragon Quest XI
        </h2>
        <p className="text-blue-200">เลือกภูมิภาคที่ต้องการสำรวจ</p>
        <div className="w-24 h-1 bg-yellow-400 mx-auto mt-4 rounded"></div>
      </div>

      {/* World Map Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {worldRegions.map((region) => (
          <div
            key={region.id}
            className={`
              relative bg-white/10 backdrop-blur-md rounded-lg border border-white/20 p-6 
              cursor-pointer transition-all duration-300 transform hover:scale-105
              ${
                region.is_unlocked
                  ? "hover:bg-white/20 hover:border-yellow-400/50"
                  : "opacity-50 cursor-not-allowed"
              }
              ${selectedRegionId === region.id ? "ring-2 ring-yellow-400" : ""}
            `}
            onClick={() => region.is_unlocked && handleRegionClick(region.id)}
          >
            {/* Lock indicator for locked regions */}
            {!region.is_unlocked && (
              <div className="absolute top-2 right-2">
                <div className="bg-red-500/20 border border-red-500/50 rounded-full p-2">
                  <span className="text-red-400 text-sm">🔒</span>
                </div>
              </div>
            )}

            {/* Region Image Placeholder */}
            <div className="w-full h-32 bg-gradient-to-br from-blue-600/30 to-purple-600/30 rounded-lg mb-4 flex items-center justify-center">
              <span className="text-4xl">🏰</span>
            </div>

            {/* Region Info */}
            <div className="space-y-2">
              <h3 className="text-xl font-bold text-white">{region.name}</h3>
              <p className="text-blue-200 text-sm line-clamp-2">
                {region.description}
              </p>

              {/* Progress Info */}
              <div className="flex items-center justify-between text-sm">
                <span className="text-blue-300">
                  สถานที่: {region.unlocked_locations_count}/
                  {region.locations_count}
                </span>
                {region.is_unlocked && (
                  <span className="text-green-400 font-medium">
                    ✓ ปลดล็อคแล้ว
                  </span>
                )}
              </div>

              {/* Progress Bar */}
              <div className="w-full bg-white/10 rounded-full h-2">
                <div
                  className="bg-gradient-to-r from-yellow-400 to-yellow-500 h-2 rounded-full transition-all duration-300"
                  style={{
                    width: `${
                      region.locations_count > 0
                        ? (region.unlocked_locations_count /
                            region.locations_count) *
                          100
                        : 0
                    }%`,
                  }}
                ></div>
              </div>
            </div>

            {/* Hover Effect */}
            {region.is_unlocked && (
              <div className="absolute inset-0 bg-gradient-to-br from-yellow-400/0 to-yellow-400/10 rounded-lg opacity-0 hover:opacity-100 transition-opacity duration-300"></div>
            )}
          </div>
        ))}
      </div>

      {/* Empty State */}
      {worldRegions.length === 0 && (
        <div className="text-center py-12">
          <div className="text-blue-400 text-6xl mb-4">🗺️</div>
          <p className="text-blue-200 font-medium mb-2">ยังไม่มีแผนที่โลก</p>
          <p className="text-blue-300">
            แผนที่โลกจะแสดงที่นี่เมื่อเริ่มการผจญภัย
          </p>
        </div>
      )}

      {/* Instructions */}
      <div className="bg-blue-900/30 rounded-lg border border-blue-500/30 p-4">
        <h4 className="text-yellow-400 font-medium mb-2">วิธีการเล่น:</h4>
        <ul className="text-blue-200 text-sm space-y-1">
          <li>• คลิกที่ภูมิภาคที่ปลดล็อคแล้วเพื่อเข้าสำรวจ</li>
          <li>• ทำภารกิจให้เสร็จเพื่อปลดล็อคพื้นที่ใหม่</li>
          <li>• สะสมประสบการณ์และไอเทมจากการผจญภัย</li>
        </ul>
      </div>
    </div>
  );
}
