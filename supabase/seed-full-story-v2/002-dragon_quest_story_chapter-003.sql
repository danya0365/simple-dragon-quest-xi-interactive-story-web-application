-- Dragon Quest XI Story Data Seed - Chapter 3: The City of Trials
-- This file contains story data for Chapter 3 of the Dragon Quest XI storyline
-- Following the journey begins, Luminary arrives at the legendary city of trials

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
    ('11111111-1111-1111-1111-111111111004', 'Galenholm', 'เมืองตำนานแห่งการทดสอบที่เต็มไปด้วยประวัติศาสตร์และความลับ', '/images/regions/galenholm_city.svg', '{"completed_events": ["66666666-6666-6666-6666-666666666034"]}', 4, false, true)
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
    -- Galenholm City Locations
    ('22222222-2222-2222-2222-222222222019', 'Galenholm', 'Galenholm Entrance', 'ประตูทางเข้าเมือง Galenholm ที่มีผู้พิทักษ์ยืนเฝ้าอยู่เสมอ', 'gate', '{"completed_events": ["66666666-6666-6666-6666-666666666025"]}', 1, false, true),
    ('22222222-2222-2222-2222-222222222020', 'Galenholm', 'Guardians Chamber', 'ห้องของผู้พิทักษ์เมืองที่ทดสอบผู้มาเยือนก่อนเข้าเมือง', 'chamber', '{"completed_events": ["66666666-6666-6666-6666-666666666026"]}', 2, false, true),
    ('22222222-2222-2222-2222-222222222021', 'Galenholm', 'Sages Tower', 'หอคอยของฤาษีผู้มีปัญญาที่รู้เรื่องราวเกี่ยวกับ Luminary', 'tower', '{"completed_events": ["66666666-6666-6666-6666-666666666027"]}', 3, false, true),
    ('22222222-2222-2222-2222-222222222022', 'Galenholm', 'Ancient Library', 'ห้องสมุดโบราณที่เก็บรักษาความรู้และความลับของโลก', 'library', '{"completed_events": ["66666666-6666-6666-6666-666666666028"]}', 4, false, true),
    ('22222222-2222-2222-2222-222222222023', 'Galenholm', 'Prophecy Chamber', 'ห้องคำพยากรณ์ที่เปิดเผยความลับเกี่ยวกับชะตากรรมของ Luminary', 'chamber', '{"completed_events": ["66666666-6666-6666-6666-666666666029"]}', 5, false, true),
    ('22222222-2222-2222-2222-222222222024', 'Galenholm', 'First Trial Arena', 'สนามประลองแห่งการทดสอบแรกที่ทดสอบความกล้าหาญ', 'arena', '{"completed_events": ["66666666-6666-6666-6666-666666666030"]}', 6, false, true),
    ('22222222-2222-2222-2222-222222222025', 'Galenholm', 'Second Trial Arena', 'สนามประลองแห่งการทดสอบที่สองที่ทดสอบปัญญาและความเฉลียวฉลาด', 'arena', '{"completed_events": ["66666666-6666-6666-6666-666666666031"]}', 7, false, true),
    ('22222222-2222-2222-2222-222222222026', 'Galenholm', 'Final Trial Arena', 'สนามประลองแห่งการทดสอบสุดท้ายที่ทดสอบพลังและจิตวิญญาณ', 'arena', '{"completed_events": ["66666666-6666-6666-6666-666666666032"]}', 8, false, true),
    
    -- Additional Galenholm Locations (unlocked after trials)
    ('22222222-2222-2222-2222-222222222027', 'Galenholm', 'Galenholm Square', 'จัตุรัสกลางเมือง Galenholm ที่เต็มไปด้วยชีวิตชาวเมือง', 'town', '{"completed_events": ["66666666-6666-6666-6666-666666666034"]}', 9, false, true),
    ('22222222-2222-2222-2222-222222222028', 'Galenholm', 'Galenholm Inn', 'โรงแรมของเมือง Galenholm ที่เป็นที่พักผ่อนของนักผจญภัย', 'inn', '{"completed_events": ["66666666-6666-6666-6666-666666666034"]}', 10, false, true)
) AS location_info(id, region_name, name, description, location_type, unlock_requirements, display_order, is_initial_user_progress, is_alway_hide_until_unlock)
WHERE wr.name = location_info.region_name;

-- Insert Story Chapters for Chapter 3
INSERT INTO story_chapters (id, title, description, chapter_number, is_unlocked, unlock_requirements, completion_requirements, created_at, updated_at) VALUES
    ('33333333-3333-3333-3333-333333333003', 'Chapter 3: The City of Trials', 
     'Luminary มาถึงเมืองตำนานแห่งการทดสอบ ที่นี่ต้องพิสูจน์ความเป็น Luminary ที่แท้จริงและเผชิญหน้ากับศัตรูครั้งใหญ่', 
     3, false, 
     '{"completed_chapters": ["33333333-3333-3333-3333-333333333002"], "completed_events": ["66666666-6666-6666-6666-666666666024", "66666666-6666-6666-6666-666666666025"]}', 
     '{"completed_events": ["66666666-6666-6666-6666-666666666031", "66666666-6666-6666-6666-666666666032", "66666666-6666-6666-6666-666666666033"]}', 
     NOW(), NOW())
ON CONFLICT (id) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    chapter_number = EXCLUDED.chapter_number,
    is_unlocked = EXCLUDED.is_unlocked,
    unlock_requirements = EXCLUDED.unlock_requirements,
    completion_requirements = EXCLUDED.completion_requirements,
    updated_at = NOW();

-- Insert Story Events for Chapter 3
INSERT INTO story_events (id, chapter_id, title, description, event_type, is_unlocked, unlock_requirements, completion_requirements, location_id, created_at, updated_at) VALUES
    -- Event 1: Arrival at Galenholm
    ('66666666-6666-6666-6666-666666666026', '33333333-3333-3333-3333-333333333003', 
     'มาถึง Galenholm', 'Luminary มาถึงเมือง Galenholm ตำนานแห่งการทดสอบที่เต็มไปด้วยประวัติศาสตร์และความลับ', 
     'location_introduction', false, 
     '{"completed_events": ["66666666-6666-6666-6666-666666666024", "66666666-6666-6666-6666-666666666025"]}', 
     '{"completed_interactions": ["88888888-8888-8888-8888-888888888101"]}', 
     '22222222-2222-2222-2222-222222222019', NOW(), NOW()),
    
    -- Event 2: The Guardian's Test
    ('66666666-6666-6666-6666-666666666027', '33333333-3333-3333-3333-333333333003', 
     'การทดสอบของผู้พิทักษ์', 'ผู้พิทักษ์ของเมืองต้องการทดสอบความสามารถของ Luminary ก่อนจะให้เข้าเมือง', 
     'trial', false, 
     '{"completed_events": ["66666666-6666-6666-6666-666666666026"]}', 
     '{"completed_interactions": ["88888888-8888-8888-8888-888888888105"]}', 
     '22222222-2222-2222-2222-222222222020', NOW(), NOW()),
    
    -- Event 3: Meeting the Sage
    ('66666666-6666-6666-6666-666666666028', '33333333-3333-3333-3333-333333333003', 
     'พบกับฤาษี', 'ในเมือง Galenholm Luminary ได้พบกับฤาษีผู้มีปัญญาที่รู้เรื่องราวเกี่ยวกับ Luminary', 
     'character_introduction', false, 
     '{"completed_events": ["66666666-6666-6666-6666-666666666027"]}', 
     '{"completed_interactions": ["88888888-8888-8888-8888-888888888109"]}', 
     '22222222-2222-2222-2222-222222222021', NOW(), NOW()),
    
    -- Event 4: The Ancient Library
    ('66666666-6666-6666-6666-666666666029', '33333333-3333-3333-3333-333333333003', 
     'ห้องสมุดโบราณ', 'การสำรวจห้องสมุดโบราณเปิดเผยความลับเกี่ยวกับอดีตและอนาคตของ Luminary', 
     'discovery', false, 
     '{"completed_events": ["66666666-6666-6666-6666-666666666028"]}', 
     '{"completed_interactions": ["88888888-8888-8888-8888-888888888113"]}', 
     '22222222-2222-2222-2222-222222222022', NOW(), NOW()),
    
    -- Event 5: The Dark Prophecy
    ('66666666-6666-6666-6666-666666666030', '33333333-3333-3333-3333-333333333003', 
     'คำพยานามมืด', 'ฤาษีเปิดเผยคำพยานามมืดเกี่ยวกับศัตรูที่ยิ่งใหญ่และชะตากรรมของโลก', 
     'story_revelation', false, 
     '{"completed_events": ["66666666-6666-6666-6666-666666666029"]}', 
     '{"completed_interactions": ["88888888-8888-8888-8888-888888888117"]}', 
     '22222222-2222-2222-2222-222222222023', NOW(), NOW()),
    
    -- Event 6: The First Trial
    ('66666666-6666-6666-6666-666666666031', '33333333-3333-3333-3333-333333333003', 
     'การทดสอบครั้งแรก', 'Luminary เริ่มต้นการทดสอบแรกในสามการทดสอบเพื่อพิสูจน์ความเป็น Luminary', 
     'trial', false, 
     '{"completed_events": ["66666666-6666-6666-6666-666666666030"]}', 
     '{"completed_interactions": ["88888888-8888-8888-8888-888888888121"]}', 
     '22222222-2222-2222-2222-222222222024', NOW(), NOW()),
    
    -- Event 7: The Second Trial
    ('66666666-6666-6666-6666-666666666032', '33333333-3333-3333-3333-333333333003', 
     'การทดสอบครั้งที่สอง', 'การทดสอบควัญที่สองทดสอบความกล้าหาญและปัญญาของ Luminary', 
     'trial', false, 
     '{"completed_events": ["66666666-6666-6666-6666-666666666031"]}', 
     '{"completed_interactions": ["88888888-8888-8888-8888-888888888125"]}', 
     '22222222-2222-2222-2222-222222222025', NOW(), NOW()),
    
    -- Event 8: The Final Trial
    ('66666666-6666-6666-6666-666666666033', '33333333-3333-3333-3333-333333333003', 
     'การทดสอบสุดท้าย', 'การทดสอบสุดท้ายที่ยิ่งใหญ่ที่สุด ทดสอบหัวใจและจิตวิญญาณของ Luminary', 
     'trial', false, 
     '{"completed_events": ["66666666-6666-6666-6666-666666666032"]}', 
     '{"completed_interactions": ["88888888-8888-8888-8888-888888888129"]}', 
     '22222222-2222-2222-2222-222222222026', NOW(), NOW())
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

-- Insert Event Interactions for Chapter 3
INSERT INTO event_interactions (id, event_id, title, description, interaction_type, is_required, requirements, created_at, updated_at) VALUES
    -- Event 1: Arrival at Galenholm interactions
    ('88888888-8888-8888-8888-888888888101', '66666666-6666-6666-6666-666666666026', 
     'สำรวจเมือง Galenholm', 'มาถึงเมือง Galenholm และเริ่มสำรวจสถาปัตยกรรมและบรรยากาศของเมือง', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888102', '66666666-6666-6666-6666-666666666026', 
     'พูดคุยกับชาวเมือง', 'พูดคุยกับชาวเมืองเพื่อเก็บข้อมูลเกี่ยวกับเมืองและการทดสอบ', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888103', '66666666-6666-6666-6666-666666666026', 
     'เยี่ยมชมสถานที่สำคัญ', 'เยี่ยมชมสถานที่สำคัญในเมืองเพื่อเรียนรู้ประวัติศาสตร์', 
     'dialogue', false, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888104', '66666666-6666-6666-6666-666666666026', 
     'พบกับผู้พิทักษ์', 'พบกับผู้พิทักษ์ที่ประตูเมืองที่ขัดขวางไม่ให้เข้า', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    -- Event 2: The Guardian's Test interactions
    ('88888888-8888-8888-8888-888888888105', '66666666-6666-6666-6666-666666666027', 
     'การทดสอบความแข็งแกร่ง', 'ผู้พิทักษ์ทดสอบความแข็งแกร่งทางกายภาพของ Luminary', 
     'challenge', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888106', '66666666-6666-6666-6666-666666666027', 
     'การทดสอบพลัง', 'ผู้พิทักษ์ทดสอบพลังของ Luminary ว่าเป็นพลังแห่งแสงจริงๆ', 
     'challenge', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888107', '66666666-6666-6666-6666-666666666027', 
     'การทดสอบจิตใจ', 'ผู้พิทักษ์ทดสอบความมุ่งมั่นและจิตใจของ Luminary', 
     'challenge', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888108', '66666666-6666-6666-6666-666666666027', 
     'ผ่านการทดสอบ', 'Luminary ผ่านการทดสอบทั้งหมดและได้รับอนุญาตให้เข้าเมือง', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    -- Event 3: Meeting the Sage interactions
    ('88888888-8888-8888-8888-888888888109', '66666666-6666-6666-6666-666666666028', 
     'พบกับฤาษี', 'ในเมืองได้พบกับฤาษีผู้มีปัญญาที่รอคอย Luminary มานาน', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888110', '66666666-6666-6666-6666-666666666028', 
     'สอบถามเรื่องราว', 'ถามฤาษีเกี่ยวกับเรื่องราวของ Luminary และภารกิจ', 
     'choice', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888111', '66666666-6666-6666-6666-666666666028', 
     'รับคำแนะนำ', 'ฤาษีให้คำแนะนำเกี่ยวกับการทดสอบที่จะเผชิญหน้า', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888112', '66666666-6666-6666-6666-666666666028', 
     'ตัดสินใจเชื่อฟัง', 'ตัดสินใจว่าจะเชื่อฟังคำแนะนำของฤาษีหรือไม่', 
     'choice', true, '{}', NOW(), NOW()),
    
    -- Event 4: The Ancient Library interactions
    ('88888888-8888-8888-8888-888888888113', '66666666-6666-6666-6666-666666666029', 
     'สำรวจห้องสมุด', 'เริ่มสำรวจห้องสมุดโบราณที่เต็มไปด้วยความรู้', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888114', '66666666-6666-6666-6666-666666666029', 
     'ค้นหาคัมภีร์', 'ค้นหาคัมภีร์โบราณที่บอกเล่าเรื่องราวของ Luminary', 
     'discovery', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888115', '66666666-6666-6666-6666-666666666029', 
     'อ่านคำพยานาม', 'อ่านคำพยานามโบราณที่เกี่ยวข้องกับชะตากรรม', 
     'discovery', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888116', '66666666-6666-6666-6666-666666666029', 
     'ค้นพบความลับ', 'ค้นพบความลับสำคัญเกี่ยวกับศัตรูที่ยิ่งใหญ่', 
     'discovery', true, '{}', NOW(), NOW()),
    
    -- Event 5: The Dark Prophecy interactions
    ('88888888-8888-8888-8888-888888888117', '66666666-6666-6666-6666-666666666030', 
     'ฤาษีเปิดเผยความจริง', 'ฤาษีเปิดเผยความจริงเกี่ยวกับศัตรูที่ยิ่งใหญ่', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888118', '66666666-6666-6666-6666-666666666030', 
     'เรียนรู้เกี่ยวกับศัตรู', 'เรียนรู้รายละเอียดเกี่ยวกับศัตรูที่ยิ่งใหญ่', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888119', '66666666-6666-6666-6666-666666666030', 
     'เข้าใจชะตากรรม', 'เข้าใจชะตากรรมของโลกและบทบาทของ Luminary', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888120', '66666666-6666-6666-6666-666666666030', 
     'ตัดสินใจรับภารกิจ', 'ตัดสินใจรับภารกิจในการต่อสู้กับศัตรู', 
     'choice', true, '{}', NOW(), NOW()),
    
    -- Event 6: The First Trial interactions
    ('88888888-8888-8888-8888-888888888121', '66666666-6666-6666-6666-666666666031', 
     'เริ่มการทดสอบครั้งแรก', 'เริ่มต้นการทดสอบแรกในหอคอยแห่งความกล้าหาญ', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888122', '66666666-6666-6666-6666-666666666031', 
     'เผชิญหน้ากับความกลัว', 'ต้องเผชิญหน้ากับความกลัวที่สุดของตัวเอง', 
     'challenge', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888123', '66666666-6666-6666-6666-666666666031', 
     'ต่อสู้กับเงา', 'ต่อสู้กับเงามืดที่เป็นส่วนหนึ่งของตัวเอง', 
     'battle', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888124', '66666666-6666-6666-6666-666666666031', 
     'ผ่านการทดสอบแรก', 'ผ่านการทดสอบแรกได้สำเร็จและได้รับพลังใหม่', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    -- Event 7: The Second Trial interactions
    ('88888888-8888-8888-8888-888888888125', '66666666-6666-6666-6666-666666666032', 
     'เริ่มการทดสอบครั้งที่สอง', 'เริ่มต้นการทดสอบที่สองในวิหารแห่งปัญญา', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888126', '66666666-6666-6666-6666-666666666032', 
     'ไขปริศนาโบราณ', 'ต้องไขปริศนาโบราณที่ทดสอบปัญญา', 
     'puzzle', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888127', '66666666-6666-6666-6666-666666666032', 
     'ตัดสินใจยาก', 'ต้องตัดสินใจที่ยากที่สุดในชีวิต', 
     'choice', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888128', '66666666-6666-6666-6666-666666666032', 
     'ผ่านการทดสอบที่สอง', 'ผ่านการทดสอบที่สองได้สำเร็จและได้รับความรู้ใหม่', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    -- Event 8: The Final Trial interactions
    ('88888888-8888-8888-8888-888888888129', '66666666-6666-6666-6666-666666666033', 
     'เริ่มการทดสอบสุดท้าย', 'เริ่มต้นการทดสอบสุดท้ายในแท่นบูชาแห่งจิตวิญญาณ', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888130', '66666666-6666-6666-6666-666666666033', 
     'ทดสอบหัวใจ', 'ต้องทดสอบความบริสุทธิ์ของหัวใจ', 
     'challenge', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888131', '66666666-6666-6666-6666-666666666033', 
     'เผชิญหน้ากับอดีต', 'ต้องเผชิญหน้ากับอดีตและยอมรับมัน', 
     'challenge', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888132', '66666666-6666-6666-6666-666666666033', 
     'ผ่านการทดสอบทั้งหมด', 'ผ่านการทดสอบทั้งหมดได้สำเร็จและได้รับการยอมรับ', 
     'dialogue', true, '{}', NOW(), NOW())
ON CONFLICT (id) DO UPDATE SET
    event_id = EXCLUDED.event_id,
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    interaction_type = EXCLUDED.interaction_type,
    is_required = EXCLUDED.is_required,
    requirements = EXCLUDED.requirements,
    updated_at = NOW();

-- Insert Event Outcomes for Chapter 3
INSERT INTO event_outcomes (id, interaction_id, choice_key, outcome_text, effects, next_event_id, auto_unlocked_locations, auto_unlocked_regions) VALUES
    -- Event 1: Arrival at Galenholm outcomes
    ('88888888-8888-8888-8888-888888888133', '88888888-8888-8888-8888-888888888101', 'default', 
     'การสำรวจเมือง Galenholm ทำให้ Luminary ประทับใจกับความงดงามและความลึกลับของเมือง', 
     '{"experience": 50, "relationship": {"Self": 5}}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888134', '88888888-8888-8888-8888-888888888102', 'default', 
     'การพูดคุยกับชาวเมืองทำให้ได้ข้อมูลเกี่ยวกับการทดสอบและประวัติศาสตร์ของเมือง', 
     '{"experience": 40, "relationship": {"Galenholm_Citizens": 5}}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888135', '88888888-8888-8888-8888-888888888103', 'default', 
     'การเยี่ยมชมสถานที่สำคัญทำให้เข้าใจประวัติศาสตร์และวัฒนธรรมของเมืองมากขึ้น', 
     '{"experience": 35, "relationship": {"Self": 3}}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888136', '88888888-8888-8888-8888-888888888104', 'default', 
     'ผู้พิทักษ์ขัดขวางไม่ให้เข้าเมืองและบอกว่าต้องผ่านการทดสอบก่อน', 
     '{"experience": 30}', '66666666-6666-6666-6666-666666666027', '{}', '{}'),
    
    -- Event 2: The Guardian's Test outcomes
    ('88888888-8888-8888-8888-888888888137', '88888888-8888-8888-8888-888888888105', 'pass', 
     'Luminary ผ่านการทดสอบความแข็งแกร่งได้สำเร็จ แสดงให้เห็นถึงพลังกายภาพ', 
     '{"experience": 60, "relationship": {"Self": 5}}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888138', '88888888-8888-8888-8888-888888888106', 'pass', 
     'Luminary ผ่านการทดสอบพลังได้สำเร็จ พลังแห่งแสงสว่างส่องประกาย', 
     '{"experience": 70, "relationship": {"Self": 7}}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888139', '88888888-8888-8888-8888-888888888107', 'pass', 
     'Luminary ผ่านการทดสอบจิตใจได้สำเร็จ แสดงให้เห็นถึงความมุ่งมั่น', 
     '{"experience": 80, "relationship": {"Self": 8}}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888140', '88888888-8888-8888-8888-888888888108', 'default', 
     'ผู้พิทักษ์ยอมรับในตัว Luminary และอนุญาตให้เข้าเมืองได้', 
     '{"experience": 100, "relationship": {"Guardian": 10}}', '66666666-6666-6666-6666-666666666028', '{}', '{}'),
    
    -- Event 3: Meeting the Sage outcomes
    ('88888888-8888-8888-8888-888888888141', '88888888-8888-8888-8888-888888888109', 'default', 
     'ฤาษีแนะนำตัวเองว่าชื่อ Rab และบอกว่ารอคอย Luminary มานาน', 
     '{"experience": 50}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888142', '88888888-8888-8888-8888-888888888110', 'ask_about_past', 
     'Luminary ถามเกี่ยวกับอดีตของ Luminary และภารกิจที่ต้องทำ', 
     '{"experience": 60, "relationship": {"Rab": 5}}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888143', '88888888-8888-8888-8888-888888888110', 'ask_about_future', 
     'Luminary ถามเกี่ยวกับอนาคตและสิ่งที่จะเผชิญหน้า', 
     '{"experience": 60, "relationship": {"Rab": 5}}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888144', '88888888-8888-8888-8888-888888888111', 'default', 
     'ฤาษี Rab ให้คำแนะนำเกี่ยวกับการทดสอบที่จะเผชิญหน้า', 
     '{"experience": 70, "relationship": {"Rab": 8}}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888145', '88888888-8888-8888-8888-888888888112', 'trust_sage', 
     'Luminary ตัดสินใจเชื่อฟังคำแนะนำของฤาษี Rab', 
     '{"experience": 80, "relationship": {"Rab": 10}}', '66666666-6666-6666-6666-666666666029', '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888146', '88888888-8888-8888-8888-888888888112', 'doubt_sage', 
     'Luminary มีข้อสงสัยเกี่ยวกับคำแนะนำของฤาษี แต่ก็ยังฟังไป', 
     '{"experience": 50, "relationship": {"Rab": 3}}', '66666666-6666-6666-6666-666666666029', '{}', '{}'),
    
    -- Event 4: The Ancient Library outcomes
    ('88888888-8888-8888-8888-888888888147', '88888888-8888-8888-8888-888888888113', 'default', 
     'การสำรวจห้องสมุดโบราณทำให้ Luminary รู้สึกถึงพลังแห่งความรู้', 
     '{"experience": 55}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888148', '88888888-8888-8888-8888-888888888114', 'default', 
     'ค้นพบคัมภีร์โบราณที่บอกเล่าเรื่องราวของ Luminary ในอดีต', 
     '{"experience": 80, "relationship": {"Self": 8}}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888149', '88888888-8888-8888-8888-888888888115', 'default', 
     'การอ่านคำพยานามทำให้เข้าใจชะตากรรมของตัวเองมากขึ้น', 
     '{"experience": 90, "relationship": {"Self": 10}}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888150', '88888888-8888-8888-8888-888888888116', 'default', 
     'ค้นพบความลับสำคัญเกี่ยวกับศัตรูที่ยิ่งใหญ่ที่จะมา', 
     '{"experience": 100, "gold": 50}', '66666666-6666-6666-6666-666666666030', '{}', '{}'),
    
    -- Event 5: The Dark Prophecy outcomes
    ('88888888-8888-8888-8888-888888888151', '88888888-8888-8888-8888-888888888117', 'default', 
     'ฤาษี Rab เปิดเผยว่าศัตรูที่ยิ่งใหญ่คือ Calasmos ผู้ทำลายโลกในอดีต', 
     '{"experience": 80}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888152', '88888888-8888-8888-8888-888888888118', 'default', 
     'เรียนรู้ว่า Calasmos เป็นศัตรูที่ยิ่งใหญ่ที่สุดและต้องหยุดยั้งให้ได้', 
     '{"experience": 90, "relationship": {"Self": 8}}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888153', '88888888-8888-8888-8888-888888888119', 'default', 
     'เข้าใจว่า Luminary เป็นความหวังเดียวของโลกในการต่อสู้กับ Calasmos', 
     '{"experience": 100, "relationship": {"Self": 10}}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888154', '88888888-8888-8888-8888-888888888120', 'accept_mission', 
     'Luminary ตัดสินใจรับภารกิจในการต่อสู้กับ Calasmos', 
     '{"experience": 120, "relationship": {"Self": 12}, "items": [{"id": "55555555-5555-5555-5555-555555555015", "quantity": 1}]}', '66666666-6666-6666-6666-666666666031', '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888155', '88888888-8888-8888-8888-888888888120', 'hesitate', 
     'Luminary ลังเลในการรับภารกิจ แต่ก็ยอมรับในที่สุด', 
     '{"experience": 80, "relationship": {"Self": 8}}', '66666666-6666-6666-6666-666666666031', '{}', '{}'),
    
    -- Event 6: The First Trial outcomes
    ('88888888-8888-8888-8888-888888888156', '88888888-8888-8888-8888-888888888121', 'default', 
     'เริ่มต้นการทดสอบแรกในหอคอยแห่งความกล้าหาญ', 
     '{"experience": 60}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888157', '88888888-8888-8888-8888-888888888122', 'overcome_fear', 
     'Luminary เอาชนะความกลัวที่สุดของตัวเองได้สำเร็จ', 
     '{"experience": 100, "relationship": {"Self": 10}}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888158', '88888888-8888-8888-8888-888888888123', 'defeat_shadow', 
     'Luminary เอาชนะเงามืดของตัวเองได้สำเร็จ', 
     '{"experience": 120, "gold": 40}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888159', '88888888-8888-8888-8888-888888888124', 'default', 
     'ผ่านการทดสอบแรกได้สำเร็จและได้รับพลังใหม่ "Courage"', 
     '{"experience": 150, "relationship": {"Self": 12}, "unlock_events": ["66666666-6666-6666-6666-666666666032"]}', NULL, '{}', '{}'),
    
    -- Event 7: The Second Trial outcomes
    ('88888888-8888-8888-8888-888888888160', '88888888-8888-8888-8888-888888888125', 'default', 
     'เริ่มต้นการทดสอบที่สองในวิหารแห่งปัญญา', 
     '{"experience": 80}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888161', '88888888-8888-8888-8888-888888888126', 'solve_puzzle', 
     'Luminary ไขปริศนาโบราณได้สำเร็จ แสดงให้เห็นถึงปัญญา', 
     '{"experience": 120, "gold": 60}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888162', '88888888-8888-8888-8888-888888888127', 'make_choice', 
     'Luminary ตัดสินใจที่ยากที่สุดในชีวิตอย่างมีสติ', 
     '{"experience": 140, "relationship": {"Self": 10}}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888163', '88888888-8888-8888-8888-888888888128', 'default', 
     'ผ่านการทดสอบที่สองได้สำเร็จและได้รับความรู้ใหม่ "Wisdom"', 
     '{"experience": 180, "relationship": {"Self": 15}, "unlock_events": ["66666666-6666-6666-6666-666666666033"]}', NULL, '{}', '{}'),
    
    -- Event 8: The Final Trial outcomes
    ('88888888-8888-8888-8888-888888888164', '88888888-8888-8888-8888-888888888129', 'default', 
     'เริ่มต้นการทดสอบสุดท้ายในแท่นบูชาแห่งจิตวิญญาณ', 
     '{"experience": 100}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888165', '88888888-8888-8888-8888-888888888130', 'pure_heart', 
     'Luminary ผ่านการทดสอบความบริสุทธิ์ของหัวใจได้สำเร็จ', 
     '{"experience": 150, "relationship": {"Self": 12}}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888166', '88888888-8888-8888-8888-888888888131', 'accept_past', 
     'Luminary ยอมรับอดีตและก้าวไปข้างหน้าได้สำเร็จ', 
     '{"experience": 170, "relationship": {"Self": 15}}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888167', '88888888-8888-8888-8888-888888888132', 'default', 
     'ผ่านการทดสอบทั้งหมดได้สำเร็จและได้รับการยอมรับจากเมือง Galenholm', 
     '{"experience": 250, "gold": 100, "relationship": {"Self": 20, "Rab": 15, "Guardian": 15, "Galenholm_Citizens": 10}, "unlock_events": ["66666666-6666-6666-6666-666666666034"], "unlock_chapters": ["33333333-3333-3333-3333-333333333004"]}', NULL, '{"22222222-2222-2222-2222-222222222027", "22222222-2222-2222-2222-222222222028"}', '{"11111111-1111-1111-1111-111111111004"}')
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
SELECT 'Chapter 3: The City of Trials - Story data seeded successfully!' as message;
