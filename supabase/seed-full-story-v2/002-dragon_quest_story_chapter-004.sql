-- Dragon Quest XI Story Data Seed - Chapter 4: The Gathering Storm
-- This file contains story data for Chapter 4 of the Dragon Quest XI storyline
-- After completing the trials, Luminary must gather allies and prepare for the coming darkness

-- Enable UUID extension if not already enabled
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

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
    ('11111111-1111-1111-1111-111111111004', 'Galenholm Region', 'ดินแดนที่อยู่ทางทิศเหนือของ Heliodor ซึ่งเป็นที่ตั้งของเมือง Galenholm ที่เต็มไปด้วยประวัติศาสตร์โบราณ', '/images/regions/galenholm.svg', '{}', 4, true, false)
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
    -- Galenholm Region Locations
    ('22222222-2222-2222-2222-222222222029', 'Galenholm Region', 'Galenholm City', 'เมืองโบราณที่เต็มไปด้วยประวัติศาสตร์และวัฒนธรรมอันเก่าแก่ เป็นศูนย์กลางการค้าและการเมืองของภูมิภาคนี้', 'town', '{}', 1, true, false),
    ('22222222-2222-2222-2222-222222222030', 'Galenholm Region', 'Ancient Library', 'ห้องสมุดโบราณที่เก็บรักษาความรู้และตำนานเก่าแก่ไว้มากมาย', 'landmark', '{}', 2, true, false),
    ('22222222-2222-2222-2222-222222222031', 'Galenholm Region', 'Forgotten Temple', 'วัดโบราณที่ถูกทิ้งร้างและเต็มไปด้วยปริศนาและอันตราย', 'dungeon', '{}', 3, true, false),
    ('22222222-2222-2222-2222-222222222032', 'Galenholm Region', 'Mystic Cave', 'ถ้ำลึกลับที่มีพลังเวทมนตร์อันศักดิ์สิทธิ์', 'dungeon', '{}', 4, true, false),
    ('22222222-2222-2222-2222-222222222033', 'Galenholm Region', 'Sacred Grove', 'ป่าศักดิ์สิทธิ์ที่เต็มไปด้วยพลังธรรมชาติและสิ่งมีชีวิตวิเศษ', 'landmark', '{}', 5, true, false),
    ('22222222-2222-2222-2222-222222222034', 'Galenholm Region', 'Crystal Lake', 'ทะเลสาบผลึกที่น้ำใสเหมือนกระจกและมีพลังรักษา', 'landmark', '{}', 6, true, false),
    ('22222222-2222-2222-2222-222222222035', 'Galenholm Region', 'Elder Council', 'สภาผู้เฒ่าที่เป็นศูนย์กลางการปกครองของเมือง', 'building', '{}', 7, true, false),
    ('22222222-2222-2222-2222-222222222036', 'Galenholm Region', 'Market Square', 'ตลาดกลางแจ้งที่คึกคักไปด้วยพ่อค้าแม่ค้าและสินค้าหายาก', 'town', '{}', 8, true, false),
    ('22222222-2222-2222-2222-222222222037', 'Galenholm Region', 'Healer Hut', 'กระท่อมของนักรักษาผู้มีพลังศักดิ์สิทธิ์ในการรักษาโรค', 'building', '{}', 9, true, false),
    ('22222222-2222-2222-2222-222222222038', 'Galenholm Region', 'Training Grounds', 'สนามฝึกซ้อมสำหรับนักรบและนักผจญภัย', 'landmark', '{}', 10, true, false)
) AS location_info(id, region_name, name, description, location_type, unlock_requirements, display_order, is_initial_user_progress, is_alway_hide_until_unlock)
WHERE wr.name = location_info.region_name;

-- Insert Story Chapters for Chapter 4
INSERT INTO story_chapters (id, title, description, chapter_number, is_unlocked, unlock_requirements, completion_requirements, created_at, updated_at) VALUES
    ('33333333-3333-3333-3333-333333333004', 'Chapter 4: The Gathering Storm', 
     'หลังจากผ่านการทดสอบทั้งหมด Luminary ต้องรวบรวมพันธมิตรและเตรียมพร้อมสำหรับความมืดที่กำลังจะมาถึง', 
     4, false, 
     '{"completed_chapters": ["33333333-3333-3333-3333-333333333003"], "completed_events": ["66666666-6666-6666-6666-666666666031", "66666666-6666-6666-6666-666666666032", "66666666-6666-6666-6666-666666666033"]}', 
     '{"completed_events": ["66666666-6666-6666-6666-666666666041", "66666666-6666-6666-6666-666666666042", "66666666-6666-6666-6666-666666666043"]}', 
     NOW(), NOW())
ON CONFLICT (id) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    chapter_number = EXCLUDED.chapter_number,
    is_unlocked = EXCLUDED.is_unlocked,
    unlock_requirements = EXCLUDED.unlock_requirements,
    completion_requirements = EXCLUDED.completion_requirements,
    updated_at = NOW();

-- Insert Story Events for Chapter 4
INSERT INTO story_events (id, chapter_id, title, description, event_type, is_unlocked, unlock_requirements, completion_requirements, location_id, created_at, updated_at) VALUES
    -- Event 1: The Vision of Darkness
    ('66666666-6666-6666-6666-666666666034', '33333333-3333-3333-3333-333333333004', 
     'นิมิตแห่งความมืด', 'Luminary มองเห็นนิมิตเกี่ยวกับความมืดที่กำลังคืบคลานเข้ามาในโลก', 
     'story_revelation', false, 
     '{"completed_events": ["66666666-6666-6666-6666-666666666033"]}', 
     '{"completed_interactions": ["88888888-8888-8888-8888-888888888201"]}', 
     '22222222-2222-2222-2222-222222222029', NOW(), NOW()),
    
    -- Event 2: Rab's Warning
    ('66666666-6666-6666-6666-666666666035', '33333333-3333-3333-3333-333333333004', 
     'คำเตือนจาก Rab', 'ฤาษี Rab เตือนว่าเวลาใกล้หมดแล้ว Luminary ต้องรวบรวมพันธมิตร', 
     'character_interaction', false, 
     '{"completed_events": ["66666666-6666-6666-6666-666666666034"]}', 
     '{"completed_interactions": ["88888888-8888-8888-8888-888888888205"]}', 
     '22222222-2222-2222-2222-222222222030', NOW(), NOW()),
    
    -- Event 3: The First Ally
    ('66666666-6666-6666-6666-666666666036', '33333333-3333-3333-3333-333333333004', 
     'พันธมิตรคนแรก', 'Luminary ได้พบกับพันธมิตรคนแรกที่จะช่วยในการต่อสู้', 
     'character_introduction', false, 
     '{"completed_events": ["66666666-6666-6666-6666-666666666035"]}', 
     '{"completed_interactions": ["88888888-8888-8888-8888-888888888209"]}', 
     '22222222-2222-2222-2222-222222222031', NOW(), NOW()),
    
    -- Event 4: The Ancient Forest
    ('66666666-6666-6666-6666-666666666037', '33333333-3333-3333-3333-333333333004', 
     'ป่าโบราณ', 'การเดินทางผ่านป่าโบราณเพื่อค้นหาพันธมิตรคนต่อไป', 
     'exploration', false, 
     '{"completed_events": ["66666666-6666-6666-6666-666666666036"]}', 
     '{"completed_interactions": ["88888888-8888-8888-8888-888888888213"]}', 
     '22222222-2222-2222-2222-222222222032', NOW(), NOW()),
    
    -- Event 5: The Second Ally
    ('66666666-6666-6666-6666-666666666038', '33333333-3333-3333-3333-333333333004', 
     'พันธมิตรคนที่สอง', 'ในป่าโบราณ Luminary ได้พบกับพันธมิตรคนที่สอง', 
     'character_introduction', false, 
     '{"completed_events": ["66666666-6666-6666-6666-666666666037"]}', 
     '{"completed_interactions": ["88888888-8888-8888-8888-888888888217"]}', 
     '22222222-2222-2222-2222-222222222033', NOW(), NOW()),
    
    -- Event 6: The Mountain Pass
    ('66666666-6666-6666-6666-666666666039', '33333333-3333-3333-3333-333333333004', 
     'เส้นทางภูเขา', 'การเดินทางผ่านเส้นทางภูเขาที่อันตรายเพื่อไปยังดินแดนต่อไป', 
     'exploration', false, 
     '{"completed_events": ["66666666-6666-6666-6666-666666666038"]}', 
     '{"completed_interactions": ["88888888-8888-8888-8888-888888888221"]}', 
     '22222222-2222-2222-2222-222222222034', NOW(), NOW()),
    
    -- Event 7: The Third Ally
    ('66666666-6666-6666-6666-666666666040', '33333333-3333-3333-3333-333333333004', 
     'พันธมิตรคนที่สาม', 'บนภูเขา Luminary ได้พบกับพันธมิตรคนที่สาม', 
     'character_introduction', false, 
     '{"completed_events": ["66666666-6666-6666-6666-666666666039"]}', 
     '{"completed_interactions": ["88888888-8888-8888-8888-888888888225"]}', 
     '22222222-2222-2222-2222-222222222035', NOW(), NOW()),
    
    -- Event 8: The Gathering
    ('66666666-6666-6666-6666-666666666041', '33333333-3333-3333-3333-333333333004', 
     'การรวมตัว', 'พันธมิตรทั้งหมดมารวมตัวกันเพื่อเตรียมพร้อมสำหรับการต่อสู้', 
     'story_progression', false, 
     '{"completed_events": ["66666666-6666-6666-6666-666666666040"]}', 
     '{"completed_interactions": ["88888888-8888-8888-8888-888888888229"]}', 
     '22222222-2222-2222-2222-222222222036', NOW(), NOW()),
    
    -- Event 9: The First Battle Together
    ('66666666-6666-6666-6666-666666666042', '33333333-3333-3333-3333-333333333004', 
     'การต่อสู้ครั้งแรกด้วยกัน', 'พันธมิตรทั้งหมดต่อสู้ด้วยกันเป็นครั้งแรก', 
     'battle', false, 
     '{"completed_events": ["66666666-6666-6666-6666-666666666041"]}', 
     '{"completed_interactions": ["88888888-8888-8888-8888-888888888233"]}', 
     '22222222-2222-2222-2222-222222222037', NOW(), NOW()),
    
    -- Event 10: The Storm Approaches
    ('66666666-6666-6666-6666-666666666043', '33333333-3333-3333-3333-333333333004', 
     'พายุใกล้เข้ามาแล้ว', 'สัญญาณของความมืดเริ่มปรากฏ พายุใกล้เข้ามาแล้ว', 
     'story_revelation', false, 
     '{"completed_events": ["66666666-6666-6666-6666-666666666042"]}', 
     '{"completed_interactions": ["88888888-8888-8888-8888-888888888237"]}', 
     '22222222-2222-2222-2222-222222222038', NOW(), NOW())
ON CONFLICT (id) DO UPDATE SET
    chapter_id = EXCLUDED.chapter_id,
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    event_type = EXCLUDED.event_type,
    is_unlocked = EXCLUDED.is_unlocked,
    unlock_requirements = EXCLUDED.unlock_requirements,
    completion_requirements = EXCLUDED.completion_requirements,
    location_id = EXCLUDED.location_id,
    updated_at = NOW();

-- Insert Event Interactions for Chapter 4
INSERT INTO event_interactions (id, event_id, title, description, interaction_type, is_required, requirements, created_at, updated_at) VALUES
    -- Event 1: The Vision of Darkness interactions
    ('88888888-8888-8888-8888-888888888201', '66666666-6666-6666-6666-666666666034', 
     'มองเห็นนิมิต', 'Luminary มองเห็นนิมิตเกี่ยวกับความมืดที่กำลังคืบคลาน', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888202', '66666666-6666-6666-6666-666666666034', 
     'เข้าใจนิมิต', 'พยายามเข้าใจความหมายของนิมิตที่เห็น', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888203', '66666666-6666-6666-6666-666666666034', 
     'ตื่นตระหนก', 'รู้สึกตื่นตระหนกกับสิ่งที่เห็นในนิมิต', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888204', '66666666-6666-6666-6666-666666666034', 
     'ตัดสินใจต่อสู้', 'ตัดสินใจว่าจะต่อสู้กับความมืดต่อไป', 
     'choice', true, '{}', NOW(), NOW()),
    
    -- Event 2: Rab's Warning interactions
    ('88888888-8888-8888-8888-888888888205', '66666666-6666-6666-6666-666666666035', 
     'Rab มาหา', 'ฤาษี Rab มาหา Luminary หลังจากเห็นนิมิต', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888206', '66666666-6666-6666-6666-666666666035', 
     'เตือนภัย', 'Rab เตือนว่าเวลาใกล้หมดแล้ว', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888207', '66666666-6666-6666-6666-666666666035', 
     'บอกทาง', 'Rab บอกทางในการรวบรวมพันธมิตร', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888208', '66666666-6666-6666-6666-666666666035', 
     'ให้กำลังใจ', 'Rab ให้กำลังใจ Luminary ก่อนออกเดินทาง', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    -- Event 3: The First Ally interactions
    ('88888888-8888-8888-8888-888888888209', '66666666-6666-6666-6666-666666666036', 
     'พบกับ Erik', 'Luminary ได้พบกับ Erik นักโจรผู้มีอดีตลึกลับ', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888210', '66666666-6666-6666-6666-666666666036', 
     'ทำความรู้จัก', 'ทำความรู้จักกับ Erik และเรื่องราวของเขา', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888211', '66666666-6666-6666-6666-666666666036', 
     'เชื่อมโยงชะตากรรม', 'พบว่า Erik มีความเชื่อมโยงกับชะตากรรมของ Luminary', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888212', '66666666-6666-6666-6666-666666666036', 
     'ตัดสินใจร่วมทาง', 'Erik ตัดสินใจร่วมเดินทางกับ Luminary', 
     'choice', true, '{}', NOW(), NOW()),
    
    -- Event 4: The Ancient Forest interactions
    ('88888888-8888-8888-8888-888888888213', '66666666-6666-6666-6666-666666666037', 
     'เข้าสู่ป่าโบราณ', 'Luminary และ Erik เข้าสู่ป่าโบราณ', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888214', '66666666-6666-6666-6666-666666666037', 
     'สำรวจป่า', 'สำรวจป่าโบราณที่เต็มไปด้วยสัตว์ประหลาด', 
     'exploration', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888215', '66666666-6666-6666-6666-666666666037', 
     'พบกับสัตว์ประหลาด', 'พบกับสัตว์ประหลาดในป่า', 
     'battle', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888216', '66666666-6666-6666-6666-666666666037', 
     'ค้นพบทาง', 'ค้นพบทางไปยังจุดหมายในป่า', 
     'discovery', true, '{}', NOW(), NOW()),
    
    -- Event 5: The Second Ally interactions
    ('88888888-8888-8888-8888-888888888217', '66666666-6666-6666-6666-666666666038', 
     'พบกับ Veronica', 'ในป่าโบราณพบกับ Veronica แม่มดผู้ทรงพลัง', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888218', '66666666-6666-6666-6666-666666666038', 
     'ทดสอบพลัง', 'Veronica ทดสอบพลังของ Luminary', 
     'challenge', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888219', '66666666-6666-6666-6666-666666666038', 
     'เปิดเผยเรื่องราว', 'Veronica เปิดเผยเรื่องราวของตัวเอง', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888220', '66666666-6666-6666-6666-666666666038', 
     'ตัดสินใจร่วมทาง', 'Veronica ตัดสินใจร่วมเดินทางกับ Luminary', 
     'choice', true, '{}', NOW(), NOW()),
    
    -- Event 6: The Mountain Pass interactions
    ('88888888-8888-8888-8888-888888888221', '66666666-6666-6666-6666-666666666039', 
     'เริ่มปีนภูเขา', 'Luminary, Erik และ Veronica เริ่มปีนภูเขา', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888222', '66666666-6666-6666-6666-666666666039', 
     'เผชิญหน้าอันตราย', 'เผชิญหน้ากับอันตรายบนภูเขา', 
     'challenge', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888223', '66666666-6666-6666-6666-666666666039', 
     'ช่วยเหลือกัน', 'ทุกคนต้องช่วยเหลือกันเพื่อผ่านภูเขา', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888224', '66666666-6666-6666-6666-666666666039', 
     'ถึงยอดภูเขา', 'ถึงยอดภูเขาและพบกับสิ่งที่รออยู่', 
     'discovery', true, '{}', NOW(), NOW()),
    
    -- Event 7: The Third Ally interactions
    ('88888888-8888-8888-8888-888888888225', '66666666-6666-6666-6666-666666666040', 
     'พบกับ Serena', 'บนภูเขาพบกับ Serena นักบวชผู้รักษา', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888226', '66666666-6666-6666-6666-666666666040', 
     'รักษาบาดเจ็บ', 'Serena ช่วยรักษาบาดเจ็บของทุกคน', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888227', '66666666-6666-6666-6666-666666666040', 
     'เปิดเผยภารกิจ', 'Serena เปิดเผยภารกิจของตัวเอง', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888228', '66666666-6666-6666-6666-666666666040', 
     'ตัดสินใจร่วมทาง', 'Serena ตัดสินใจร่วมเดินทางกับ Luminary', 
     'choice', true, '{}', NOW(), NOW()),
    
    -- Event 8: The Gathering interactions
    ('88888888-8888-8888-8888-888888888229', '66666666-6666-6666-6666-666666666041', 
     'รวมตัวกัน', 'พันธมิตรทั้งหมดมารวมตัวกัน', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888230', '66666666-6666-6666-6666-666666666041', 
     'แนะนำตัวเอง', 'ทุกคนแนะนำตัวเองและความสามารถ', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888231', '66666666-6666-6666-6666-666666666041', 
     'วางแผนการต่อสู้', 'วางแผนการต่อสู้กับความมืด', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888232', '66666666-6666-6666-6666-666666666041', 
     'สาบาน', 'ทุกคนสาบานว่าจะต่อสู้ด้วยกัน', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    -- Event 9: The First Battle Together interactions
    ('88888888-8888-8888-8888-888888888233', '66666666-6666-6666-6666-666666666042', 
     'เผชิญหน้าศัตรู', 'พบกับศัตรูกลุ่มแรกที่ส่งมาจากความมืด', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888234', '66666666-6666-6666-6666-666666666042', 
     'ต่อสู้ด้วยกัน', 'ต่อสู้กับศัตรูด้วยกันเป็นครั้งแรก', 
     'battle', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888235', '66666666-6666-6666-6666-666666666042', 
     'ใช้ความสามารถร่วมกัน', 'ใช้ความสามารถของแต่ละคนร่วมกัน', 
     'battle', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888236', '66666666-6666-6666-6666-666666666042', 
     'ชนะการต่อสู้', 'ชนะการต่อสู้ครั้งแรกด้วยกัน', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    -- Event 10: The Storm Approaches interactions
    ('88888888-8888-8888-8888-888888888237', '66666666-6666-6666-6666-666666666043', 
     'เห็นสัญญาณ', 'เห็นสัญญาณของความมืดที่กำลังใกล้เข้ามา', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888238', '66666666-6666-6666-6666-666666666043', 
     'รู้สึกถึงอันตราย', 'รู้สึกถึงอันตรายที่ใกล้เข้ามา', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888239', '66666666-6666-6666-6666-666666666043', 
     'เตรียมพร้อม', 'ทุกคนเตรียมพร้อมสำหรับการต่อสู้ครั้งใหญ่', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888240', '66666666-6666-6666-6666-666666666043', 
     'มองไปข้างหน้า', 'มองไปข้างหน้าพร้อมกับเผชิญหน้ากับอนาคต', 
     'dialogue', true, '{}', NOW(), NOW())
ON CONFLICT (id) DO UPDATE SET
    event_id = EXCLUDED.event_id,
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    interaction_type = EXCLUDED.interaction_type,
    is_required = EXCLUDED.is_required,
    requirements = EXCLUDED.requirements,
    updated_at = NOW();

-- Insert Event Outcomes for Chapter 4
INSERT INTO event_outcomes (id, interaction_id, choice_key, outcome_text, effects, next_event_id, auto_unlocked_locations, auto_unlocked_regions) VALUES
    -- Event 1: The Vision of Darkness outcomes
    ('88888888-8888-8888-8888-888888888241', '88888888-8888-8888-8888-888888888201', 'default', 
     'Luminary มองเห็นนิมิตเกี่ยวกับความมืดที่กำลังคืบคลานเข้ามาในโลก', 
     '{"experience": 60, "relationship": {"Self": 5}}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888242', '88888888-8888-8888-8888-888888888202', 'default', 
     'พยายามเข้าใจความหมายของนิมิตที่เห็น แต่ยังไม่ชัดเจน', 
     '{"experience": 50, "relationship": {"Self": 3}}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888243', '88888888-8888-8888-8888-888888888203', 'default', 
     'รู้สึกตื่นตระหนกกับสิ่งที่เห็นในนิมิต แต่ก็พยายามควบคุมสติ', 
     '{"experience": 55, "relationship": {"Self": 4}}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888244', '88888888-8888-8888-8888-888888888204', 'fight_darkness', 
     'Luminary ตัดสินใจว่าจะต่อสู้กับความมืดต่อไปไม่ย่อท้อ', 
     '{"experience": 80, "relationship": {"Self": 8}}', '66666666-6666-6666-6666-666666666035', '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888245', '88888888-8888-8888-8888-888888888204', 'hesitate', 
     'Luminary ลังเลใจ แต่ก็ตัดสินใจว่าจะต่อสู้ต่อไป', 
     '{"experience": 60, "relationship": {"Self": 5}}', '66666666-6666-6666-6666-666666666035', '{}', '{}'),
    
    -- Event 2: Rab's Warning outcomes
    ('88888888-8888-8888-8888-888888888246', '88888888-8888-8888-8888-888888888205', 'default', 
     'ฤาษี Rab มาหา Luminary หลังจากเห็นนิมิตและกังวลใจ', 
     '{"experience": 50}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888247', '88888888-8888-8888-8888-888888888206', 'default', 
     'Rab เตือนว่าเวลาใกล้หมดแล้ว ความมืดกำลังใกล้เข้ามา', 
     '{"experience": 70, "relationship": {"Rab": 5}}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888248', '88888888-8888-8888-8888-888888888207', 'default', 
     'Rab บอกทางในการรวบรวมพันธมิตรเพื่อต่อสู้กับความมืด', 
     '{"experience": 80, "relationship": {"Rab": 8}}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888249', '88888888-8888-8888-8888-888888888208', 'default', 
     'Rab ให้กำลังใจ Luminary ก่อนออกเดินทางเพื่อรวบรวมพันธมิตร', 
     '{"experience": 90, "relationship": {"Rab": 10}, "items": [{"id": "55555555-5555-5555-5555-555555555016", "quantity": 1}]}', '66666666-6666-6666-6666-666666666036', '{}', '{}'),
    
    -- Event 3: The First Ally outcomes
    ('88888888-8888-8888-8888-888888888250', '88888888-8888-8888-8888-888888888209', 'default', 
     'Luminary ได้พบกับ Erik นักโจรผู้มีอดีตลึกลับ', 
     '{"experience": 60}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888251', '88888888-8888-8888-8888-888888888210', 'default', 
     'ทำความรู้จักกับ Erik และเรื่องราวของเขาที่ถูกทรยศ', 
     '{"experience": 80, "relationship": {"Erik": 5}}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888252', '88888888-8888-8888-8888-888888888211', 'default', 
     'พบว่า Erik มีความเชื่อมโยงกับชะตากรรมของ Luminary ในอดีต', 
     '{"experience": 100, "relationship": {"Erik": 8}}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888253', '88888888-8888-8888-8888-888888888212', 'accept_ally', 
     'Erik ตัดสินใจร่วมเดินทางกับ Luminary เพื่อแก้แค้นและช่วยโลก', 
     '{"experience": 120, "relationship": {"Erik": 10}, "unlock_events": ["66666666-6666-6666-6666-666666666037"]}', '66666666-6666-6666-6666-666666666037', '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888254', '88888888-8888-8888-8888-888888888212', 'hesitate_ally', 
     'Erik ลังเลใจ แต่ก็ตัดสินใจร่วมเดินทางในที่สุด', 
     '{"experience": 90, "relationship": {"Erik": 7}, "unlock_events": ["66666666-6666-6666-6666-666666666037"]}', '66666666-6666-6666-6666-666666666037', '{}', '{}'),
    
    -- Event 4: The Ancient Forest outcomes
    ('88888888-8888-8888-8888-888888888255', '88888888-8888-8888-8888-888888888213', 'default', 
     'Luminary และ Erik เข้าสู่ป่าโบราณที่เต็มไปด้วยความลับ', 
     '{"experience": 70}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888256', '88888888-8888-8888-8888-888888888214', 'default', 
     'การสำรวจป่าโบราณทำให้พบสัตว์ประหลาดและความลับ', 
     '{"experience": 90, "gold": 30}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888257', '88888888-8888-8888-8888-888888888215', 'defeat_monster', 
     'Luminary และ Erik เอาชนะสัตว์ประหลาดในป่าได้สำเร็จ', 
     '{"experience": 110, "gold": 50}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888258', '88888888-8888-8888-8888-888888888216', 'default', 
     'ค้นพบทางไปยังจุดหมายในป่าและพบกับ Veronica', 
     '{"experience": 100, "relationship": {"Self": 5}}', '66666666-6666-6666-6666-666666666038', '{}', '{}'),
    
    -- Event 5: The Second Ally outcomes
    ('88888888-8888-8888-8888-888888888259', '88888888-8888-8888-8888-888888888217', 'default', 
     'ในป่าโบราณพบกับ Veronica แม่มดผู้ทรงพลัง', 
     '{"experience": 80}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888260', '88888888-8888-8888-8888-888888888218', 'pass_test', 
     'Luminary ผ่านการทดสอบพลังของ Veronica ได้สำเร็จ', 
     '{"experience": 120, "relationship": {"Veronica": 5}}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888261', '88888888-8888-8888-8888-888888888219', 'default', 
     'Veronica เปิดเผยเรื่องราวของตัวเองและเหตุผลที่ต้องต่อสู้', 
     '{"experience": 100, "relationship": {"Veronica": 8}}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888262', '88888888-8888-8888-8888-888888888220', 'accept_ally', 
     'Veronica ตัดสินใจร่วมเดินทางกับ Luminary เพื่อหยุดยั้งความมืด', 
     '{"experience": 140, "relationship": {"Veronica": 10}, "unlock_events": ["66666666-6666-6666-6666-666666666039"]}', '66666666-6666-6666-6666-666666666039', '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888263', '88888888-8888-8888-8888-888888888220', 'hesitate_ally', 
     'Veronica ลังเลใจ แต่ก็ตัดสินใจร่วมเดินทางในที่สุด', 
     '{"experience": 110, "relationship": {"Veronica": 7}, "unlock_events": ["66666666-6666-6666-6666-666666666039"]}', '66666666-6666-6666-6666-666666666039', '{}', '{}'),
    
    -- Event 6: The Mountain Pass outcomes
    ('88888888-8888-8888-8888-888888888264', '88888888-8888-8888-8888-888888888221', 'default', 
     'Luminary, Erik และ Veronica เริ่มปีนภูเขาที่อันตราย', 
     '{"experience": 90}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888265', '88888888-8888-8888-8888-888888888222', 'overcome_danger', 
     'ทุกคนเอาชนะอันตรายบนภูเขาได้สำเร็จ', 
     '{"experience": 130, "gold": 60}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888266', '88888888-8888-8888-8888-888888888223', 'help_each_other', 
     'ทุกคนต้องช่วยเหลือกันเพื่อผ่านภูเขา สร้างความสัมพันธ์ที่ดีขึ้น', 
     '{"experience": 110, "relationship": {"Erik": 3, "Veronica": 3}}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888267', '88888888-8888-8888-8888-888888888224', 'default', 
     'ถึงยอดภูเขาและพบกับ Serena ที่รออยู่', 
     '{"experience": 120, "relationship": {"Self": 5}}', '66666666-6666-6666-6666-666666666040', '{}', '{}'),
    
    -- Event 7: The Third Ally outcomes
    ('88888888-8888-8888-8888-888888888268', '88888888-8888-8888-8888-888888888225', 'default', 
     'บนภูเขาพบกับ Serena นักบวชผู้รักษาที่มีพลังศักดิ์สิทธิ์', 
     '{"experience": 100}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888269', '88888888-8888-8888-8888-888888888226', 'default', 
     'Serena ช่วยรักษาบาดเจ็บของทุกคนด้วยพลังศักดิ์สิทธิ์', 
     '{"experience": 120, "relationship": {"Serena": 8}}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888270', '88888888-8888-8888-8888-888888888227', 'default', 
     'Serena เปิดเผยภารกิจของตัวเองในการปกป้องผู้คน', 
     '{"experience": 110, "relationship": {"Serena": 6}}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888271', '88888888-8888-8888-8888-888888888228', 'accept_ally', 
     'Serena ตัดสินใจร่วมเดินทางกับ Luminary เพื่อช่วยเหลือผู้คน', 
     '{"experience": 150, "relationship": {"Serena": 10}, "unlock_events": ["66666666-6666-6666-6666-666666666041"]}', '66666666-6666-6666-6666-666666666041', '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888272', '88888888-8888-8888-8888-888888888228', 'hesitate_ally', 
     'Serena ลังเลใจ แต่ก็ตัดสินใจร่วมเดินทางในที่สุด', 
     '{"experience": 120, "relationship": {"Serena": 7}, "unlock_events": ["66666666-6666-6666-6666-666666666041"]}', '66666666-6666-6666-6666-666666666041', '{}', '{}'),
    
    -- Event 8: The Gathering outcomes
    ('88888888-8888-8888-8888-888888888273', '88888888-8888-8888-8888-888888888229', 'default', 
     'พันธมิตรทั้งหมดมารวมตัวกันเพื่อเตรียมพร้อมสำหรับการต่อสู้', 
     '{"experience": 100}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888274', '88888888-8888-8888-8888-888888888230', 'default', 
     'ทุกคนแนะนำตัวเองและความสามารถที่แตกต่างกัน', 
     '{"experience": 120, "relationship": {"Erik": 2, "Veronica": 2, "Serena": 2}}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888275', '88888888-8888-8888-8888-888888888231', 'default', 
     'วางแผนการต่อสู้กับความมืดอย่างมีระบบ', 
     '{"experience": 140, "relationship": {"Self": 8}}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888276', '88888888-8888-8888-8888-888888888232', 'default', 
     'ทุกคนสาบานว่าจะต่อสู้ด้วยกันจนกว่าจะชนะ', 
     '{"experience": 160, "relationship": {"Erik": 5, "Veronica": 5, "Serena": 5}, "unlock_events": ["66666666-6666-6666-6666-666666666042"]}', '66666666-6666-6666-6666-666666666042', '{}', '{}'),
    
    -- Event 9: The First Battle Together outcomes
    ('88888888-8888-8888-8888-888888888277', '88888888-8888-8888-8888-888888888233', 'default', 
     'พบกับศัตรูกลุ่มแรกที่ส่งมาจากความมืด', 
     '{"experience": 80}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888278', '88888888-8888-8888-8888-888888888234', 'win_battle', 
     'ต่อสู้กับศัตรูด้วยกันเป็นครั้งแรกและชนะ', 
     '{"experience": 150, "gold": 80}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888279', '88888888-8888-8888-8888-888888888235', 'use_abilities', 
     'ใช้ความสามารถของแต่ละคนร่วมกันอย่างมีประสิทธิภาพ', 
     '{"experience": 170, "relationship": {"Erik": 3, "Veronica": 3, "Serena": 3}}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888280', '88888888-8888-8888-8888-888888888236', 'default', 
     'ชนะการต่อสู้ครั้งแรกด้วยกัน สร้างความมั่นใจในทีม', 
     '{"experience": 200, "relationship": {"Erik": 5, "Veronica": 5, "Serena": 5, "Self": 10}, "unlock_events": ["66666666-6666-6666-6666-666666666043"]}', '66666666-6666-6666-6666-666666666043', '{}', '{}'),
    
    -- Event 10: The Storm Approaches outcomes
    ('88888888-8888-8888-8888-888888888281', '88888888-8888-8888-8888-888888888237', 'default', 
     'เห็นสัญญาณของความมืดที่กำลังใกล้เข้ามา', 
     '{"experience": 90}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888282', '88888888-8888-8888-8888-888888888238', 'default', 
     'รู้สึกถึงอันตรายที่ใกล้เข้ามาและเตรียมพร้อม', 
     '{"experience": 110, "relationship": {"Self": 5}}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888283', '88888888-8888-8888-8888-888888888239', 'default', 
     'ทุกคนเตรียมพร้อมสำหรับการต่อสู้ครั้งใหญ่ที่จะเกิดขึ้น', 
     '{"experience": 130, "relationship": {"Erik": 3, "Veronica": 3, "Serena": 3}}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888284', '88888888-8888-8888-8888-888888888240', 'default', 
     'มองไปข้างหน้าพร้อมกับเผชิญหน้ากับอนาคตที่ไม่แน่นอน', 
     '{"experience": 150, "gold": 100, "relationship": {"Erik": 5, "Veronica": 5, "Serena": 5, "Self": 10}, "unlock_events": ["66666666-6666-6666-666666666044"], "unlock_chapters": ["33333333-3333-3333-3333-333333333005"]}', NULL, '{"22222222-2222-2222-2222-222222222039", "22222222-2222-2222-2222-222222222040"}', '{"11111111-1111-1111-1111-111111111005"}')
ON CONFLICT (id) DO UPDATE SET
    interaction_id = EXCLUDED.interaction_id,
    choice_key = EXCLUDED.choice_key,
    outcome_text = EXCLUDED.outcome_text,
    effects = EXCLUDED.effects,
    next_event_id = EXCLUDED.next_event_id,
    auto_unlocked_locations = EXCLUDED.auto_unlocked_locations,
    auto_unlocked_regions = EXCLUDED.auto_unlocked_regions,
    updated_at = NOW();

-- Update the sequence for the next chapter
SELECT setval('story_chapters_id_seq', (SELECT COALESCE(MAX(id::bigint), 1) FROM story_chapters));
SELECT setval('story_events_id_seq', (SELECT COALESCE(MAX(id::bigint), 1) FROM story_events));
SELECT setval('event_interactions_id_seq', (SELECT COALESCE(MAX(id::bigint), 1) FROM event_interactions));
SELECT setval('event_outcomes_id_seq', (SELECT COALESCE(MAX(id::bigint), 1) FROM event_outcomes));

-- Display completion message
SELECT 'Chapter 4: The Gathering Storm - Story data seeded successfully!' as message;
