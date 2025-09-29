-- Dragon Quest XI Story Data Seed - Chapter 7: The Mermaid's Kingdom
-- Created: 2025-09-26
-- Author: Marosdee Uma
-- Description: Chapter 7 - The journey to Nautica, the underwater mermaid kingdom
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
    ('11111111-1111-1111-1111-111111111007', 'Nautica', 'อาณาจักรใต้ทะเลของนางเงือกที่สวยงามและลึกลับ', '/images/regions/nautica.svg', '{"completed_events": ["66666666-6666-6666-6666-666666666053"]}', 7, false, true)
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
    ('22222222-2222-2222-2222-222222222024', 'Nautica', 'Ocean Depths', 'ส่วนลึกของมหาสมุทรที่นำไปสู่อาณาจักรใต้น้ำ', 'underwater', '{}', 1, false, false),
    ('22222222-2222-2222-2222-222222222025', 'Nautica', 'Mermaid Palace', 'พระราชวังของราชินีนางเงือกที่งดงาม', 'palace', '{"completed_events": ["66666666-6666-6666-6666-666666666061"]}', 2, false, true),
    ('22222222-2222-2222-2222-222222222026', 'Nautica', 'Pearl Gardens', 'สวนไข่มุกที่เต็มไปด้วยสมบัติใต้ทะเล', 'garden', '{"completed_events": ["66666666-6666-6666-6666-666666666062"]}', 3, false, true)
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
    ('33333333-3333-3333-3333-333333333007', 7, 'The Mermaid''s Kingdom', 'การเดินทางสู่ Nautica อาณาจักรใต้ทะเลและการพบกับราชินีนางเงือก', '{"completed_chapters": ["33333333-3333-3333-3333-333333333006"]}', 7, false)
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
    ('44444444-4444-4444-4444-444444444019', 'Queen Marina', 'ราชินีนางเงือกผู้ปกครองอาณาจักร Nautica ด้วยความเมตตา', 'npc', '/images/characters/queen_marina.svg', '{"hp": 350, "mp": 300, "level": 40}', '["Ocean''s Blessing", "Tidal Wave", "Healing Waters"]', false, false),
    ('44444444-4444-4444-4444-444444444020', 'Jade', 'นักสู้สาวผู้เชี่ยวชาญด้านศิลปะการต่อสู้และการใช้หอก', 'party_member', '/images/characters/jade.svg', '{"hp": 140, "mp": 70, "level": 1, "attack": 22, "defense": 16, "agility": 18, "luck": 14}', '["Spear Strike", "Lightning Spear", "Multithrust"]', true, false),
    ('44444444-4444-4444-4444-444444444021', 'Mermaid Guard', 'ทหารนางเงือกที่ปกป้องอาณาจักร', 'npc', '/images/characters/mermaid_guard.svg', '{"hp": 150, "mp": 80, "level": 15}', '["Trident Strike", "Water Shield"]', false, false)
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
    ('55555555-5555-5555-5555-555555555023', 'Trident of the Seas', 'ตรีศูลแห่งท้องทะเลที่มีพลังควบคุมน้ำ', 'weapon', 'legendary', '{"attack": 40, "water_power": 30, "magic_power": 20}', '{"water_mastery": true}', '/images/items/sea_trident.svg', false),
    ('55555555-5555-5555-5555-555555555024', 'Pearl of Wisdom', 'ไข่มุกแห่งปัญญาที่เพิ่มพลังเวทมนตร์', 'accessory', 'rare', '{"magic_power": 25, "mp": 50}', '{"wisdom_boost": 20}', '/images/items/wisdom_pearl.svg', false),
    ('55555555-5555-5555-5555-555555555025', 'Mermaid Scale Armor', 'เกราะเกล็ดนางเงือกที่ป้องกันการโจมตีทางน้ำ', 'armor', 'rare', '{"defense": 30, "water_resistance": 50}', '{"underwater_breathing": true}', '/images/items/mermaid_armor.svg', false)
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
    ('66666666-6666-6666-6666-666666666061', 'The Mermaid''s Kingdom', 'Ocean Depths', 'Diving into the Deep', 'การดำน้ำลึกเพื่อค้นหาอาณาจักรใต้ทะเล', 'exploration', '{"completed_chapters": ["33333333-3333-3333-3333-333333333006"]}', 1, false),
    ('66666666-6666-6666-6666-666666666062', 'The Mermaid''s Kingdom', 'Mermaid Palace', 'Audience with the Queen', 'การเข้าเฝ้าราชินีนางเงือก Marina', 'dialogue', '{"completed_events": ["66666666-6666-6666-6666-666666666061"]}', 2, false),
    ('66666666-6666-6666-6666-666666666063', 'The Mermaid''s Kingdom', 'Pearl Gardens', 'The Pearl Trial', 'การทดสอบในสวนไข่มุกเพื่อพิสูจน์ความคุ้มค่า', 'trial', '{"completed_events": ["66666666-6666-6666-6666-666666666062"]}', 3, false)
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
    ('77777777-7777-7777-7777-777777777070', 'Diving into the Deep', 'examine', 'Explore Ocean Floor', 'สำรวจพื้นมหาสมุทรที่ลึกลับ', 'ใต้ทะเลลึกนี้สวยงามเหลือเกิน! ปะการังและสิ่งมีชีวิตใต้น้ำมากมาย', 'Narrator', '[]', '{}', 1),
    ('77777777-7777-7777-7777-777777777071', 'Audience with the Queen', 'talk', 'Speak to Queen Marina', 'พูดคุยกับราชินีนางเงือก', 'ยินดีต้อนรับสู่ Nautica, Luminary ข้าได้รอคอยการมาของเจ้า', 'Queen Marina', '[{"id": "purpose", "text": "ผมมาเพื่อขอความช่วยเหลือ", "type": "request"}, {"id": "honor", "text": "เป็นเกียรติที่ได้พบพระองค์", "type": "respectful"}]', '{}', 1),
    ('77777777-7777-7777-7777-777777777072', 'The Pearl Trial', 'trial', 'Face Pearl Guardian', 'เผชิญหน้ากับผู้พิทักษ์ไข่มุก', 'ผู้พิทักษ์ไข่มุกปรากฏตัว! พิสูจน์ความคุ้มค่าของเจ้า!', 'Pearl Guardian', '[{"id": "fight", "text": "ผมพร้อมสู้!", "type": "brave"}, {"id": "negotiate", "text": "เราสามารถเจรจาได้ไหม?", "type": "diplomatic"}]', '{}', 1)
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
    ('88888888-8888-8888-8888-888888888070', 'Speak to Queen Marina', 'purpose', 'story', 'Royal Assistance', 'ราชินี Marina ยิ้ม "ข้าจะช่วยเจ้า แต่เจ้าต้องพิสูจน์ตัวเองก่อน"', '{"experience": 100, "relationship": {"queen_marina": 15}}', 'The Pearl Trial'),
    ('88888888-8888-8888-8888-888888888071', 'Speak to Queen Marina', 'honor', 'story', 'Royal Respect', 'ราชินี Marina พอใจ "เจ้ามีมารยาทดี ข้าจะพิจารณาช่วยเหลือ"', '{"experience": 80, "relationship": {"queen_marina": 12}}', 'The Pearl Trial'),
    ('88888888-8888-8888-8888-888888888072', 'Face Pearl Guardian', 'fight', 'reward', 'Victory in Battle', 'Luminary เอาชนะผู้พิทักษ์ไข่มุกด้วยความกล้าหาญ!', '{"experience": 250, "items": [{"id": "55555555-5555-5555-5555-555555555024", "quantity": 1}], "party_join": "44444444-4444-4444-4444-444444444020", "unlock_regions": ["11111111-1111-1111-1111-111111111008"]}', null),
    ('88888888-8888-8888-8888-888888888073', 'Face Pearl Guardian', 'negotiate', 'story', 'Peaceful Resolution', 'ผู้พิทักษ์ประทับใจในปัญญาของ Luminary และยอมให้ผ่าน', '{"experience": 200, "items": [{"id": "55555555-5555-5555-5555-555555555024", "quantity": 1}], "party_join": "44444444-4444-4444-4444-444444444020", "unlock_regions": ["11111111-1111-1111-1111-111111111008"]}', null)
) AS outcome_info(id, interaction_title, choice_key, outcome_type, title, description, effects, next_event_title)
LEFT JOIN story_events se_next ON se_next.title = outcome_info.next_event_title
WHERE ei.title = outcome_info.interaction_title;
