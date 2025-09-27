-- Dragon Quest XI Story Data Seed - Chapter 2: The Journey Begins
-- This file contains story data for Chapter 2 of the Dragon Quest XI storyline
-- Following the awakening of Luminary, the true journey begins

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
    ('11111111-1111-1111-1111-111111111003', 'Galenholm Region', 'ดินแดนที่อยู่ทางทิศเหนือของ Cobblestone ซึ่งเป็นที่ตั้งของเมือง Galenholm แห่งการทดสอบ', '/images/regions/galenholm.svg', '{"completed_events": ["66666666-6666-6666-6666-666666666025"]}', 3, false, true)
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
    -- Path Locations (between regions)
    ('22222222-2222-2222-2222-222222222013', 'Heliodor Region', 'Forest Path', 'เส้นทางป่าที่เชื่อมระหว่าง Cobblestone และ Heliodor เต็มไปด้วยสัตว์ป่าและอันตราย', 'path', '{"completed_events": ["66666666-6666-6666-6666-666666666017"]}', 1, false, true),
    ('22222222-2222-2222-2222-222222222014', 'Heliodor Region', 'Hidden Clearing', 'ทุ่งหญ่แห่งความลับที่ซ่อนอยู่ในป่า เป็นที่พบกับบุคคลลึกลับ', 'landmark', '{"completed_events": ["66666666-6666-6666-6666-666666666018"]}', 2, false, true),
    ('22222222-2222-2222-2222-222222222015', 'Heliodor Region', 'Ancient Ruins', 'ซากปรักหักพังโบราณที่เต็มไปด้วยความลับและพลังลึกลับ', 'dungeon', '{"completed_events": ["66666666-6666-6666-6666-666666666019"]}', 3, false, true),
    ('22222222-2222-2222-2222-222222222016', 'Heliodor Region', 'Crossroads', 'ทางแยกสำคัญที่เชื่อมระหว่างเส้นทางต่างๆ เป็นจุดตัดสินใจในการเดินทาง', 'landmark', '{"completed_events": ["66666666-6666-6666-6666-666666666020"]}', 4, false, true),
    
    -- First Town (in new region)
    ('22222222-2222-2222-2222-222222222017', 'Galenholm Region', 'First Town', 'เมืองเล็กๆ แรกที่ Luminary พบหลังจากออกเดินทางจาก Cobblestone เต็มไปด้วยผู้คนที่เป็นมิตร', 'town', '{"completed_events": ["66666666-6666-6666-6666-666666666021"], "choices": {"88888888-8888-8888-8888-888888888053": "go_to_town"}}', 1, false, true),
    
    -- Mountain Path (alternative route)
    ('22222222-2222-2222-2222-222222222018', 'Heliodor Region', 'Mountain Path', 'เส้นทางภูเขาที่สูงชันและอันตรายแต่เต็มไปด้วยความท้าทายและรางวัล', 'path', '{"completed_events": ["66666666-6666-6666-6666-666666666021"], "choices": {"88888888-8888-8888-8888-888888888053": "go_to_mountains"}}', 5, false, true)
) AS location_info(id, region_name, name, description, location_type, unlock_requirements, display_order, is_initial_user_progress, is_alway_hide_until_unlock)
WHERE wr.name = location_info.region_name;

-- Insert Story Chapters for Chapter 2
INSERT INTO story_chapters (id, title, description, chapter_number, is_unlocked, unlock_requirements, completion_requirements, created_at, updated_at) VALUES
    ('33333333-3333-3333-3333-333333333002', 'Chapter 2: The Journey Begins', 
     'หลังจากการตื่นขึ้นของ Luminary การเดินทางที่แท้จริงก็เริ่มต้นขึ้น ต้องเผชิญหน้ากับโชคชะตาและออกเดินทางไปยังโลกกว้าง', 
     2, false, 
     '{"completed_chapters": ["33333333-3333-3333-3333-333333333001"], "completed_events": ["66666666-6666-6666-6666-666666666016"]}', 
     '{"completed_events": ["66666666-6666-6666-6666-666666666021", "66666666-6666-6666-6666-666666666022", "66666666-6666-6666-6666-666666666023"]}', 
     NOW(), NOW())
ON CONFLICT (id) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    chapter_number = EXCLUDED.chapter_number,
    is_unlocked = EXCLUDED.is_unlocked,
    unlock_requirements = EXCLUDED.unlock_requirements,
    completion_requirements = EXCLUDED.completion_requirements,
    updated_at = NOW();

-- Insert Story Events for Chapter 2
INSERT INTO story_events (id, chapter_id, title, description, event_type, is_unlocked, unlock_requirements, completion_requirements, location_id, created_at, updated_at) VALUES
    -- Event 1: Leaving Cobblestone
    ('66666666-6666-6666-6666-666666666017', '33333333-3333-3333-3333-333333333002', 
     'การอำลาบ้านเกิด', 'Luminary ต้องตัดสินใจออกเดินทางจาก Cobblestone เพื่อตามหาความจริงและพิสูจน์ตัวเอง', 
     'story_decision', false, 
     '{"completed_events": ["66666666-6666-6666-6666-666666666016"]}', 
     '{"completed_interactions": ["88888888-8888-8888-8888-888888888037"]}', 
     '22222222-2222-2222-2222-222222222001', NOW(), NOW()),
    
    -- Event 2: The First Battle
    ('66666666-6666-6666-6666-666666666018', '33333333-3333-3333-3333-333333333002', 
     'การต่อสู้ครั้งแรก', 'การเดินทางครั้งแรกนำพา Luminary ไปพบกับศัตรูครั้งแรก ต้องใช้พลังใหม่ในการป้องกันตัวเอง', 
     'battle', false, 
     '{"completed_events": ["66666666-6666-6666-6666-666666666017"]}', 
     '{"completed_interactions": ["88888888-8888-8888-8888-888888888041"]}', 
     '22222222-2222-2222-2222-222222222013', NOW(), NOW()),
    
    -- Event 3: Meeting the Mysterious Stranger
    ('66666666-6666-6666-6666-666666666019', '33333333-3333-3333-3333-333333333002', 
     'พบกับบุคคลลึกลับ', 'ระหว่างการเดินทาง Luminary ได้พบกับบุคคลลึกลับที่อาจจะเป็นพันธมิตรหรือศัตรู', 
     'character_introduction', false, 
     '{"completed_events": ["66666666-6666-6666-6666-666666666018"]}', 
     '{"completed_interactions": ["88888888-8888-8888-8888-888888888045"]}', 
     '22222222-2222-2222-2222-222222222014', NOW(), NOW()),
    
    -- Event 4: The Ancient Ruins
    ('66666666-6666-6666-6666-666666666020', '33333333-3333-3333-3333-333333333002', 
     'ซากปรักหักพังโบราณ', 'การค้นพบซากปรักหักพังโบราณเปิดเผยความลับเกี่ยวกับอดีตและพลังของ Luminary', 
     'discovery', false, 
     '{"completed_events": ["66666666-6666-6666-6666-666666666019"]}', 
     '{"completed_interactions": ["88888888-8888-8888-8888-888888888049"]}', 
     '22222222-2222-2222-2222-222222222015', NOW(), NOW()),
    
    -- Event 5: The Crossroads
    ('66666666-6666-6666-6666-666666666021', '33333333-3333-3333-3333-333333333002', 
     'ทางแยกสำคัญ', 'ถึงทางแยกสำคัญที่ Luminary ต้องตัดสินใจเลือกเส้นทางต่อไปในการเดินทาง', 
     'story_decision', false, 
     '{"completed_events": ["66666666-6666-6666-6666-666666666020"]}', 
     '{"completed_interactions": ["88888888-8888-8888-8888-888888888053"]}', 
     '22222222-2222-2222-2222-222222222016', NOW(), NOW()),
    
    -- Event 6: The First Town
    ('66666666-6666-6666-6666-666666666022', '33333333-3333-3333-3333-333333333002', 
     'เมืองแรกในการเดินทาง', 'มาถึงเมืองแรกนอก Cobblestone พบกับวัฒนธรรมใหม่และผู้คนที่แตกต่าง', 
     'location_introduction', false, 
     '{"completed_events": ["66666666-6666-6666-6666-666666666021"], "choices": {"88888888-8888-8888-8888-888888888053": "go_to_town"}}', 
     '{"completed_interactions": ["88888888-8888-8888-8888-888888888057"]}', 
     '22222222-2222-2222-2222-222222222017', NOW(), NOW()),
    
    -- Event 7: The Mountain Path
    ('66666666-6666-6666-6666-666666666023', '33333333-3333-3333-3333-333333333002', 
     'เส้นทางภูเขา', 'เลือกเส้นทางภูเขาที่อันตรายแต่เต็มไปด้วยความท้าทายและรางวัล', 
     'location_introduction', false, 
     '{"completed_events": ["66666666-6666-6666-6666-666666666021"], "choices": {"88888888-8888-8888-8888-888888888053": "go_to_mountains"}}', 
     '{"completed_interactions": ["88888888-8888-8888-8888-888888888061"]}', 
     '22222222-2222-2222-2222-222222222018', NOW(), NOW())
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

-- Insert Event Interactions for Chapter 2
INSERT INTO event_interactions (id, event_id, title, description, interaction_type, is_required, requirements, created_at, updated_at) VALUES
    -- Event 1: Leaving Cobblestone interactions
    ('88888888-8888-8888-8888-888888888037', '66666666-6666-6666-6666-666666666017', 
     'พูดคุยกับ Gemma', 'Gemma มาหา Luminary ก่อนการเดินทางเพื่อมอบของขวัญและคำอำลา', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888038', '66666666-6666-6666-6666-666666666017', 
     'พูดคุยกับ Chalky', 'Chalky ให้คำแนะนำสุดท้ายและเตือนถึงอันตรายที่รออยู่', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888039', '66666666-6666-6666-6666-666666666017', 
     'พูดคุยกับผู้เฒ่า', 'ผู้เฒ่ามอบคำพยานามและคำทำนายสำคัญก่อนการเดินทาง', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888040', '66666666-6666-6666-6666-666666666017', 
     'ตัดสินใจออกเดินทาง', 'เวลาตัดสินใจสุดท้ายก่อนออกเดินทางจาก Cobblestone', 
     'choice', true, '{}', NOW(), NOW()),
    
    -- Event 2: The First Battle interactions
    ('88888888-8888-8888-8888-888888888041', '66666666-6666-6666-6666-666666666018', 
     'เผชิญหน้ากับสัตว์ป่า', 'พบกับสัตว์ป่าดุร้ายที่โจมตีขณะเดินทาง', 
     'battle', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888042', '66666666-6666-6666-6666-666666666018', 
     'ใช้พลังใหม่', 'ลองใช้พลังใหม่ที่ได้รับจากการตื่นขึ้น', 
     'choice', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888043', '66666666-6666-6666-666666666018', 
     'เรียนรู้การต่อสู้', 'เรียนรู้พื้นฐานการต่อสู้จากประสบการณ์ครั้งแรก', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888044', '66666666-6666-6666-6666-666666666018', 
     'พักฟื้นหลังการต่อสู้', 'พักฟื้นและตรวจสอบสภาพร่างกายหลังการต่อสู้ครั้งแรก', 
     'dialogue', false, '{}', NOW(), NOW()),
    
    -- Event 3: Meeting the Mysterious Stranger interactions
    ('88888888-8888-8888-8888-888888888045', '66666666-6666-6666-6666-666666666019', 
     'พบกับบุคคลลึกลับ', 'บุคคลลึกลับปรากฏตัวและเริ่มสนทนา', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888046', '66666666-6666-6666-6666-666666666019', 
     'สอบถามตัวตน', 'ถามเกี่ยวกับตัวตนและจุดประสงค์ของบุคคลลึกลับ', 
     'choice', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888047', '66666666-6666-6666-6666-666666666019', 
     'รับข้อมูลสำคัญ', 'บุคคลลึกลับมอบข้อมูลสำคัญเกี่ยวกับการเดินทางต่อไป', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888048', '66666666-6666-6666-6666-666666666019', 
     'ตัดสินใจเชื่อใจ', 'ตัดสินใจว่าจะเชื่อใจบุคคลลึกลับหรือไม่', 
     'choice', true, '{}', NOW(), NOW()),
    
    -- Event 4: The Ancient Ruins interactions
    ('88888888-8888-8888-8888-888888888049', '66666666-6666-6666-6666-666666666020', 
     'สำรวจซากปรักหักพัง', 'เริ่มสำรวจซากปรักหักพังโบราณ', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888050', '66666666-6666-6666-6666-666666666020', 
     'ค้นพบคำจารึก', 'พบคำจารึกโบราณที่บอกเล่าเรื่องราวเกี่ยวกับ Luminary', 
     'discovery', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888051', '66666666-6666-6666-6666-666666666020', 
     'ไขปริศนาโบราณ', 'พบปริศนาโบราณที่ต้องไขเพื่อดำเนินการต่อ', 
     'puzzle', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888052', '66666666-6666-6666-6666-666666666020', 
     'รับพลังใหม่', 'หลังจากไขปริศนาสำเร็จ ได้รับพลังใหม่จากซากปรักหักพัง', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    -- Event 5: The Crossroads interactions
    ('88888888-8888-8888-8888-888888888053', '66666666-6666-6666-6666-666666666021', 
     'ถึงทางแยกสำคัญ', 'มาถึงทางแยกสำคัญที่ต้องเลือกเส้นทางต่อไป', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888054', '66666666-6666-6666-6666-666666666021', 
     'ปรึกษากับตัวเอง', 'คิดถึงเส้นทางที่เหมาะสมที่สุดสำหรับการเดินทาง', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888055', '66666666-6666-6666-6666-666666666021', 
     'ตรวจสอบเส้นทาง', 'ตรวจสอบข้อมูลเกี่ยวกับแต่ละเส้นทางก่อนตัดสินใจ', 
     'choice', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888056', '66666666-6666-6666-6666-666666666021', 
     'ตัดสินใจเลือกเส้นทาง', 'ตัดสินใจเลือกระหว่างเส้นทางเมืองหรือเส้นทางภูเขา', 
     'choice', true, '{}', NOW(), NOW()),
    
    -- Event 6: The First Town interactions
    ('88888888-8888-8888-8888-888888888057', '66666666-6666-6666-6666-666666666022', 
     'มาถึงเมืองใหม่', 'มาถึงเมืองแรกนอก Cobblestone พบกับบรรยากาศใหม่', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888058', '66666666-6666-6666-6666-666666666022', 
     'พูดคุยกับชาวเมือง', 'พูดคุยกับชาวเมืองเพื่อเก็บข้อมูลเกี่ยวกับสถานการณ์ปัจจุบัน', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888059', '66666666-6666-6666-6666-666666666022', 
     'เยี่ยมชมร้านค้า', 'เยี่ยมชมร้านค้าในเมืองเพื่อซื้ออุปกรณ์และข้อมูล', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888060', '66666666-6666-6666-6666-666666666022', 
     'พักผ่อนที่โรงแรม', 'พักผ่อนที่โรงแรมในเมืองเพื่อเตรียมตัวสำหรับการเดินทางต่อไป', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    -- Event 7: The Mountain Path interactions
    ('88888888-8888-8888-8888-888888888061', '66666666-6666-6666-6666-666666666023', 
     'เริ่มปีนภูเขา', 'เริ่มต้นการเดินทางบนเส้นทางภูเขาที่ยากลำบาก', 
     'dialogue', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888062', '66666666-6666-6666-6666-666666666023', 
     'เผชิญหน้ากับสภาพอากาศ', 'ต้องเผชิญหน้ากับสภาพอากาศที่รุนแรงบนภูเขา', 
     'challenge', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888063', '66666666-6666-6666-6666-666666666023', 
     'พบถ้ำลึกลับ', 'พบถ้ำลึกลับบนภูเขาที่อาจมีสมบัติหรืออันตรายรออยู่', 
     'discovery', true, '{}', NOW(), NOW()),
    
    ('88888888-8888-8888-8888-888888888064', '66666666-6666-6666-6666-666666666023', 
     'ถึงยอดเขา', 'ถึงยอดเขาและได้เห็นทิวทัศน์ที่สวยงามและข้อมูลสำคัญ', 
     'dialogue', true, '{}', NOW(), NOW())
ON CONFLICT (id) DO UPDATE SET
    event_id = EXCLUDED.event_id,
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    interaction_type = EXCLUDED.interaction_type,
    is_required = EXCLUDED.is_required,
    requirements = EXCLUDED.requirements,
    updated_at = NOW();

-- Insert Event Outcomes for Chapter 2
INSERT INTO event_outcomes (id, interaction_id, choice_key, outcome_text, effects, next_event_id, auto_unlocked_locations, auto_unlocked_regions) VALUES
    -- Event 1: Leaving Cobblestone outcomes
    ('88888888-8888-8888-8888-888888888065', '88888888-8888-8888-8888-888888888037', 'default', 
     'Gemma มอบสร้อยคอที่มีพลังป้องกันพิเศษและให้กำลังใจ Luminary ในการเดินทาง', 
     '{"items": [{"id": "55555555-5555-5555-5555-555555555010", "quantity": 1}], "experience": 25, "relationship": {"Gemma": 8}}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888066', '88888888-8888-8888-8888-888888888038', 'default', 
     'Chalky มอบดาบเล่มพิเศษและเตือนถึงศัตรูที่อาจตามมาทำร้าย', 
     '{"items": [{"id": "55555555-5555-5555-5555-555555555011", "quantity": 1}], "experience": 30, "relationship": {"Chalky": 10}}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888067', '88888888-8888-8888-8888-888888888039', 'default', 
     'ผู้เฒ่ามอบคำพยานามและทำนายว่า Luminary จะพบกับการทดสอบที่ยิ่งใหญ่', 
     '{"experience": 35, "relationship": {"Elder": 8}}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888068', '88888888-8888-8888-8888-888888888040', 'leave_now', 
     'Luminary ตัดสินใจออกเดินทางทันที พร้อมกับความมุ่งมั่นและความกล้าหาญ', 
     '{"experience": 40, "gold": 20}', '66666666-6666-6666-6666-666666666018', '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888069', '88888888-8888-8888-8888-888888888040', 'say_goodbye', 
     'Luminary ไปลาทุกคนในหมู่บ้านก่อนออกเดินทาง ได้รับของขวัญและคำอำลาเพิ่มเติม', 
     '{"experience": 45, "gold": 30, "relationship": {"Villagers": 8}}', '66666666-6666-6666-6666-666666666018', '{}', '{}'),
    
    -- Event 2: The First Battle outcomes
    ('88888888-8888-8888-8888-888888888070', '88888888-8888-8888-8888-888888888041', 'victory', 
     'Luminary เอาชนะสัตว์ป่าได้สำเร็จ ได้รับประสบการณ์การต่อสู้ครั้งแรก', 
     '{"experience": 50, "gold": 15}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888071', '88888888-8888-8888-8888-888888888042', 'use_power', 
     'Luminary ใช้พลังใหม่ได้สำเร็จ รู้สึกถึงพลังที่เพิ่มขึ้นในร่างกาย', 
     '{"experience": 60, "relationship": {"Self": 5}}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888072', '88888888-8888-8888-8888-888888888042', 'save_power', 
     'Luminary ตัดสินใจประหยัดพลังไว้ใช้ในเวลาที่จำเป็นจริงๆ', 
     '{"experience": 40, "relationship": {"Self": 3}}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888073', '88888888-8888-8888-8888-888888888043', 'default', 
     'จากการต่อสู้ครั้งแรก Luminary เรียนรู้พื้นฐานการต่อสู้และการใช้พลัง', 
     '{"experience": 55}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888074', '88888888-8888-8888-8888-888888888044', 'rest', 
     'การพักฟื้นทำให้ Luminary ฟื้นตัวและพร้อมสำหรับการเดินทางต่อไป', 
     '{"experience": 20, "relationship": {"Self": 2}}', '66666666-6666-6666-6666-666666666019', '{}', '{}'),
    
    -- Event 3: Meeting the Mysterious Stranger outcomes
    ('88888888-8888-8888-8888-888888888075', '88888888-8888-8888-8888-888888888045', 'default', 
     'บุคคลลึกลับแนะนำตัวเองว่าชื่อ Veronica และมีความรู้เกี่ยวกับ Luminary', 
     '{"experience": 30}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888076', '88888888-8888-8888-8888-888888888046', 'ask_directly', 
     'Luminary ถาม Veronica โดยตรงเกี่ยวกับตัวตนและวัตถุประสงค์', 
     '{"experience": 35, "relationship": {"Veronica": 3}}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888077', '88888888-8888-8888-8888-888888888046', 'observe_first', 
     'Luminary สังเกตพฤติกรรมของ Veronica ก่อนตัดสินใจถามคำถาม', 
     '{"experience": 40, "relationship": {"Veronica": 5}}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888078', '88888888-8888-8888-8888-888888888047', 'default', 
     'Veronica มอบแผนที่และข้อมูลเกี่ยวกับซากปรักหักพังโบราณที่น่าสนใจ', 
     '{"items": [{"id": "55555555-5555-5555-5555-555555555012", "quantity": 1}], "experience": 45, "relationship": {"Veronica": 7}}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888079', '88888888-8888-8888-8888-888888888048', 'trust', 
     'Luminary ตัดสินใจเชื่อใจ Veronica และยอมรับความช่วยเหลือ', 
     '{"experience": 50, "relationship": {"Veronica": 10}}', '66666666-6666-6666-6666-666666666020', '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888080', '88888888-8888-8888-8888-888888888048', 'distrust', 
     'Luminary ระแวง Veronica แต่ก็ยังรับข้อมูลที่เป็นประโยชน์', 
     '{"experience": 35, "relationship": {"Veronica": 2}}', '66666666-6666-6666-6666-666666666020', '{}', '{}'),
    
    -- Event 4: The Ancient Ruins outcomes
    ('88888888-8888-8888-8888-888888888081', '88888888-8888-8888-8888-888888888049', 'default', 
     'การสำรวจซากปรักหักพังเปิดเผยความลับเกี่ยวกับอดีตของ Luminary', 
     '{"experience": 40}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888082', '88888888-8888-8888-8888-888888888050', 'default', 
     'คำจารึกโบราณบอกเล่าเรื่องราวเกี่ยวกับ Luminary ในอดีตและพลังที่แท้จริง', 
     '{"experience": 60, "relationship": {"Self": 8}}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888083', '88888888-8888-8888-8888-888888888051', 'solve_puzzle', 
     'Luminary ไขปริศนาโบราณได้สำเร็จ ประตูลึกลับเปิดออก', 
     '{"experience": 80, "gold": 40}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888084', '88888888-8888-8888-8888-888888888051', 'skip_puzzle', 
     'Luminary ตัดสินใจข้ามปริศนาและหาทางอื่นเข้าไปแทน', 
     '{"experience": 30}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888085', '88888888-8888-8888-8888-888888888052', 'default', 
     'ได้รับพลังใหม่ "Heal" ที่สามารถรักษาตัวเองและผู้อื่นได้', 
     '{"experience": 100, "relationship": {"Self": 10}}', '66666666-6666-6666-6666-666666666021', '{}', '{}'),
    
    -- Event 5: The Crossroads outcomes
    ('88888888-8888-8888-8888-888888888086', '88888888-8888-8888-8888-888888888053', 'default', 
     'ถึงทางแยกสำคัญที่ต้องเลือกระหว่างเส้นทางที่ปลอดภัยแต่น่าเบื่อกับเส้นทางที่อันตรายแต่น่าตื่นเต้น', 
     '{"experience": 25}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888087', '88888888-8888-8888-8888-888888888054', 'default', 
     'การคิดถึงเส้นทางทำให้ Luminary เข้าใจตัวเองและเป้าหมายในการเดินทางมากขึ้น', 
     '{"experience": 35, "relationship": {"Self": 5}}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888088', '88888888-8888-8888-8888-888888888055', 'check_town', 
     'ตรวจสอบข้อมูลเกี่ยวกับเส้นทางเมือง พบว่ามีคนที่คุ้นเคยและข้อมูลสำคัญรออยู่', 
     '{"experience": 30}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888089', '88888888-8888-8888-8888-888888888055', 'check_mountains', 
     'ตรวจสอบข้อมูลเกี่ยวกับเส้นทางภูเขา พบว่ามีสมบัติและการทดสอบที่ยิ่งใหญ่รออยู่', 
     '{"experience": 30}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888090', '88888888-8888-8888-8888-888888888056', 'go_to_town', 
     'Luminary ตัดสินใจเลือกเส้นทางเมืองที่ปลอดภัยและเต็มไปด้วยข้อมูล', 
     '{"experience": 40, "gold": 20}', '66666666-6666-6666-6666-666666666022', '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888091', '88888888-8888-8888-8888-888888888056', 'go_to_mountains', 
     'Luminary ตัดสินใจเลือกเส้นทางภูเขาที่อันตรายแต่เต็มไปด้วยความท้าทาย', 
     '{"experience": 50, "gold": 30}', '66666666-6666-6666-6666-666666666023', '{}', '{}'),
    
    -- Event 6: The First Town outcomes
    ('88888888-8888-8888-8888-888888888092', '88888888-8888-8888-8888-888888888057', 'default', 
     'มาถึงเมือง Heliodor ที่มีชีวิตชีวาและเต็มไปด้วยผู้คน', 
     '{"experience": 45}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888093', '88888888-8888-8888-8888-888888888058', 'talk_to_people', 
     'การพูดคุยกับชาวเมืองทำให้ได้ข้อมูลเกี่ยวกับสถานการณ์การเมืองและศัตรูของ Luminary', 
     '{"experience": 55, "relationship": {"Townsfolk": 5}}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888094', '88888888-8888-8888-8888-888888888059', 'buy_equipment', 
     'ซื้ออุปกรณ์ใหม่และข้อมูลสำคัญจากร้านค้าในเมือง', 
     '{"items": [{"id": "55555555-5555-5555-5555-555555555013", "quantity": 1}], "experience": 40, "gold": -50}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888095', '88888888-8888-8888-8888-888888888060', 'rest_at_inn', 
     'การพักผ่อนที่โรงแรมทำให้ Luminary ฟื้นตัวและพร้อมสำหรับการเดินทางต่อไป', 
     '{"experience": 30, "relationship": {"Self": 3}, "unlock_events": ["66666666-6666-6666-6666-666666666024"]}', NULL, '{}', '{}'),
    
    -- Event 7: The Mountain Path outcomes
    ('88888888-8888-8888-8888-888888888096', '88888888-8888-8888-8888-888888888061', 'default', 
     'เริ่มต้นการเดินทางบนเส้นทางภูเขาที่ยากลำบากแต่เต็มไปด้วยความท้าทาย', 
     '{"experience": 50}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888097', '88888888-8888-8888-8888-888888888062', 'endure_weather', 
     'Luminary ทนต่อสภาพอากาศรุนแรงได้สำเร็จ แสดงให้เห็นถึงความแข็งแกร่ง', 
     '{"experience": 70, "relationship": {"Self": 8}}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888098', '88888888-8888-8888-8888-888888888063', 'explore_cave', 
     'การสำรวจถ้ำลึกลับพบกับสมบัติโบราณและข้อมูลสำคัญ', 
     '{"items": [{"id": "55555555-5555-5555-5555-555555555014", "quantity": 1}], "experience": 80, "gold": 60}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888099', '88888888-8888-8888-8888-888888888063', 'avoid_cave', 
     'Luminary ตัดสินใจหลีกเลี่ยงถ้ำลึกลับและหาทางอื่นขึ้นภูเขาต่อ', 
     '{"experience": 40}', NULL, '{}', '{}'),
    
    ('88888888-8888-8888-8888-888888888100', '88888888-8888-8888-8888-888888888064', 'default', 
     'ถึงยอดเขาและได้เห็นทิวทัศน์ที่สวยงาม พบว่ามีเมืองที่น่าสนใจอยู่ใกล้ๆ', 
     '{"experience": 90, "relationship": {"Self": 10}, "unlock_events": ["66666666-6666-6666-6666-666666666025"], "unlock_chapters": ["33333333-3333-3333-3333-333333333003"]}', NULL, '{"22222222-2222-2222-2222-222222222019", "22222222-2222-2222-2222-222222222020"}', '{"11111111-1111-1111-1111-111111111003"}')
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
SELECT 'Chapter 2: The Journey Begins - Story data seeded successfully!' as message;
