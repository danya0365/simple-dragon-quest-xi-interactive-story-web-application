-- Dragon Quest XI Story Data Seed - Chapter 8: The Final Confrontation
-- This file contains story data for Chapter 8 of the Dragon Quest XI storyline
-- The final battle against the Dark Lord and the resolution of the story

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
    ('11111111-1111-1111-1111-111111111008', 'Dark Lord Castle Region', 'ดินแดนแห่งความมืดที่เป็นที่ตั้งของปราสาทของ Dark Lord ซึ่งเต็มไปด้วยพลังแห่งความชั่วร้ายและสัตว์ร้าย', '/images/regions/dark_lord_castle.svg', '{}', 8, true, false)
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
    -- Dark Lord Castle Region Locations
    ('22222222-2222-2222-2222-222222222071', 'Dark Lord Castle Region', 'Castle Gates', 'ประตูปราสาทของ Dark Lord ที่ถูกป้องกันอย่างแน่นหนา', 'landmark', '{}', 1, true, false),
    ('22222222-2222-2222-2222-222222222072', 'Dark Lord Castle Region', 'Outer Courtyard', 'ลานด้านนอกของปราสาทที่เต็มไปด้วยกองทัพของ Dark Lord', 'outdoor', '{}', 2, true, false),
    ('22222222-2222-2222-2222-222222222073', 'Dark Lord Castle Region', 'Castle Entrance', 'ทางเข้าปราสาทที่มีปริศนารอคอย', 'dungeon', '{}', 3, true, false),
    ('22222222-2222-2222-2222-222222222074', 'Dark Lord Castle Region', 'Dark Corridors', 'ทางเดินมืดภายในปราสาทที่เต็มไปด้วยกับดัก', 'dungeon', '{}', 4, true, false),
    ('22222222-2222-2222-2222-222222222075', 'Dark Lord Castle Region', 'Generals Chamber', 'ห้องของแม่ทัพของ Dark Lord', 'boss_room', '{}', 5, true, false),
    ('22222222-2222-2222-2222-222222222076', 'Dark Lord Castle Region', 'Throne Room', 'ห้องบัลลังก์ของ Dark Lord', 'boss_room', '{}', 6, true, false),
    ('22222222-2222-2222-2222-222222222077', 'Dark Lord Castle Region', 'Battle Arena', 'สนามประลองยุทธ์สำหรับการต่อสู้ครั้งสุดท้าย', 'boss_room', '{}', 7, true, false),
    ('22222222-2222-2222-2222-222222222078', 'Dark Lord Castle Region', 'Power Chamber', 'ห้องแห่งพลังที่เก็บรักษาพลังมืด', 'special', '{}', 8, true, false),
    ('22222222-2222-2222-2222-222222222079', 'Dark Lord Castle Region', 'Victory Plaza', 'ลานฉลองชัยชนะหลังจากเอาชนะ Dark Lord', 'landmark', '{}', 9, true, false),
    ('22222222-2222-2222-2222-222222222080', 'Dark Lord Castle Region', 'Dawn of Peace', 'จุดที่แสงสว่างเริ่มแผ่ขยายหลังความมืดสิ้นสุดลง', 'landmark', '{}', 10, true, false)
) AS location_info(id, region_name, name, description, location_type, unlock_requirements, display_order, is_initial_user_progress, is_alway_hide_until_unlock)
WHERE wr.name = location_info.region_name;

-- Insert Story Chapters for Chapter 8
INSERT INTO story_chapters (id, title, description, chapter_number, is_unlocked, unlock_requirements, completion_requirements, created_at, updated_at) VALUES
    ('33333333-3333-3333-3333-333333333008', 'Chapter 8: The Final Confrontation', 
     'ทีมและพันธมิตรเผชิญหน้ากับ Dark Lord ในการต่อสู้ครั้งสุดท้ายเพื่อกอบกู้โลกและปลดปล่อยความมืด', 
     8, false, 
     '{"completed_chapters": ["33333333-3333-3333-3333-333333333007"], "completed_events": ["66666666-6666-6666-6666-666666666071", "66666666-6666-6666-6666-666666666072", "66666666-6666-6666-6666-666666666073"]}', 
     '{"completed_events": ["66666666-6666-6666-6666-666666666081", "66666666-6666-6666-6666-666666666082", "66666666-6666-6666-6666-666666666083"]}', 
     NOW(), NOW())
ON CONFLICT (id) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    chapter_number = EXCLUDED.chapter_number,
    is_unlocked = EXCLUDED.is_unlocked,
    unlock_requirements = EXCLUDED.unlock_requirements,
    completion_requirements = EXCLUDED.completion_requirements,
    updated_at = NOW();

-- Insert Story Events for Chapter 8
INSERT INTO story_events (id, chapter_id, title, description, event_type, is_unlocked, unlock_requirements, completion_requirements, location_id, created_at, updated_at) VALUES
    -- Event 1: The Castle Gates
    ('66666666-6666-6666-6666-666666666074', '33333333-3333-3333-3333-333333333008', 
     'ประตูปราสาท', 'ทีมและพันธมิตรมาถึงประตูปราสาทของ Dark Lord พร้อมสำหรับการต่อสู้', 
     'story_progression', false, 
     '{"completed_events": ["66666666-6666-6666-6666-666666666073"]}', 
     '{"completed_interactions": ["88888888-8888-8888-8888-888888888561"]}', 
     '22222222-2222-2222-2222-222222222071', NOW(), NOW()),
    
    -- Event 2: The Dark Lord's Army
    ('66666666-6666-6666-6666-666666666075', '33333333-3333-3333-3333-333333333008', 
     'กองทัพของ Dark Lord', 'ทีมต้องเผชิญหน้ากับกองทัพของ Dark Lord ก่อนจะเข้าไปในปราสาท', 
     'battle', false, 
     '{"completed_events": ["66666666-6666-6666-6666-666666666074"]}', 
     '{"completed_interactions": ["88888888-8888-8888-8888-888888888565"]}', 
     '22222222-2222-2222-2222-222222222072', NOW(), NOW()),
    
    -- Event 3: The Castle Entrance
    ('66666666-6666-6666-6666-666666666076', '33333333-3333-3333-3333-333333333008', 
     'ทางเข้าปราสาท', 'ทีมเข้าสู่ปราสาทของ Dark Lord และเผชิญหน้ากับปริศนาแรก', 
     'puzzle', false, 
     '{"completed_events": ["66666666-6666-6666-6666-666666666075"]}', 
     '{"completed_interactions": ["88888888-8888-8888-8888-888888888569"]}', 
     '22222222-2222-2222-2222-222222222073', NOW(), NOW()),
    
    -- Event 4: The Dark Corridors
    ('66666666-6666-6666-6666-666666666077', '33333333-3333-3333-3333-333333333008', 
     'ทางเดินมืด', 'ทีมต้องผ่านทางเดินมืดที่เต็มไปด้วยกับดักและศัตรู', 
     'exploration', false, 
     '{"completed_events": ["66666666-6666-6666-6666-666666666076"]}', 
     '{"completed_interactions": ["88888888-8888-8888-8888-888888888573"]}', 
     '22222222-2222-2222-2222-222222222074', NOW(), NOW()),
    
    -- Event 5: The Dark Lord's Generals
    ('66666666-6666-6666-6666-666666666078', '33333333-3333-3333-3333-333333333008', 
     'แม่ทัพของ Dark Lord', 'ทีมต้องเผชิญหน้ากับแม่ทัพของ Dark Lord ในการต่อสู้ครั้งใหญ่', 
     'boss_encounter', false, 
     '{"completed_events": ["66666666-6666-6666-6666-666666666077"]}', 
     '{"completed_interactions": ["88888888-8888-8888-8888-888888888577"]}', 
     '22222222-2222-2222-2222-222222222075', NOW(), NOW()),
    
    -- Event 6: The Throne Room
    ('66666666-6666-6666-6666-666666666079', '33333333-3333-3333-3333-333333333008', 
     'ห้องบัลลังก์', 'ทีมมาถึงห้องบัลลังก์ของ Dark Lord และพบกับเขา', 
     'story_progression', false, 
     '{"completed_events": ["66666666-6666-6666-6666-666666666078"]}', 
     '{"completed_interactions": ["88888888-8888-8888-8888-888888888581"]}', 
     '22222222-2222-2222-2222-222222222076', NOW(), NOW()),
    
    -- Event 7: The Final Battle Begins
    ('66666666-6666-6666-6666-666666666080', '33333333-3333-3333-3333-333333333008', 
     'การต่อสู้ครั้งสุดท้ายเริ่มต้น', 'การต่อสู้ครั้งสุดท้ายกับ Dark Lord เริ่มต้นขึ้น', 
     'boss_encounter', false, 
     '{"completed_events": ["66666666-6666-6666-6666-666666666079"]}', 
     '{"completed_interactions": ["88888888-8888-8888-8888-888888888585"]}', 
     '22222222-2222-2222-2222-222222222077', NOW(), NOW()),
    
    -- Event 8: The Power of Light
    ('66666666-6666-6666-6666-666666666081', '33333333-3333-3333-3333-333333333008', 
     'พลังแห่งแสงสว่าง', 'ทีมใช้พลังแห่งแสงสว่างที่รวบรวมมาเพื่อต่อสู้กับ Dark Lord', 
     'power_discovery', false, 
     '{"completed_events": ["66666666-6666-6666-6666-666666666080"]}', 
     '{"completed_interactions": ["88888888-8888-8888-8888-888888888589"]}', 
     '22222222-2222-2222-2222-222222222078', NOW(), NOW()),
    
    -- Event 9: The Dark Lord's Defeat
    ('66666666-6666-6666-6666-666666666082', '33333333-3333-3333-3333-333333333008', 
     'การพ่ายแพ้ของ Dark Lord', 'Dark Lord พ่ายแพ้ต่อพลังของทีมและพันธมิตร', 
     'story_progression', false, 
     '{"completed_events": ["66666666-6666-6666-6666-666666666081"]}', 
     '{"completed_interactions": ["88888888-8888-8888-8888-888888888593"]}', 
     '22222222-2222-2222-2222-222222222079', NOW(), NOW()),
    
    -- Event 10: The Dawn of Peace
    ('66666666-6666-6666-6666-666666666083', '33333333-3333-3333-3333-333333333008', 
     'รุ่งอรุณแห่งสันติภาพ', 'ความมืดสลายไปและสันติภาพกลับคืนมาสู่โลก', 
     'story_progression', false, 
     '{"completed_events": ["66666666-6666-6666-6666-666666666082"]}', 
     '{"completed_interactions": ["88888888-8888-8888-8888-888888888597"]}', 
     '22222222-2222-2222-2222-222222222080', NOW(), NOW())
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

-- Insert Event Interactions for Chapter 8
INSERT INTO event_interactions (id, event_id, title, description, interaction_type, is_required, requirements, created_at, updated_at) VALUES
    -- Event 1: The Castle Gates interactions
    ('88888888-8888-8888-8888-888888888561', '66666666-6666-6666-6666-666666666074', 
     'สำรวจประตูปราสาท', 'สำรวจประตูปราสาทที่ถูกป้องกันอย่างแน่นหนา', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888562', '66666666-6666-6666-6666-666666666074', 
     'วางแผนการเข้าปราสาท', 'วางแผนการเข้าปราสาทอย่างระมัดระวัง', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888563', '66666666-6666-6666-6666-666666666074', 
     'เตรียมพร้อมสำหรับการต่อสู้', 'เตรียมพร้อมสำหรับการต่อสู้ที่จะเกิดขึ้น', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888564', '66666666-6666-6666-6666-666666666074', 
     'เข้าปราสาท', 'ตัดสินใจเข้าปราสาทเพื่อเผชิญหน้ากับ Dark Lord', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    -- Event 2: The Dark Lord's Army interactions
    ('88888888-8888-8888-8888-888888888565', '66666666-6666-6666-6666-666666666075', 
     'เผชิญหน้ากับกองทัพ', 'เผชิญหน้ากับกองทัพของ Dark Lord', 
     'battle', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888566', '66666666-6666-6666-6666-666666666075', 
     'ต่อสู้กับทหาร', 'ต่อสู้กับทหารของ Dark Lord', 
     'battle', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888567', '66666666-6666-6666-6666-666666666075', 
     'ใช้กลยุทธ์', 'ใช้กลยุทธ์ในการเอาชนะกองทัพ', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888568', '66666666-6666-6666-6666-666666666075', 
     'เอาชนะกองทัพ', 'เอาชนะกองทัพของ Dark Lord ได้สำเร็จ', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    -- Event 3: The Castle Entrance interactions
    ('88888888-8888-8888-8888-888888888569', '66666666-6666-6666-6666-666666666076', 
     'สำรวจทางเข้า', 'สำรวจทางเข้าปราสาทที่เต็มไปด้วยปริศนา', 
     'puzzle', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888570', '66666666-6666-6666-6666-666666666076', 
     'แก้ปริศนาแรก', 'แก้ปริศนาแรกเพื่อเปิดประตูเข้าปราสาท', 
     'puzzle', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888571', '66666666-6666-6666-6666-666666666076', 
     'ใช้ความรู้โบราณ', 'ใช้ความรู้โบราณที่ได้จากวิหาร', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888572', '66666666-6666-6666-6666-666666666076', 
     'เข้าปราสาทสำเร็จ', 'เข้าปราสาทได้สำเร็จหลังจากแก้ปริศนา', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    -- Event 4: The Dark Corridors interactions
    ('88888888-8888-8888-8888-888888888573', '66666666-6666-6666-6666-666666666077', 
     'สำรวจทางเดิน', 'สำรวจทางเดินมืดในปราสาท', 
     'exploration', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888574', '66666666-6666-6666-6666-666666666077', 
     'เผชิญกับดัก', 'เผชิญหน้ากับกับดักที่ซ่อนอยู่', 
     'trial', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888575', '66666666-6666-6666-6666-666666666077', 
     'ต่อสู้กับศัตรู', 'ต่อสู้กับศัตรูที่ซ่อนอยู่ในทางเดิน', 
     'battle', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888576', '66666666-6666-6666-6666-666666666077', 
     'ผ่านทางเดินมืด', 'ผ่านทางเดินมืดไปยังห้องบัลลังก์', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    -- Event 5: The Dark Lord's Generals interactions
    ('88888888-8888-8888-8888-888888888577', '66666666-6666-6666-6666-666666666078', 
     'เผชิญหน้ากับแม่ทัพ', 'เผชิญหน้ากับแม่ทัพของ Dark Lord', 
     'boss_encounter', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888578', '66666666-6666-6666-6666-666666666078', 
     'ต่อสู้กับแม่ทัพ', 'ต่อสู้กับแม่ทัพที่แข็งแกร่ง', 
     'boss_encounter', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888579', '66666666-6666-6666-6666-666666666078', 
     'ใช้พลังรวม', 'ใช้พลังรวมของทีมในการต่อสู้', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888580', '66666666-6666-6666-6666-666666666078', 
     'เอาชนะแม่ทัพ', 'เอาชนะแม่ทัพของ Dark Lord ได้สำเร็จ', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    -- Event 6: The Throne Room interactions
    ('88888888-8888-8888-8888-888888888581', '66666666-6666-6666-6666-666666666079', 
     'เข้าห้องบัลลังก์', 'เข้าสู่ห้องบัลลังก์ของ Dark Lord', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888582', '66666666-6666-6666-6666-666666666079', 
     'พบกับ Dark Lord', 'พบกับ Dark Lord ในห้องบัลลังก์', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888583', '66666666-6666-6666-6666-666666666079', 
     'พูดคุยกับ Dark Lord', 'พูดคุยกับ Dark Lord เกี่ยวกับสิ่งที่เขาทำ', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888584', '66666666-6666-6666-6666-666666666079', 
     'เตรียมสำหรับการต่อสู้', 'เตรียมพร้อมสำหรับการต่อสู้ครั้งสุดท้าย', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    -- Event 7: The Final Battle Begins interactions
    ('88888888-8888-8888-8888-888888888585', '66666666-6666-6666-6666-666666666080', 
     'เริ่มการต่อสู้', 'การต่อสู้ครั้งสุดท้ายกับ Dark Lord เริ่มต้นขึ้น', 
     'boss_encounter', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888586', '66666666-6666-6666-6666-666666666080', 
     'ต่อสู้กับ Dark Lord', 'ต่อสู้กับ Dark Lord อย่างดุเดือด', 
     'boss_encounter', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888587', '66666666-6666-6666-6666-666666666080', 
     'ใช้ทุกพลัง', 'ใช้ทุกพลังที่มีในการต่อสู้', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888588', '66666666-6666-6666-6666-666666666080', 
     'ท้าทาย Dark Lord', 'ท้าทาย Dark Lord ให้ต่อสู้ต่อไป', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    -- Event 8: The Power of Light interactions
    ('88888888-8888-8888-8888-888888888589', '66666666-6666-6666-6666-666666666081', 
     'เรียกใช้พลังแสงสว่าง', 'เรียกใช้พลังแห่งแสงสว่างที่รวบรวมมา', 
     'power_discovery', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888590', '66666666-6666-6666-6666-666666666081', 
     'ใช้พลังรวม', 'ใช้พลังรวมของทีมและพันธมิตร', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888591', '66666666-6666-6666-6666-666666666081', 
     'โจมตีด้วยพลังแสง', 'โจมตี Dark Lord ด้วยพลังแห่งแสงสว่าง', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888592', '66666666-6666-6666-6666-666666666081', 
     'เอาชนะความมืด', 'เอาชนะพลังความมืดของ Dark Lord', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    -- Event 9: The Dark Lord's Defeat interactions
    ('88888888-8888-8888-8888-888888888593', '66666666-6666-6666-6666-666666666082', 
     'Dark Lord พ่ายแพ้', 'Dark Lord พ่ายแพ้ต่อพลังของทีม', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888594', '66666666-6666-6666-6666-666666666082', 
     'พูดคุยครั้งสุดท้าย', 'พูดคุยกับ Dark Lord ครั้งสุดท้าย', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888595', '66666666-6666-6666-6666-666666666082', 
     'เข้าใจเหตุผล', 'เข้าใจเหตุผลที่ Dark Lord ทำสิ่งเหล่านี้', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888596', '66666666-6666-6666-6666-666666666082', 
     'ความมืดสลายไป', 'ความมืดเริ่มสลายไปจากโลก', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    -- Event 10: The Dawn of Peace interactions
    ('88888888-8888-8888-8888-888888888597', '66666666-6666-6666-6666-666666666083', 
     'แสงสว่างกลับมา', 'แสงสว่างกลับมาสู่โลกอีกครั้ง', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888598', '66666666-6666-6666-6666-666666666083', 
     'ฉลองชัยชนะ', 'ทีมและพันธมิตรฉลองชัยชนะ', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888599', '66666666-6666-6666-6666-666666666083', 
     'กลับสู่บ้าน', 'ทีมและพันธมิตรกลับสู่บ้านของตน', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888600', '66666666-6666-6666-6666-666666666083', 
     'สันติภาพเริ่มต้น', 'สันติภาพเริ่มต้นขึ้นในโลก', 
     'dialogue', true, '{}', NOW(), NOW())
ON CONFLICT (id) DO UPDATE SET
    event_id = EXCLUDED.event_id,
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    interaction_type = EXCLUDED.interaction_type,
    is_required = EXCLUDED.is_required,
    requirements = EXCLUDED.requirements,
    updated_at = NOW();

-- Insert Event Outcomes for Chapter 8
INSERT INTO event_outcomes (id, interaction_id, choice_key, outcome_text, effects, next_event_id, auto_unlocked_locations, auto_unlocked_regions) VALUES
    -- Event 1: The Castle Gates outcomes
    ('88888888-8888-8888-8888-888888888601', '88888888-8888-8888-8888-888888888561', 'default', 
     'สำรวจประตูปราสาทที่ถูกป้องกันอย่างแน่นหนา', 
     '{"experience": 150}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888602', '88888888-8888-8888-8888-888888888562', 'default', 
     'วางแผนการเข้าปราสาทอย่างระมัดระวัง', 
     '{"experience": 180, "relationship": {"Self": 10}}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888603', '88888888-8888-8888-8888-888888888563', 'default', 
     'เตรียมพร้อมสำหรับการต่อสู้ที่จะเกิดขึ้น', 
     '{"experience": 220, "relationship": {"Erik": 5, "Veronica": 5, "Serena": 5}}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888604', '88888888-8888-8888-8888-888888888564', 'default', 
     'ตัดสินใจเข้าปราสาทเพื่อเผชิญหน้ากับ Dark Lord', 
     '{"experience": 280, "gold": 100, "unlock_events": ["66666666-6666-6666-6666-666666666075"]}', '66666666-6666-6666-6666-666666666075', '{}', '{}'),
    
    -- Event 2: The Dark Lord's Army outcomes
    ('88888888-8888-8888-8888-888888888605', '88888888-8888-8888-8888-888888888565', 'default', 
     'เผชิญหน้ากับกองทัพของ Dark Lord', 
     '{"experience": 200}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888606', '88888888-8888-8888-8888-888888888566', 'default', 
     'ต่อสู้กับทหารของ Dark Lord อย่างกล้าหาญ', 
     '{"experience": 250, "gold": 80}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888607', '88888888-8888-8888-8888-888888888567', 'default', 
     'ใช้กลยุทธ์ในการเอาชนะกองทัพ', 
     '{"experience": 320, "relationship": {"Self": 15}}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888608', '88888888-8888-8888-8888-888888888568', 'default', 
     'เอาชนะกองทัพของ Dark Lord ได้สำเร็จ', 
     '{"experience": 400, "gold": 150, "relationship": {"Erik": 10, "Veronica": 10, "Serena": 10}, "unlock_events": ["66666666-6666-6666-6666-666666666076"]}', '66666666-6666-6666-6666-666666666076', '{}', '{}'),
    
    -- Event 3: The Castle Entrance outcomes
    ('88888888-8888-8888-8888-888888888609', '88888888-8888-8888-8888-888888888569', 'default', 
     'สำรวจทางเข้าปราสาทที่เต็มไปด้วยปริศนา', 
     '{"experience": 180}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888610', '88888888-8888-8888-8888-888888888570', 'solve_puzzle', 
     'แก้ปริศนาแรกเพื่อเปิดประตูเข้าปราสาท', 
     '{"experience": 240, "gold": 100}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888611', '88888888-8888-8888-8888-888888888571', 'default', 
     'ใช้ความรู้โบราณที่ได้จากวิหารในการแก้ปริศนา', 
     '{"experience": 300, "relationship": {"Self": 20}}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888612', '88888888-8888-8888-8888-888888888572', 'default', 
     'เข้าปราสาทได้สำเร็จหลังจากแก้ปริศนา', 
     '{"experience": 380, "gold": 120, "items": [{"id": "55555555-5555-5555-5555-555555555024", "quantity": 1}], "unlock_events": ["66666666-6666-6666-6666-666666666077"]}', '66666666-6666-6666-6666-666666666077', '{}', '{}'),
    
    -- Event 4: The Dark Corridors outcomes
    ('88888888-8888-8888-8888-888888888613', '88888888-8888-8888-8888-888888888573', 'default', 
     'สำรวจทางเดินมืดในปราสาท', 
     '{"experience": 200}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888614', '88888888-8888-8888-8888-888888888574', 'pass_trial', 
     'เผชิญหน้ากับกับดักและผ่านไปได้สำเร็จ', 
     '{"experience": 260, "gold": 80}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888615', '88888888-8888-8888-8888-888888888575', 'default', 
     'ต่อสู้กับศัตรูที่ซ่อนอยู่ในทางเดิน', 
     '{"experience": 340, "relationship": {"Erik": 8, "Veronica": 8, "Serena": 8}}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888616', '88888888-8888-8888-8888-888888888576', 'default', 
     'ผ่านทางเดินมืดไปยังห้องบัลลังก์', 
     '{"experience": 420, "gold": 100, "unlock_events": ["66666666-6666-6666-6666-666666666078"]}', '66666666-6666-6666-6666-666666666078', '{}', '{}'),
    
    -- Event 5: The Dark Lord's Generals outcomes
    ('88888888-8888-8888-8888-888888888617', '88888888-8888-8888-8888-888888888577', 'default', 
     'เผชิญหน้ากับแม่ทัพของ Dark Lord', 
     '{"experience": 250}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888618', '88888888-8888-8888-8888-888888888578', 'default', 
     'ต่อสู้กับแม่ทัพที่แข็งแกร่งอย่างดุเดือด', 
     '{"experience": 320, "gold": 120}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888619', '88888888-8888-8888-8888-888888888579', 'default', 
     'ใช้พลังรวมของทีมในการต่อสู้', 
     '{"experience": 400, "relationship": {"Self": 25}}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888620', '88888888-8888-8888-8888-888888888580', 'default', 
     'เอาชนะแม่ทัพของ Dark Lord ได้สำเร็จ', 
     '{"experience": 500, "gold": 200, "relationship": {"Erik": 15, "Veronica": 15, "Serena": 15}, "unlock_events": ["66666666-6666-6666-6666-666666666079"]}', '66666666-6666-6666-6666-666666666079', '{}', '{}'),
    
    -- Event 6: The Throne Room outcomes
    ('88888888-8888-8888-8888-888888888621', '88888888-8888-8888-8888-888888888581', 'default', 
     'เข้าสู่ห้องบัลลังก์ของ Dark Lord', 
     '{"experience": 200}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888622', '88888888-8888-8888-8888-888888888582', 'default', 
     'พบกับ Dark Lord ในห้องบัลลังก์', 
     '{"experience": 280, "relationship": {"Self": 15}}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888623', '88888888-8888-8888-8888-888888888583', 'default', 
     'พูดคุยกับ Dark Lord เกี่ยวกับสิ่งที่เขาทำ', 
     '{"experience": 360, "relationship": {"Self": 20}}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888624', '88888888-8888-8888-8888-888888888584', 'default', 
     'เตรียมพร้อมสำหรับการต่อสู้ครั้งสุดท้าย', 
     '{"experience": 450, "gold": 150, "relationship": {"Erik": 5, "Veronica": 5, "Serena": 5, "Self": 30}, "unlock_events": ["66666666-6666-6666-6666-666666666080"]}', '66666666-6666-6666-6666-666666666080', '{}', '{}'),
    
    -- Event 7: The Final Battle Begins outcomes
    ('88888888-8888-8888-8888-888888888625', '88888888-8888-8888-8888-888888888585', 'default', 
     'การต่อสู้ครั้งสุดท้ายกับ Dark Lord เริ่มต้นขึ้น', 
     '{"experience": 300}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888626', '88888888-8888-8888-8888-888888888586', 'default', 
     'ต่อสู้กับ Dark Lord อย่างดุเดือด', 
     '{"experience": 400, "gold": 100}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888627', '88888888-8888-8888-8888-888888888587', 'default', 
     'ใช้ทุกพลังที่มีในการต่อสู้', 
     '{"experience": 500, "relationship": {"Self": 25}}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888628', '88888888-8888-8888-8888-888888888588', 'default', 
     'ท้าทาย Dark Lord ให้ต่อสู้ต่อไป', 
     '{"experience": 600, "gold": 150, "relationship": {"Erik": 10, "Veronica": 10, "Serena": 10, "Self": 35}, "unlock_events": ["66666666-6666-6666-6666-666666666081"]}', '66666666-6666-6666-6666-666666666081', '{}', '{}'),
    
    -- Event 8: The Power of Light outcomes
    ('88888888-8888-8888-8888-888888888629', '88888888-8888-8888-8888-888888888589', 'default', 
     'เรียกใช้พลังแห่งแสงสว่างที่รวบรวมมา', 
     '{"experience": 350}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888630', '88888888-8888-8888-8888-888888888590', 'default', 
     'ใช้พลังรวมของทีมและพันธมิตร', 
     '{"experience": 450, "relationship": {"Self": 30}}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888631', '88888888-8888-8888-8888-888888888591', 'default', 
     'โจมตี Dark Lord ด้วยพลังแห่งแสงสว่าง', 
     '{"experience": 550, "relationship": {"Erik": 15, "Veronica": 15, "Serena": 15}}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888632', '88888888-8888-8888-8888-888888888592', 'default', 
     'เอาชนะพลังความมืดของ Dark Lord', 
     '{"experience": 700, "gold": 200, "items": [{"id": "55555555-5555-5555-5555-555555555025", "quantity": 1}], "unlock_events": ["66666666-6666-6666-6666-666666666082"]}', '66666666-6666-6666-6666-666666666082', '{}', '{}'),
    
    -- Event 9: The Dark Lord's Defeat outcomes
    ('88888888-8888-8888-8888-888888888633', '88888888-8888-8888-8888-888888888593', 'default', 
     'Dark Lord พ่ายแพ้ต่อพลังของทีม', 
     '{"experience": 400}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888634', '88888888-8888-8888-8888-888888888594', 'default', 
     'พูดคุยกับ Dark Lord ครั้งสุดท้าย', 
     '{"experience": 500, "relationship": {"Self": 40}}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888635', '88888888-8888-8888-8888-888888888595', 'default', 
     'เข้าใจเหตุผลที่ Dark Lord ทำสิ่งเหล่านี้', 
     '{"experience": 600, "relationship": {"Self": 50}}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888636', '88888888-8888-8888-8888-888888888596', 'default', 
     'ความมืดเริ่มสลายไปจากโลก', 
     '{"experience": 800, "gold": 300, "relationship": {"Erik": 20, "Veronica": 20, "Serena": 20, "Self": 60}, "unlock_events": ["66666666-6666-6666-6666-666666666083"]}', '66666666-6666-6666-6666-666666666083', '{}', '{}'),
    
    -- Event 10: The Dawn of Peace outcomes
    ('88888888-8888-8888-8888-888888888637', '88888888-8888-8888-8888-888888888597', 'default', 
     'แสงสว่างกลับมาสู่โลกอีกครั้ง', 
     '{"experience": 500}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888638', '88888888-8888-8888-8888-888888888598', 'default', 
     'ทีมและพันธมิตรฉลองชัยชนะ', 
     '{"experience": 650, "relationship": {"Erik": 25, "Veronica": 25, "Serena": 25}}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888639', '88888888-8888-8888-8888-888888888599', 'default', 
     'ทีมและพันธมิตรกลับสู่บ้านของตน', 
     '{"experience": 800, "gold": 200}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888640', '88888888-8888-8888-8888-888888888600', 'default', 
     'สันติภาพเริ่มต้นขึ้นในโลกและเรื่องราวจบลง', 
     '{"experience": 1000, "gold": 500, "relationship": {"Erik": 30, "Veronica": 30, "Serena": 30, "Self": 100}, "unlock_chapters": ["33333333-3333-3333-3333-333333333009"], "unlock_regions": ["11111111-1111-1111-1111-111111111009"]}', NULL, '{"22222222-2222-2222-2222-222222222081", "22222222-2222-2222-2222-222222222082"}', '{"11111111-1111-1111-1111-111111111009"}'),
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
SELECT 'Chapter 8: The Final Confrontation - Story data seeded successfully!' as message;
