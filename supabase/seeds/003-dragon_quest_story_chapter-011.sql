-- Dragon Quest XI Story Data Seed - Chapter 11: The Time Paradox
-- Created: 2025-09-26
-- Author: Marosdee Uma
-- Description: Chapter 11 - Post-game content: Time travel to prevent the dark future
-- Features: Basic structure following Dragon Quest XI post-game narrative

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
    ('past-world-region---------------------011', 'Past World', 'โลกในอดีตก่อนที่ Mordegon จะทำลายทุกอย่าง - โอกาสสุดท้ายในการแก้ไขอนาคต', '/images/regions/past_world.svg', '{"completed_events": ["ultimate-sacrifice-evt---------------093"], "game_flags": {"world_saved": true}}', 11, false, true)
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
    ('time-nexus-loc------------------------036', 'Past World', 'Time Nexus', 'จุดเชื่อมต่อเวลาที่สามารถเดินทางข้ามกาลเวลาได้', 'time_portal', '{}', 1, false, false),
    ('past-cobblestone-loc------------------037', 'Past World', 'Past Cobblestone', 'หมู่บ้าน Cobblestone ในอดีตที่ยังไม่ถูกทำลาย', 'village', '{"completed_events": ["final-confrontation-interaction------101"]}', 2, false, true),
    ('altar-time-loc------------------------038', 'Past World', 'Altar of Time', 'แท่นบูชาแห่งเวลาที่สามารถเปลี่ยนแปลงประวัติศาสตร์ได้', 'altar', '{"completed_events": ["save-world-interaction----------------102"]}', 3, false, true)
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
    ('time-paradox-ch----------------------011', 'dragon-quest-xi-act----------------004', 11, 'The Time Paradox', 'การเดินทางกลับไปในอดีตเพื่อป้องกันไม่ให้โลกถูกทำลาย และการค้นพบศัตรูตัวจริง', '{"completed_chapters": ["final-battle-ch----------------------010"], "game_flags": {"world_saved": true}}', 11, false)
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
    ('time-keeper-character-----------------031', 'Time Keeper', 'ผู้พิทักษ์เวลาที่ควบคุมกระแสแห่งกาลเวลา', 'npc', '/images/characters/time_keeper.svg', '{"hp": 400, "mp": 600, "level": 60}', '["Time Control", "Temporal Sight", "Paradox Prevention"]', false, false),
    ('past-gemma-character------------------032', 'Past Gemma', 'Gemma ในอดีตที่ยังไม่รู้เรื่องราวที่จะเกิดขึ้น', 'npc', '/images/characters/past_gemma.svg', '{"hp": 80, "mp": 40, "level": 1}', '[]', false, false),
    ('serenica-character--------------------033', 'Serenica', 'นักเวทสาวจากอดีตที่มีความเชื่อมโยงกับ Serena', 'npc', '/images/characters/serenica.svg', '{"hp": 150, "mp": 250, "level": 35}', '["Time Magic", "Healing Light", "Ancient Wisdom"]', false, false)
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
    ('time-crystal-item---------------------035', 'Time Crystal', 'คริสตัลเวลาที่สามารถเดินทางข้ามกาลเวลาได้', 'key_item', 'legendary', '{}', '{"time_travel": true, "temporal_power": 100}', '/images/items/time_crystal.svg', false),
    ('chronos-blade-item--------------------036', 'Chronos Blade', 'ดาบแห่งกาลเวลาที่มีพลังควบคุมเวลา', 'weapon', 'legendary', '{"attack": 70, "time_power": 40}', '{"time_slash": true, "temporal_strike": 50}', '/images/items/chronos_blade.svg', false),
    ('pendant-memories-item-----------------037', 'Pendant of Memories', 'จี้แห่งความทรงจำที่เก็บรักษาอดีตไว้', 'accessory', 'rare', '{"memory_power": 30, "nostalgia": 20}', '{"memory_preservation": true}', '/images/items/memory_pendant.svg', false)
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
    ('time-portal-opens-evt-----------------101', 'The Time Paradox', 'Time Nexus', 'The Time Portal Opens', 'การเปิดประตูเวลาเพื่อเดินทางกลับไปในอดีต', 'time_travel', '{"completed_chapters": ["final-battle-ch----------------------010"]}', 1, false),
    ('return-to-past-evt--------------------102', 'The Time Paradox', 'Past Cobblestone', 'Return to the Past', 'การกลับไปยังหมู่บ้าน Cobblestone ในอดีต', 'exploration', '{"completed_events": ["time-portal-opens-evt-----------------101"]}', 2, false),
    ('difficult-choice-evt------------------103', 'The Time Paradox', 'Altar of Time', 'The Difficult Choice', 'การเลือกระหว่างการช่วยเหลือเพื่อนและการกอบกู้โลก', 'choice', '{"completed_events": ["return-to-past-evt--------------------102"]}', 3, false)
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
    ('speak-time-keeper-interaction---------110', 'The Time Portal Opens', 'talk', 'Speak with Time Keeper', 'พูดคุยกับผู้พิทักษ์เวลา', 'Luminary... เจ้าได้กอบกู้โลกแล้ว แต่ยังมีทางเลือกหนึ่งที่เหลืออยู่... เจ้าสามารถเดินทางกลับไปในอดีตเพื่อป้องกันไม่ให้โศกนาฏกรรมเกิดขึ้น', 'Time Keeper', '[{"id": "accept", "text": "ผมจะกลับไปแก้ไขอดีต", "type": "heroic"}, {"id": "hesitate", "text": "การเปลี่ยนแปลงอดีตอันตรายไหม?", "type": "cautious"}]', '{}', 1),
    ('observe-past-world-interaction--------111', 'Return to the Past', 'examine', 'Observe Past World', 'สำรวจโลกในอดีตที่ยังไม่ถูกทำลาย', 'โลกในอดีตนี้สวยงามและเงียบสงบ... ทุกอย่างยังคงอยู่ในสภาพเดิม ก่อนที่ Mordegon จะทำลายทุกสิ่ง', 'Narrator', '[]', '{}', 1),
    ('meet-past-gemma-interaction------------112', 'Return to the Past', 'talk', 'Meet Past Gemma', 'พบกับ Gemma ในอดีต', 'Luminary! เธอกลับมาแล้ว! ฉันรอเธอมานานแล้ว... แต่เธอดูแปลกไปจากเดิม มีอะไรเกิดขึ้นหรือเปล่า?', 'Past Gemma', '[{"id": "truth", "text": "เล่าความจริงให้ฟัง", "type": "honest"}, {"id": "lie", "text": "ไม่มีอะไร ผมสบายดี", "type": "protective"}]', '{}', 2),
    ('ultimate-decision-interaction---------113', 'The Difficult Choice', 'choice', 'Make the Ultimate Decision', 'ตัดสินใจครั้งสุดท้าย', 'ที่แท่นบูชาแห่งเวลา... Luminary ต้องเลือกระหว่างการช่วยเหลือเพื่อนๆ หรือการป้องกันไม่ให้โลกถูกทำลาย... ทั้งสองทางไม่สามารถทำได้พร้อมกัน', 'Serenica', '[{"id": "save_friends", "text": "ช่วยเพื่อนๆ ก่อน", "type": "friendship"}, {"id": "save_world", "text": "ป้องกันโลกจากการถูกทำลาย", "type": "sacrifice"}]', '{}', 1)
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
    ('time-travel-begins-outcome-------------110', 'Speak with Time Keeper', 'accept', 'story', 'Time Travel Begins', 'Luminary ยอมรับการเดินทางข้ามเวลา! ประตูเวลาเปิดขึ้น...', '{"experience": 300, "items": [{"code": "time-crystal-item---------------------035", "quantity": 1}]}', 'Return to the Past'),
    ('understanding-risk-outcome------------111', 'Speak with Time Keeper', 'hesitate', 'story', 'Understanding the Risk', 'Time Keeper อธิบายความเสี่ยง "การเปลี่ยนแปลงอดีตมีความเสี่ยง แต่นี่คือโอกาสเดียว"', '{"experience": 200}', 'Return to the Past'),
    ('painful-truth-outcome-----------------112', 'Meet Past Gemma', 'truth', 'story', 'Painful Truth', 'Luminary เล่าความจริงให้ Gemma ฟัง... เธอตกใจแต่เข้าใจและให้กำลังใจ', '{"experience": 250, "relationship": {"past_gemma": 20}}', 'The Difficult Choice'),
    ('protective-lie-outcome-----------------113', 'Meet Past Gemma', 'lie', 'story', 'Protective Lie', 'Luminary ปกป้อง Gemma จากความจริงที่เจ็บปวด', '{"experience": 150, "relationship": {"past_gemma": 10}}', 'The Difficult Choice'),
    ('friendship-chosen-outcome--------------114', 'Make the Ultimate Decision', 'save_friends', 'story', 'Friendship Chosen', 'Luminary เลือกช่วยเพื่อนๆ... แต่โลกยังคงเสี่ยงต่อการถูกทำลาย', '{"experience": 400, "items": [{"code": "pendant-memories-item-----------------037", "quantity": 1}], "unlock_regions": ["future-world-rg----------------------012"]}', null),
    ('world-protection-outcome--------------115', 'Make the Ultimate Decision', 'save_world', 'story', 'World Protection', 'Luminary เลือกป้องกันโลก... การเสียสละที่ยิ่งใหญ่เพื่อทุกคน', '{"experience": 500, "items": [{"code": "chronos-blade-item--------------------036", "quantity": 1}], "unlock_regions": ["future-world-rg----------------------012"]}', null)
) AS outcome_info(code, interaction_title, choice_key, outcome_type, title, description, effects, next_event_title)
LEFT JOIN story_events se_next ON se_next.title = outcome_info.next_event_title
WHERE ei.title = outcome_info.interaction_title;
