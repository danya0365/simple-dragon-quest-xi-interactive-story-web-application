-- Dragon Quest XI Story Data Seed - Chapter 8: The Frozen Citadel
-- Created: 2025-09-26
-- Author: Marosdee Uma
-- Description: Chapter 8 - The journey to Sniflheim, the frozen kingdom
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
    ('11111111-1111-1111-1111-111111111008', 'Sniflheim', 'ดินแดนแห่งน้ำแข็งและหิมะที่เย็นเหน็บและเต็มไปด้วยความลึกลับ', '/images/regions/sniflheim.svg', '{"completed_events": ["66666666-6666-6666-6666-666666666063"]}', 8, false, true)
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
    ('22222222-2222-2222-2222-222222222027', 'Sniflheim', 'Frozen Wasteland', 'ที่ราบน้ำแข็งที่กว้างใหญ่และเย็นเหน็บ', 'wasteland', '{}', 1, false, false),
    ('22222222-2222-2222-2222-222222222028', 'Sniflheim', 'Ice Palace', 'พระราชวังน้ำแข็งที่สวยงามแต่เย็นเยียบ', 'palace', '{"completed_events": ["66666666-6666-6666-6666-666666666071"]}', 2, false, true),
    ('22222222-2222-2222-2222-222222222029', 'Sniflheim', 'Crystal Caverns', 'ถ้ำคริสตัลที่เต็มไปด้วยน้ำแข็งและแสงระยิบระยับ', 'cavern', '{"completed_events": ["66666666-6666-6666-6666-666666666072"]}', 3, false, true)
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
    ('33333333-3333-3333-3333-333333333008', 8, 'The Frozen Citadel', 'การเดินทางสู่ Sniflheim ดินแดนแห่งน้ำแข็งและการเผชิญหน้ากับความหนาวเหน็บ', '{"completed_chapters": ["33333333-3333-3333-3333-333333333007"]}', 8, false)
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
    ('44444444-4444-4444-4444-444444444022', 'Hendrik', 'อัศวินผู้ยิ่งใหญ่ที่เคยเป็นศัตรู แต่ตอนนี้เป็นพันธมิตร', 'party_member', '/images/characters/hendrik.svg', '{"hp": 180, "mp": 60, "level": 1, "attack": 28, "defense": 35, "agility": 8, "luck": 10}', '["Sword Mastery", "Shield Wall", "Noble Strike"]', true, false),
    ('44444444-4444-4444-4444-444444444023', 'Ice Queen', 'ราชินีแห่งน้ำแข็งผู้ปกครอง Sniflheim ด้วยความเย็นชา', 'npc', '/images/characters/ice_queen.svg', '{"hp": 400, "mp": 350, "level": 45}', '["Absolute Zero", "Ice Storm", "Frozen Heart"]', false, false),
    ('44444444-4444-4444-4444-444444444024', 'Frost Giant', 'ยักษ์น้ำแข็งที่ปกป้องดินแดนแห่งความหนาวเหน็บ', 'npc', '/images/characters/frost_giant.svg', '{"hp": 300, "mp": 100, "level": 25}', '["Ice Punch", "Blizzard Breath"]', false, false)
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
    ('55555555-5555-5555-5555-555555555026', 'Frost Blade', 'ดาบน้ำแข็งที่มีพลังแห่งความหนาวเหน็บ', 'weapon', 'rare', '{"attack": 35, "ice_power": 25}', '{"freeze_chance": 30}', '/images/items/frost_blade.svg', false),
    ('55555555-5555-5555-5555-555555555027', 'Crystal of Eternal Ice', 'คริสตัลน้ำแข็งนิรันดร์ที่ไม่เคยละลาย', 'key_item', 'legendary', '{}', '{"eternal_cold": true, "ice_immunity": true}', '/images/items/ice_crystal.svg', false),
    ('55555555-5555-5555-5555-555555555028', 'Winter Cloak', 'เสื้อคลุมฤดูหนาวที่ป้องกันความหนาวเย็น', 'armor', 'uncommon', '{"defense": 25, "cold_resistance": 40}', '{"warmth": true}', '/images/items/winter_cloak.svg', false)
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
    ('66666666-6666-6666-6666-666666666071', 'The Frozen Citadel', 'Frozen Wasteland', 'Journey Through Ice', 'การเดินทางผ่านที่ราบน้ำแข็งที่เย็นเหน็บ', 'exploration', '{"completed_chapters": ["33333333-3333-3333-3333-333333333007"]}', 1, false),
    ('66666666-6666-6666-6666-666666666072', 'The Frozen Citadel', 'Ice Palace', 'The Ice Queen''s Challenge', 'การเผชิญหน้ากับราชินีแห่งน้ำแข็ง', 'boss_battle', '{"completed_events": ["66666666-6666-6666-6666-666666666071"]}', 2, false),
    ('66666666-6666-6666-6666-666666666073', 'The Frozen Citadel', 'Crystal Caverns', 'The Crystal Heart', 'การค้นหาหัวใจคริสตัลในถ้ำลึก', 'quest', '{"completed_events": ["66666666-6666-6666-6666-666666666072"]}', 3, false)
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
    ('77777777-7777-7777-7777-777777777080', 'Journey Through Ice', 'examine', 'Observe Frozen Land', 'สำรวจดินแดนที่ปกคลุมไปด้วยน้ำแข็ง', 'ดินแดนนี้หนาวเหน็บมาก! ทุกอย่างปกคลุมไปด้วยน้ำแข็งและหิมะ', 'Narrator', '[]', '{}', 1),
    ('77777777-7777-7777-7777-777777777081', 'The Ice Queen''s Challenge', 'battle', 'Confront Ice Queen', 'เผชิญหน้ากับราชินีแห่งน้ำแข็ง', 'ใครกล้ามาท้าทายข้าในดินแดนแห่งน้ำแข็ง! เจ้าจะต้องแข็งตัวไปตลอดกาล!', 'Ice Queen', '[{"id": "fight", "text": "ผมจะหยุดคุณ!", "type": "heroic"}, {"id": "reason", "text": "เราไม่จำเป็นต้องสู้กัน", "type": "peaceful"}]', '{}', 1),
    ('77777777-7777-7777-7777-777777777082', 'The Crystal Heart', 'quest', 'Search for Crystal', 'ค้นหาหัวใจคริสตัลในถ้ำ', 'หัวใจคริสตัลซ่อนอยู่ในส่วนลึกของถ้ำ... แต่มีอันตรายรออยู่', 'Narrator', '[{"id": "careful", "text": "เดินอย่างระมัดระวัง", "type": "cautious"}, {"id": "rush", "text": "รีบไปให้เร็ว", "type": "hasty"}]', '{}', 1)
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
    ('88888888-8888-8888-8888-888888888080', 'Confront Ice Queen', 'fight', 'reward', 'Ice Queen Defeated', 'Luminary เอาชนะราชินีแห่งน้ำแข็ง! ความหนาวเหน็บเริ่มลดลง', '{"experience": 300, "items": [{"id": "55555555-5555-5555-5555-555555555026", "quantity": 1}], "party_joins": ["44444444-4444-4444-4444-444444444022"]}', 'The Crystal Heart'),
    ('88888888-8888-8888-8888-888888888081', 'Confront Ice Queen', 'reason', 'story', 'Peaceful Resolution', 'ราชินีแห่งน้ำแข็งเข้าใจและยอมช่วยเหลือ Luminary', '{"experience": 250, "items": [{"id": "55555555-5555-5555-5555-555555555027", "quantity": 1}], "party_joins": ["44444444-4444-4444-4444-444444444022"]}', 'The Crystal Heart'),
    ('88888888-8888-8888-8888-888888888082', 'Search for Crystal', 'careful', 'reward', 'Crystal Found Safely', 'ความระมัดระวังทำให้ Luminary หาหัวใจคริสตัลได้อย่างปลอดภัย', '{"experience": 200, "items": [{"id": "55555555-5555-5555-5555-555555555027", "quantity": 1}], "unlock_regions": ["11111111-1111-1111-1111-111111111009"]}', null),
    ('88888888-8888-8888-8888-888888888083', 'Search for Crystal', 'rush', 'story', 'Dangerous Discovery', 'การรีบร้อนทำให้เกิดอันตราย แต่ก็ได้หัวใจคริสตัลมา', '{"experience": 150, "items": [{"id": "55555555-5555-5555-5555-555555555027", "quantity": 1}], "unlock_regions": ["11111111-1111-1111-1111-111111111009"]}', null)
) AS outcome_info(id, interaction_title, choice_key, outcome_type, title, description, effects, next_event_title)
LEFT JOIN story_events se_next ON se_next.title = outcome_info.next_event_title
WHERE ei.title = outcome_info.interaction_title;
