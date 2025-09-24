# Dragon Quest Seed Data Guidelines

## ข้อกำหนดสำหรับการสร้าง Seed Data

### 1. Event Interactions Rules

#### 1.1 Interactions ที่มี Choices (เลือกตัวเลือก)

```sql
-- ต้องมี choices ในรูปแบบ JSON array
choices: '[{"id": "choice1", "text": "ตัวเลือกที่ 1", "type": "friendly"}, ...]'

-- ต้องมี outcomes สำหรับทุก choice
INSERT INTO event_outcomes (interaction_id, choice_key, ...) VALUES
('interaction_id', 'choice1', ...),
('interaction_id', 'choice2', ...);
```

#### 1.2 Interactions ที่ไม่มี Choices (คลิกเดียวจบ)

```sql
-- ไม่ต้องมี choices หรือใส่ '[]'
choices: '[]'

-- ต้องมี default outcome เสมอ
INSERT INTO event_outcomes (interaction_id, choice_key, ...) VALUES
('interaction_id', 'default', ...);
```

### 2. Event Outcomes Rules

#### 2.1 Default Outcomes (สำหรับ interactions ไม่มี choices)

```sql
-- ต้องใช้ choice_key = 'default'
choice_key: 'default'

-- ควรมี effects หรือ next_event_id
effects: '{"items": [{"id": "item_id", "quantity": 1}]}'
-- หรือ
next_event_id: 'next_interaction_id'
```

#### 2.2 Choice Outcomes (สำหรับ interactions มี choices)

```sql
-- ต้องใช้ choice_key ตรงกับ choices ใน interaction
choice_key: 'choice1'  -- ตรงกับ id ใน choices array

-- ควรมี effects และ next_event_id
effects: '{"party_join": "character_id", "items": [...]}'
next_event_id: 'next_event_id'
```

### 3. Story Flow Rules

#### 3.1 Chapter Progression

```sql
-- บทแรกต้อง unlocked เสมอ
is_unlocked: true  -- สำหรับ chapter 1

-- บทถัดไปต้อง locked และ unlock ผ่าน outcomes
is_unlocked: false  -- สำหรับ chapter 2, 3, ...
```

#### 3.2 Event Progression

```sql
-- event แรกของแต่ละบทต้อง unlocked
is_unlocked: true  -- สำหรับ event แรก

-- event ถัดไป unlock ผ่าน outcomes
effects: '{"unlock_events": ["next_event_id"]}'
-- หรือ
next_event_id: 'next_event_id'
```

### 4. Validation Functions

#### 4.1 ตรวจสอบ Interactions และ Outcomes

```sql
-- เรียกใช้ validation function
SELECT * FROM validate_interactions_outcomes();

-- ผลลัพธ์ที่ควรได้:
-- is_valid: true สำหรับทุก interaction
-- issues: [] ไม่มี issues
```

#### 4.2 ตรวจสอบ Story Flow

```sql
-- เรียกใช้ story flow validation
SELECT * FROM validate_story_flow();

-- ผลลัพธ์ที่ควรได้:
-- is_valid: true สำหรับทุก chapter
-- has_starting_event: true
-- issues: []
```

#### 4.3 สร้าง Default Outcomes อัตโนมัติ

```sql
-- สร้าง default outcomes ที่ขาดหายไป
SELECT * FROM generate_missing_default_outcomes();
```

### 5. Best Practices

#### 5.1 Naming Conventions

```sql
-- Interaction IDs: 77777777-7777-7777-7777-777777777XXX
-- Outcome IDs: 88888888-8888-8888-8888-888888888XXX
-- Choice IDs: ใช้คำที่สื่อความหมาย เช่น 'friendly', 'suspicious', 'default'
```

#### 5.2 Data Integrity

```sql
-- ตรวจสอบ foreign keys ก่อน insert
-- ตรวจสอบ JSON format ก่อน insert
-- ตรวจสอบ UUID format ก่อน insert
```

#### 5.3 Testing

```sql
-- ทดสอบ complete_interaction function สำหรับทุก interaction
-- ทดสอบ story flow จากต้นจนจบ
-- ทดสอบ unlock mechanism ทุกจุด
```

### 6. Common Issues and Solutions

#### 6.1 Issue: Interaction ไม่มี outcome

```sql
-- สาเหตุ: ลืมสร้าง outcome สำหรับ interaction ที่ไม่มี choices
-- แก้ไข: เพิ่ม default outcome
INSERT INTO event_outcomes (interaction_id, choice_key, outcome_type, title, description, effects, next_event_id)
VALUES ('interaction_id', 'default', 'story', 'Default Action', 'Completed', '{}', 'next_interaction_id');
```

#### 6.2 Issue: Story flow ติดขัด

```sql
-- สาเหตุ: ไม่มี next_event_id หรือ unlock_events ใน outcomes
-- แก้ไข: เพิ่ม next_event_id หรือ unlock_events ใน effects
UPDATE event_outcomes
SET next_event_id = 'next_event_id'
WHERE interaction_id = 'current_interaction_id';
```

#### 6.3 Issue: Choices ไม่ทำงาน

```sql
-- สาเหตุ: choice_key ใน outcomes ไม่ตรงกับ id ใน choices
-- แก้ไข: ตรวจสอบให้ choice_key ตรงกัน
SELECT ei.choices, eo.choice_key
FROM event_interactions ei
JOIN event_outcomes eo ON ei.id = eo.interaction_id;
```

### 7. Migration Checklist

ก่อนสร้าง seed data ใหม่:

- [ ] ตรวจสอบ interactions ทุกตัวมี outcomes ครบถ้วน
- [ ] ตรวจสอบ story flow ต่อเนื่อง
- [ ] รัน validation functions
- [ ] ทดสอบ complete_interaction สำหรับทุก interaction
- [ ] ทดสอบ story flow จากต้นจนจบ
- [ ] ตรวจสอบ foreign keys และ data types
