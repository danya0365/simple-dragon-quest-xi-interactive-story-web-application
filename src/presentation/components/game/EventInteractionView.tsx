"use client";

import { EventOutcomeDto } from "@/src/domain/types/rpc";
import { EventInteractionUI } from "@/src/domain/types/ui";
import { formatEffectsForDisplay } from "@/src/presentation/components/game/EffectsDisplay";
import { useGameStore } from "@/src/stores/gameStore";
import Image from "next/image";
import { useCallback, useEffect, useState } from "react";

type InteractionState =
  | "loading"
  | "selecting"
  | "processing"
  | "showing_outcome"
  | "completed";

export function EventInteractionView() {
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

  // Component state
  const [interactionState, setInteractionState] =
    useState<InteractionState>("loading");
  const [currentInteraction, setCurrentInteraction] =
    useState<EventInteractionUI | null>(null);
  const [selectedChoice, setSelectedChoice] = useState<string | null>(null);
  const [interactionHistory, setInteractionHistory] = useState<string[]>([]);
  const [currentEventOutcome, setCurrentEventOutcome] =
    useState<EventOutcomeDto | null>(null);
  const [allInteractions, setAllInteractions] = useState<EventInteractionUI[]>(
    []
  );
  const [currentInteractionIndex, setCurrentInteractionIndex] =
    useState<number>(0);

  // Find current event from available events
  const currentEvent = availableEvents.find(
    (event) => event.eventId === selectedEventId
  );

  // Check if interaction is completed
  const isInteractionCompleted = useCallback(
    (interactionId: string) => {
      const completedInteractions = userGameState?.completedInteractions || [];
      return completedInteractions.some(
        (ci) =>
          ci.eventId === selectedEventId && ci.interactionId === interactionId
      );
    },
    [userGameState?.completedInteractions, selectedEventId]
  );

  // Initialize component
  useEffect(() => {
    const initializeComponent = async () => {
      if (!selectedEventId) {
        setInteractionState("completed");
        return;
      }

      setInteractionState("loading");

      try {
        // Load available events if needed
        if (selectedLocationId && availableEvents.length === 0) {
          await loadAvailableEvents(selectedLocationId);
        }

        // Load interactions for current event
        const interactions = await loadEventInteractions(selectedEventId);

        if (interactions && interactions.length > 0) {
          // Store all interactions
          setAllInteractions(interactions);

          // Find the next incomplete interaction in sequence
          const nextInteractionIndex = interactions.findIndex(
            (interaction) => !isInteractionCompleted(interaction.id)
          );

          if (nextInteractionIndex !== -1) {
            setCurrentInteraction(interactions[nextInteractionIndex]);
            setCurrentInteractionIndex(nextInteractionIndex);
            setInteractionState("selecting");
          } else {
            // All interactions completed
            setInteractionState("completed");
          }
        } else {
          // No interactions found
          setInteractionState("completed");
        }
      } catch (error) {
        console.error("EventInteractionView: Initialization error:", error);
        setInteractionState("completed");
      }
    };

    initializeComponent();
  }, [
    selectedEventId,
    availableEvents.length,
    isInteractionCompleted,
    loadAvailableEvents,
    loadEventInteractions,
    selectedLocationId,
  ]);

  // Handle manual navigation back to event view
  const handleBackToEvents = () => {
    setSelectedEventId(null);
    setCurrentView("event");
  };

  // Move to next interaction or complete
  const moveToNextInteraction = useCallback(async () => {
    if (!selectedEventId || allInteractions.length === 0) {
      setInteractionState("completed");
      return;
    }

    try {
      // Find the next incomplete interaction starting from current index + 1
      const nextInteractionIndex = allInteractions.findIndex(
        (interaction, index) =>
          index > currentInteractionIndex &&
          !isInteractionCompleted(interaction.id)
      );

      if (nextInteractionIndex !== -1) {
        setCurrentInteraction(allInteractions[nextInteractionIndex]);
        setCurrentInteractionIndex(nextInteractionIndex);
        setInteractionState("selecting");
        setSelectedChoice(null);
      } else {
        // Check if there are any incomplete interactions before current index
        const previousIncompleteIndex = allInteractions.findIndex(
          (interaction, index) =>
            index < currentInteractionIndex &&
            !isInteractionCompleted(interaction.id)
        );

        if (previousIncompleteIndex !== -1) {
          setCurrentInteraction(allInteractions[previousIncompleteIndex]);
          setCurrentInteractionIndex(previousIncompleteIndex);
          setInteractionState("selecting");
          setSelectedChoice(null);
        } else {
          // All interactions completed
          setInteractionState("completed");
        }
      }
    } catch (error) {
      console.error(
        "EventInteractionView: Error loading next interaction:",
        error
      );
      setInteractionState("completed");
    }
  }, [
    selectedEventId,
    allInteractions,
    currentInteractionIndex,
    isInteractionCompleted,
  ]);

  // Handle manual continue after outcome display
  const handleContinueAfterOutcome = () => {
    setCurrentEventOutcome(null);
    // Move to next interaction or complete
    moveToNextInteraction();
  };

  const handleChoiceSelect = (choiceKey: string) => {
    if (interactionState !== "selecting") return;
    setSelectedChoice(choiceKey);
  };

  const handleConfirmChoice = async () => {
    if (!currentInteraction || interactionState !== "selecting") {
      return;
    }

    // If there are no choices, use a default choice
    const choiceToUse = selectedChoice || "default";

    // Prevent duplicate submissions
    if (isInteractionCompleted(currentInteraction.id)) {
      console.warn("Interaction already completed, moving to next");
      moveToNextInteraction();
      return;
    }

    setInteractionState("processing");

    try {
      const choiceData = {
        choiceKey: choiceToUse,
        interactionId: currentInteraction.id,
      };

      // Complete the interaction
      const result = await completeInteraction(
        currentInteraction.id,
        choiceData
      );

      if (result.success) {
        // Add to history only if there are actual choices
        if (
          currentInteraction.choices &&
          currentInteraction.choices.length > 0
        ) {
          const choice = currentInteraction.choices.find(
            (c: { id: string }) => c.id === selectedChoice
          );
          if (choice) {
            setInteractionHistory((prev: string[]) => [...prev, choice.text]);
          }
        }

        // Show outcome if available
        if (result.eventOutcome) {
          setCurrentEventOutcome(result.eventOutcome);
          setInteractionState("showing_outcome");
        } else {
          // No outcome, move to next interaction
          moveToNextInteraction();
        }
      } else {
        // Handle error
        console.error(
          "EventInteractionView: Interaction failed:",
          result.error
        );
        setInteractionState("selecting");
      }
    } catch (error) {
      console.error(
        "EventInteractionView: Error completing interaction:",
        error
      );
      setInteractionState("selecting");
    }
  };

  const handleBackToEventList = () => {
    setSelectedEventId(null);
    setCurrentView("event");
  };

  // Loading state
  if (loading || interactionState === "loading") {
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

  // Completed state - all interactions done
  if (interactionState === "completed") {
    return (
      <div className="text-center py-12">
        <div className="text-green-400 text-6xl mb-4">✅</div>
        <h2 className="text-2xl font-bold text-green-400 mb-4">
          เหตุการณ์สมบูรณ์!
        </h2>
        <p className="text-blue-200 mb-6">
          คุณได้ทำการโต้ตอบทั้งหมดของเหตุการณ์นี้เสร็จสิ้นแล้ว
        </p>
        <button
          onClick={handleBackToEvents}
          className="px-6 py-3 bg-blue-600 hover:bg-blue-700 text-white rounded-lg font-medium transition-colors duration-200"
        >
          กลับไปหน้าเหตุการณ์
        </button>
      </div>
    );
  }

  // No event or interaction data state
  if (!currentEvent || !currentInteraction) {
    return (
      <div className="text-center py-12">
        <div className="text-yellow-400 text-6xl mb-4">⚠️</div>
        <h2 className="text-2xl font-bold text-yellow-400 mb-4">
          ไม่พบข้อมูลเหตุการณ์
        </h2>
        <p className="text-blue-200 mb-6">
          ไม่สามารถโหลดข้อมูลเหตุการณ์หรือการโต้ตอบได้
        </p>
        <button
          onClick={handleBackToEvents}
          className="px-6 py-3 bg-blue-600 hover:bg-blue-700 text-white rounded-lg font-medium transition-colors duration-200"
        >
          กลับไปหน้าเหตุการณ์
        </button>
      </div>
    );
  }

  return (
    <>
      <style jsx>{`
        @keyframes fadeIn {
          from {
            opacity: 0;
            transform: translateY(10px);
          }
          to {
            opacity: 1;
            transform: translateY(0);
          }
        }
      `}</style>
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
              {currentEvent?.eventTitle || "เหตุการณ์"}
            </h2>
            <p className="text-blue-200">{currentEvent?.chapterTitle}</p>
          </div>

          <div className="text-blue-300 text-sm">
            {interactionHistory.length + 1}
          </div>
        </div>

        {/* Event Scene */}
        <div className="bg-white/10 backdrop-blur-md rounded-lg border border-white/20 p-8">
          {/* Character Speaker */}
          {currentInteraction.characterSpeaker && (
            <div className="flex items-center mb-6">
              {currentInteraction.characterAvatar && (
                <Image
                  src={currentInteraction.characterAvatar}
                  alt={currentInteraction.characterSpeaker}
                  width={64}
                  height={64}
                  className="w-16 h-16 rounded-full border-2 border-yellow-400"
                />
              )}
              <div className="flex-1">
                <h3 className="text-lg font-bold text-yellow-400">
                  {currentInteraction.characterSpeaker}
                </h3>
                <p className="text-sm text-blue-200">
                  {currentInteraction.interactionType === "dialogue"
                    ? "บทสนทนา"
                    : "เหตุการณ์"}
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

          {/* Event Outcome Display */}
          {currentEventOutcome && (
            <div
              className="mb-6"
              style={{
                animation: "fadeIn 0.5s ease-in-out",
              }}
            >
              <div className="bg-purple-900/30 border border-purple-500/30 rounded-lg p-6">
                <div className="flex items-center mb-4">
                  <div className="text-purple-400 text-2xl mr-3">✨</div>
                  <h4 className="text-purple-400 font-medium text-lg">
                    ผลลัพธ์:
                  </h4>
                </div>
                {currentEventOutcome && (
                  <div className="bg-blue-900/80 backdrop-blur-sm rounded-lg p-6 border border-blue-700">
                    <h3 className="text-xl font-bold text-yellow-400 mb-4">
                      ผลลัพธ์
                    </h3>
                    <div className="text-blue-100 mb-6 whitespace-pre-line">
                      {currentEventOutcome?.title}
                      {currentEventOutcome?.description && (
                        <div className="mt-2 text-blue-200">
                          {currentEventOutcome.description}
                        </div>
                      )}
                    </div>
                    <div className="flex justify-center">
                      <button
                        onClick={handleContinueAfterOutcome}
                        className="px-6 py-3 bg-blue-600 hover:bg-blue-700 text-white rounded-lg font-medium transition-colors duration-200"
                      >
                        ดำเนินการต่อ
                      </button>
                    </div>
                  </div>
                )}
                {currentEventOutcome.effects &&
                  Object.keys(currentEventOutcome.effects).length > 0 && (
                    <div className="mt-4 pt-4 border-t border-purple-500/30">
                      <h5 className="text-purple-300 font-medium mb-2">
                        สิ่งที่ได้รับ:
                      </h5>
                      <div className="text-sm text-purple-200 space-y-1">
                        {formatEffectsForDisplay(currentEventOutcome.effects).map(
                          (line: string, index: number) => (
                            <div
                              key={index}
                              className="py-1"
                            >
                              {line}
                            </div>
                          )
                        )}
                      </div>
                    </div>
                  )}
              </div>
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
          {!currentInteraction.dialogueText &&
            !currentInteraction.description && (
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

          {/* Choices - Hide when showing outcome or processing */}
          {interactionState === "selecting" && (
            <>
              {currentInteraction.choices &&
              currentInteraction.choices.length > 0 ? (
                <div className="space-y-3">
                  <h4 className="text-yellow-400 font-medium mb-3">
                    เลือกตัวเลือก:
                  </h4>
                  {currentInteraction.choices.map(
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
                    onClick={handleConfirmChoice}
                    className="bg-yellow-500 hover:bg-yellow-600 text-blue-900 px-8 py-3 rounded-lg font-medium transition-colors"
                  >
                    ดำเนินการต่อ
                  </button>
                </div>
              )}
            </>
          )}

          {/* Confirm Button - Show only when choice is selected, not processing, and there are actual choices */}
          {selectedChoice &&
            interactionState === "selecting" &&
            currentInteraction.choices &&
            currentInteraction.choices.length > 0 && (
              <div className="flex justify-center mt-6">
                <button
                  onClick={handleConfirmChoice}
                  className="bg-green-500 hover:bg-green-600 text-white px-8 py-3 rounded-lg font-medium transition-colors"
                >
                  ยืนยัน
                </button>
              </div>
            )}

          {/* Processing State */}
          {interactionState === "processing" && (
            <div className="flex justify-center mt-6">
              <div className="text-center">
                <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-green-400 mx-auto mb-2"></div>
                <p className="text-green-200">กำลังดำเนินการ...</p>
              </div>
            </div>
          )}
        </div>

        {/* Event Info */}
        <div className="bg-blue-900/30 rounded-lg border border-blue-500/30 p-4">
          <div className="grid grid-cols-1 md:grid-cols-3 gap-4 text-sm">
            <div>
              <span className="text-yellow-400 font-medium">ประเภท:</span>
              <span className="text-blue-200 ml-2">
                {currentEvent?.eventType}
              </span>
            </div>
            <div>
              <span className="text-yellow-400 font-medium">สถานที่:</span>
              <span className="text-blue-200 ml-2">
                {currentEvent?.locationName || "ไม่ระบุ"}
              </span>
            </div>
            <div>
              <span className="text-yellow-400 font-medium">
                การโต้ตอบที่ผ่านมา:
              </span>
              <span className="text-blue-200 ml-2">
                {interactionHistory.length}
              </span>
            </div>
          </div>
        </div>
      </div>
    </>
  );
}
