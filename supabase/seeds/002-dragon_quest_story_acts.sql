-- Dragon Quest Story Acts Seed Data
-- This file contains the story acts that group chapters into logical narrative sections

-- === STORY ACTS ===
INSERT INTO public.story_acts (id, code, origin_id, act_number, title, description, unlock_requirements, display_order, is_initial_user_progress)
SELECT 
  uuid_generate_v5(uuid_nil(), act_info.code),
  act_info.code,
  so.id AS origin_id,
  act_info.act_number,
  act_info.title,
  act_info.description,
  act_info.unlock_requirements::jsonb,
  act_info.display_order,
  act_info.is_initial_user_progress
FROM (
  VALUES 
    -- Dragon Quest I Acts
    ('dragon-quest-i-act-----------------001', 1, 'The Beginning', 'การเริ่มต้นของการผจญภัย - การได้รับภารกิจจากกษัตริย์และการออกเดินทางครั้งแรก', '{}', 1, true, 'dragon-quest-i---------------------001'),
    ('dragon-quest-i-act-----------------002', 2, 'The Adventure', 'การผจญภัยตามหาอาวุธวิเศษ - การเก็บรวบรวม Sun Stone และ Rain Staff', '{}', 2, false, 'dragon-quest-i---------------------001'),
    ('dragon-quest-i-act-----------------003', 3, 'The Final Battle', 'การต่อสู้ครั้งสุดท้าย - การเผชิญหน้ากับเจ้ามังกร Dragonlord และการช่วยเหลือเจ้าหญิง', '{}', 3, false, 'dragon-quest-i---------------------001'),
    
    -- Dragon Quest II Acts
    ('dragon-quest-ii-act----------------001', 1, 'The Descendants', 'ทายาทผู้กล้า - การเริ่มต้นการเดินทางของลูกหลานผู้กล้าจาก Dragon Quest I', '{}', 4, false, 'dragon-quest-ii--------------------001'),
    ('dragon-quest-ii-act----------------002', 2, 'The Cursed Kingdom', 'อาณาจักรแห่งคำสาป - การสำรวจโลกที่ถูกทำลายและตามหาพี่น้อง', '{}', 5, false, 'dragon-quest-ii--------------------001'),
    ('dragon-quest-ii-act----------------003', 3, 'The Final Confrontation', 'การเผชิญหน้าครั้งสุดท้าย - การต่อสู้กับมนุษย์ปีศาจ Hargon และ Malroth', '{}', 6, false, 'dragon-quest-ii--------------------001'),
    
    -- Dragon Quest III Acts
    ('dragon-quest-iii-act---------------001', 1, 'The Hero''s Journey', 'การเดินทางของผู้กล้า - การเดินทางย้อนเวลาและการรวบรวมพรรคพวก', '{}', 7, false, 'dragon-quest-iii-------------------001'),
    ('dragon-quest-iii-act---------------002', 2, 'The World Tree', 'ต้นไม้โลก - การตามหาอาวุธวิเศษและการเผชิญหน้ากับ Baramos', '{}', 8, false, 'dragon-quest-iii-------------------001'),
    ('dragon-quest-iii-act---------------003', 3, 'The Battle with Zoma', 'การต่อสู้กับโซมา - การเผชิญหน้ากับจอมมาร Zoma ผู้ปกครองโลกใต้พิภพ', '{}', 9, false, 'dragon-quest-iii-------------------001'),
    
    -- Dragon Quest XI Acts
    ('dragon-quest-xi-act----------------001', 1, 'The Beginning of Destiny', 'การเริ่มต้นของชะตากรรม - การปรากฏตัวของ Luminary และการตกจากความสุขสงบ', '{}', 10, false, 'dragon-quest-xi--------------------001'),
    ('dragon-quest-xi-act----------------002', 2, 'The Journey Begins', 'การเริ่มต้นการเดินทาง - การหลบหนีและการผจญภัยในดินแดนต่างๆ เพื่อสร้างพลังและพันธมิตร', '{}', 11, false, 'dragon-quest-xi--------------------001'),
    ('dragon-quest-xi-act----------------003', 3, 'The Quest for Truth', 'การตามหาความจริง - การเรียนรู้เกี่ยวกับชะตากรรมที่แท้จริงและการเก็บรวบรวมพันธมิตรครั้งสุดท้าย', '{}', 12, false, 'dragon-quest-xi--------------------001'),
    ('dragon-quest-xi-act----------------004', 4, 'The Final Confrontation', 'การต่อสู้ครั้งสุดท้าย - การเตรียมพร้อมและการเผชิญหน้ากับความชั่วร้ายเพื่อกอบกู้โลก', '{}', 13, false, 'dragon-quest-xi--------------------001'),
    ('dragon-quest-xi-act----------------005', 5, 'The Epilogue', 'บทสรุปและการเริ่มต้นใหม่ - การแต่งงาน การสร้าง Cobblestone ใหม่ และมรดกของ Luminary', '{}', 14, false, 'dragon-quest-xi--------------------001')
) AS act_info(code, act_number, title, description, unlock_requirements, display_order, is_initial_user_progress, origin_code)
JOIN story_origins so ON so.code = act_info.origin_code;
