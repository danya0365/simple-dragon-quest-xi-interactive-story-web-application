import { GameEffectsUI } from "@/src/domain/types/ui";
import React from "react";

interface EffectsDisplayProps {
  effects: GameEffectsUI;
  className?: string;
}

/**
 * Component for displaying game effects with exciting UI and icons
 * Transforms effect data into visually appealing cards with animations
 */
export const EffectsDisplay: React.FC<EffectsDisplayProps> = ({
  effects,
  className = "",
}) => {
  const displayElements: React.ReactNode[] = [];

  // Handle items
  if (effects.items && effects.items.length > 0) {
    effects.items.forEach((item, index) => {
      displayElements.push(
        <div
          key={`items-${index}`}
          className="flex items-center gap-3 py-3 px-4 bg-gradient-to-r from-yellow-500/20 via-amber-500/20 to-yellow-500/20 rounded-xl border border-yellow-400/40 animate-pulse shadow-lg shadow-yellow-500/10 hover:shadow-yellow-500/20 transition-all duration-300"
        >
          <div className="flex-shrink-0">
            <span className="text-yellow-400 text-2xl animate-bounce">🎁</span>
          </div>
          <div className="flex-1 min-w-0">
            <span className="text-yellow-200 font-bold text-lg block">
              ได้รับไอเทม!
            </span>
            <div className="text-yellow-100 text-sm font-medium">
              ID: {item.id} x{item.quantity || 1}
            </div>
          </div>
          <div className="flex-shrink-0">
            <span className="text-yellow-300 text-2xl animate-spin-slow">
              ✨
            </span>
          </div>
        </div>
      );
    });
  }

  // Handle relationships
  if (effects.relationship) {
    Object.entries(effects.relationship).forEach(
      ([charName, points], index) => {
        displayElements.push(
          <div
            key={`relationship-${index}`}
            className="flex items-center gap-3 py-3 px-4 bg-gradient-to-r from-pink-500/20 via-rose-500/20 to-pink-500/20 rounded-xl border border-pink-400/40 shadow-lg shadow-pink-500/10 hover:shadow-pink-500/20 transition-all duration-300"
          >
            <div className="flex-shrink-0">
              <span className="text-pink-400 text-2xl animate-pulse">💝</span>
            </div>
            <div className="flex-1 min-w-0">
              <span className="text-pink-200 font-bold text-lg block">
                ความสัมพันธ์เพิ่มขึ้น!
              </span>
              <div className="text-pink-100 text-sm font-medium">
                กับ {charName}: +{points}
              </div>
            </div>
            <div className="flex-shrink-0">
              <span className="text-pink-300 text-2xl animate-bounce">❤️</span>
            </div>
          </div>
        );
      }
    );
  }

  // Handle experience
  if (effects.experience) {
    displayElements.push(
      <div
        key="experience"
        className="flex items-center gap-3 py-3 px-4 bg-gradient-to-r from-green-500/20 via-emerald-500/20 to-green-500/20 rounded-xl border border-green-400/40 shadow-lg shadow-green-500/10 hover:shadow-green-500/20 transition-all duration-300"
      >
        <div className="flex-shrink-0">
          <span className="text-green-400 text-2xl animate-bounce">⭐</span>
        </div>
        <div className="flex-1 min-w-0">
          <span className="text-green-200 font-bold text-lg block">
            ได้รับค่าประสบการณ์!
          </span>
          <div className="text-green-100 text-sm font-medium">
            +{effects.experience} EXP
          </div>
        </div>
        <div className="flex-shrink-0">
          <span className="text-green-300 text-2xl animate-spin-slow">🌟</span>
        </div>
      </div>
    );
  }

  // Handle gold
  if (effects.gold) {
    displayElements.push(
      <div
        key="gold"
        className="flex items-center gap-3 py-3 px-4 bg-gradient-to-r from-yellow-600/20 via-amber-600/20 to-yellow-600/20 rounded-xl border border-yellow-500/40 shadow-lg shadow-yellow-600/10 hover:shadow-yellow-600/20 transition-all duration-300"
      >
        <div className="flex-shrink-0">
          <span className="text-yellow-500 text-2xl animate-bounce">💰</span>
        </div>
        <div className="flex-1 min-w-0">
          <span className="text-yellow-300 font-bold text-lg block">
            ได้รับเงิน!
          </span>
          <div className="text-yellow-200 text-sm font-medium">
            +{effects.gold} ทอง
          </div>
        </div>
        <div className="flex-shrink-0">
          <span className="text-yellow-400 text-2xl animate-spin-slow">🪙</span>
        </div>
      </div>
    );
  }

  // Handle party join
  if (effects.partyJoin) {
    displayElements.push(
      <div
        key="party_join"
        className="flex items-center gap-3 py-3 px-4 bg-gradient-to-r from-blue-500/20 via-indigo-500/20 to-blue-500/20 rounded-xl border border-blue-400/40 shadow-lg shadow-blue-500/10 hover:shadow-blue-500/20 transition-all duration-300"
      >
        <div className="flex-shrink-0">
          <span className="text-blue-400 text-2xl animate-pulse">👥</span>
        </div>
        <div className="flex-1 min-w-0">
          <span className="text-blue-200 font-bold text-lg block">
            ตัวละครเข้าร่วมปาร์ตี้!
          </span>
          <div className="text-blue-100 text-sm font-medium">
            {effects.partyJoin}
          </div>
        </div>
        <div className="flex-shrink-0">
          <span className="text-blue-300 text-2xl animate-bounce">🎉</span>
        </div>
      </div>
    );
  }

  // Handle unlocks
  const unlockTypes = [
    { key: "unlockEvents", icon: "📜", label: "เหตุการณ์" },
    { key: "unlockChapters", icon: "📖", label: "บท" },
    { key: "unlockLocations", icon: "🏰", label: "สถานที่" },
    { key: "unlockRegions", icon: "🗺️", label: "ภูมิภาค" },
  ];

  unlockTypes.forEach(({ key, icon, label }) => {
    const unlockArray = effects[key as keyof GameEffectsUI] as
      | string[]
      | undefined;
    if (unlockArray && unlockArray.length > 0) {
      displayElements.push(
        <div
          key={key}
          className="flex items-center gap-3 py-3 px-4 bg-gradient-to-r from-purple-500/20 via-violet-500/20 to-purple-500/20 rounded-xl border border-purple-400/40 shadow-lg shadow-purple-500/10 hover:shadow-purple-500/20 transition-all duration-300"
        >
          <div className="flex-shrink-0">
            <span className="text-purple-400 text-2xl animate-bounce">
              {icon}
            </span>
          </div>
          <div className="flex-1 min-w-0">
            <span className="text-purple-200 font-bold text-lg block">
              ปลดล็อกใหม่!
            </span>
            <div className="text-purple-100 text-sm font-medium">
              {label}: {unlockArray.length} รายการ
            </div>
          </div>
          <div className="flex-shrink-0">
            <span className="text-purple-300 text-2xl animate-spin-slow">
              🔓
            </span>
          </div>
        </div>
      );
    }
  });

  // Handle unknown effects (fallback for any other properties)
  const unknownEffects = Object.entries(effects).filter(
    ([key]) =>
      ![
        "items",
        "relationship",
        "experience",
        "gold",
        "partyJoin",
        "unlockEvents",
        "unlockChapters",
        "unlockLocations",
        "unlockRegions",
      ].includes(key)
  );

  unknownEffects.forEach(([key, value], index) => {
    if (Array.isArray(value)) {
      displayElements.push(
        <div
          key={`unknown-array-${key}-${index}`}
          className="flex items-center gap-3 py-3 px-4 bg-gradient-to-r from-gray-500/20 via-slate-500/20 to-gray-500/20 rounded-xl border border-gray-400/40 shadow-lg shadow-gray-500/10 hover:shadow-gray-500/20 transition-all duration-300"
        >
          <div className="flex-shrink-0">
            <span className="text-gray-400 text-2xl animate-pulse">📋</span>
          </div>
          <div className="flex-1 min-w-0">
            <span className="text-gray-200 font-bold text-lg block">
              {key.replace(/_/g, " ")}
            </span>
            <div className="text-gray-100 text-sm font-medium">
              {value.length} รายการ
            </div>
          </div>
          <div className="flex-shrink-0">
            <span className="text-gray-300 text-2xl animate-bounce">📊</span>
          </div>
        </div>
      );
    } else if (typeof value === "object" && value !== null) {
      displayElements.push(
        <div
          key={`default-object-${key}-${index}`}
          className="flex items-center gap-3 py-3 px-4 bg-gradient-to-r from-gray-500/20 via-slate-500/20 to-gray-500/20 rounded-xl border border-gray-400/40 shadow-lg shadow-gray-500/10 hover:shadow-gray-500/20 transition-all duration-300"
        >
          <div className="flex-shrink-0">
            <span className="text-gray-400 text-2xl animate-pulse">📦</span>
          </div>
          <div className="flex-1 min-w-0">
            <span className="text-gray-200 font-bold text-lg block">
              {key.replace(/_/g, " ")}
            </span>
            <div className="text-gray-100 text-sm font-medium">
              {JSON.stringify(value)}
            </div>
          </div>
          <div className="flex-shrink-0">
            <span className="text-gray-300 text-2xl animate-bounce">🔍</span>
          </div>
        </div>
      );
    } else {
      displayElements.push(
        <div
          key={`default-value-${key}-${index}`}
          className="flex items-center gap-3 py-3 px-4 bg-gradient-to-r from-gray-500/20 via-slate-500/20 to-gray-500/20 rounded-xl border border-gray-400/40 shadow-lg shadow-gray-500/10 hover:shadow-gray-500/20 transition-all duration-300"
        >
          <div className="flex-shrink-0">
            <span className="text-gray-400 text-2xl animate-pulse">📝</span>
          </div>
          <div className="flex-1 min-w-0">
            <span className="text-gray-200 font-bold text-lg block">
              {key.replace(/_/g, " ")}
            </span>
            <div className="text-gray-100 text-sm font-medium">
              {String(value)}
            </div>
          </div>
          <div className="flex-shrink-0">
            <span className="text-gray-300 text-2xl animate-bounce">💡</span>
          </div>
        </div>
      );
    }
  });

  if (displayElements.length === 0) {
    return (
      <div className={`text-center text-gray-400 py-4 ${className}`}>
        ไม่มีผลลัพธ์พิเศษ
      </div>
    );
  }

  return <div className={`space-y-3 ${className}`}>{displayElements}</div>;
};
