-- Dragon Quest Story Origins Seed Data
-- Created: 2025-10-01
-- Author: Marosdee Uma
-- Description: Seed data for Dragon Quest story origins

-- Insert story origins data
INSERT INTO public.story_origins (id, code, name, description, unlock_requirements, display_order, is_initial_user_progress)
VALUES 
  -- Dragon Quest I
  (uuid_generate_v5(uuid_nil(), 'dragon-quest-i---------------------001'), 'dragon-quest-i---------------------001', 'Dragon Quest I', 'เรื่องราวของผู้กล้าผู้สืบทอดอำนาจแห่งแสง ผู้ออกเดินทางเพื่อกอบกู้โลกจากเจ้ามังกรคลั่ง และช่วยเหลือเจ้าหญิงลอร่า', '{}', 1, true),
  
  -- Dragon Quest II
  (uuid_generate_v5(uuid_nil(), 'dragon-quest-ii--------------------001'), 'dragon-quest-ii--------------------001', 'Dragon Quest II', 'เรื่องราวของทายาทผู้กล้าจาก Dragon Quest I ผู้ออกเดินทางเพื่อกอบกู่โลกจากมนุษย์ปีศาจฮาร์กอน และตามหาพี่น้องที่สูญหาย', '{}', 2, false),
  
  -- Dragon Quest III
  (uuid_generate_v5(uuid_nil(), 'dragon-quest-iii-------------------001'), 'dragon-quest-iii-------------------001', 'Dragon Quest III', 'เรื่องราวของผู้กล้าผู้เดินทางย้อนเวลากลับไปในอดีต เพื่อต่อสู้กับซอมาและปกป้องโลก ซึ่งเป็นจุดเริ่มต้นของซีรีส์ Dragon Quest ทั้งหมด', '{}', 3, false),
  
  -- Dragon Quest XI
  (uuid_generate_v5(uuid_nil(), 'dragon-quest-xi--------------------001'), 'dragon-quest-xi--------------------001', 'Dragon Quest XI', 'เรื่องราวของผู้ส่องแสงผู้ถูกเลือก ผู้ออกเดินทางเพื่อค้นหาความจริงเกี่ยวกับตัวตนของตนเอง และต่อสู้กับความมืดที่คุกคามโลก', '{}', 4, false);
