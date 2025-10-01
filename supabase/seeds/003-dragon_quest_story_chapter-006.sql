-- Dragon Quest XI Story Data Seed - Chapter 6: The Sage's Trial
-- Created: 2025-09-26
-- Author: Marosdee Uma
-- Description: Chapter 6 - The journey to Arboria and meeting the Sage
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
    ('arboria-region---------------------006', 'Arboria', 'ป่าโบราณที่เต็มไปด้วยต้นไม้ยักษ์และพลังเวทมนตร์', '/images/regions/arboria.svg', '{"completed_events": ["beach-encounter-evt----------------043"]}', 6, false, true)
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
    ('forest-entrance-loc----------------021', 'Arboria', 'Forest Entrance', 'ทางเข้าป่าโบราณที่มีต้นไม้ใหญ่ยักษ์', 'forest', '{}', 1, false, false),
    ('sacred-grove-loc-------------------022', 'Arboria', 'Sacred Grove', 'ป่าศักดิ์สิทธิ์ที่มีพลังเวทมนตร์โบราณ', 'sacred_site', '{"completed_events": ["sacred-trial-evt----------------052"]}', 2, false, true),
    ('sage-dwelling-loc------------------023', 'Arboria', 'Sage''s Dwelling', 'ที่อยู่ของ Sage ผู้ปราชญ์', 'dwelling', '{"completed_events": ["meeting-sage-evt----------------053"]}', 3, false, true)
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
FROM (
  VALUES 
    ('dragon-quest-xi-ch-----------------006', 6, 'The Sage''s Trial', 'การเดินทางสู่ Arboria เพื่อพบกับ Sage และเรียนรู้ความจริงเกี่ยวกับ Luminary', '{"completed_chapters": ["dragon-quest-xi-ch-----------------005"]}', 6, false, 'dragon-quest-xi-act-----------------002')
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
    ('sage-char--------------------------016', 'Sage', 'ปราชญ์ผู้รู้ความจริงเกี่ยวกับ Luminary และโลกโบราณ', 'npc', '/images/characters/sage.svg', '{"hp": 300, "mp": 400, "level": 50}', '["Ancient Wisdom", "Time Magic", "Truth Sight"]', false, false),
    ('rab-char---------------------------017', 'Rab', 'อาจารย์ของ Luminary ผู้มีความรู้ลึกซึ้งเกี่ยวกับโลก', 'party_member', '/images/characters/rab.svg', '{"hp": 120, "mp": 200, "level": 1, "attack": 12, "defense": 18, "agility": 8, "luck": 25}', '["Wisdom", "Ancient Knowledge", "Heal"]', true, false),
    ('forest-guardian-char----------------018', 'Forest Guardian', 'ผู้พิทักษ์ป่าที่ปกป้องความศักดิ์สิทธิ์', 'npc', '/images/characters/forest_guardian.svg', '{"hp": 200, "mp": 150, "level": 20}', '["Nature''s Blessing", "Forest Shield"]', false, false)
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
    ('sage-staff-item---------------------020', 'Sage''s Staff', 'คทาของ Sage ที่มีพลังเวทมนตร์โบราณ', 'weapon', 'legendary', '{"attack": 20, "magic_power": 50, "wisdom": 30}', '{"ancient_magic": true}', '/images/items/sage_staff.svg', false),
    ('luminary-pendant-item--------------021', 'Luminary''s Pendant', 'จี้ของ Luminary ที่แสดงถึงตัวตนที่แท้จริง', 'key_item', 'legendary', '{}', '{"luminary_proof": true, "light_power": 100}', '/images/items/luminary_pendant.svg', false),
    ('forest-elixir-item------------------022', 'Forest Elixir', 'น้ำยาป่าที่มีพลังรักษาและฟื้นฟูจิตใจ', 'consumable', 'rare', '{}', '{"heal": 150, "mp_restore": 80, "status_cure": "all"}', '/images/items/forest_elixir.svg', false)
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
    ('entering-forest-evt----------------051', 'The Sage''s Trial', 'Forest Entrance', 'Entering the Ancient Forest', 'การเข้าสู่ป่าโบราณที่เต็มไปด้วยพลังลึกลับ', 'exploration', '{"completed_chapters": ["dragon-quest-xi-ch-----------------005"]}', 1, false),
    ('sacred-trial-evt-------------------052', 'The Sage''s Trial', 'Sacred Grove', 'The Sacred Trial', 'การทดสอบในป่าศักดิ์สิทธิ์เพื่อพิสูจน์ความเป็น Luminary', 'trial', '{"completed_events": ["entering-forest-evt----------------051"]}', 2, false),
    ('meeting-sage-evt-------------------053', 'The Sage''s Trial', 'Sage''s Dwelling', 'Meeting the Sage', 'การพบกับ Sage และเรียนรู้ความจริงเกี่ยวกับชะตากรรม', 'dialogue', '{"completed_events": ["sacred-trial-evt----------------052"]}', 3, false)
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
    ('observe-trees-interaction----------060', 'Entering the Ancient Forest', 'examine', 'Observe Ancient Trees', 'สำรวจต้นไม้โบราณที่มีอายุหลายพันปี', 'ต้นไม้เหล่านี้เก่าแก่มาก... มีพลังเวทมนตร์ลึกลับไหลเวียนอยู่', 'Narrator', '[]', '{}', 1),
    ('face-trial-interaction--------------061', 'The Sacred Trial', 'trial', 'Face the Trial', 'เผชิญหน้ากับการทดสอบของป่าศักดิ์สิทธิ์', 'ป่าทดสอบจิตใจและความมุ่งมั่นของเจ้า... พิสูจน์ว่าเจ้าคือ Luminary ที่แท้จริง!', 'Forest Guardian', '[{"id": "accept", "text": "ผมยอมรับการทดสอบ", "type": "brave"}, {"id": "prepare", "text": "ขอเตรียมตัวก่อน", "type": "cautious"}]', '{}', 1),
    ('speak-sage-interaction--------------062', 'Meeting the Sage', 'talk', 'Speak with Sage', 'พูดคุยกับ Sage ผู้ปราชญ์', 'ข้าได้รอเจ้ามานานแล้ว Luminary... เจ้าคือผู้ที่จะนำแสงสว่างกลับมาสู่โลก', 'Sage', '[{"id": "truth", "text": "ความจริงคืออะไร?", "type": "curious"}, {"id": "destiny", "text": "ชะตากรรมของผมคืออะไร?", "type": "serious"}]', '{}', 1)
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
    ('trial-completed-outcome--------------060', 'Face the Trial', 'accept', 'reward', 'Trial Completed', 'Luminary ผ่านการทดสอบด้วยความกล้าหาญ! ได้รับการยอมรับจากป่าศักดิ์สิทธิ์', '{"experience": 200, "items": [{"code": "luminary-pendant-item--------------021", "quantity": 1}]}', 'Meeting the Sage'),
    ('preparation-time-outcome-------------061', 'Face the Trial', 'prepare', 'story', 'Preparation Time', 'Forest Guardian พยักหน้า "ความระมัดระวังก็เป็นสิ่งดี เตรียมตัวให้ดี"', '{"experience": 50}', 'Meeting the Sage'),
    ('truth-revealed-outcome---------------062', 'Speak with Sage', 'truth', 'story', 'The Truth Revealed', 'Sage เล่าความจริงเกี่ยวกับ Luminary และภัยคุกคามที่จะมา', '{"experience": 150, "party_joins": ["rab-char---------------------------017"], "unlock_regions": ["arboria-region---------------------006"]}', null),
    ('destiny-unveiled-outcome-------------063', 'Speak with Sage', 'destiny', 'story', 'Destiny Unveiled', 'Sage อธิบายชะตากรรมของ Luminary และภารกิจที่รออยู่', '{"experience": 150, "party_joins": ["rab-char---------------------------017"], "unlock_regions": ["arboria-region---------------------006"]}', null)
) AS outcome_info(code, interaction_title, choice_key, outcome_type, title, description, effects, next_event_title)
LEFT JOIN story_events se_next ON se_next.title = outcome_info.next_event_title
WHERE ei.title = outcome_info.interaction_title;
