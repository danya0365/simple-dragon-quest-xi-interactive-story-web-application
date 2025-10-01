-- Dragon Quest XI Story Data Seed - Chapter 4: The Desert Kingdom
-- Created: 2025-09-26
-- Author: Marosdee Uma
-- Description: Chapter 4 - The journey to Gallopolis, the desert kingdom of horse racing
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
    ('gallopolis-region-loc----------------004', 'Gallopolis', 'เมืองแห่งการแข่งม้าและวัฒนธรรมการต่อสู้ในทะเลทราย', '/images/regions/gallopolis.svg', '{"completed_events": ["dungeon-escape-evt----------------023"]}', 4, false, true)
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
    ('gallopolis-town-loc----------------015', 'Gallopolis', 'Gallopolis Town', 'เมืองที่เต็มไปด้วยวัฒนธรรมการแข่งม้า', 'town', '{}', 1, false, false),
    ('royal-stables-loc------------------016', 'Gallopolis', 'Royal Stables', 'โรงม้าหลวงที่สวยงาม', 'stable', '{"completed_events": ["gallopolis-arrival-evt----------------031"]}', 2, false, true),
    ('gallopolis-arena-loc----------------017', 'Gallopolis', 'Gallopolis Arena', 'สนามประลองที่โด่งดังทั่วโลก', 'arena', '{"completed_events": ["gallopolis-arrival-evt----------------032"]}', 3, false, true)
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
    ('dragon-quest-xi-ch-----------------004', 'DRAGON-QUEST-XI-ACT----------------001', 4, 'The Desert Kingdom', 'การมาถึง Gallopolis เมืองแห่งการแข่งม้าและการต่อสู้ที่โด่งดัง', '{"completed_chapters": ["dragon-quest-xi-ch-----------------003"]}', 4, false)
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
    ('prince-faris-char------------------010', 'Prince Faris', 'เจ้าชายของ Gallopolis ผู้รักการแข่งม้าและการต่อสู้', 'npc', '/images/characters/prince_faris.svg', '{"hp": 200, "mp": 80, "level": 12}', '["Royal Command", "Horse Mastery"]', false, false),
    ('sylvando-char---------------------011', 'Sylvando', 'นักแสดงสุดหล่อผู้มีความสามารถในการต่อสู้และความบันเทิง', 'party_member', '/images/characters/sylvando.svg', '{"hp": 130, "mp": 90, "level": 1, "attack": 18, "defense": 14, "agility": 16, "luck": 20}', '["Pink Tornado", "Charm"]', true, false),
    ('arena-master-char------------------012', 'Arena Master', 'ผู้ดูแลสนามประลองของ Gallopolis', 'npc', '/images/characters/arena_master.svg', '{"hp": 150, "mp": 50, "level": 10}', '["Arena Rules"]', false, false)
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
    ('desert-sword-item------------------014', 'Desert Sword', 'ดาบทะเลทรายที่แข็งแรงและคมกริบ', 'weapon', 'rare', '{"attack": 28, "accuracy": 95}', '{}', '/images/items/desert_sword.svg', false),
    ('champion-medal-item----------------015', 'Champion''s Medal', 'เหรียญแชมป์เปี้ยนจากสนามประลอง Gallopolis', 'key_item', 'legendary', '{}', '{"prestige": 50}', '/images/items/champion_medal.svg', false),
    ('desert-robes-item------------------016', 'Desert Robes', 'เสื้อคลุมทะเลทรายที่ป้องกันแสงแดด', 'armor', 'uncommon', '{"defense": 18, "heat_resistance": 20}', '{}', '/images/items/desert_robes.svg', false)
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
    ('gallopolis-arrival-evt----------------031', 'The Desert Kingdom', 'Gallopolis Town', 'Arrival at Gallopolis', 'การมาถึงเมืองทะเลทราย Gallopolis', 'exploration', '{"completed_chapters": ["dragon-quest-xi-ch-----------------003"]}', 1, false),
    ('gallopolis-arrival-evt----------------032', 'The Desert Kingdom', 'Royal Stables', 'Meeting the Horses', 'การพบกับม้าที่สวยงามในโรงม้าหลวง', 'exploration', '{"completed_events": ["gallopolis-arrival-evt----------------031"]}', 2, false),
    ('gallopolis-arrival-evt----------------033', 'The Desert Kingdom', 'Gallopolis Arena', 'Arena Challenge', 'การท้าทายในสนามประลองที่ยิ่งใหญ่', 'action', '{"completed_events": ["gallopolis-arrival-evt----------------032"]}', 3, false)
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
    ('observe-desert-int-----------------040', 'Arrival at Gallopolis', 'examine', 'Observe Desert City', 'สำรวจเมืองทะเลทรายที่มีสีสันและคึกคัก', 'เมือง Gallopolis สวยงามท่ามกลางทะเลทราย! สถาปัตยกรรมแบบอาหรับที่งดงาม', 'Narrator', '[]', '{}', 1),
    ('talk-to-stable-int-----------------041', 'Meeting the Horses', 'talk', 'Talk to Stable Master', 'พูดคุยกับผู้ดูแลโรงม้า', 'ยินดีต้อนรับสู่โรงม้าหลวง! ม้าเหล่านี้เป็นม้าที่ดีที่สุดในอาณาจักร', 'Stable Master', '[{"id": "interested", "text": "สนใจม้ามาก", "type": "positive"}, {"id": "racing", "text": "อยากลองแข่งม้า", "type": "quest"}]', '{}', 1),
    ('enter-arena-int-------------------042', 'Arena Challenge', 'choice', 'Enter Arena', 'เข้าสู่สนามประลองเพื่อพิสูจน์ความสามารถ', 'ยินดีต้อนรับสู่สนามประลอง Gallopolis! ท่านพร้อมที่จะพิสูจน์ตัวเองหรือไม่?', 'Arena Master', '[{"id": "accept", "text": "ผมพร้อมแล้ว!", "type": "brave"}, {"id": "hesitate", "text": "ให้ผมเตรียมตัวก่อน", "type": "cautious"}]', '{}', 1)
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
    ('horse-knowledge-outcome--------------040', 'Talk to Stable Master', 'interested', 'story', 'Horse Knowledge', 'ผู้ดูแลโรงม้ายิ้ม "ม้าเหล่านี้ได้รับการฝึกมาอย่างดี"', '{"experience": 15}', 'Arena Challenge'),
    ('racing-interest-outcome--------------041', 'Talk to Stable Master', 'racing', 'story', 'Racing Interest', 'ผู้ดูแลโรงม้าตื่นเต้น "ถ้าอยากแข่ง ไปที่สนามประลองสิ!"', '{"experience": 20}', 'Arena Challenge'),
    ('arena-victory-outcome----------------042', 'Enter Arena', 'accept', 'reward', 'Arena Victory', 'Luminary ชนะการต่อสู้ในสนามประลอง! ได้รับการยอมรับจากผู้คน', '{"experience": 100, "items": [{"code": "gallopolis-medal-item----------------015", "quantity": 1}], "party_joins": ["gemma-char-----------------------011"], "unlock_regions": ["gallopolis-arena-loc----------------005"]}', null),
    ('preparation-time-outcome-------------043', 'Enter Arena', 'hesitate', 'story', 'Preparation Time', 'Arena Master พยักหน้า "ไม่เป็นไร เตรียมตัวให้ดีแล้วค่อยมา"', '{"experience": 30}', null)
) AS outcome_info(code, interaction_title, choice_key, outcome_type, title, description, effects, next_event_title)
LEFT JOIN story_events se_next ON se_next.title = outcome_info.next_event_title
WHERE ei.title = outcome_info.interaction_title;
