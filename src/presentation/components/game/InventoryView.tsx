"use client";

import { useGameStore } from "@/src/stores/gameStore";
import { useAuthStore } from "@/src/stores/authStore";

interface InventoryItem {
  item_id: string;
  name: string;
  description: string;
  item_type: string;
  rarity: string;
  image_url: string;
  quantity: number;
  obtained_at: string;
}

export function InventoryView() {
  const { user } = useAuthStore();
  const { userGameState, loading, error } = useGameStore();

  const inventory = userGameState?.inventory || [];

  const getRarityColor = (rarity: string) => {
    switch (rarity.toLowerCase()) {
      case 'common': return 'text-gray-300 border-gray-500';
      case 'uncommon': return 'text-green-300 border-green-500';
      case 'rare': return 'text-blue-300 border-blue-500';
      case 'epic': return 'text-purple-300 border-purple-500';
      case 'legendary': return 'text-yellow-300 border-yellow-500';
      default: return 'text-gray-300 border-gray-500';
    }
  };

  const getItemTypeIcon = (type: string) => {
    switch (type.toLowerCase()) {
      case 'weapon': return '⚔️';
      case 'armor': return '🛡️';
      case 'accessory': return '💍';
      case 'consumable': return '🧪';
      case 'material': return '🔧';
      case 'key_item': return '🗝️';
      default: return '📦';
    }
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center min-h-[400px]">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-yellow-400 mx-auto mb-4"></div>
          <p className="text-blue-200">กำลังโหลดกระเป๋า...</p>
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
          🎒 กระเป๋า
        </h2>
        <p className="text-blue-200">
          ไอเทมทั้งหมด: {inventory.length} รายการ
        </p>
      </div>

      {/* Inventory Grid */}
      {inventory.length === 0 ? (
        <div className="text-center py-8 lg:py-12">
          <div className="text-blue-400 text-4xl lg:text-6xl mb-4">📦</div>
          <p className="text-blue-200 font-medium mb-2">กระเป๋าว่างเปล่า</p>
          <p className="text-blue-300 text-sm lg:text-base">
            เริ่มต้นการผจญภัยเพื่อรวบรวมไอเทม!
          </p>
        </div>
      ) : (
        <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-4 xl:grid-cols-5 gap-3 lg:gap-4">
          {inventory.map((item: InventoryItem) => (
            <div
              key={item.item_id}
              className={`
                bg-white/10 backdrop-blur-md rounded-lg border-2 p-4 
                transition-all duration-200 hover:bg-white/15 hover:scale-105
                ${getRarityColor(item.rarity)}
              `}
            >
              {/* Item Header */}
              <div className="flex items-center justify-between mb-3">
                <div className="flex items-center space-x-2">
                  <span className="text-2xl">{getItemTypeIcon(item.item_type)}</span>
                  <div className="text-xs px-2 py-1 rounded-full bg-black/30">
                    {item.item_type}
                  </div>
                </div>
                {item.quantity > 1 && (
                  <div className="bg-yellow-500/20 text-yellow-300 text-xs px-2 py-1 rounded-full font-bold">
                    x{item.quantity}
                  </div>
                )}
              </div>

              {/* Item Image */}
              {item.image_url && (
                <div className="w-full h-24 bg-black/20 rounded-lg mb-3 flex items-center justify-center overflow-hidden">
                  <img
                    src={item.image_url}
                    alt={item.name}
                    className="max-w-full max-h-full object-contain"
                  />
                </div>
              )}

              {/* Item Info */}
              <div className="space-y-2">
                <h3 className="text-white font-bold text-sm line-clamp-2">
                  {item.name}
                </h3>
                <p className="text-blue-200 text-xs line-clamp-3">
                  {item.description}
                </p>
                
                {/* Rarity Badge */}
                <div className="flex items-center justify-between">
                  <div className={`text-xs px-2 py-1 rounded-full border ${getRarityColor(item.rarity)}`}>
                    {item.rarity}
                  </div>
                  <div className="text-xs text-blue-300">
                    {new Date(item.obtained_at).toLocaleDateString('th-TH')}
                  </div>
                </div>
              </div>
            </div>
          ))}
        </div>
      )}

      {/* Inventory Stats */}
      {inventory.length > 0 && (
        <div className="bg-blue-900/30 rounded-lg border border-blue-500/30 p-6">
          <h3 className="text-yellow-400 font-bold mb-4">สถิติกระเป๋า</h3>
          <div className="grid grid-cols-2 md:grid-cols-4 gap-4 text-sm">
            <div className="text-center">
              <div className="text-2xl mb-1">⚔️</div>
              <div className="text-white font-medium">
                {inventory.filter(item => item.item_type === 'weapon').length}
              </div>
              <div className="text-blue-300">อาวุธ</div>
            </div>
            <div className="text-center">
              <div className="text-2xl mb-1">🛡️</div>
              <div className="text-white font-medium">
                {inventory.filter(item => item.item_type === 'armor').length}
              </div>
              <div className="text-blue-300">เกราะ</div>
            </div>
            <div className="text-center">
              <div className="text-2xl mb-1">🧪</div>
              <div className="text-white font-medium">
                {inventory.filter(item => item.item_type === 'consumable').length}
              </div>
              <div className="text-blue-300">ยา</div>
            </div>
            <div className="text-center">
              <div className="text-2xl mb-1">🔧</div>
              <div className="text-white font-medium">
                {inventory.filter(item => item.item_type === 'material').length}
              </div>
              <div className="text-blue-300">วัสดุ</div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
