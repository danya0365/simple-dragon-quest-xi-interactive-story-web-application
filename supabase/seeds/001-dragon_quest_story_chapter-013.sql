-- Dragon Quest XI Story Data Seed - Chapter 13: The Wedding Bells
-- Created: 2025-09-26
-- Author: Marosdee Uma
-- Description: Chapter 13 - The wedding ceremony and rebuilding of Cobblestone
-- Features: Basic structure following Dragon Quest XI post-game narrative

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
    ('11111111-1111-1111-1111-111111111013', 'Cobblestone Rebuilt', 'หมู่บ้าน Cobblestone ที่ถูกสร้างใหม่อย่างสวยงาม เต็มไปด้วยความสุขและความหวัง', '/images/regions/cobblestone_rebuilt.svg', '{"completed_events": ["66666666-6666-6666-6666-666666666113"], "game_flags": {"calasmos_defeated": true}}', 13, false, true)
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
    ('22222222-2222-2222-2222-222222222042', 'Cobblestone Rebuilt', 'New Village Square', 'จัตุรัสใหม่ที่สวยงามและกว้างขวางกว่าเดิม', 'town_square', '{}', 1, false, false),
    ('22222222-2222-2222-2222-222222222043', 'Cobblestone Rebuilt', 'Wedding Chapel', 'โบสถ์เล็กๆ ที่สร้างขึ้นใหม่สำหรับพิธีแต่งงาน', 'chapel', '{"completed_events": ["66666666-6666-6666-6666-666666666121"]}', 2, false, true),
    ('22222222-2222-2222-2222-222222222044', 'Cobblestone Rebuilt', 'Luminary''s New Home', 'บ้านใหม่ของ Luminary ที่สร้างด้วยความรักและความหวัง', 'house', '{"completed_events": ["66666666-6666-6666-6666-666666666122"]}', 3, false, true)
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
    ('33333333-3333-3333-3333-333333333013', 13, 'The Wedding Bells', 'การแต่งงานของ Luminary และ Gemma และการสร้าง Cobblestone ใหม่ให้สวยงามกว่าเดิม', '{"completed_chapters": ["33333333-3333-3333-3333-333333333012"], "game_flags": {"calasmos_defeated": true}}', 13, false)
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
    ('44444444-4444-4444-4444-444444444037', 'Gemma Bride', 'Gemma ในชุดเจ้าสาวที่สวยงาม พร้อมเริ่มต้นชีวิตใหม่กับ Luminary', 'npc', '/images/characters/gemma_bride.svg', '{"hp": 100, "mp": 60, "level": 1}', '["Love''s Blessing", "Hope''s Light"]', false, false),
    ('44444444-4444-4444-4444-444444444038', 'Village Elder', 'ผู้อาวุโสของหมู่บ้านที่ทำหน้าที่เป็นผู้ประกอบพิธีแต่งงาน', 'npc', '/images/characters/village_elder.svg', '{"hp": 80, "mp": 40, "level": 1}', '["Wedding Blessing", "Village Wisdom"]', false, false),
    ('44444444-4444-4444-4444-444444444039', 'All Party Members', 'เพื่อนๆ ทุกคนที่มาร่วมงานแต่งงานด้วยความยินดี', 'group', '/images/characters/party_group.svg', '{"hp": 999, "mp": 999, "level": 99}', '["Friendship Power", "Unity Blessing"]', false, false)
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
    ('55555555-5555-5555-5555-555555555041', 'Wedding Ring', 'แหวนแต่งงานที่สัญลักษณ์ของความรักนิรันดร์', 'accessory', 'legendary', '{"love_power": 100, "happiness": 100}', '{"eternal_love": true, "happiness_aura": true}', '/images/items/wedding_ring.svg', false),
    ('55555555-5555-5555-5555-555555555042', 'Gemma''s Bouquet', 'ช่อดอกไม้ของเจ้าสาวที่สวยงามและหอมหวาน', 'key_item', 'rare', '{}', '{"beauty": 50, "fragrance": 30}', '/images/items/bridal_bouquet.svg', false),
    ('55555555-5555-5555-5555-555555555043', 'Village Reconstruction Plans', 'แผนการสร้างหมู่บ้านใหม่ที่ดีกว่าเดิม', 'key_item', 'uncommon', '{}', '{"construction": true, "village_upgrade": true}', '/images/items/construction_plans.svg', false)
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
    ('66666666-6666-6666-6666-666666666121', 'The Wedding Bells', 'New Village Square', 'Village Reconstruction', 'การสร้างหมู่บ้าน Cobblestone ใหม่ให้สวยงามกว่าเดิม', 'construction', '{"completed_chapters": ["33333333-3333-3333-3333-333333333012"]}', 1, false),
    ('66666666-6666-6666-6666-666666666122', 'The Wedding Bells', 'Wedding Chapel', 'The Wedding Ceremony', 'พิธีแต่งงานของ Luminary และ Gemma', 'wedding', '{"completed_events": ["66666666-6666-6666-6666-666666666121"]}', 2, false),
    ('66666666-6666-6666-6666-666666666123', 'The Wedding Bells', 'Luminary''s New Home', 'New Life Begins', 'การเริ่มต้นชีวิตใหม่ของ Luminary และ Gemma', 'life_event', '{"completed_events": ["66666666-6666-6666-6666-666666666122"]}', 3, false)
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
    ('77777777-7777-7777-7777-777777777130', 'Village Reconstruction', 'construction', 'Plan the Village', 'วางแผนการสร้างหมู่บ้านใหม่', 'ตอนนี้ที่ Calasmos ถูกขับไล่ไปแล้ว... เราสามารถสร้าง Cobblestone ใหม่ให้สวยงามกว่าเดิม! ทุกคนช่วยกันวางแผนกันเถอะ!', 'Luminary', '[{"id": "beautiful", "text": "สร้างให้สวยงามที่สุด!", "type": "ambitious"}, {"id": "practical", "text": "สร้างให้ใช้งานได้ดี", "type": "practical"}]', '{}', 1),
    ('77777777-7777-7777-7777-777777777131', 'The Wedding Ceremony', 'wedding', 'Exchange Vows', 'แลกเปลี่ยนคำสาบาน', 'Luminary... เจ้าจะรับ Gemma เป็นภรรยาหรือไม่? ในยามสุขและยามทุกข์ จนกว่าความตายจะพรากจากกัน?', 'Village Elder', '[{"id": "i_do", "text": "ผมยอมรับ", "type": "romantic"}]', '{}', 1),
    ('77777777-7777-7777-7777-777777777132', 'The Wedding Ceremony', 'wedding', 'Gemma''s Vows', 'คำสาบานของ Gemma', 'Gemma... เจ้าจะรับ Luminary เป็นสามีหรือไม่? ในยามสุขและยามทุกข์ จนกว่าความตายจะพรากจากกัน?', 'Village Elder', '[]', '{}', 2),
    ('77777777-7777-7777-7777-777777777133', 'New Life Begins', 'life_event', 'First Day Together', 'วันแรกของชีวิตคู่', 'ในบ้านใหม่ที่สวยงาม... Luminary และ Gemma เริ่มต้นชีวิตใหม่ด้วยกัน... ความสุขและความหวังเต็มเปี่ยมในใจ', 'Narrator', '[{"id": "happy", "text": "เราจะมีความสุขตลอดไป", "type": "joyful"}]', '{}', 1)
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
    ('88888888-8888-8888-8888-888888888130', 'Plan the Village', 'beautiful', 'story', 'Beautiful Village Design', 'ทุกคนร่วมมือกันสร้างหมู่บ้านที่สวยงามที่สุด! Cobblestone ใหม่จะเป็นสถานที่ที่น่าอยู่', '{"experience": 300, "items": [{"id": "55555555-5555-5555-5555-555555555043", "quantity": 1}]}', 'The Wedding Ceremony'),
    ('88888888-8888-8888-8888-888888888131', 'Plan the Village', 'practical', 'story', 'Practical Village Design', 'การออกแบบที่เน้นการใช้งาน Cobblestone ใหม่จะเป็นหมู่บ้านที่มีประสิทธิภาพ', '{"experience": 250, "items": [{"id": "55555555-5555-5555-5555-555555555043", "quantity": 1}]}', 'The Wedding Ceremony'),
    ('88888888-8888-8888-8888-888888888132', 'Exchange Vows', 'i_do', 'story', 'Sacred Vows', 'Luminary ตอบรับด้วยความรัก! เสียงปรบมือดังก้องจากเพื่อนๆ ทุกคน', '{"experience": 500, "items": [{"id": "55555555-5555-5555-5555-555555555041", "quantity": 1}]}', null),
    ('88888888-8888-8888-8888-888888888133', 'Gemma''s Vows', null, 'story', 'Gemma''s Love', 'Gemma ตอบรับด้วยน้ำตาแห่งความสุข "ฉันยอมรับ!" ความรักที่แท้จริงได้รับการยืนยัน', '{"experience": 500, "items": [{"id": "55555555-5555-5555-5555-555555555042", "quantity": 1}], "relationship": {"gemma": 100}}', 'New Life Begins'),
    ('88888888-8888-8888-8888-888888888134', 'First Day Together', 'happy', 'ending', 'Happily Ever After', 'Luminary และ Gemma เริ่มต้นชีวิตใหม่ด้วยความสุข... เรื่องราวของ Luminary จบลงด้วยความสุขและความหวัง!', '{"experience": 1000, "game_flags": {"married": true, "happy_ending": true}, "unlock_regions": ["11111111-1111-1111-1111-111111111014"]}', null)
) AS outcome_info(id, interaction_title, choice_key, outcome_type, title, description, effects, next_event_title)
WHERE ei.title = outcome_info.interaction_title;
