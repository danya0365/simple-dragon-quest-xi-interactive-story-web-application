-- Dragon Quest XI Story Data Seed - Chapter 2: The Fall from Grace
-- Created: 2025-09-26
-- Author: Marosdee Uma
-- Description: Chapter 2 - The journey to Heliodor and the false accusation as Darkspawn
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
    ('heliodor-region-----------------001', 'Heliodor', 'เมืองหลวงของอาณาจักร Heliodor ที่ยิ่งใหญ่และเจริญรุ่งเรือง', '/images/regions/heliodor.svg', '{"completed_events": ["luminary-awakening-evt-----------005"]}', 2, false, true)
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
    ('heliodor-town-loc----------------007', 'Heliodor', 'Heliodor Town', 'เมืองใหญ่ที่คึกคักและมีชีวิตชีวา', 'town', '{}', 1, false, false),
    ('heliodor-castle-loc---------------008', 'Heliodor', 'Heliodor Castle', 'ปราสาทของกษัตริย์ Carnelian', 'castle', '{"completed_events": ["heliodor-arrival-evt-------------011"]}', 2, false, true),
    ('throne-room-loc-------------------009', 'Heliodor', 'Throne Room', 'ห้องบัลลังก์ที่ยิ่งใหญ่', 'throne_room', '{"completed_events": ["heliodor-arrival-evt-------------012"]}', 3, false, true)
) AS location_info(code, region_name, name, description, location_type, unlock_requirements, display_order, is_initial_user_progress, is_alway_hide_until_unlock)
WHERE wr.name = location_info.region_name;

-- === STORY CHAPTERS ===
INSERT INTO public.story_chapters (id, code, chapter_number, title, description, unlock_requirements, display_order, is_initial_user_progress, act_id)
SELECT 
  uuid_generate_v5(uuid_nil(), chapter_info.code),
  chapter_info.code,
  chapter_info.chapter_number,
  chapter_info.title,
  chapter_info.description,
  chapter_info.unlock_requirements::jsonb,
  chapter_info.display_order,
  chapter_info.is_initial_user_progress,
  sa.id AS act_id
FROM (
  VALUES 
    ('dragon-quest-xi-ch-----------------002', 2, 'The Fall from Grace', 'การเดินทางไปยัง Heliodor และการถูกกล่าวหาว่าเป็น Darkspawn', '{"completed_chapters": ["dragon-quest-xi-ch-----------------001"]}', 2, false, 'dragon-quest-xi-act-----------------001')
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
    ('king-carnelian-char----------------006', 'King Carnelian', 'กษัตริย์แห่ง Heliodor ผู้เชื่อว่า Luminary คือ Darkspawn', 'npc', '/images/characters/king_carnelian.svg', '{"hp": 300, "mp": 150, "level": 20}', '["Royal Decree"]', false, false),
    ('jasper-char-----------------------007', 'Jasper', 'นายพลของ Heliodor ผู้ภักดีต่อกษัตริย์', 'npc', '/images/characters/jasper.svg', '{"hp": 250, "mp": 100, "level": 15}', '["Dark Blade"]', false, false)
) AS character_info(code, name, description, character_type, avatar_url, stats, abilities, is_joinable, is_initial_user_progress);

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
    ('heliodor-arrival-evt-------------011', 'The Fall from Grace', 'Heliodor Town', 'Arrival at Heliodor', 'การมาถึงเมืองหลวง Heliodor', 'exploration', '{"completed_chapters": ["dragon-quest-xi-ch-----------------001"]}', 1, false),
    ('heliodor-arrival-evt-------------012', 'The Fall from Grace', 'Heliodor Castle', 'Meeting the King', 'การพบกับกษัตริย์ Carnelian', 'dialogue', '{"completed_events": ["heliodor-arrival-evt-------------011"]}', 2, false),
    ('heliodor-arrival-evt-------------013', 'The Fall from Grace', 'Throne Room', 'The Accusation', 'การถูกกล่าวหาว่าเป็น Darkspawn', 'story', '{"completed_events": ["heliodor-arrival-evt-------------012"]}', 3, false)
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
    ('observe-city-int------------------020', 'Arrival at Heliodor', 'examine', 'Observe the City', 'สำรวจเมืองหลวง Heliodor ที่ยิ่งใหญ่', 'เมืองหลวง Heliodor ใหญ่โตและคึกคักเหลือเกิน!', 'Narrator', '[]', '{}', 1),
    ('speak-to-king-int----------------021', 'Meeting the King', 'talk', 'Speak to King', 'พูดกับกษัตริย์ Carnelian', 'ข้าได้ยินมาว่าเจ้าอ้างว่าตัวเองเป็น Luminary...', 'King Carnelian', '[{"id": "show_mark", "text": "แสดงเครื่องหมายศักดิ์สิทธิ์", "type": "reveal"}]', '{}', 1),
    ('dark-revelation-int----------------022', 'The Accusation', 'story', 'Dark Revelation', 'การเปิดเผยความจริงที่น่าตกใจ', 'นี่คือเครื่องหมายของ Darkspawn! เจ้าไม่ใช่ Luminary!', 'King Carnelian', '[]', '{}', 1)
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
    ('mark-revealed-outcome----------------020', 'Speak to King', 'show_mark', 'story', 'Mark Revealed', 'Luminary แสดงเครื่องหมาย แต่แสงที่ออกมาเป็นสีมืด!', '{"experience": 30}', 'The Accusation'),
    ('imprisoned-darkspawn-outcome----------021', 'Dark Revelation', 'default', 'unlock', 'Imprisoned as Darkspawn', 'Luminary ถูกจับและขังในคุก ถูกกล่าวหาว่าเป็น Darkspawn', '{"experience": 50, "unlock_regions": ["dungeon-region-----------------003"]}', null)
) AS outcome_info(code, interaction_title, choice_key, outcome_type, title, description, effects, next_event_title)
LEFT JOIN story_events se_next ON se_next.title = outcome_info.next_event_title
WHERE ei.title = outcome_info.interaction_title;
