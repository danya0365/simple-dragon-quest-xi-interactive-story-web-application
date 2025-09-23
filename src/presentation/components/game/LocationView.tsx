"use client";

import { useEffect } from "react";
import { useGameStore } from "@/src/stores/gameStore";
import { useAuthStore } from "@/src/stores/authStore";

export function LocationView() {
  const { user } = useAuthStore();
  const {
    availableEvents,
    selectedRegionId,
    loading,
    error,
    loadAvailableEvents,
    setSelectedEvent,
    setCurrentView,
    setSelectedRegion,
  } = useGameStore();

  useEffect(() => {
    if (user?.id) {
      loadAvailableEvents(user.id);
    }
  }, [user?.id, loadAvailableEvents]);

  const handleEventClick = (eventId: string) => {
    setSelectedEvent(eventId);
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
          <p className="text-blue-200">กำลังโหลดเหตุการณ์...</p>
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
            onClick={() => user?.id && loadAvailableEvents(user.id)}
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
            เหตุการณ์ที่พร้อมเล่น
          </h2>
          <p className="text-blue-200">เลือกเหตุการณ์เพื่อเริ่มการผจญภัย</p>
        </div>
        
        <div></div> {/* Spacer for flex layout */}
      </div>

      {/* Available Events */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {availableEvents.map((event) => (
          <div
            key={event.event_id}
            className="bg-white/10 backdrop-blur-md rounded-lg border border-white/20 p-6 cursor-pointer transition-all duration-300 transform hover:scale-105 hover:bg-white/20 hover:border-yellow-400/50"
            onClick={() => handleEventClick(event.event_id)}
          >
            {/* Event Type Badge */}
            <div className="flex items-center justify-between mb-4">
              <span className={`
                px-3 py-1 rounded-full text-xs font-medium
                ${event.event_type === 'story' ? 'bg-blue-500/20 text-blue-300 border border-blue-500/50' : ''}
                ${event.event_type === 'dialogue' ? 'bg-green-500/20 text-green-300 border border-green-500/50' : ''}
                ${event.event_type === 'choice' ? 'bg-purple-500/20 text-purple-300 border border-purple-500/50' : ''}
                ${event.event_type === 'battle' ? 'bg-red-500/20 text-red-300 border border-red-500/50' : ''}
              `}>
                {event.event_type === 'story' && '📖 เรื่องราว'}
                {event.event_type === 'dialogue' && '💬 บทสนทนา'}
                {event.event_type === 'choice' && '🤔 ตัวเลือก'}
                {event.event_type === 'battle' && '⚔️ การต่อสู้'}
              </span>
              
              <span className="text-blue-300 text-sm">
                {event.interactions_count} การโต้ตอบ
              </span>
            </div>

            {/* Event Info */}
            <div className="space-y-3">
              <h3 className="text-xl font-bold text-white">{event.event_title}</h3>
              
              <p className="text-blue-200 text-sm line-clamp-3">
                {event.event_description}
              </p>

              {/* Chapter and Location Info */}
              <div className="space-y-2">
                {event.chapter_title && (
                  <div className="flex items-center text-sm">
                    <span className="text-yellow-400 mr-2">📚</span>
                    <span className="text-blue-300">บท: {event.chapter_title}</span>
                  </div>
                )}
                
                {event.location_name && (
                  <div className="flex items-center text-sm">
                    <span className="text-yellow-400 mr-2">📍</span>
                    <span className="text-blue-300">สถานที่: {event.location_name}</span>
                  </div>
                )}
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
      {availableEvents.length === 0 && (
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
