-- Dragon Quest XI Story Data Seed - Chapter 5: The Coastal Adventures
-- Created: 2025-09-26
-- Author: Marosdee Uma
-- Description: Chapter 5 - The journey to Puerto Valor, the coastal port city
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
    ('11111111-1111-1111-1111-111111111005', 'Puerto Valor', 'เมืองท่าแห่งทะเลเมดิเตอร์เรเนียนที่คึกคักและเต็มไปด้วยการผจญภัย', '/images/regions/puerto_valor.svg', '{"completed_events": ["66666666-6666-6666-6666-666666666033"]}', 5, false, true)
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
    ('22222222-2222-2222-2222-222222222018', 'Puerto Valor', 'Puerto Valor Harbor', 'ท่าเรือที่คึกคักและมีเรือสินค้ามากมาย', 'harbor', '{}', 1, false, false),
    ('22222222-2222-2222-2222-222222222019', 'Puerto Valor', 'Casino', 'คาสิโนที่มีชื่อเสียงและสนุกสนาน', 'casino', '{"completed_events": ["66666666-6666-6666-6666-666666666041"]}', 2, false, true),
    ('22222222-2222-2222-2222-222222222020', 'Puerto Valor', 'Beach', 'ชายหาดที่สวยงามและเงียบสงบ', 'beach', '{"completed_events": ["66666666-6666-6666-6666-666666666042"]}', 3, false, true)
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
    ('33333333-3333-3333-3333-333333333005', 5, 'The Coastal Adventures', 'การเดินทางสู่ Puerto Valor เมืองท่าแห่งทะเลที่เต็มไปด้วยความท้าทาย', '{"completed_chapters": ["33333333-3333-3333-3333-333333333004"]}', 5, false)
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
    ('44444444-4444-4444-4444-444444444013', 'Veronica', 'แม่มดสาวเจ้าเสน่ห์ผู้มีพลังเวทมนตร์อันทรงพลัง', 'party_member', '/images/characters/veronica.svg', '{"hp": 80, "mp": 150, "level": 1, "attack": 8, "defense": 6, "agility": 15, "luck": 12}', '["Frizz", "Sizzle", "Bang"]', true, false),
    ('44444444-4444-4444-4444-444444444014', 'Serena', 'นักบวชสาวผู้เชี่ยวชาญด้านการรักษาและเวทมนตร์สนับสนุน', 'party_member', '/images/characters/serena.svg', '{"hp": 100, "mp": 120, "level": 1, "attack": 10, "defense": 12, "agility": 10, "luck": 18}', '["Heal", "Moreheal", "Zing"]', true, false),
    ('44444444-4444-4444-4444-444444444015', 'Captain Marina', 'กัปตันเรือที่มีประสบการณ์และรู้จักทะเลดี', 'npc', '/images/characters/captain_marina.svg', '{"hp": 180, "mp": 60, "level": 14}', '["Sea Navigation", "Storm Control"]', false, false)
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
    ('55555555-5555-5555-5555-555555555017', 'Sea Breeze Sword', 'ดาบลมทะเลที่มีพลังของคลื่นและลม', 'weapon', 'rare', '{"attack": 32, "water_power": 15}', '{"water_damage": 25}', '/images/items/sea_breeze_sword.svg', false),
    ('55555555-5555-5555-5555-555555555018', 'Mermaid''s Tear', 'น้ำตาของนางเงือกที่มีพลังรักษาอันยิ่งใหญ่', 'consumable', 'legendary', '{}', '{"heal": 200, "mp_restore": 100}', '/images/items/mermaid_tear.svg', false),
    ('55555555-5555-5555-5555-555555555019', 'Sailor''s Coat', 'เสื้อคลุมของกะลาสีที่ป้องกันลมและน้ำ', 'armor', 'uncommon', '{"defense": 22, "water_resistance": 30}', '{}', '/images/items/sailor_coat.svg', false)
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
    ('66666666-6666-6666-6666-666666666041', 'The Coastal Adventures', 'Puerto Valor Harbor', 'Coastal Arrival', 'การมาถึง Puerto Valor เมืองท่าแห่งทะเล', 'exploration', '{"completed_chapters": ["33333333-3333-3333-3333-333333333004"]}', 1, false),
    ('66666666-6666-6666-6666-666666666042', 'The Coastal Adventures', 'Casino', 'Casino Adventure', 'การผจญภัยในคาสิโนที่เต็มไปด้วยความเสี่ยง', 'choice', '{"completed_events": ["66666666-6666-6666-6666-666666666041"]}', 2, false),
    ('66666666-6666-6666-6666-666666666043', 'The Coastal Adventures', 'Beach', 'Beach Encounter', 'การพบกับ Veronica และ Serena ที่ชายหาด', 'dialogue', '{"completed_events": ["66666666-6666-6666-6666-666666666042"]}', 3, false)
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
    ('77777777-7777-7777-7777-777777777050', 'Coastal Arrival', 'examine', 'Observe Harbor', 'สำรวจท่าเรือที่คึกคักและมีชีวิตชีวา', 'ท่าเรือ Puerto Valor คึกคักไปด้วยเรือสินค้าและกะลาสี! กลิ่นเค็มของทะเลลอยมา', 'Narrator', '[]', '{}', 1),
    ('77777777-7777-7777-7777-777777777051', 'Casino Adventure', 'choice', 'Enter Casino', 'เข้าสู่คาสิโนที่หรูหราและเต็มไปด้วยความเสี่ยง', 'ยินดีต้อนรับสู่คาสิโนที่ดีที่สุดใน Puerto Valor! ท่านต้องการเล่นอะไร?', 'Casino Dealer', '[{"id": "play_cards", "text": "เล่นไพ่", "type": "gamble"}, {"id": "just_look", "text": "แค่ดูๆ", "type": "cautious"}]', '{}', 1),
    ('77777777-7777-7777-7777-777777777052', 'Beach Encounter', 'talk', 'Meet the Sisters', 'พบกับพี่น้องสาว Veronica และ Serena', 'เฮ้! นายคือ Luminary ใช่ไหม? ฉันชื่อ Veronica นี่คือน้องสาวฉัน Serena', 'Veronica', '[{"id": "introduce", "text": "ใช่ ผมชื่อ Luminary", "type": "friendly"}, {"id": "surprised", "text": "ทำไมพวกคุณถึงรู้จักผม?", "type": "curious"}]', '{}', 1)
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
    ('88888888-8888-8888-8888-888888888050', 'Enter Casino', 'play_cards', 'reward', 'Lucky Win', 'Luminary โชคดี! ชนะเงินจำนวนมากจากการเล่นไพ่', '{"gold": 500, "experience": 25}', 'Beach Encounter'),
    ('88888888-8888-8888-8888-888888888051', 'Enter Casino', 'just_look', 'story', 'Cautious Observer', 'Luminary เลือกที่จะสังเกตการณ์แทนการเสี่ยง', '{"experience": 10}', 'Beach Encounter'),
    ('88888888-8888-8888-8888-888888888052', 'Meet the Sisters', 'introduce', 'party_join', 'New Companions', 'Veronica และ Serena ตัดสินใจเข้าร่วมการเดินทางกับ Luminary', '{"party_join": "44444444-4444-4444-4444-444444444013", "relationship": {"veronica": 15, "serena": 15}, "experience": 100}', null),
    ('88888888-8888-8888-8888-888888888053', 'Meet the Sisters', 'surprised', 'story', 'Mysterious Knowledge', 'Veronica ยิ้มลึกลับ "เราได้ยินเรื่องราวของนายมาแล้ว Luminary ผู้นำแสงสว่าง"', '{"party_join": "44444444-4444-4444-4444-444444444013", "relationship": {"veronica": 12, "serena": 12}, "experience": 80}', null)
) AS outcome_info(id, interaction_title, choice_key, outcome_type, title, description, effects, next_event_title)
LEFT JOIN story_events se_next ON se_next.title = outcome_info.next_event_title
WHERE ei.title = outcome_info.interaction_title;
