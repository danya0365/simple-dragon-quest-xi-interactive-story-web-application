-- Dragon Quest XI Story Data Seed - Chapter 1: The Luminary's Awakening
-- Created: 2025-09-26
-- Author: Marosdee Uma
-- Description: Chapter 1 - The beginning of the Luminary's journey in Cobblestone
-- Features: Detailed story progression following Dragon Quest XI narrative

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
    ('11111111-1111-1111-1111-111111111001', 'Cobblestone', 'หมู่บ้านเล็กๆ ที่เงียบสงบ บ้านเกิดของ Luminary ท่ามกลางภูเขาและป่าไผ่', '/images/regions/cobblestone.svg', '{}', 1, true, false)
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
    ('22222222-2222-2222-2222-222222222001', 'Cobblestone', 'Luminary''s House', 'บ้านของ Luminary และ Grandpa Chalky ที่อบอุ่นและเต็มไปด้วยความทรงจำ', 'house', '{}', 1, true, false),
    ('22222222-2222-2222-2222-222222222002', 'Cobblestone', 'Village Square', 'จัตุรัสกลางหมู่บ้าน Cobblestone ที่คึกคักในวันเทศกาล', 'town', '{}', 2, true, false),
    ('22222222-2222-2222-2222-222222222003', 'Cobblestone', 'Sacred Tor', 'ยอดเขาศักดิ์สิทธิ์ที่มีต้นไผ่โบราณและพลังลึกลับ', 'landmark', '{"completed_events": ["66666666-6666-6666-6666-666666666003"]}', 3, false, true),
    ('22222222-2222-2222-2222-222222222004', 'Cobblestone', 'Village Shop', 'ร้านค้าของหมู่บ้านที่มีของใช้พื้นฐานและอุปกรณ์การเดินทาง', 'shop', '{}', 4, true, false),
    ('22222222-2222-2222-2222-222222222005', 'Cobblestone', 'Gemma''s House', 'บ้านของ Gemma เพื่อนสนิทของ Luminary ตั้งแต่เด็ก', 'house', '{}', 5, true, false),
    ('22222222-2222-2222-2222-222222222006', 'Cobblestone', 'Village Well', 'บ่อน้ำกลางหมู่บ้านที่เป็นจุดรวมตัวของชาวบ้าน', 'landmark', '{}', 6, true, false)
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
    ('33333333-3333-3333-3333-333333333001', 1, 'The Luminary''s Awakening', 'จุดเริ่มต้นของการผจญภัย เมื่อ Luminary ตื่นขึ้นในวันเกิดปีที่ 16 และเตรียมตัวสำหรับพิธีกรรมบรรลุนิติภาวะ', '{}', 1, true)
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
    ('44444444-4444-4444-4444-444444444001', 'Luminary', 'ตัวเอกของเรื่อง ผู้ถูกเลือกให้เป็น Luminary ผู้นำแสงสว่างมาสู่โลก', 'party_member', '/images/characters/luminary.svg', 
     '{"hp": 120, "mp": 60, "level": 1, "attack": 18, "defense": 12, "agility": 10, "luck": 8}', 
     '["Sword Strike", "Heal", "Zap"]', true, true),
     
    ('44444444-4444-4444-4444-444444444002', 'Chalky', 'ปู่ของ Luminary ผู้เลี้ยงดู Luminary มาตั้งแต่เด็ก คนเดียวที่รู้ความจริงเกี่ยวกับต้นกำเนิด', 'npc', '/images/characters/chalky.svg',
     '{"hp": 80, "mp": 40, "level": 1}', '[]', false, true),

    ('44444444-4444-4444-4444-444444444003', 'Gemma', 'เพื่อนสนิทของ Luminary ตั้งแต่เด็ก สาวน้อยที่ใจดีและเป็นห่วงเป็นใย', 'npc', '/images/characters/gemma.svg',
     '{"hp": 60, "mp": 30, "level": 1}', '[]', false, true),

    ('44444444-4444-4444-4444-444444444004', 'Mayor', 'นายกเทศมนตรีของหมู่บ้าน Cobblestone ผู้ใจดีและเป็นที่เคารพของชาวบ้าน', 'npc', '/images/characters/mayor.svg',
     '{"hp": 70, "mp": 20, "level": 1}', '[]', false, false),

    ('44444444-4444-4444-4444-444444444005', 'Shopkeeper Dan', 'เจ้าของร้านค้าในหมู่บ้าน คนใจดีที่คอยช่วยเหลือนักผจญภัย', 'npc', '/images/characters/shopkeeper.svg',
     '{"hp": 50, "mp": 10, "level": 1}', '[]', false, false)
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
    ('55555555-5555-5555-5555-555555555001', 'Cobblestone Sword', 'ดาบไม้ที่ Chalky ทำให้ Luminary สำหรับการฝึกซ้อม', 'weapon', 'common', 
     '{"attack": 12, "accuracy": 90}', '{}', '/images/items/cobblestone_sword.svg', true),
     
    ('55555555-5555-5555-5555-555555555002', 'Village Clothes', 'เสื้อผ้าชาวบ้านที่สวมใส่ในชีวิตประจำวัน', 'armor', 'common',
     '{"defense": 5}', '{}', '/images/items/village_clothes.svg', true),

    ('55555555-5555-5555-5555-555555555003', 'Medicinal Herb', 'สมุนไพรรักษาที่หาได้ในป่าใกล้หมู่บ้าน', 'consumable', 'common',
     '{}', '{"heal": 25}', '/images/items/herb.svg', false),

    ('55555555-5555-5555-5555-555555555004', 'Birthday Cake', 'เค้กวันเกิดที่ Gemma ทำให้ Luminary', 'consumable', 'uncommon',
     '{}', '{"heal": 50, "mp_restore": 20}', '/images/items/birthday_cake.svg', false),

    ('55555555-5555-5555-5555-555555555005', 'Sacred Mark', 'เครื่องหมายศักดิ์สิทธิ์ที่ปรากฏบนมือของ Luminary', 'key_item', 'legendary',
     '{}', '{"luminary_power": true}', '/images/items/sacred_mark.svg', false)
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
    ('66666666-6666-6666-6666-666666666001', 'The Luminary''s Awakening', 'Luminary''s House', 'Birthday Morning', 'เช้าวันเกิดปีที่ 16 ของ Luminary วันที่จะเปลี่ยนชีวิตไปตลอดกาล', 'dialogue', '{}', 1, true),
    ('66666666-6666-6666-6666-666666666002', 'The Luminary''s Awakening', 'Gemma''s House', 'Meeting Gemma', 'การพบกับ Gemma และรับเค้กวันเกิดที่เธอทำให้', 'dialogue', '{"completed_events": ["66666666-6666-6666-6666-666666666001"]}', 2, false),
    ('66666666-6666-6666-6666-666666666003', 'The Luminary''s Awakening', 'Village Square', 'Festival Preparation', 'การเตรียมตัวสำหรับเทศกาลและพิธีกรรมบรรลุนิติภาวะ', 'exploration', '{"completed_events": ["66666666-6666-6666-6666-666666666002"]}', 3, false),
    ('66666666-6666-6666-6666-666666666004', 'The Luminary''s Awakening', 'Village Shop', 'Getting Supplies', 'การซื้อของใช้สำหรับการเดินทางที่จะมาถึง', 'shopping', '{"completed_events": ["66666666-6666-6666-6666-666666666003"]}', 4, false),
    ('66666666-6666-6666-6666-666666666005', 'The Luminary''s Awakening', 'Sacred Tor', 'The Sacred Ritual', 'พิธีกรรมบรรลุนิติภาวะที่ Sacred Tor ที่จะเปิดเผยชะตากรรมของ Luminary', 'story', '{"completed_events": ["66666666-6666-6666-6666-666666666004"]}', 5, false)
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
    -- Birthday Morning interactions
    ('77777777-7777-7777-7777-777777777001', 'Birthday Morning', 'talk', 'Talk to Chalky', 
     'พูดคุยกับปู่ Chalky เกี่ยวกับวันเกิดและพิธีกรรมที่จะมาถึง', 
     'เช้าดี Luminary! วันนี้เป็นวันเกิดปีที่ 16 ของเจ้า วันสำคัญที่เจ้าจะต้องไปทำพิธีกรรมบรรลุนิติภาวะที่ Sacred Tor เจ้าพร้อมแล้วหรือยัง?', 'Chalky', 
     '[{"id": "ready", "text": "ผมพร้อมแล้วครับ ปู่", "type": "positive"}, {"id": "nervous", "text": "ผมรู้สึกกังวลนิดหน่อย", "type": "neutral"}]', '{}', 1),

    ('77777777-7777-7777-7777-777777777002', 'Birthday Morning', 'examine', 'Check Room', 
     'ตรวจสอบห้องของตัวเองและเตรียมของสำหรับวันสำคัญ', '', '', '[]', '{}', 2),

    -- Meeting Gemma interactions
    ('77777777-7777-7777-7777-777777777003', 'Meeting Gemma', 'talk', 'Talk to Gemma', 
     'พูดคุยกับ Gemma และรับเค้กวันเกิด', 
     'สุขสันต์วันเกิด Luminary! ฉันทำเค้กให้เธอเป็นของขวัญ หวังว่าเธอจะชอบนะ วันนี้เธอจะไปทำพิธีกรรมที่ Sacred Tor ใช่ไหม?', 'Gemma',
     '[{"id": "thanks", "text": "ขอบคุณมากเลย Gemma", "type": "positive"}, {"id": "worried", "text": "ฉันกังวลเรื่องพิธีกรรม", "type": "neutral"}]', '{}', 1),

    -- Festival Preparation interactions  
    ('77777777-7777-7777-7777-777777777004', 'Festival Preparation', 'talk', 'Talk to Villagers', 
     'พูดคุยกับชาวบ้านที่กำลังเตรียมงานเทศกาล', 
     'วันนี้เป็นวันสำคัญของ Luminary เลยนะ! ทุกคนในหมู่บ้านต่างก็ตื่นเต้นกับพิธีกรรมบรรลุนิติภาวะ', 'Villager',
     '[]', '{}', 1),

    ('77777777-7777-7777-7777-777777777005', 'Festival Preparation', 'examine', 'Look at Decorations', 
     'ดูการตกแต่งงานเทศกาลที่สวยงาม', '', '', '[]', '{}', 2),

    -- Getting Supplies interactions
    ('77777777-7777-7777-7777-777777777006', 'Getting Supplies', 'talk', 'Talk to Dan', 
     'พูดคุยกับ Dan เจ้าของร้านค้า', 
     'สวัสดี Luminary! วันนี้เป็นวันสำคัญของเจ้าเลยนะ มีอะไรให้ช่วยไหม? เจ้าต้องการอุปกรณ์อะไรสำหรับการเดินทางไหม?', 'Shopkeeper Dan',
     '[{"id": "buy_herbs", "text": "ซื้อสมุนไพรรักษา", "type": "shop"}, {"id": "just_looking", "text": "แค่ดูๆ ครับ", "type": "neutral"}]', '{}', 1),

    -- The Sacred Ritual interactions
    ('77777777-7777-7777-7777-777777777007', 'The Sacred Ritual', 'story', 'The Awakening', 
     'พิธีกรรมบรรลุนิติภาวะที่จะเปลี่ยนชีวิต Luminary ไปตลอดกาล', 
     'Luminary เข้าใกล้ต้นไผ่โบราณบน Sacred Tor... แสงสว่างเริ่มส่องออกมา... เครื่องหมายศักดิ์สิทธิ์ปรากฏบนมือซ้าย... นี่คือจุดเริ่มต้นของชะตากรรม Luminary!', 'Narrator', '[]', '{}', 1)
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
    ('88888888-8888-8888-8888-888888888001', 'Talk to Chalky', 'ready', 'story', 'Ready for Adventure', 
     'Chalky ยิ้มด้วยความภาคภูมิใจ "ดีมาก! เจ้าเติบโตเป็นหนุ่มที่แข็งแกร่งแล้ว"', 
     '{"relationship": {"chalky": 5}, "experience": 10}', 'Meeting Gemma'),
     
    ('88888888-8888-8888-8888-888888888002', 'Talk to Chalky', 'nervous', 'story', 'Grandfather''s Comfort', 
     'Chalky วางมือบนไหล่ Luminary "ไม่ต้องกังวล เจ้าจะทำได้ดี ปู่เชื่อในตัวเจ้า"', 
     '{"relationship": {"chalky": 3}, "experience": 5}', 'Meeting Gemma'),

    ('88888888-8888-8888-8888-888888888003', 'Talk to Gemma', 'thanks', 'reward', 'Birthday Gift', 
     'Gemma ยิ้มอย่างมีความสุข "ฉันดีใจที่เธอชอบ! ขอให้โชคดีในพิธีกรรมนะ"', 
     '{"relationship": {"gemma": 10}, "items": [{"id": "55555555-5555-5555-5555-555555555004", "quantity": 1}]}', 'Festival Preparation'),

    ('88888888-8888-8888-8888-888888888004', 'Talk to Gemma', 'worried', 'story', 'Gemma''s Support', 
     'Gemma จับมือ Luminary "ไม่ต้องกังวล ฉันเชื่อว่าเธอจะทำได้ดี"', 
     '{"relationship": {"gemma": 8}, "items": [{"id": "55555555-5555-5555-5555-555555555004", "quantity": 1}]}', 'Festival Preparation'),

    ('88888888-8888-8888-8888-888888888005', 'Talk to Dan', 'buy_herbs', 'reward', 'Medicinal Herbs', 
     'Dan ให้สมุนไพรรักษา "เอานี่ไปเถอะ อาจจะมีประโยชน์ในการเดินทาง"', 
     '{"items": [{"id": "55555555-5555-5555-5555-555555555003", "quantity": 3}], "gold": -10}', 'The Sacred Ritual'),

    ('88888888-8888-8888-8888-888888888006', 'Talk to Dan', 'just_looking', 'story', 'Window Shopping', 
     'Dan พยักหน้า "ไม่เป็นไร ถ้าต้องการอะไรก็มาหาได้เสมอ"', 
     '{"relationship": {"dan": 2}}', 'The Sacred Ritual'),

    ('88888888-8888-8888-8888-888888888007', 'The Awakening', 'default', 'unlock', 'Luminary Powers Awakened', 
     'พลังของ Luminary ได้ตื่นขึ้นแล้ว! เครื่องหมายศักดิ์สิทธิ์ปรากฏบนมือ และแสงสว่างล้อมรอบร่างกาย', 
     '{"items": [{"id": "55555555-5555-5555-5555-555555555005", "quantity": 1}], "experience": 100, "unlock_regions": ["11111111-1111-1111-1111-111111111002"]}', null),

    ('88888888-8888-8888-8888-888888888008', 'Look at Decorations', 'default', 'story', 'Festival Atmosphere', 
     'การตกแต่งที่สวยงามทำให้รู้สึกถึงบรรยากาศเทศกาลอย่างเต็มที่ ชาวบ้านต่างเตรียมตัวสำหรับพิธีกรรมสำคัญ', 
     '{"experience": 5}', 'Getting Supplies'),

    ('88888888-8888-8888-8888-888888888009', 'Check Room', 'default', 'story', 'Room Preparation', 
     'ห้องสะอาดและเรียบร้อยพร้อมสำหรับวันสำคัญ มีของใช้ส่วนตัวและของที่จะนำไปทำพิธีกรรมวางอยู่', 
     '{"experience": 3}', 'Meeting Gemma'),

    ('88888888-8888-8888-8888-888888888010', 'Talk to Villagers', 'default', 'story', 'Village Excitement', 
     'ชาวบ้านต่างแสดงความยินดีและให้กำลังใจกับ Luminary ที่จะทำพิธีกรรมบรรลุนิติภาวะ', 
     '{"experience": 8}', 'Getting Supplies')
) AS outcome_info(id, interaction_title, choice_key, outcome_type, title, description, effects, next_event_title)
LEFT JOIN story_events se_next ON se_next.title = outcome_info.next_event_title
WHERE ei.title = outcome_info.interaction_title;
