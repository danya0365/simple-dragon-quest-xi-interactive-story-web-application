-- Dragon Quest XI Story Data Seed - Enhanced Version (SUBQUERY PATTERN)
-- Created: 2025-09-26
-- Author: Marosdee Uma
-- Description: Enhanced and more intense story data for Dragon Quest XI Interactive Story
-- Features: More regions, locations, characters, items, events, and complex story progression
-- Pattern: Uses subqueries instead of hardcoding for better maintainability

-- === WORLD REGIONS ===
-- Insert World Regions using subquery pattern
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
    ('11111111-1111-1111-1111-111111111001', 'Cobblestone', 'หมู่บ้านเล็ก ๆ ที่เงียบสงบ บ้านเกิดของ Hero ท่ามกลางภูเขาและป่าไม้', '/images/regions/cobblestone.svg', '{}', 1, true, false),
    ('11111111-1111-1111-1111-111111111002', 'Heliodor', 'เมืองหลวงของอาณาจักร Heliodor ที่ยิ่งใหญ่และเจริญรุ่งเรือง', '/images/regions/heliodor.svg', '{"level": 5, "completed_chapters": ["33333333-3333-3333-3333-333333333001"]}', 2, false, true),
    ('11111111-1111-1111-1111-111111111003', 'Heliodor Dungeons', 'คุกใต้ดินของ Heliodor ที่มืดมิดและน่ากลัว', '/images/regions/dungeons.svg', '{"level": 5, "completed_chapters": ["33333333-3333-3333-3333-333333333001"], "flags": {"reached_heliodor": true}}', 3, false, true),
    ('11111111-1111-1111-1111-111111111004', 'Gallopolis', 'เมืองแห่งการแข่งม้าและวัฒนธรรมการต่อสู้', '/images/regions/gallopolis.svg', '{"level": 15, "completed_chapters": ["33333333-3333-3333-3333-333333333003"]}', 4, false, true),
    ('11111111-1111-1111-1111-111111111005', 'Puerto Valor', 'เมืองท่าแห่งทะเลเมดิเตอร์เรเนียนที่คึกคัก', '/images/regions/puerto_valor.svg', '{"level": 20, "completed_chapters": ["33333333-3333-3333-3333-333333333004"]}', 5, false, true),
    ('11111111-1111-1111-1111-111111111006', 'Octagonia', 'เมืองแห่งการต่อสู้ในสนามประลองที่โด่งดัง', '/images/regions/octagonia.svg', '{"level": 30, "completed_chapters": ["33333333-3333-3333-3333-333333333005"]}', 6, false, true),
    ('11111111-1111-1111-1111-111111111007', 'Zwaardsrust', 'ดินแดนแห่งอัศวินและการปกครองที่เข้มแข็ง', '/images/regions/zwaardsrust.svg', '{"level": 25, "completed_chapters": ["33333333-3333-3333-3333-333333333004"]}', 7, false, true),
    ('11111111-1111-1111-1111-111111111008', 'Grotta', 'หมู่บ้านชาวประมงที่สงบและอุดมสมบูรณ์', '/images/regions/grotta.svg', '{"level": 18, "completed_chapters": ["33333333-3333-3333-3333-333333333004"]}', 8, false, true)
) AS region_info(id, name, description, image_url, unlock_requirements, display_order, is_initial_user_progress, is_alway_hide_until_unlock);

-- === LOCATIONS ===
-- Insert Locations using subquery pattern
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
    -- Cobblestone locations
    ('22222222-2222-2222-2222-222222222001', 'Cobblestone', 'Hero''s House', 'บ้านของ Hero และ Grandpa ที่อบอุ่นและเต็มไปด้วยความทรงจำ', 'house', '{}', 1, true, false),
    ('22222222-2222-2222-2222-222222222002', 'Cobblestone', 'Village Square', 'จัตุรัสกลางหมู่บ้าน Cobblestone ที่คึกคัก', 'town', '{}', 2, true, false),
    ('22222222-2222-2222-2222-222222222003', 'Cobblestone', 'Sacred Tree', 'ต้นไม้ศักดิ์สิทธิ์ของหมู่บ้านที่เก่าแก่ที่สุด', 'landmark', '{"completed_events": ["66666666-6666-6666-6666-666666666001"]}', 3, false, true),
    ('22222222-2222-2222-2222-222222222004', 'Cobblestone', 'Village Shop', 'ร้านค้าของหมู่บ้านที่มีของใช้พื้นฐาน', 'shop', '{}', 4, true, false),

    -- Heliodor locations  
    ('22222222-2222-2222-2222-222222222005', 'Heliodor', 'Heliodor Castle', 'ปราสาทของกษัตริย์ Carnelian ที่สูงใหญ่', 'castle', '{"level": 8, "completed_events": ["66666666-6666-6666-6666-666666666003"]}', 1, false, true),
    ('22222222-2222-2222-2222-222222222006', 'Heliodor', 'Heliodor Town', 'เมืองใหญ่ที่คึกคักและมีชีวิตชีวา', 'town', '{"level": 5, "completed_events": ["66666666-6666-6666-6666-666666666003"]}', 2, false, true),
    ('22222222-2222-2222-2222-222222222007', 'Heliodor', 'Royal Market', 'ตลาดหลวงที่มีสินค้าหลากหลาย', 'market', '{"level": 6, "completed_events": ["66666666-6666-6666-6666-666666666003"]}', 3, false, true),

    -- Dungeon locations
    ('22222222-2222-2222-2222-222222222008', 'Heliodor Dungeons', 'Prison Cell Block A', 'ห้องขังส่วน A ของคุก Heliodor ที่เย็นเหี่ยว', 'dungeon', '{"level": 5, "completed_events": ["66666666-6666-6666-6666-666666666003"]}', 1, false, true),
    ('22222222-2222-2222-2222-222222222009', 'Heliodor Dungeons', 'Prison Cell Block B', 'ห้องขังส่วน B ที่มี Erik อยู่', 'dungeon', '{"level": 5, "completed_events": ["66666666-6666-6666-6666-666666666004"]}', 2, false, true),
    ('22222222-2222-2222-2222-222222222010', 'Heliodor Dungeons', 'Torture Chamber', 'ห้องทรมานที่น่ากลัวและมืดมิด', 'dungeon', '{"level": 8, "completed_events": ["66666666-6666-6666-6666-666666666005"]}', 3, false, true),
    ('22222222-2222-2222-2222-222222222011', 'Heliodor Dungeons', 'Sewer Entrance', 'ทางเข้าท่อระบายน้ำที่เหม็นอับ', 'dungeon', '{"level": 6, "completed_events": ["66666666-6666-6666-6666-666666666005"]}', 4, false, true),

    -- Gallopolis locations
    ('22222222-2222-2222-2222-222222222012', 'Gallopolis', 'Gallopolis Arena', 'สนามประลองที่โด่งดังทั่วโลก', 'arena', '{"level": 15, "completed_chapters": ["33333333-3333-3333-3333-333333333003"]}', 1, false, true),
    ('22222222-2222-2222-2222-222222222013', 'Gallopolis', 'Royal Stables', 'โรงม้าหลวงที่สวยงาม', 'stable', '{"level": 15, "completed_chapters": ["33333333-3333-3333-3333-333333333003"]}', 2, false, true),
    ('22222222-2222-2222-2222-222222222014', 'Gallopolis', 'Gallopolis Town', 'เมืองที่เต็มไปด้วยวัฒนธรรมการแข่งม้า', 'town', '{"level": 15, "completed_chapters": ["33333333-3333-3333-3333-333333333003"]}', 3, false, true),

    -- Puerto Valor locations
    ('22222222-2222-2222-2222-222222222015', 'Puerto Valor', 'Harbor', 'ท่าเรือที่คึกคักและมีเรือสินค้ามากมาย', 'harbor', '{"level": 20, "completed_chapters": ["33333333-3333-3333-3333-333333333004"]}', 1, false, true),
    ('22222222-2222-2222-2222-222222222016', 'Puerto Valor', 'Casino', 'คาสิโนที่มีชื่อเสียงและสนุกสนาน', 'casino', '{"level": 20, "completed_chapters": ["33333333-3333-3333-3333-333333333004"]}', 2, false, true),
    ('22222222-2222-2222-2222-222222222017', 'Puerto Valor', 'Beach', 'ชายหาดที่สวยงามและเงียบสงบ', 'beach', '{"level": 20, "completed_chapters": ["33333333-3333-3333-3333-333333333004"]}', 3, false, true),

    -- Octagonia locations
    ('22222222-2222-2222-2222-222222222018', 'Octagonia', 'Octagonia Arena', 'สนามประลองที่ใหญ่ที่สุดในโลก', 'arena', '{"level": 30, "completed_chapters": ["33333333-3333-3333-3333-333333333005"]}', 1, false, true),
    ('22222222-2222-2222-2222-222222222019', 'Octagonia', 'Fighter''s Guild', 'สมาคมนักสู้ที่มีชื่อเสียง', 'guild', '{"level": 30, "completed_chapters": ["33333333-3333-3333-3333-333333333005"]}', 2, false, true),

    -- Zwaardsrust locations
    ('22222222-2222-2222-2222-222222222020', 'Zwaardsrust', 'Zwaardsrust Castle', 'ปราสาทของอัศวินที่สูงใหญ่', 'castle', '{"level": 25, "completed_chapters": ["33333333-3333-3333-3333-333333333004"]}', 1, false, true),
    ('22222222-2222-2222-2222-222222222021', 'Zwaardsrust', 'Knight Academy', 'สถาบันการศึกษาของอัศวิน', 'academy', '{"level": 25, "completed_chapters": ["33333333-3333-3333-3333-333333333004"]}', 2, false, true),

    -- Grotta locations
    ('22222222-2222-2222-2222-222222222022', 'Grotta', 'Fishing Village', 'หมู่บ้านชาวประมงที่เรียบง่าย', 'village', '{"level": 18, "completed_chapters": ["33333333-3333-3333-3333-333333333004"]}', 1, false, true),
    ('22222222-2222-2222-2222-222222222023', 'Grotta', 'Fishing Dock', 'ท่าเทียบเรือประมงที่คึกคัก', 'dock', '{"level": 18, "completed_chapters": ["33333333-3333-3333-3333-333333333004"]}', 2, false, true)
) AS location_info(id, region_name, name, description, location_type, unlock_requirements, display_order, is_initial_user_progress, is_alway_hide_until_unlock)
WHERE wr.name = location_info.region_name;

-- === STORY CHAPTERS ===
-- Insert Story Chapters using subquery pattern
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
    ('33333333-3333-3333-3333-333333333001', 1, 'The Darkspawn', 'จุดเริ่มต้นของการผจญภัย เมื่อ Hero ถูกเรียกว่า Darkspawn และชีวิตกลับตาลปัตร', '{}', 1, true),
    ('33333333-3333-3333-3333-333333333002', 2, 'The Dungeons of Heliodor', 'Hero ถูกจับและขังในคุก Heliodor พบกับ Erik และเริ่มวางแผนการหลบหนี', '{"level": 5, "completed_chapters": ["33333333-3333-3333-3333-333333333001"], "flags": {"ceremony_completed": true}}', 2, false),
    ('33333333-3333-3333-3333-333333333003', 3, 'The Great Escape', 'การหลบหนีจากคุก Heliodor พร้อมกับ Erik และการเริ่มต้นการเดินทางที่แท้จริง', '{"level": 8, "completed_chapters": ["33333333-3333-3333-3333-333333333002"], "flags": {"met_erik": true}}', 3, false),
    ('33333333-3333-3333-3333-333333333004', 4, 'The City of Champions', 'การมาถึง Gallopolis เมืองแห่งการแข่งม้าและการต่อสู้ที่โด่งดัง', '{"level": 15, "completed_chapters": ["33333333-3333-3333-3333-333333333003"], "flags": {"escaped_prison": true}}', 4, false),
    ('33333333-3333-3333-3333-333333333005', 5, 'The Coastal Adventure', 'การเดินทางสู่ Puerto Valor เมืองท่าแห่งทะเลที่เต็มไปด้วยความท้าทาย', '{"level": 20, "completed_chapters": ["33333333-3333-3333-3333-333333333004"], "flags": {"gallopolis_champion": true}}', 5, false),
    ('33333333-3333-3333-3333-333333333006', 6, 'The Arena of Legends', 'การมาถึง Octagonia เมืองแห่งสนามประลองที่ใหญ่ที่สุดในโลก', '{"level": 30, "completed_chapters": ["33333333-3333-3333-3333-333333333005"], "flags": {"puerto_valor_hero": true}}', 6, false),
    ('33333333-3333-3333-3333-333333333007', 7, 'The Knight''s Honor', 'การไปยัง Zwaardsrust ดินแดนแห่งอัศวินและการปกครองที่เข้มแข็ง', '{"level": 25, "completed_chapters": ["33333333-3333-3333-3333-333333333005"], "flags": {"arena_veteran": true}}', 7, false),
    ('33333333-3333-3333-3333-333333333008', 8, 'The Fisher''s Tale', 'การไปยัง Grotta หมู่บ้านชาวประมงที่สงบและอุดมสมบูรณ์', '{"level": 18, "completed_chapters": ["33333333-3333-3333-3333-333333333005"], "flags": {"coastal_explorer": true}}', 8, false)
) AS chapter_info(id, chapter_number, title, description, unlock_requirements, display_order, is_initial_user_progress);

-- === CHARACTERS ===
-- Insert Characters using subquery pattern
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
    -- Main characters
    ('44444444-4444-4444-4444-444444444001', 'Hero', 'ตัวเอกของเรื่อง ผู้ถูกเรียกว่า Darkspawn และมีพลังลึกลับ', 'party_member', '/images/characters/hero.svg', 
     '{"hp": 150, "mp": 80, "level": 1, "attack": 20, "defense": 15, "agility": 12, "luck": 10}', 
     '["Sword Strike", "Heal", "Falcon Slash", "Metal Slash"]', true, true),
     
    ('44444444-4444-4444-4444-444444444002', 'Erik', 'โจรหนุ่มที่ถูกขังในคุก Heliodor เชี่ยวชาญด้านการขโมยและมีดโยน', 'party_member', '/images/characters/erik.svg',
     '{"hp": 120, "mp": 60, "level": 1, "attack": 25, "defense": 10, "agility": 20, "luck": 15}',
     '["Dagger Throw", "Steal", "Critical Hit", "Poison Dagger"]', true, false),

    ('44444444-4444-4444-4444-444444444003', 'Veronica', 'แม่มดสาวเจ้าเสน่ห์ผู้มีพลังเวทมนตร์อันทรงพลัง', 'party_member', '/images/characters/veronica.svg',
     '{"hp": 80, "mp": 150, "level": 1, "attack": 8, "defense": 6, "agility": 15, "luck": 12}',
     '["Frizz", "Sizzle", "Bang", "Kaboom"]', true, false),

    ('44444444-4444-4444-4444-444444444004', 'Serena', 'นักบวชสาวผู้เชี่ยวชาญด้านการรักษาและเวทมนตร์สนับสนุน', 'party_member', '/images/characters/serena.svg',
     '{"hp": 100, "mp": 120, "level": 1, "attack": 10, "defense": 12, "agility": 10, "luck": 18}',
     '["Heal", "Moreheal", "Zing", "Kazing"]', true, false),

    ('44444444-4444-4444-4444-444444444005', 'Sylvando', 'นักแสดงสุดหล่อผู้มีความสามารถในการต่อสู้และความบันเทิง', 'party_member', '/images/characters/sylvando.svg',
     '{"hp": 130, "mp": 90, "level": 1, "attack": 18, "defense": 14, "agility": 16, "luck": 20}',
     '["Pink Tornado", "Litheness", "Showmanship", "Charm"]', true, false),

    -- NPCs
    ('44444444-4444-4444-4444-444444444006', 'Grandpa', 'ปู่ของ Hero ผู้เลี้ยงดู Hero มาตั้งแต่เด็ก', 'npc', '/images/characters/grandpa.svg',
     '{"hp": 80, "mp": 40, "level": 1}', '[]', false, false),
     
    ('44444444-4444-4444-4444-444444444007', 'King Carnelian', 'กษัตริย์แห่ง Heliodor ผู้เชื่อว่า Hero คือ Darkspawn', 'npc', '/images/characters/king.svg',
     '{"hp": 300, "mp": 150, "level": 15}', '["Royal Decree", "King''s Wrath"]', false, false),

    ('44444444-4444-4444-4444-444444444008', 'Prison Guard', 'ยามคุก Heliodor ที่เข้มงวดและไร้ความปราณี', 'npc', '/images/characters/guard.svg',
     '{"hp": 100, "mp": 20, "level": 5}', '["Guard Strike", "Intimidate"]', false, false),

    ('44444444-4444-4444-4444-444444444009', 'Jasper', 'นายพลของ Heliodor ผู้ภักดีต่อกษัตริย์แต่มีเบื้องหลัง', 'npc', '/images/characters/jasper.svg',
     '{"hp": 250, "mp": 100, "level": 12}', '["Dark Blade", "Shadow Strike"]', false, false),

    ('44444444-4444-4444-4444-444444444010', 'Rab', 'อาจารย์ของ Hero ผู้มีความรู้ลึกซึ้งเกี่ยวกับโลก', 'npc', '/images/characters/rab.svg',
     '{"hp": 120, "mp": 200, "level": 10}', '["Wisdom", "Ancient Knowledge"]', false, false)
) AS character_info(id, name, description, character_type, avatar_url, stats, abilities, is_joinable, is_initial_user_progress);

-- === ITEMS ===
-- Insert Items using subquery pattern
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
    ('55555555-5555-5555-5555-555555555001', 'Rusty Sword', 'ดาบเก่า ๆ ที่เป็นสนิม แต่ยังใช้ได้', 'weapon', 'common', 
     '{"attack": 8, "accuracy": 85}', '{}', '/images/items/rusty_sword.svg', true),
     
    ('55555555-5555-5555-5555-555555555002', 'Erik''s Dagger', 'มีดโยนของ Erik อาวุธที่คมกริบและว่องไว', 'weapon', 'uncommon',
     '{"attack": 15, "critical": 20, "agility": 5}', '{}', '/images/items/dagger.svg', false),

    ('55555555-5555-5555-5555-555555555003', 'Flame Sword', 'ดาบเพลิงที่มีพลังไฟศักดิ์สิทธิ์', 'weapon', 'rare',
     '{"attack": 35, "fire_power": 15}', '{"fire_damage": 20}', '/images/items/flame_sword.svg', false),

    ('55555555-5555-5555-5555-555555555004', 'Thunder Staff', 'คทาสายฟ้าของนักเวท', 'weapon', 'rare',
     '{"attack": 12, "magic_power": 25, "mp": 20}', '{"thunder_damage": 30}', '/images/items/thunder_staff.svg', false),

    -- Armor
    ('55555555-5555-5555-5555-555555555005', 'Prison Clothes', 'เสื้อผ้านักโทษที่ขาดความสง่า', 'armor', 'common',
     '{"defense": 3}', '{}', '/images/items/prison_clothes.svg', false),

    ('55555555-5555-5555-5555-555555555006', 'Leather Armor', 'เกราะหนังที่ทนทานและยืดหยุ่น', 'armor', 'uncommon',
     '{"defense": 12, "hp": 20}', '{}', '/images/items/leather_armor.svg', false),

    ('55555555-5555-5555-5555-555555555007', 'Magic Robe', 'ชุดคลุมของนักเวทที่เพิ่มพลังเวท', 'armor', 'rare',
     '{"defense": 8, "magic_power": 15, "mp": 30}', '{}', '/images/items/magic_robe.svg', false),

    -- Consumables
    ('55555555-5555-5555-5555-555555555008', 'Medicinal Herb', 'สมุนไพรรักษา ฟื้นฟู HP เล็กน้อย', 'consumable', 'common',
     '{}', '{"heal": 30}', '/images/items/herb.svg', false),

    ('55555555-5555-5555-5555-555555555009', 'Strong Medicine', 'ยาแรงที่ฟื้นฟู HP จำนวนมาก', 'consumable', 'uncommon',
     '{}', '{"heal": 80}', '/images/items/strong_medicine.svg', false),

    ('55555555-5555-5555-5555-555555555010', 'Magic Water', 'น้ำมนตร์ที่ฟื้นฟู MP', 'consumable', 'uncommon',
     '{}', '{"magic_restore": 20}', '/images/items/magic_water.svg', false),

    -- Key items
    ('55555555-5555-5555-5555-555555555011', 'Prison Key', 'กุญแจคุก สำหรับปลดล็อคประตูคุก', 'key_item', 'rare',
     '{}', '{"unlock": "prison_door"}', '/images/items/key.svg', false),

    ('55555555-5555-5555-5555-555555555012', 'Sacred Amulet', 'เครื่องรางศักดิ์สิทธิ์ที่ปกป้องจากความชั่วร้าย', 'key_item', 'legendary',
     '{"defense": 10, "magic_power": 10}', '{"holy_protection": true}', '/images/items/amulet.svg', false),

    ('55555555-5555-5555-5555-555555555013', 'World Map', 'แผนที่โลกที่แสดงตำแหน่งที่ตั้งต่างๆ', 'key_item', 'common',
     '{}', '{"reveal_map": true}', '/images/items/map.svg', false)
) AS item_info(id, name, description, item_type, rarity, stats, effects, image_url, is_initial_user_progress);

-- === STORY EVENTS ===
-- Insert Story Events using subquery pattern
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
    -- Chapter 1: The Darkspawn
    ('66666666-6666-6666-6666-666666666001', 'The Darkspawn', 'Hero''s House', 'Morning at Home', 'เช้าวันหนึ่งที่บ้าน Hero ตื่นขึ้นมาและพูดคุยกับปู่เกี่ยวกับวันสำคัญ', 'dialogue', '{}', 1, true),
    ('66666666-6666-6666-6666-666666666002', 'The Darkspawn', 'Village Square', 'Village Life', 'การใช้ชีวิตประจำวันในหมู่บ้าน Cobblestone ที่สงบสุข', 'exploration', '{}', 2, true),
    ('66666666-6666-6666-6666-666666666003', 'The Darkspawn', 'Village Shop', 'Shopping for Adventure', 'การเตรียมอุปกรณ์สำหรับการเดินทางที่จะมาถึง', 'shopping', '{}', 3, true),
    ('66666666-6666-6666-6666-666666666004', 'The Darkspawn', 'Sacred Tree', 'The Sacred Tree Ceremony', 'พิธีกรรมที่ต้นไม้ศักดิ์สิทธิ์ เหตุการณ์ที่เปลี่ยนชีวิต Hero ไปตลอดกาล', 'story', '{"completed_events": ["66666666-6666-6666-6666-666666666001"]}', 4, false),

    -- Chapter 2: The Dungeons of Heliodor
    ('66666666-6666-6666-6666-666666666005', 'The Dungeons of Heliodor', 'Prison Cell Block A', 'Imprisoned', 'Hero ถูกจับและขังในคุก Heliodor ที่เย็นเหี่ยวและมืดมิด', 'story', '{"completed_chapters": ["33333333-3333-3333-3333-333333333001"], "flags": {"ceremony_completed": true}}', 1, false),
    ('66666666-6666-6666-6666-666666666006', 'The Dungeons of Heliodor', 'Prison Cell Block A', 'Cell Investigation', 'การตรวจสอบห้องขังเพื่อหาทางหนี', 'exploration', '{"completed_events": ["66666666-6666-6666-6666-666666666005"]}', 2, false),
    ('66666666-6666-6666-6666-666666666007', 'The Dungeons of Heliodor', 'Torture Chamber', 'The Torture Threat', 'การถูกคุกคามโดยยามคุกที่โหดร้าย', 'story', '{"completed_events": ["66666666-6666-6666-6666-666666666006"]}', 3, false),
    ('66666666-6666-6666-6666-666666666008', 'The Dungeons of Heliodor', 'Sewer Entrance', 'Sewer Discovery', 'การค้นพบทางเข้าท่อระบายน้ำที่อาจเป็นทางรอด', 'exploration', '{"completed_events": ["66666666-6666-6666-6666-666666666007"]}', 4, false),
    ('66666666-6666-6666-6666-666666666009', 'The Dungeons of Heliodor', 'Prison Cell Block B', 'Meeting Erik', 'Hero พบกับ Erik ในคุก และเริ่มวางแผนหลบหนีร่วมกัน', 'dialogue', '{"completed_events": ["66666666-6666-6666-6666-666666666005"]}', 5, false),

    -- Chapter 3: The Great Escape
    ('66666666-6666-6666-6666-666666666010', 'The Great Escape', 'Prison Cell Block B', 'Planning the Escape', 'วางแผนการหลบหนีจากคุกพร้อมกับ Erik อย่างละเอียด', 'choice', '{"completed_events": ["66666666-6666-6666-6666-666666666009"], "flags": {"erik_trust": 5}}', 1, false),
    ('66666666-6666-6666-6666-666666666011', 'The Great Escape', 'Sewer Entrance', 'The Great Escape', 'การหลบหนีที่ยิ่งใหญ่จากคุก Heliodor ผ่านท่อระบายน้ำ', 'story', '{"completed_events": ["66666666-6666-6666-6666-666666666010"]}', 2, false),
    ('66666666-6666-6666-6666-666666666012', 'The Great Escape', 'Heliodor Town', 'Freedom at Last', 'การได้รับอิสรภาพและเห็นโลกกว้างอีกครั้ง', 'story', '{"completed_events": ["66666666-6666-6666-6666-666666666011"]}', 3, false),
    ('66666666-6666-6666-6666-666666666013', 'The Great Escape', 'Royal Market', 'Market Escape', 'การหลบหนีผ่านตลาดที่คึกคักและเต็มไปด้วยผู้คน', 'action', '{"completed_events": ["66666666-6666-6666-6666-666666666012"]}', 4, false),
    ('66666666-6666-6666-6666-666666666014', 'The Great Escape', 'Heliodor Town', 'Leaving Heliodor', 'การออกจาก Heliodor เพื่อเริ่มการเดินทางที่แท้จริง', 'story', '{"completed_events": ["66666666-6666-6666-6666-666666666013"]}', 5, false),

    -- Chapter 4: The City of Champions
    ('66666666-6666-6666-6666-666666666015', 'The City of Champions', 'Gallopolis Town', 'Arriving at Gallopolis', 'การมาถึง Gallopolis เมืองแห่งการแข่งม้าที่โด่งดัง', 'story', '{"completed_chapters": ["33333333-3333-3333-3333-333333333003"], "flags": {"escaped_prison": true}}', 1, false),
    ('66666666-6666-6666-6666-666666666016', 'The City of Champions', 'Royal Stables', 'Meeting the Horses', 'การพบกับม้าที่สวยงามและแข็งแรงในโรงม้าหลวง', 'exploration', '{"completed_events": ["66666666-6666-6666-6666-666666666015"]}', 2, false),
    ('66666666-6666-6666-6666-666666666017', 'The City of Champions', 'Gallopolis Arena', 'The Arena Challenge', 'การท้าทายในสนามประลองที่ต้องการความกล้าหาญ', 'choice', '{"completed_events": ["66666666-6666-6666-6666-666666666016"]}', 3, false),
    ('66666666-6666-6666-6666-666666666018', 'The City of Champions', 'Gallopolis Arena', 'Arena Victory', 'การชนะการต่อสู้ในสนามประลองและได้รับการยอมรับ', 'story', '{"completed_events": ["66666666-6666-6666-6666-666666666017"]}', 4, false),
    ('66666666-6666-6666-6666-666666666019', 'The City of Champions', 'Gallopolis Town', 'Champion Celebration', 'การเฉลิมฉลองชัยชนะและการได้รับฉายาแชมป์เปี้ยน', 'story', '{"completed_events": ["66666666-6666-6666-6666-666666666018"]}', 5, false),

    -- Chapter 5: The Coastal Adventure
    ('66666666-6666-6666-6666-666666666020', 'The Coastal Adventure', 'Harbor', 'Coastal Arrival', 'การมาถึง Puerto Valor เมืองท่าแห่งทะเลที่คึกคัก', 'story', '{"completed_chapters": ["33333333-3333-3333-3333-333333333004"], "flags": {"gallopolis_champion": true}}', 1, false),
    ('66666666-6666-6666-6666-666666666021', 'The Coastal Adventure', 'Beach', 'Beach Exploration', 'การสำรวจชายหาดที่สวยงามและเงียบสงบ', 'exploration', '{"completed_events": ["66666666-6666-6666-6666-666666666020"]}', 2, false),
    ('66666666-6666-6666-6666-666666666022', 'The Coastal Adventure', 'Casino', 'Casino Adventure', 'การผจญภัยในคาสิโนที่เต็มไปด้วยความเสี่ยงและความสนุก', 'choice', '{"completed_events": ["66666666-6666-6666-6666-666666666021"]}', 3, false),
    ('66666666-6666-6666-6666-666666666023', 'The Coastal Adventure', 'Harbor', 'Sailing Challenge', 'การท้าทายการแล่นเรือและการสำรวจทะเล', 'action', '{"completed_events": ["66666666-6666-6666-6666-666666666022"]}', 4, false),
    ('66666666-6666-6666-6666-666666666024', 'The Coastal Adventure', 'Puerto Valor', 'Coastal Hero', 'การกลายเป็นฮีโร่แห่งชายฝั่งทะเล', 'story', '{"completed_events": ["66666666-6666-6666-6666-666666666023"]}', 5, false)
) AS event_info(id, chapter_name, location_name, title, description, event_type, unlock_requirements, display_order, is_initial_user_progress)
WHERE sc.title = event_info.chapter_name
AND l.name = event_info.location_name;

-- === EVENT INTERACTIONS ===
-- Insert Event Interactions using subquery pattern
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
    -- Morning at Home interactions
    ('77777777-7777-7777-7777-777777777001', 'Morning at Home', 'talk', 'Talk to Grandpa', 
     'พูดคุยกับปู่เกี่ยวกับวันสำคัญและพิธีกรรมที่จะมาถึง', 
     'เช้าดี Hero วันนี้เป็นวันสำคัญมาก เจ้าต้องไปที่ต้นไม้ศักดิ์สิทธิ์เพื่อทำพิธีกรรมบรรลุนิติภาวะ นี่คือชะตากรรมของเจ้า', 'Grandpa', '[]', '{}', 1),

    ('77777777-7777-7777-7777-777777777002', 'Morning at Home', 'examine', 'Check Equipment',
     'ตรวจสอบอุปกรณ์และเตรียมตัวสำหรับการเดินทางที่จะมาถึง', '', '', '[]', '{}', 2),

    ('77777777-7777-7777-7777-777777777003', 'Morning at Home', 'examine', 'Look at Family Photo',
     'ดูรูปภาพครอบครัวที่เต็มไปด้วยความทรงจำอันลึกซึ้ง', '', '', '[]', '{}', 3),

    -- Village Life interactions
    ('77777777-7777-7777-7777-777777777004', 'Village Life', 'talk', 'Talk to Villagers',
     'พูดคุยกับชาวบ้านและได้ยินเรื่องราวต่างๆ ในหมู่บ้าน', '', '', '[]', '{}', 1),

    ('77777777-7777-7777-7777-777777777005', 'Village Life', 'examine', 'Examine Village Well',
     'ตรวจสอบบ่อน้ำโบราณของหมู่บ้านที่มีน้ำใสสะอาด', '', '', '[]', '{}', 2),

    -- Shopping for Adventure interactions
    ('77777777-7777-7777-7777-777777777006', 'Shopping for Adventure', 'talk', 'Talk to Shopkeeper',
     'พูดคุยกับเจ้าของร้านเกี่ยวกับอุปกรณ์สำหรับการเดินทาง',
     'ยินดีต้อนรับ Hero มีอะไรให้ช่วยเหลือไหม? เจ้ากำลังจะออกเดินทางใช่ไหม?', 'Shopkeeper', '[]', '{}', 1),

    ('77777777-7777-7777-7777-777777777007', 'Shopping for Adventure', 'examine', 'Browse Items',
     'ดูสินค้าต่างๆ ในร้านที่อาจมีประโยชน์สำหรับการเดินทาง', '', '', '[]', '{}', 2),

    -- Sacred Tree Ceremony interactions
    ('77777777-7777-7777-7777-777777777008', 'The Sacred Tree Ceremony', 'story', 'Sacred Tree Ritual',
     'พิธีกรรมที่ต้นไม้ศักดิ์สิทธิ์ที่จะเปลี่ยนชีวิต Hero ไปตลอดกาล', 
     'Hero ทำพิธีกรรมที่ต้นไม้ศักดิ์สิทธิ์... แสงสว่างล้อมรอบ... พลังลึกลับผุดขึ้น... แต่แล้วก็เกิดเหตุการณ์ไม่คาดฝัน! แสงสีมืดล้อมรอบ... มีเสียงกรีดร้องดังขึ้น!', 'Narrator', '[]', '{}', 1),

    ('77777777-7777-7777-7777-777777777009', 'The Sacred Tree Ceremony', 'examine', 'Examine the Tree',
     'ตรวจสอบต้นไม้ศักดิ์สิทธิ์ที่เก่าแก่และมีพลังลึกลับ', '', '', '[]', '{}', 2),

    -- Imprisoned interactions
    ('77777777-7777-7777-7777-777777777010', 'Imprisoned', 'story', 'Waking Up in Prison',
     'ตื่นขึ้นมาในคุกที่เย็นเหี่ยวและมืดมิด ไม่รู้ว่าเกิดอะไรขึ้น', 
     'Hero ตื่นขึ้นมาในห้องขังที่เย็นเหี่ยว... หัวปวด... ไม่รู้ว่าตัวเองอยู่ที่ไหน... เสียงยามคุกดังอยู่ไกลๆ... นี่คือความมืดที่แท้จริง!', 'Narrator', '[]', '{}', 1),

    ('77777777-7777-7777-7777-777777777011', 'Imprisoned', 'examine', 'Examine Cell',
     'ตรวจสอบห้องขังที่มืดมิดและน่ากลัวเพื่อหาทางรอด', '', '', '[]', '{}', 2),

    -- Cell Investigation interactions
    ('77777777-7777-7777-7777-777777777012', 'Cell Investigation', 'examine', 'Search for Weak Points',
     'ค้นหาจุดอ่อนในห้องขังที่อาจเป็นทางรอด', '', '', '[]', '{}', 1),

    ('77777777-7777-7777-7777-777777777013', 'Cell Investigation', 'examine', 'Listen to Guards',
     'ฟังเสียงยามคุกเพื่อเก็บข้อมูลและหาจังหวะ', '', '', '[]', '{}', 2),

    -- The Torture Threat interactions
    ('77777777-7777-7777-7777-777777777014', 'The Torture Threat', 'story', 'Guard Interrogation',
     'การถูกสอบปากโดยยามคุกที่โหดร้ายและไร้ความปราณี', 
     'ยามคุก: บอกมาซะว่าเจ้าคือใคร! ทำไมถึงมีพลังประหลาด! ถ้าไม่บอกจะเอาไปทรมานให้ได้เลือดตา!', 'Prison Guard', '[]', '{}', 1),

    ('77777777-7777-7777-7777-777777777015', 'The Torture Threat', 'choose', 'Respond to Guard',
     'เลือกการตอบสนองต่อยามคุกที่โหดร้าย',
     'เจ้าจะตอบยามคุกว่าอย่างไร?', '',
     '[
       {"id": "defiant", "text": "ข้าไม่รู้อะไรเลย! ปล่อยข้าออกไป!", "type": "bold"},
       {"id": "silent", "text": "เงียบ... ไม่ตอบสนอง", "type": "calm"},
       {"id": "plead", "text": "ขอโทษครับ... ข้าไม่ได้ทำอะไรผิด", "type": "humble"}
     ]', '{}', 2),

    -- Sewer Discovery interactions
    ('77777777-7777-7777-7777-777777777016', 'Sewer Discovery', 'examine', 'Find Sewer Entrance',
     'ค้นพบทางเข้าท่อระบายน้ำที่ซ่อนอยู่', '', '', '[]', '{}', 1),

    ('77777777-7777-7777-7777-777777777017', 'Sewer Discovery', 'examine', 'Check Sewer Condition',
     'ตรวจสอบสภาพของท่อระบายน้ำว่าสามารถผ่านได้หรือไม่', '', '', '[]', '{}', 2),

    -- Meeting Erik interactions  
    ('77777777-7777-7777-7777-777777777018', 'Meeting Erik', 'talk', 'Talk to Erik',
     'พูดคุยกับ Erik ในคุกและได้รู้จักกัน',
     'เฮ้ นายใหม่เหรอ? ข้าชื่อ Erik... ข้าอยู่ที่นี่มานานแล้ว ดูเหมือนนายจะมีเรื่องใหญ่ๆ เกิดขึ้นเหมือนกัน', 'Erik', '[]', '{}', 1),

    ('77777777-7777-7777-7777-777777777019', 'Meeting Erik', 'choose', 'Respond to Erik',
     'เลือกการตอบสนองต่อ Erik ที่เสนอช่วยเหลือ',
     'นายจะตอบ Erik ว่าอย่างไร?', '',
     '[
       {"id": "friendly", "text": "ยินดีที่ได้รู้จัก ฉันชื่อ Hero", "type": "friendly"},
       {"id": "suspicious", "text": "ทำไมนายถึงอยู่ที่นี่? นายเป็นใคร?", "type": "suspicious"},
       {"id": "silent", "text": "เงียบไม่พูดอะไร... แต่สบตา", "type": "neutral"}
     ]', '{}', 2),

    -- Planning Escape interactions
    ('77777777-7777-7777-7777-777777777020', 'Planning the Escape', 'talk', 'Discuss Escape Plan',
     'หารือแผนการหลบหนีกับ Erik อย่างละเอียด',
     'ฟังนะ Hero ข้ามีแผนที่จะหนีออกจากที่นี่ แต่ต้องใช้คนสองคน ข้าเห็นทางเข้าท่อระบายน้ำแล้ว แต่ยังมีอุปสรรคอีกหลายอย่าง', 'Erik', '[]', '{}', 1),

    ('77777777-7777-7777-7777-777777777021', 'Planning the Escape', 'choose', 'Choose Escape Route',
     'เลือกเส้นทางการหลบหนีที่เหมาะสมที่สุด',
     'เราจะเลือกเส้นทางไหนในการหลบหนี?', '',
     '[
       {"id": "sewers", "text": "ผ่านท่อระบายน้ำ (ปลอดภัยแต่เหม็นอับ)", "type": "stealth"},
       {"id": "main_gate", "text": "ผ่านประตูหลัก (กล้าหาญแต่เสี่ยงสูง)", "type": "bold"},
       {"id": "window", "text": "ผ่านหน้าต่าง (เสี่ยงแต่รวดเร็ว)", "type": "risky"}
     ]', '{}', 2)
) AS interaction_info(id, event_title, interaction_type, title, description, dialogue_text, character_speaker, choices, requirements, display_order)
WHERE se.title = interaction_info.event_title;

-- === EVENT OUTCOMES ===
-- Insert Event Outcomes using subquery pattern
INSERT INTO public.event_outcomes (id, interaction_id, choice_key, outcome_type, title, description, effects, next_event_id)
SELECT 
  outcome_info.id::uuid,
  ei.id AS interaction_id,
  outcome_info.choice_key,
  outcome_info.outcome_type,
  outcome_info.title,
  outcome_info.description,
  outcome_info.effects::jsonb,
  outcome_info.next_event_id::uuid
FROM event_interactions ei
CROSS JOIN (
  VALUES 
    -- Morning at Home outcomes
    ('88888888-8888-8888-8888-888888888001', 'Talk to Grandpa', 'default', 'story', 'Grandpa Conversation', 
     'ปู่บอกเรื่องพิธีกรรมและความสำคัญของวันนี้ Hero รู้สึกตื่นเต้นและพร้อมที่จะทำตามชะตากรรม', 
     '{"experience": 10, "relationship": {"Grandpa": 5}}', '66666666-6666-6666-6666-666666666002'),

    ('88888888-8888-8888-8888-888888888002', 'Check Equipment', 'default', 'reward', 'Equipment Check', 
     'Hero ตรวจสอบอุปกรณ์พื้นฐาน พบดาบเก่าและเกราะหนัง พร้อมสำหรับการเดินทาง', 
     '{"items": [{"id": "55555555-5555-5555-5555-555555555001", "quantity": 1}, {"id": "55555555-5555-5555-5555-555555555005", "quantity": 1}], "experience": 5}', '66666666-6666-6666-6666-666666666003'),

    ('88888888-8888-8888-8888-888888888003', 'Look at Family Photo', 'default', 'story', 'Family Memories', 
     'รูปภาพครอบครัวทำให้ Hero นึกถึงความทรงจำดีๆ และมีกำลังใจในการเผชิญหน้าอนาคต', 
     '{"experience": 5, "relationship": {"Grandpa": 3}}', '66666666-6666-6666-6666-666666666004'),

    -- Village Life outcomes
    ('88888888-8888-8888-8888-888888888004', 'Talk to Villagers', 'default', 'story', 'Village Welcome', 
     'ชาวบ้านต้อนรับ Hero อย่างอบอุ่น บอกเรื่องราวต่างๆ และให้กำลังใจ', 
     '{"experience": 15, "gold": 50, "relationship": {"Villagers": 10}}', '66666666-6666-6666-6666-666666666005'),

    ('88888888-8888-8888-8888-888888888005', 'Examine Village Well', 'default', 'reward', 'Well Water', 
     'บ่อน้ำโบราณมีน้ำใสสะอาด Hero ได้น้ำมาดื่มและรู้สึกสดชื่น', 
     '{"experience": 5, "items": [{"id": "55555555-5555-5555-5555-555555555008", "quantity": 2}]}', '66666666-6666-6666-6666-666666666006'),

    -- Shopping for Adventure outcomes
    ('88888888-8888-8888-8888-888888888006', 'Talk to Shopkeeper', 'default', 'story', 'Shopkeeper Advice', 
     'เจ้าของร้านให้ข้อมูลเกี่ยวกับอุปกรณ์สำหรับการเดินทางและแนะนำสินค้าที่มีประโยชน์', 
     '{"experience": 10, "gold": 100, "relationship": {"Shopkeeper": 5}}', '66666666-6666-6666-6666-666666666007'),

    ('88888888-8888-8888-8888-888888888007', 'Browse Items', 'default', 'reward', 'Purchase Items', 
     'Hero ดูสินค้าต่างๆ และซื้อของที่จำเป็นสำหรับการเดินทาง', 
     '{"items": [{"id": "55555555-5555-5555-5555-555555555008", "quantity": 5}, {"id": "55555555-5555-5555-5555-555555555009", "quantity": 2}], "gold": -150}', '66666666-6666-6666-6666-666666666008'),

    -- Sacred Tree Ceremony outcomes
    ('88888888-8888-8888-8888-888888888008', 'Sacred Tree Ritual', 'default', 'story', 'Ceremony Disruption', 
     'พิธีกรรมเริ่มขึ้น! แสงสว่างล้อมรอบ Hero แต่แล้วเกิดเหตุการณ์ไม่คาดฝัน! พลังมืดปรากฏ... มีเสียงกรีดร้อง... และ Hero ถูกจับ!', 
     '{"experience": 50, "unlock_chapters": ["33333333-3333-3333-3333-333333333002"], "flags": {"ceremony_completed": true, "darkspawn_event": true}}', '66666666-6666-6666-6666-666666666009'),

    ('88888888-8888-8888-8888-888888888009', 'Examine the Tree', 'default', 'reward', 'Tree Power', 
     'ต้นไม้ศักดิ์สิทธิ์มีพลังลึกลับ Hero รู้สึกถึงพลังที่แข็งแกร่งและพร้อมสำหรับพิธีกรรม', 
     '{"experience": 20, "items": [{"id": "55555555-5555-5555-5555-555555555012", "quantity": 1}]}', '66666666-6666-6666-6666-666666666010'),

    -- Imprisoned outcomes
    ('88888888-8888-8888-8888-888888888010', 'Waking Up in Prison', 'default', 'story', 'Prison Awakening', 
     'Hero ตื่นขึ้นมาในคุกที่เย็นเหี่ยว ไม่รู้ว่าเกิดอะไรขึ้น แต่รู้สึกได้ถึงพลังลึกลับในตัว', 
     '{"experience": 10, "unlock_locations": ["22222222-2222-2222-2222-222222222008"]}', '66666666-6666-6666-6666-666666666011'),

    ('88888888-8888-8888-8888-888888888011', 'Examine Cell', 'default', 'reward', 'Cell Discovery', 
     'การตรวจสอบห้องขังพบว่ามีจุดอ่อนที่ผนังและประตูที่อาจสามารถเปิดได้', 
     '{"experience": 15, "items": [{"id": "55555555-5555-5555-5555-555555555011", "quantity": 1}]}', '66666666-6666-6666-6666-666666666012'),

    -- Cell Investigation outcomes
    ('88888888-8888-8888-8888-888888888012', 'Search for Weak Points', 'default', 'unlock', 'Weak Points Found', 
     'Hero พบจุดอ่อนที่ผนังห้องขัง มีรอยแตกที่อาจสามารถทลายได้', 
     '{"experience": 20, "unlock_events": ["66666666-6666-6666-6666-666666666007"]}', '66666666-6666-6666-6666-666666666013'),

    ('88888888-8888-8888-8888-888888888013', 'Listen to Guards', 'default', 'story', 'Guard Schedule', 
     'การฟังเสียงยามคุกทำให้ Hero รู้จักเวลาเปลี่ยนเวรและจังหวะที่เหมาะสม', 
     '{"experience": 15, "flags": {"knows_guard_schedule": true}}', '66666666-6666-6666-6666-666666666014'),

    -- The Torture Threat outcomes
    ('88888888-8888-8888-8888-888888888014', 'Guard Interrogation', 'default', 'story', 'Guard Threat', 
     'ยามคุกคุกคาม Hero อย่างโหดร้าย แต่ Hero ยังคงไม่ยอมแพ้', 
     '{"experience": 25, "relationship": {"Prison Guard": -10}}', '66666666-6666-6666-6666-666666666015'),

    ('88888888-8888-8888-8888-888888888015', 'Respond to Guard', 'defiant', 'story', 'Defiant Response', 
     'Hero ตอบโต้ยามคุกอย่างกล้าหาญ ทำให้ยามคุกโมโหแต่ก็เคารพความกล้าหาญ', 
     '{"experience": 30, "relationship": {"Prison Guard": -5, "Erik": 5}}', '66666666-6666-6666-6666-666666666016'),

    ('88888888-8888-8888-8888-888888888016', 'Respond to Guard', 'silent', 'story', 'Silent Response', 
     'Hero เงียบไม่ตอบสนอง ทำให้ยามคุกโมโหและข่มเหง แต่ Hero ยังคงสงบ', 
     '{"experience": 20, "relationship": {"Prison Guard": -15}}', '66666666-6666-6666-6666-666666666016'),

    ('88888888-8888-8888-8888-888888888017', 'Respond to Guard', 'plead', 'story', 'Pleading Response', 
     'Hero อ้อนวอนขอโทษ ทำให้ยามคุกเห็นใจแต่ก็ยังไม่ปล่อยตัว', 
     '{"experience": 10, "relationship": {"Prison Guard": -5}}', '66666666-6666-6666-6666-666666666016'),

    -- Sewer Discovery outcomes
    ('88888888-8888-8888-8888-888888888018', 'Find Sewer Entrance', 'default', 'unlock', 'Sewer Found', 
     'Hero พบทางเข้าท่อระบายน้ำที่ซ่อนอยู่ นี่อาจเป็นทางรอด!', 
     '{"experience": 25, "unlock_locations": ["22222222-2222-2222-2222-222222222011"]}', '66666666-6666-6666-6666-666666666017'),

    ('88888888-8888-8888-8888-888888888019', 'Check Sewer Condition', 'default', 'story', 'Sewer Assessment', 
     'ท่อระบายน้ำมีสภาพที่สามารถผ่านได้ แม้จะเหม็นอับแต่ก็เป็นทางรอดที่ดี', 
     '{"experience": 15, "flags": {"sewer_accessible": true}}', '66666666-6666-6666-6666-666666666018'),

    -- Meeting Erik outcomes
    ('88888888-8888-8888-8888-888888888020', 'Talk to Erik', 'default', 'story', 'Erik Introduction', 
     'Erik เป็นโจรหนุ่มที่ถูกขังมานาน เขามีข้อมูลเกี่ยวกับคุกและอาจช่วยเหลือได้', 
     '{"experience": 20, "relationship": {"Erik": 10}, "unlock_events": ["66666666-6666-6666-6666-666666666010"]}', '66666666-6666-6666-6666-666666666019'),

    ('88888888-8888-8888-8888-888888888021', 'Respond to Erik', 'friendly', 'story', 'Friendly Response', 
     'Hero ตอบรับ Erik อย่างเป็นกันเอง ทำให้ Erik ไว้ใจและยอมช่วยเหลือ', 
     '{"experience": 25, "relationship": {"Erik": 15}, "flags": {"erik_trust": 5}}', '66666666-6666-6666-6666-666666666020'),

    ('88888888-8888-8888-8888-888888888022', 'Respond to Erik', 'suspicious', 'story', 'Suspicious Response', 
     'Hero สงสัย Erik แต่ Erik ก็เข้าใจและพยายามพิสูจน์ตัวเอง', 
     '{"experience": 15, "relationship": {"Erik": 5}}', '66666666-6666-6666-6666-666666666020'),

    ('88888888-8888-8888-8888-888888888023', 'Respond to Erik', 'silent', 'story', 'Silent Understanding', 
     'Hero เงียบแต่สบตากับ Erik ทำให้ Erik เข้าใจและเคารพ', 
     '{"experience": 20, "relationship": {"Erik": 10}}', '66666666-6666-6666-6666-666666666020'),

    -- Planning Escape outcomes
    ('88888888-8888-8888-8888-888888888024', 'Discuss Escape Plan', 'default', 'story', 'Escape Strategy', 
     'Erik บอกแผนการหลบหนีที่ละเอียด มีทางเลือกหลายอย่างและต้องการความร่วมมือ', 
     '{"experience": 30, "relationship": {"Erik": 20}, "flags": {"escape_plan_ready": true}}', '66666666-6666-6666-6666-666666666021'),

    ('88888888-8888-8888-8888-888888888025', 'Choose Escape Route', 'sewers', 'story', 'Sewer Route', 
     'เลือกผ่านท่อระบายน้ำ! แม้จะเหม็นอับแต่ปลอดภัยและมีโอกาสสำเร็จสูง', 
     '{"experience": 40, "items": [{"id": "55555555-5555-5555-5555-555555555008", "quantity": 3}], "flags": {"escape_route": "sewers"}}', '66666666-6666-6666-6666-666666666022'),

    ('88888888-8888-8888-8888-888888888026', 'Choose Escape Route', 'main_gate', 'story', 'Main Gate Route', 
     'เลือกผ่านประตูหลัก! กล้าหาญแต่เสี่ยงสูง ต้องเผชิญหน้ากับยามคุกหลายคน', 
     '{"experience": 50, "items": [{"id": "55555555-5555-5555-5555-555555555009", "quantity": 2}], "flags": {"escape_route": "main_gate"}}', '66666666-6666-6666-6666-666666666022'),

    ('88888888-8888-8888-8888-888888888027', 'Choose Escape Route', 'window', 'story', 'Window Route', 
     'เลือกผ่านหน้าต่าง! เสี่ยงแต่รวดเร็ว ต้องอาศัยความว่องไวและโชค', 
     '{"experience": 45, "items": [{"id": "55555555-5555-5555-5555-555555555010", "quantity": 1}], "flags": {"escape_route": "window"}}', '66666666-6666-6666-6666-666666666022')
) AS outcome_info(id, interaction_title, choice_key, outcome_type, title, description, effects, next_event_id)
WHERE ei.title = outcome_info.interaction_title;
