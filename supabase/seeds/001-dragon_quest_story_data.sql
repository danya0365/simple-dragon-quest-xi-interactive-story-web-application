-- Dragon Quest XI Story Data Seed (FIXED VERSION)
-- Created: 2025-09-23
-- Author: Marosdee Uma
-- Description: Fixed sample story data for Dragon Quest XI Interactive Story (Prison Arc)
-- Fixed: Event progression logic and proper sequential unlocking

-- Insert World Regions (Same as original)
INSERT INTO public.world_regions (id, name, description, image_url, unlock_requirements, display_order, is_initial_user_progress) VALUES
('11111111-1111-1111-1111-111111111001', 'Cobblestone', 'หมู่บ้านเล็ก ๆ ที่เงียบสงบ บ้านเกิดของ Hero', '/images/regions/cobblestone.svg', '{}', 1, true),
('11111111-1111-1111-1111-111111111002', 'Heliodor', 'เมืองหลวงของอาณาจักร Heliodor ที่ยิ่งใหญ่', '/images/regions/heliodor.svg', '{"level": 2, "completed_chapters": ["33333333-3333-3333-3333-333333333001"]}', 2, false),
('11111111-1111-1111-1111-111111111003', 'Heliodor Dungeons', 'คุกใต้ดินของ Heliodor ที่มืดมิด', '/images/regions/dungeons.svg', '{"level": 2, "completed_chapters": ["33333333-3333-3333-3333-333333333001"], "flags": {"reached_heliodor": true}}', 3, false);

-- Insert Locations (Same as original)
INSERT INTO public.locations (id, world_region_id, name, description, location_type, unlock_requirements, display_order, is_initial_user_progress) VALUES
-- Cobblestone locations
('22222222-2222-2222-2222-222222222001', '11111111-1111-1111-1111-111111111001', 'Hero''s House', 'บ้านของ Hero และ Grandpa', 'house', '{}', 1, true),
('22222222-2222-2222-2222-222222222002', '11111111-1111-1111-1111-111111111001', 'Village Square', 'จัตุรัสกลางหมู่บ้าน Cobblestone', 'town', '{}', 2, true),
('22222222-2222-2222-2222-222222222003', '11111111-1111-1111-1111-111111111001', 'Sacred Tree', 'ต้นไม้ศักดิ์สิทธิ์ของหมู่บ้าน', 'landmark', '{"completed_events": ["66666666-6666-6666-6666-666666666001"]}', 3, false),

-- Heliodor locations  
('22222222-2222-2222-2222-222222222004', '11111111-1111-1111-1111-111111111002', 'Heliodor Castle', 'ปราสาทของกษัตริย์ Carnelian', 'castle', '{"level": 3, "completed_events": ["66666666-6666-6666-6666-666666666003"]}', 1, false),
('22222222-2222-2222-2222-222222222005', '11111111-1111-1111-1111-111111111002', 'Heliodor Town', 'เมืองใหญ่ที่คึกคัก', 'town', '{"level": 2, "completed_events": ["66666666-6666-6666-6666-666666666003"]}', 2, false),

-- Dungeon locations
('22222222-2222-2222-2222-222222222006', '11111111-1111-1111-1111-111111111003', 'Prison Cell Block A', 'ห้องขังส่วน A ของคุก Heliodor', 'dungeon', '{"level": 2, "completed_events": ["66666666-6666-6666-6666-666666666003"]}', 1, false),
('22222222-2222-2222-2222-222222222007', '11111111-1111-1111-1111-111111111003', 'Prison Cell Block B', 'ห้องขังส่วน B ที่มี Erik อยู่', 'dungeon', '{"level": 2, "completed_events": ["66666666-6666-6666-6666-666666666004"]}', 2, false);

-- Insert Story Chapters (Same as original)
INSERT INTO public.story_chapters (id, chapter_number, title, description, unlock_requirements, display_order, is_initial_user_progress) VALUES
('33333333-3333-3333-3333-333333333001', 1, 'The Darkspawn', 'จุดเริ่มต้นของการผจญภัย เมื่อ Hero ถูกเรียกว่า Darkspawn', '{}', 1, true),
('33333333-3333-3333-3333-333333333002', 2, 'The Dungeons of Heliodor', 'Hero ถูกจับและขังในคุก Heliodor พบกับ Erik', '{"level": 1, "completed_chapters": ["33333333-3333-3333-3333-333333333001"], "flags": {"ceremony_completed": true}}', 2, false),
('33333333-3333-3333-3333-333333333003', 3, 'The Great Escape', 'การหลบหนีจากคุก Heliodor พร้อมกับ Erik', '{"level": 2, "completed_chapters": ["33333333-3333-3333-3333-333333333002"], "flags": {"met_erik": true}}', 3, false);

-- Insert Characters (Same as original)
INSERT INTO public.characters (id, name, description, character_type, avatar_url, stats, abilities, is_joinable, is_initial_user_progress) VALUES
('44444444-4444-4444-4444-444444444001', 'Hero', 'ตัวเอกของเรื่อง ผู้ถูกเรียกว่า Darkspawn', 'party_member', '/images/characters/hero.svg', 
 '{"hp": 100, "mp": 50, "level": 1, "attack": 15, "defense": 10}', 
 '["Sword Strike", "Heal"]', true, true),
 
('44444444-4444-4444-4444-444444444002', 'Erik', 'โจรหนุ่มที่ถูกขังในคุก Heliodor เชี่ยวชาญด้านการขโมยและมีดโยน', 'party_member', '/images/characters/erik.svg',
 '{"hp": 80, "mp": 30, "level": 1, "attack": 18, "defense": 8}',
 '["Dagger Throw", "Steal", "Critical Hit"]', true, false),

('44444444-4444-4444-4444-444444444003', 'Grandpa', 'ปู่ของ Hero ผู้เลี้ยงดู Hero มาตั้งแต่เด็ก', 'npc', '/images/characters/grandpa.svg',
 '{"hp": 50, "mp": 20, "level": 1}', '[]', false, false),
 
('44444444-4444-4444-4444-444444444004', 'King Carnelian', 'กษัตริย์แห่ง Heliodor ผู้เชื่อว่า Hero คือ Darkspawn', 'npc', '/images/characters/king.svg',
 '{"hp": 200, "mp": 100, "level": 10}', '[]', false, false),

('44444444-4444-4444-4444-444444444005', 'Prison Guard', 'ยามคุก Heliodor', 'npc', '/images/characters/guard.svg',
 '{"hp": 60, "mp": 10, "level": 3}', '[]', false, false);

-- Insert Items (Same as original)
INSERT INTO public.items (id, name, description, item_type, rarity, stats, effects, image_url, is_initial_user_progress) VALUES
('55555555-5555-5555-5555-555555555001', 'Rusty Sword', 'ดาบเก่า ๆ ที่เป็นสนิม', 'weapon', 'common', 
 '{"attack": 5}', '{}', '/images/items/rusty_sword.svg', true),
 
('55555555-5555-5555-5555-555555555002', 'Prison Clothes', 'เสื้อผ้านักโทษ', 'armor', 'common',
 '{"defense": 2}', '{}', '/images/items/prison_clothes.svg', false),
 
('55555555-5555-5555-5555-555555555003', 'Medicinal Herb', 'สมุนไพรรักษา ฟื้นฟู HP', 'consumable', 'common',
 '{}', '{"heal": 30}', '/images/items/herb.svg', false),
 
('55555555-5555-5555-5555-555555555004', 'Prison Key', 'กุญแจคุก สำหรับปลดล็อคประตูคุก', 'key_item', 'rare',
 '{}', '{"unlock": "prison_door"}', '/images/items/key.svg', false),
 
('55555555-5555-5555-5555-555555555005', 'Erik''s Dagger', 'มีดโยนของ Erik อาวุธที่คมกริบ', 'weapon', 'uncommon',
 '{"attack": 12, "critical": 15}', '{}', '/images/items/dagger.svg', false);

-- Insert Story Events (Same as original)
INSERT INTO public.story_events (id, chapter_id, location_id, title, description, event_type, unlock_requirements, display_order, is_initial_user_progress) VALUES
-- Chapter 1 events
('66666666-6666-6666-6666-666666666001', '33333333-3333-3333-3333-333333333001', '22222222-2222-2222-2222-222222222001', 
 'Morning at Home', 'เช้าวันหนึ่งที่บ้าน Hero ตื่นขึ้นมาและพูดคุยกับปู่', 'dialogue', '{}', 1, true),

('66666666-6666-6666-6666-666666666002', '33333333-3333-3333-3333-333333333001', '22222222-2222-2222-2222-222222222003',
 'The Sacred Tree Ceremony', 'พิธีกรรมที่ต้นไม้ศักดิ์สิทธิ์ เหตุการณ์ที่เปลี่ยนชีวิต Hero', 'story', '{"completed_events": ["66666666-6666-6666-6666-666666666001"]}', 2, false),

-- Chapter 2 events  
('66666666-6666-6666-6666-666666666003', '33333333-3333-3333-3333-333333333002', '22222222-2222-2222-2222-222222222006',
 'Imprisoned', 'Hero ถูกจับและขังในคุก Heliodor', 'story', '{"completed_chapters": ["33333333-3333-3333-3333-333333333001"], "flags": {"ceremony_completed": true}}', 1, false),

('66666666-6666-6666-6666-666666666004', '33333333-3333-3333-3333-333333333002', '22222222-2222-2222-2222-222222222007',
 'Meeting Erik', 'Hero พบกับ Erik ในคุก และเริ่มวางแผนหลบหนี', 'dialogue', '{"completed_events": ["66666666-6666-6666-6666-666666666003"]}', 2, false),

-- Chapter 3 events
('66666666-6666-6666-6666-666666666005', '33333333-3333-3333-3333-333333333003', '22222222-2222-2222-2222-222222222007',
 'Planning the Escape', 'วางแผนการหลบหนีจากคุกพร้อมกับ Erik', 'choice', '{"completed_events": ["66666666-6666-6666-6666-666666666004"], "flags": {"erik_trust": 5}}', 1, false),

('66666666-6666-6666-6666-666666666006', '33333333-3333-3333-3333-333333333003', '22222222-2222-2222-2222-222222222006',
 'The Great Escape', 'การหลบหนีที่ยิ่งใหญ่จากคุก Heliodor', 'story', '{"completed_events": ["66666666-6666-6666-6666-666666666005"]}', 2, false);

-- Insert Event Interactions (Same as original)
INSERT INTO public.event_interactions (id, event_id, interaction_type, title, description, dialogue_text, character_speaker, choices, requirements, display_order) VALUES
-- Morning at Home interactions
('77777777-7777-7777-7777-777777777001', '66666666-6666-6666-6666-666666666001', 'talk', 'Talk to Grandpa', 
 'พูดคุยกับปู่เกี่ยวกับวันนี้', 
 'เช้าดี Hero วันนี้เป็นวันสำคัญนะ เจ้าต้องไปที่ต้นไม้ศักดิ์สิทธิ์', 'Grandpa', '[]', '{}', 1),

('77777777-7777-7777-7777-777777777002', '66666666-6666-6666-6666-666666666001', 'examine', 'Check Equipment',
 'ตรวจสอบอุปกรณ์ของตัวเอง', '', '', '[]', '{}', 2),

-- The Sacred Tree Ceremony interactions
('77777777-7777-7777-7777-777777777007', '66666666-6666-6666-6666-666666666002', 'story', 'Sacred Tree Ritual',
 'พิธีกรรมที่ต้นไม้ศักดิ์สิทธิ์', 'Hero ทำพิธีกรรมที่ต้นไม้ศักดิ์สิทธิ์... แสงสว่างล้อมรอบ... แต่แล้วก็เกิดเหตุการณ์ไม่คาดฝัน!', 'Narrator', '[]', '{}', 1),

('77777777-7777-7777-7777-777777777008', '66666666-6666-6666-6666-666666666002', 'examine', 'Examine the Tree',
 'ตรวจสอบต้นไม้ศักดิ์สิทธิ์', '', '', '[]', '{}', 2),

-- Imprisoned interactions
('77777777-7777-7777-7777-777777777009', '66666666-6666-6666-6666-666666666003', 'story', 'Waking Up in Prison',
 'ตื่นขึ้นมาในคุก', 'Hero ตื่นขึ้นมาในห้องขังที่มืดมิด... ไม่รู้ว่าเกิดอะไรขึ้น', 'Narrator', '[]', '{}', 1),

('77777777-7777-7777-7777-777777777010', '66666666-6666-6666-6666-666666666003', 'examine', 'Examine Cell',
 'ตรวจสอบห้องขัง', '', '', '[]', '{}', 2),

-- Meeting Erik interactions  
('77777777-7777-7777-7777-777777777003', '66666666-6666-6666-6666-666666666004', 'talk', 'Talk to Erik',
 'พูดคุยกับ Erik ในคุก',
 'เฮ้ นายใหม่เหรอ? ข้าชื่อ Erik... ข้าอยู่ที่นี่มานานแล้ว', 'Erik', '[]', '{}', 1),

('77777777-7777-7777-7777-777777777004', '66666666-6666-6666-6666-666666666004', 'choose', 'Respond to Erik',
 'เลือกการตอบสนองต่อ Erik',
 'นายจะตอบ Erik ว่าอย่างไร?', '',
 '[
   {"id": "friendly", "text": "ยินดีที่ได้รู้จัก ฉันชื่อ Hero", "type": "friendly"},
   {"id": "suspicious", "text": "ทำไมนายถึงอยู่ที่นี่?", "type": "suspicious"},
   {"id": "silent", "text": "เงียบไม่พูดอะไร", "type": "neutral"}
 ]', '{}', 2),

-- Planning Escape interactions
('77777777-7777-7777-7777-777777777005', '66666666-6666-6666-6666-666666666005', 'talk', 'Discuss Escape Plan',
 'หารือแผนการหลบหนีกับ Erik',
 'ฟังนะ Hero ข้ามีแผนที่จะหนีออกจากที่นี่ แต่ต้องใช้คนสองคน', 'Erik', '[]', '{}', 1),

('77777777-7777-7777-7777-777777777006', '66666666-6666-6666-6666-666666666005', 'choose', 'Choose Escape Route',
 'เลือกเส้นทางการหลบหนี',
 'เราจะเลือกเส้นทางไหนในการหลบหนี?', '',
 '[
   {"id": "sewers", "text": "ผ่านท่อระบายน้ำ", "type": "stealth"},
   {"id": "main_gate", "text": "ผ่านประตูหลัก", "type": "bold"},
   {"id": "window", "text": "ผ่านหน้าต่าง", "type": "risky"}
 ]', '{}', 2),

-- The Great Escape interactions
('77777777-7777-7777-7777-777777777011', '66666666-6666-6666-6666-666666666006', 'story', 'Escape Execution',
 'การปฏิบัติการหลบหนี', 'Hero และ Erik ทำการหลบหนีตามแผนที่วางไว้...', 'Narrator', '[]', '{}', 1),

('77777777-7777-7777-7777-777777777012', '66666666-6666-6666-6666-666666666006', 'examine', 'Check Surroundings',
 'ตรวจสอบสภาพแวดล้อมหลังหลบหนี', '', '', '[]', '{}', 2);

-- FIXED: Insert Event Outcomes with proper progression logic
INSERT INTO public.event_outcomes (id, interaction_id, choice_key, outcome_type, title, description, effects, next_event_id) VALUES

-- === MORNING AT HOME EVENT OUTCOMES ===
-- FIXED: Only one interaction should unlock the Sacred Tree event
-- Talk to Grandpa - This is the MAIN trigger for going to Sacred Tree
('88888888-8888-8888-8888-888888888007', '77777777-7777-7777-7777-777777777001', 'default', 'story',
 'Grandpa''s Important Message', 'ปู่บอกให้ Hero ไปที่ต้นไม้ศักดิ์สิทธิ์เพื่อทำพิธีกรรม',
 '{"unlock_events": ["66666666-6666-6666-6666-666666666002"], "unlock_locations": ["22222222-2222-2222-2222-222222222003"]}', NULL),

-- Check Equipment - This only gives starting equipment, NO event unlock
('88888888-8888-8888-8888-888888888008', '77777777-7777-7777-7777-777777777002', 'default', 'story',
 'Equipment Ready', 'Hero ได้รับอุปกรณ์พื้นฐานสำหรับการเดินทาง',
 '{"items": [{"id": "55555555-5555-5555-5555-555555555001", "quantity": 1}]}', NULL),

-- === SACRED TREE CEREMONY EVENT OUTCOMES ===
-- Sacred Tree Ritual - Main story progression, unlocks Chapter 2 and prison
('88888888-8888-8888-8888-888888888011', '77777777-7777-7777-7777-777777777007', 'default', 'story',
 'The Ceremony Changes Everything', 'พิธีกรรมเสร็จสิ้น Hero ถูกมองว่าเป็น Darkspawn!',
 '{
   "unlock_events": ["66666666-6666-6666-6666-666666666003"], 
   "unlock_chapters": ["33333333-3333-3333-3333-333333333002"],
   "unlock_locations": ["22222222-2222-2222-2222-222222222006"],
   "unlock_regions": ["11111111-1111-1111-1111-111111111003"]
 }', '66666666-6666-6666-6666-666666666003'),

-- Examine Tree - Minor exploration, no major unlock
('88888888-8888-8888-8888-888888888012', '77777777-7777-7777-7777-777777777008', 'default', 'story',
 'Ancient Tree Knowledge', 'Hero เรียนรู้เกี่ยวกับต้นไม้ศักดิ์สิทธิ์',
 '{"experience": 25}', NULL),

-- === IMPRISONED EVENT OUTCOMES ===
-- Prison Awakening - Story progression
('88888888-8888-8888-8888-888888888013', '77777777-7777-7777-7777-777777777009', 'default', 'story',
 'Awakening in Darkness', 'Hero ตื่นขึ้นในคุก เริ่มต้นบทใหม่',
 '{"unlock_events": ["66666666-6666-6666-6666-666666666004"], "unlock_locations": ["22222222-2222-2222-2222-222222222007"]}', '66666666-6666-6666-6666-666666666004'),

-- Cell Examination - Minor exploration
('88888888-8888-8888-8888-888888888014', '77777777-7777-7777-7777-777777777010', 'default', 'story',
 'Cold Prison Reality', 'การตรวจสอบห้องขังทำให้เข้าใจสถานการณ์',
 '{"experience": 10}', NULL),

-- === MEETING ERIK EVENT OUTCOMES ===
-- Talk to Erik - Introduction only
('88888888-8888-8888-8888-888888888009', '77777777-7777-7777-7777-777777777003', 'default', 'story',
 'Erik''s Introduction', 'Erik แนะนำตัวเองให้ Hero รู้จัก',
 '{"relationship": {"erik": 5}}', NULL),

-- Erik Response Choices - These determine relationship level and unlock escape planning
('88888888-8888-8888-8888-888888888001', '77777777-7777-7777-7777-777777777004', 'friendly', 'story',
 'Erik Appreciates Friendliness', 'Erik รู้สึกประทับใจในความเป็นมิตรของ Hero',
 '{
   "relationship": {"erik": 15}, 
   "unlock_events": ["66666666-6666-6666-6666-666666666005"],
   "unlock_chapters": ["33333333-3333-3333-3333-333333333003"]
 }', NULL),

('88888888-8888-8888-8888-888888888002', '77777777-7777-7777-7777-777777777004', 'suspicious', 'story',
 'Erik Explains His Past', 'Erik อธิบายเหตุผลที่อยู่ในคุก ได้รับความไว้วางใจ',
 '{
   "relationship": {"erik": 10}, 
   "unlock_events": ["66666666-6666-6666-6666-666666666005"],
   "unlock_chapters": ["33333333-3333-3333-3333-333333333003"]
 }', NULL),

('88888888-8888-8888-8888-888888888003', '77777777-7777-7777-7777-777777777004', 'silent', 'story',
 'Erik Respects Your Silence', 'Erik เข้าใจและเคารพท่าทีของ Hero',
 '{
   "relationship": {"erik": 8}, 
   "unlock_events": ["66666666-6666-6666-6666-666666666005"],
   "unlock_chapters": ["33333333-3333-3333-3333-333333333003"]
 }', NULL),

-- === PLANNING ESCAPE EVENT OUTCOMES ===
-- Discuss Escape Plan - Setup for the actual escape choice
('88888888-8888-8888-8888-888888888010', '77777777-7777-7777-7777-777777777005', 'default', 'story',
 'Escape Plan Formation', 'Erik และ Hero หารือแผนการหลบหนี',
 '{"relationship": {"erik": 5}}', NULL),

-- Escape Route Choices - These determine how escape happens and rewards
('88888888-8888-8888-8888-888888888004', '77777777-7777-7777-7777-777777777006', 'sewers', 'party_join',
 'Successful Stealth Escape', 'หลบหนีอย่างเงียบ ๆ ผ่านท่อระบายน้ำ Erik เข้าร่วมทีม!', 
 '{
   "party_join": "44444444-4444-4444-4444-444444444002", 
   "items": [{"id": "55555555-5555-5555-5555-555555555005", "quantity": 1}], 
   "unlock_events": ["66666666-6666-6666-6666-666666666006"],
   "relationship": {"erik": 10}
 }', '66666666-6666-6666-6666-666666666006'),

('88888888-8888-8888-8888-888888888005', '77777777-7777-7777-7777-777777777006', 'main_gate', 'party_join',
 'Bold Escape Through Main Gate', 'หลบหนีแบบกล้าหาญผ่านประตูหลัก Erik เข้าร่วมทีม!',
 '{
   "party_join": "44444444-4444-4444-4444-444444444002", 
   "items": [{"id": "55555555-5555-5555-5555-555555555003", "quantity": 2}], 
   "unlock_events": ["66666666-6666-6666-6666-666666666006"],
   "relationship": {"erik": 12}
 }', '66666666-6666-6666-6666-666666666006'),

('88888888-8888-8888-8888-888888888006', '77777777-7777-7777-7777-777777777006', 'window', 'party_join',
 'Risky Window Escape', 'หลบหนีแบบเสี่ยงภัยผ่านหน้าต่าง Erik เข้าร่วมทีม!',
 '{
   "party_join": "44444444-4444-4444-4444-444444444002", 
   "items": [{"id": "55555555-5555-5555-5555-555555555004", "quantity": 1}], 
   "unlock_events": ["66666666-6666-6666-6666-666666666006"],
   "relationship": {"erik": 8}
 }', '66666666-6666-6666-6666-666666666006'),

-- === THE GREAT ESCAPE EVENT OUTCOMES ===
-- Escape Execution - Final escape sequence, unlocks the world
('88888888-8888-8888-8888-888888888015', '77777777-7777-7777-7777-777777777011', 'default', 'story',
 'Freedom at Last', 'การหลบหนีสำเร็จ! Hero และ Erik ได้อิสรภาพ',
 '{
   "unlock_locations": ["22222222-2222-2222-2222-222222222004", "22222222-2222-2222-2222-222222222005"], 
   "unlock_regions": ["11111111-1111-1111-1111-111111111002"],
   "experience": 100,
   "relationship": {"erik": 5}
 }', NULL),

-- Check Surroundings - Exploration after escape
('88888888-8888-8888-8888-888888888016', '77777777-7777-7777-7777-777777777012', 'default', 'story',
 'New Horizons', 'ได้รับอิสรภาพและเห็นโลกกว้าง',
 '{
   "unlock_locations": ["22222222-2222-2222-2222-222222222004", "22222222-2222-2222-2222-222222222005"], 
   "unlock_regions": ["11111111-1111-1111-1111-111111111002"],
   "experience": 50
 }', NULL);