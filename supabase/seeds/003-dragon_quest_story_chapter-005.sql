-- Dragon Quest XI Story Data Seed - Chapter 5: The Coastal Adventures
-- Created: 2025-09-26
-- Author: Marosdee Uma
-- Description: Chapter 5 - The journey to Puerto Valor, the coastal port city
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
    ('puerto-valor-region----------------005', 'Puerto Valor', 'เมืองท่าแห่งทะเลเมดิเตอร์เรเนียนที่คึกคักและเต็มไปด้วยการผจญภัย', '/images/regions/puerto_valor.svg', '{"completed_events": ["shipwreck-bay-evt----------------033"]}', 5, false, true)
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
    ('puerto-valor-harbor-loc------------018', 'Puerto Valor', 'Puerto Valor Harbor', 'ท่าเรือที่คึกคักและมีเรือสินค้ามากมาย', 'harbor', '{}', 1, false, false),
    ('puerto-valor-casino-loc------------019', 'Puerto Valor', 'Casino', 'คาสิโนที่มีชื่อเสียงและสนุกสนาน', 'casino', '{"completed_events": ["casino-challenge-evt----------------041"]}', 2, false, true),
    ('puerto-valor-beach-loc-------------020', 'Puerto Valor', 'Beach', 'ชายหาดที่สวยงามและเงียบสงบ', 'beach', '{"completed_events": ["beach-discovery-evt----------------042"]}', 3, false, true)
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
    ('dragon-quest-xi-ch-----------------005', 5, 'The Coastal Adventures', 'การเดินทางสู่ Puerto Valor เมืองท่าแห่งทะเลที่เต็มไปด้วยความท้าทาย', '{"completed_chapters": ["dragon-quest-xi-ch-----------------004"]}', 5, false, 'dragon-quest-xi-act-----------------001')
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
    ('veronica-char---------------------013', 'Veronica', 'แม่มดสาวเจ้าเสน่ห์ผู้มีพลังเวทมนตร์อันทรงพลัง', 'party_member', '/images/characters/veronica.svg', '{"hp": 80, "mp": 150, "level": 1, "attack": 8, "defense": 6, "agility": 15, "luck": 12}', '["Frizz", "Sizzle", "Bang"]', true, false),
    ('serena-char-----------------------014', 'Serena', 'นักบวชสาวผู้เชี่ยวชาญด้านการรักษาและเวทมนตร์สนับสนุน', 'party_member', '/images/characters/serena.svg', '{"hp": 100, "mp": 120, "level": 1, "attack": 10, "defense": 12, "agility": 10, "luck": 18}', '["Heal", "Moreheal", "Zing"]', true, false),
    ('captain-marina-char---------------015', 'Captain Marina', 'กัปตันเรือที่มีประสบการณ์และรู้จักทะเลดี', 'npc', '/images/characters/captain_marina.svg', '{"hp": 180, "mp": 60, "level": 14}', '["Sea Navigation", "Storm Control"]', false, false)
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
    ('sea-breeze-sword-item-------------017', 'Sea Breeze Sword', 'ดาบลมทะเลที่มีพลังของคลื่นและลม', 'weapon', 'rare', '{"attack": 32, "water_power": 15}', '{"water_damage": 25}', '/images/items/sea_breeze_sword.svg', false),
    ('mermaid-tear-item-----------------018', 'Mermaid''s Tear', 'น้ำตาของนางเงือกที่มีพลังรักษาอันยิ่งใหญ่', 'consumable', 'legendary', '{}', '{"heal": 200, "mp_restore": 100}', '/images/items/mermaid_tear.svg', false),
    ('sailor-coat-item------------------019', 'Sailor''s Coat', 'เสื้อคลุมของกะลาสีที่ป้องกันลมและน้ำ', 'armor', 'uncommon', '{"defense": 22, "water_resistance": 30}', '{}', '/images/items/sailor_coat.svg', false)
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
    ('coastal-arrival-evt----------------041', 'The Coastal Adventures', 'Puerto Valor Harbor', 'Coastal Arrival', 'การมาถึง Puerto Valor เมืองท่าแห่งทะเล', 'exploration', '{"completed_chapters": ["dragon-quest-xi-ch-----------------004"]}', 1, false),
    ('casino-adventure-evt---------------042', 'The Coastal Adventures', 'Casino', 'Casino Adventure', 'การผจญภัยในคาสิโนที่เต็มไปด้วยความเสี่ยง', 'choice', '{"completed_events": ["coastal-arrival-evt----------------041"]}', 2, false),
    ('beach-encounter-evt----------------043', 'The Coastal Adventures', 'Beach', 'Beach Encounter', 'การพบกับ Veronica และ Serena ที่ชายหาด', 'dialogue', '{"completed_events": ["casino-adventure-evt---------------042"]}', 3, false)
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
    ('coastal-arrival-interaction---------050', 'Coastal Arrival', 'examine', 'Observe Harbor', 'สำรวจท่าเรือที่คึกคักและมีชีวิตชีวา', 'ท่าเรือ Puerto Valor คึกคักไปด้วยเรือสินค้าและกะลาสี! กลิ่นเค็มของทะเลลอยมา', 'Narrator', '[]', '{}', 1),
    ('casino-adventure-interaction--------051', 'Casino Adventure', 'choice', 'Enter Casino', 'เข้าสู่คาสิโนที่หรูหราและเต็มไปด้วยความเสี่ยง', 'ยินดีต้อนรับสู่คาสิโนที่ดีที่สุดใน Puerto Valor! ท่านต้องการเล่นอะไร?', 'Casino Dealer', '[{"id": "play_cards", "text": "เล่นไพ่", "type": "gamble"}, {"id": "just_look", "text": "แค่ดูๆ", "type": "cautious"}]', '{}', 1),
    ('beach-encounter-interaction---------052', 'Beach Encounter', 'talk', 'Meet the Sisters', 'พบกับพี่น้องสาว Veronica และ Serena', 'เฮ้! นายคือ Luminary ใช่ไหม? ฉันชื่อ Veronica นี่คือน้องสาวฉัน Serena', 'Veronica', '[{"id": "introduce", "text": "ใช่ ผมชื่อ Luminary", "type": "friendly"}, {"id": "surprised", "text": "ทำไมพวกคุณถึงรู้จักผม?", "type": "curious"}]', '{}', 1)
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
    ('lucky-win-outcome--------------------050', 'Enter Casino', 'play_cards', 'reward', 'Lucky Win', 'Luminary โชคดี! ชนะเงินจำนวนมากจากการเล่นไพ่', '{"gold": 500, "experience": 25}', 'Beach Encounter'),
    ('cautious-observer-outcome-----------051', 'Enter Casino', 'just_look', 'story', 'Cautious Observer', 'Luminary เลือกที่จะสังเกตการณ์แทนการเสี่ยง', '{"experience": 10}', 'Beach Encounter'),
    ('new-companions-outcome--------------052', 'Meet the Sisters', 'introduce', 'party_join', 'New Companions', 'Veronica และ Serena ตัดสินใจเข้าร่วมการเดินทางกับ Luminary', '{"party_joins": ["veronica-char---------------------013", "serena-char----------------------014"], "relationship": {"veronica": 15, "serena": 15}, "experience": 100}', null),
    ('mysterious-knowledge-outcome--------053', 'Meet the Sisters', 'surprised', 'story', 'Mysterious Knowledge', 'Veronica ยิ้มลึกลับ "เราได้ยินเรื่องราวของนายมาแล้ว Luminary ผู้นำแสงสว่าง"', '{"party_joins": ["veronica-char---------------------013", "serena-char----------------------014"], "relationship": {"veronica": 12, "serena": 12}, "experience": 80}', null)
) AS outcome_info(code, interaction_title, choice_key, outcome_type, title, description, effects, next_event_title)
LEFT JOIN story_events se_next ON se_next.title = outcome_info.next_event_title
WHERE ei.title = outcome_info.interaction_title;
