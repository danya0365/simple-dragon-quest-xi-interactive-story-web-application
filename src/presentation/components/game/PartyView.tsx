"use client";

import { useGameStore } from "@/src/stores/gameStore";

interface PartyMember {
  character_id: string;
  name: string;
  description: string;
  avatar_url: string;
  current_stats: Record<string, number | string>;
  equipment: Record<string, string | null>;
  party_position: number;
  joined_at: string;
}

export function PartyView() {
  const { userGameState, loading, error } = useGameStore();

  const partyMembers = userGameState?.partyMembers || [];

  const getStatIcon = (statName: string) => {
    switch (statName.toLowerCase()) {
      case "hp":
      case "health":
        return "❤️";
      case "mp":
      case "mana":
        return "💙";
      case "attack":
      case "str":
      case "strength":
        return "⚔️";
      case "defense":
      case "def":
        return "🛡️";
      case "speed":
      case "agility":
        return "💨";
      case "magic":
      case "int":
      case "intelligence":
        return "✨";
      case "level":
        return "⭐";
      default:
        return "📊";
    }
  };

  const getEquipmentIcon = (equipType: string) => {
    switch (equipType.toLowerCase()) {
      case "weapon":
        return "⚔️";
      case "helmet":
      case "head":
        return "⛑️";
      case "armor":
      case "chest":
        return "🛡️";
      case "gloves":
      case "hands":
        return "🧤";
      case "boots":
      case "feet":
        return "👢";
      case "accessory":
      case "ring":
        return "💍";
      default:
        return "📦";
    }
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center min-h-[400px]">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-yellow-400 mx-auto mb-4"></div>
          <p className="text-blue-200">กำลังโหลดข้อมูลปาร์ตี้...</p>
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
          <p className="text-blue-200">{error}</p>
        </div>
      </div>
    );
  }

  return (
    <div className="max-w-6xl mx-auto space-y-6">
      {/* Header */}
      <div className="text-center">
        <h2 className="text-3xl font-bold text-yellow-400 font-serif mb-2">
          👥 ปาร์ตี้
        </h2>
        <p className="text-blue-200">
          สมาชิกในปาร์ตี้: {partyMembers.length} คน
        </p>
      </div>

      {/* Party Members */}
      {partyMembers.length === 0 ? (
        <div className="text-center py-8 lg:py-12">
          <div className="text-blue-400 text-4xl lg:text-6xl mb-4">👤</div>
          <p className="text-blue-200 font-medium mb-2">
            ยังไม่มีสมาชิกในปาร์ตี้
          </p>
          <p className="text-blue-300 text-sm lg:text-base">
            ผจญภัยต่อไปเพื่อพบเพื่อนร่วมทาง!
          </p>
        </div>
      ) : (
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-4 lg:gap-6">
          {partyMembers
            .sort(
              (a: PartyMember, b: PartyMember) =>
                a.party_position - b.party_position
            )
            .map((member: PartyMember) => (
              <div
                key={member.character_id}
                className="bg-white/10 backdrop-blur-md rounded-lg border border-white/20 p-6 hover:bg-white/15 transition-all duration-200"
              >
                {/* Member Header */}
                <div className="flex items-center space-x-4 mb-6">
                  {/* Avatar */}
                  <div className="relative">
                    {member.avatar_url ? (
                      <img
                        src={member.avatar_url}
                        alt={member.name}
                        className="w-16 h-16 rounded-full object-cover border-2 border-yellow-400"
                      />
                    ) : (
                      <div className="w-16 h-16 bg-gradient-to-br from-yellow-400 to-yellow-500 rounded-full flex items-center justify-center border-2 border-yellow-400">
                        <span className="text-blue-900 font-bold text-xl">
                          {member.name.charAt(0)}
                        </span>
                      </div>
                    )}
                    {/* Position Badge */}
                    <div className="absolute -top-2 -right-2 w-6 h-6 bg-blue-600 text-white text-xs rounded-full flex items-center justify-center font-bold">
                      {member.party_position}
                    </div>
                  </div>

                  {/* Member Info */}
                  <div className="flex-1">
                    <h3 className="text-white font-bold text-lg">
                      {member.name}
                    </h3>
                    <p className="text-blue-200 text-sm mb-2">
                      {member.description}
                    </p>
                    <div className="text-blue-300 text-xs">
                      เข้าร่วม:{" "}
                      {new Date(member.joined_at).toLocaleDateString("th-TH")}
                    </div>
                  </div>
                </div>

                {/* Stats */}
                <div className="mb-6">
                  <h4 className="text-yellow-400 font-medium mb-3">สถานะ</h4>
                  <div className="grid grid-cols-2 gap-3">
                    {Object.entries(member.current_stats).map(
                      ([statName, value]) => (
                        <div
                          key={statName}
                          className="bg-blue-900/30 rounded-lg border border-blue-500/30 p-3"
                        >
                          <div className="flex items-center justify-between">
                            <div className="flex items-center space-x-2">
                              <span className="text-lg">
                                {getStatIcon(statName)}
                              </span>
                              <span className="text-blue-200 text-sm capitalize">
                                {statName}
                              </span>
                            </div>
                            <span className="text-white font-bold">
                              {value}
                            </span>
                          </div>
                        </div>
                      )
                    )}
                  </div>
                </div>

                {/* Equipment */}
                <div>
                  <h4 className="text-yellow-400 font-medium mb-3">อุปกรณ์</h4>
                  <div className="grid grid-cols-2 gap-2">
                    {Object.entries(member.equipment).map(([slot, item]) => (
                      <div
                        key={slot}
                        className="bg-black/20 rounded-lg border border-white/10 p-2"
                      >
                        <div className="flex items-center space-x-2">
                          <span className="text-sm">
                            {getEquipmentIcon(slot)}
                          </span>
                          <div className="flex-1 min-w-0">
                            <div className="text-blue-300 text-xs capitalize">
                              {slot}
                            </div>
                            <div className="text-white text-xs truncate">
                              {item || "ไม่มี"}
                            </div>
                          </div>
                        </div>
                      </div>
                    ))}
                  </div>
                </div>
              </div>
            ))}
        </div>
      )}

      {/* Party Stats */}
      {partyMembers.length > 0 && (
        <div className="bg-blue-900/30 rounded-lg border border-blue-500/30 p-6">
          <h3 className="text-yellow-400 font-bold mb-4">สถิติปาร์ตี้</h3>
          <div className="grid grid-cols-2 md:grid-cols-4 gap-4 text-sm">
            <div className="text-center">
              <div className="text-2xl mb-1">👥</div>
              <div className="text-white font-medium">
                {partyMembers.length}
              </div>
              <div className="text-blue-300">สมาชิก</div>
            </div>
            <div className="text-center">
              <div className="text-2xl mb-1">⭐</div>
              <div className="text-white font-medium">
                {Math.round(
                  partyMembers.reduce(
                    (sum: number, member: PartyMember) =>
                      sum + (Number(member.current_stats.level) || 1),
                    0
                  ) / partyMembers.length
                )}
              </div>
              <div className="text-blue-300">เลเวลเฉลี่ย</div>
            </div>
            <div className="text-center">
              <div className="text-2xl mb-1">❤️</div>
              <div className="text-white font-medium">
                {partyMembers.reduce(
                  (sum: number, member: PartyMember) =>
                    sum + (Number(member.current_stats.hp) || 0),
                  0
                )}
              </div>
              <div className="text-blue-300">HP รวม</div>
            </div>
            <div className="text-center">
              <div className="text-2xl mb-1">⚔️</div>
              <div className="text-white font-medium">
                {partyMembers.reduce(
                  (sum: number, member: PartyMember) =>
                    sum + (Number(member.current_stats.attack) || 0),
                  0
                )}
              </div>
              <div className="text-blue-300">พลังโจมตีรวม</div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
