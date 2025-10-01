-- Dragon Quest XI Story Acts Seed Data
-- This file contains the story acts that group chapters into logical narrative sections

-- === STORY ACTS ===
INSERT INTO public.story_acts (id, act_number, title, description, unlock_requirements, display_order, is_initial_user_progress)
SELECT 
  act_info.id::uuid,
  act_info.act_number,
  act_info.title,
  act_info.description,
  act_info.unlock_requirements::jsonb,
  act_info.display_order,
  act_info.is_initial_user_progress
FROM (
  VALUES 
    -- Act 1: The Beginning of Destiny
    ('11111111-1111-1111-1111-111111111001', 1, 'The Beginning of Destiny', 'การเริ่มต้นของชะตากรรม - การปรากฏตัวของ Luminary และการตกจากความสุขสงบ', '{}', 1, true),
    
    -- Act 2: The Journey Begins
    ('11111111-1111-1111-1111-111111111002', 2, 'The Journey Begins', 'การเริ่มต้นการเดินทาง - การหลบหนีและการผจญภัยในดินแดนต่างๆ เพื่อสร้างพลังและพันธมิตร', '{"completed_acts": ["11111111-1111-1111-1111-111111111001"]}', 2, false),
    
    -- Act 3: The Quest for Truth
    ('11111111-1111-1111-1111-111111111003', 3, 'The Quest for Truth', 'การตามหาความจริง - การเรียนรู้เกี่ยวกับชะตากรรมที่แท้จริงและการเก็บรวบรวมพันธมิตรครั้งสุดท้าย', '{"completed_acts": ["11111111-1111-1111-1111-111111111002"]}', 3, false),
    
    -- Act 4: The Final Confrontation
    ('11111111-1111-1111-1111-111111111004', 4, 'The Final Confrontation', 'การต่อสู้ครั้งสุดท้าย - การเตรียมพร้อมและการเผชิญหน้ากับความชั่วร้ายเพื่อกอบกู้โลก', '{"completed_acts": ["11111111-1111-1111-1111-111111111003"]}', 4, false),
    
    -- Act 5: The Epilogue
    ('11111111-1111-1111-1111-111111111005', 5, 'The Epilogue', 'บทสรุปและการเริ่มต้นใหม่ - การแต่งงาน การสร้าง Cobblestone ใหม่ และมรดกของ Luminary', '{"completed_acts": ["11111111-1111-1111-1111-111111111004"]}', 5, false)
) AS act_info(id, act_number, title, description, unlock_requirements, display_order, is_initial_user_progress);
