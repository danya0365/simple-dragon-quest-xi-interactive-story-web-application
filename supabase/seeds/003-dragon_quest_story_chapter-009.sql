-- Dragon Quest XI Story Data Seed - Chapter 9: The World Tree
-- Created: 2025-09-26
-- Author: Marosdee Uma
-- Description: Chapter 9 - The journey to Yggdrasil, the World Tree
-- Features: Basic structure following Dragon Quest XI narrative

-- === WORLD REGIONS ===
INSERT INTO public.world_regions (id, code, name, description, image_url, unlock_requirements, display_order, is_initial_user_progress, is_alway_hide_until_unlock)
SELECT 
  uuid_generate_v5(uuid_nil(), region_info.code),
  region_info.code,
  region_info.name,
  region_info.description,
  region_info.image_url,
  region_info.unlock_requirements::jsonb,
  region_info.display_order,
  region_info.is_initial_user_progress,
  region_info.is_alway_hide_until_unlock
FROM (
  VALUES 
    ('yggdrasil-region-------------------009', 'Yggdrasil', 'ต้นไม้แห่งโลกที่ยิ่งใหญ่และเป็นศูนย์กลางของพลังชีวิต', '/images/regions/yggdrasil.svg', '{"completed_events": ["journey-through-ice-evt-------------072"]}', 9, false, true)
) AS region_info(code, name, description, image_url, unlock_requirements, display_order, is_initial_user_progress, is_alway_hide_until_unlock);

-- === LOCATIONS ===
INSERT INTO public.locations (id, code, world_region_id, name, description, location_type, unlock_requirements, display_order, is_initial_user_progress, is_alway_hide_until_unlock)
SELECT 
  uuid_generate_v5(uuid_nil(), location_info.code),
  location_info.code,
  wr.id AS world_region_id,
  location_info.name,
  location_info.description,
  location_info.location_type,
  location_info.unlock_requirements::jsonb,
  location_info.display_order,
  location_info.is_initial_user_progress,
  location_info.is_alway_hide_until_unlock
FROM world_regions wr
CROSS JOIN (
  VALUES 
    ('tree-base-loc----------------------030', 'Yggdrasil', 'Tree Base', 'โคนต้นไม้แห่งโลกที่ใหญ่โตมหาศาล', 'tree_base', '{}', 1, false, false),
    ('tree-crown-loc---------------------031', 'Yggdrasil', 'Tree Crown', 'ยอดต้นไม้ที่สูงถึงฟ้าและเต็มไปด้วยแสงศักดิ์สิทธิ์', 'tree_crown', '{"completed_events": ["approaching-yggdrasil-evt----------081"]}', 2, false, true),
    ('heart-of-tree-loc------------------032', 'Yggdrasil', 'Heart of the Tree', 'หัวใจของต้นไม้แห่งโลกที่เป็นแหล่งพลังชีวิต', 'sacred_core', '{"completed_events": ["spirits-blessing-evt--------------082"]}', 3, false, true)
) AS location_info(code, region_name, name, description, location_type, unlock_requirements, display_order, is_initial_user_progress, is_alway_hide_until_unlock)
WHERE wr.name = location_info.region_name;

-- === STORY CHAPTERS ===
INSERT INTO public.story_chapters (id, code, act_id, chapter_number, title, description, unlock_requirements, display_order, is_initial_user_progress)
SELECT 
  uuid_generate_v5(uuid_nil(), chapter_info.code),
  chapter_info.code,
  sa.id AS act_id,
  chapter_info.chapter_number,
  chapter_info.title,
  chapter_info.description,
  chapter_info.unlock_requirements::jsonb,
  chapter_info.display_order,
  chapter_info.is_initial_user_progress
FROM story_acts sa
CROSS JOIN (
  VALUES 
    ('world-tree-ch-----------------------009', 'dragon-quest-xi-act----------------003', 9, 'The World Tree', 'การเดินทางสู่ Yggdrasil ต้นไม้แห่งโลกและการเตรียมพร้อมสำหรับการต่อสู้ครั้งสุดท้าย', '{"completed_chapters": ["frozen-citadel-ch-------------------008"]}', 9, false)
) AS chapter_info(code, act_code, chapter_number, title, description, unlock_requirements, display_order, is_initial_user_progress)
WHERE sa.code = chapter_info.act_code;

-- === CHARACTERS ===
INSERT INTO public.characters (id, code, name, description, character_type, avatar_url, stats, abilities, is_joinable, is_initial_user_progress)
SELECT 
  uuid_generate_v5(uuid_nil(), character_info.code),
  character_info.code,
  character_info.name,
  character_info.description,
  character_info.character_type,
  character_info.avatar_url,
  character_info.stats::jsonb,
  character_info.abilities::jsonb,
  character_info.is_joinable,
  character_info.is_initial_user_progress
FROM (
  VALUES 
    ('yggdrasil-spirit-character----------025', 'Yggdrasil Spirit', 'วิญญาณของต้นไม้แห่งโลกที่ปกป้องความสมดุลของธรรมชาติ', 'npc', '/images/characters/yggdrasil_spirit.svg', '{"hp": 500, "mp": 500, "level": 60}', '["Life Force", "World Blessing", "Nature''s Wrath"]', false, false),
    ('mordegon-character------------------026', 'Mordegon', 'ลอร์ดแห่งความมืดผู้เป็นศัตรูตัวฉกาจของ Luminary', 'npc', '/images/characters/mordegon.svg', '{"hp": 800, "mp": 600, "level": 70}', '["Dark Magic", "Shadow Storm", "Despair"]', false, false),
    ('tree-guardian-character--------------027', 'Tree Guardian', 'ผู้พิทักษ์ต้นไม้ที่ปกป้องความศักดิ์สิทธิ์', 'npc', '/images/characters/tree_guardian.svg', '{"hp": 250, "mp": 200, "level": 30}', '["Nature Shield", "Root Bind"]', false, false)
) AS character_info(code, name, description, character_type, avatar_url, stats, abilities, is_joinable, is_initial_user_progress);

-- === ITEMS ===
INSERT INTO public.items (id, code, name, description, item_type, rarity, stats, effects, image_url, is_initial_user_progress)
SELECT 
  uuid_generate_v5(uuid_nil(), item_info.code),
  item_info.code,
  item_info.name,
  item_info.description,
  item_info.item_type,
  item_info.rarity,
  item_info.stats::jsonb,
  item_info.effects::jsonb,
  item_info.image_url,
  item_info.is_initial_user_progress
FROM (
  VALUES 
    ('sword-of-light-item-----------------029', 'Sword of Light', 'ดาบแห่งแสงสว่างที่เป็นอาวุธสุดท้ายของ Luminary', 'weapon', 'legendary', '{"attack": 60, "light_power": 50, "holy_damage": 40}', '{"ultimate_weapon": true}', '/images/items/sword_of_light.svg', false),
    ('seed-of-yggdrasil-item--------------030', 'Seed of Yggdrasil', 'เมล็ดของต้นไม้แห่งโลกที่มีพลังสร้างชีวิต', 'key_item', 'legendary', '{}', '{"life_creation": true, "world_restoration": true}', '/images/items/yggdrasil_seed.svg', false),
    ('crown-of-luminary-item--------------031', 'Crown of the Luminary', 'มงกุฎของ Luminary ที่แสดงถึงความเป็นผู้นำแสงสว่าง', 'accessory', 'legendary', '{"all_stats": 20, "light_power": 30}', '{"luminary_crown": true}', '/images/items/luminary_crown.svg', false)
) AS item_info(code, name, description, item_type, rarity, stats, effects, image_url, is_initial_user_progress);

-- === STORY EVENTS ===
INSERT INTO public.story_events (id, code, chapter_id, location_id, title, description, event_type, unlock_requirements, display_order, is_initial_user_progress)
SELECT 
  uuid_generate_v5(uuid_nil(), event_info.code),
  event_info.code,
  sc.id AS chapter_id,
  l.id AS location_id,
  event_info.title,
  event_info.description,
  event_info.event_type,
  event_info.unlock_requirements::jsonb,
  event_info.display_order,
  event_info.is_initial_user_progress
FROM story_chapters sc
JOIN locations l ON 1=1
CROSS JOIN (
  VALUES 
    ('approaching-yggdrasil-evt----------081', 'The World Tree', 'Tree Base', 'Approaching Yggdrasil', 'การเข้าใกล้ต้นไม้แห่งโลกที่ยิ่งใหญ่', 'exploration', '{"completed_chapters": ["frozen-citadel-ch-------------------008"]}', 1, false),
    ('spirits-blessing-evt--------------082', 'The World Tree', 'Tree Crown', 'The Spirit''s Blessing', 'การได้รับพรจากวิญญาณของต้นไม้แห่งโลก', 'blessing', '{"completed_events": ["approaching-yggdrasil-evt----------081"]}', 2, false),
    ('final-preparation-evt--------------083', 'The World Tree', 'Heart of the Tree', 'The Final Preparation', 'การเตรียมพร้อมสำหรับการต่อสู้ครั้งสุดท้าย', 'preparation', '{"completed_events": ["spirits-blessing-evt--------------082"]}', 3, false)
) AS event_info(code, chapter_name, location_name, title, description, event_type, unlock_requirements, display_order, is_initial_user_progress)
WHERE sc.title = event_info.chapter_name
AND l.name = event_info.location_name;

-- === EVENT INTERACTIONS ===
INSERT INTO public.event_interactions (id, code, event_id, interaction_type, title, description, dialogue_text, character_speaker, choices, requirements, display_order)
SELECT 
  uuid_generate_v5(uuid_nil(), interaction_info.code),
  interaction_info.code,
  se.id AS event_id,
  interaction_info.interaction_type,
  interaction_info.title,
  interaction_info.description,
  interaction_info.dialogue_text,
  interaction_info.character_speaker,
  interaction_info.choices::jsonb,
  interaction_info.requirements::jsonb,
  interaction_info.display_order
FROM story_events se
CROSS JOIN (
  VALUES 
    ('marvel-at-tree-int-----------------090', 'Approaching Yggdrasil', 'examine', 'Marvel at the Tree', 'ชื่นชมความยิ่งใหญ่ของต้นไม้แห่งโลก', 'ต้นไม้แห่งโลก Yggdrasil ใหญ่โตเหลือเกิน! ความสูงของมันเสียดฟ้า และมีแสงศักดิ์สิทธิ์ส่องออกมา', 'Narrator', '[]', '{}', 1),
    ('speak-with-spirit-int--------------091', 'The Spirit''s Blessing', 'talk', 'Speak with Spirit', 'พูดคุยกับวิญญาณของต้นไม้แห่งโลก', 'Luminary... เจ้าได้มาถึงที่นี่แล้ว เวลาแห่งการต่อสู้ครั้งสุดท้ายใกล้เข้ามาแล้ว', 'Yggdrasil Spirit', '[{"id": "ready", "text": "ผมพร้อมแล้ว", "type": "determined"}, {"id": "blessing", "text": "ขอพรจากท่าน", "type": "humble"}]', '{}', 1),
    ('forge-ultimate-weapon-int----------092', 'The Final Preparation', 'preparation', 'Forge the Ultimate Weapon', 'สร้างอาวุธสุดท้ายสำหรับการต่อสู้', 'ด้วยพลังของต้นไม้แห่งโลก... ดาบแห่งแสงสว่างได้ถือกำเนิดขึ้น!', 'Yggdrasil Spirit', '[{"id": "accept", "text": "รับดาบแห่งแสงสว่าง", "type": "heroic"}]', '{}', 1)
) AS interaction_info(code, event_name, interaction_type, title, description, dialogue_text, character_speaker, choices, requirements, display_order)
WHERE se.title = interaction_info.event_name;

-- === EVENT OUTCOMES ===
INSERT INTO public.event_outcomes (id, code, interaction_id, choice_key, outcome_type, title, description, effects, next_event_id)
SELECT 
  uuid_generate_v5(uuid_nil(), outcome_info.code),
  outcome_info.code,
  ei.id AS interaction_id,
  outcome_info.choice_key,
  outcome_info.outcome_type,
  outcome_info.title,
  outcome_info.description,
  outcome_info.effects::jsonb,
  se_next.id AS next_event_id
FROM event_interactions ei
CROSS JOIN (
  VALUES 
    ('determination-acknowledged-out-------090', 'Speak with Spirit', 'ready', 'story', 'Determination Acknowledged', 'วิญญาณของต้นไม้ประทับใจในความมุ่งมั่นของ Luminary', '{"experience": 300, "relationship": {"yggdrasil_spirit": 20}}', 'The Final Preparation'),
    ('divine-blessing-received-out---------091', 'Speak with Spirit', 'blessing', 'blessing', 'Divine Blessing Received', 'Luminary ได้รับพรศักดิ์สิทธิ์จากต้นไม้แห่งโลก', '{"experience": 400, "items": [{"code": "crown-of-luminary-item--------------031", "quantity": 1}], "relationship": {"yggdrasil_spirit": 25}}', 'The Final Preparation'),
    ('ultimate-power-achieved-out----------092', 'Forge the Ultimate Weapon', 'accept', 'unlock', 'Ultimate Power Achieved', 'Luminary ได้รับดาบแห่งแสงสว่างและพร้อมสำหรับการต่อสู้ครั้งสุดท้าย', '{"experience": 500, "items": [{"code": "sword-of-light-item-----------------029", "quantity": 1}, {"code": "seed-of-yggdrasil-item--------------030", "quantity": 1}], "unlock_regions": ["yggdrasil-region-------------------010"]}', null)
) AS outcome_info(code, interaction_title, choice_key, outcome_type, title, description, effects, next_event_title)
LEFT JOIN story_events se_next ON se_next.title = outcome_info.next_event_title
WHERE ei.title = outcome_info.interaction_title;
