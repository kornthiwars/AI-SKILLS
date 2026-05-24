# Vault layout

> Rules: [vault-learning.mdc](../vault-learning.mdc)

## โครงสร้าง

```
vault/
├── templates/
│   ├── template.learning.md    ← Problem · Fix · Don't repeat (EN)
│   └── template.issue.md       ← daily sections; **English** body
├── learnings/                  ← ไฟล์ต่อ lesson (≥3 prompt rounds)
└── issues/
    └── YYYY-MM-DD.md           ← ไฟล์เดียวต่อวัน — หลายเรื่องในไฟล์เดียวกัน
```

## Issues รายวัน

```
vault/issues/2026-05-24.md
├── ## 1. เรื่องแรก
├── ## 2. เรื่องที่สอง
└── ## 5. เรื่องที่ห้า   ← วันเดียวกัน 5 เรื่อง = 5 sections
```

Agent **append** each substantive Q&A — one file per day. **Write vault in English**; chat replies stay ~70% ไทย / ~30% English.

## Flow

```
ถามทั่วไป / ประจำวัน     → issues/YYYY-MM-DD.md (append)
ติดปัญหา + prompt ≥3 รอบ → learnings/ (ไฟล์แยก)
debug หนัก              → อ่าน learnings/ ก่อน
```

## นับ "3 รอบ" (learnings)

นับ **ข้อความ user** ที่เกี่ยวกับปัญหาเดียวกันในแชทนี้ (ไม่นับทักทาย). รอบที่ 3 ขึ้นไป + แก้ได้ → เขียน learning

## Obsidian

- Vault root = repo root
- Daily note pattern: `vault/issues/{{date}}.md` (optional)

## Git

`learnings/` + `issues/` local only · `templates/` in git
