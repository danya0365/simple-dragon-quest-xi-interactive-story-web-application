-- Dragon Quest XI Story Data Seed
-- Created: 2025-09-23
-- Author: Marosdee Uma
-- Description: Sample story data for Dragon Quest XI Interactive Story (Prison Arc)

-- Insert World Map regions
INSERT INTO public.world_map (id, name, description, image_url, is_unlocked, display_order) VALUES
('11111111-1111-1111-1111-111111111001', 'Cobblestone', 'หมู่บ้านเล็ก ๆ ที่เงียบสงบ บ้านเกิดของ Hero', '/images/regions/cobblestone.jpg', true, 1),
('11111111-1111-1111-1111-111111111002', 'Heliodor', 'เมืองหลวงของอาณาจักร Heliodor ที่ยิ่งใหญ่', '/images/regions/heliodor.jpg', false, 2),
('11111111-1111-1111-1111-111111111003', 'Heliodor Dungeons', 'คุกใต้ดินของ Heliodor ที่มืดมิด', '/images/regions/dungeons.jpg', false, 3);

-- Insert Locations
INSERT INTO public.locations (id, world_map_id, name, description, location_type, is_unlocked, display_order) VALUES
-- Cobblestone locations
('22222222-2222-2222-2222-222222222001', '11111111-1111-1111-1111-111111111001', 'Hero''s House', 'บ้านของ Hero และ Grandpa', 'house', true, 1),
('22222222-2222-2222-2222-222222222002', '11111111-1111-1111-1111-111111111001', 'Village Square', 'จัตุรัสกลางหมู่บ้าน Cobblestone', 'town', true, 2),
('22222222-2222-2222-2222-222222222003', '11111111-1111-1111-1111-111111111001', 'Sacred Tree', 'ต้นไม้ศักดิ์สิทธิ์ของหมู่บ้าน', 'landmark', false, 3),

-- Heliodor locations  
('22222222-2222-2222-2222-222222222004', '11111111-1111-1111-1111-111111111002', 'Heliodor Castle', 'ปราสาทของกษัตริย์ Carnelian', 'castle', false, 1),
('22222222-2222-2222-2222-222222222005', '11111111-1111-1111-1111-111111111002', 'Heliodor Town', 'เมืองใหญ่ที่คึกคัก', 'town', false, 2),

-- Dungeon locations
('22222222-2222-2222-2222-222222222006', '11111111-1111-1111-1111-111111111003', 'Prison Cell Block A', 'ห้องขังส่วน A ของคุก Heliodor', 'dungeon', false, 1),
('22222222-2222-2222-2222-222222222007', '11111111-1111-1111-1111-111111111003', 'Prison Cell Block B', 'ห้องขังส่วน B ที่มี Erik อยู่', 'dungeon', false, 2);

-- Insert Story Chapters
INSERT INTO public.story_chapters (id, chapter_number, title, description, is_unlocked, display_order) VALUES
('33333333-3333-3333-3333-333333333001', 1, 'The Darkspawn', 'จุดเริ่มต้นของการผจญภัย เมื่อ Hero ถูกเรียกว่า Darkspawn', true, 1),
('33333333-3333-3333-3333-333333333002', 2, 'The Dungeons of Heliodor', 'Hero ถูกจับและขังในคุก Heliodor พบกับ Erik', false, 2),
('33333333-3333-3333-3333-333333333003', 3, 'The Great Escape', 'การหลบหนีจากคุก Heliodor พร้อมกับ Erik', false, 3);

-- Insert Characters
INSERT INTO public.characters (id, name, description, character_type, avatar_url, stats, abilities, is_party_member) VALUES
-- Party members
('44444444-4444-4444-4444-444444444001', 'Hero', 'ตัวเอกของเรื่อง ผู้ถูกเรียกว่า Darkspawn', 'party_member', '/images/characters/hero.jpg', 
 '{"hp": 100, "mp": 50, "level": 1, "attack": 15, "defense": 10}', 
 '["Sword Strike", "Heal"]', true),
 
('44444444-4444-4444-4444-444444444002', 'Erik', 'โจรหนุ่มที่ถูกขังในคุก Heliodor เชี่ยวชาญด้านการขโมยและมีดโยน', 'party_member', '/images/characters/erik.jpg',
 '{"hp": 80, "mp": 30, "level": 1, "attack": 18, "defense": 8}',
 '["Dagger Throw", "Steal", "Critical Hit"]', false),

-- NPCs
('44444444-4444-4444-4444-444444444003', 'Grandpa', 'ปู่ของ Hero ผู้เลี้ยงดู Hero มาตั้งแต่เด็ก', 'npc', '/images/characters/grandpa.jpg',
 '{"hp": 50, "mp": 20, "level": 1}', '[]', false),
 
('44444444-4444-4444-4444-444444444004', 'King Carnelian', 'กษัตริย์แห่ง Heliodor ผู้เชื่อว่า Hero คือ Darkspawn', 'npc', '/images/characters/king.jpg',
 '{"hp": 200, "mp": 100, "level": 10}', '[]', false),

('44444444-4444-4444-4444-444444444005', 'Prison Guard', 'ยามคุก Heliodor', 'npc', '/images/characters/guard.jpg',
 '{"hp": 60, "mp": 10, "level": 3}', '[]', false);

-- Insert Items
INSERT INTO public.items (id, name, description, item_type, rarity, stats, effects, image_url) VALUES
('55555555-5555-5555-5555-555555555001', 'Rusty Sword', 'ดาบเก่า ๆ ที่เป็นสนิม', 'weapon', 'common', 
 '{"attack": 5}', '{}', '/images/items/rusty_sword.jpg'),
 
('55555555-5555-5555-5555-555555555002', 'Prison Clothes', 'เสื้อผ้านักโทษ', 'armor', 'common',
 '{"defense": 2}', '{}', '/images/items/prison_clothes.jpg'),
 
('55555555-5555-5555-5555-555555555003', 'Medicinal Herb', 'สมุนไพรรักษา ฟื้นฟู HP', 'consumable', 'common',
 '{}', '{"heal": 30}', '/images/items/herb.jpg'),
 
('55555555-5555-5555-5555-555555555004', 'Prison Key', 'กุญแจคุก สำหรับปลดล็อคประตูคุก', 'key_item', 'rare',
 '{}', '{"unlock": "prison_door"}', '/images/items/key.jpg'),
 
('55555555-5555-5555-5555-555555555005', 'Erik''s Dagger', 'มีดโยนของ Erik อาวุธที่คมกริบ', 'weapon', 'uncommon',
 '{"attack": 12, "critical": 15}', '{}', '/images/items/dagger.jpg');

-- Insert Story Events
INSERT INTO public.story_events (id, chapter_id, location_id, title, description, event_type, is_unlocked, display_order) VALUES
-- Chapter 1 events
('66666666-6666-6666-6666-666666666001', '33333333-3333-3333-3333-333333333001', '22222222-2222-2222-2222-222222222001', 
 'Morning at Home', 'เช้าวันหนึ่งที่บ้าน Hero ตื่นขึ้นมาและพูดคุยกับปู่', 'dialogue', true, 1),

('66666666-6666-6666-6666-666666666002', '33333333-3333-3333-3333-333333333001', '22222222-2222-2222-2222-222222222003',
 'The Sacred Tree Ceremony', 'พิธีกรรมที่ต้นไม้ศักดิ์สิทธิ์ เหตุการณ์ที่เปลี่ยนชีวิต Hero', 'story', false, 2),

-- Chapter 2 events  
('66666666-6666-6666-6666-666666666003', '33333333-3333-3333-3333-333333333002', '22222222-2222-2222-2222-222222222006',
 'Imprisoned', 'Hero ถูกจับและขังในคุก Heliodor', 'story', false, 1),

('66666666-6666-6666-6666-666666666004', '33333333-3333-3333-3333-333333333002', '22222222-2222-2222-2222-222222222007',
 'Meeting Erik', 'Hero พบกับ Erik ในคุก และเริ่มวางแผนหลบหนี', 'dialogue', false, 2),

-- Chapter 3 events
('66666666-6666-6666-6666-666666666005', '33333333-3333-3333-3333-333333333003', '22222222-2222-2222-2222-222222222007',
 'Planning the Escape', 'วางแผนการหลบหนีจากคุกพร้อมกับ Erik', 'choice', false, 1),

('66666666-6666-6666-6666-666666666006', '33333333-3333-3333-3333-333333333003', '22222222-2222-2222-2222-222222222006',
 'The Great Escape', 'การหลบหนีที่ยิ่งใหญ่จากคุก Heliodor', 'story', false, 2);

-- Insert Event Interactions
INSERT INTO public.event_interactions (id, event_id, interaction_type, title, description, dialogue_text, character_speaker, choices, display_order) VALUES
-- Morning at Home interactions
('77777777-7777-7777-7777-777777777001', '66666666-6666-6666-6666-666666666001', 'talk', 'Talk to Grandpa', 
 'พูดคุยกับปู่เกี่ยวกับวันนี้', 
 'เช้าดี Hero วันนี้เป็นวันสำคัญนะ เจ้าต้องไปที่ต้นไม้ศักดิ์สิทธิ์', 'Grandpa', '[]', 1),

('77777777-7777-7777-7777-777777777002', '66666666-6666-6666-6666-666666666001', 'examine', 'Check Equipment',
 'ตรวจสอบอุปกรณ์ของตัวเอง', '', '', '[]', 2),

-- Meeting Erik interactions  
('77777777-7777-7777-7777-777777777003', '66666666-6666-6666-6666-666666666004', 'talk', 'Talk to Erik',
 'พูดคุยกับ Erik ในคุก',
 'เฮ้ นายใหม่เหรอ? ข้าชื่อ Erik... ข้าอยู่ที่นี่มานานแล้ว', 'Erik', '[]', 1),

('77777777-7777-7777-7777-777777777004', '66666666-6666-6666-6666-666666666004', 'choose', 'Respond to Erik',
 'เลือกการตอบสนองต่อ Erik',
 'นายจะตอบ Erik ว่าอย่างไร?', '',
 '[
   {"id": "friendly", "text": "ยินดีที่ได้รู้จัก ฉันชื่อ Hero", "type": "friendly"},
   {"id": "suspicious", "text": "ทำไมนายถึงอยู่ที่นี่?", "type": "suspicious"},
   {"id": "silent", "text": "เงียบไม่พูดอะไร", "type": "neutral"}
 ]', 2),

-- Planning Escape interactions
('77777777-7777-7777-7777-777777777005', '66666666-6666-6666-6666-666666666005', 'talk', 'Discuss Escape Plan',
 'หารือแผนการหลบหนีกับ Erik',
 'ฟังนะ Hero ข้ามีแผนที่จะหนีออกจากที่นี่ แต่ต้องใช้คนสองคน', 'Erik', '[]', 1),

('77777777-7777-7777-7777-777777777006', '66666666-6666-6666-6666-666666666005', 'choose', 'Choose Escape Route',
 'เลือกเส้นทางการหลบหนี',
 'เราจะเลือกเส้นทางไหนในการหลบหนี?', '',
 '[
   {"id": "sewers", "text": "ผ่านท่อระบายน้ำ", "type": "stealth"},
   {"id": "main_gate", "text": "ผ่านประตูหลัก", "type": "bold"},
   {"id": "window", "text": "ผ่านหน้าต่าง", "type": "risky"}
 ]', 2);

-- Insert Event Outcomes
INSERT INTO public.event_outcomes (id, interaction_id, choice_id, outcome_type, title, description, effects, next_event_id) VALUES
-- Friendly response to Erik
('88888888-8888-8888-8888-888888888001', '77777777-7777-7777-7777-777777777004', 'friendly', 'story',
 'Erik becomes friendly', 'Erik รู้สึกประทับใจในตัว Hero',
 '{"relationship": {"erik": 10}}', '66666666-6666-6666-6666-666666666005'),

-- Suspicious response to Erik  
('88888888-8888-8888-8888-888888888002', '77777777-7777-7777-7777-777777777004', 'suspicious', 'story',
 'Erik explains his situation', 'Erik อธิบายว่าทำไมเขาถึงอยู่ในคุก',
 '{"relationship": {"erik": 5}}', '66666666-6666-6666-6666-666666666005'),

-- Silent response
('88888888-8888-8888-8888-888888888003', '77777777-7777-7777-7777-777777777004', 'silent', 'story',
 'Erik respects your silence', 'Erik เข้าใจและเคารพการเงียบของ Hero',
 '{"relationship": {"erik": 7}}', '66666666-6666-6666-6666-666666666005'),

-- Sewer escape route
('88888888-8888-8888-8888-888888888004', '77777777-7777-7777-7777-777777777006', 'sewers', 'party_join',
 'Successful Stealth Escape', 'หลบหนีสำเร็จผ่านท่อระบายน้ำ Erik เข้าร่วมปาร์ตี้',
 '{"party_join": "44444444-4444-4444-4444-444444444002", "items": [{"id": "55555555-5555-5555-5555-555555555005", "quantity": 1}]}', 
 '66666666-6666-6666-6666-666666666006'),

-- Main gate escape route  
('88888888-8888-8888-8888-888888888005', '77777777-7777-7777-7777-777777777006', 'main_gate', 'party_join',
 'Bold Escape', 'หลบหนีแบบกล้าหาญผ่านประตูหลัก Erik เข้าร่วมปาร์ตี้',
 '{"party_join": "44444444-4444-4444-4444-444444444002", "items": [{"id": "55555555-5555-5555-5555-555555555003", "quantity": 2}]}',
 '66666666-6666-6666-6666-666666666006'),

-- Window escape route
('88888888-8888-8888-8888-888888888006', '77777777-7777-7777-7777-777777777006', 'window', 'party_join',
 'Risky but Successful', 'หลบหนีแบบเสี่ยงภัยผ่านหน้าต่าง Erik เข้าร่วมปาร์ตี้',
 '{"party_join": "44444444-4444-4444-4444-444444444002", "items": [{"id": "55555555-5555-5555-5555-555555555004", "quantity": 1}]}',
 '66666666-6666-6666-6666-666666666006'),

-- Default outcomes for interactions without choices
-- Add default outcome for "Talk to Grandpa" interaction
('88888888-8888-8888-8888-888888888007', '77777777-7777-7777-7777-777777777001', 'default', 'story',
 'Grandpa''s Advice', 'ปู่ให้คำแนะนำแก่ Hero',
 '{"unlock_events": ["66666666-6666-6666-6666-666666666002"]}', '66666666-6666-6666-6666-666666666002'),

-- Add default outcome for "Check Equipment" interaction
('88888888-8888-8888-8888-888888888008', '77777777-7777-7777-7777-777777777002', 'default', 'story',
 'Equipment Check', 'Hero ตรวจสอบอุปกรณ์ของตัวเอง',
 '{"items": [{"id": "55555555-5555-5555-5555-555555555001", "quantity": 1}], "unlock_events": ["66666666-6666-6666-6666-666666666002"]}', '66666666-6666-6666-6666-666666666002'),

-- Add default outcome for "Talk to Erik" interaction
('88888888-8888-8888-8888-888888888009', '77777777-7777-7777-7777-777777777003', 'default', 'story',
 'Erik''s Introduction', 'Erik แนะนำตัวเองให้ Hero รู้จัก',
 '{"relationship": {"erik": 5}, "unlock_events": ["66666666-6666-6666-6666-666666666005"]}', '66666666-6666-6666-6666-666666666005'),

-- Add default outcome for "Discuss Escape Plan" interaction
('88888888-8888-8888-8888-888888888010', '77777777-7777-7777-7777-777777777005', 'default', 'story',
 'Escape Plan Discussion', 'การหารือแผนการหลบหนี',
 '{"unlock_events": ["66666666-6666-6666-6666-666666666006"]}', '66666666-6666-6666-6666-666666666006');
