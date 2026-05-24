# Skill authoring

> อ่านก่อนสร้างหรือแก้ skill. ตัวอย่าง gold: [`ui-builder/`](ui-builder/SKILL.md), [`api-builder/`](api-builder/SKILL.md).

## แนวที่ใช้ใน repo นี้

| แนว | นำมาใช้เป็น |
|-----|-------------|
| Progressive disclosure | รายละเอียดใน `reference.md` + `assets/` — ไม่ยัดทุกอย่างใน `SKILL.md` |
| Token efficiency | หนึ่ง `@skill` ต่อเทิร์น · อ่าน `reference` / `assets` เฉพาะขั้นที่ถึง — ดู § Token efficiency |
| Agent discipline | `reference.md` § Common rationalizations + Red flags (โหลดเมื่อ agent ข้ามขั้น) |
| WHEN NOT ใน description | ลด skill ถูกเรียกผิดบริบท |
| Pre-delivery self-check | checklist ใน `assets/checklist.*` หรือขั้น deliver ใน `SKILL.md` / `reference.md` |
| Hard rules ด้านบน | `## Hard rules` |
| Operating stance + ลำดับขั้น | `## Operating stance`, workflow เป็นขั้น |
| Required inputs | ปฏิเสธงานเมื่อข้อมูลไม่ครบ |
| Output flow | `## Output flow` — ลำดับ deliver ชัด |

## โครงสร้าง repo (ปัจจุบัน)

```
ai-skills/                         # repo root (canonical)
├── README.md                      # สารบัญ skill
├── SKILL-AUTHORING.md             # ไฟล์นี้
├── ui-builder/
├── api-builder/
├── feature-builder/               # orchestrate FE+BE → api + ui
├── debug/                         # data/logic diagnosis
├── upgrade/                       # maintain skills ใน repo นี้
├── pr-review/                     # self-review ก่อน push
└── git-push/                      # sole git CLI skill
```

**Mirror ใน IDE (optional):** `.cursor/skills/<name>/` · `.claude/skills/<name>/` — copy/link จาก canonical ด้านบน

### โครงสร้างต่อ skill

```
<skill-name>/
├── SKILL.md              # บังคับ — workflow, gates, hard rules (agentskills.io)
├── reference.md          # รายละเอียดลึก, pitfalls, gate forms
└── assets/               # optional — template.* · checklist.*
    ├── template.{topic}.md
    └── checklist.{topic}.md
```

**ชื่อ skill** (`name: ui-builder`) ต้องตรงกับชื่อโฟลเดอร์ `<skill-name>/` — mirror ใช้ชื่อเดียวกันเพื่อ `@ui-builder`.

### Skills ใน repo + assets

| Skill | มี `assets/` | ไฟล์ใน `assets/` |
|-------|--------------|------------------|
| [ui-builder](ui-builder/SKILL.md) | ✓ | `template.viewport-spec`, `template.breakpoints-spec`, `template.gate-b`, `checklist.quality-tier` |
| [api-builder](api-builder/SKILL.md) | ✓ | `template.contract-spec`, `template.crud-pack`, `template.endpoint-delta`, `template.handoff-to-ui` |
| [feature-builder](feature-builder/SKILL.md) | ✓ | `template.feature-spec`, `template.phase-plan`, `template.ui-invoke-packet`, `checklist.integration` |
| [debug](debug/SKILL.md) | ✓ | `template.repro`, `template.evidence`, `template.diagnosis-report`, `template.breadcrumb-ledger`, `template.post-fix-learning` |
| [pr-review](pr-review/SKILL.md) | ✓ | `template.review-comment` |
| [git-push](git-push/SKILL.md) | — | (reference only) |
| [upgrade](upgrade/SKILL.md) | — | (reference only) |

## Git operations — `@pr-review` then `@git-push`

**App repos (ship finished work):**

```
implement → @pr-review (select mode) → ready → @git-push
```

| กฎ | รายละเอียด |
|-----|-------------|
| **เจ้าของ git CLI** | เฉพาะ [`git-push`](git-push/SKILL.md) |
| **self-review ก่อน push** | [`pr-review`](pr-review/SKILL.md) — ไม่รัน git; AskQuestion โหมดถ้า user ไม่ระบุ |
| **skill อื่น** | **ห้าม** รัน git CLI → hand off **`@pr-review`** แล้ว **`@git-push`** |
| **skills repo นี้** | แก้ canonical ด้วย `@upgrade` — ship ด้วย `@git-push` |
| **Hard rules template** | `- **No git commands** — … ship → @pr-review then @git-push` |

## Token efficiency

Agent Skills โหลดเป็น 3 ชั้น ([agentskills.io](https://agentskills.io/specification)): (1) `description` ตอน discover (2) `SKILL.md` เต็มเมื่อ invoke (3) `reference.md` / `assets/` เมื่อ agent อ่านไฟล์

### กฎสำหรับ agent

| กฎ | รายละเอียด |
|-----|-------------|
| **หนึ่ง skill ต่อเทิร์น** | ส่งต่อ cross-skill แทนรวมหลาย `@skill` |
| **`disable-model-invocation: true`** | บังคับ — ไม่ auto-โหลด SKILL.md ทุกแชท |
| **อ่าน reference ตามขั้น** | “Load [reference.md](reference.md) § X” **ที่ขั้น X** |
| **อ่าน assets เมื่อถึง gate** | `assets/template.*` / `assets/checklist.*` — เปิดเมื่อ post Gate หรือ deliver |
| **description สั้น แม่น** | WHAT + WHEN NOT — อย่ายัด workflow |
| **pr-review โหมดเดียว** | `bugs` / `production` / `scale-security` — ไม่รันทั้ง 3 ถ้าไม่จำเป็น |
| **หลัง pr-review `ready`** | `@git-push` R1–R10 **เฉพาะ gap** |

### สำหรับผู้เขียน skill

- เป้า **SKILL.md ต่ำกว่า 500 บรรทัด** — รายละเอียดยาว → `reference.md`
- **Quick reference** ตาราง Phase | Load | Outcome
- **Output flow** ท้าย SKILL — ไม่ซ้ำย่อหน้าเดียวกันใน reference

### โหลด skill ตาม phase (app repo)

| Phase | Skill |
|-------|--------|
| สเปก / ฟีเจอร์ทั้งก้อน | `@feature-builder` |
| API | `@api-builder` |
| UI ตรงรูป | `@ui-builder` |
| ข้อมูล/logic ผิด | `@debug` |
| รีวิวก่อน push | `@pr-review` |
| commit/push | `@git-push` |
| แก้ skill ใน repo นี้ | `@upgrade` |

### อย่าทำ

- รวมหลาย skill เป็นไฟล์เดียว
- ตัด Hard rules / Gate เพื่อสั้น
- ยัด incident ทุกโปรเจกต์เข้า `SKILL.md` canonical

## Language (70% ไทย / 30% อังกฤษ)

**SKILL.md file:** English body. Thai triggers ใน `description` ถ้าต้องการ.

**Replies to user:**

| Layer | ~% | Use for |
|-------|-----|---------|
| **ไทย** | **70** | อธิบาย, สรุป, คำถาม, ขั้นถัดไป, หัวตาราง, trade-off |
| **อังกฤษ** | **30** | Gate/phase labels, industry terms, mode ids, pitfall #N |

| Rule | Detail |
|------|--------|
| **Mix** | ประโยคไทยปน EN term — อย่า reply อังกฤษทั้งก้อน |
| **Gloss** | ศัพท์ EN ที่อาจสับสน → ไทยในวงเล็บ **ครั้งแรกต่อ reply** |
| **Do not translate** | paths, `@skill`, โค้ด, คำสั่ง git/shell |

ตัวอย่าง block: [api-builder/SKILL.md § Language](api-builder/SKILL.md)

## SKILL.md skeleton

```markdown
---
name: skill-name
description: >-
  [WHAT]. Triggers on /skill-name, @skill-name, … Does not apply when …
disable-model-invocation: true
metadata:
  version: "x.y.z"
---

# Title
One-sentence job.

## Language
(70% ไทย / 30% อังกฤษ — see SKILL-AUTHORING.md)

## Operating stance
(bullets)

## Required inputs — refuse without these
- [ ] …

## Hard rules
- …

## Quick reference
| Phase | Load | Outcome |

## Workflow
Run in order.

## Output flow
1. …

## Resources
| File | Use when |
|------|----------|
| [reference.md](reference.md) | … |
| [assets/template.example.md](assets/template.example.md) | … |
```

## Frontmatter

```yaml
disable-model-invocation: true
compatibility: …
metadata:
  version: "x.y.z"
  author: kornthiwars
  license: MIT
  surfaces: [ide]
```

## Asset naming (`assets/`)

| Prefix | Use | Example |
|--------|-----|---------|
| `template.` | แบบฟอร์มกรอก / paste ใน chat | `template.contract-spec.md` |
| `checklist.` | รายการตรวจก่อนส่ง | `checklist.quality-tier.md` |

**Rules:** kebab-case · **no digits** in filename · no phase codes (`f4`, `fe`) · topic = สิ่งที่ไฟล์ทำ ไม่ใช่ลำดับขั้น

Skill ที่ไม่มี template/checklist (เช่น `git-push`, `upgrade`) — ใช้แค่ `SKILL.md` + `reference.md`.

## หลังแก้ skill (verify)

1. แก้ `<skill-name>/` ใน repo นี้เท่านั้น (ชื่อโฟลเดอร์ = `name:` ใน SKILL.md)
2. ตรวจ cross-ref — ลิงก์ใน `SKILL.md` / `reference.md` ชี้ไฟล์ที่มีจริง
3. bump `metadata.version` (PATCH / MINOR / MAJOR) ตามการเปลี่ยน workflow
4. อัป [README.md](README.md) ถ้าเพิ่ม skill ใหม่
5. copy/link ไป `.cursor/skills/<name>/` ถ้าใช้ mirror
6. ship ด้วย `@git-push` เมื่อ user ขอ commit

## Project learnings (app repo — ไม่ commit ใน skills repo)

เมื่องานกินเวลา (≥2 รอบ / bug ซ้ำ):

1. **อย่า** ยัดยาวใน `SKILL.md` canonical
2. เสนอ append **5–12 บรรทัด** ในโปรเจกต์เป้าหมาย: `.cursor/learnings.md` — **ถาม user ก่อน**
3. แท็ก skill: `#ui-builder` `#debug` `#git` · มี index ถ้าหัวข้อเยอะ
4. โปรเจกต์นั้น gitignore หรือ commit learnings เอง — ไม่ push เข้า `ai-skills`

## Agent discipline (Rationalizations + Red flags)

ใส่ใน **`reference.md`** — โหลดเมื่อ agent ข้ามขั้นหรือ rubber-stamp

| Rationalization | Reality |
|-----------------|---------|
| *(ข้อแก้ตัวที่ agent มักพูด)* | *(ทำไมขั้นใน SKILL ยังบังคับ)* |

**Red flags:** พฤติกรรมที่ต้องหยุด · ต้องมีหลักฐานก่อน Approved / Confirmed / `ready` / push

ตัวอย่าง: [ui-builder/reference.md](ui-builder/reference.md)

## Checklist ก่อน ship skill

- [ ] `disable-model-invocation: true` · description สั้น + WHEN NOT
- [ ] `## Language` — 70% ไทย / 30% อังกฤษ
- [ ] `reference.md` มี § Common rationalizations + § Red flags (ถ้า skill มี gate)
- [ ] `assets/` ชื่อ `template.*` / `checklist.*` · ไม่มี digit · cross-ref ครบ
- [ ] Required inputs + Hard rules + Output flow
- [ ] ลิงก์ cross-skill ถูก `@name` และ path
- [ ] `SKILL.md` < 500 บรรทัด
- [ ] README.md มีแถว skill (ถ้า skill ใหม่)
