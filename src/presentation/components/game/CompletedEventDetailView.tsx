"use client";

import { useEffect, useState } from "react";
import type { EventInteractionUI } from "../../../domain/types/ui";
import { useGameStore } from "../../../stores/gameStore";
import { EventTypeBadge } from "./EventTypeBadge";

interface CompletedEventDetailViewProps {
  eventId: string;
  onBack: () => void;
}

export function CompletedEventDetailView({
  eventId,
  onBack,
}: CompletedEventDetailViewProps) {
  const { userGameState, completedEvents, loadEventInteractions } =
    useGameStore();

  const [eventInteractions, setEventInteractions] = useState<
    EventInteractionUI[]
  >([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const event = completedEvents.find((e) => e.eventId === eventId);
  const userCompletedInteractions =
    userGameState?.completedInteractions.filter(
      (ci) => ci.eventId === eventId
    ) || [];

  useEffect(() => {
    const loadInteractions = async () => {
      setLoading(true);
      setError(null);

      try {
        const interactions = await loadEventInteractions(eventId);
        if (interactions) {
          setEventInteractions(interactions);
        }
      } catch {
        setError("ไม่สามารถโหลดข้อมูลการโต้ตอบได้");
      } finally {
        setLoading(false);
      }
    };

    loadInteractions();
  }, [eventId, loadEventInteractions]);

  const getChoiceText = (interactionId: string, choiceKey: string) => {
    const interaction = eventInteractions.find((i) => i.id === interactionId);
    if (!interaction) return "ไม่พบข้อมูลการโต้ตอบ";

    const choice = interaction.choices.find((c) => c.id === choiceKey);
    return choice ? choice.text : "ไม่พบตัวเลือก";
  };

  const getInteractionDetails = (interactionId: string) => {
    const interaction = eventInteractions.find((i) => i.id === interactionId);
    return interaction || null;
  };

  if (loading) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-blue-900 via-purple-900 to-indigo-900 flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin rounded-full h-32 w-32 border-b-2 border-yellow-400 mx-auto mb-4"></div>
          <p className="text-blue-200 text-lg">
            กำลังโหลดรายละเอียดเหตุการณ์...
          </p>
        </div>
      </div>
    );
  }

  if (error || !event) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-blue-900 via-purple-900 to-indigo-900 flex items-center justify-center">
        <div className="text-center bg-red-900/50 rounded-lg p-6 border border-red-500/30">
          <p className="text-red-200 text-lg mb-4">
            {error || "ไม่พบข้อมูลเหตุการณ์"}
          </p>
          <button
            onClick={onBack}
            className="bg-red-600 hover:bg-red-700 text-white px-4 py-2 rounded-lg transition-colors"
          >
            กลับไปหน้าเหตุการณ์ที่ทำเสร็จแล้ว
          </button>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-900 via-purple-900 to-indigo-900">
      <div className="max-w-4xl mx-auto p-6 space-y-6">
        {/* Header */}
        <div className="flex items-center justify-between mb-8">
          <button
            onClick={onBack}
            className="flex items-center text-blue-300 hover:text-blue-200 transition-colors"
          >
            <span className="mr-2">←</span>
            กลับไปหน้าเหตุการณ์ที่ทำเสร็จแล้ว
          </button>
          <div className="text-center">
            <h2 className="text-2xl font-bold text-green-400 font-serif">
              📖 ทบทวนเนื้อเรื่อง
            </h2>
            <p className="text-blue-200">
              ดูรายละเอียดการโต้ตอบและตัวเลือกของคุณ
            </p>
          </div>
          <div></div> {/* Spacer for flex layout */}
        </div>

        {/* Event Summary Card */}
        <div className="bg-white/10 backdrop-blur-md rounded-lg border border-green-500/30 p-6 relative overflow-hidden">
          <div className="absolute inset-0 bg-gradient-to-br from-green-400/5 to-green-400/15 rounded-lg"></div>

          <div className="relative z-10">
            <div className="flex items-center justify-between mb-4">
              <EventTypeBadge eventType={event.eventType} />
              <div className="flex items-center space-x-2">
                <span className="text-blue-300 text-sm">
                  {userCompletedInteractions.length} การโต้ตอบที่ทำเสร็จ
                </span>
                <span className="text-green-400 text-lg">✅</span>
              </div>
            </div>

            <div className="space-y-3">
              <h3 className="text-2xl font-bold text-white mb-2">
                {event.eventTitle}
              </h3>

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
          </div>
        </div>

        {/* Interaction History */}
        <div className="space-y-6">
          <div className="flex items-center space-x-3">
            <span className="text-yellow-400 text-2xl">📝</span>
            <h3 className="text-xl font-bold text-yellow-400">
              ประวัติการโต้ตอบของคุณ
            </h3>
          </div>

          {userCompletedInteractions.length === 0 ? (
            <div className="text-center py-12 bg-white/5 rounded-lg border border-blue-500/30">
              <div className="text-blue-400 text-6xl mb-4">📭</div>
              <p className="text-blue-200 font-medium mb-2">
                ไม่พบข้อมูลการโต้ตอบที่ทำเสร็จ
              </p>
              <p className="text-blue-300">ยังไม่มีการโต้ตอบในเหตุการณ์นี้</p>
            </div>
          ) : (
            <div className="space-y-4">
              {userCompletedInteractions.map((interaction, index) => {
                const interactionDetails = getInteractionDetails(
                  interaction.interactionId
                );
                const choiceText = getChoiceText(
                  interaction.interactionId,
                  interaction.choiceKey
                );

                return (
                  <div
                    key={`${interaction.interactionId}-${index}`}
                    className="bg-white/10 backdrop-blur-md rounded-lg border border-blue-500/30 p-6 relative overflow-hidden"
                  >
                    <div className="absolute inset-0 bg-gradient-to-br from-blue-400/3 to-blue-400/10 rounded-lg"></div>

                    <div className="relative z-10 space-y-4">
                      {/* Header */}
                      <div className="flex items-start justify-between">
                        <div className="flex-1">
                          <div className="flex items-center space-x-2 mb-2">
                            <span className="text-yellow-400 text-lg">💬</span>
                            <h4 className="text-lg font-bold text-white">
                              {interactionDetails?.title || "การโต้ตอบ"}
                            </h4>
                          </div>

                          {interactionDetails?.characterSpeaker && (
                            <div className="flex items-center space-x-2 text-blue-300 text-sm">
                              <span className="text-yellow-400">👤</span>
                              <span>
                                พูดโดย: {interactionDetails.characterSpeaker}
                              </span>
                            </div>
                          )}
                        </div>

                        <div className="text-right">
                          <span className="text-green-400 text-xs bg-green-900/30 px-2 py-1 rounded">
                            {new Date(interaction.completedAt).toLocaleString(
                              "th-TH",
                              {
                                year: "numeric",
                                month: "short",
                                day: "numeric",
                                hour: "2-digit",
                                minute: "2-digit",
                              }
                            )}
                          </span>
                        </div>
                      </div>

                      {/* Dialogue/Description */}
                      {interactionDetails?.dialogueText && (
                        <div className="bg-blue-900/30 rounded-lg p-4 border border-blue-500/20">
                          <p className="text-blue-200 leading-relaxed">
                            {interactionDetails.dialogueText}
                          </p>
                        </div>
                      )}

                      {interactionDetails?.description && (
                        <div className="bg-purple-900/20 rounded-lg p-4 border border-purple-500/20">
                          <p className="text-purple-200 text-sm leading-relaxed">
                            {interactionDetails.description}
                          </p>
                        </div>
                      )}

                      {/* User's Choice - only show if there are choices */}
                      {interactionDetails?.choices && interactionDetails.choices.length > 0 && (
                        <div className="bg-yellow-900/30 rounded-lg p-4 border border-yellow-500/30">
                          <div className="flex items-center space-x-2 mb-2">
                            <span className="text-yellow-400">⭐</span>
                            <h5 className="text-yellow-400 font-medium">
                              ตัวเลือกของคุณ
                            </h5>
                          </div>
                          <p className="text-yellow-200 font-medium">
                            {choiceText}
                          </p>
                        </div>
                      )}

                      {/* Available Choices (for context) - only show if there are multiple choices */}
                      {interactionDetails?.choices &&
                        interactionDetails.choices.length > 1 &&
                        interactionDetails.choices.some(choice => choice.id === interaction.choiceKey) && (
                          <div className="bg-gray-800/30 rounded-lg p-4 border border-gray-500/20">
                            <div className="flex items-center space-x-2 mb-3">
                              <span className="text-gray-400">📋</span>
                              <h5 className="text-gray-400 font-medium text-sm">
                                ตัวเลือกที่มีให้เลือก:
                              </h5>
                            </div>
                            <div className="space-y-2">
                              {interactionDetails.choices.map((choice) => (
                                <div
                                  key={choice.id}
                                  className={`p-2 rounded text-sm ${
                                    choice.id === interaction.choiceKey
                                      ? "bg-yellow-900/40 border border-yellow-500/30 text-yellow-200"
                                      : "bg-gray-700/30 text-gray-400"
                                  }`}
                                >
                                  {choice.text}
                                  {choice.id === interaction.choiceKey && (
                                    <span className="ml-2 text-yellow-400">
                                      ✓
                                    </span>
                                  )}
                                </div>
                              ))}
                            </div>
                          </div>
                        )}
                    </div>
                  </div>
                );
              })}
            </div>
          )}
        </div>

        {/* Summary */}
        <div className="bg-gradient-to-r from-green-900/40 to-emerald-900/40 rounded-lg border border-green-500/30 p-6">
          <div className="flex items-start space-x-4">
            <div className="text-green-400 text-2xl">📊</div>
            <div className="flex-1">
              <h4 className="text-green-400 font-bold text-lg mb-3">
                สรุปการผจญภัยในเหตุการณ์นี้:
              </h4>

              <div className="space-y-2 text-blue-200">
                <p>
                  • ทำการโต้ตอบทั้งหมด {userCompletedInteractions.length} ครั้ง
                </p>
                <p>• เหตุการณ์ประเภท: {event.eventType}</p>
                <p>• สถานที่: {event.locationName || "ไม่ระบุ"}</p>
                <p>• บทที่: {event.chapterTitle}</p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
