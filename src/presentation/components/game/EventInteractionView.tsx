"use client";

import { useAuthStore } from "@/src/stores/authStore";
import { useGameStore } from "@/src/stores/gameStore";
import { useEffect, useState } from "react";

interface Interaction {
  id: string;
  interaction_type: string;
  title: string;
  description: string;
  dialogue_text: string;
  character_speaker: string;
  character_avatar?: string;
  choices: Array<{
    id: string;
    text: string;
    type: string;
    description?: string;
  }>;
}

interface EventData {
  id: string;
  title: string;
  description: string;
  event_type: string;
  chapter_title: string;
  location_name: string;
}

export function EventInteractionView() {
  const { user } = useAuthStore();
  const {
    selectedEventId,
    selectedLocationId,
    availableEvents,
    loading,
    error,
    completeInteraction,
    loadAvailableEvents,
    loadEventInteractions,
    setCurrentView,
    setSelectedEventId,
  } = useGameStore();

  const [eventData, setEventData] = useState<EventData | null>(null);
  const [interactions, setInteractions] = useState<Interaction[]>([]);
  const [currentInteractionIndex, setCurrentInteractionIndex] = useState(0);
  const [selectedChoice, setSelectedChoice] = useState<string | null>(null);
  const [interactionHistory, setInteractionHistory] = useState<string[]>([]);

  const currentEvent = availableEvents.find(
    (event) => event.event_id === selectedEventId
  );
  const currentInteraction = interactions[currentInteractionIndex] || null;

  useEffect(() => {
    // Load real interaction data from database
    if (user?.id && selectedLocationId) {
      loadAvailableEvents();
    }
  }, [user?.id, selectedLocationId, loadAvailableEvents]);

  useEffect(() => {
    if (selectedEventId && user?.id) {
      loadEventInteractions(selectedEventId).then((data: any) => {
        if (data && !(data as any).error) {
          setEventData((data as any).event);
          setInteractions((data as any).interactions || []);
          setCurrentInteractionIndex(0);
          setInteractionHistory([]);
        }
      });
    }
  }, [selectedEventId, user?.id, loadEventInteractions]);

  const handleChoiceSelect = (choiceKey: string) => {
    setSelectedChoice(choiceKey);
  };

  const handleConfirmChoice = async () => {
    if (!user?.id || !currentInteraction) return;

    // If there are no choices, use a default choice data
    const choiceData = selectedChoice
      ? {
          choice_key: selectedChoice,
          interaction_id: currentInteraction.id,
        }
      : {
          choice_key: "default",
          interaction_id: currentInteraction.id,
        };

    await completeInteraction(currentInteraction.id, choiceData);

    // Add to history if there was a choice
    if (selectedChoice) {
      const choice = currentInteraction.choices.find(
        (c) => c.id === selectedChoice
      );
      if (choice) {
        setInteractionHistory((prev) => [...prev, choice.text]);
      }
    } else {
      // Add default message for interactions without choices
      setInteractionHistory((prev) => [...prev, "ดำเนินการต่อ"]);
    }

    // Move to next interaction or reset
    if (currentInteractionIndex < interactions.length - 1) {
      setCurrentInteractionIndex((prev) => prev + 1);
    }
    setSelectedChoice(null);
  };

  const handleBackToLocation = () => {
    setSelectedEventId(null);
    setCurrentView("location");
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center min-h-[400px]">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-yellow-400 mx-auto mb-4"></div>
          <p className="text-blue-200">กำลังโหลดการโต้ตอบ...</p>
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
            onClick={handleBackToLocation}
            className="bg-yellow-500 hover:bg-yellow-600 text-blue-900 px-4 py-2 rounded-lg font-medium transition-colors"
          >
            กลับไปรายการเหตุการณ์
          </button>
        </div>
      </div>
    );
  }

  if (!currentEvent || !currentInteraction) {
    return (
      <div className="text-center py-12">
        <div className="text-blue-400 text-6xl mb-4">❓</div>
        <p className="text-blue-200 font-medium mb-2">ไม่พบเหตุการณ์</p>
        <button
          onClick={handleBackToLocation}
          className="bg-yellow-500 hover:bg-yellow-600 text-blue-900 px-4 py-2 rounded-lg font-medium transition-colors"
        >
          กลับไปรายการเหตุการณ์
        </button>
      </div>
    );
  }

  return (
    <div className="max-w-4xl mx-auto space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <button
          onClick={handleBackToLocation}
          className="flex items-center text-blue-300 hover:text-blue-200 transition-colors"
        >
          <span className="mr-2">←</span>
          กลับไปรายการเหตุการณ์
        </button>

        <div className="text-center">
          <h2 className="text-2xl font-bold text-yellow-400 font-serif">
            {eventData?.title || currentEvent?.event_title || "เหตุการณ์"}
          </h2>
          <p className="text-blue-200">
            {eventData?.chapter_title || currentEvent?.chapter_title}
          </p>
        </div>

        <div></div>
      </div>

      {/* Event Scene */}
      <div className="bg-white/10 backdrop-blur-md rounded-lg border border-white/20 p-8">
        {/* Character Speaker */}
        {currentInteraction.character_speaker && (
          <div className="flex items-center mb-6">
            {currentInteraction.character_avatar ? (
              <img
                src={currentInteraction.character_avatar}
                alt={currentInteraction.character_speaker}
                className="w-12 h-12 rounded-full mr-4 object-cover"
              />
            ) : (
              <div className="w-12 h-12 bg-gradient-to-br from-yellow-400 to-yellow-500 rounded-full flex items-center justify-center mr-4">
                <span className="text-blue-900 font-bold text-lg">
                  {currentInteraction.character_speaker.charAt(0)}
                </span>
              </div>
            )}
            <div>
              <h3 className="text-white font-bold">
                {currentInteraction.character_speaker}
              </h3>
              <p className="text-blue-300 text-sm">ตัวละคร</p>
            </div>
          </div>
        )}

        {/* Dialogue */}
        <div className="bg-blue-900/30 rounded-lg border border-blue-500/30 p-6 mb-6">
          <p className="text-white text-lg leading-relaxed">
            {currentInteraction.dialogue_text}
          </p>
        </div>

        {/* Interaction History */}
        {interactionHistory.length > 0 && (
          <div className="mb-6">
            <h4 className="text-yellow-400 font-medium mb-3">
              การตอบสนองก่อนหน้า:
            </h4>
            <div className="space-y-2">
              {interactionHistory.map((response, index) => (
                <div
                  key={index}
                  className="bg-green-900/20 border border-green-500/30 rounded-lg p-3"
                >
                  <p className="text-green-200 text-sm">คุณ: {response}</p>
                </div>
              ))}
            </div>
          </div>
        )}

        {/* Choices */}
        {currentInteraction.choices &&
        Array.isArray(currentInteraction.choices) &&
        currentInteraction.choices.length > 0 ? (
          <div className="space-y-4">
            <h4 className="text-yellow-400 font-medium">เลือกการตอบสนอง:</h4>
            <div className="grid gap-3">
              {currentInteraction.choices.map((choice) => (
                <button
                  key={choice.id}
                  onClick={() => handleChoiceSelect(choice.id)}
                  className={`
                    text-left p-4 rounded-lg border transition-all duration-200
                    ${
                      selectedChoice === choice.id
                        ? "bg-yellow-500/20 border-yellow-400 text-yellow-100"
                        : "bg-white/5 border-white/20 text-blue-200 hover:bg-white/10 hover:border-white/40"
                    }
                  `}
                >
                  <div className="flex items-center justify-between">
                    <span>{choice.text}</span>
                    <span
                      className={`
                      text-xs px-2 py-1 rounded-full
                      ${
                        choice.type === "friendly"
                          ? "bg-green-500/20 text-green-300"
                          : ""
                      }
                      ${
                        choice.type === "suspicious"
                          ? "bg-red-500/20 text-red-300"
                          : ""
                      }
                      ${
                        choice.type === "neutral"
                          ? "bg-blue-500/20 text-blue-300"
                          : ""
                      }
                      ${
                        choice.type === "stealth"
                          ? "bg-purple-500/20 text-purple-300"
                          : ""
                      }
                      ${
                        choice.type === "bold"
                          ? "bg-orange-500/20 text-orange-300"
                          : ""
                      }
                      ${
                        choice.type === "risky"
                          ? "bg-red-500/20 text-red-300"
                          : ""
                      }
                    `}
                    >
                      {choice.type === "friendly" && "😊 เป็นมิตร"}
                      {choice.type === "suspicious" && "🤨 สงสัย"}
                      {choice.type === "neutral" && "😐 เฉยๆ"}
                      {choice.type === "stealth" && "🥷 ลอบเคลื่อนไหว"}
                      {choice.type === "bold" && "⚔️ กล้าหาญ"}
                      {choice.type === "risky" && "🎲 เสี่ยงภัย"}
                    </span>
                  </div>
                </button>
              ))}
            </div>

            {/* Confirm Button */}
            {selectedChoice && (
              <div className="pt-4 border-t border-white/10">
                <button
                  onClick={handleConfirmChoice}
                  disabled={loading}
                  className="w-full bg-gradient-to-r from-yellow-500 to-yellow-600 hover:from-yellow-600 hover:to-yellow-700 text-blue-900 font-bold py-3 px-4 rounded-lg transition-all duration-200 transform hover:scale-105 disabled:opacity-50 disabled:cursor-not-allowed disabled:transform-none"
                >
                  {loading ? (
                    <div className="flex items-center justify-center">
                      <div className="animate-spin rounded-full h-5 w-5 border-b-2 border-blue-900 mr-2"></div>
                      กำลังดำเนินการ...
                    </div>
                  ) : (
                    "ยืนยันการเลือก"
                  )}
                </button>
              </div>
            )}
          </div>
        ) : (
          <div className="text-center py-8">
            <div className="text-blue-400 text-4xl mb-4">📖</div>
            <p className="text-blue-200 mb-4">
              การโต้ตอบนี้ไม่มีตัวเลือก กดปุ่มด้านล่างเพื่อดำเนินการต่อ
            </p>
            <button
              onClick={handleConfirmChoice}
              disabled={loading}
              className="bg-yellow-500 hover:bg-yellow-600 text-blue-900 font-bold py-2 px-6 rounded-lg transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
            >
              {loading ? "กำลังดำเนินการ..." : "ดำเนินการต่อ"}
            </button>
          </div>
        )}
      </div>

      {/* Event Info */}
      <div className="bg-blue-900/30 rounded-lg border border-blue-500/30 p-4">
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4 text-sm">
          <div>
            <span className="text-yellow-400 font-medium">ประเภท:</span>
            <span className="text-blue-200 ml-2">
              {currentEvent.event_type}
            </span>
          </div>
          <div>
            <span className="text-yellow-400 font-medium">สถานที่:</span>
            <span className="text-blue-200 ml-2">
              {currentEvent.location_name || "ไม่ระบุ"}
            </span>
          </div>
          <div>
            <span className="text-yellow-400 font-medium">การโต้ตอบ:</span>
            <span className="text-blue-200 ml-2">
              {currentEvent.interactions_count}
            </span>
          </div>
        </div>
      </div>
    </div>
  );
}
