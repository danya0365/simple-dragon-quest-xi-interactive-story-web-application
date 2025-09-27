-- Dragon Quest XI Story Data Seed - Chapter 1: The Luminary's Awakening (Expanded)
-- Created: 2025-09-26
-- Author: Marosdee Uma
-- Description: Chapter 1 - The beginning of the Luminary's journey in Cobblestone (Expanded Version)
-- Features: Detailed story progression with additional characters, locations, and extended narrative

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
    ('11111111-1111-1111-1111-111111111001', 'Cobblestone', 'หมู่บ้านเล็กๆ ที่เงียบสงบ บ้านเกิดของ Luminary ท่ามกลางภูเขาและป่าไผ่ ที่นี่คือจุดเริ่มต้นของตำนาน Luminary ผู้นำแสงสว่างมาสู่โลก', '/images/regions/cobblestone.svg', '{}', 1, true, false),
    ('11111111-1111-1111-1111-111111111002', 'Heliodor Region', 'ดินแดนที่อยู่ทางทิศตะวันตกของ Cobblestone ซึ่งเป็นที่ตั้งของเมืองหลวง Heliodor ที่ยิ่งใหญ่', '/images/regions/heliodor.svg', '{"completed_events": ["66666666-6666-6666-6666-666666666015"]}', 2, false, true)
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
    -- Cobblestone Locations
    ('22222222-2222-2222-2222-222222222001', 'Cobblestone', 'Luminary''s House', 'บ้านของ Luminary และ Grandpa Chalky ที่อบอุ่นและเต็มไปด้วยความทรงจำ ภายในมีห้องนอนของ Luminary ห้องครัว และห้องนั่งเล่นที่เต็มไปด้วยหนังสือเกี่ยวกับตำนานโบราณ', 'house', '{}', 1, true, false),
    ('22222222-2222-2222-2222-222222222002', 'Cobblestone', 'Village Square', 'จัตุรัสกลางหมู่บ้าน Cobblestone ที่คึกคักในวันเทศกาล มีเวทีไม้ขนาดเล็ก น้ำพุ และร้านค้าชั่วคราวที่ชาวบ้านตั้งขึ้น', 'town', '{}', 2, true, false),
    ('22222222-2222-2222-2222-222222222003', 'Cobblestone', 'Sacred Tor', 'ยอดเขาศักดิ์สิทธิ์ที่มีต้นไผ่โบราณและพลังลึกลับ สถานที่ศักดิ์สิทธิ์ที่บรรพบุรุษของ Luminary เคยมาทำพิธีกรรมมากมาย', 'landmark', '{"completed_events": ["66666666-6666-6666-6666-666666666012"]}', 3, false, true),
    ('22222222-2222-2222-2222-222222222004', 'Cobblestone', 'Village Shop', 'ร้านค้าของหมู่บ้านที่มีของใช้พื้นฐานและอุปกรณ์การเดินทาง ด้านในมีสินค้าหลากหลายตั้งแต่ยาและอาหารไปจนถึงอุปกรณ์การผจญภัย', 'shop', '{}', 4, true, false),
    ('22222222-2222-2222-2222-222222222005', 'Cobblestone', 'Gemma''s House', 'บ้านของ Gemma เพื่อนสนิทของ Luminary ตั้งแต่เด็ก บ้านหลังเล็กๆ ที่สวยงามมีสวนดอกไม้เล็กๆ ด้านหน้า', 'house', '{}', 5, true, false),
    ('22222222-2222-2222-2222-222222222006', 'Cobblestone', 'Village Well', 'บ่อน้ำกลางหมู่บ้านที่เป็นจุดรวมตัวของชาวบ้าน น้ำในบ่อสะอาดใสและเชื่อกันว่ามีพลังรักษา', 'landmark', '{}', 6, true, false),
    ('22222222-2222-2222-2222-222222222007', 'Cobblestone', 'Village Inn', 'โรงแรมเล็กๆ ของหมู่บ้านที่มีห้องพักไม่กี่ห้อง เป็นที่พักของนักเดินทางที่ผ่านมา', 'inn', '{}', 7, true, false),
    ('22222222-2222-2222-2222-222222222008', 'Cobblestone', 'Blacksmith', 'โรงตีเหล็กของหมู่บ้านที่มีช่างตีเหล็กฝีมือดี ทำอาวุธและเกราะให้กับนักผจญภัย', 'shop', '{}', 8, true, false),
    ('22222222-2222-2222-2222-222222222009', 'Cobblestone', 'Bamboo Forest', 'ป่าไผ่โบราณที่ล้อมรอบหมู่บ้าน Cobblestone เต็มไปด้วยสมุนไพรหายากและสัตว์ป่าสวยงาม', 'dungeon', '{"completed_events": ["66666666-6666-6666-6666-666666666008"]}', 9, false, true),
    ('22222222-2222-2222-2222-222222222010', 'Cobblestone', 'Training Grounds', 'สนามฝึกซ้อมของหมู่บ้านที่ Luminary ใช้ฝึกวิชาดาบตั้งแต่เด็ก', 'landmark', '{}', 10, true, false),
    
    -- Heliodor Region Locations (Locked initially)
    ('22222222-2222-2222-2222-222222222011', 'Heliodor Region', 'Heliodor Castle', 'ปราสาทอันยิ่งใหญ่ของเมือง Heliodor ที่เป็นศูนย์กลางการปกครองของอาณาจักร', 'castle', '{"completed_events": ["66666666-6666-6666-6666-666666666015"]}', 1, false, true),
    ('22222222-2222-2222-2222-222222222012', 'Heliodor Region', 'Heliodor City', 'เมืองหลวง Heliodor ที่เจริญรุ่งเรืองและคึกคักไปด้วยพ่อค้าแม่ค้า', 'town', '{"completed_events": ["66666666-6666-6666-6666-666666666015"]}', 2, false, true)
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
    ('33333333-3333-3333-3333-333333333001', 1, 'The Luminary''s Awakening', 'จุดเริ่มต้นของการผจญภัย เมื่อ Luminary ตื่นขึ้นในวันเกิดปีที่ 16 และเตรียมตัวสำหรับพิธีกรรมบรรลุนิติภาวะที่จะเปิดเผยชะตากรรมอันยิ่งใหญ่ของเขา', '{}', 1, true)
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
    -- Main Characters
    ('44444444-4444-4444-4444-444444444001', 'Luminary', 'ตัวเอกของเรื่อง ผู้ถูกเลือกให้เป็น Luminary ผู้นำแสงสว่างมาสู่โลก เด็กหนุ่มที่เติบโตมาในหมู่บ้าน Cobblestone และไม่รู้ตัวว่าตัวเองคือผู้ถูกเลือก', 'party_member', '/images/characters/luminary.svg', 
     '{"hp": 150, "mp": 80, "level": 1, "attack": 22, "defense": 15, "agility": 12, "luck": 10}', 
     '["Sword Strike", "Heal", "Zap", "Falcon Slash"]', true, true),
     
    ('44444444-4444-4444-4444-444444444002', 'Chalky', 'ปู่ของ Luminary ผู้เลี้ยงดู Luminary มาตั้งแต่เด็ก คนเดียวที่รู้ความจริงเกี่ยวกับต้นกำเนิดของ Luminary และพร้อมจะเปิดเผยความลับในวันสำคัญ', 'npc', '/images/characters/chalky.svg',
     '{"hp": 100, "mp": 50, "level": 1}', '["Heal", "Protect"]', false, true),

    ('44444444-4444-4444-4444-444444444003', 'Gemma', 'เพื่อนสนิทของ Luminary ตั้งแต่เด็ก สาวน้อยที่ใจดีและเป็นห่วงเป็นใย เธอมีความสามารถในการทำอาหารและมักจะช่วยเหลือ Luminary ในทุกเรื่อง', 'npc', '/images/characters/gemma.svg',
     '{"hp": 80, "mp": 40, "level": 1}', '["Cooking", "First Aid"]', false, true),

    -- Village Characters
    ('44444444-4444-4444-4444-444444444004', 'Mayor', 'นายกเทศมนตรีของหมู่บ้าน Cobblestone ผู้ใจดีและเป็นที่เคารพของชาวบ้าน เขาเป็นผู้นำที่ซื่อสัตย์และดูแลชาวบ้านเหมือนลูกหลาน', 'npc', '/images/characters/mayor.svg',
     '{"hp": 90, "mp": 30, "level": 1}', '["Leadership"]', false, true),

    ('44444444-4444-4444-4444-444444444005', 'Shopkeeper Dan', 'เจ้าของร้านค้าในหมู่บ้าน คนใจดีที่คอยช่วยเหลือนักผจญภัย เขามีสินค้าหลากหลายและรู้จักนักผจญภัยมากมาย', 'npc', '/images/characters/shopkeeper.svg',
     '{"hp": 60, "mp": 20, "level": 1}', '["Bartering", "Appraisal"]', false, true),

    ('44444444-4444-4444-4444-444444444006', 'Blacksmith Tom', 'ช่างตีเหล็กของหมู่บ้าน ผู้มีฝีมือการตีเหล็กที่เก่งกาจ เขาเป็นคนที่เข้มงวดแต่ใจดี และเป็นอาจารย์สอนดาบให้กับ Luminary', 'npc', '/images/characters/blacksmith.svg',
     '{"hp": 120, "mp": 10, "level": 1}', '["Smithing", "Swordsmanship"]', false, true),

    ('44444444-4444-4444-4444-444444444007', 'Innkeeper Mary', 'เจ้าของโรงแรมของหมู่บ้าน สาวใหญ่ที่เป็นกันเองและเป็นห่วงเป็นใยนักเดินทาง เธอมีข่าวสารและเรื่องเล่าจากที่ต่างๆ มากมาย', 'npc', '/images/characters/innkeeper.svg',
     '{"hp": 70, "mp": 25, "level": 1}', '["Hospitality", "Information"]', false, true),

    ('44444444-4444-4444-4444-444444444008', 'Elder', 'ผู้เฒ่าของหมู่บ้าน ผู้มีความรู้เรื่องตำนานและประวัติศาสตร์ของหมู่บ้าน เขาเป็นที่ปรึกษาของนายกเทศมนตรีและชาวบ้าน', 'npc', '/images/characters/elder.svg',
     '{"hp": 85, "mp": 60, "level": 1}', '["Wisdom", "History"]', false, true),

    ('44444444-4444-4444-4444-444444444009', 'Village Children', 'เด็กๆ ในหมู่บ้านที่ชอบเล่นกับ Luminary และมองว่าเขาเป็นพี่ชายที่เก่งและเจ้าเล่ห์', 'npc', '/images/characters/children.svg',
     '{"hp": 40, "mp": 15, "level": 1}', '["Playfulness"]', false, true),

    -- Special Characters (Appear later)
    ('44444444-4444-4444-4444-444444444010', 'Mysterious Traveler', 'นักเดินทางลึกลับที่ปรากฏตัวในหมู่บ้านเป็นครั้งคราว ไม่มีใครรู้จักตัวตนที่แท้จริงของเขา', 'npc', '/images/characters/traveler.svg',
     '{"hp": 200, "mp": 100, "level": 5}', '["Stealth", "Mystery"]', false, false)
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
    -- Weapons
    ('55555555-5555-5555-5555-555555555001', 'Cobblestone Sword', 'ดาบไม้ที่ Chalky ทำให้ Luminary สำหรับการฝึกซ้อม ดาบที่เบาและคล่องแคล่วเหมาะสำหรับผู้เริ่มต้น', 'weapon', 'common', 
     '{"attack": 15, "accuracy": 90}', '{}', '/images/items/cobblestone_sword.svg', true),
     
    ('55555555-5555-5555-5555-555555555002', 'Training Sword', 'ดาบฝึกซ้อมที่ Blacksmith Tom ทำให้ หนักกว่าดาบไม้แต่ทำให้กล้ามเนื้อแข็งแรงขึ้น', 'weapon', 'common',
     '{"attack": 18, "accuracy": 85}', '{}', '/images/items/training_sword.svg', false),

    -- Armor
    ('55555555-5555-5555-5555-555555555003', 'Village Clothes', 'เสื้อผ้าชาวบ้านที่สวมใส่ในชีวิตประจำวัน เบาและสบายแต่ไม่ค่อยป้องกันได้ดี', 'armor', 'common',
     '{"defense": 5}', '{}', '/images/items/village_clothes.svg', true),

    ('55555555-5555-5555-5555-555555555004', 'Leather Armor', 'เกราะหนังที่ Blacksmith Tom ทำให้ ป้องกันได้ดีกว่าเสื้อผ้าทั่วไป', 'armor', 'uncommon',
     '{"defense": 12}', '{}', '/images/items/leather_armor.svg', false),

    -- Consumables
    ('55555555-5555-5555-5555-555555555005', 'Medicinal Herb', 'สมุนไพรรักษาที่หาได้ในป่าใกล้หมู่บ้าน มีกลิ่นหอมและรสชาติขมเล็กน้อย', 'consumable', 'common',
     '{}', '{"heal": 30}', '/images/items/herb.svg', false),

    ('55555555-5555-5555-5555-555555555006', 'Strong Medicine', 'ยารักษาที่เข้มข้นกว่าสมุนไพรทั่วไป ทำจากสมุนไพรหายากหลายชนิด', 'consumable', 'uncommon',
     '{}', '{"heal": 60}', '/images/items/strong_medicine.svg', false),

    ('55555555-5555-5555-5555-555555555007', 'Birthday Cake', 'เค้กวันเกิดที่ Gemma ทำให้ Luminary หวานมันและอร่อยมาก มีผลให้ฟื้นพลังทั้งชีวิตและเวทมนตร์', 'consumable', 'uncommon',
     '{}', '{"heal": 50, "mp_restore": 25}', '/images/items/birthday_cake.svg', false),

    ('55555555-5555-5555-5555-555555555008', 'Gemma''s Special Meal', 'อาหารพิเศษที่ Gemma ทำให้ มีส่วนผสมของสมุนไพรหายากที่ช่วยฟื้นพลัง', 'consumable', 'rare',
     '{}', '{"heal": 80, "mp_restore": 40, "temporary_stats": {"attack": 5, "defense": 5}}', '/images/items/special_meal.svg', false),

    -- Key Items
    ('55555555-5555-5555-5555-555555555009', 'Sacred Mark', 'เครื่องหมายศักดิ์สิทธิ์ที่ปรากฏบนมือของ Luminary เป็นสัญลักษณ์ของผู้ถูกเลือก', 'key_item', 'legendary',
     '{}', '{"luminary_power": true, "unlock_abilities": ["Zap"]}', '/images/items/sacred_mark.svg', false),

    ('55555555-5555-5555-5555-555555555010', 'Chalky''s Letter', 'จดหมายจากปู่ Chalky ที่มอบให้ Luminary ก่อนออกเดินทาง มีข้อมูลสำคัญเกี่ยวกับต้นกำเนิด', 'key_item', 'rare',
     '{}', '{"information": "luminary_origin"}', '/images/items/letter.svg', false),

    -- Materials
    ('55555555-5555-5555-5555-555555555011', 'Bamboo Shoot', 'หน่อไม้สดจากป่าไผ่ สามารถนำไปทำอาหารหรือขายได้', 'material', 'common',
     '{}', '{"cooking_ingredient": true}', '/images/items/bamboo_shoot.svg', false),

    ('55555555-5555-5555-5555-555555555012', 'Herb Seeds', 'เมล็ดพันธุ์สมุนไพรที่สามารถปลูกเพื่อเก็บเกี่ยวสมุนไพรได้', 'material', 'common',
     '{}', '{"plantable": true}', '/images/items/herb_seeds.svg', false),

    -- Accessories
    ('55555555-5555-5555-5555-555555555013', 'Lucky Charm', 'เครื่องรางที่ Gemma มอบให้เป็นของขวัญวันเกิด เชื่อกันว่าช่วยเสริมดวง', 'accessory', 'uncommon',
     '{"luck": 5}', '{}', '/images/items/lucky_charm.svg', false),

    ('55555555-5555-5555-5555-555555555014', 'Training Gloves', 'ถุงมือฝึกซ้อมที่ช่วยเพิ่มความแม่นยำในการใช้ดาบ', 'accessory', 'common',
     '{"accuracy": 10}', '{}', '/images/items/training_gloves.svg', false)
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
    -- Morning Events
    ('66666666-6666-6666-6666-666666666001', 'The Luminary''s Awakening', 'Luminary''s House', 'Birthday Awakening', 'เช้าวันเกิดปีที่ 16 ของ Luminary วันที่จะเปลี่ยนชีวิตไปตลอดกาล ตื่นขึ้นมาพร้อมกับความรู้สึกว่าจะเกิดเรื่องพิเศษในวันนี้', 'dialogue', '{}', 1, true),
    ('66666666-6666-6666-6666-666666666002', 'The Luminary''s Awakening', 'Training Grounds', 'Morning Training', 'การฝึกซ้อมดาบในตอนเช้ากับ Blacksmith Tom ก่อนวันสำคัญ', 'training', '{"completed_events": ["66666666-6666-6666-6666-666666666001"]}', 2, false),
    
    -- Village Exploration Events
    ('66666666-6666-6666-6666-666666666003', 'The Luminary''s Awakening', 'Gemma''s House', 'Meeting Gemma', 'การพบกับ Gemma และรับเค้กวันเกิดที่เธอทำให้ด้วยความรักและห่วงใย', 'dialogue', '{"completed_events": ["66666666-6666-6666-6666-666666666002"]}', 3, false),
    ('66666666-6666-6666-6666-666666666004', 'The Luminary''s Awakening', 'Village Square', 'Festival Preparation', 'การเตรียมตัวสำหรับเทศกาลและพิธีกรรมบรรลุนิติภาวะ ชาวบ้านต่างตื่นเต้นและเตรียมการต่างๆ', 'exploration', '{"completed_events": ["66666666-6666-6666-6666-666666666003"]}', 4, false),
    ('66666666-6666-6666-6666-666666666005', 'The Luminary''s Awakening', 'Village Well', 'Well Wishes', 'การไปรับน้ำที่บ่อน้ำและพบกับชาวบ้านที่มาอวยพรวันเกิด', 'dialogue', '{"completed_events": ["66666666-6666-6666-6666-666666666004"]}', 5, false),
    ('66666666-6666-6666-6666-666666666006', 'The Luminary''s Awakening', 'Village Shop', 'Getting Supplies', 'การซื้อของใช้สำหรับการเดินทางที่จะมาถึง พูดคุยกับ Dan เจ้าของร้าน', 'shopping', '{"completed_events": ["66666666-6666-6666-6666-666666666005"]}', 6, false),
    ('66666666-6666-6666-6666-666666666007', 'The Luminary''s Awakening', 'Blacksmith', 'Sword Blessing', 'การพบกับ Blacksmith Tom และรับพรจากอาวุธที่เขาตีขึ้นมา', 'dialogue', '{"completed_events": ["66666666-6666-6666-6666-666666666006"]}', 7, false),
    ('66666666-6666-6666-6666-666666666008', 'The Luminary''s Awakening', 'Bamboo Forest', 'Forest Meditation', 'การไปสมาธิในป่าไผ่เพื่อเตรียมจิตใจก่อนพิธีกรรม', 'exploration', '{"completed_events": ["66666666-6666-6666-6666-666666666007"]}', 8, false),
    ('66666666-6666-6666-6666-666666666009', 'The Luminary''s Awakening', 'Village Inn', 'Traveler''s Tale', 'การพบกับนักเดินทางลึกลับที่มาบอกเรื่องราวเกี่ยวกับโลกภายนอก', 'dialogue', '{"completed_events": ["66666666-6666-6666-6666-666666666008"]}', 9, false),
    ('66666666-6666-6666-6666-666666666010', 'The Luminary''s Awakening', 'Elder''s House', 'Ancient Wisdom', 'การไปพบกับผู้เฒ่าเพื่อขึ้นความรู้เกี่ยวกับตำนาน Luminary', 'dialogue', '{"completed_events": ["66666666-6666-6666-6666-666666666009"]}', 10, false),
    
    -- Climax Events
    ('66666666-6666-6666-6666-666666666011', 'The Luminary''s Awakening', 'Village Square', 'Festival Gathering', 'การรวมตัวกันของชาวบ้านที่จัตุรัสเพื่อเริ่มพิธีกรรม', 'story', '{"completed_events": ["66666666-6666-6666-6666-666666666010"]}', 11, false),
    ('66666666-6666-6666-6666-666666666012', 'The Luminary''s Awakening', 'Sacred Tor', 'The Sacred Journey', 'การเดินทางไปยัง Sacred Tor พร้อมกับ Chalky และชาวบ้าน', 'story', '{"completed_events": ["66666666-6666-6666-6666-666666666011"]}', 12, false),
    ('66666666-6666-6666-6666-666666666013', 'The Luminary''s Awakening', 'Sacred Tor', 'Chalky''s Revelation', 'Chalky เปิดเผยความลับเกี่ยวกับต้นกำเนิดที่แท้จริงของ Luminary', 'story', '{"completed_events": ["66666666-6666-6666-6666-666666666012"]}', 13, false),
    ('66666666-6666-6666-6666-666666666014', 'The Luminary''s Awakening', 'Sacred Tor', 'The Sacred Ritual', 'พิธีกรรมบรรลุนิติภาวะที่จะเปิดเผยชะตากรรมของ Luminary', 'story', '{"completed_events": ["66666666-6666-6666-6666-666666666013"]}', 14, false),
    ('66666666-6666-6666-6666-666666666015', 'The Luminary''s Awakening', 'Sacred Tor', 'Luminary''s Awakening', 'จุดสิ้นสุดของพิธีกรรมและการตื่นขึ้นของพลัง Luminary', 'story', '{"completed_events": ["66666666-6666-6666-6666-666666666014"]}', 15, false)
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
    -- Birthday Awakening interactions
    ('77777777-7777-7777-7777-777777777001', 'Birthday Awakening', 'talk', 'Talk to Chalky', 
     'พูดคุยกับปู่ Chalky เกี่ยวกับวันเกิดและพิธีกรรมที่จะมาถึงในวันนี้', 
     'เช้าดี Luminary! วันนี้เป็นวันเกิดปีที่ 16 ของเจ้า วันสำคัญที่เจ้าจะต้องไปทำพิธีกรรมบรรลุนิติภาวะที่ Sacred Tor แต่ก่อนอื่น... มีเรื่องสำคัญที่ปู่ต้องบอกเจ้า', 'Chalky', 
     '[{"id": "ready", "text": "ผมพร้อมแล้วครับ ปู่", "type": "positive"}, {"id": "nervous", "text": "ผมรู้สึกกังวลนิดหน่อย", "type": "neutral"}, {"id": "what_secret", "text": "มีเรื่องสำคัญอะไรครับ", "type": "curious"}]', '{}', 1),

    ('77777777-7777-7777-7777-777777777002', 'Birthday Awakening', 'examine', 'Check Room', 
     'ตรวจสอบห้องของตัวเองและเตรียมของสำหรับวันสำคัญ มีของขวัญวันเกิดจากปู่ Chalky วางอยู่บนโต๊ะ', '', '[]', '{}', 2),

    -- Morning Training interactions
    ('77777777-7777-7777-7777-777777777003', 'Morning Training', 'talk', 'Train with Tom', 
     'ฝึกซ้อมดาบกับ Blacksmith Tom ผู้เป็นอาจารย์ของคุณ', 
     'วันนี้เป็นวันสำคัญของเจ้านะ Luminary! มาฝึกซ้อมกันอีกหน่อยก่อนไปพิธีกรรม เจ้าเก่งขึ้นเรื่อยๆ เลย', 'Blacksmith Tom',
     '[{"id": "train_hard", "text": "ฝึกอย่างหนัก", "type": "positive"}, {"id": "light_training", "text": "ฝึกเบาๆ ก็พอ", "type": "neutral"}]', '{}', 1),

    ('77777777-7777-7777-7777-777777777004', 'Morning Training', 'examine', 'Inspect Training Equipment', 
     'ตรวจสอบอุปกรณ์ฝึกซ้อมและอาวุธต่างๆ ที่โรงตีเหล็ก', '', '[]', '{}', 2),

    -- Meeting Gemma interactions
    ('77777777-7777-7777-7777-777777777005', 'Meeting Gemma', 'talk', 'Talk to Gemma', 
     'พูดคุยกับ Gemma และรับเค้กวันเกิดที่เธอทำให้ด้วยความรัก', 
     'สุขสันต์วันเกิด Luminary! ฉันทำเค้กให้เธอเป็นของขวัญ หวังว่าเธอจะชอบนะ วันนี้เธอจะไปทำพิธีกรรมที่ Sacred Tor ใช่ไหม? ฉันกังวลเกี่ยวกับเธอมาก', 'Gemma',
     '[{"id": "thanks_love", "text": "ขอบคุณมากเลย Gemma ฉันรักเค้กของเธอ", "type": "positive"}, {"id": "worried_too", "text": "ฉันก็กังวลเหมือนกัน", "type": "neutral"}, {"id": "reassure", "text": "ไม่ต้องกังวลหรอก ฉันจะกลับมาแน่นอน", "type": "positive"}]', '{}', 1),

    ('77777777-7777-7777-7777-777777777006', 'Meeting Gemma', 'examine', 'Look at Gemma''s Garden', 
     'ดูสวนดอกไม้สวยงามที่ Gemia ดูแลอยู่ข้างบ้านของเธอ', '', '[]', '{}', 2),

    -- Festival Preparation interactions  
    ('77777777-7777-7777-7777-777777777007', 'Festival Preparation', 'talk', 'Talk to Villagers', 
     'พูดคุยกับชาวบ้านที่กำลังเตรียมงานเทศกาลและตกแต่งหมู่บ้าน', 
     'วันนี้เป็นวันสำคัญของ Luminary เลยนะ! ทุกคนในหมู่บ้านต่างก็ตื่นเต้นกับพิธีกรรมบรรลุนิติภาวะ เราได้เตรียมการตกแต่งหมู่บ้านเพื่อเป็นการเฉลิมฉลอง', 'Villager',
     '[]', '{}', 1),

    ('77777777-7777-7777-7777-777777777008', 'Festival Preparation', 'examine', 'Look at Decorations', 
     'ดูการตกแต่งงานเทศกาลที่สวยงาม มีดอกไม้และโบว์สีสันสดใสตามบ้านต่างๆ', '', '[]', '{}', 2),

    ('77777777-7777-7777-7777-777777777009', 'Festival Preparation', 'talk', 'Talk to Mayor', 
     'พูดคุยกับนายกเทศมนตรีเกี่ยวกับความสำคัญของพิธีกรรม', 
     'Luminary! วันนี้เป็นวันที่สำคัญที่สุดในชีวิตของเจ้า พิธีกรรมบรรลุนิติภาวะจะเปิดเผยว่าเจ้าเป็นผู้ถูกเลือกหรือไม่ ทุกคนในหมู่บ้านต่างก็ภูมิใจในตัวเจ้ามาก', 'Mayor',
     '[{"id": "thankful", "text": "ขอบคุณมากครับนายก", "type": "positive"}, {"id": "humble", "text": "ฉันจะทำให้ดีที่สุด", "type": "neutral"}]', '{}', 3),

    -- Well Wishes interactions
    ('77777777-7777-7777-7777-777777777010', 'Well Wishes', 'talk', 'Talk to Village Children', 
     'พูดคุยกับเด็กๆ ในหมู่บ้านที่มาเล่นที่บ่อน้ำและอวยพรวันเกิด', 
     'พี่ Luminary! สุขสันต์วันเกิดนะ! พวกเราหวังว่าพี่จะผ่านพิธีกรรมได้ดีๆ นะ!', 'Village Children',
     '[{"id": "play_with", "text": "เล่นด้วยกันหน่อย", "type": "positive"}, {"id": "give_candy", "text": "มีลูกอมให้", "type": "positive"}]', '{}', 1),

    ('77777777-7777-7777-7777-777777777011', 'Well Wishes', 'examine', 'Draw Water from Well', 
     'ตักน้ำจากบ่อน้ำศักดิ์สิทธิ์ น้ำใสและเย็นสบาย', '', '[]', '{}', 2),

    -- Getting Supplies interactions
    ('77777777-7777-7777-7777-777777777012', 'Getting Supplies', 'talk', 'Talk to Dan', 
     'พูดคุยกับ Dan เจ้าของร้านค้าเกี่ยวกับการเดินทางที่จะมาถึง', 
     'สวัสดี Luminary! วันนี้เป็นวันสำคัญของเจ้าเลยนะ มีอะไรให้ช่วยไหม? เจ้าต้องการอุปกรณ์อะไรสำหรับการเดินทางไหม? เจ้าอาจจะต้องการยาและอาหารไปกับเจ้า', 'Shopkeeper Dan',
     '[{"id": "buy_herbs", "text": "ซื้อสมุนไพรรักษา", "type": "shop"}, {"id": "buy_food", "text": "ซื้ออาหาร", "type": "shop"}, {"id": "just_looking", "text": "แค่ดูๆ ครับ", "type": "neutral"}]', '{}', 1),

    ('77777777-7777-7777-7777-777777777013', 'Getting Supplies', 'examine', 'Browse Shop Items', 
     'ดูสินค้าต่างๆ ในร้าน มีทั้งอาวุธ เกราะ ยา และของใช้ต่างๆ', '', '[]', '{}', 2),

    -- Sword Blessing interactions
    ('77777777-7777-7777-7777-777777777014', 'Sword Blessing', 'talk', 'Receive Sword Blessing', 
     'รับพรจาก Blacksmith Tom และดาบฝึกซ้อมที่เขาทำให้เป็นพิเศษ', 
     'Luminary! นี่คือดาบฝึกซ้อมที่ผมทำให้เป็นพิเศษสำหรับเจ้า ดาบเล่มนี้ผมได้ใส่พลังแห่งการปกป้องไว้ เจ้าจะใช้มันปกป้องตัวเองและคนที่เจ้ารักได้', 'Blacksmith Tom',
     '[{"id": "grateful", "text": "ขอบคุณมากครับ Tom", "type": "positive"}, {"id": "promise", "text": "ฉันจะใช้ดาบนี้ดีๆ", "type": "positive"}]', '{}', 1),

    -- Forest Meditation interactions
    ('77777777-7777-7777-7777-777777777015', 'Forest Meditation', 'examine', 'Meditate at Ancient Tree', 
     'สมาธิที่ต้นไม้โบราณในป่าไผ่ เพื่อเตรียมจิตใจก่อนพิธีกรรม', '', '[]', '{}', 1),

    ('77777777-7777-7777-7777-777777777016', 'Forest Meditation', 'examine', 'Collect Herbs', 
     'เก็บสมุนไพรหายากในป่าไผ่ มีสมุนไพรรักษาหลายชนิด', '', '[]', '{}', 2),

    -- Traveler''s Tale interactions
    ('77777777-7777-7777-7777-777777777017', 'Traveler''s Tale', 'talk', 'Listen to Traveler''s Story', 
     'ฟังเรื่องราวจากนักเดินทางลึกลับเกี่ยวกับโลกภายนอก', 
     'ดูเหมือนว่าวันนี้จะเป็นวันสำคัญสำหรับเจ้านะ... ผมเคยเห็นผู้คนมาทำพิธีกรรมแบบนี้มาก่อนในที่อื่น... โลกนี้กว้างใหญ่กว่าที่เจ้าคิดนะ', 'Mysterious Traveler',
     '[{"id": "curious", "text": "เคยเห็นอะไรมาบ้าง", "type": "curious"}, {"id": "skeptical", "text": "ไม่เชื่อหรอก", "type": "neutral"}]', '{}', 1),

    -- Ancient Wisdom interactions
    ('77777777-7777-7777-7777-777777777018', 'Ancient Wisdom', 'talk', 'Seek Elder''s Guidance', 
     'ขึ้นความรู้เกี่ยวกับตำนาน Luminary จากผู้เฒ่า', 
     'Luminary... มานั่งคุยกับผมสักหน่อย วันนี้เป็นวันที่เราทุกคนรอคอยมานาน ตำนานเก่าแก่เล่าว่า เมื่อ Luminary ตื่นขึ้น แสงสว่างจะกลับมาสู่โลกอีกครั้ง', 'Elder',
     '[{"id": "learn_more", "text": "สอนเรื่องราวเพิ่มเติมหน่อย", "type": "curious"}, {"id": "ready", "text": "ฉันพร้อมแล้ว", "type": "positive"}]', '{}', 1),

    -- Climax Event interactions
    ('77777777-7777-7777-7777-777777777019', 'Festival Gathering', 'story', 'Village Assembly', 
     'การรวมตัวกันของชาวบ้านทั้งหมู่บ้านเพื่อเริ่มพิธีกรรม', 
     'ชาวบ้านทุกคนรวมตัวกันที่จัตุรัส พร้อมกับเสียงดนตรีและเพลงสรรเสริญ นายกเทศมนตรีกล่าวคำปราศรัยและเชิญ Luminary ขึ้นเวที', 'Narrator', '[]', '{}', 1),

    ('77777777-7777-7777-7777-777777777020', 'The Sacred Journey', 'story', 'Journey to Sacred Tor', 
     'การเดินทางไปยัง Sacred Tor พร้อมกับ Chalky และชาวบ้าน', 
     'Luminary และชาวบ้านเดินทางไปยัง Sacred Tor พร้อมกับคบเพลิงและเครื่องสักการะ ทางเดินมืดและเงียบ แต่มีแสงจันทร์ส่องทาง', 'Narrator', '[]', '{}', 1),

    ('77777777-7777-7777-7777-777777777021', 'Chalky''s Revelation', 'story', 'The Truth Revealed', 
     'Chalky เปิดเผยความลับเกี่ยวกับต้นกำเนิดที่แท้จริงของ Luminary', 
     'Luminary... ตอนนี้ถึงเวลาที่เจ้าต้องรู้ความจริง เจ้าไม่ใช่เด็กกำพร้าธรรมดา... เจ้าคือลูกหลานของ Luminary ผู้นำแสงสว่างในตำนาน', 'Chalky',
     '[{"id": "shocked", "text": "ไม่น่าเชื่อ...", "type": "shocked"}, {"id": "accept", "text": "ฉันเข้าใจแล้ว", "type": "accept"}]', '{}', 1),

    ('77777777-7777-7777-7777-777777777022', 'The Sacred Ritual', 'story', 'Ritual Begins', 
     'พิธีกรรมบรรลุนิติภาวะเริ่มขึ้น ณ ยอดเขาศักดิ์สิทธิ์', 
     'Luminary เข้าใกล้ต้นไผ่โบราณบน Sacred Tor... แสงจันทร์ส่องลงมา... พลังลึกลับเริ่มสั่นคลอน... นี่คือจุดเริ่มต้นของชะตากรรม', 'Narrator', '[]', '{}', 1),

    ('77777777-7777-7777-7777-777777777023', 'Luminary''s Awakening', 'story', 'The Awakening', 
     'จุดสิ้นสุดของพิธีกรรมและการตื่นขึ้นของพลัง Luminary', 
     'แสงสว่างระเบิดออกจากต้นไผ่โบราณ! เครื่องหมายศักดิ์สิทธิ์ปรากฏบนมือซ้ายของ Luminary... พลังแห่งแสงสว่างไหลเวียนในร่างกาย... Luminary ได้ตื่นขึ้นแล้ว!', 'Narrator', '[]', '{}', 1)
) AS interaction_info(id, event_name, interaction_type, title, description, dialogue_text, character_speaker, choices, requirements, display_order)
WHERE se.title = interaction_info.event_name;

-- === EVENT OUTCOMES ===
INSERT INTO public.event_outcomes (id, interaction_id, choice_key, outcome_text, effects, next_event_id, auto_unlocked_locations, auto_unlocked_regions)
SELECT 
  outcome_info.id::uuid,
  ei.id AS interaction_id,
  outcome_info.choice_key,
  outcome_info.outcome_text,
  outcome_info.effects::jsonb,
  outcome_info.next_event_id::uuid,
  outcome_info.auto_unlocked_locations::uuid[],
  outcome_info.auto_unlocked_regions::uuid[]
FROM event_interactions ei
CROSS JOIN (
  VALUES 
    -- Birthday Awakening outcomes
    ('88888888-8888-8888-8888-888888888001', 'Talk to Chalky', 'ready', 
     'Luminary พร้อมเผชิญหน้ากับชะตากรรม ปู่ Chalky ยิ้มและให้กำลังใจ', 
     '{"experience": 10, "relationship": {"Chalky": 5}}', '66666666-6666-6666-6666-666666666002', '{}', '{}'),

    ('88888888-8888-8888-8888-888888888002', 'Talk to Chalky', 'nervous', 
     'Chalky ปลอบโยน Luminary และบอกว่าการรู้สึกกังวลเป็นเรื่องปกติ', 
     '{"experience": 5, "relationship": {"Chalky": 3}}', '66666666-6666-6666-6666-666666666002', '{}', '{}'),

    ('88888888-8888-8888-8888-888888888003', 'Talk to Chalky', 'what_secret', 
     'Chalky บอกว่าจะเปิดเผยความลับในภายหลัง ตอนนี้ให้เตรียมตัวไปทำพิธีกรรมก่อน', 
     '{"experience": 8, "relationship": {"Chalky": 4}}', '66666666-6666-6666-6666-666666666002', '{}', '{}'),

    ('88888888-8888-8888-8888-888888888004', 'Check Room', 'default', 
     'Luminary พบของขวัญวันเกิดจากปู่ Chalky - ดาบไม้ Cobblestone Sword และชุดผ้าสะอาด', 
     '{"items": [{"id": "55555555-5555-5555-5555-555555555001", "quantity": 1}]}', NULL, '{}', '{}'),

    -- Morning Training outcomes
    ('88888888-8888-8888-8888-888888888005', 'Train with Tom', 'train_hard', 
     'การฝึกอย่างหนักทำให้ Luminary เก่งขึ้น แต่เหนื่อยมาก', 
     '{"experience": 15, "gold": 10}', '66666666-6666-6666-6666-666666666003', '{}', '{}'),

    ('88888888-8888-8888-8888-888888888006', 'Train with Tom', 'light_training', 
     'การฝึกเบาๆ ทำให้ Luminary สดชื่นและพร้อมสำหรับวันสำคัญ', 
     '{"experience": 8, "gold": 5}', '66666666-6666-6666-6666-666666666003', '{}', '{}'),

    ('88888888-8888-8888-8888-888888888007', 'Inspect Training Equipment', 'default', 
     'Luminary พบอุปกรณ์ฝึกซ้อมหลายอย่าง รวมถึงถุงมือฝึกซ้อมที่ดูเหมาะกับเขา', 
     '{"items": [{"id": "55555555-5555-5555-5555-555555555014", "quantity": 1}]}', NULL, '{}', '{}'),

    -- Meeting Gemma outcomes
    ('88888888-8888-8888-8888-888888888008', 'Talk to Gemma', 'thanks_love', 
     'Gemma ยิ้มและมอบเค้กวันเกิดให้ เธอดีใจที่ Luminary ชอบของขวัญของเธอ', 
     '{"items": [{"id": "55555555-5555-5555-5555-555555555007", "quantity": 1}], "relationship": {"Gemma": 8}}', '66666666-6666-6666-6666-666666666004', '{}', '{}'),

    ('88888888-8888-8888-8888-888888888009', 'Talk to Gemma', 'worried_too', 
     'Gemma กอด Luminary และบอกว่าเธอจะรอเขากลับมา ทั้งคู่สัญญาว่าจะดูแลกัน', 
     '{"relationship": {"Gemma": 10}}', '66666666-6666-6666-6666-666666666004', '{}', '{}'),

    ('88888888-8888-8888-8888-888888888010', 'Talk to Gemma', 'reassure', 
     'Gemma ยิ้มและบอกว่าเธอเชื่อมั่นใน Luminary เธอมอบเครื่องรางเสริมดวงให้', 
     '{"items": [{"id": "55555555-5555-5555-5555-555555555013", "quantity": 1}], "relationship": {"Gemma": 7}}', '66666666-6666-6666-6666-666666666004', '{}', '{}'),

    ('88888888-8888-8888-8888-888888888011', 'Look at Gemma''s Garden', 'default', 
     'สวนดอกไม้ของ Gemma สวยงามมาก Luminary เก็บดอกไม้สวยๆ ไว้เป็นที่ระลึก', 
     '{"items": [{"id": "55555555-5555-5555-5555-555555555011", "quantity": 3}]}', NULL, '{}', '{}'),

    -- Festival Preparation outcomes
    ('88888888-8888-8888-8888-888888888012', 'Talk to Villagers', 'default', 
     'ชาวบ้านต่างให้กำลังใจ Luminary และอวยพรให้เขาผ่านพิธีกรรมได้ดี', 
     '{"experience": 5, "relationship": {"Villagers": 3}}', NULL, '{}', '{}'),

    ('88888888-8888-8888-8888-888888888013', 'Look at Decorations', 'default', 
     'การตกแต่งงานเทศกาลสวยงามมาก Luminary รู้สึกภูมิใจในหมู่บ้านของตัวเอง', 
     '{"experience": 3}', NULL, '{}', '{}'),

    ('88888888-8888-8888-8888-888888888014', 'Talk to Mayor', 'thankful', 
     'นายกเทศมนตรียิ้มและบอกว่าหมู่บ้านภูมิใจใน Luminary มาก', 
     '{"experience": 10, "relationship": {"Mayor": 5}}', '66666666-6666-6666-6666-666666666005', '{}', '{}'),

    ('88888888-8888-8888-8888-888888888015', 'Talk to Mayor', 'humble', 
     'นายกเทศมนตรีชื่นชมความอ่อนน้อมถ่อมตนของ Luminary', 
     '{"experience": 8, "relationship": {"Mayor": 4}}', '66666666-6666-6666-6666-666666666005', '{}', '{}'),

    -- Well Wishes outcomes
    ('88888888-8888-8888-8888-888888888016', 'Talk to Village Children', 'play_with', 
     'Luminary เล่นกับเด็กๆ สนุกสนาน เด็กๆ ต่างชื่นชอบเขามาก', 
     '{"experience": 8, "relationship": {"Village Children": 5}}', NULL, '{}', '{}'),

    ('88888888-8888-8888-8888-888888888017', 'Talk to Village Children', 'give_candy', 
     'Luminary มอบลูกอมให้เด็กๆ เด็กๆ ดีใจมากและอวยพรให้เขาโชคดี', 
     '{"experience": 5, "relationship": {"Village Children": 4}}', NULL, '{}', '{}'),

    ('88888888-8888-8888-8888-888888888018', 'Draw Water from Well', 'default', 
     'น้ำจากบ่อน้ำศักดิ์สิทธิ์สะอาดใสและเย็นสบาย Luminary รู้สึกสดชื่น', 
     '{"experience": 3}', NULL, '{}', '{}'),

    -- Getting Supplies outcomes
    ('88888888-8888-8888-8888-888888888019', 'Talk to Dan', 'buy_herbs', 
     'Dan ขายสมุนไพรรักษาให้ Luminary ในราคาพิเศษเนื่องในวันเกิด', 
     '{"items": [{"id": "55555555-5555-5555-5555-555555555005", "quantity": 3}], "gold": -15, "relationship": {"Dan": 3}}', NULL, '{}', '{}'),

    ('88888888-8888-8888-8888-888888888020', 'Talk to Dan', 'buy_food', 
     'Dan ขายอาหารและขนมปังให้ Luminary พร้อมกับคำแนะนำเกี่ยวกับการเดินทาง', 
     '{"items": [{"id": "55555555-5555-5555-5555-555555555006", "quantity": 2}], "gold": -20, "relationship": {"Dan": 3}}', NULL, '{}', '{}'),

    ('88888888-8888-8888-8888-888888888021', 'Talk to Dan', 'just_looking', 
     'Dan ยิ้มและบอกว่ายินดีต้อนรับเสมอ เขาให้ข้อมูลเกี่ยวกับสินค้าต่างๆ', 
     '{"relationship": {"Dan": 2}}', NULL, '{}', '{}'),

    ('88888888-8888-8888-8888-888888888022', 'Browse Shop Items', 'default', 
     'Luminary ดูสินค้าต่างๆ ในร้านและได้ความรู้เกี่ยวกับราคาและคุณสมบัติ', 
     '{"experience": 5}', NULL, '{}', '{}'),

    -- Sword Blessing outcomes
    ('88888888-8888-8888-8888-888888888023', 'Receive Sword Blessing', 'grateful', 
     'Tom ยิ้มและบอกว่าดาบเล่มนี้จะปกป้อง Luminary เสมอ', 
     '{"items": [{"id": "55555555-5555-5555-5555-555555555002", "quantity": 1}], "relationship": {"Tom": 5}}', '66666666-6666-6666-6666-666666666008', '{}', '{}'),

    ('88888888-8888-8888-8888-888888888024', 'Receive Sword Blessing', 'promise', 
     'Tom ชื่นชมคำมั่นสัญญาของ Luminary และให้คำแนะนำเกี่ยวกับการใช้ดาบ', 
     '{"items": [{"id": "55555555-5555-5555-5555-555555555002", "quantity": 1}], "experience": 10, "relationship": {"Tom": 4}}', '66666666-6666-6666-6666-666666666008', '{}', '{}'),

    -- Forest Meditation outcomes
    ('88888888-8888-8888-8888-888888888025', 'Meditate at Ancient Tree', 'default', 
     'การสมาธิทำให้ Luminary สงบและมีสมาธิ เขารู้สึกพลังลึกลับไหลเวียนในร่างกาย', 
     '{"experience": 12, "mp": 10}', NULL, '{}', '{}'),

    ('88888888-8888-8888-8888-888888888026', 'Collect Herbs', 'default', 
     'Luminary เก็บสมุนไพรหายากได้หลายชนิด สมุนไพรเหล่านี้มีพลังรักษาสูง', 
     '{"items": [{"id": "55555555-5555-5555-5555-555555555005", "quantity": 2}, {"id": "55555555-5555-5555-5555-555555555006", "quantity": 1}]}', NULL, '{}', '{}'),

    -- Traveler''s Tale outcomes
    ('88888888-8888-8888-8888-888888888027', 'Listen to Traveler''s Story', 'curious', 
     'นักเดินทางเล่าเรื่องราวเกี่ยวกับโลกภายนอกที่ Luminary ไม่เคยได้ยินมาก่อน', 
     '{"experience": 15, "relationship": {"Mysterious Traveler": 3}}', '66666666-6666-6666-6666-666666666010', '{}', '{}'),

    ('88888888-8888-8888-8888-888888888028', 'Listen to Traveler''s Story', 'skeptical', 
     'นักเดินทางยิ้มและบอกว่าเวลาจะพิสูจน์ทุกอย่าง เขามอบของขวัญเล็กๆ ให้', 
     '{"items": [{"id": "55555555-5555-5555-5555-555555555012", "quantity": 1}], "relationship": {"Mysterious Traveler": 2}}', '66666666-6666-6666-6666-666666666010', '{}', '{}'),

    -- Ancient Wisdom outcomes
    ('88888888-8888-8888-8888-888888888029', 'Seek Elder''s Guidance', 'learn_more', 
     'ผู้เฒ่าเล่าเรื่องราวเกี่ยวกับตำนาน Luminary และความสำคัญของพิธีกรรม', 
     '{"experience": 20, "relationship": {"Elder": 5}}', '66666666-6666-6666-6666-666666666011', '{}', '{}'),

    ('88888888-8888-8888-8888-888888888030', 'Seek Elder''s Guidance', 'ready', 
     'ผู้เฒ่ายิ้มและให้พรให้ Luminary ประสบความสำเร็จในพิธีกรรม', 
     '{"experience": 15, "relationship": {"Elder": 4}}', '66666666-6666-6666-6666-666666666011', '{}', '{}'),

    -- Climax Event outcomes
    ('88888888-8888-8888-8888-888888888031', 'Village Assembly', 'default', 
     'Luminary ขึ้นเวทีและรับการเชิญจากนายกเทศมนตรี ชาวบ้านต่างปรบมือให้', 
     '{"experience": 25, "relationship": {"Villagers": 5}}', '66666666-6666-6666-6666-666666666012', '{}', '{}'),

    ('88888888-8888-8888-8888-888888888032', 'Journey to Sacred Tor', 'default', 
     'การเดินทางไปยัง Sacred Tor เต็มไปด้วยความสำคัญและความศักดิ์สิทธิ์', 
     '{"experience": 30}', '66666666-6666-6666-6666-666666666013', '{}', '{}'),

    ('88888888-8888-8888-8888-888888888033', 'The Truth Revealed', 'shocked', 
     'Luminary ตกใจกับความจริงที่ Chalky เปิดเผย แต่ก็เริ่มเข้าใจบทบาทของตัวเอง', 
     '{"experience": 50, "relationship": {"Chalky": 10}}', '66666666-6666-6666-6666-666666666014', '{}', '{}'),

    ('88888888-8888-8888-8888-888888888034', 'The Truth Revealed', 'accept', 
     'Luminary ยอมรับชะตากรรมและพร้อมเผชิญหน้ากับอนาคตที่รออยู่', 
     '{"experience": 60, "relationship": {"Chalky": 12}}', '66666666-6666-6666-6666-666666666014', '{}', '{}'),

    ('88888888-8888-8888-8888-888888888035', 'Ritual Begins', 'default', 
     'พิธีกรรมเริ่มขึ้นอย่างยิ่งใหญ่ พลังลึกลับเริ่มสั่นคลอนทั่ว Sacred Tor', 
     '{"experience": 40}', '66666666-6666-6666-6666-666666666015', '{}', '{}'),

    ('88888888-8888-8888-8888-888888888036', 'The Awakening', 'default', 
     'Luminary ได้ตื่นขึ้นแล้ว! เครื่องหมายศักดิ์สิทธิ์ปรากฏบนมือ พลังแห่งแสงสว่างไหลเวียนในร่างกาย', 
     '{"items": [{"id": "55555555-5555-5555-5555-555555555009", "quantity": 1}], "experience": 100, "gold": 50, "unlock_events": ["66666666-6666-6666-6666-666666666016"], "unlock_chapters": ["33333333-3333-3333-3333-333333333002"]}', NULL, '{"22222222-2222-2222-2222-222222222011", "22222222-2222-2222-2222-222222222012"}', '{"11111111-1111-1111-1111-111111111002"}')
) AS outcome_info(id, interaction_title, choice_key, outcome_text, effects, next_event_id, auto_unlocked_locations, auto_unlocked_regions)
WHERE ei.title = outcome_info.interaction_title;
