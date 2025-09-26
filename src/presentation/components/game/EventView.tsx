"use client";

import { useEffect } from "react";
import { useAuthStore } from "../../../stores/authStore";
import { useGameStore } from "../../../stores/gameStore";

export function EventView() {
  const { user } = useAuthStore();
  const {
    availableEvents,
    selectedLocationId,
    loading,
    error,
    loadAvailableEvents,
    setSelectedEventId,
    setCurrentView,
    setSelectedLocationId,
  } = useGameStore();

  useEffect(() => {
    if (user?.id && selectedLocationId) {
      loadAvailableEvents(selectedLocationId);
    }
  }, [user?.id, selectedLocationId, loadAvailableEvents]);

  const handleEventClick = (eventId: string) => {
    setSelectedEventId(eventId);
    setCurrentView("event_interaction");
  };

  const handleBackToLocation = () => {
    setSelectedLocationId(null);
    setCurrentView("location");
  };

  if (loading) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-blue-900 via-purple-900 to-indigo-900 flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin rounded-full h-32 w-32 border-b-2 border-yellow-400 mx-auto mb-4"></div>
          <p className="text-blue-200 text-lg">กำลังโหลดเหตุการณ์...</p>
        </div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-blue-900 via-purple-900 to-indigo-900 flex items-center justify-center">
        <div className="text-center bg-red-900/50 rounded-lg p-6 border border-red-500/30">
          <p className="text-red-200 text-lg mb-4">{error}</p>
          <button
            onClick={handleBackToLocation}
            className="bg-red-600 hover:bg-red-700 text-white px-4 py-2 rounded-lg transition-colors"
          >
            กลับไปหน้าสถานที่
          </button>
        </div>
      </div>
    );
  }

  return (
    <div className="max-w-6xl mx-auto space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between mb-8">
        <button
          onClick={handleBackToLocation}
          className="flex items-center text-blue-300 hover:text-blue-200 transition-colors"
        >
          <span className="mr-2">←</span>
          กลับไปหน้าสถานที่
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
            key={event.eventId}
            className="bg-white/10 backdrop-blur-md rounded-lg border border-white/20 p-6 cursor-pointer transition-all duration-300 transform hover:scale-105 hover:bg-white/20 hover:border-yellow-400/50"
          >
            {/* Event Type Badge */}
            <div className="flex items-center justify-between mb-4">
              <span
                className={`px-3 py-1 rounded-full text-xs font-medium ${
                  event.eventType === "story"
                    ? "bg-blue-500/20 text-blue-300 border border-blue-500/50"
                    : event.eventType === "dialogue"
                    ? "bg-green-500/20 text-green-300 border border-green-500/50"
                    : event.eventType === "choice"
                    ? "bg-purple-500/20 text-purple-300 border border-purple-500/50"
                    : event.eventType === "combat"
                    ? "bg-red-500/20 text-red-300 border border-red-500/50"
                    : "bg-gray-500/20 text-gray-300 border border-gray-500/50"
                }`}
              >
                {event.eventType === "story" && "📖 เรื่องราว"}
                {event.eventType === "choice" && "🤔 ตัวเลือก"}
                {event.eventType === "battle" && "⚔️ การต่อสู้"}
                {event.eventType === "quest" && "📜 ภารกิจ"}
              </span>

              <span className="text-blue-300 text-sm">
                {event.interactionsCount} การโต้ตอบ
              </span>
            </div>

            {/* Event Info */}
            <div className="space-y-3">
              <h3 className="text-xl font-bold text-white mb-2">
                {event.eventTitle}
              </h3>
              {/* Chapter and Location Info */}
              <div className="space-y-2">
                <div className="flex items-center text-blue-300 text-sm mb-2">
                  <span className="mr-2">📚</span>
                  <span>บท: {event.chapterTitle}</span>
                </div>

                <div className="flex items-center text-blue-300 text-sm">
                  <span className="mr-2">📍</span>
                  <span>สถานที่: {event.locationName || "ไม่ระบุ"}</span>
                </div>
              </div>
            </div>

            {/* Play Button */}
            <div className="flex items-center justify-between">
              <span className="text-blue-300 text-sm">
                คลิกเพื่อเริ่มเล่น
              </span>
              <span className="text-yellow-400 text-lg">▶️</span>
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
            ลองสำรวจสถานที่อื่นหรือทำภารกิจให้เสร็จเพื่อปลดล็อคเหตุการณ์ใหม่
          </p>
          <button
            onClick={handleBackToLocation}
            className="bg-blue-600 hover:bg-blue-700 text-white px-6 py-3 rounded-lg transition-colors"
          >
            กลับไปหน้าสถานที่
          </button>
        </div>
      )}

      {/* Walkthrough / Next Steps */}
      <div className="bg-gradient-to-r from-yellow-900/40 to-orange-900/40 rounded-lg border border-yellow-500/30 p-6 mt-8">
        <div className="flex items-start space-x-4">
          <div className="text-yellow-400 text-2xl">🎯</div>
          <div className="flex-1">
            <h4 className="text-yellow-400 font-bold text-lg mb-3">
              สิ่งที่ควรทำต่อไป:
            </h4>

            <div className="space-y-3">
              {availableEvents.length > 0 ? (
                <>
                  <div className="flex items-start space-x-2">
                    <span className="text-yellow-400 mt-1">1️⃣</span>
                    <div>
                      <p className="text-blue-200 font-medium">
                        เลือกเหตุการณ์ที่ต้องการเล่น
                      </p>
                      <p className="text-blue-300 text-sm">
                        คลิกที่การ์ดเหตุการณ์ด้านบนเพื่อเริ่มการผจญภัย
                      </p>
                    </div>
                  </div>

                  <div className="flex items-start space-x-2">
                    <span className="text-yellow-400 mt-1">2️⃣</span>
                    <div>
                      <p className="text-blue-200 font-medium">
                        ทำตามเหตุการณ์
                      </p>
                      <p className="text-blue-300 text-sm">
                        อ่านบทสนทนาและเลือกตัวเลือกต่างๆ เพื่อดำเนินเรื่องราว
                      </p>
                    </div>
                  </div>
                </>
              ) : (
                <div className="flex items-start space-x-2">
                  <span className="text-yellow-400 mt-1">1️⃣</span>
                  <div>
                    <p className="text-blue-200 font-medium">
                      กลับไปหน้าสถานที่
                    </p>
                    <p className="text-blue-300 text-sm">
                      ไปที่สถานที่อื่นๆ เพื่อค้นหาเหตุการณ์ใหม่ๆ
                      ที่จะเปิดให้เล่น
                    </p>
                  </div>
                </div>
              )}
            </div>

            {/* Progress Indicator */}
            <div className="mt-4 pt-4 border-t border-yellow-500/30">
              <div className="flex items-center text-blue-300 text-sm">
                <span className="mr-2">📍</span>
                <span>สถานที่: {selectedLocationId || "ไม่ระบุ"}</span>
              </div>
              <span className="text-yellow-400 font-medium">
                {availableEvents.length > 0
                  ? `มี ${availableEvents.length} เหตุการณ์ที่พร้อมเล่น`
                  : "สำรวจเพื่อค้นหาเหตุการณ์ใหม่"}
              </span>
            </div>
          </div>
        </div>
      </div>

      {/* Tips */}
      <div className="bg-blue-900/30 rounded-lg border border-blue-500/30 p-4 mt-6">
        <h4 className="text-yellow-400 font-medium mb-2">เคล็ดลับ:</h4>
        <ul className="text-blue-200 text-sm space-y-1">
          <li>• เหตุการณ์แต่ละประเภทจะมีการโต้ตอบที่แตกต่างกัน</li>
          <li>• การเลือกตัวเลือกจะส่งผลต่อเนื้อเรื่องในอนาคต</li>
          <li>• ทำภารกิจให้เสร็จเพื่อปลดล็อคเหตุการณ์ใหม่ๆ</li>
          <li>• บทสนทนาจะช่วยให้คุณเข้าใจตัวละครและโลกในเกมมากขึ้น</li>
        </ul>
      </div>
    </div>
  );
}
