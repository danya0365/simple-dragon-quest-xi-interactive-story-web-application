-- Dragon Quest XI Story Data Seed - Chapter 10: The Final Battle
-- Created: 2025-09-26
-- Author: Marosdee Uma
-- Description: Chapter 10 - The final battle against Mordegon and the conclusion
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
    ('fortress-of-fear-region--------------010', 'Fortress of Fear', 'ป้อมปราการแห่งความกลัวที่เป็นที่อยู่ของ Mordegon ลอร์ดแห่งความมืด', '/images/regions/fortress_of_fear.svg', '{"completed_events": ["final-preparation-evt--------------083"]}', 10, false, true)
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
    ('dark-gates-loc-----------------------033', 'Fortress of Fear', 'Dark Gates', 'ประตูมืดที่นำไปสู่ป้อมปราการแห่งความกลัว', 'fortress_gate', '{}', 1, false, false),
    ('throne-of-darkness-loc--------------034', 'Fortress of Fear', 'Throne of Darkness', 'บัลลังก์แห่งความมืดที่ Mordegon ประทับ', 'throne_room', '{"completed_events": ["enter-fortress-evt-----------------091"]}', 2, false, true),
    ('final-battleground-loc---------------035', 'Fortress of Fear', 'Final Battleground', 'สนามรบสุดท้ายที่จะตัดสินชะตากรรมของโลก', 'battleground', '{"completed_events": ["throne-confrontation-evt------------092"]}', 3, false, true)
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
    ('final-battle-ch----------------------010', 'dragon-quest-xi-act----------------003', 10, 'The Final Battle', 'การต่อสู้ครั้งสุดท้ายกับ Mordegon และการกอบกู้โลกจากความมืดมิด', '{"completed_chapters": ["world-tree-ch-----------------------009"]}', 10, false)
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
    ('mordegon-final-character-------------028', 'Mordegon Final Form', 'รูปแบบสุดท้ายของ Mordegon ที่มีพลังแห่งความมืดสูงสุด', 'boss', '/images/characters/mordegon_final.svg', '{"hp": 1200, "mp": 800, "level": 80}', '["Ultimate Darkness", "World Destroyer", "Despair Incarnate"]', false, false),
    ('shadow-minion-character----------------029', 'Shadow Minion', 'สมุนของเงาที่รับใช้ Mordegon', 'enemy', '/images/characters/shadow_minion.svg', '{"hp": 200, "mp": 100, "level": 35}', '["Shadow Strike", "Dark Bind"]', false, false),
    ('spirit-of-hope-character---------------030', 'Spirit of Hope', 'วิญญาณแห่งความหวังที่ช่วยเหลือ Luminary', 'ally', '/images/characters/spirit_hope.svg', '{"hp": 300, "mp": 400, "level": 50}', '["Hope''s Light", "Courage Boost", "Final Blessing"]', false, false)
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
    ('orb-of-calasmos-item-----------------032', 'Orb of Calasmos', 'ลูกแก้วของ Calasmos ที่มีพลังมืดสูงสุด', 'key_item', 'legendary', '{}', '{"ultimate_darkness": true, "world_threat": true}', '/images/items/calasmos_orb.svg', false),
    ('light-of-hope-item--------------------033', 'Light of Hope', 'แสงแห่งความหวังที่จะขับไล่ความมืด', 'key_item', 'legendary', '{}', '{"ultimate_light": true, "darkness_banisher": true}', '/images/items/light_hope.svg', false),
    ('crown-true-king-item------------------034', 'Crown of the True King', 'มงกุฎของกษัตริย์ที่แท้จริงแห่งโลก', 'accessory', 'legendary', '{"all_stats": 50, "leadership": 100}', '{"true_king": true}', '/images/items/true_king_crown.svg', false)
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
    ('enter-fortress-evt-----------------091', 'The Final Battle', 'Dark Gates', 'Storming the Fortress', 'การบุกเข้าสู่ป้อมปราการแห่งความกลัว', 'action', '{"completed_chapters": ["final-battle-ch----------------------010"]}', 1, false),
    ('throne-confrontation-evt------------092', 'The Final Battle', 'Throne of Darkness', 'Confronting Mordegon', 'การเผชิญหน้ากับ Mordegon ครั้งสุดท้าย', 'boss_battle', '{"completed_events": ["enter-fortress-evt-----------------091"]}', 2, false),
    ('ultimate-sacrifice-evt---------------093', 'The Final Battle', 'Final Battleground', 'The Ultimate Sacrifice', 'การเสียสละครั้งสุดท้ายเพื่อกอบกู้โลก', 'climax', '{"completed_events": ["throne-confrontation-evt------------092"]}', 3, false)
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
    ('break-defenses-interaction-----------100', 'Storming the Fortress', 'action', 'Break Through Defenses', 'ทำลายการป้องกันของป้อมปราการ', 'ป้อมปราการแห่งความกลัวมีการป้องกันที่แข็งแกร่ง! ต้องใช้พลังทั้งหมดเพื่อทะลุผ่าน!', 'Narrator', '[{"id": "full_power", "text": "ใช้พลังเต็มที่!", "type": "heroic"}, {"id": "strategy", "text": "ใช้กลยุทธ์", "type": "tactical"}]', '{}', 1),
    ('final-confrontation-interaction------101', 'Confronting Mordegon', 'boss_battle', 'Final Confrontation', 'การเผชิญหน้าครั้งสุดท้ายกับ Mordegon', 'ในที่สุด Luminary... เจ้าก็มาถึงที่นี่! แต่ทุกอย่างสายเกินไปแล้ว! โลกนี้จะจมอยู่ในความมืดมิดตลอดกาล!', 'Mordegon Final Form', '[{"id": "never", "text": "ไม่มีวัน! ผมจะหยุดคุณ!", "type": "determined"}, {"id": "hope", "text": "ความหวังยังคงอยู่!", "type": "hopeful"}]', '{}', 1),
    ('save-world-interaction----------------102', 'The Ultimate Sacrifice', 'climax', 'Save the World', 'การกอบกู้โลกด้วยการเสียสละ', 'เพื่อกอบกู้โลก... Luminary ต้องเสียสละทุกอย่าง... แสงแห่งความหวังส่องสว่างไปทั่วโลก!', 'Spirit of Hope', '[{"id": "sacrifice", "text": "ผมยอมเสียสละเพื่อโลก", "type": "heroic"}]', '{}', 1)
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
    ('fortress-breached-outcome-------------100', 'Break Through Defenses', 'full_power', 'story', 'Fortress Breached', 'ด้วยพลังเต็มที่ Luminary ทะลุผ่านการป้องกันได้สำเร็จ!', '{"experience": 400}', 'Confronting Mordegon'),
    ('strategic-victory-outcome-------------101', 'Break Through Defenses', 'strategy', 'story', 'Strategic Victory', 'ด้วยกลยุทธ์ที่ชาญฉลาด Luminary เอาชนะการป้องกันได้', '{"experience": 350}', 'Confronting Mordegon'),
    ('unwavering-determination-outcome------102', 'Final Confrontation', 'never', 'story', 'Unwavering Determination', 'ความมุ่งมั่นของ Luminary ทำให้ Mordegon สั่นคลอน', '{"experience": 500}', 'The Ultimate Sacrifice'),
    ('hope-prevails-outcome-----------------103', 'Final Confrontation', 'hope', 'story', 'Hope Prevails', 'ความหวังของ Luminary ส่องแสงสว่างในความมืด', '{"experience": 500}', 'The Ultimate Sacrifice'),
    ('world-saved-outcome-------------------104', 'Save the World', 'sacrifice', 'ending', 'World Saved', 'Luminary เสียสละตัวเองเพื่อกอบกู้โลก! แสงแห่งความหวังกลับคืนมา โลกได้รับการช่วยเหลือ!', '{"experience": 1000, "items": [{"code": "light-of-hope-item--------------------033", "quantity": 1}, {"code": "crown-true-king-item------------------034", "quantity": 1}], "game_flags": {"world_saved": true, "story_completed": true}}', null)
) AS outcome_info(code, interaction_title, choice_key, outcome_type, title, description, effects, next_event_title)
LEFT JOIN story_events se_next ON se_next.title = outcome_info.next_event_title
WHERE ei.title = outcome_info.interaction_title;
