-- Dragon Quest XI Story Data Seed - Chapter 13: The Wedding Bells
-- Created: 2025-09-26
-- Author: Marosdee Uma
-- Description: Chapter 13 - The wedding ceremony and rebuilding of Cobblestone
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
    ('post-game-rg-------------------------013', 'Cobblestone Rebuilt', 'หมู่บ้าน Cobblestone ที่ถูกสร้างใหม่อย่างสวยงาม เต็มไปด้วยความสุขและความหวัง', '/images/regions/cobblestone_rebuilt.svg', '{"completed_events": ["66666666-6666-6666-6666-666666666113"], "game_flags": {"calasmos_defeated": true}}', 13, false, true)
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
    ('new-village-square-location--------------042', 'Cobblestone Rebuilt', 'New Village Square', 'จัตุรัสใหม่ที่สวยงามและกว้างขวางกว่าเดิม', 'town_square', '{}', 1, false, false),
    ('wedding-chapel-location-----------------043', 'Cobblestone Rebuilt', 'Wedding Chapel', 'โบสถ์เล็กๆ ที่สร้างขึ้นใหม่สำหรับพิธีแต่งงาน', 'chapel', '{"completed_events": ["66666666-6666-6666-6666-666666666121"]}', 2, false, true),
    ('luminary-new-home-location--------------044', 'Cobblestone Rebuilt', 'Luminary''s New Home', 'บ้านใหม่ของ Luminary ที่สร้างด้วยความรักและความหวัง', 'house', '{"completed_events": ["66666666-6666-6666-6666-666666666122"]}', 3, false, true)
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
    ('wedding-bells-ch----------------------013', 13, 'The Wedding Bells', 'การแต่งงานของ Luminary และ Gemma และการสร้าง Cobblestone ใหม่ให้สวยงามกว่าเดิม', '{"completed_chapters": ["true-enemy-ch------------------------012"], "game_flags": {"calasmos_defeated": true}}', 13, false, 'post-game-act-------------------------005')
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
    ('gemma-bride-character------------------037', 'Gemma Bride', 'Gemma ในชุดเจ้าสาวที่สวยงาม พร้อมเริ่มต้นชีวิตใหม่กับ Luminary', 'npc', '/images/characters/gemma_bride.svg', '{"hp": 100, "mp": 60, "level": 1}', '["Love''s Blessing", "Hope''s Light"]', false, false),
    ('village-elder-character----------------038', 'Village Elder', 'ผู้อาวุโสของหมู่บ้านที่ทำหน้าที่เป็นผู้ประกอบพิธีแต่งงาน', 'npc', '/images/characters/village_elder.svg', '{"hp": 80, "mp": 40, "level": 1}', '["Wedding Blessing", "Village Wisdom"]', false, false),
    ('party-members-character----------------039', 'All Party Members', 'เพื่อนๆ ทุกคนที่มาร่วมงานแต่งงานด้วยความยินดี', 'group', '/images/characters/party_group.svg', '{"hp": 999, "mp": 999, "level": 99}', '["Friendship Power", "Unity Blessing"]', false, false)
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
    ('wedding-ring-item---------------------041', 'Wedding Ring', 'แหวนแต่งงานที่สัญลักษณ์ของความรักนิรันดร์', 'accessory', 'legendary', '{"love_power": 100, "happiness": 100}', '{"eternal_love": true, "happiness_aura": true}', '/images/items/wedding_ring.svg', false),
    ('gemma-bouquet-item--------------------042', 'Gemma''s Bouquet', 'ช่อดอกไม้ของเจ้าสาวที่สวยงามและหอมหวาน', 'key_item', 'rare', '{}', '{"beauty": 50, "fragrance": 30}', '/images/items/bridal_bouquet.svg', false),
    ('reconstruction-plans-item--------------043', 'Village Reconstruction Plans', 'แผนการสร้างหมู่บ้านใหม่ที่ดีกว่าเดิม', 'key_item', 'uncommon', '{}', '{"construction": true, "village_upgrade": true}', '/images/items/construction_plans.svg', false)
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
    ('village-reconstruction-evt-------------121', 'The Wedding Bells', 'New Village Square', 'Village Reconstruction', 'การสร้างหมู่บ้าน Cobblestone ใหม่ให้สวยงามกว่าเดิม', 'construction', '{"completed_chapters": ["true-enemy-ch------------------------012"]}', 1, false),
    ('wedding-ceremony-evt------------------122', 'The Wedding Bells', 'Wedding Chapel', 'The Wedding Ceremony', 'พิธีแต่งงานของ Luminary และ Gemma', 'wedding', '{"completed_events": ["village-reconstruction-evt-------------121"]}', 2, false),
    ('new-life-begins-evt-------------------123', 'The Wedding Bells', 'Luminary''s New Home', 'New Life Begins', 'การเริ่มต้นชีวิตใหม่ของ Luminary และ Gemma', 'life_event', '{"completed_events": ["wedding-ceremony-evt------------------122"]}', 3, false)
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
    ('plan-village-interaction----------------130', 'Village Reconstruction', 'construction', 'Plan the Village', 'วางแผนการสร้างหมู่บ้านใหม่', 'ตอนนี้ที่ Calasmos ถูกขับไล่ไปแล้ว... เราสามารถสร้าง Cobblestone ใหม่ให้สวยงามกว่าเดิม! ทุกคนช่วยกันวางแผนกันเถอะ!', 'Luminary', '[{"id": "beautiful", "text": "สร้างให้สวยงามที่สุด!", "type": "ambitious"}, {"id": "practical", "text": "สร้างให้ใช้งานได้ดี", "type": "practical"}]', '{}', 1),
    ('exchange-vows-interaction----------------131', 'The Wedding Ceremony', 'wedding', 'Exchange Vows', 'แลกเปลี่ยนคำสาบาน', 'Luminary... เจ้าจะรับ Gemma เป็นภรรยาหรือไม่? ในยามสุขและยามทุกข์ จนกว่าความตายจะพรากจากกัน?', 'Village Elder', '[{"id": "i_do", "text": "ผมยอมรับ", "type": "romantic"}]', '{}', 1),
    ('gemma-vows-interaction------------------132', 'The Wedding Ceremony', 'wedding', 'Gemma''s Vows', 'คำสาบานของ Gemma', 'Gemma... เจ้าจะรับ Luminary เป็นสามีหรือไม่? ในยามสุขและยามทุกข์ จนกว่าความตายจะพรากจากกัน?', 'Village Elder', '[]', '{}', 2),
    ('first-day-together-interaction-----------133', 'New Life Begins', 'life_event', 'First Day Together', 'วันแรกของชีวิตคู่', 'ในบ้านใหม่ที่สวยงาม... Luminary และ Gemma เริ่มต้นชีวิตใหม่ด้วยกัน... ความสุขและความหวังเต็มเปี่ยมในใจ', 'Narrator', '[{"id": "happy", "text": "เราจะมีความสุขตลอดไป", "type": "joyful"}]', '{}', 1)
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
    ('beautiful-village-outcome---------------130', 'Plan the Village', 'beautiful', 'story', 'Beautiful Village Design', 'ทุกคนร่วมมือกันสร้างหมู่บ้านที่สวยงามที่สุด! Cobblestone ใหม่จะเป็นสถานที่ที่น่าอยู่', '{"experience": 300, "items": [{"code": "village-blueprint-item------------------043", "quantity": 1}]}', 'The Wedding Ceremony'),
    ('practical-village-outcome---------------131', 'Plan the Village', 'practical', 'story', 'Practical Village Design', 'การออกแบบที่เน้นการใช้งาน Cobblestone ใหม่จะเป็นหมู่บ้านที่มีประสิทธิภาพ', '{"experience": 250, "items": [{"code": "village-blueprint-item------------------043", "quantity": 1}]}', 'The Wedding Ceremony'),
    ('sacred-vows-outcome---------------------132', 'Exchange Vows', 'i_do', 'story', 'Sacred Vows', 'Luminary ตอบรับด้วยความรัก! เสียงปรบมือดังก้องจากเพื่อนๆ ทุกคน', '{"experience": 500, "items": [{"code": "wedding-ring-item-----------------------041", "quantity": 1}]}', null),
    ('gemma-love-outcome---------------------133', 'Gemma''s Vows', 'default', 'story', 'Gemma''s Love', 'Gemma ตอบรับด้วยน้ำตาแห่งความสุข "ฉันยอมรับ!" ความรักที่แท้จริงได้รับการยืนยัน', '{"experience": 500, "items": [{"code": "love-letter-item----------------------042", "quantity": 1}], "relationship": {"gemma": 100}}', 'New Life Begins'),
    ('happily-ever-after-outcome--------------134', 'First Day Together', 'happy', 'ending', 'Happily Ever After', 'Luminary และ Gemma เริ่มต้นชีวิตใหม่ด้วยความสุข... เรื่องราวของ Luminary จบลงด้วยความสุขและความหวัง!', '{"experience": 1000, "game_flags": {"married": true, "happy_ending": true}, "unlock_regions": ["post-game-rg-------------------------013"]}', null)
) AS outcome_info(code, interaction_title, choice_key, outcome_type, title, description, effects, next_event_title)
LEFT JOIN story_events se_next ON se_next.title = outcome_info.next_event_title
WHERE ei.title = outcome_info.interaction_title;
