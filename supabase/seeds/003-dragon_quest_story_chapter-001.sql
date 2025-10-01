-- Dragon Quest XI Story Data Seed - Chapter 1: The Luminary's Awakening
-- Created: 2025-09-26
-- Author: Marosdee Uma
-- Description: Chapter 1 - The beginning of the Luminary's journey in Cobblestone
-- Features: Detailed story progression following Dragon Quest XI narrative

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
    ('cobblestone-region----------------001', 'Cobblestone', 'หมู่บ้านเล็กๆ ที่เงียบสงบ บ้านเกิดของ Luminary ท่ามกลางภูเขาและป่าไผ่', '/images/regions/cobblestone.svg', '{}', 1, true, false)
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
    ('luminary-house-------------------001', 'Cobblestone', 'Luminary''s House', 'บ้านของ Luminary และ Grandpa Chalky ที่อบอุ่นและเต็มไปด้วยความทรงจำ', 'house', '{}', 1, true, false),
    ('village-square------------------001', 'Cobblestone', 'Village Square', 'จัตุรัสกลางหมู่บ้าน Cobblestone ที่คึกคักในวันเทศกาล', 'town', '{}', 2, true, false),
    ('sacred-tor---------------------001', 'Cobblestone', 'Sacred Tor', 'ยอดเขาศักดิ์สิทธิ์ที่มีต้นไผ่โบราณและพลังลึกลับ', 'landmark', '{}', 3, false, true),
    ('village-shop-------------------001', 'Cobblestone', 'Village Shop', 'ร้านค้าของหมู่บ้านที่มีของใช้พื้นฐานและอุปกรณ์การเดินทาง', 'shop', '{}', 4, true, false),
    ('gemma-house--------------------001', 'Cobblestone', 'Gemma''s House', 'บ้านของ Gemma เพื่อนสนิทของ Luminary ตั้งแต่เด็ก', 'house', '{}', 5, true, false),
    ('village-well--------------------001', 'Cobblestone', 'Village Well', 'บ่อน้ำกลางหมู่บ้านที่เป็นจุดรวมตัวของชาวบ้าน', 'landmark', '{}', 6, true, false)
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
    ('dragon-quest-xi-ch-----------------001', 1, 'The Luminary''s Awakening', 'จุดเริ่มต้นของการผจญภัย เมื่อ Luminary ตื่นขึ้นในวันเกิดปีที่ 16 และเตรียมตัวสำหรับพิธีกรรมบรรลุนิติภาวะ', '{}', 1, true, 'dragon-quest-xi-act-----------------001')
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
    ('luminary-char------------------001', 'Luminary', 'ตัวเอกของเรื่อง ผู้ถูกเลือกให้เป็น Luminary ผู้นำแสงสว่างมาสู่โลก', 'party_member', '/images/characters/luminary.svg', 
     '{"hp": 120, "mp": 60, "level": 1, "attack": 18, "defense": 12, "agility": 10, "luck": 8}', 
     '["Sword Strike", "Heal", "Zap"]', true, true),
     
    ('chalky-char--------------------001', 'Chalky', 'ปู่ของ Luminary ผู้เลี้ยงดู Luminary มาตั้งแต่เด็ก คนเดียวที่รู้ความจริงเกี่ยวกับต้นกำเนิด', 'npc', '/images/characters/chalky.svg',
     '{"hp": 80, "mp": 40, "level": 1}', '[]', false, true),

    ('gemma-char---------------------001', 'Gemma', 'เพื่อนสนิทของ Luminary ตั้งแต่เด็ก สาวน้อยที่ใจดีและเป็นห่วงเป็นใย', 'npc', '/images/characters/gemma.svg',
     '{"hp": 60, "mp": 30, "level": 1}', '[]', false, true),

    ('mayor-char---------------------001', 'Mayor', 'นายกเทศมนตรีของหมู่บ้าน Cobblestone ผู้ใจดีและเป็นที่เคารพของชาวบ้าน', 'npc', '/images/characters/mayor.svg',
     '{"hp": 70, "mp": 20, "level": 1}', '[]', false, false),

    ('shopkeeper-dan-char-------------001', 'Shopkeeper Dan', 'เจ้าของร้านค้าในหมู่บ้าน คนใจดีที่คอยช่วยเหลือนักผจญภัย', 'npc', '/images/characters/shopkeeper.svg',
     '{"hp": 50, "mp": 10, "level": 1}', '[]', false, false)
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
    ('cobblestone-sword-item-----------001', 'Cobblestone Sword', 'ดาบไม้ที่ Chalky ทำให้ Luminary สำหรับการฝึกซ้อม', 'weapon', 'common', 
     '{"attack": 12, "accuracy": 90}', '{}', '/images/items/cobblestone_sword.svg', true),
     
    ('village-clothes-item-------------001', 'Village Clothes', 'เสื้อผ้าชาวบ้านที่สวมใส่ในชีวิตประจำวัน', 'armor', 'common',
     '{"defense": 5}', '{}', '/images/items/village_clothes.svg', true),

    ('medicinal-herb-item--------------001', 'Medicinal Herb', 'สมุนไพรรักษาที่หาได้ในป่าใกล้หมู่บ้าน', 'consumable', 'common',
     '{}', '{"heal": 25}', '/images/items/herb.svg', false),

    ('birthday-cake-item---------------001', 'Birthday Cake', 'เค้กวันเกิดที่ Gemma ทำให้ Luminary', 'consumable', 'uncommon',
     '{}', '{"heal": 50, "mp_restore": 20}', '/images/items/birthday_cake.svg', false),

    ('sacred-mark-item-----------------001', 'Sacred Mark', 'เครื่องหมายศักดิ์สิทธิ์ที่ปรากฏบนมือของ Luminary', 'key_item', 'legendary',
     '{}', '{"luminary_power": true}', '/images/items/sacred_mark.svg', false)
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
    ('luminary-awakening-evt-----------001', 'The Luminary''s Awakening', 'Luminary''s House', 'Birthday Morning', 'เช้าวันเกิดปีที่ 16 ของ Luminary วันที่จะเปลี่ยนชีวิตไปตลอดกาล', 'dialogue', '{}', 1, true),
    ('luminary-awakening-evt-----------002', 'The Luminary''s Awakening', 'Gemma''s House', 'Meeting Gemma', 'การพบกับ Gemma และรับเค้กวันเกิดที่เธอทำให้', 'dialogue', '{"completed_events": ["luminary-awakening-evt-----------001"]}', 2, false),
    ('luminary-awakening-evt-----------003', 'The Luminary''s Awakening', 'Village Square', 'Festival Preparation', 'การเตรียมตัวสำหรับเทศกาลและพิธีกรรมบรรลุนิติภาวะ', 'exploration', '{"completed_events": ["luminary-awakening-evt-----------002"]}', 3, false),
    ('luminary-awakening-evt-----------004', 'The Luminary''s Awakening', 'Village Shop', 'Getting Supplies', 'การซื้อของใช้สำหรับการเดินทางที่จะมาถึง', 'shopping', '{"completed_events": ["luminary-awakening-evt-----------003"]}', 4, false),
    ('luminary-awakening-evt-----------005', 'The Luminary''s Awakening', 'Sacred Tor', 'The Sacred Ritual', 'พิธีกรรมบรรลุนิติภาวะที่ Sacred Tor ที่จะเปิดเผยชะตากรรมของ Luminary', 'story', '{"completed_events": ["luminary-awakening-evt-----------004"]}', 5, false)
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
    -- Birthday Morning interactions
    ('talk-chalky-int----------------001', 'Birthday Morning', 'talk', 'Talk to Chalky', 
     'พูดคุยกับปู่ Chalky เกี่ยวกับวันเกิดและพิธีกรรมที่จะมาถึง', 
     'เช้าดี Luminary! วันนี้เป็นวันเกิดปีที่ 16 ของเจ้า วันสำคัญที่เจ้าจะต้องไปทำพิธีกรรมบรรลุนิติภาวะที่ Sacred Tor เจ้าพร้อมแล้วหรือยัง?', 'Chalky', 
     '[{"id": "ready", "text": "ผมพร้อมแล้วครับ ปู่", "type": "positive"}, {"id": "nervous", "text": "ผมรู้สึกกังวลนิดหน่อย", "type": "neutral"}]', '{}', 1),

    ('check-room-int-----------------001', 'Birthday Morning', 'examine', 'Check Room', 
     'ตรวจสอบห้องของตัวเองและเตรียมของสำหรับวันสำคัญ', '', '', '[]', '{}', 2),

    -- Meeting Gemma interactions
    ('talk-gemma-int-----------------001', 'Meeting Gemma', 'talk', 'Talk to Gemma', 
     'พูดคุยกับ Gemma และรับเค้กวันเกิด', 
     'สุขสันต์วันเกิด Luminary! ฉันทำเค้กให้เธอเป็นของขวัญ หวังว่าเธอจะชอบนะ วันนี้เธอจะไปทำพิธีกรรมที่ Sacred Tor ใช่ไหม?', 'Gemma',
     '[{"id": "thanks", "text": "ขอบคุณมากเลย Gemma", "type": "positive"}, {"id": "worried", "text": "ฉันกังวลเรื่องพิธีกรรม", "type": "neutral"}]', '{}', 1),

    -- Festival Preparation interactions  
    ('talk-villagers-int--------------001', 'Festival Preparation', 'talk', 'Talk to Villagers', 
     'พูดคุยกับชาวบ้านที่กำลังเตรียมงานเทศกาล', 
     'วันนี้เป็นวันสำคัญของ Luminary เลยนะ! ทุกคนในหมู่บ้านต่างก็ตื่นเต้นกับพิธีกรรมบรรลุนิติภาวะ', 'Villager',
     '[]', '{}', 1),

    ('look-decorations-int-----------001', 'Festival Preparation', 'examine', 'Look at Decorations', 
     'ดูการตกแต่งงานเทศกาลที่สวยงาม', '', '', '[]', '{}', 2),

    -- Getting Supplies interactions
    ('talk-dan-int-------------------001', 'Getting Supplies', 'talk', 'Talk to Dan', 
     'พูดคุยกับ Dan เจ้าของร้านค้า', 
     'สวัสดี Luminary! วันนี้เป็นวันสำคัญของเจ้าเลยนะ มีอะไรให้ช่วยไหม? เจ้าต้องการอุปกรณ์อะไรสำหรับการเดินทางไหม?', 'Shopkeeper Dan',
     '[{"id": "buy_herbs", "text": "ซื้อสมุนไพรรักษา", "type": "shop"}, {"id": "just_looking", "text": "แค่ดูๆ ครับ", "type": "neutral"}]', '{}', 1),

    -- The Sacred Ritual interactions
    ('awakening-int-----------------001', 'The Sacred Ritual', 'story', 'The Awakening', 
     'พิธีกรรมบรรลุนิติภาวะที่จะเปลี่ยนชีวิต Luminary ไปตลอดกาล', 
     'Luminary เข้าใกล้ต้นไผ่โบราณบน Sacred Tor... แสงสว่างเริ่มส่องออกมา... เครื่องหมายศักดิ์สิทธิ์ปรากฏบนมือซ้าย... นี่คือจุดเริ่มต้นของชะตากรรม Luminary!', 'Narrator', '[]', '{}', 1)
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
    ('ready-adventure-outcome----------001', 'Talk to Chalky', 'ready', 'story', 'Ready for Adventure', 
     'Chalky ยิ้มด้วยความภาคภูมิใจ "ดีมาก! เจ้าเติบโตเป็นหนุ่มที่แข็งแกร่งแล้ว"', 
     '{"relationship": {"chalky": 5}, "experience": 10}', 'Meeting Gemma'),
     
    ('grandfather-comfort-outcome-------001', 'Talk to Chalky', 'nervous', 'story', 'Grandfather''s Comfort', 
     'Chalky วางมือบนไหล่ Luminary "ไม่ต้องกังวล เจ้าจะทำได้ดี ปู่เชื่อในตัวเจ้า"', 
     '{"relationship": {"chalky": 3}, "experience": 5}', 'Meeting Gemma'),

    ('birthday-gift-outcome-------------001', 'Talk to Gemma', 'thanks', 'reward', 'Birthday Gift', 
     'Gemma ยิ้มอย่างมีความสุข "ฉันดีใจที่เธอชอบ! ขอให้โชคดีในพิธีกรรมนะ"', 
     '{"relationship": {"gemma": 10}, "items": [{"code": "birthday-cake-item---------------001", "quantity": 1}]}', 'Festival Preparation'),

    ('gemma-support-outcome-------------001', 'Talk to Gemma', 'worried', 'story', 'Gemma''s Support', 
     'Gemma จับมือ Luminary "ไม่ต้องกังวล ฉันเชื่อว่าเธอจะทำได้ดี"', 
     '{"relationship": {"gemma": 8}, "items": [{"code": "birthday-cake-item---------------001", "quantity": 1}]}', 'Festival Preparation'),

    ('medicinal-herbs-outcome-----------001', 'Talk to Dan', 'buy_herbs', 'reward', 'Medicinal Herbs', 
     'Dan ให้สมุนไพรรักษา "เอานี่ไปเถอะ อาจจะมีประโยชน์ในการเดินทาง"', 
     '{"items": [{"code": "medicinal-herb-item--------------001", "quantity": 3}], "gold": -10}', 'The Sacred Ritual'),

    ('window-shopping-outcome-----------001', 'Talk to Dan', 'just_looking', 'story', 'Window Shopping', 
     'Dan พยักหน้า "ไม่เป็นไร ถ้าต้องการอะไรก็มาหาได้เสมอ"', 
     '{"relationship": {"dan": 2}}', 'The Sacred Ritual'),

    ('luminary-powers-outcome-----------001', 'The Awakening', 'default', 'unlock', 'Luminary Powers Awakened', 
     'พลังของ Luminary ได้ตื่นขึ้นแล้ว! เครื่องหมายศักดิ์สิทธิ์ปรากฏบนมือ และแสงสว่างล้อมรอบร่างกาย', 
     '{"items": [{"code": "sacred-mark-item-----------------001", "quantity": 1}], "experience": 100, "unlock_regions": ["world-of-peace-loc----------------002"]}', null),

    ('festival-atmosphere-outcome-------001', 'Look at Decorations', 'default', 'story', 'Festival Atmosphere', 
     'การตกแต่งที่สวยงามทำให้รู้สึกถึงบรรยากาศเทศกาลอย่างเต็มที่ ชาวบ้านต่างเตรียมตัวสำหรับพิธีกรรมสำคัญ', 
     '{"experience": 5}', 'Getting Supplies'),

    ('room-preparation-outcome----------001', 'Check Room', 'default', 'story', 'Room Preparation', 
     'ห้องสะอาดและเรียบร้อยพร้อมสำหรับวันสำคัญ มีของใช้ส่วนตัวและของที่จะนำไปทำพิธีกรรมวางอยู่', 
     '{"experience": 3}', 'Meeting Gemma'),

    ('village-excitement-outcome--------001', 'Talk to Villagers', 'default', 'story', 'Village Excitement', 
     'ชาวบ้านต่างแสดงความยินดีและให้กำลังใจกับ Luminary ที่จะทำพิธีกรรมบรรลุนิติภาวะ', 
     '{"experience": 8}', 'Getting Supplies')
) AS outcome_info(code, interaction_title, choice_key, outcome_type, title, description, effects, next_event_title)
LEFT JOIN story_events se_next ON se_next.title = outcome_info.next_event_title
WHERE ei.title = outcome_info.interaction_title;
