# Upgrade — audit reference (v1.1.0)

ใช้เมื่อ **อัปเกรด skill อื่น** — เทียบกับ [SKILL-AUTHORING.md](../SKILL-AUTHORING.md) และ gold skills

## Repo-wide stale patterns (ค้นทั้ง repo)

| Pattern | แก้เป็น |
|---------|---------|
| `revive-code`, `@revive-code`, `revivecode` | ลบแล้ว → `@pr-review` (select โหมด) แล้ว `@git-push` |
| author review ก่อน push | `@pr-review` ไม่ใช่ revive-code |
| `design-coding`, `@design-coding` | `ui-builder`, `@ui-builder` |
| `skills/design/`, `skills/engineering/`, `skills/ops/` (legacy) | `ai-skills/<skill-name>/` |
| bare `skills/<name>/` in footers | `ai-skills/<name>/` |
| `skills repo` (ambiguous) | `ai-skills repo` (this monorepo) |
| `.cursor/learnings.md`, `project-learnings-template`, `cursor-rule-learnings.mdc`, `bootstrap-learnings.ps1` | `vault/learnings/` + `ai-rules/vault-learning` |
| issues ไฟล์ละเรื่อง / learnings ≥2 | `issues/YYYY-MM-DD.md` วันละไฟล์ · `learnings/` ≥3 rounds |

## Per-skill checklist

ทำทุกครั้งที่ audit `ai-skills/<name>/`:

### Frontmatter & identity

- [ ] `name:` ตรงชื่อโฟลเดอร์ (`ai-skills/<name>/`)
- [ ] `description:` third-person + triggers TH/EN + **Does not apply when** (WHEN NOT)
- [ ] `disable-model-invocation: true`
- [ ] `metadata.version` semver string
- [ ] `metadata.author`, `license`, `surfaces` ครบตาม peer

### SKILL.md body

- [ ] `## Language` (หรืออ้าง SKILL-AUTHORING)
- [ ] `## Operating stance` หรือเทียบเท่า — บทบาทชัด
- [ ] `## Required inputs` — ถ้า skill มี gate/deliverable ที่ต้องปฏิเสธงานเมื่อขาด input
- [ ] `## Hard rules` — ไม่ขัด README / skill อื่น
- [ ] Workflow เป็นขั้น เรียงได้
- [ ] `## Output flow` หรือ deliverable ชัด
- [ ] SKILL.md < 500 บรรทัด — ย้ายรายละเอียดไป `reference.md` / `workflow-examples.md`

### Supporting files

- [ ] `FILES.md` ตรงไฟล์จริง
- [ ] `reference.md` — ถ้า skill ซับซ้อน (peer มี)
- [ ] `assets/` — ชื่อ `template.*` / `checklist.*` · ไม่มี digit · cross-ref ตรง

### Cross-skill & README

- [ ] ตาราง README.md — เวอร์ชันตรง `metadata.version`
- [ ] AI-NOTES.md — รายการ skill + version
- [ ] ลิงก์ไป skill อื่นถูก `@name` และ path
- [ ] ไม่ชน ui-builder (visual) / api-builder (server contract) / pr-review (author self-review) / git-push (sole git CLI)
- [ ] Ship flow ใน skill ที่ส่งงาน: `@pr-review` → `@git-push` (ไม่ข้าม pr-review ด้วย git-push อย่างเดียว)

### Token efficiency

ดู [SKILL-AUTHORING.md](../SKILL-AUTHORING.md) § Token efficiency

- [ ] `disable-model-invocation: true` (ไม่ auto-โหลดทุกแชท)
- [ ] `description` สั้น — WHAT + WHEN NOT; ไม่ยัด workflow
- [ ] Workflow บอก **เมื่อไหร่** อ่าน `reference.md` / `assets/` (ไม่ Read ทั้งก้อนตอนเริ่ม)
- [ ] SKILL.md ต่ำกว่า 500 บรรทัด; รายละเอียดยาวอยู่ใน reference
- [ ] Ship chain: pr-review โหมดเดียวที่พอ (optional) → git-push safety only หลัง `ready`
- [ ] ไม่แนะนำรวมหลาย skill เป็นไฟล์เดียวเพื่อ “ประหยัด”
- [ ] `reference.md` มี § Common rationalizations + § Red flags (เนื้อหาตรง skill)

### Behavior quality

- [ ] ไม่ rubber-stamp — มี evidence / checklist ก่อนส่งมอบ (ถ้า skill ตรวจงาน)
- [ ] Self-upgrade hook — skill ที่ส่งมอบซ้ำได้ควรมีแถว pitfalls หรืออ้าง project learnings (api-builder แบบ)
- [ ] Triggers ไม่ซ้ำ skill อื่นจนเรียกผิด

## Pros and cons (บังคับใน reply §4 และ §7)

ใช้เมื่อเสนอแผนแก้หรือสรุปหลัง implement — **อย่า** เขียนแค่ "ควรแก้" โดยไม่มี trade-off

### ตัวอย่างข้อดี (เลือกที่ตรงแผน)

- ตรง [SKILL-AUTHORING.md](../SKILL-AUTHORING.md) / gold skill — ลด agent เรียกผิด skill
- cross-ref / semver / README สอดคล้อง — ลด drift ระหว่าง mirror กับ canonical
- ship flow ชัด (`@pr-review` → `@git-push`) — ลด push โดยไม่รีวิว
- ย้ายรายละเอียดไป `reference.md` — SKILL โหลดสั้นลง
- เพิ่ม § Token efficiency ใน AUTHORING — audit ซ้ำได้โดยไม่ขยายทุก SKILL.md

### ตัวอย่างข้อเสีย / ความเสี่ยง

- SKILL ยาวขึ้น / ขั้นตอนเพิ่ม — token และรอบ agent มากขึ้น
- **MINOR/MAJOR** — user ที่จำ workflow เก่าอาจสับสน
- บังคับ pr-review ก่อน push — ช้ากว่า push ตรง (แลกความปลอดภัย)
- แก้หลาย skill พร้อมกัน — diff ใหญ่ รีวิวยาก
- ไม่แก้ learnings ในโปรเจกต์ลูก — ปัญหาเดิมใน app อาจซ้ำ

### รูปแบบในแชท (สั้น)

```text
[upgrade] Plan — <scope>
ข้อดี: …
ข้อเสีย: …
ถ้าไม่แก้: …
semver: ui-builder 2.2.1 → 2.2.2 (PATCH)
ยืนยัน scope: ทั้งหมด | blocker+major | รายการเดียว | ไม่ทำ
```

หลัง implement:

```text
[upgrade] Done — <skill>
ข้อดีที่ได้: …
ข้อเสียที่ยอมรับ: …
ยังไม่ทำ: … (เหตุผล)
```

## Common rationalizations (agent discipline)

| Rationalization | Reality |
|-----------------|---------|
| "mirror sync แล้ว = อัปเกรด skill เสร็จ" | งานหลัก = แก้ **canonical** เนื้อหา |
| "ไม่ต้องบอกข้อเสีย user ยืนยันแล้ว" | §4 ต้องมี pros/cons ก่อนแก้ |
| "ยัด learnings โปรเจกต์เข้า SKILL.md" | ต้องยืนยัน user ต่อแถว |
| "bump MAJOR เพราะแก้คำเดียว" | ใช้ PATCH เมื่อไม่เปลี่ยน gate |
| "ข้าม verify หลังแก้" | ตรวจ cross-ref + ไฟล์ required หลังแก้ |

## Red flags

- แก้โดยไม่ audit SKILL-AUTHORING
- semver ไม่ตรง README / `metadata.version`
- ลบขั้น gate โดย user ไม่ขอ
- เพิ่ม workflow ใน description ยาวเกิน 1024 ตัวอักษร
- รัน git ในเทิร์น upgrade

## Severity guide

| Level | ตัวอย่าง |
|-------|---------|
| blocker | ขั้นตอนอ้าง `@revivecode` ที่ไม่มีแล้ว; path canonical ผิด |
| major | ไม่มี WHEN NOT; workflow ขาดขั้นยืนยันก่อน push |
| minor | FILES.md / README เวอร์ชันไม่ตรง `metadata.version` ใน SKILL.md |

## After edit (ship checklist)

- [ ] Bump `metadata.version` ตาม semver table ใน SKILL.md
- [ ] อัป README / AI-NOTES / plugin.json ถ้ามีแถวเวอร์ชัน
- [ ] ตรวจ cross-ref และไฟล์ที่ SKILL.md อ้างอิง — ไม่มีลิงก์พัง
- [ ] ไม่ commit จน user ขอ

## Project vault (optional input)

ถ้า user ให้ path โปรเจกต์เป้าหมาย:

1. ตรวจ `vault/` + rule `vault-learning` — issues auto · learnings ≥3 rounds · **search learnings ก่อน debug**
2. แถวที่ tag skill → **candidate** สำหรับ canonical หรือเก็บใน vault โปรเจกต์เท่านั้น
3. ยืนยันกับ user ก่อน merge เข้า `ai-skills/`
4. ไม่มี vault → แนะนำ copy `templates/` + `ai-rules/vault-learning.mdc` จาก AI-SKILLS
