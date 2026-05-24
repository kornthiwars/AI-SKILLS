# AI-SKILLS

Repository สำหรับ **Cursor Agent Skills + Rules**

**Universal:** [AGENTS.md](AGENTS.md) · **Skills:** [ai-skills/](ai-skills/README.md) · **Rules:** [ai-rules/](ai-rules/README.md)

---

## เริ่มต้น

**Cursor (ครั้งแรกหลัง clone):**

```powershell
cmd /c mklink /J .cursor\skills ai-skills
cmd /c mklink /J .cursor\rules ai-rules
cmd /c mklink /J .claude\skills ai-skills
cmd /c mklink /J .claude\rules ai-rules
```

→ [.cursor/README.md](.cursor/README.md) · [.claude/README.md](.claude/README.md) · reload Cursor

1. เรียก `@ui-builder`, `@debug`, `@git-push` ฯลฯ
2. **Obsidian** — เปิด repo root เป็น vault · [vault/](vault/README.md)

---

## โครงสร้าง

```
ai-skills/          canonical
ai-rules/           canonical
templates/          vault note templates (repo root)
.cursor/            junction → ai-skills, ai-rules
.claude/            junction → ai-skills, ai-rules
AGENTS.md · CLAUDE.md
vault/
```

---

## Skills

Versions: [ai-skills/README.md](ai-skills/README.md) (table at top)

| Skill | ใช้เมื่อ |
|-------|----------|
| [@feature-builder](ai-skills/feature-builder/SKILL.md) | ฟีเจอร์ครบ FE+BE |
| [@api-builder](ai-skills/api-builder/SKILL.md) | API, contract |
| [@ui-builder](ai-skills/ui-builder/SKILL.md) | UI ตรง mockup |
| [@debug](ai-skills/debug/SKILL.md) | logic บนจอผิด |
| [@pr-review](ai-skills/pr-review/SKILL.md) | review ก่อน push |
| [@git-push](ai-skills/git-push/SKILL.md) | commit + push |
| [@upgrade](ai-skills/upgrade/SKILL.md) | แก้ skill ใน repo |

Ship flow: `implement → @pr-review → @git-push` — [ai-skills/README.md](ai-skills/README.md)
