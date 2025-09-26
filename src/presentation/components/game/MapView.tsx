"use client";

import React, { useState, useCallback } from 'react';
import { useGameStore } from '@/src/stores/gameStore';
import { MapDto, MapObjectDto } from "@/src/stores/gameStore";

interface MapViewProps {
  className?: string;
}

export function MapView({ className = "" }: MapViewProps) {
  const {
    currentMap,
    maps,
    mapObjects,
    selectedMapObject,
    loading,
    error,
    setCurrentMap,
    selectMapObject,
    interactWithMapObject,
    isMapUnlocked,
    isMapAccessible
  } = useGameStore();

  const [hoveredMapObject, setHoveredMapObject] = useState<MapObjectDto | null>(null);

  // Get sub-maps for the current map
  const getSubMaps = useCallback(() => {
    if (!currentMap) return [];
    return maps.filter(map => map.parentId === currentMap.id);
  }, [currentMap, maps]);

  // Get map objects for the current map
  const getCurrentMapObjects = useCallback(() => {
    if (!currentMap) return [];
    return mapObjects.filter(obj => obj.mapId === currentMap.id);
  }, [currentMap, mapObjects]);

  // Handle map object click
  const handleMapObjectClick = useCallback((mapObject: MapObjectDto) => {
    if (mapObject.isInteractive) {
      interactWithMapObject(mapObject.id);
    } else {
      selectMapObject(mapObject);
    }
  }, [interactWithMapObject, selectMapObject]);

  // Handle sub-map click
  const handleSubMapClick = useCallback((map: MapDto) => {
    if (isMapUnlocked(map.id) && isMapAccessible(map.id)) {
      setCurrentMap(map.id);
    }
  }, [isMapUnlocked, isMapAccessible, setCurrentMap]);

  if (loading) {
    return (
      <div className={`flex items-center justify-center ${className}`}>
        <div className="text-white text-xl">กำลังโหลดแผนที่...</div>
      </div>
    );
  }

  if (error) {
    return (
      <div className={`flex items-center justify-center ${className}`}>
        <div className="text-red-400 text-xl">เกิดข้อผิดพลาด: {error}</div>
      </div>
    );
  }

  if (!currentMap) {
    return (
      <div className={`flex items-center justify-center ${className}`}>
        <div className="text-white text-xl">ไม่พบแผนที่ปัจจุบัน</div>
      </div>
    );
  }

  const subMaps = getSubMaps();
  const currentMapObjects = getCurrentMapObjects();

  return (
    <div className={`relative w-full h-screen overflow-hidden ${className}`}>
      {/* Map Background */}
      <div className="absolute inset-0 bg-gradient-to-br from-green-800 via-green-600 to-green-400">
        {currentMap.imageUrl && (
          <img
            src={currentMap.imageUrl}
            alt={currentMap.name}
            className="w-full h-full object-cover"
          />
        )}
      </div>

      {/* Map Info Header */}
      <div className="absolute top-4 left-4 right-4 bg-black bg-opacity-50 text-white p-4 rounded-lg">
        <h1 className="text-2xl font-bold mb-2">{currentMap.name}</h1>
        <p className="text-gray-300">{currentMap.description}</p>
      </div>

      {/* Map Objects */}
      {currentMapObjects.map((mapObject) => (
        <div
          key={mapObject.id}
          className={`absolute transform -translate-x-1/2 -translate-y-1/2 cursor-pointer transition-all duration-200 ${
            mapObject.isInteractive 
              ? 'hover:scale-110 hover:z-10' 
              : 'cursor-default'
          } ${
            selectedMapObject?.id === mapObject.id 
              ? 'ring-4 ring-yellow-400 rounded-lg' 
              : ''
          } ${
            hoveredMapObject?.id === mapObject.id 
              ? 'ring-2 ring-blue-400 rounded-lg' 
              : ''
          }`}
          style={{
            left: `${mapObject.positionX || 0}px`,
            top: `${mapObject.positionY || 0}px`,
            width: 40,
            height: 40,
          }}
          onClick={() => handleMapObjectClick(mapObject)}
          onMouseEnter={() => setHoveredMapObject(mapObject)}
          onMouseLeave={() => setHoveredMapObject(null)}
        >
          {/* Map Object Sprite */}
          {mapObject.properties?.spriteUrl ? (
            <img
              src={mapObject.properties.spriteUrl}
              alt={mapObject.name}
              className={`w-full h-full object-cover ${
                mapObject.isInteractive ? 'cursor-pointer' : ''
              }`}
            />
          ) : (
            <div className={`w-full h-full rounded-lg flex items-center justify-center text-xs font-bold ${
              mapObject.objectType === 'sub_map' 
                ? 'bg-blue-600 text-white' 
                : mapObject.objectType === 'npc'
                ? 'bg-purple-600 text-white'
                : mapObject.objectType === 'item'
                ? 'bg-yellow-600 text-white'
                : 'bg-gray-600 text-white'
            }`}>
              {mapObject.name.substring(0, 2)}
            </div>
          )}

          {/* Hover Tooltip */}
          {hoveredMapObject?.id === mapObject.id && (
            <div className="absolute bottom-full left-1/2 transform -translate-x-1/2 mb-2 bg-black bg-opacity-75 text-white text-sm px-2 py-1 rounded whitespace-nowrap z-20">
              {mapObject.name}
              {mapObject.properties?.description && (
                <div className="text-xs text-gray-300">{mapObject.properties.description}</div>
              )}
            </div>
          )}
        </div>
      ))}

      {/* Sub-maps Display */}
      {subMaps.length > 0 && (
        <div className="absolute bottom-4 left-4 right-4 bg-black bg-opacity-50 text-white p-4 rounded-lg">
          <h2 className="text-lg font-bold mb-3">สถานที่ใกล้เคียง</h2>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-3">
            {subMaps.map((subMap) => (
              <div
                key={subMap.id}
                className={`p-3 rounded-lg cursor-pointer transition-all duration-200 ${
                  isMapUnlocked(subMap.id) && isMapAccessible(subMap.id)
                    ? 'bg-green-700 hover:bg-green-600 hover:scale-105'
                    : 'bg-gray-700 cursor-not-allowed opacity-50'
                }`}
                onClick={() => handleSubMapClick(subMap)}
              >
                <h3 className="font-semibold">{subMap.name}</h3>
                <p className="text-xs text-gray-300 mt-1">{subMap.description}</p>
                <div className="text-xs mt-2">
                  {isMapUnlocked(subMap.id) ? (
                    <span className="text-green-400">✓ ปลดล็อกแล้ว</span>
                  ) : (
                    <span className="text-red-400">🔒 ถูกล็อก</span>
                  )}
                </div>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* Selected Map Object Info */}
      {selectedMapObject && (
        <div className="absolute top-20 right-4 bg-black bg-opacity-75 text-white p-4 rounded-lg max-w-xs">
          <h3 className="text-lg font-bold mb-2">{selectedMapObject.name}</h3>
          <p className="text-sm text-gray-300 mb-3">{selectedMapObject.properties?.description}</p>
          <div className="text-xs space-y-1">
            <div><strong>ประเภท:</strong> {selectedMapObject.objectType}</div>
            <div><strong>ตำแหน่ง:</strong> ({selectedMapObject.positionX || 0}, {selectedMapObject.positionY || 0})</div>
            {selectedMapObject.interactionId && (
              <div><strong>ข้อมูลการโต้ตอบ:</strong> {selectedMapObject.interactionId}</div>
            )}
          </div>
          {selectedMapObject.isInteractive && (
            <button
              className="mt-3 w-full bg-blue-600 hover:bg-blue-700 text-white py-2 px-4 rounded text-sm"
              onClick={() => interactWithMapObject(selectedMapObject.id)}
            >
              โต้ตอบ
            </button>
          )}
          <button
            className="mt-2 w-full bg-gray-600 hover:bg-gray-700 text-white py-1 px-4 rounded text-sm"
            onClick={() => selectMapObject(null)}
          >
            ปิด
          </button>
        </div>
      )}

      {/* Navigation Controls */}
      <div className="absolute top-4 right-4 flex flex-col gap-2">
        {maps
          .filter(map => map.parentId === null) // Root maps only
          .map((rootMap) => (
            <button
              key={rootMap.id}
              className={`px-3 py-2 rounded text-sm font-medium transition-all duration-200 ${
                currentMap.id === rootMap.id
                  ? 'bg-blue-600 text-white'
                  : isMapUnlocked(rootMap.id) && isMapAccessible(rootMap.id)
                  ? 'bg-gray-700 text-white hover:bg-gray-600'
                  : 'bg-gray-800 text-gray-400 cursor-not-allowed'
              }`}
              onClick={() => isMapUnlocked(rootMap.id) && isMapAccessible(rootMap.id) && setCurrentMap(rootMap.id)}
              disabled={!isMapUnlocked(rootMap.id) || !isMapAccessible(rootMap.id)}
            >
              {rootMap.name}
            </button>
          ))}
      </div>
    </div>
  );
}
