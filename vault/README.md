# vault

Obsidian — **issues รายวัน (ไฟล์เดียวต่อวัน)** · **learnings หลังแก้ปัญหา ≥3 prompt**

## โครงสร้าง

```
vault/
├── templates/       ← git
├── issues/
│   ├── README.md    ← git (placeholder)
│   └── YYYY-MM-DD.md    ← local
└── learnings/
    ├── README.md    ← git (placeholder)
    └── *-learning.md    ← local
```

## ใช้ยังไง

| สถานการณ์ | ที่เก็บ |
|-----------|---------|
| ถามเรื่องงาน / repo / vault / tools | `issues/YYYY-MM-DD.md` (append) |
| อากาศ / chitchat / trivia | **ไม่** เขียน issues |
| ติดปัญหา แก้ด้วย prompt ≥3 ครั้ง | `learnings/*.md` |

ตัวอย่าง: วันเดียวมี 5 คำถาม → ไฟล์เดียว 5 sections

**ภาษา:** เนื้อหาใน vault = **English** (ลด token) · แชทกับ user = **~70% ไทย / ~30% English**

รายละเอียด: [ai-rules/vault-learning](../ai-rules/vault-learning/reference.md)

เปิด Obsidian ที่ **repo root**

## Git

`issues/*.md` + `learnings/*-learning.md` = local only · **README.md** ในแต่ละโฟลเดอร์ track ใน git
