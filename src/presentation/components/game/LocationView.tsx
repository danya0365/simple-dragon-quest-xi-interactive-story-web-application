"use client";

import { useEffect } from "react";
import { useGameStore } from "@/src/stores/gameStore";
import { useAuthStore } from "@/src/stores/authStore";

export function LocationView() {
  const { user } = useAuthStore();
  const {
    availableLocations,
    selectedRegionId,
    loading,
    error,
    loadAvailableEvents,
    setSelectedEventId,
    setSelectedLocationId,
    setCurrentView,
    setSelectedRegion,
  } = useGameStore();

  useEffect(() => {
    if (user?.id && selectedRegionId) {
      loadAvailableEvents();
    }
  }, [user?.id, selectedRegionId, loadAvailableEvents]);

  const handleLocationClick = (locationId: string) => {
    setSelectedLocationId(locationId); // Set selected location
    setSelectedEventId(null); // Reset selected event
    setCurrentView('event');
  };

  const handleBackToWorldMap = () => {
    setSelectedRegion(null);
    setCurrentView('world_map');
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
            onClick={() => loadAvailableEvents()}
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
        {availableLocations.map((location) => (
          <div
            key={location.id}
            className="bg-white/10 backdrop-blur-md rounded-lg border border-white/20 p-6 cursor-pointer transition-all duration-300 transform hover:scale-105 hover:bg-white/20 hover:border-yellow-400/50"
            onClick={() => handleLocationClick(location.id)}
          >
            {/* Location Type Badge */}
            <div className="flex items-center justify-between mb-4">
              <span className="px-3 py-1 rounded-full text-xs font-medium bg-purple-500/20 text-purple-300 border border-purple-500/50">
                📍 สถานที่
              </span>
              
              <span className="text-blue-300 text-sm">
                {location.description ? 'มีเหตุการณ์' : 'สถานที่'}
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
                <span className="text-blue-300 text-sm">คลิกเพื่อเริ่มเล่น</span>
                <span className="text-yellow-400 text-lg">▶️</span>
              </div>
            </div>

            {/* Hover Effect */}
            <div className="absolute inset-0 bg-gradient-to-br from-yellow-400/0 to-yellow-400/10 rounded-lg opacity-0 hover:opacity-100 transition-opacity duration-300"></div>
          </div>
        ))}
      </div>

      {/* Empty State */}
      {availableLocations.length === 0 && (
        <div className="text-center py-12">
          <div className="text-blue-400 text-6xl mb-4">🎭</div>
          <p className="text-blue-200 font-medium mb-2">
            ไม่มีเหตุการณ์ที่พร้อมเล่น
          </p>
          <p className="text-blue-300 mb-4">
            ลองสำรวจพื้นที่อื่นหรือทำภารกิจให้เสร็จเพื่อปลดล็อคเหตุการณ์ใหม่
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
              {availableLocations.length > 0 ? (
                <>
                  <div className="flex items-start space-x-2">
                    <span className="text-yellow-400 mt-1">1️⃣</span>
                    <div>
                      <p className="text-blue-200 font-medium">เลือกเหตุการณ์ที่ต้องการเล่น</p>
                      <p className="text-blue-300 text-sm">คลิกที่การ์ดเหตุการณ์ด้านบนเพื่อเริ่มการผจญภัย</p>
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
                      <p className="text-blue-300 text-sm">การตัดสินใจของคุณจะส่งผลต่อเรื่องราวและปลดล็อคเหตุการณ์ใหม่</p>
                    </div>
                  </div>
                </>
              ) : (
                <div className="flex items-start space-x-2">
                  <span className="text-yellow-400 mt-1">🔄</span>
                  <div>
                    <p className="text-blue-200 font-medium">กลับไปแผนที่โลก</p>
                    <p className="text-blue-300 text-sm">ไปที่พื้นที่อื่นๆ เพื่อค้นหาเหตุการณ์ใหม่ๆ ที่จะเปิดให้เล่น</p>
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
                {availableLocations.length > 0 
                  ? `มี ${availableLocations.length} เหตุการณ์ที่พร้อมเล่น` 
                  : 'สำรวจเพื่อค้นหาเหตุการณ์ใหม่'}
              </span>
            </div>
          </div>
        </div>
      </div>
      
      {/* Tips */}
      <div className="bg-blue-900/30 rounded-lg border border-blue-500/30 p-4">
        <h4 className="text-yellow-400 font-medium mb-2">เคล็ดลับ:</h4>
        <ul className="text-blue-200 text-sm space-y-1">
          <li>• เหตุการณ์แต่ละประเภทจะมีการโต้ตอบที่แตกต่างกัน</li>
          <li>• การเลือกในเหตุการณ์จะส่งผลต่อเรื่องราวและตัวละคร</li>
          <li>• ทำเหตุการณ์ให้เสร็จเพื่อปลดล็อคเนื้อหาใหม่</li>
        </ul>
      </div>
    </div>
  );
}
