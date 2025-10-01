-- Dragon Quest XI Story Data Seed - Chapter 2: The Fall from Grace
-- Created: 2025-09-26
-- Author: Marosdee Uma
-- Description: Chapter 2 - The journey to Heliodor and the false accusation as Darkspawn
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
    ('11111111-1111-1111-1111-111111111002', 'Heliodor', 'เมืองหลวงของอาณาจักร Heliodor ที่ยิ่งใหญ่และเจริญรุ่งเรือง', '/images/regions/heliodor.svg', '{"completed_events": ["66666666-6666-6666-6666-666666666005"]}', 2, false, true)
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
    ('22222222-2222-2222-2222-222222222007', 'Heliodor', 'Heliodor Town', 'เมืองใหญ่ที่คึกคักและมีชีวิตชีวา', 'town', '{}', 1, false, false),
    ('22222222-2222-2222-2222-222222222008', 'Heliodor', 'Heliodor Castle', 'ปราสาทของกษัตริย์ Carnelian', 'castle', '{"completed_events": ["66666666-6666-6666-6666-666666666011"]}', 2, false, true),
    ('22222222-2222-2222-2222-222222222009', 'Heliodor', 'Throne Room', 'ห้องบัลลังก์ที่ยิ่งใหญ่', 'throne_room', '{"completed_events": ["66666666-6666-6666-6666-666666666012"]}', 3, false, true)
) AS location_info(id, region_name, name, description, location_type, unlock_requirements, display_order, is_initial_user_progress, is_alway_hide_until_unlock)
WHERE wr.name = location_info.region_name;

-- === STORY CHAPTERS ===
INSERT INTO public.story_chapters (id, chapter_number, title, description, unlock_requirements, display_order, is_initial_user_progress, act_id)
SELECT 
  chapter_info.id::uuid,
  chapter_info.chapter_number,
  chapter_info.title,
  chapter_info.description,
  chapter_info.unlock_requirements::jsonb,
  chapter_info.display_order,
  chapter_info.is_initial_user_progress,
  chapter_info.act_id::uuid
FROM (
  VALUES 
    ('33333333-3333-3333-3333-333333333002', 2, 'The Fall from Grace', 'การเดินทางไปยัง Heliodor และการถูกกล่าวหาว่าเป็น Darkspawn', '{"completed_chapters": ["33333333-3333-3333-3333-333333333001"]}', 2, false, '11111111-1111-1111-1111-111111111001')
) AS chapter_info(id, chapter_number, title, description, unlock_requirements, display_order, is_initial_user_progress, act_id);

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
    ('44444444-4444-4444-4444-444444444006', 'King Carnelian', 'กษัตริย์แห่ง Heliodor ผู้เชื่อว่า Luminary คือ Darkspawn', 'npc', '/images/characters/king_carnelian.svg', '{"hp": 300, "mp": 150, "level": 20}', '["Royal Decree"]', false, false),
    ('44444444-4444-4444-4444-444444444007', 'Jasper', 'นายพลของ Heliodor ผู้ภักดีต่อกษัตริย์', 'npc', '/images/characters/jasper.svg', '{"hp": 250, "mp": 100, "level": 15}', '["Dark Blade"]', false, false)
) AS character_info(id, name, description, character_type, avatar_url, stats, abilities, is_joinable, is_initial_user_progress);

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
    ('66666666-6666-6666-6666-666666666011', 'The Fall from Grace', 'Heliodor Town', 'Arrival at Heliodor', 'การมาถึงเมืองหลวง Heliodor', 'exploration', '{"completed_chapters": ["33333333-3333-3333-3333-333333333001"]}', 1, false),
    ('66666666-6666-6666-6666-666666666012', 'The Fall from Grace', 'Heliodor Castle', 'Meeting the King', 'การพบกับกษัตริย์ Carnelian', 'dialogue', '{"completed_events": ["66666666-6666-6666-6666-666666666011"]}', 2, false),
    ('66666666-6666-6666-6666-666666666013', 'The Fall from Grace', 'Throne Room', 'The Accusation', 'การถูกกล่าวหาว่าเป็น Darkspawn', 'story', '{"completed_events": ["66666666-6666-6666-6666-666666666012"]}', 3, false)
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
    ('77777777-7777-7777-7777-777777777020', 'Arrival at Heliodor', 'examine', 'Observe the City', 'สำรวจเมืองหลวง Heliodor ที่ยิ่งใหญ่', 'เมืองหลวง Heliodor ใหญ่โตและคึกคักเหลือเกิน!', 'Narrator', '[]', '{}', 1),
    ('77777777-7777-7777-7777-777777777021', 'Meeting the King', 'talk', 'Speak to King', 'พูดกับกษัตริย์ Carnelian', 'ข้าได้ยินมาว่าเจ้าอ้างว่าตัวเองเป็น Luminary...', 'King Carnelian', '[{"id": "show_mark", "text": "แสดงเครื่องหมายศักดิ์สิทธิ์", "type": "reveal"}]', '{}', 1),
    ('77777777-7777-7777-7777-777777777022', 'The Accusation', 'story', 'Dark Revelation', 'การเปิดเผยความจริงที่น่าตกใจ', 'นี่คือเครื่องหมายของ Darkspawn! เจ้าไม่ใช่ Luminary!', 'King Carnelian', '[]', '{}', 1)
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
    ('88888888-8888-8888-8888-888888888020', 'Speak to King', 'show_mark', 'story', 'Mark Revealed', 'Luminary แสดงเครื่องหมาย แต่แสงที่ออกมาเป็นสีมืด!', '{"experience": 30}', 'The Accusation'),
    ('88888888-8888-8888-8888-888888888021', 'Dark Revelation', 'default', 'unlock', 'Imprisoned as Darkspawn', 'Luminary ถูกจับและขังในคุก ถูกกล่าวหาว่าเป็น Darkspawn', '{"experience": 50, "unlock_regions": ["11111111-1111-1111-1111-111111111003"]}', null)
) AS outcome_info(id, interaction_title, choice_key, outcome_type, title, description, effects, next_event_title)
LEFT JOIN story_events se_next ON se_next.title = outcome_info.next_event_title
WHERE ei.title = outcome_info.interaction_title;
