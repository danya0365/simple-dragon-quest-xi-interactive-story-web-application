"use client";

import { EventType } from "../../../domain/types/enums";

interface EventTypeBadgeProps {
  eventType: EventType;
}

export function EventTypeBadge({ eventType }: EventTypeBadgeProps) {
  const getEventTypeConfig = (type: EventType) => {
    switch (type) {
      case EventType.DIALOGUE:
        return {
          bgColor: "bg-green-500/20",
          textColor: "text-green-300",
          borderColor: "border-green-500/50",
          label: "💬 บทสนทนา",
        };
      case EventType.EXPLORATION:
        return {
          bgColor: "bg-cyan-500/20",
          textColor: "text-cyan-300",
          borderColor: "border-cyan-500/50",
          label: "🗺️ สำรวจ",
        };
      case EventType.SHOPPING:
        return {
          bgColor: "bg-yellow-500/20",
          textColor: "text-yellow-300",
          borderColor: "border-yellow-500/50",
          label: "🛍️ ช้อปปิ้ง",
        };
      case EventType.STORY:
        return {
          bgColor: "bg-blue-500/20",
          textColor: "text-blue-300",
          borderColor: "border-blue-500/50",
          label: "📖 เรื่องราว",
        };
      case EventType.ACTION:
        return {
          bgColor: "bg-orange-500/20",
          textColor: "text-orange-300",
          borderColor: "border-orange-500/50",
          label: "⚡ แอ็คชัน",
        };
      case EventType.CHOICE:
        return {
          bgColor: "bg-purple-500/20",
          textColor: "text-purple-300",
          borderColor: "border-purple-500/50",
          label: "🤔 ตัวเลือก",
        };
      case EventType.TRIAL:
        return {
          bgColor: "bg-indigo-500/20",
          textColor: "text-indigo-300",
          borderColor: "border-indigo-500/50",
          label: "⚖️ การทดสอบ",
        };
      case EventType.BATTLE:
        return {
          bgColor: "bg-red-500/20",
          textColor: "text-red-300",
          borderColor: "border-red-500/50",
          label: "⚔️ การต่อสู้",
        };
      case EventType.BOSS_BATTLE:
        return {
          bgColor: "bg-red-600/20",
          textColor: "text-red-200",
          borderColor: "border-red-600/50",
          label: "👺 บอสต่อสู้",
        };
      case EventType.QUEST:
        return {
          bgColor: "bg-yellow-600/20",
          textColor: "text-yellow-300",
          borderColor: "border-yellow-600/50",
          label: "📜 ภารกิจ",
        };
      case EventType.BLESSING:
        return {
          bgColor: "bg-pink-500/20",
          textColor: "text-pink-300",
          borderColor: "border-pink-500/50",
          label: "✨ พร",
        };
      case EventType.PREPARATION:
        return {
          bgColor: "bg-teal-500/20",
          textColor: "text-teal-300",
          borderColor: "border-teal-500/50",
          label: "🛡️ เตรียมการ",
        };
      case EventType.CLIMAX:
        return {
          bgColor: "bg-violet-500/20",
          textColor: "text-violet-300",
          borderColor: "border-violet-500/50",
          label: "🎭 คลิแมกซ์",
        };
      case EventType.TIME_TRAVEL:
        return {
          bgColor: "bg-purple-600/20",
          textColor: "text-purple-300",
          borderColor: "border-purple-600/50",
          label: "⏰ ย้อนเวลา",
        };
      case EventType.REVELATION:
        return {
          bgColor: "bg-amber-500/20",
          textColor: "text-amber-300",
          borderColor: "border-amber-500/50",
          label: "💡 การเปิดเผย",
        };
      case EventType.ULTIMATE_BATTLE:
        return {
          bgColor: "bg-red-700/20",
          textColor: "text-red-200",
          borderColor: "border-red-700/50",
          label: "🔥 การต่อสู้สุดยอด",
        };
      case EventType.CONSTRUCTION:
        return {
          bgColor: "bg-gray-600/20",
          textColor: "text-gray-300",
          borderColor: "border-gray-600/50",
          label: "🏗️ การก่อสร้าง",
        };
      case EventType.WEDDING:
        return {
          bgColor: "bg-rose-500/20",
          textColor: "text-rose-300",
          borderColor: "border-rose-500/50",
          label: "💒 งานแต่งงาน",
        };
      case EventType.LIFE_EVENT:
        return {
          bgColor: "bg-emerald-500/20",
          textColor: "text-emerald-300",
          borderColor: "border-emerald-500/50",
          label: "🌱 เหตุการณ์ชีวิต",
        };
      case EventType.REFLECTION:
        return {
          bgColor: "bg-slate-500/20",
          textColor: "text-slate-300",
          borderColor: "border-slate-500/50",
          label: "🪞 การสะท้อน",
        };
      case EventType.LEGACY:
        return {
          bgColor: "bg-amber-600/20",
          textColor: "text-amber-300",
          borderColor: "border-amber-600/50",
          label: "👑 มรดก",
        };
      case EventType.FINALE:
        return {
          bgColor: "bg-gradient-to-r from-purple-500/20 via-pink-500/20 to-red-500/20",
          textColor: "text-yellow-300",
          borderColor: "border-yellow-500/50",
          label: "🎆 ไฟนาเล",
        };
      default:
        return {
          bgColor: "bg-gray-500/20",
          textColor: "text-gray-300",
          borderColor: "border-gray-500/50",
          label: "❓ ไม่ทราบ",
        };
    }
  };

  const config = getEventTypeConfig(eventType);

  return (
    <span
      className={`px-3 py-1 rounded-full text-xs font-medium ${config.bgColor} ${config.textColor} border ${config.borderColor}`}
    >
      {config.label}
    </span>
  );
}
