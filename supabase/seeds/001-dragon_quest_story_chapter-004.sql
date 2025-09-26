-- Dragon Quest XI Story Data Seed - Chapter 4: The Desert Kingdom
-- Created: 2025-09-26
-- Author: Marosdee Uma
-- Description: Chapter 4 - The journey to Gallopolis, the desert kingdom of horse racing
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
    ('11111111-1111-1111-1111-111111111004', 'Gallopolis', 'เมืองแห่งการแข่งม้าและวัฒนธรรมการต่อสู้ในทะเลทราย', '/images/regions/gallopolis.svg', '{"completed_events": ["66666666-6666-6666-6666-666666666023"]}', 4, false, true)
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
    ('22222222-2222-2222-2222-222222222015', 'Gallopolis', 'Gallopolis Town', 'เมืองที่เต็มไปด้วยวัฒนธรรมการแข่งม้า', 'town', '{}', 1, false, false),
    ('22222222-2222-2222-2222-222222222016', 'Gallopolis', 'Royal Stables', 'โรงม้าหลวงที่สวยงาม', 'stable', '{"completed_events": ["66666666-6666-6666-6666-666666666031"]}', 2, false, true),
    ('22222222-2222-2222-2222-222222222017', 'Gallopolis', 'Gallopolis Arena', 'สนามประลองที่โด่งดังทั่วโลก', 'arena', '{"completed_events": ["66666666-6666-6666-6666-666666666032"]}', 3, false, true)
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
    ('33333333-3333-3333-3333-333333333004', 4, 'The Desert Kingdom', 'การมาถึง Gallopolis เมืองแห่งการแข่งม้าและการต่อสู้ที่โด่งดัง', '{"completed_chapters": ["33333333-3333-3333-3333-333333333003"]}', 4, false)
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
    ('44444444-4444-4444-4444-444444444010', 'Prince Faris', 'เจ้าชายของ Gallopolis ผู้รักการแข่งม้าและการต่อสู้', 'npc', '/images/characters/prince_faris.svg', '{"hp": 200, "mp": 80, "level": 12}', '["Royal Command", "Horse Mastery"]', false, false),
    ('44444444-4444-4444-4444-444444444011', 'Sylvando', 'นักแสดงสุดหล่อผู้มีความสามารถในการต่อสู้และความบันเทิง', 'party_member', '/images/characters/sylvando.svg', '{"hp": 130, "mp": 90, "level": 1, "attack": 18, "defense": 14, "agility": 16, "luck": 20}', '["Pink Tornado", "Charm"]', true, false),
    ('44444444-4444-4444-4444-444444444012', 'Arena Master', 'ผู้ดูแลสนามประลองของ Gallopolis', 'npc', '/images/characters/arena_master.svg', '{"hp": 150, "mp": 50, "level": 10}', '["Arena Rules"]', false, false)
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
    ('55555555-5555-5555-5555-555555555014', 'Desert Sword', 'ดาบทะเลทรายที่แข็งแรงและคมกริบ', 'weapon', 'rare', '{"attack": 28, "accuracy": 95}', '{}', '/images/items/desert_sword.svg', false),
    ('55555555-5555-5555-5555-555555555015', 'Champion''s Medal', 'เหรียญแชมป์เปี้ยนจากสนามประลอง Gallopolis', 'key_item', 'legendary', '{}', '{"prestige": 50}', '/images/items/champion_medal.svg', false),
    ('55555555-5555-5555-5555-555555555016', 'Desert Robes', 'เสื้อคลุมทะเลทรายที่ป้องกันแสงแดด', 'armor', 'uncommon', '{"defense": 18, "heat_resistance": 20}', '{}', '/images/items/desert_robes.svg', false)
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
    ('66666666-6666-6666-6666-666666666031', 'The Desert Kingdom', 'Gallopolis Town', 'Arrival at Gallopolis', 'การมาถึงเมืองทะเลทราย Gallopolis', 'exploration', '{"completed_chapters": ["33333333-3333-3333-3333-333333333003"]}', 1, false),
    ('66666666-6666-6666-6666-666666666032', 'The Desert Kingdom', 'Royal Stables', 'Meeting the Horses', 'การพบกับม้าที่สวยงามในโรงม้าหลวง', 'exploration', '{"completed_events": ["66666666-6666-6666-6666-666666666031"]}', 2, false),
    ('66666666-6666-6666-6666-666666666033', 'The Desert Kingdom', 'Gallopolis Arena', 'Arena Challenge', 'การท้าทายในสนามประลองที่ยิ่งใหญ่', 'action', '{"completed_events": ["66666666-6666-6666-6666-666666666032"]}', 3, false)
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
    ('77777777-7777-7777-7777-777777777040', 'Arrival at Gallopolis', 'examine', 'Observe Desert City', 'สำรวจเมืองทะเลทรายที่มีสีสันและคึกคัก', 'เมือง Gallopolis สวยงามท่ามกลางทะเลทราย! สถาปัตยกรรมแบบอาหรับที่งดงาม', 'Narrator', '[]', '{}', 1),
    ('77777777-7777-7777-7777-777777777041', 'Meeting the Horses', 'talk', 'Talk to Stable Master', 'พูดคุยกับผู้ดูแลโรงม้า', 'ยินดีต้อนรับสู่โรงม้าหลวง! ม้าเหล่านี้เป็นม้าที่ดีที่สุดในอาณาจักร', 'Stable Master', '[{"id": "interested", "text": "สนใจม้ามาก", "type": "positive"}, {"id": "racing", "text": "อยากลองแข่งม้า", "type": "quest"}]', '{}', 1),
    ('77777777-7777-7777-7777-777777777042', 'Arena Challenge', 'choice', 'Enter Arena', 'เข้าสู่สนามประลองเพื่อพิสูจน์ความสามารถ', 'ยินดีต้อนรับสู่สนามประลอง Gallopolis! ท่านพร้อมที่จะพิสูจน์ตัวเองหรือไม่?', 'Arena Master', '[{"id": "accept", "text": "ผมพร้อมแล้ว!", "type": "brave"}, {"id": "hesitate", "text": "ให้ผมเตรียมตัวก่อน", "type": "cautious"}]', '{}', 1)
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
LEFT JOIN story_events se_next ON se_next.title = outcome_info.next_event_title
CROSS JOIN (
  VALUES 
    ('88888888-8888-8888-8888-888888888040', 'Talk to Stable Master', 'interested', 'story', 'Horse Knowledge', 'ผู้ดูแลโรงม้ายิ้ม "ม้าเหล่านี้ได้รับการฝึกมาอย่างดี"', '{"experience": 15}', 'Arena Challenge'),
    ('88888888-8888-8888-8888-888888888041', 'Talk to Stable Master', 'racing', 'story', 'Racing Interest', 'ผู้ดูแลโรงม้าตื่นเต้น "ถ้าอยากแข่ง ไปที่สนามประลองสิ!"', '{"experience": 20}', 'Arena Challenge'),
    ('88888888-8888-8888-8888-888888888042', 'Enter Arena', 'accept', 'reward', 'Arena Victory', 'Luminary ชนะการต่อสู้ในสนามประลอง! ได้รับการยอมรับจากผู้คน', '{"experience": 100, "items": [{"id": "55555555-5555-5555-5555-555555555015", "quantity": 1}], "party_join": "44444444-4444-4444-4444-444444444011", "unlock_regions": ["11111111-1111-1111-1111-111111111005"]}', null),
    ('88888888-8888-8888-8888-888888888043', 'Enter Arena', 'hesitate', 'story', 'Preparation Time', 'Arena Master พยักหน้า "ไม่เป็นไร เตรียมตัวให้ดีแล้วค่อยมา"', '{"experience": 30}', null)
) AS outcome_info(id, interaction_title, choice_key, outcome_type, title, description, effects, next_event_title)
WHERE ei.title = outcome_info.interaction_title;
