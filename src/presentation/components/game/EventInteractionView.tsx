"use client";

import { useAuthStore } from "@/src/stores/authStore";
import { useGameStore, EventInteraction } from "@/src/stores/gameStore";
import { useEffect, useState } from "react";

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
    userGameState,
  } = useGameStore();

  const [eventData, setEventData] = useState<EventData | null>(null);
  const [interactions, setInteractions] = useState<EventInteraction[]>([]);
  const [currentInteractionIndex, setCurrentInteractionIndex] = useState(0);
  const [selectedChoice, setSelectedChoice] = useState<string | null>(null);
  const [interactionHistory, setInteractionHistory] = useState<string[]>([]);
  const [isInitialized, setIsInitialized] = useState(false);

  // Find current event from available events
  const currentEvent = availableEvents.find(
    (event) => event.event_id === selectedEventId
  );

  const currentInteraction = interactions[currentInteractionIndex] || null;

  // Initialize component - load available events if not already loaded
  useEffect(() => {
    if (!isInitialized && user?.id && selectedLocationId) {
      console.log(
        "EventInteractionView: Initializing, loading available events for location:",
        selectedLocationId
      );
      loadAvailableEvents(selectedLocationId);
      setIsInitialized(true);
    }
  }, [user?.id, selectedLocationId, loadAvailableEvents, isInitialized]);

  // Load event interactions when event is selected
  useEffect(() => {
    if (selectedEventId && user?.id) {
      console.log(
        "EventInteractionView: Loading interactions for event:",
        selectedEventId
      );

      const loadInteractions = async () => {
        try {
          const data = await loadEventInteractions(selectedEventId);
          console.log("EventInteractionView: Loaded interactions data:", data);

          if (data && !(data as any).error) {
            // API คืนค่ามาเป็น array ของ interactions ตรงๆ
            const interactions = Array.isArray(data) ? data : [];

            // แปลง StoryEvent เป็น EventData structure
            const eventData = currentEvent ? {
              id: currentEvent.event_id,
              title: currentEvent.event_title,
              description: currentEvent.event_description || '',
              event_type: currentEvent.event_type,
              chapter_title: currentEvent.chapter_title || '',
              location_name: currentEvent.location_name || ''
            } : null;

            console.log("EventInteractionView: Setting event data:", eventData);
            console.log("EventInteractionView: Setting interactions:", interactions);

            // Get completed interactions from user game state
            const completedInteractions = userGameState?.completedInteractions as Array<{event_id: string; interaction_id: string}> || [];
            const completedInteractionIds = completedInteractions
              .filter(ci => ci.event_id === selectedEventId)
              .map(ci => ci.interaction_id);
            
            console.log("EventInteractionView: Completed interaction IDs:", completedInteractionIds);
            
            // Filter out completed interactions
            const availableInteractions = interactions.filter(
              interaction => !completedInteractionIds.includes(interaction.id)
            );
            
            console.log("EventInteractionView: Available interactions after filtering:", availableInteractions);
            
            // If all interactions are completed, go back to location view
            if (availableInteractions.length === 0) {
              console.log("EventInteractionView: All interactions completed, going back to location view");
              setCurrentView("location");
              setSelectedEventId(null);
              return;
            }
            
            setEventData(eventData);
            setInteractions(availableInteractions);
            setCurrentInteractionIndex(0);
            setInteractionHistory([]);
            setSelectedChoice(null);
          } else {
            console.error(
              "EventInteractionView: Error loading interactions:",
              data
            );
          }
        } catch (error) {
          console.error(
            "EventInteractionView: Exception loading interactions:",
            error
          );
        }
      };

      loadInteractions();
    }
  }, [selectedEventId, user?.id, loadEventInteractions, currentEvent, setCurrentView, setSelectedEventId, userGameState?.completedInteractions]);

  // Debug logging
  useEffect(() => {
    console.log("EventInteractionView Debug:", {
      selectedEventId,
      selectedLocationId,
      availableEvents: availableEvents?.length || 0,
      currentEvent: currentEvent?.event_title,
      interactions: interactions?.length || 0,
      currentInteractionIndex,
      loading,
      error,
      userGameState: userGameState ? "loaded" : "not loaded",
    });
  }, [
    selectedEventId,
    selectedLocationId,
    availableEvents,
    currentEvent,
    interactions,
    currentInteractionIndex,
    loading,
    error,
    userGameState,
  ]);

  const handleChoiceSelect = (choiceKey: string) => {
    console.log("EventInteractionView: Choice selected:", choiceKey);
    setSelectedChoice(choiceKey);
  };

  const handleConfirmChoice = async () => {
    if (!user?.id || !currentInteraction) {
      console.error("EventInteractionView: Missing user or interaction", {
        user: !!user,
        interaction: !!currentInteraction,
      });
      return;
    }

    console.log(
      "EventInteractionView: Confirming choice for interaction:",
      currentInteraction.id
    );

    // Prepare choice data
    const choiceData = selectedChoice
      ? {
          choice_key: selectedChoice,
          interaction_id: currentInteraction.id,
        }
      : {
          choice_key: "default",
          interaction_id: currentInteraction.id,
        };

    try {
      // Complete the interaction
      const result = await completeInteraction(
        currentInteraction.id,
        choiceData
      );
      console.log(
        "EventInteractionView: Interaction completion result:",
        result
      );

      // Add to history
      if (selectedChoice) {
        const choice = currentInteraction.choices.find(
          (c: { id: string }) => c.id === selectedChoice
        );
        if (choice) {
          setInteractionHistory((prev) => [...prev, choice.text]);
        }
      } else {
        setInteractionHistory((prev) => [...prev, "ดำเนินการต่อ"]);
      }

      // Move to next interaction or reset
      if (currentInteractionIndex < interactions.length - 1) {
        setCurrentInteractionIndex((prev) => prev + 1);
        console.log(
          "EventInteractionView: Moving to next interaction:",
          currentInteractionIndex + 1
        );
      } else {
        console.log(
          "EventInteractionView: No more interactions, returning to event list"
        );
        // If no more interactions, go back to event list
        setTimeout(() => {
          setSelectedEventId(null);
          setCurrentView("event");
        }, 1000);
      }

      setSelectedChoice(null);
    } catch (error) {
      console.error(
        "EventInteractionView: Error completing interaction:",
        error
      );
    }
  };

  const handleBackToEventList = () => {
    console.log("EventInteractionView: Going back to event list");
    setSelectedEventId(null);
    setCurrentView("event");
  };

  // Loading state
  if (loading) {
    return (
      <div className="flex items-center justify-center min-h-[400px]">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-yellow-400 mx-auto mb-4"></div>
          <p className="text-blue-200">กำลังโหลดการโต้ตอบ...</p>
          <p className="text-blue-300 text-sm mt-2">Event: {selectedEventId}</p>
        </div>
      </div>
    );
  }

  // Error state
  if (error) {
    return (
      <div className="flex items-center justify-center min-h-[400px]">
        <div className="text-center">
          <div className="text-red-400 text-6xl mb-4">⚠️</div>
          <p className="text-red-400 font-medium mb-2">เกิดข้อผิดพลาด</p>
          <p className="text-blue-200 mb-4">{error}</p>
          <button
            onClick={handleBackToEventList}
            className="bg-yellow-500 hover:bg-yellow-600 text-blue-900 px-4 py-2 rounded-lg font-medium transition-colors"
          >
            กลับไปหน้าเหตุการณ์
          </button>
        </div>
      </div>
    );
  }

  // No event or interaction data state
  if (!currentEvent) {
    return (
      <div className="text-center py-12">
        <div className="text-blue-400 text-6xl mb-4">❓</div>
        <p className="text-blue-200 font-medium mb-2">ไม่พบเหตุการณ์</p>
        <p className="text-blue-300 text-sm mb-4">
          Selected Event ID: {selectedEventId}
        </p>
        <p className="text-blue-300 text-sm mb-4">
          Available Events: {availableEvents?.length || 0}
        </p>
        <button
          onClick={handleBackToEventList}
          className="bg-yellow-500 hover:bg-yellow-600 text-blue-900 px-4 py-2 rounded-lg font-medium transition-colors"
        >
          กลับไปหน้าเหตุการณ์
        </button>
      </div>
    );
  }

  if (!currentInteraction) {
    return (
      <div className="text-center py-12">
        <div className="text-blue-400 text-6xl mb-4">📝</div>
        <p className="text-blue-200 font-medium mb-2">ไม่พบการโต้ตอบ</p>
        <p className="text-blue-300 text-sm mb-4">
          Event: {currentEvent.event_title}
        </p>
        <p className="text-blue-300 text-sm mb-4">
          Loaded Interactions: {interactions.length}
        </p>
        <button
          onClick={handleBackToEventList}
          className="bg-yellow-500 hover:bg-yellow-600 text-blue-900 px-4 py-2 rounded-lg font-medium transition-colors"
        >
          กลับไปหน้าเหตุการณ์
        </button>
      </div>
    );
  }

  return (
    <div className="max-w-4xl mx-auto space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <button
          onClick={handleBackToEventList}
          className="flex items-center text-blue-300 hover:text-blue-200 transition-colors"
        >
          <span className="mr-2">←</span>
          กลับไปหน้าเหตุการณ์
        </button>

        <div className="text-center">
          <h2 className="text-2xl font-bold text-yellow-400 font-serif">
            {eventData?.title || currentEvent?.event_title || "เหตุการณ์"}
          </h2>
          <p className="text-blue-200">
            {eventData?.chapter_title || currentEvent?.chapter_title}
          </p>
        </div>

        <div className="text-blue-300 text-sm">
          {currentInteractionIndex + 1} / {interactions.length}
        </div>
      </div>

      {/* Event Scene */}
      <div className="bg-white/10 backdrop-blur-md rounded-lg border border-white/20 p-8">
        {/* Character Speaker */}
        {currentInteraction.characterSpeaker && (
          <div className="flex items-center mb-6">
            {currentInteraction.characterAvatar && (
              <img
                src={currentInteraction.characterAvatar}
                alt={currentInteraction.characterSpeaker}
                className="w-16 h-16 rounded-full border-2 border-yellow-400"
              />
            )}
            <div className="flex-1">
              <h3 className="text-lg font-bold text-yellow-400">
                {currentInteraction.characterSpeaker}
              </h3>
              <p className="text-sm text-blue-200">
                {currentInteraction.interactionType === "dialogue" ? "บทสนทนา" : "เหตุการณ์"}
              </p>
            </div>
          </div>
        )}

        {/* Dialogue */}
        {currentInteraction.dialogueText && (
          <div className="bg-blue-900/30 rounded-lg border border-blue-500/30 p-6 mb-6">
            <p className="text-white text-lg leading-relaxed">
              {currentInteraction.dialogueText}
            </p>
          </div>
        )}

        {/* Description/Context */}
        {currentInteraction.description && (
          <div className="bg-yellow-900/30 rounded-lg border border-yellow-500/30 p-6 mb-6">
            <div className="flex items-center mb-3">
              <div className="text-yellow-400 text-2xl mr-3">💡</div>
              <h4 className="text-yellow-400 font-medium">คำแนะนำ:</h4>
            </div>
            <p className="text-yellow-100 text-lg leading-relaxed">
              {currentInteraction.description}
            </p>
          </div>
        )}

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

        {/* Interaction Instruction */}
        {!currentInteraction.dialogueText && !currentInteraction.description && (
          <div className="bg-blue-900/30 rounded-lg border border-blue-500/30 p-6 mb-6">
            <div className="flex items-center mb-3">
              <div className="text-blue-400 text-2xl mr-3">🎯</div>
              <h4 className="text-blue-400 font-medium">เลือกการกระทำ:</h4>
            </div>
            <p className="text-blue-200 text-lg leading-relaxed">
              เลือกสิ่งที่คุณต้องการทำจากตัวเลือกด้านล่าง
            </p>
          </div>
        )}

        {/* Choices */}
        {currentInteraction.choices &&
        Array.isArray(currentInteraction.choices) &&
        currentInteraction.choices.length > 0 ? (
          <div className="space-y-4">
            <h4 className="text-yellow-400 font-medium">เลือกการตอบสนอง:</h4>
            <div className="grid gap-3">
              {currentInteraction.choices.map((choice: { id: string; text: string; type: string }) => (
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
