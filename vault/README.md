# vault

Obsidian — **issues รายวัน (ไฟล์เดียวต่อวัน)** · **learnings หลังแก้ปัญหา ≥3 prompt**

## โครงสร้าง

```
vault/
├── templates/
│   ├── template.learning.md
│   └── template.issue.md
├── issues/
│   └── YYYY-MM-DD.md    ← วันละไฟล์ — หลายเรื่องเป็น ## 1, ## 2, …
└── learnings/           ← ไฟล์ต่อ lesson
```

## ใช้ยังไง

| สถานการณ์ | ที่เก็บ |
|-----------|---------|
| ถาม / ประเด็นประจำวัน | `issues/2026-05-24.md` (append ต่อวัน) |
| ติดปัญหา แก้ด้วย prompt ≥3 ครั้ง | `learnings/*.md` |

ตัวอย่าง: วันเดียวมี 5 คำถาม → ไฟล์เดียว 5 sections

**ภาษา:** เนื้อหาใน vault = **English** (ลด token) · แชทกับ user = **~70% ไทย / ~30% English**

รายละเอียด: [ai-rules/vault-learning](../ai-rules/vault-learning/reference.md)

เปิด Obsidian ที่ **repo root**

## Git

`issues/` + `learnings/` = local only
