"use client";

import { useAuthStore } from "@/src/stores/authStore";
import { useGameStore, EventInteraction } from "@/src/stores/gameStore";
import { useState, useEffect } from "react";
import Image from "next/image";

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

  // Initialize component - load available events if not already loaded
  useEffect(() => {
    if (!isInitialized && user?.id && selectedLocationId) {
      loadAvailableEvents(selectedLocationId);
      setIsInitialized(true);
    }
  }, [user?.id, selectedLocationId, loadAvailableEvents, isInitialized]);

  // Load event interactions when event is selected
  useEffect(() => {
    if (selectedEventId && user?.id) {
      const loadInteractions = async () => {
        try {
          const data = await loadEventInteractions(selectedEventId);

          if (data && !(data as unknown as { error: unknown }).error) {
            // API คืนค่ามาเป็น array ของ interactions ตรงๆ
            const interactions = Array.isArray(data) ? data : [];

            // แปลง StoryEvent เป็น EventData structure
            const eventData = currentEvent
              ? {
                  id: currentEvent.event_id,
                  title: currentEvent.event_title,
                  description: currentEvent.event_description || "",
                  event_type: currentEvent.event_type,
                  chapter_title: currentEvent.chapter_title || "",
                  location_name: currentEvent.location_name || "",
                }
              : null;

            // Set all interactions first (we'll handle filtering in render)
            setEventData(eventData);
            setInteractions(interactions);
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
  }, [selectedEventId, user?.id, loadEventInteractions, currentEvent]);

  const handleChoiceSelect = (choiceKey: string) => {
    console.log("EventInteractionView: Choice selected:", choiceKey);
    setSelectedChoice(choiceKey);
  };

  const handleConfirmChoice = async () => {
    if (!user?.id || !currentAvailableInteraction) {
      console.error("EventInteractionView: Missing user or interaction", {
        user: !!user,
        interaction: !!currentAvailableInteraction,
      });
      return;
    }

    // Prepare choice data
    const choiceData = selectedChoice
      ? {
          choice_key: selectedChoice,
          interaction_id: currentAvailableInteraction.id,
        }
      : {
          choice_key: "default",
          interaction_id: currentAvailableInteraction.id,
        };

    try {
      // Complete the interaction
      const result = await completeInteraction(
        currentAvailableInteraction.id,
        choiceData
      );
      console.log(
        "EventInteractionView: Interaction completion result:",
        result
      );

      // Add to history
      if (selectedChoice) {
        const choice = currentAvailableInteraction.choices.find(
          (c: { id: string }) => c.id === selectedChoice
        );
        if (choice) {
          setInteractionHistory((prev) => [...prev, choice.text]);
        }
      } else {
        setInteractionHistory((prev) => [...prev, "ดำเนินการต่อ"]);
      }

      // Check if there are more interactions in the current event
      const remainingInteractions = interactions.filter(
        (interaction, index) =>
          index > currentInteractionIndex &&
          !isInteractionCompleted(interaction.id)
      );

      console.log(
        "EventInteractionView: Remaining interactions:",
        remainingInteractions.length
      );

      if (remainingInteractions.length > 0) {
        // Move to next available interaction
        const nextInteractionIndex = interactions.findIndex(
          (interaction, index) =>
            index > currentInteractionIndex &&
            !isInteractionCompleted(interaction.id)
        );

        if (nextInteractionIndex !== -1) {
          setCurrentInteractionIndex(nextInteractionIndex);
          console.log(
            "EventInteractionView: Moving to next interaction:",
            nextInteractionIndex
          );
        }
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

  // Helper function to check if interaction is completed
  const isInteractionCompleted = (interactionId: string) => {
    const completedInteractions =
      (userGameState?.completedInteractions as Array<{
        event_id: string;
        interaction_id: string;
      }>) || [];
    return completedInteractions.some(
      (ci) =>
        ci.event_id === selectedEventId && ci.interaction_id === interactionId
    );
  };

  // Filter out completed interactions and get current interaction
  const availableInteractions = interactions.filter(
    (interaction) => !isInteractionCompleted(interaction.id)
  );

  const currentAvailableInteraction =
    availableInteractions[currentInteractionIndex] || null;

  // Check if all interactions are completed
  const allInteractionsCompleted =
    availableInteractions.length === 0 && interactions.length > 0;

  // If all interactions are completed, go back to event list
  useEffect(() => {
    if (allInteractionsCompleted && interactions.length > 0) {
      console.log(
        "EventInteractionView: All interactions completed, going back to event list"
      );
      setTimeout(() => {
        setSelectedEventId(null);
        setCurrentView("event");
      }, 1000);
    }
  }, [
    allInteractionsCompleted,
    interactions.length,
    setSelectedEventId,
    setCurrentView,
  ]);

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

  if (!currentAvailableInteraction) {
    return (
      <div className="text-center py-12">
        <div className="text-blue-400 text-6xl mb-4">📝</div>
        <p className="text-blue-200 font-medium mb-2">ไม่พบการโต้ตอบ</p>
        <p className="text-blue-300 text-sm mb-4">
          Event: {currentEvent?.event_title}
        </p>
        <p className="text-blue-300 text-sm mb-4">
          Loaded Interactions: {interactions.length}
        </p>
        <p className="text-blue-300 text-sm mb-4">
          Available Interactions: {availableInteractions.length}
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
          {currentInteractionIndex + 1} / {availableInteractions.length}
        </div>
      </div>

      {/* Event Scene */}
      <div className="bg-white/10 backdrop-blur-md rounded-lg border border-white/20 p-8">
        {/* Character Speaker */}
        {currentAvailableInteraction.characterSpeaker && (
          <div className="flex items-center mb-6">
            {currentAvailableInteraction.characterAvatar && (
              <Image
                src={currentAvailableInteraction.characterAvatar}
                alt={currentAvailableInteraction.characterSpeaker}
                width={64}
                height={64}
                className="w-16 h-16 rounded-full border-2 border-yellow-400"
              />
            )}
            <div className="flex-1">
              <h3 className="text-lg font-bold text-yellow-400">
                {currentAvailableInteraction.characterSpeaker}
              </h3>
              <p className="text-sm text-blue-200">
                {currentAvailableInteraction.interactionType === "dialogue"
                  ? "บทสนทนา"
                  : "เหตุการณ์"}
              </p>
            </div>
          </div>
        )}

        {/* Dialogue */}
        {currentAvailableInteraction.dialogueText && (
          <div className="bg-blue-900/30 rounded-lg border border-blue-500/30 p-6 mb-6">
            <p className="text-white text-lg leading-relaxed">
              {currentAvailableInteraction.dialogueText}
            </p>
          </div>
        )}

        {/* Description/Context */}
        {currentAvailableInteraction.description && (
          <div className="bg-yellow-900/30 rounded-lg border border-yellow-500/30 p-6 mb-6">
            <div className="flex items-center mb-3">
              <div className="text-yellow-400 text-2xl mr-3">💡</div>
              <h4 className="text-yellow-400 font-medium">คำแนะนำ:</h4>
            </div>
            <p className="text-yellow-100 text-lg leading-relaxed">
              {currentAvailableInteraction.description}
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
        {!currentAvailableInteraction.dialogueText &&
          !currentAvailableInteraction.description && (
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
        {currentAvailableInteraction.choices &&
        currentAvailableInteraction.choices.length > 0 ? (
          <div className="space-y-3">
            <h4 className="text-yellow-400 font-medium mb-3">เลือกตัวเลือก:</h4>
            {currentAvailableInteraction.choices.map(
              (choice: { id: string; text: string }) => (
                <button
                  key={choice.id}
                  onClick={() => handleChoiceSelect(choice.id)}
                  className={`w-full text-left p-4 rounded-lg border transition-colors ${
                    selectedChoice === choice.id
                      ? "bg-yellow-500 border-yellow-400 text-blue-900"
                      : "bg-blue-900/50 border-blue-500/50 text-blue-100 hover:bg-blue-900/70"
                  }`}
                >
                  {choice.text}
                </button>
              )
            )}
          </div>
        ) : (
          <div className="text-center">
            <button
              onClick={() => handleChoiceSelect("default")}
              className="bg-yellow-500 hover:bg-yellow-600 text-blue-900 px-8 py-3 rounded-lg font-medium transition-colors"
            >
              ดำเนินการต่อ
            </button>
          </div>
        )}

        {/* Confirm Button */}
        {selectedChoice && (
          <div className="flex justify-center mt-6">
            <button
              onClick={handleConfirmChoice}
              className="bg-green-500 hover:bg-green-600 text-white px-8 py-3 rounded-lg font-medium transition-colors"
            >
              ยืนยัน
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
              {currentEvent?.event_type}
            </span>
          </div>
          <div>
            <span className="text-yellow-400 font-medium">สถานที่:</span>
            <span className="text-blue-200 ml-2">
              {currentEvent?.location_name || "ไม่ระบุ"}
            </span>
          </div>
          <div>
            <span className="text-yellow-400 font-medium">การโต้ตอบ:</span>
            <span className="text-blue-200 ml-2">{interactions.length}</span>
          </div>
        </div>
      </div>
    </div>
  );
}
