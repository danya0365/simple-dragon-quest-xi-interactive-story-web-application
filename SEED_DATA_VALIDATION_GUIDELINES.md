# Seed Data Validation Guidelines

## ปัญหาที่พบ
เมื่อไม่นานมานี้ เราพบปัญหาที่ seed data ใน `001-dragon_quest_story_data.sql` มีข้อมูลไม่ถูกต้อง:
- บาง outcomes มี `next_event_id = null` แต่ไม่มี `unlock_events` effects
- ทำให้ผู้เล่นติดอยู่ในเกมและไม่สามารถก้าวหน้าต่อไปได้

## วิธีแก้ปัญหาในอนาคต

### 1. ใช้ Validation Scripts

เราได้สร้าง scripts สำหรับ validation ขึ้นมาแล้ว:

```bash
# Run validation
node scripts/validate-seed-data-final.js
```

### 2. Pre-commit Hooks

เพิ่ม script นี้ใน pre-commit hooks เพื่อตรวจสอบก่อน commit:

```json
// package.json
{
  "husky": {
    "hooks": {
      "pre-commit": "node scripts/validate-seed-data-final.js"
    }
  }
}
```

### 3. กฎการ Validation

#### กฎที่ 1: Outcome Progression Check
- **กฎ**: ทุก outcome ต้องมี `next_event_id` หรือ `unlock_events` effects
- **เหตุผล**: ป้องกันไม่ให้ผู้เล่นติดอยู่ในเกม
- **ตัวอย่างที่ถูกต้อง**:
  ```sql
  -- มี next_event_id
  ('outcome_id', 'interaction_id', 'choice_id', 'story', 'Title', 'Description', '{}', 'next_event_uuid')
  
  -- มี unlock_events effects
  ('outcome_id', 'interaction_id', 'choice_id', 'story', 'Title', 'Description', '{"unlock_events": ["event_uuid"]}', null)
  ```

#### กฎที่ 2: Event Interactions Check
- **กฎ**: ทุก event ต้องมีอย่างน้อย 1 interaction
- **เหตุผล**: ป้องกัน event ที่ไม่สามารถเล่นได้

#### กฎที่ 3: Interaction Outcomes Check
- **กฎ**: ทุก interaction ต้องมีอย่างน้อย 1 outcome
- **เหตุผล**: ป้องกัน interaction ที่ไม่มีผลลัพธ์

#### กฎที่ 4: Next Event Existence Check
- **กฎ**: `next_event_id` ต้อง reference ถึง event ที่มีอยู่จริง
- **เหตุผล**: ป้องกัน broken links

#### กฎที่ 5: Effects JSON Validation
- **กฎ**: effects field ต้องเป็น JSON ที่ถูกต้อง
- **เหตุผล**: ป้องกัน runtime errors

### 4. ขั้นตอนการเพิ่มข้อมูลใหม่

#### ขั้นตอนที่ 1: เพิ่ม Event
```sql
INSERT INTO public.story_events (id, chapter_id, location_id, title, description, event_type, is_unlocked, display_order) VALUES
('new-event-uuid', 'chapter-uuid', 'location-uuid', 'Event Title', 'Description', 'dialogue', false, 1);
```

#### ขั้นตอนที่ 2: เพิ่ม Interactions
```sql
INSERT INTO public.event_interactions (id, event_id, interaction_type, title, description, dialogue_text, character_speaker, choices, display_order) VALUES
('interaction-uuid', 'new-event-uuid', 'talk', 'Talk Title', 'Description', 'Dialogue text', 'Character', '[]', 1);
```

#### ขั้นตอนที่ 3: เพิ่ม Outcomes
```sql
INSERT INTO public.event_outcomes (id, interaction_id, choice_id, outcome_type, title, description, effects, next_event_id) VALUES
-- ถ้าจะให้ไป event ถัดไป直接
('outcome-uuid', 'interaction-uuid', 'choice-id', 'story', 'Outcome Title', 'Description', '{}', 'next-event-uuid'),

-- ถ้าจะปลดล็อก events หลายตัว
('outcome-uuid', 'interaction-uuid', 'choice-id', 'story', 'Outcome Title', 'Description', '{"unlock_events": ["event1-uuid", "event2-uuid"]}', null);
```

### 5. Testing

#### หลังจากแก้ไข seed data:
```bash
# 1. Run validation
node scripts/validate-seed-data-final.js

# 2. Reset database
supabase db reset

# 3. Test in application
npm run dev
```

### 6. Code Review Checklist

เมื่อมีการเปลี่ยนแปลง seed data ให้ตรวจสอบ:

- [ ] ทุก outcome มี `next_event_id` หรือ `unlock_events` effects
- [ ] `next_event_id` ชี้ไปยัง event ที่มีอยู่จริง
- [ ] `unlock_events` ชี้ไปยัง events ที่มีอยู่จริง
- [ ] Effects JSON ถูกต้อง
- [ ] ไม่มี events หรือ interactions ที่ไม่มี outcomes
- [ ] Run validation script ผ่าน
- [ ] Test ใน application ว่าเกม flow ทำงานถูกต้อง

### 7. Automated Testing

สร้าง automated tests เพื่อตรวจสอบ game flow:

```javascript
// Example test
describe('Game Flow', () => {
  it('should not allow player to get stuck', async () => {
    // Test that every interaction leads to progression
  });
  
  it('should unlock new events when appropriate', async () => {
    // Test that unlock_events work correctly
  });
});
```

### 8. Documentation

อัพเดท documentation เมื่อมีการเปลี่ยนแปลง:
- เพิ่ม flow chart ของเนื้อเรื่อง
- อัพเดท event relationships
- เพิ่มข้อมูลเกี่ยวกับ progression paths

## สรุป

การมี validation process ที่ดีจะช่วยป้องกันปัญหา seed data ที่ไม่ถูกต้อง:
1. **Prevention**: ใช้ validation scripts และ pre-commit hooks
2. **Detection**: มี automated tests และ validation rules
3. **Correction**: มี process สำหรับแก้ไขและทดสอบ
4. **Documentation**: มี guidelines ที่ชัดเจนสำหรับทีม

การทำตาม guidelines เหล่านี้จะช่วยให้เราหลีกเลี่ยงปัญหาที่ทำให้ผู้เล่นติดอยู่ในเกมได้ในอนาคต
