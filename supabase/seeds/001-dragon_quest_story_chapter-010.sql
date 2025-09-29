-- Dragon Quest XI Story Data Seed - Chapter 10: The Final Battle
-- Created: 2025-09-26
-- Author: Marosdee Uma
-- Description: Chapter 10 - The final battle against Mordegon and the conclusion
-- Features: Basic structure following Dragon Quest XI narrative

-- === WORLD REGIONS ===
INSERT INTO public.world_regions (id, name, description, image_url, unlock_requirements, display_order, is_initial_user_progress, is_alway_hide_until_unlock)
SELECT 
  region_info.id::uuid,
  region_info.name,
  region_info.description,
  region_info.image_url,
  region_info.unlock_requirements::jsonb,
  region_info.display_order,
  region_info.is_initial_user_progress,
  region_info.is_alway_hide_until_unlock
FROM (
  VALUES 
    ('11111111-1111-1111-1111-111111111010', 'Fortress of Fear', 'ป้อมปราการแห่งความกลัวที่เป็นที่อยู่ของ Mordegon ลอร์ดแห่งความมืด', '/images/regions/fortress_of_fear.svg', '{"completed_events": ["66666666-6666-6666-6666-666666666083"]}', 10, false, true)
) AS region_info(id, name, description, image_url, unlock_requirements, display_order, is_initial_user_progress, is_alway_hide_until_unlock);

-- === LOCATIONS ===
INSERT INTO public.locations (id, world_region_id, name, description, location_type, unlock_requirements, display_order, is_initial_user_progress, is_alway_hide_until_unlock)
SELECT 
  location_info.id::uuid,
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
    ('22222222-2222-2222-2222-222222222033', 'Fortress of Fear', 'Dark Gates', 'ประตูมืดที่นำไปสู่ป้อมปราการแห่งความกลัว', 'fortress_gate', '{}', 1, false, false),
    ('22222222-2222-2222-2222-222222222034', 'Fortress of Fear', 'Throne of Darkness', 'บัลลังก์แห่งความมืดที่ Mordegon ประทับ', 'throne_room', '{"completed_events": ["66666666-6666-6666-6666-666666666091"]}', 2, false, true),
    ('22222222-2222-2222-2222-222222222035', 'Fortress of Fear', 'Final Battleground', 'สนามรบสุดท้ายที่จะตัดสินชะตากรรมของโลก', 'battleground', '{"completed_events": ["66666666-6666-6666-6666-666666666092"]}', 3, false, true)
) AS location_info(id, region_name, name, description, location_type, unlock_requirements, display_order, is_initial_user_progress, is_alway_hide_until_unlock)
WHERE wr.name = location_info.region_name;

-- === STORY CHAPTERS ===
INSERT INTO public.story_chapters (id, chapter_number, title, description, unlock_requirements, display_order, is_initial_user_progress)
SELECT 
  chapter_info.id::uuid,
  chapter_info.chapter_number,
  chapter_info.title,
  chapter_info.description,
  chapter_info.unlock_requirements::jsonb,
  chapter_info.display_order,
  chapter_info.is_initial_user_progress
FROM (
  VALUES 
    ('33333333-3333-3333-3333-333333333010', 10, 'The Final Battle', 'การต่อสู้ครั้งสุดท้ายกับ Mordegon และการกอบกู้โลกจากความมืดมิด', '{"completed_chapters": ["33333333-3333-3333-3333-333333333009"]}', 10, false)
) AS chapter_info(id, chapter_number, title, description, unlock_requirements, display_order, is_initial_user_progress);

-- === CHARACTERS ===
INSERT INTO public.characters (id, name, description, character_type, avatar_url, stats, abilities, is_joinable, is_initial_user_progress)
SELECT 
  character_info.id::uuid,
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
    ('44444444-4444-4444-4444-444444444028', 'Mordegon Final Form', 'รูปแบบสุดท้ายของ Mordegon ที่มีพลังแห่งความมืดสูงสุด', 'boss', '/images/characters/mordegon_final.svg', '{"hp": 1200, "mp": 800, "level": 80}', '["Ultimate Darkness", "World Destroyer", "Despair Incarnate"]', false, false),
    ('44444444-4444-4444-4444-444444444029', 'Shadow Minion', 'สมุนของเงาที่รับใช้ Mordegon', 'enemy', '/images/characters/shadow_minion.svg', '{"hp": 200, "mp": 100, "level": 35}', '["Shadow Strike", "Dark Bind"]', false, false),
    ('44444444-4444-4444-4444-444444444030', 'Spirit of Hope', 'วิญญาณแห่งความหวังที่ช่วยเหลือ Luminary', 'ally', '/images/characters/spirit_hope.svg', '{"hp": 300, "mp": 400, "level": 50}', '["Hope''s Light", "Courage Boost", "Final Blessing"]', false, false)
) AS character_info(id, name, description, character_type, avatar_url, stats, abilities, is_joinable, is_initial_user_progress);

-- === ITEMS ===
INSERT INTO public.items (id, name, description, item_type, rarity, stats, effects, image_url, is_initial_user_progress)
SELECT 
  item_info.id::uuid,
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
    ('55555555-5555-5555-5555-555555555032', 'Orb of Calasmos', 'ลูกแก้วของ Calasmos ที่มีพลังมืดสูงสุด', 'key_item', 'legendary', '{}', '{"ultimate_darkness": true, "world_threat": true}', '/images/items/calasmos_orb.svg', false),
    ('55555555-5555-5555-5555-555555555033', 'Light of Hope', 'แสงแห่งความหวังที่จะขับไล่ความมืด', 'key_item', 'legendary', '{}', '{"ultimate_light": true, "darkness_banisher": true}', '/images/items/light_hope.svg', false),
    ('55555555-5555-5555-5555-555555555034', 'Crown of the True King', 'มงกุฎของกษัตริย์ที่แท้จริงแห่งโลก', 'accessory', 'legendary', '{"all_stats": 50, "leadership": 100}', '{"true_king": true}', '/images/items/true_king_crown.svg', false)
) AS item_info(id, name, description, item_type, rarity, stats, effects, image_url, is_initial_user_progress);

-- === STORY EVENTS ===
INSERT INTO public.story_events (id, chapter_id, location_id, title, description, event_type, unlock_requirements, display_order, is_initial_user_progress)
SELECT 
  event_info.id::uuid,
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
    ('66666666-6666-6666-6666-666666666091', 'The Final Battle', 'Dark Gates', 'Storming the Fortress', 'การบุกเข้าสู่ป้อมปราการแห่งความกลัว', 'action', '{"completed_chapters": ["33333333-3333-3333-3333-333333333009"]}', 1, false),
    ('66666666-6666-6666-6666-666666666092', 'The Final Battle', 'Throne of Darkness', 'Confronting Mordegon', 'การเผชิญหน้ากับ Mordegon ครั้งสุดท้าย', 'boss_battle', '{"completed_events": ["66666666-6666-6666-6666-666666666091"]}', 2, false),
    ('66666666-6666-6666-6666-666666666093', 'The Final Battle', 'Final Battleground', 'The Ultimate Sacrifice', 'การเสียสละครั้งสุดท้ายเพื่อกอบกู้โลก', 'climax', '{"completed_events": ["66666666-6666-6666-6666-666666666092"]}', 3, false)
) AS event_info(id, chapter_name, location_name, title, description, event_type, unlock_requirements, display_order, is_initial_user_progress)
WHERE sc.title = event_info.chapter_name
AND l.name = event_info.location_name;

-- === EVENT INTERACTIONS ===
INSERT INTO public.event_interactions (id, event_id, interaction_type, title, description, dialogue_text, character_speaker, choices, requirements, display_order)
SELECT 
  interaction_info.id::uuid,
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
    ('77777777-7777-7777-7777-777777777100', 'Storming the Fortress', 'action', 'Break Through Defenses', 'ทำลายการป้องกันของป้อมปราการ', 'ป้อมปราการแห่งความกลัวมีการป้องกันที่แข็งแกร่ง! ต้องใช้พลังทั้งหมดเพื่อทะลุผ่าน!', 'Narrator', '[{"id": "full_power", "text": "ใช้พลังเต็มที่!", "type": "heroic"}, {"id": "strategy", "text": "ใช้กลยุทธ์", "type": "tactical"}]', '{}', 1),
    ('77777777-7777-7777-7777-777777777101', 'Confronting Mordegon', 'boss_battle', 'Final Confrontation', 'การเผชิญหน้าครั้งสุดท้ายกับ Mordegon', 'ในที่สุด Luminary... เจ้าก็มาถึงที่นี่! แต่ทุกอย่างสายเกินไปแล้ว! โลกนี้จะจมอยู่ในความมืดมิดตลอดกาล!', 'Mordegon Final Form', '[{"id": "never", "text": "ไม่มีวัน! ผมจะหยุดคุณ!", "type": "determined"}, {"id": "hope", "text": "ความหวังยังคงอยู่!", "type": "hopeful"}]', '{}', 1),
    ('77777777-7777-7777-7777-777777777102', 'The Ultimate Sacrifice', 'climax', 'Save the World', 'การกอบกู้โลกด้วยการเสียสละ', 'เพื่อกอบกู้โลก... Luminary ต้องเสียสละทุกอย่าง... แสงแห่งความหวังส่องสว่างไปทั่วโลก!', 'Spirit of Hope', '[{"id": "sacrifice", "text": "ผมยอมเสียสละเพื่อโลก", "type": "heroic"}]', '{}', 1)
) AS interaction_info(id, event_name, interaction_type, title, description, dialogue_text, character_speaker, choices, requirements, display_order)
WHERE se.title = interaction_info.event_name;

-- === EVENT OUTCOMES ===
INSERT INTO public.event_outcomes (id, interaction_id, choice_key, outcome_type, title, description, effects, next_event_id)
SELECT 
  outcome_info.id::uuid,
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
    ('88888888-8888-8888-8888-888888888100', 'Break Through Defenses', 'full_power', 'story', 'Fortress Breached', 'ด้วยพลังเต็มที่ Luminary ทะลุผ่านการป้องกันได้สำเร็จ!', '{"experience": 400}', 'Confronting Mordegon'),
    ('88888888-8888-8888-8888-888888888101', 'Break Through Defenses', 'strategy', 'story', 'Strategic Victory', 'ด้วยกลยุทธ์ที่ชาญฉลาด Luminary เอาชนะการป้องกันได้', '{"experience": 350}', 'Confronting Mordegon'),
    ('88888888-8888-8888-8888-888888888102', 'Final Confrontation', 'never', 'story', 'Unwavering Determination', 'ความมุ่งมั่นของ Luminary ทำให้ Mordegon สั่นคลอน', '{"experience": 500}', 'The Ultimate Sacrifice'),
    ('88888888-8888-8888-8888-888888888103', 'Final Confrontation', 'hope', 'story', 'Hope Prevails', 'ความหวังของ Luminary ส่องแสงสว่างในความมืด', '{"experience": 500}', 'The Ultimate Sacrifice'),
    ('88888888-8888-8888-8888-888888888104', 'Save the World', 'sacrifice', 'ending', 'World Saved', 'Luminary เสียสละตัวเองเพื่อกอบกู้โลก! แสงแห่งความหวังกลับคืนมา โลกได้รับการช่วยเหลือ!', '{"experience": 1000, "items": [{"id": "55555555-5555-5555-5555-555555555033", "quantity": 1}, {"id": "55555555-5555-5555-5555-555555555034", "quantity": 1}], "game_flags": {"world_saved": true, "story_completed": true}}', null)
) AS outcome_info(id, interaction_title, choice_key, outcome_type, title, description, effects, next_event_title)
LEFT JOIN story_events se_next ON se_next.title = outcome_info.next_event_title
WHERE ei.title = outcome_info.interaction_title;
