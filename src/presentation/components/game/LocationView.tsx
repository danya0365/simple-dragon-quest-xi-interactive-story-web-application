"use client";

import { useGameStore } from "@/src/stores/gameStore";
import Image from "next/image";

export function LocationView() {
  const {
    allLocations,
    selectedRegionId,
    loading,
    error,
    setSelectedEventId,
    setSelectedLocationId,
    setCurrentView,
    setSelectedRegion,
    isLocationUnlocked,
  } = useGameStore();

  const handleBackToWorldMap = () => {
    setSelectedRegion(null);
    setSelectedLocationId(null);
    setSelectedEventId(null);
    setCurrentView('world_map');
  };

  // Filter locations for the selected region
  const locationsForRegion = selectedRegionId 
    ? allLocations.filter((location) => location.world_region_id === selectedRegionId)
    : [];

  // Handle case where no region is selected or no locations found
  if (!selectedRegionId || locationsForRegion.length === 0) {
    return (
      <div className="flex items-center justify-center min-h-[400px]">
        <div className="text-center">
          <div className="text-blue-400 text-6xl mb-4">🗺️</div>
          <p className="text-blue-200 font-medium mb-2">ไม่พบสถานที่</p>
          <p className="text-blue-300 mb-4">กรุณาเลือกภูมิภาคจากแผนที่โลกก่อน</p>
          <button
            onClick={handleBackToWorldMap}
            className="bg-yellow-500 hover:bg-yellow-600 text-blue-900 px-4 py-2 rounded-lg font-medium transition-colors"
          >
            กลับไปแผนที่โลก
          </button>
        </div>
      </div>
    );
  }

  const handleLocationClick = (locationId: string, isUnlocked: boolean) => {
    if (!isUnlocked) return; // Don't allow click on locked locations
    setSelectedLocationId(locationId); // Set selected location
    setSelectedEventId(null); // Reset selected event
    setCurrentView('event');
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center min-h-[400px]">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-yellow-400 mx-auto mb-4"></div>
          <p className="text-blue-200">กำลังโหลดสถานที่...</p>
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
            onClick={() => window.location.reload()}
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
      {/* Header with Back Button */}
      <div className="flex items-center justify-between">
        <button
          onClick={handleBackToWorldMap}
          className="flex items-center text-blue-300 hover:text-blue-200 transition-colors"
        >
          <span className="mr-2">←</span>
          กลับไปแผนที่โลก
        </button>
        
        <div className="text-center">
          <h2 className="text-2xl font-bold text-yellow-400 font-serif">
            สถานที่ที่พร้อมเล่น
          </h2>
          <p className="text-blue-200">เลือกสถานที่เพื่อเริ่มการผจญภัย</p>
        </div>
        
        <div></div> {/* Spacer for flex layout */}
      </div>

      {/* Available Locations */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {locationsForRegion.map((location) => {
          const isUnlocked = isLocationUnlocked(location.id); // Use proper unlock status check
          return (
            <div
              key={location.id}
              className={`
                relative bg-white/10 backdrop-blur-md rounded-lg border border-white/20 p-6 
                cursor-pointer transition-all duration-300 transform hover:scale-105
                ${
                  isUnlocked
                    ? "hover:bg-white/20 hover:border-yellow-400/50"
                    : "opacity-50 cursor-not-allowed"
                }
              `}
              onClick={() => handleLocationClick(location.id, isUnlocked)}
            >
              {/* Lock indicator for locked locations */}
              {!isUnlocked && (
                <div className="absolute top-2 right-2 z-50">
                  <div className="bg-red-500/20 border border-red-500/50 rounded-full p-2">
                    <span className="text-red-400 text-sm">🔒</span>
                  </div>
                </div>
              )}
            {/* Location Image */}
            <div className="w-full h-40 bg-gradient-to-br from-purple-600/30 to-blue-600/30 rounded-lg mb-4 overflow-hidden relative">
              {location.image_url ? (
                <Image
                  src={location.image_url}
                  alt={location.name}
                  fill
                  className="object-cover"
                  sizes="(max-width: 768px) 100vw, (max-width: 1200px) 50vw, 50vw"
                />
              ) : (
                <div className="w-full h-full flex items-center justify-center">
                  <span className="text-4xl">🏛️</span>
                </div>
              )}
            </div>

            {/* Location Type Badge */}
            <div className="flex items-center justify-between mb-4">
              <span className="px-3 py-1 rounded-full text-xs font-medium bg-purple-500/20 text-purple-300 border border-purple-500/50">
                📍 สถานที่
              </span>
              
              <span className="text-blue-300 text-sm">
                {isUnlocked ? "พร้อมเล่น" : "ยังไม่ปลดล็อค"}
              </span>
            </div>

            {/* Event Info */}
            <div className="space-y-3">
              <h3 className="text-xl font-bold text-white mb-2">
                {location.name}
              </h3>
              <p className="text-blue-200 mb-4">
                {location.description || 'สถานที่สำคัญในโลกของ Dragon Quest'}
              </p>

              {/* Chapter and Location Info */}
              <div className="space-y-2">
                <div className="flex items-center text-blue-300 text-sm mb-2">
                  <span className="mr-2">📍</span>
                  <span>ประเภท: {location.location_type || 'สถานที่ทั่วไป'}</span>
                </div>
              </div>
            </div>

            {/* Play Button */}
            <div className="mt-4 pt-4 border-t border-white/10">
              <div className="flex items-center justify-between">
                <span className="text-blue-300 text-sm">
                  {isUnlocked ? "คลิกเพื่อเริ่มเล่น" : "ทำภารกิจเพื่อปลดล็อค"}
                </span>
                <span className={isUnlocked ? "text-yellow-400 text-lg" : "text-gray-400 text-lg"}>
                  {isUnlocked ? "▶️" : "🔒"}
                </span>
              </div>
            </div>

            {/* Hover Effect */}
            {isUnlocked && (
              <div className="absolute inset-0 bg-gradient-to-br from-yellow-400/0 to-yellow-400/10 rounded-lg opacity-0 hover:opacity-100 transition-opacity duration-300"></div>
            )}
          </div>
          );
        })}
      </div>

      {/* Empty State */}
      {locationsForRegion.length === 0 && (
        <div className="text-center py-12">
          <div className="text-blue-400 text-6xl mb-4">🏛️</div>
          <p className="text-blue-200 font-medium mb-2">
            ไม่มีสถานที่ในภูมิภาคนี้
          </p>
          <p className="text-blue-300 mb-4">
            ภูมิภาคนี้ยังไม่มีสถานที่ให้สำรวจ
          </p>
          <button
            onClick={handleBackToWorldMap}
            className="bg-yellow-500 hover:bg-yellow-600 text-blue-900 px-4 py-2 rounded-lg font-medium transition-colors"
          >
            กลับไปแผนที่โลก
          </button>
        </div>
      )}

      {/* Walkthrough / Next Steps */}
      <div className="bg-gradient-to-r from-yellow-900/40 to-orange-900/40 rounded-lg border border-yellow-500/30 p-6">
        <div className="flex items-start space-x-4">
          <div className="text-yellow-400 text-2xl">🎯</div>
          <div className="flex-1">
            <h4 className="text-yellow-400 font-bold text-lg mb-3">สิ่งที่ควรทำต่อไป:</h4>
            
            <div className="space-y-3">
              {locationsForRegion.length > 0 ? (
                <>
                  <div className="flex items-start space-x-2">
                    <span className="text-yellow-400 mt-1">1️⃣</span>
                    <div>
                      <p className="text-blue-200 font-medium">เลือกสถานที่ที่ปลดล็อคแล้ว</p>
                      <p className="text-blue-300 text-sm">คลิกที่การ์ดสถานที่ที่ไม่มีกุญแจเพื่อเริ่มการผจญภัย</p>
                    </div>
                  </div>
                  
                  <div className="flex items-start space-x-2">
                    <span className="text-yellow-400 mt-1">2️⃣</span>
                    <div>
                      <p className="text-blue-200 font-medium">ทำการโต้ตอบให้เสร็จสิ้น</p>
                      <p className="text-blue-300 text-sm">อ่านบทสนทนาและเลือกตัวเลือกต่างๆ เพื่อดำเนินเรื่องราว</p>
                    </div>
                  </div>
                  
                  <div className="flex items-start space-x-2">
                    <span className="text-yellow-400 mt-1">3️⃣</span>
                    <div>
                      <p className="text-blue-200 font-medium">ปลดล็อคเนื้อหาใหม่</p>
                      <p className="text-blue-300 text-sm">การตัดสินใจของคุณจะส่งผลต่อเรื่องราวและปลดล็อคสถานที่ใหม่</p>
                    </div>
                  </div>
                </>
              ) : (
                <div className="flex items-start space-x-2">
                  <span className="text-yellow-400 mt-1">🔄</span>
                  <div>
                    <p className="text-blue-200 font-medium">กลับไปแผนที่โลก</p>
                    <p className="text-blue-300 text-sm">ไปที่พื้นที่อื่นๆ เพื่อค้นหาสถานที่ใหม่ๆ</p>
                  </div>
                </div>
              )}
            </div>
            
            {/* Progress Indicator */}
            <div className="mt-4 pt-4 border-t border-yellow-500/30">
              <div className="flex items-center text-blue-300 text-sm">
                <span className="mr-2">🌍</span>
                <span>ภูมิภาค: {selectedRegionId || 'ไม่ระบุ'}</span>
              </div>
              <span className="text-yellow-400 font-medium">
                {locationsForRegion.length > 0 
                  ? `มี ${locationsForRegion.filter(loc => isLocationUnlocked(loc.id)).length}/${locationsForRegion.length} สถานที่ที่ปลดล็อคแล้ว` 
                  : 'สำรวจเพื่อค้นหาสถานที่ใหม่'}
              </span>
            </div>
          </div>
        </div>
      </div>
      
      {/* Tips */}
      <div className="bg-blue-900/30 rounded-lg border border-blue-500/30 p-4">
        <h4 className="text-yellow-400 font-medium mb-2">เคล็ดลับ:</h4>
        <ul className="text-blue-200 text-sm space-y-1">
          <li>• สถานที่ที่มี 🔒 ยังไม่สามารถเข้าถึงได้</li>
          <li>• ทำภารกิจให้เสร็จเพื่อปลดล็อคสถานที่ใหม่</li>
          <li>• การเลือกในสถานที่จะส่งผลต่อเรื่องราวและตัวละคร</li>
        </ul>
      </div>
    </div>
  );
}
