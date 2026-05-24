# AI-SKILLS

Repository สำหรับ **Cursor Agent Skills** — workflow ช่วย AI ทำงาน FE, BE, debug, review และ push git อย่างมีขั้นตอน

เนื้อหาทั้งหมดอยู่ในโฟลเดอร์ **[`ai-skills/`](ai-skills/README.md)**

---

## เริ่มต้น

1. เปิด [`ai-skills/README.md`](ai-skills/README.md) — ดูว่า **เมื่อไหร่ควรใช้ skill ไหน**
2. ติดตั้ง mirror (optional) — copy/link แต่ละ skill ไป `.cursor/skills/<name>/`
3. เรียกในแชทด้วย `@ui-builder`, `@api-builder`, `@debug` ฯลฯ

---

## Skills (v1.0.0)

| Skill | ใช้เมื่อ |
|-------|----------|
| [@feature-builder](ai-skills/feature-builder/SKILL.md) | ฟีเจอร์ครบ FE+BE (login, checkout) |
| [@api-builder](ai-skills/api-builder/SKILL.md) | สร้าง/แก้ API, contract, migration |
| [@ui-builder](ai-skills/ui-builder/SKILL.md) | UI ตรง mockup / Figma / screenshot |
| [@debug](ai-skills/debug/SKILL.md) | ข้อมูลหรือ logic บนจอผิด (API ถูกแล้ว) |
| [@pr-review](ai-skills/pr-review/SKILL.md) | self-review ก่อน push / PR |
| [@git-push](ai-skills/git-push/SKILL.md) | commit + push ปลอดภัย |
| [@upgrade](ai-skills/upgrade/SKILL.md) | แก้ skill ใน repo นี้ |

---

## โครงสร้าง repo

```
AI-SKILLS/
├── README.md           ← ไฟล์นี้
└── ai-skills/
    ├── README.md       ← คู่มือเต็ม + เลือก skill
    ├── SKILL-AUTHORING.md
    └── <skill-name>/
        ├── SKILL.md
        ├── reference.md
        └── assets/
```

---

## Ship flow (app repo)

```
implement → @pr-review → ready → @git-push
```

รายละเอียด cross-skill, required inputs และ flow อื่นๆ → [`ai-skills/README.md`](ai-skills/README.md)
