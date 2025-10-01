-- Dragon Quest XI Story Data Seed - Chapter 12: The True Enemy
-- Created: 2025-09-26
-- Author: Marosdee Uma
-- Description: Chapter 12 - The revelation of Calasmos as the true enemy behind everything
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
    ('void-beyond-time-rg-------------------012', 'Void Beyond Time', 'มิติแห่งความว่างเปล่าที่อยู่เหนือกาลเวลา ที่อยู่ของ Calasmos ผู้เป็นต้นกำเนิดแห่งความมืด', '/images/regions/void_beyond_time.svg', '{"completed_events": ["difficult-choice-evt------------------103"]}', 12, false, true)
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
    ('dimensional-rift-location---------------039', 'Void Beyond Time', 'Dimensional Rift', 'รอยแยกมิติที่นำไปสู่ที่อยู่ของ Calasmos', 'dimensional_gate', '{}', 1, false, false),
    ('calasmos-sanctum-location--------------040', 'Void Beyond Time', 'Calasmos Sanctum', 'สถานที่ศักดิ์สิทธิ์ของ Calasmos ที่เต็มไปด้วยพลังมืดบริสุทธิ์', 'sanctum', '{"completed_events": ["observe-past-world-interaction--------111"]}', 2, false, true),
    ('core-darkness-location-----------------041', 'Void Beyond Time', 'Core of Darkness', 'แก่นแท้แห่งความมืดที่เป็นแหล่งกำเนิดของความชั่วร้ายทั้งหมด', 'dark_core', '{"completed_events": ["meet-past-gemma-interaction------------112"]}', 3, false, true)
) AS location_info(code, region_name, name, description, location_type, unlock_requirements, display_order, is_initial_user_progress, is_alway_hide_until_unlock)
WHERE wr.name = location_info.region_name;

-- === STORY CHAPTERS ===
INSERT INTO public.story_chapters (id, code, chapter_number, title, description, unlock_requirements, display_order, is_initial_user_progress, act_id)
SELECT 
  uuid_generate_v5(uuid_nil(), chapter_info.code),
  chapter_info.code,
  chapter_info.chapter_number,
  chapter_info.title,
  chapter_info.description,
  chapter_info.unlock_requirements::jsonb,
  chapter_info.display_order,
  chapter_info.is_initial_user_progress,
  sa.id AS act_id
FROM (
  VALUES 
    ('true-enemy-ch------------------------012', 12, 'The True Enemy', 'การเปิดเผยว่า Calasmos คือศัตรูตัวจริงที่อยู่เบื้องหลัง Mordegon และการต่อสู้ครั้งสุดท้ายที่แท้จริง', '{"completed_chapters": ["time-paradox-ch-----------------------011"]}', 12, false, 'post-game-act-------------------------004')
) AS chapter_info(code, chapter_number, title, description, unlock_requirements, display_order, is_initial_user_progress, act_code)
JOIN story_acts sa ON sa.code = chapter_info.act_code;

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
    ('calasmos-character---------------------034', 'Calasmos', 'ปีศาจแห่งความมืดที่แท้จริง ผู้เป็นต้นกำเนิดของความชั่วร้ายทั้งหมดในโลก', 'final_boss', '/images/characters/calasmos.svg', '{"hp": 2000, "mp": 1000, "level": 99}', '["Absolute Darkness", "Reality Destroyer", "Void Incarnate", "Despair Eternal"]', false, false),
    ('void-sentinel-character----------------035', 'Void Sentinel', 'ผู้พิทักษ์แห่งความว่างเปล่าที่รับใช้ Calasmos', 'boss', '/images/characters/void_sentinel.svg', '{"hp": 800, "mp": 400, "level": 60}', '["Void Strike", "Dimensional Tear", "Nothingness"]', false, false),
    ('echo-erdwin-character------------------036', 'Echo of Erdwin', 'เงาของ Erdwin ผู้เป็น Luminary คนแรก', 'ally', '/images/characters/echo_erdwin.svg', '{"hp": 500, "mp": 600, "level": 80}', '["Ancient Light", "Luminary Legacy", "Hope Eternal"]', false, false)
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
    ('supreme-sword-light-item--------------038', 'Supreme Sword of Light', 'ดาบแสงสว่างสูงสุดที่มีพลังเหนือกว่าดาบแห่งแสงธรรมดา', 'weapon', 'legendary', '{"attack": 99, "light_power": 99, "holy_damage": 99}', '{"supreme_light": true, "calasmos_bane": true}', '/images/items/supreme_light_sword.svg', false),
    ('erdwin-lantern-item--------------------039', 'Erdwin''s Lantern', 'โคมไฟของ Erdwin ที่ส่องแสงในความมืดมิด', 'key_item', 'legendary', '{}', '{"eternal_light": true, "darkness_banisher": true, "hope_beacon": true}', '/images/items/erdwin_lantern.svg', false),
    ('calasmos-fragment-item-----------------040', 'Calasmos Fragment', 'เศษชิ้นส่วนของ Calasmos ที่มีพลังมืดอันน่าสะพรึงกลัว', 'key_item', 'legendary', '{}', '{"ultimate_darkness": true, "void_power": 100}', '/images/items/calasmos_fragment.svg', false)
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
    ('truth-revealed-evt-------------------111', 'The True Enemy', 'Dimensional Rift', 'The Truth Revealed', 'การเปิดเผยความจริงเกี่ยวกับ Calasmos', 'revelation', '{"completed_chapters": ["time-paradox-ch-----------------------011"]}', 1, false),
    ('confronting-void-evt-----------------112', 'The True Enemy', 'Calasmos Sanctum', 'Confronting the Void', 'การเผชิญหน้ากับ Calasmos ในสถานที่ศักดิ์สิทธิ์', 'boss_battle', '{"completed_events": ["truth-revealed-evt-------------------111"]}', 2, false),
    ('final-light-evt----------------------113', 'The True Enemy', 'Core of Darkness', 'The Final Light', 'การใช้แสงสว่างสุดท้ายเพื่อขับไล่ความมืดมิด', 'ultimate_battle', '{"completed_events": ["confronting-void-evt-----------------112"]}', 3, false)
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
    ('learn-truth-interaction-----------------120', 'The Truth Revealed', 'revelation', 'Learn the Truth', 'เรียนรู้ความจริงเกี่ยวกับ Calasmos', 'ความจริงที่น่าสะพรึงกลัว... Mordegon เป็นเพียงหุ่นเชิด! Calasmos คือผู้ที่อยู่เบื้องหลังทุกอย่าง! มันคือต้นกำเนิดแห่งความมืดที่แท้จริง!', 'Echo of Erdwin', '[{"id": "shocked", "text": "ไม่อาจเป็นไปได้!", "type": "shocked"}, {"id": "determined", "text": "งั้นเราต้องหยุดมัน!", "type": "determined"}]', '{}', 1),
    ('face-calasmos-interaction--------------121', 'Confronting the Void', 'boss_battle', 'Face Calasmos', 'เผชิญหน้ากับ Calasmos', 'ในที่สุด... Luminary ผู้น่าสมเพช... เจ้าคิดว่าเจ้าจะสามารถหยุดข้าได้หรือ? ข้าคือความมืดนิรันดร์! ข้าคือความว่างเปล่าที่จะกลืนกินทุกสิ่ง!', 'Calasmos', '[{"id": "fight", "text": "ผมจะหยุดคุณให้ได้!", "type": "heroic"}, {"id": "light", "text": "แสงสว่างจะเอาชนะความมืด!", "type": "hopeful"}]', '{}', 1),
    ('ultimate-sacrifice-interaction---------122', 'The Final Light', 'ultimate_battle', 'Ultimate Sacrifice', 'การเสียสละครั้งสุดท้าย', 'เพื่อขับไล่ Calasmos... Luminary ต้องใช้พลังแสงสว่างทั้งหมด... แม้ว่าจะต้องเสียสละชีวิตตัวเอง...', 'Narrator', '[{"id": "sacrifice", "text": "เพื่อทุกคน... ผมยอม!", "type": "ultimate_sacrifice"}]', '{}', 1)
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
    ('overwhelming-truth-outcome-------------120', 'Learn the Truth', 'shocked', 'story', 'Overwhelming Truth', 'ความจริงที่น่าตกใจทำให้ Luminary สั่นคลอน แต่ก็เพิ่มความมุ่งมั่น', '{"experience": 400}', 'Confronting the Void'),
    ('unwavering-resolve-outcome-------------121', 'Learn the Truth', 'determined', 'story', 'Unwavering Resolve', 'ความมุ่งมั่นของ Luminary แข็งแกร่งขึ้น พร้อมเผชิญหน้ากับความมืดที่แท้จริง', '{"experience": 500, "items": [{"code": "erdwin-lantern-item--------------------039", "quantity": 1}]}', 'Confronting the Void'),
    ('battle-void-outcome-------------------122', 'Face Calasmos', 'fight', 'story', 'Battle Against Void', 'การต่อสู้ที่ยากลำบากที่สุดเริ่มต้นขึ้น! Calasmos แสดงพลังที่น่าสะพรึงกลัว', '{"experience": 600}', 'The Final Light'),
    ('light-darkness-outcome----------------123', 'Face Calasmos', 'light', 'story', 'Light vs Darkness', 'แสงสว่างและความมืดปะทะกัน! พลังของ Luminary เริ่มส่องแสง', '{"experience": 700, "items": [{"code": "supreme-sword-light-item--------------038", "quantity": 1}]}', 'The Final Light'),
    ('darkness-banished-outcome--------------124', 'Ultimate Sacrifice', 'sacrifice', 'ending', 'Darkness Banished Forever', 'ด้วยการเสียสละครั้งสุดท้าย Luminary ขับไล่ Calasmos ไปตลอดกาล! แสงสว่างกลับคืนสู่โลก และความมืดถูกขับไล่ไปตลอดกาล!', '{"experience": 2000, "items": [{"code": "calasmos-fragment-item-----------------040", "quantity": 1}], "game_flags": {"calasmos_defeated": true, "true_ending": true}, "unlock_regions": ["post-game-rg-------------------------013"]}', null)
) AS outcome_info(code, interaction_title, choice_key, outcome_type, title, description, effects, next_event_title)
LEFT JOIN story_events se_next ON se_next.title = outcome_info.next_event_title
WHERE ei.title = outcome_info.interaction_title;
