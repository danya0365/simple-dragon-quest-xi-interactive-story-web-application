"use client";

import { useEffect, useState } from "react";
import { EventTypeBadge } from "./EventTypeBadge";
import { useGameStore } from "../../../stores/gameStore";
import type { EventInteractionUI } from "../../../domain/types/ui";

export function CompletedEventsView() {
  const {
    userGameState,
    completedEvents,
    loading,
    error,
    loadCompletedEventsForUserProgress,
    loadEventInteractions,
    setCurrentView,
  } = useGameStore();
  
  const [selectedEvent, setSelectedEvent] = useState<string | null>(null);
  const [eventInteractions, setEventInteractions] = useState<EventInteractionUI[]>([]);
  const [loadingInteractions, setLoadingInteractions] = useState(false);
  const [interactionsError, setInteractionsError] = useState<string | null>(null);

  useEffect(() => {
    if (userGameState?.id) {
      loadCompletedEventsForUserProgress();
    }
  }, [userGameState?.id, loadCompletedEventsForUserProgress]);

  const handleEventClick = async (eventId: string) => {
    if (selectedEvent === eventId) {
      setSelectedEvent(null);
      setEventInteractions([]);
      return;
    }
    
    setSelectedEvent(eventId);
    setLoadingInteractions(true);
    setInteractionsError(null);
    
    try {
      const interactions = await loadEventInteractions(eventId);
      if (interactions) {
        setEventInteractions(interactions);
      }
    } catch {
      setInteractionsError("ไม่สามารถโหลดข้อมูลการโต้ตอบได้");
    } finally {
      setLoadingInteractions(false);
    }
  };

  const getChoiceText = (interactionId: string, choiceKey: string) => {
    const interaction = eventInteractions.find(i => i.id === interactionId);
    if (!interaction) return "ไม่พบข้อมูลการโต้ตอบ";
    
    const choice = interaction.choices.find(c => c.id === choiceKey);
    return choice ? choice.text : "ไม่พบตัวเลือก";
  };

  const getInteractionTitle = (interactionId: string) => {
    const interaction = eventInteractions.find(i => i.id === interactionId);
    return interaction ? interaction.title : "ไม่พบข้อมูล";
  };

  const handleBackToWorldMap = () => {
    setCurrentView("world_map");
  };

  if (loading) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-blue-900 via-purple-900 to-indigo-900 flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin rounded-full h-32 w-32 border-b-2 border-yellow-400 mx-auto mb-4"></div>
          <p className="text-blue-200 text-lg">
            กำลังโหลดเหตุการณ์ที่ทำเสร็จแล้ว...
          </p>
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
            onClick={handleBackToWorldMap}
            className="bg-red-600 hover:bg-red-700 text-white px-4 py-2 rounded-lg transition-colors"
          >
            กลับไปแผนที่โลก
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
          onClick={handleBackToWorldMap}
          className="flex items-center text-blue-300 hover:text-blue-200 transition-colors"
        >
          <span className="mr-2">←</span>
          กลับไปแผนที่โลก
        </button>
        <div className="text-center">
          <h2 className="text-2xl font-bold text-green-400 font-serif">
            ✅ เหตุการณ์ที่ทำเสร็จแล้ว
          </h2>
          <p className="text-blue-200">
            เหตุการณ์ทั้งหมดที่คุณได้ผ่านไปแล้วในการผจญภัย
          </p>
        </div>
        <div></div> {/* Spacer for flex layout */}
      </div>

      {/* Completed Events */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {completedEvents.map((event) => {
          const userCompletedInteractions = userGameState?.completedInteractions.filter(
            ci => ci.eventId === event.eventId
          ) || [];
          
          return (
            <div
              key={event.eventId}
              className={`bg-white/10 backdrop-blur-md rounded-lg border p-6 relative overflow-hidden opacity-90 cursor-pointer transition-all hover:scale-[1.02] ${
                selectedEvent === event.eventId 
                  ? 'border-yellow-400/50 bg-yellow-400/10' 
                  : 'border-green-500/30'
              }`}
              onClick={() => handleEventClick(event.eventId)}
            >
            {/* Event Type Badge */}
            <div className="flex items-center justify-between mb-4">
              <EventTypeBadge eventType={event.eventType} />

              <div className="flex items-center space-x-2">
                <span className="text-blue-300 text-sm">
                  {userCompletedInteractions.length} การโต้ตอบที่ทำเสร็จ
                </span>
                <span className="text-green-400 text-lg">✅</span>
                {selectedEvent === event.eventId && (
                  <span className="text-yellow-400 text-lg">▼</span>
                )}
              </div>
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

            {/* Completed Status */}
            <div className="flex items-center justify-between mt-4">
              <span className="text-green-400 text-sm font-medium">
                ทำเสร็จแล้ว
              </span>
              <span className="text-green-400 text-lg">🏆</span>
            </div>

            {/* Interaction History (Expanded View) */}
            {selectedEvent === event.eventId && (
              <div className="mt-4 pt-4 border-t border-green-500/30">
                <h4 className="text-yellow-400 font-bold mb-3 flex items-center">
                  <span className="mr-2">📝</span>
                  ประวัติการโต้ตอบของคุณ
                </h4>
                
                {loadingInteractions ? (
                  <div className="flex items-center justify-center py-4">
                    <div className="animate-spin rounded-full h-6 w-6 border-b-2 border-yellow-400 mr-2"></div>
                    <span className="text-blue-200">กำลังโหลดข้อมูลการโต้ตอบ...</span>
                  </div>
                ) : interactionsError ? (
                  <div className="bg-red-900/30 rounded-lg p-3 border border-red-500/30">
                    <p className="text-red-200 text-sm">{interactionsError}</p>
                  </div>
                ) : userCompletedInteractions.length === 0 ? (
                  <div className="text-center py-4">
                    <p className="text-blue-300">ไม่พบข้อมูลการโต้ตอบที่ทำเสร็จ</p>
                  </div>
                ) : (
                  <div className="space-y-3">
                    {userCompletedInteractions.map((interaction, index) => (
                      <div 
                        key={`${interaction.interactionId}-${index}`}
                        className="bg-blue-900/30 rounded-lg p-3 border border-blue-500/30"
                      >
                        <div className="flex items-start justify-between mb-2">
                          <h5 className="text-blue-200 font-medium">
                            {getInteractionTitle(interaction.interactionId)}
                          </h5>
                          <span className="text-green-400 text-xs">
                            {new Date(interaction.completedAt).toLocaleDateString('th-TH')}
                          </span>
                        </div>
                        <div className="flex items-center space-x-2">
                          <span className="text-yellow-400 text-sm">💬</span>
                          <span className="text-blue-300 text-sm">
                            คุณเลือก: {getChoiceText(interaction.interactionId, interaction.choiceKey)}
                          </span>
                        </div>
                      </div>
                    ))}
                  </div>
                )}
              </div>
            )}
            
            {/* Success Effect */}
            <div className="absolute inset-0 bg-gradient-to-br from-green-400/5 to-green-400/15 rounded-lg"></div>
          </div>
          );
        })}
      </div>

      {/* Empty State */}
      {completedEvents.length === 0 && (
        <div className="text-center py-12">
          <div className="text-blue-400 text-6xl mb-4">🏆</div>
          <p className="text-blue-200 font-medium mb-2">
            ยังไม่มีเหตุการณ์ที่ทำเสร็จแล้ว
          </p>
          <p className="text-blue-300 mb-4">
            เริ่มผจญภัยเพื่อทำภารกิจต่างๆ และกลับมาดูความสำเร็จของคุณ
          </p>
          <button
            onClick={handleBackToWorldMap}
            className="bg-blue-600 hover:bg-blue-700 text-white px-6 py-3 rounded-lg transition-colors"
          >
            กลับไปแผนที่โลก
          </button>
        </div>
      )}

      {/* Progress Summary */}
      <div className="bg-gradient-to-r from-green-900/40 to-emerald-900/40 rounded-lg border border-green-500/30 p-6 mt-8">
        <div className="flex items-start space-x-4">
          <div className="text-green-400 text-2xl">📊</div>
          <div className="flex-1">
            <h4 className="text-green-400 font-bold text-lg mb-3">
              สรุปความคืบหน้า:
            </h4>

            <div className="space-y-3">
              <div className="flex items-start space-x-2">
                <span className="text-green-400 mt-1">🏆</span>
                <div>
                  <p className="text-blue-200 font-medium">
                    เหตุการณ์ที่ทำเสร็จแล้ว
                  </p>
                  <p className="text-blue-300 text-sm">
                    คุณได้ทำเหตุการณ์ทั้งหมด {completedEvents.length}{" "}
                    เหตุการณ์สำเร็จแล้ว
                  </p>
                </div>
              </div>

              <div className="flex items-start space-x-2">
                <span className="text-green-400 mt-1">📈</span>
                <div>
                  <p className="text-blue-200 font-medium">
                    ติดตามความก้าวหน้า
                  </p>
                  <p className="text-blue-300 text-sm">
                    ทุกเหตุการณ์ที่คุณทำเสร็จจะถูกบันทึกไว้ที่นี่เพื่อให้คุณย้อนดูได้
                  </p>
                </div>
              </div>
            </div>

            {/* Progress Indicator */}
            <div className="mt-4 pt-4 border-t border-green-500/30">
              <div className="flex items-center text-blue-300 text-sm">
                <span className="mr-2">✅</span>
                <span>โหมด: เหตุการณ์ที่ทำเสร็จแล้ว</span>
              </div>
              <span className="text-green-400 font-medium">
                {completedEvents.length > 0
                  ? `ทำเสร็จแล้ว ${completedEvents.length} เหตุการณ์`
                  : "ยังไม่มีเหตุการณ์ที่ทำเสร็จแล้ว"}
              </span>
            </div>
          </div>
        </div>
      </div>

      {/* Tips */}
      <div className="bg-blue-900/30 rounded-lg border border-blue-500/30 p-4 mt-6">
        <h4 className="text-green-400 font-medium mb-2">เคล็ดลับ:</h4>
        <ul className="text-blue-200 text-sm space-y-1">
          <li>• หน้านี้แสดงเหตุการณ์ทั้งหมดที่คุณได้ทำเสร็จแล้ว</li>
          <li>• คุณสามารถย้อนดูความสำเร็จและความก้าวหน้าของคุณได้ที่นี่</li>
          <li>• ทุกเหตุการณ์ที่ทำเสร็จจะส่งผลต่อเนื้อเรื่องในอนาคต</li>
          <li>• พยายามทำเหตุการณ์ให้ครบทุกอย่างเพื่อดู ending ทั้งหมด</li>
        </ul>
      </div>
    </div>
  );
}
