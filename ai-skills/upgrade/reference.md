# Upgrade — audit reference (v1.1.5)

ใช้เมื่อ **อัปเกรด skill อื่น** — เทียบกับ [SKILL-AUTHORING.md](../SKILL-AUTHORING.md) และ gold skills

## Workflow — upgrade another skill

Run in order after [SKILL.md](SKILL.md) gates. Severity examples: [§ Severity guide](#severity-guide) · Pros/cons templates: [§ Pros and cons](#pros-and-cons-บังคับใน-reply-§4-และ-§7).

### 1 — Pick target

- Read `ai-skills/**/SKILL.md` → table `# | name | version | path`
- If many skills and user did not name one: sort findings by severity or ask where to start

### 2 — Load standard

1. [SKILL-AUTHORING.md](../SKILL-AUTHORING.md)
2. [reference.md](reference.md) — audit checklist · § Repo doc hygiene (when `scripts/` changed)
3. **Gold skill** by complexity:
   - Heavy gates / deliverables → `ui-builder` or `api-builder`
   - Short skills (pr-review, git-push, upgrade) → frontmatter + Language + Hard rules + clear workflow

### 3 — Audit target

Read every file in `ai-skills/<name>/` plus repo-wide cross-ref search (old names, paths, wrong `@invoke`).

Record findings:

| Severity | Meaning |
|----------|---------|
| **blocker** | Wrong context, conflicting steps, broken invoke/path |
| **major** | Missing Required inputs / Hard rules / WHEN NOT; incomplete workflow |
| **minor** | typo, stale headings, README version drift, FILES.md mismatch |

### 4 — Plan + semver

| Bump | When |
|------|------|
| PATCH | Wording, cross-ref, README version; no step change |
| MINOR | New section, checklist, template, backward-compatible workflow |
| MAJOR | Gate / invoke change; removed step users rely on |

Propose: files to edit · brief headings · new version.

**Pros / cons (required before user OK)** — [§ Pros and cons](#pros-and-cons-บังคับใน-reply-§4-และ-§7):

| Topic | Content |
|-------|---------|
| **Benefits** | What improves (standard, fewer wrong invokes, ship flow, shorter tokens, etc.) |
| **Risks** | Longer SKILL, slower agent, MAJOR breakage, extra steps (e.g. pr-review), mirror sync |
| **If unchanged** | What risk remains |
| **Alternatives** | PATCH only vs MINOR workflow vs defer scope |

Multi-skill plans: repo-level pros/cons + **short per-skill** bump notes.

**Ask user:** confirm scope (all / blocker+major only / single item / **skip** with reason from risks).

### 5 — Implement (after OK)

- Edit `ai-skills/<name>/` and repo version tables (`README.md`, `AI-NOTES.md`, `.claude-plugin/plugin.json` if present)
- If scope includes **setup / vault path** changes: sync repo docs per [§ Repo doc hygiene](#repo-doc-hygiene-when-scripts-or-vault-layout-changes) (same PR as skill edits when possible)
- Do not exceed confirmed scope
- Keep `disable-model-invocation: true` and **70% Thai / 30% English** in chat replies; **English** `SKILL.md` body per AUTHORING

### 6 — Verify

- Cross-ref in edited skills — no broken links
- Frontmatter, Required inputs, Hard rules, workflow complete
- `metadata.version` matches README / repo tables if any

### 7 — Report

Deliver:

1. What changed (short before/after)
2. New version(s)
3. **Actual benefits** vs **accepted risks** (vs plan §4 — note surprises)
4. Deferred items (if any) + reason / trade-off
5. Next: `@pr-review` (app ship) then `@git-push` for commit in this repo when user asks

### Install note (secondary)

After canonical fix, if user consumes skills from another project: briefly suggest copy/link to `.cursor/skills/<name>/` — do not end with “mirror OK” without fixing skill content.

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
| issues ไฟล์ละเรื่อง / learnings ≥3 | `issues/YYYY-MM-DD.md` วันละไฟล์ · `learnings/` ≥2 rounds |
| `setup-windows.ps1` without `-InstallRoot` | mandatory `-InstallRoot <workspace>` |
| `WORKSPACE_ROOT`, `-WorkspaceRoot`, `setup-macos-linux-parent.sh` | `setup-macos-linux.sh <workspace>` |
| `.claude/skills`, `.claude/rules`, parent `vault/` at workspace root | `.cursor/skills`, `.cursor/rules`, `.cursor/vault` at install root only |
| `ai-skills-vault.json` optional / parent `vault/` symlink | required at install root; `issuesRelative: .cursor/vault/issues` |
| pr-review “3 modes” / no `clean-code` | four modes: `bugs`, `production`, `clean-code`, `scale-security` |

## Repo doc hygiene (when `scripts/` or vault layout changes)

Run when setup scripts, junction targets, or vault resolve paths change — **blocker** if docs still describe old layout.

| File | Must match |
|------|------------|
| [scripts/README.md](../../scripts/README.md) | source of truth for commands |
| [AGENTS.md](../../AGENTS.md) § Setup | `-InstallRoot`, `.cursor/` links, no `.claude/` |
| [README.md](../../README.md) § Setup | same; no parent `setup-windows.bat` / parent-only scripts |
| [ai-rules/vault-learning.mdc](../../ai-rules/vault-learning.mdc) | resolve steps: JSON → `.cursor/vault/issues` → clone fallback |
| [ai-rules/vault-learning/reference.md](../../ai-rules/vault-learning/reference.md) | multi-project install root, not `parent/vault/` |
| [ai-skills/README.md](../README.md) | setup line: `.cursor/skills` only |
| [ai-rules/README.md](../../ai-rules/README.md) · [RULE-AUTHORING.md](../../ai-rules/RULE-AUTHORING.md) | setup via script, not manual `.claude/` mklink |

After edit: grep repo for `WORKSPACE_ROOT`, `WorkspaceRoot`, `setup-macos-linux-parent`, `.claude/skills` in setup context — should be zero.

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

1. ตรวจ `vault/` + rule `vault-learning` — issues auto · learnings ≥2 rounds · **search learnings ก่อน debug**
2. แถวที่ tag skill → **candidate** สำหรับ canonical หรือเก็บใน vault โปรเจกต์เท่านั้น
3. ยืนยันกับ user ก่อน merge เข้า `ai-skills/`
4. ไม่มี vault → แนะนำ copy `templates/` + `ai-rules/vault-learning.mdc` จาก AI-SKILLS
