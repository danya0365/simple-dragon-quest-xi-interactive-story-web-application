-- Dragon Quest XI Story Data Seed - Chapter 14: The New Beginning
-- Created: 2025-09-26
-- Author: Marosdee Uma
-- Description: Chapter 14 - Epilogue: The new beginning and legacy of the Luminary
-- Features: Basic structure following Dragon Quest XI post-game narrative

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
    ('world-of-peace-rg----------------------014', 'World of Peace', 'โลกที่เต็มไปด้วยสันติสุขหลังจากการขับไล่ความมืดไปตลอดกาล', '/images/regions/world_of_peace.svg', '{"completed_events": ["happily-ever-after-outcome--------------134"], "game_flags": {"married": true, "happy_ending": true}}', 14, false, true)
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
    ('memorial-garden-location----------------045', 'World of Peace', 'Memorial Garden', 'สวนรำลึกที่สร้างขึ้นเพื่อระลึกถึงการเดินทางของ Luminary', 'memorial', '{}', 1, false, false),
    ('hall-of-heroes-location------------------046', 'World of Peace', 'Hall of Heroes', 'หอเกียรติยศที่บันทึกเรื่องราวของ Luminary และเพื่อนๆ', 'hall', '{"completed_events": ["memorial-visit-evt-------------------131"]}', 2, false, true),
    ('futures-dawn-location-------------------047', 'World of Peace', 'Future''s Dawn', 'จุดที่มองเห็นอนาคตที่สดใสของโลก', 'viewpoint', '{"completed_events": ["heroes-hall-evt----------------------132"]}', 3, false, true)
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
FROM story_acts sa
CROSS JOIN (
  VALUES 
    ('new-beginning-ch-----------------------014', 14, 'The New Beginning', 'บทสุดท้าย: มรดกของ Luminary และการเริ่มต้นใหม่ของโลกที่เต็มไปด้วยสันติสุข', '{"completed_chapters": ["happily-ever-after-ch------------------013"], "game_flags": {"married": true, "happy_ending": true}}', 14, false, 'Epilogue')
) AS chapter_info(code, chapter_number, title, description, unlock_requirements, display_order, is_initial_user_progress, act_name)
WHERE sa.title = chapter_info.act_name;

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
    ('future-child-char----------------------040', 'Future Child', 'ลูกของ Luminary และ Gemma ที่จะเป็นความหวังของอนาคต', 'future', '/images/characters/future_child.svg', '{"hp": 50, "mp": 100, "level": 1}', '["Inherited Light", "Future Hope", "New Generation"]', false, false),
    ('chronicler-char-----------------------041', 'Chronicler', 'ผู้บันทึกประวัติศาสตร์ที่เขียนเรื่องราวของ Luminary', 'npc', '/images/characters/chronicler.svg', '{"hp": 100, "mp": 150, "level": 30}', '["History Recording", "Story Telling", "Memory Preservation"]', false, false),
    ('spirit-friends-char--------------------042', 'Spirit of All Friends', 'วิญญาณของเพื่อนๆ ทุกคนที่มาให้กำลังใจในวันสุดท้าย', 'spirit', '/images/characters/friends_spirit.svg', '{"hp": 999, "mp": 999, "level": 99}', '["Eternal Friendship", "Bonds Unbroken", "Love Everlasting"]', false, false)
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
    ('chronicle-luminary-item----------------044', 'Chronicle of the Luminary', 'หนังสือบันทึกเรื่องราวของ Luminary ที่จะส่งต่อให้คนรุ่นหลัง', 'key_item', 'legendary', '{}', '{"story_preservation": true, "legacy": 100, "inspiration": 100}', '/images/items/luminary_chronicle.svg', false),
    ('seed-new-hope-item--------------------045', 'Seed of New Hope', 'เมล็ดพันธุ์แห่งความหวังใหม่ที่จะเติบโตในอนาคต', 'key_item', 'legendary', '{}', '{"future_growth": true, "hope_eternal": true, "new_beginning": true}', '/images/items/hope_seed.svg', false),
    ('luminary-gift-item--------------------046', 'Luminary''s Final Gift', 'ของขวัญสุดท้ายจาก Luminary สำหรับโลกและผู้คนที่รัก', 'key_item', 'legendary', '{}', '{"eternal_blessing": true, "world_peace": true, "love_infinite": true}', '/images/items/final_gift.svg', false)
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
    ('memorial-visit-evt-------------------131', 'The New Beginning', 'Memorial Garden', 'Reflecting on the Journey', 'การมองย้อนกลับไปในการเดินทางที่ผ่านมา', 'reflection', '{"completed_chapters": ["new-beginning-ch-----------------------014"]}', 1, false),
    ('heroes-hall-evt----------------------132', 'The New Beginning', 'Hall of Heroes', 'Legacy Preserved', 'การบันทึกมรดกของ Luminary ไว้สำหรับอนาคต', 'legacy', '{"completed_events": ["memorial-visit-evt-------------------131"]}', 2, false),
    ('final-farewell-evt-------------------133', 'The New Beginning', 'Future''s Dawn', 'The Final Farewell', 'การอำลาครั้งสุดท้ายและการมองไปสู่อนาคต', 'finale', '{"completed_events": ["heroes-hall-evt----------------------132"]}', 3, false)
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
    ('reflect-journey-interaction--------------140', 'Reflecting on the Journey', 'reflection', 'Remember the Past', 'ระลึกถึงอดีตที่ผ่านมา', 'ในสวนรำลึกนี้... Luminary นึกถึงการเดินทางที่ยาวนาน... จากหมู่บ้าน Cobblestone เล็กๆ จนถึงการกอบกู้โลก... ทุกอย่างดูเหมือนฝันไป', 'Narrator', '[{"id": "grateful", "text": "ผมรู้สึกขอบคุณทุกอย่าง", "type": "grateful"}, {"id": "nostalgic", "text": "คิดถึงเพื่อนๆ ทุกคน", "type": "nostalgic"}]', '{}', 1),
    ('legacy-preserved-interaction--------------141', 'Legacy Preserved', 'legacy', 'Record the Story', 'บันทึกเรื่องราวไว้', 'Chronicler เข้ามาหา Luminary "ท่าน Luminary... ข้าอยากบันทึกเรื่องราวของท่านไว้ เพื่อให้คนรุ่นหลังได้เรียนรู้จากความกล้าหาญของท่าน"', 'Chronicler', '[{"id": "agree", "text": "ผมยินดีเล่าให้ฟัง", "type": "sharing"}, {"id": "humble", "text": "ผมเป็นแค่คนธรรมดา", "type": "humble"}]', '{}', 1),
    ('final-farewell-interaction--------------142', 'The Final Farewell', 'finale', 'Look to the Future', 'มองไปสู่อนาคต', 'ที่จุดชมวิว Future''s Dawn... Luminary มองดูโลกที่เต็มไปด้วยสันติสุข... เด็กๆ เล่นอย่างมีความสุข... ผู้คนยิ้มแย้ม... นี่คือโลกที่เขาต่อสู้เพื่อปกป้อง', 'Narrator', '[{"id": "satisfied", "text": "นี่คือสิ่งที่ผมต้องการ", "type": "fulfilled"}, {"id": "hopeful", "text": "อนาคตจะสดใสแน่นอน", "type": "hopeful"}]', '{}', 1)
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
    ('gratitude-overflow-outcome--------------140', 'Remember the Past', 'grateful', 'story', 'Gratitude Overflowing', 'ความขอบคุณของ Luminary ล้นเหลือ... เขารู้สึกโชคดีที่ได้พบเจอผู้คนดีๆ มากมาย', '{"experience": 500, "relationship": {"all_friends": 100}}', 'Legacy Preserved'),
    ('sweet-memories-outcome-----------------141', 'Remember the Past', 'nostalgic', 'story', 'Sweet Memories', 'ความทรงจำหวานๆ กับเพื่อนๆ ทำให้ Luminary ยิ้มได้... แม้จะอยู่ห่างไกลกัน', '{"experience": 400, "items": [{"code": "seed-new-hope-item--------------------045", "quantity": 1}]}', 'Legacy Preserved'),
    ('story-shared-outcome-------------------142', 'Record the Story', 'agree', 'story', 'Story Shared', 'Luminary เล่าเรื่องราวทั้งหมดให้ Chronicler ฟัง... เรื่องราวจะถูกบันทึกไว้ตลอดกาล', '{"experience": 600, "items": [{"code": "chronicle-luminary-item----------------044", "quantity": 1}]}', 'The Final Farewell'),
    ('humble-hero-outcome--------------------143', 'Record the Story', 'humble', 'story', 'Humble Hero', 'ความถ่อมตัวของ Luminary ทำให้ Chronicler ประทับใจยิ่งขึ้น... นี่คือวีรบุรุษที่แท้จริง', '{"experience": 500, "items": [{"code": "chronicle-luminary-item----------------044", "quantity": 1}]}', 'The Final Farewell'),
    ('mission-accomplished-outcome-----------144', 'Look to the Future', 'satisfied', 'ending', 'Mission Accomplished', 'Luminary รู้สึกพอใจในสิ่งที่ทำได้... โลกได้รับสันติสุขแล้ว... ภารกิจสำเร็จลุล่วง', '{"experience": 1000, "items": [{"code": "luminary-gift-item--------------------046", "quantity": 1}], "game_flags": {"story_complete": true, "perfect_ending": true}}', null),
    ('eternal-hope-outcome-------------------145', 'Look to the Future', 'hopeful', 'ending', 'Eternal Hope', 'ความหวังของ Luminary จะคงอยู่ตลอดไป... เป็นแสงสว่างนำทางสำหรับคนรุ่นหลัง... เรื่องราวของ Luminary จบลงด้วยความหวังที่ไม่มีวันดับ', '{"experience": 1500, "items": [{"code": "luminary-gift-item--------------------046", "quantity": 1}], "game_flags": {"story_complete": true, "perfect_ending": true, "eternal_hope": true}}', null)
) AS outcome_info(code, interaction_title, choice_key, outcome_type, title, description, effects, next_event_title)
LEFT JOIN story_events se_next ON se_next.title = outcome_info.next_event_title
WHERE ei.title = outcome_info.interaction_title;
