---
name: upgrade
description: >-
  Maintains and upgrades other skills in this repo — audit outdated or wrong content,
  fix to match SKILL-AUTHORING and gold skills (ui-builder, api-builder), bump
  semver. Triggers on /upgrade, @upgrade, skill upgrade,
  อัปเกรด skill, อัพเกรด skill, แก้ skill, skill ล่าสมัย, skill ผิด, ข้อดีข้อเสีย, ลด token, ประหยัด token.
  Does not apply to building app UI (ui-builder), API contracts (api-builder),
  or git push (git-push). Install-only mirror checks: mention briefly after fix.
disable-model-invocation: true
metadata:
  version: "1.0.0"
  author: kornthiwars
  license: MIT
  surfaces:
    - ide
---

# Skill upgrade

**Job:** พัฒนาและแก้ **skill อื่น** ใน repo นี้ที่ **ล่าสมัย ผิด หรือไม่ตรงมาตรฐาน** — ให้สอดคล้องกับที่ Ford ออกแบบไว้ใน [SKILL-AUTHORING.md](../SKILL-AUTHORING.md) และ skill ตัวอย่าง (`ui-builder`, `api-builder`)

**ไม่ใช่:** ตรวจ mirror/global เป็นหลัก (ทำสั้นๆ หลังแก้ canonical เท่านั้น) · ไม่ทำ UI/API ในโปรเจกต์ลูก

Checklist ละเอียด: [reference.md](reference.md)

## Operating stance

- **Canonical only** — แก้ใต้ `skills/<name>/` เท่านั้น
- **มาตรฐานคือกฎ** — [SKILL-AUTHORING.md](../SKILL-AUTHORING.md) + [reference.md](reference.md) + skill ตัวอย่างที่ใกล้เคียง
- **เสนอก่อน แก้หลังยืนยัน** — สรุป findings + แผน + **ข้อดี/ข้อเสีย** + semver แล้วถาม scope ก่อนแตะไฟล์
- **Trade-offs บังคับ** — ทุกแผนอัปเกรดต้องมีข้อดีและข้อเสียชัดเจน (ไม่ rubber-stamp ว่าแก้แล้วดีเสมอ)
- **แก้จริง** — หลัง user ยืนยัน ให้ implement ใน repo (ไม่ใช่แค่รายงานว่า “ไม่ต้องอัปเกรด”)
- **Learnings แยก** — incident จากโปรเจกต์อื่น → `.cursor/learnings.md` ไม่ยัดเข้า canonical (เสนอเป็น candidate ได้) · audit รวม `templates/` + `scripts/bootstrap-learnings.ps1` เมื่อเกี่ยวกับ learnings
- **Token-aware upgrades** — เมื่อ audit ให้เช็ค [SKILL-AUTHORING.md](../SKILL-AUTHORING.md) § Token efficiency; อย่าเพิ่มเนื้อหาใน SKILL.md ถ้าย้ายไป `reference.md` ได้

## Required inputs

| สถานการณ์ | ต้องมี |
|-----------|--------|
| ใน **skills repo** | path ชัด — ใช้ repo ปัจจุบัน |
| นอก repo | path ไป `skills` หรือถามก่อน |
| ระบุ skill | `@upgrade git-push` → โฟกัสตัวนั้น |
| ไม่ระบุ | สแกนทุก skill ใน `skills/` (ยกเว้น `deprecated` / `in-progress` / `personal`) → ตารางเลือกหรือไล่ทีละตัวตาม severity |

## Hard rules

- Do not delete `skills/` canonical without explicit user request
- Do not start **ui-builder** UI work or **api-builder** API implementation in target apps
- Do not cite removed `skill-upgrade.ps1` / `scripts/upgrade-skill.ps1`
- **No git commands** — no `git status` / `add` / `commit` / `push` / `pull` / `rebase`; ship ใน **skills repo** → `@git-push` · ship **app repo** หลังงาน implement → `@pr-review` แล้ว `@git-push`
- Do not merge project learnings into canonical without user approval per row

## Workflow — upgrade another skill

รันตามลำดับ:

### 1 — Pick target

- อ่าน `skills/**/SKILL.md` → ตาราง `# | name | version | path`
- ถ้าหลายตัวและ user ไม่ระบุ: เรียง findings ตาม severity หรือถามว่าจะเริ่มตัวไหน

### 2 — Load standard

1. [SKILL-AUTHORING.md](../SKILL-AUTHORING.md)
2. [reference.md](reference.md) — audit checklist
3. **Gold skill** ตามความซับซ้อน:
   - มี gates / deliverable หนัก → `ui-builder` หรือ `api-builder`
   - skill สั้น (pr-review, git-push, upgrade) → โครง frontmatter + Language + Hard rules + workflow ชัด

### 3 — Audit target

อ่านทุกไฟล์ใน `skills/<name>/` ที่มีอยู่ + ค้นหา cross-ref ทั้ง repo (ชื่อเก่า, path เก่า, `@invoke` ผิด)

บันทึกในตาราง:

| Severity | ความหมาย |
|----------|-----------|
| **blocker** | เรียกผิดบริบท, ขั้นตอนขัดกัน, invoke/path พัง |
| **major** | ขาด Required inputs / Hard rules / WHEN NOT, workflow ไม่ครบ |
| **minor** | typo, หัวข้อเก่า, README version drift, FILES.md ไม่ตรง |

ดูรายการเช็คเต็มใน [reference.md](reference.md)

### 4 — Plan + semver

| Bump | เมื่อ |
|------|--------|
| PATCH | แก้คำ, cross-ref, version ใน README, ไม่เปลี่ยนขั้นตอน |
| MINOR | เพิ่ม section, checklist, template, workflow ใหม่ที่ backward-compatible |
| MAJOR | เปลี่ยน gate / invoke / ลบขั้นที่ user พึ่งพา |

เสนอ: ไฟล์ที่จะแก้ · บรรทัด/หัวข้อโดยย่อ · เวอร์ชันใหม่

**ข้อดี / ข้อเสีย (บังคับก่อนถามยืนยัน)** — ใส่ใน reply ทุกครั้งที่มีแผนแก้ (รายละเอียด: [reference.md](reference.md) § Pros and cons):

| หัวข้อ | เนื้อหา |
|--------|---------|
| **ข้อดี** | ได้อะไรหลังแก้ (มาตรฐาน, ลดเรียก skill ผิด, ship flow ชัด, token สั้นลง ฯลฯ) |
| **ข้อเสีย / ความเสี่ยง** | token ยาวขึ้น, agent ช้าลง, breaking ถ้า MAJOR, user ต้องขั้นตอนเพิ่ม (เช่น pr-review), mirror ต้อง sync |
| **ถ้าไม่แก้** | คงสถานะเดิม — อะไรยังเสี่ยงอยู่ |
| **ทางเลือก** | (ถ้ามี) PATCH เฉพาะคำ vs MINOR workflow vs เลื่อน scope |

ถ้าแผนมีหลาย skill — ใส่ข้อดี/ข้อเสีย **รวมระดับ repo** + **สั้นๆ ต่อ skill** ที่จะ bump

**ถาม user:** ยืนยัน scope (ทั้งหมด / เฉพาะ blocker+major / รายการเดียว / **ไม่ทำ** พร้อมเหตุผลจากข้อเสีย)

### 5 — Implement (หลังยืนยัน)

- แก้เฉพาะ `skills/<name>/` และตาราง repo ที่อ้างเวอร์ชัน (`README.md`, `AI-NOTES.md`, `.claude-plugin/plugin.json` ถ้ามี)
- อย่าขยาย scope เกินแผนที่ยืนยัน
- รักษา `disable-model-invocation: true` และรูปแบบ Language **70% ไทย / 30% อังกฤษ** (ไทยใน reply, EN body ใน SKILL.md)

### 6 — Verify

- ตรวจ cross-ref ใน skill ที่แก้ — ลิงก์ไม่ชี้ไฟล์ที่ไม่มี
- ตรวจ `SKILL.md` frontmatter, Required inputs, Hard rules, workflow ครบ
- ตรวจ `metadata.version` ตรง README / ตาราง repo (ถ้ามี)

### 7 — Report

ส่งมอบ:

1. สิ่งที่แก้ (ก่อน/หลังสั้นๆ)
2. เวอร์ชันใหม่
3. **ข้อดีที่ได้จริง** vs **ข้อเสียที่ยอมรับ** (เทียบกับแผน §4 — ระบุถ้าต่างจากที่คาด)
4. สิ่งที่ยังไม่ทำ (ถ้ามี) + เหตุผล / trade-off
5. คำสั่งถัดไป: `@pr-review` (ถ้า user จะ ship งาน app) แล้ว `@git-push` สำหรับ commit ใน repo นี้

### Install note (รอง — ไม่ใช่งานหลัก)

หลังแก้ canonical แล้ว ถ้า user ใช้ skill จากโปรเจกต์อื่น: แนะนำ copy/link ไป `.cursor/skills/<name>/` สั้นๆ — **อย่า** จบแชทแค่ “mirror OK” โดยไม่แก้เนื้อหา skill

## Output flow

```
Pick → Audit (table) → Plan + pros/cons + semver → [user OK] → Edit canonical → Verify → Report (pros/cons จริง)
```

## Resources

| Resource | Use |
|----------|-----|
| [SKILL-AUTHORING.md](../SKILL-AUTHORING.md) | มาตรฐาน repo |
| [reference.md](reference.md) | Audit checklist · § Rationalizations / Red flags |
| [ui-builder/SKILL.md](../ui-builder/SKILL.md) | ตัวอย่าง gates + required inputs |
| [api-builder/SKILL.md](../api-builder/SKILL.md) | ตัวอย่าง workflow + self-upgrade |

## Language

- **70% ไทย / 30% อังกฤษ** — audit findings, แผน, pros/cons, คำถาม user เป็นภาษาไทย; ใช้อังกฤษ ~30% สำหรับ canonical, semver, blocker/major/minor, trade-off, gate names
- **Mix ธรรมชาติ** — เช่น "finding **major** — ขาด WHEN NOT; bump **semver** PATCH"
- **Gloss ครั้งแรกต่อ reply** — `canonical (แหล่งจริง)`, `semver (เวอร์ชัน MAJOR.MINOR.PATCH)`, `trade-off (แลกเปลี่ยน)`
- **ไม่แปล** — path, PowerShell blocks
