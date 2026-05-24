# vault

โฟลเดอร์ส่วนตัวสำหรับ note, draft, learnings, scratch — **ไม่ถูก push ขึ้น Git**

## ใช้ยังไง

- สร้างไฟล์/โฟลเดอร์ใต้ `vault/` ได้ตามต้องการ
- Git จะ ignore ทุกอย่างในนี้ **ยกเว้น** ไฟล์ `README.md` นี้
- เหมาะกับ Obsidian, draft skill, บันทึก session, โน้ตโปรเจกต์

## ตัวอย่างโครงสร้าง (local เท่านั้น)

```
vault/
├── README.md          ← track ใน git (คำอธิบาย)
├── notes/             ← ไม่ track
├── drafts/            ← ไม่ track
└── learnings/         ← ไม่ track
```

## Obsidian

ถ้าเปิด `vault/` เป็น Obsidian vault — โฟลเดอร์ `.obsidian/` จะถูก ignore ด้วย (อยู่ใต้ `vault/*`)
