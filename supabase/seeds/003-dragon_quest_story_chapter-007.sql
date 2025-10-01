-- Dragon Quest XI Story Data Seed - Chapter 7: The Mermaid's Kingdom
-- Created: 2025-09-26
-- Author: Marosdee Uma
-- Description: Chapter 7 - The journey to Nautica, the underwater mermaid kingdom
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
    ('nautica-region---------------------007', 'Nautica', 'อาณาจักรใต้ทะเลของนางเงือกที่สวยงามและลึกลับ', '/images/regions/nautica.svg', '{"completed_events": ["ancient-forest-evt----------------053"]}', 7, false, true)
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
    ('ocean-depths-loc-------------------024', 'Nautica', 'Ocean Depths', 'ส่วนลึกของมหาสมุทรที่นำไปสู่อาณาจักรใต้น้ำ', 'underwater', '{}', 1, false, false),
    ('mermaid-palace-loc-----------------025', 'Nautica', 'Mermaid Palace', 'พระราชวังของราชินีนางเงือกที่งดงาม', 'palace', '{"completed_events": ["diving-deep-evt-------------------061"]}', 2, false, true),
    ('pearl-gardens-loc------------------026', 'Nautica', 'Pearl Gardens', 'สวนไข่มุกที่เต็มไปด้วยสมบัติใต้ทะเล', 'garden', '{"completed_events": ["audience-queen-evt----------------062"]}', 3, false, true)
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
    ('mermaid-kingdom-ch-----------------007', 'dragon-quest-xi-act----------------002', 7, 'The Mermaid''s Kingdom', 'การเดินทางสู่ Nautica อาณาจักรใต้ทะเลและการพบกับราชินีนางเงือก', '{"completed_chapters": ["ancient-forest-ch-----------------006"]}', 7, false)
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
    ('queen-marina-char-----------------019', 'Queen Marina', 'ราชินีนางเงือกผู้ปกครองอาณาจักร Nautica ด้วยความเมตตา', 'npc', '/images/characters/queen_marina.svg', '{"hp": 350, "mp": 300, "level": 40}', '["Ocean''s Blessing", "Tidal Wave", "Healing Waters"]', false, false),
    ('jade-char--------------------------020', 'Jade', 'นักสู้สาวผู้เชี่ยวชาญด้านศิลปะการต่อสู้และการใช้หอก', 'party_member', '/images/characters/jade.svg', '{"hp": 140, "mp": 70, "level": 1, "attack": 22, "defense": 16, "agility": 18, "luck": 14}', '["Spear Strike", "Lightning Spear", "Multithrust"]', true, false),
    ('mermaid-guard-char-----------------021', 'Mermaid Guard', 'ทหารนางเงือกที่ปกป้องอาณาจักร', 'npc', '/images/characters/mermaid_guard.svg', '{"hp": 150, "mp": 80, "level": 15}', '["Trident Strike", "Water Shield"]', false, false)
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
    ('trident-seas-item------------------023', 'Trident of the Seas', 'ตรีศูลแห่งท้องทะเลที่มีพลังควบคุมน้ำ', 'weapon', 'legendary', '{"attack": 40, "water_power": 30, "magic_power": 20}', '{"water_mastery": true}', '/images/items/sea_trident.svg', false),
    ('pearl-wisdom-item------------------024', 'Pearl of Wisdom', 'ไข่มุกแห่งปัญญาที่เพิ่มพลังเวทมนตร์', 'accessory', 'rare', '{"magic_power": 25, "mp": 50}', '{"wisdom_boost": 20}', '/images/items/wisdom_pearl.svg', false),
    ('mermaid-armor-item-----------------025', 'Mermaid Scale Armor', 'เกราะเกล็ดนางเงือกที่ป้องกันการโจมตีทางน้ำ', 'armor', 'rare', '{"defense": 30, "water_resistance": 50}', '{"underwater_breathing": true}', '/images/items/mermaid_armor.svg', false)
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
    ('diving-deep-evt-------------------061', 'The Mermaid''s Kingdom', 'Ocean Depths', 'Diving into the Deep', 'การดำน้ำลึกเพื่อค้นหาอาณาจักรใต้ทะเล', 'exploration', '{"completed_chapters": ["ancient-forest-ch-----------------006"]}', 1, false),
    ('audience-queen-evt----------------062', 'The Mermaid''s Kingdom', 'Mermaid Palace', 'Audience with the Queen', 'การเข้าเฝ้าราชินีนางเงือก Marina', 'dialogue', '{"completed_events": ["diving-deep-evt-------------------061"]}', 2, false),
    ('pearl-trial-evt--------------------063', 'The Mermaid''s Kingdom', 'Pearl Gardens', 'The Pearl Trial', 'การทดสอบในสวนไข่มุกเพื่อพิสูจน์ความคุ้มค่า', 'trial', '{"completed_events": ["audience-queen-evt----------------062"]}', 3, false)
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
    ('explore-ocean-interaction----------070', 'Diving into the Deep', 'examine', 'Explore Ocean Floor', 'สำรวจพื้นมหาสมุทรที่ลึกลับ', 'ใต้ทะเลลึกนี้สวยงามเหลือเกิน! ปะการังและสิ่งมีชีวิตใต้น้ำมากมาย', 'Narrator', '[]', '{}', 1),
    ('speak-queen-interaction-------------071', 'Audience with the Queen', 'talk', 'Speak to Queen Marina', 'พูดคุยกับราชินีนางเงือก', 'ยินดีต้อนรับสู่ Nautica, Luminary ข้าได้รอคอยการมาของเจ้า', 'Queen Marina', '[{"id": "purpose", "text": "ผมมาเพื่อขอความช่วยเหลือ", "type": "request"}, {"id": "honor", "text": "เป็นเกียรติที่ได้พบพระองค์", "type": "respectful"}]', '{}', 1),
    ('face-pearl-interaction--------------072', 'The Pearl Trial', 'trial', 'Face Pearl Guardian', 'เผชิญหน้ากับผู้พิทักษ์ไข่มุก', 'ผู้พิทักษ์ไข่มุกปรากฏตัว! พิสูจน์ความคุ้มค่าของเจ้า!', 'Pearl Guardian', '[{"id": "fight", "text": "ผมพร้อมสู้!", "type": "brave"}, {"id": "negotiate", "text": "เราสามารถเจรจาได้ไหม?", "type": "diplomatic"}]', '{}', 1)
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
    ('royal-assistance-outcome-------------070', 'Speak to Queen Marina', 'purpose', 'story', 'Royal Assistance', 'ราชินี Marina ยิ้ม "ข้าจะช่วยเจ้า แต่เจ้าต้องพิสูจน์ตัวเองก่อน"', '{"experience": 100, "relationship": {"queen_marina": 15}}', 'The Pearl Trial'),
    ('royal-respect-outcome----------------071', 'Speak to Queen Marina', 'honor', 'story', 'Royal Respect', 'ราชินี Marina พอใจ "เจ้ามีมารยาทดี ข้าจะพิจารณาช่วยเหลือ"', '{"experience": 80, "relationship": {"queen_marina": 12}}', 'The Pearl Trial'),
    ('victory-battle-outcome---------------072', 'Face Pearl Guardian', 'fight', 'reward', 'Victory in Battle', 'Luminary เอาชนะผู้พิทักษ์ไข่มุกด้วยความกล้าหาญ!', '{"experience": 250, "items": [{"code": "pearl-wisdom-item------------------024", "quantity": 1}], "party_joins": ["jade-char--------------------------020"], "unlock_regions": ["nautica-region---------------------007"]}', null),
    ('peaceful-resolution-outcome----------073', 'Face Pearl Guardian', 'negotiate', 'story', 'Peaceful Resolution', 'ผู้พิทักษ์ประทับใจในปัญญาของ Luminary และยอมให้ผ่าน', '{"experience": 200, "items": [{"code": "pearl-wisdom-item------------------024", "quantity": 1}], "party_joins": ["jade-char--------------------------020"], "unlock_regions": ["nautica-region---------------------007"]}', null)
) AS outcome_info(code, interaction_title, choice_key, outcome_type, title, description, effects, next_event_title)
LEFT JOIN story_events se_next ON se_next.title = outcome_info.next_event_title
WHERE ei.title = outcome_info.interaction_title;
