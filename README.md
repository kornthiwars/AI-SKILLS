# AI-SKILLS

Repository สำหรับ **Cursor Agent Skills + Rules**

**Universal:** [AGENTS.md](AGENTS.md) · **Skills:** [ai-skills/](ai-skills/README.md) · **Rules:** [ai-rules/](ai-rules/README.md)

---

## ติดตั้ง

### สิ่งที่ต้องมี

| รายการ | ใช้ทำอะไร |
|--------|-----------|
| [Git](https://git-scm.com/) | clone repo |
| [Cursor](https://cursor.com/) | ใช้ `@skill` จาก `ai-skills/` |
| PowerShell 5.1+ (Windows) หรือ `bash` (macOS/Linux) | รัน setup script |
| Obsidian (ถ้าต้องการ vault) | เปิด repo root เป็น vault — ไม่บังคับ |

### 1 — Clone

```bash
git clone https://github.com/kornthiwars/AI-SKILLS.git
cd AI-SKILLS
```

### 2 — Setup (ครั้งเดียวหลัง clone)

สคริปต์สร้าง link ใต้ **โฟลเดอร์ที่เปิดใน Cursor** (install root): `.cursor/skills`, `.cursor/rules`, `.cursor/vault` + `ai-skills-vault.json`  
เนื้อหา vault จริงอยู่ใน `AI-SKILLS/vault/` (ผ่าน link)

**Windows** — ดับเบิลคลิก `scripts\setup-windows.bat` (workspace = repo) หรือ:

```powershell
cd AI-SKILLS
.\scripts\setup-windows.ps1 -InstallRoot C:\path\to\workspace
```

| เปิด Cursor ที่ | รัน (จากใน clone) |
|-----------------|-------------------|
| `AI-SKILLS` | `.\scripts\setup-windows.ps1 -InstallRoot .` |
| โฟลเดอร์แม่ `SK/` | `.\scripts\setup-windows.ps1 -InstallRoot ..` |

**macOS / Linux:**

```bash
cd AI-SKILLS
chmod +x scripts/setup-macos-linux.sh
./scripts/setup-macos-linux.sh .    # workspace = AI-SKILLS
./scripts/setup-macos-linux.sh ..   # workspace = parent
```

รายละเอียด / troubleshooting: [scripts/README.md](scripts/README.md)

| ปัญหา | แก้ |
|--------|-----|
| Windows `mklink` ล้มเหลว | เปิด PowerShell **Run as administrator** แล้วรัน `.\scripts\setup-windows.ps1` อีกครั้ง |
| `.cursor/skills` มีอยู่แล้วแต่ไม่ใช่ link | ลบโฟลเดอร์นั้น (ถ้าไม่มีงานสำคัญ) แล้วรัน setup ใหม่ |

### 3 — เปิดใน Cursor

1. **File → Open Folder** → เลือกโฟลเดอร์ `AI-SKILLS` (repo root)
2. **Developer: Reload Window** (หรือปิดเปิด Cursor ใหม่)
3. ในแชทลอง `@ui-builder`, `@debug`, `@git-push` ฯลฯ

แก้ skill / rule ที่ canonical เท่านั้น: `ai-skills/`, `ai-rules/` — อย่าแก้ใน `.cursor/` (เป็น link/mirror)

### 4 — Obsidian (ถ้าใช้ vault)

1. เปิด **repo root** (`AI-SKILLS`) เป็น vault — ไม่ใช่แค่โฟลเดอร์ `vault/`
2. Templates อยู่ที่ `templates/` (repo root)
3. ดู [vault/README.md](vault/README.md)

### ติดตั้งมือ (ไม่ใช้ script)

ดูคำสั่ง `mklink` / `ln` ใน [scripts/README.md](scripts/README.md) และ [AGENTS.md](AGENTS.md) § Setup

---

## เริ่มใช้

- Ship งาน: `implement → @pr-review → @git-push` — [ai-skills/README.md](ai-skills/README.md)
- แก้ skill ใน repo นี้: `@upgrade`

---

## โครงสร้าง

```
ai-skills/          canonical
ai-rules/           canonical
templates/          vault note templates (repo root)
.cursor/            at workspace root after setup (skills, rules, vault)
AGENTS.md · CLAUDE.md
vault/              canonical in clone
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
