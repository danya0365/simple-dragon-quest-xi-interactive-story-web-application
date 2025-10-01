-- Dragon Quest XI Story Data Seed - Chapter 3: The Great Escape
-- Created: 2025-09-26
-- Author: Marosdee Uma
-- Description: Chapter 3 - The escape from Heliodor dungeons and meeting Erik
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
    ('dungeon-region-----------------003', 'Heliodor Dungeons', 'คุกใต้ดินของ Heliodor ที่มืดมิดและน่ากลัว', '/images/regions/heliodor_dungeons.svg', '{"completed_events": ["heliodor-arrival-evt-------------013"]}', 3, false, true)
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
    ('prison-cell-a-loc----------------012', 'Heliodor Dungeons', 'Prison Cell A', 'ห้องขังของ Luminary ที่เย็นเหี่ยว', 'dungeon', '{}', 1, false, false),
    ('prison-cell-b-loc----------------013', 'Heliodor Dungeons', 'Prison Cell B', 'ห้องขังที่มี Erik อยู่', 'dungeon', '{"completed_events": ["dungeon-escape-evt----------------021"]}', 2, false, true),
    ('sewer-entrance-loc----------------014', 'Heliodor Dungeons', 'Sewer Entrance', 'ทางเข้าท่อระบายน้ำ ทางหนีลับ', 'dungeon', '{"completed_events": ["dungeon-escape-evt----------------022"]}', 3, false, true)
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
    ('dragon-quest-xi-ch-----------------003', 'dragon-quest-xi-act-----------------001', 3, 'The Great Escape', 'การหลบหนีจากคุก Heliodor พร้อมกับ Erik และการเริ่มต้นการเดินทางที่แท้จริง', '{"completed_chapters": ["dragon-quest-xi-ch-----------------002"]}', 3, false)
) AS chapter_info(code, act_code, chapter_number, title, description, unlock_requirements, display_order, is_initial_user_progress)
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
    ('erik-char-----------------------008', 'Erik', 'โจรหนุ่มที่ถูกขังในคุก Heliodor เชี่ยวชาญด้านการขโมยและมีดโยน', 'party_member', '/images/characters/erik.svg', '{"hp": 120, "mp": 60, "level": 1, "attack": 25, "defense": 10, "agility": 20, "luck": 15}', '["Dagger Throw", "Steal", "Critical Hit"]', true, false),
    ('prison-guard-char----------------009', 'Prison Guard', 'ยามคุก Heliodor ที่เข้มงวดและไร้ความปราณี', 'npc', '/images/characters/guard.svg', '{"hp": 100, "mp": 20, "level": 5}', '["Guard Strike"]', false, false)
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
    ('prison-key-item-------------------011', 'Prison Key', 'กุญแจคุกที่ Erik ขโมยมาได้', 'key_item', 'rare', '{}', '{"unlock": "prison_door"}', '/images/items/prison_key.svg', false),
    ('erik-dagger-item------------------012', 'Erik''s Dagger', 'มีดโยนของ Erik อาวุธที่คมกริบ', 'weapon', 'uncommon', '{"attack": 15, "critical": 20}', '{}', '/images/items/dagger.svg', false),
    ('prison-clothes-item----------------013', 'Prison Clothes', 'เสื้อผ้านักโทษที่ขาดความสง่า', 'armor', 'common', '{"defense": 3}', '{}', '/images/items/prison_clothes.svg', false)
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
    ('dungeon-escape-evt----------------021', 'The Great Escape', 'Prison Cell A', 'Imprisoned', 'Luminary ตื่นขึ้นในห้องขังที่มืดมิด', 'story', '{"completed_chapters": ["dragon-quest-xi-ch-----------------002"]}', 1, false),
    ('dungeon-escape-evt----------------022', 'The Great Escape', 'Prison Cell B', 'Meeting Erik', 'การพบกับ Erik และการวางแผนหลบหนี', 'dialogue', '{"completed_events": ["dungeon-escape-evt----------------021"]}', 2, false),
    ('dungeon-escape-evt----------------023', 'The Great Escape', 'Sewer Entrance', 'The Escape', 'การหลบหนีจากคุกผ่านท่อระบายน้ำ', 'action', '{"completed_events": ["dungeon-escape-evt----------------022"]}', 3, false)
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
    ('waking-up-int-------------------030', 'Imprisoned', 'story', 'Waking Up', 'ตื่นขึ้นในคุกที่มืดมิด', 'Luminary ตื่นขึ้นในห้องขังที่เย็นเหี่ยว... นี่คือความมืดที่แท้จริง', 'Narrator', '[]', '{}', 1),
    ('talk-to-erik-int-----------------031', 'Meeting Erik', 'talk', 'Talk to Erik', 'พูดคุยกับ Erik ในห้องขังข้างๆ', 'เฮ้! นายใหม่ใช่ไหม? ฉันชื่อ Erik นายถูกจับมาทำไม?', 'Erik', '[{"id": "darkspawn", "text": "พวกเขาว่าผมเป็น Darkspawn", "type": "explain"}, {"id": "confused", "text": "ผมไม่รู้ว่าเกิดอะไรขึ้น", "type": "confused"}]', '{}', 1),
    ('escape-plan-int------------------032', 'The Escape', 'action', 'Escape Plan', 'ดำเนินการตามแผนหลบหนี', 'Erik นำทางผ่านท่อระบายน้ำ "ตามฉันมา! เราจะออกไปจากที่นี่!"', 'Erik', '[]', '{}', 1)
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
    ('erik-understanding-outcome---------030', 'Talk to Erik', 'darkspawn', 'story', 'Erik''s Understanding', 'Erik พยักหน้า "Darkspawn? นั่นมันเรื่องไร้สาระ! เราต้องหนีจากที่นี่"', '{"relationship": {"erik": 10}, "experience": 20}', 'The Escape'),
    ('erik-sympathy-outcome--------------031', 'Talk to Erik', 'confused', 'story', 'Erik''s Sympathy', 'Erik ยิ้มเศร้า "ฉันเข้าใจ ที่นี่ทำให้คนสับสน แต่เราต้องออกไป"', '{"relationship": {"erik": 8}, "experience": 15}', 'The Escape'),
    ('freedom-achieved-outcome-----------032', 'Escape Plan', 'default', 'unlock', 'Freedom Achieved', 'Erik และ Luminary หลบหนีสำเร็จ! การเดินทางที่แท้จริงเริ่มต้นขึ้น', '{"party_joins": ["erik-char-----------------------008"], "items": [{"code": "erik-dagger-item------------------012", "quantity": 1}], "experience": 100, "unlock_regions": ["dungeon-region-loc----------------004"]}', null)
) AS outcome_info(code, interaction_title, choice_key, outcome_type, title, description, effects, next_event_title)
LEFT JOIN story_events se_next ON se_next.title = outcome_info.next_event_title
WHERE ei.title = outcome_info.interaction_title;
