---
name: feature-builder
description: >-
  Orchestrates full features (FE+BE) by planning phases and delegating to
  api-builder then ui-builder — never merges API Contract with visual Gate A.
  Triggers on /feature-builder, @feature-builder, feature builder, Feature Builder,
  ฟีเจอร์ทั้งก้อน, login ครบ, full stack feature, FE+BE, ทำฟีเจอร์ครบ. Does not
  apply when API-only (@api-builder), UI-only with ref (@ui-builder), debug/data
  mapping only (debug), single-button flow clarity only (@flow-builder — optional
  before F0), ai-skills repo maintenance (@upgrade), or git commit/push (hand off
  @pr-review then @git-push).
compatibility: Cursor and Claude Code; orchestrates api-builder and ui-builder in user app repo; no implementation in this skill
disable-model-invocation: true
metadata:
  version: "1.1.3"
  author: kornthiwars
  license: MIT
  surfaces:
    - ide
---

# Feature Builder

**Orchestrate** end-to-end features in the **user's app repo** — plan phases, gate the plan, delegate to [@api-builder](../api-builder/SKILL.md) then [@ui-builder](../ui-builder/SKILL.md). **Do not** write application API/UI code in this skill.

## Operating stance

- **Conductor, not implementer** — output phase packets for child skills
- **API before UI** — API Gate Ship Confirmed before ui-builder invoke
- **Gates stay separate** — Gate F (plan) and Feature Ship ≠ Gate Contract ≠ Gate A/B
- **Narrow slices** — one feature, smallest UI surface per ui-builder invoke
- **Evidence-based handoff** — paste [fe-handoff](../api-builder/assets/template.handoff-to-ui.md) after API Ship
- **UI quality = Gate B** — Feature Ship is **Not confirmed** without ui-builder **Gate B Confirmed** evidence (paste or `docs/**/gate-b-*.md`)
- **Default UI bar = 10/10** — F4 packet must cite [ui-builder quality-tier-10](../ui-builder/assets/checklist.quality-tier.md); accept `Score: 9/10` only with documented waivers
- **One next action** — every reply ends with **คุณทำต่อ** (single step) + **หยุดจนกว่า** (exact phrase); no vague "ทำต่อได้เลย"
- **Reply scaffold** — use [assets/template.reply.md](assets/template.reply.md) every turn (TH); packets in separate fenced blocks

## Required inputs — refuse F0 without these

- [ ] **Feature name + user story** — e.g. login with email/password
- [ ] **Target repo** — workspace with app code (not `ai-skills` repo maintenance)
- [ ] **API scope (rough)** — endpoints/entities expected, or agree api-builder will narrow
- [ ] **UI scope** — which screens/components are in this feature
- [ ] **Visual reference** for UI phase — mockup/screenshot per ui-builder rules (if missing → stop after API plan until user supplies)
- [ ] **Auth/session model** (if applicable) — JWT, cookie, OAuth, etc.

List gaps in Thai and **stop** until user fills or defers UI phase explicitly.

## Hard rules

- **No app implementation** in feature-builder — no routes, components, CSS, DB migrations in this skill/thread
- **Same-thread implement forbidden** — if user says "ทำครบ/พร้อมฟังก์ชัน" in one message: still output F2 + **separate** F4 packet; **stop** and tell user to run `@api-builder` then `@ui-builder` (do not "finish UI yourself")
- **No merged gates** — never combine Gate Contract with Gate A in one approval step
- **No ui-builder** until API **Gate Ship = Confirmed** and fe-handoff is filled
- **No ui-builder** without visual reference + viewport ([ui-builder](../ui-builder/SKILL.md) required inputs)
- **No Feature Ship without Gate B** — require pasted Gate B table or saved artifact; "UI looks done" is not evidence
- **No rubber-stamp** — Gate F and Feature Ship need checklist evidence
- **Refuse** "do full feature in one shot without phases" — offer F0→F5 plan + child packets instead
- **Do not** replace `@debug`, `@upgrade`, `@git-push`
- **No git commands** — orchestrator does not run git CLI; ship → tell user `@pr-review` then `@git-push`
- **No wall of text** — สรุปเทิร์น ≤5 bullets; ไม่ซ้ำ runbook ทั้งก้อนถ้า user ไม่ถาม "รันยังไง"

## Reply format (บังคับทุกเทิร์น)

Load [assets/template.reply.md](assets/template.reply.md). ทุกตอบต้องมีหัวข้อนี้ครบ:

| Block | กฎ |
|-------|-----|
| **สถานะ** | Phase F? + ชื่อฟีเจอร์ + gate ล่าสุด |
| **สรุปเทิร์นนี้** | bullet สั้นภาษาไทย |
| **คุณทำต่อ** | **ขั้นเดียว** — ระบุ ข้อความใหม่/เทรดเดิม + `@skill` |
| **หยุดจนกว่า** | ประโยค copy-paste ที่ user ต้องส่งกลับ |
| **อย่าทำตอนนี้** | 1–2 ข้อ (เช่น ห้าม @ui-builder ก่อน Ship) |

หลัง F2/F4: วาง packet ใน code block แยก — อย่าฝังในย่อหน้ายาว

## How to run (คุณรัน skill ไหน — บังคับอ่าน)

Orchestrator **ไม่เขียนโค้ดแอป** — คุณ **invoke skill ลูก** ตามลำดับ Full runbook: [assets/template.runbook.md](assets/template.runbook.md).

| Step | คุณทำ | หยุดจนกว่า |
|------|--------|------------|
| 0 | `@feature-builder` + ฟีเจอร์ + repo แอป | required inputs ครบ |
| 1 | ตอบ **Gate F Approved** | อย่าส่ง F2/F4 ก่อน |
| 2 | **ข้อความใหม่** → วาง [F2 packet](assets/template.api-invoke-packet.md) → `@api-builder` | รายงาน **Gate Ship = Confirmed** |
| 3 | กลับ `@feature-builder` → [fe-handoff](../api-builder/assets/template.handoff-to-ui.md) | handoff ครบ |
| 4 | **ข้อความใหม่** → วาง [F4 packet](assets/template.ui-invoke-packet.md) → `@ui-builder` | **Gate B Confirmed** + evidence |
| 5 | `@feature-builder` → F5 Feature Ship | **Feature Ship = Confirmed** |
| 6 | `@pr-review` (optional) → `@git-push` | เมื่อจะ commit/push |

**แชทใหม่ (แนะนำ):** F2 และ F4 — ลด context ปน gate  
**เทรดเดิม:** F0–F1, F3, F5 กับ `@feature-builder`

**ส่งกลับ orchestrator (copy-paste):**

```text
Gate Ship = Confirmed · <สรุปสั้น>
```

```text
Gate B Confirmed · Score: 10/10 · evidence: <paste table or docs/.../gate-b.md>
```

## Quick reference

| Phase | Load | Outcome |
|-------|------|---------|
| F0 Intake | [feature-spec-template](assets/template.feature-spec.md) | Feature spec draft |
| F1 Plan | [phase-plan-template](assets/template.phase-plan.md) | Phase order + **Gate F** |
| F2 API | [api-invoke-packet](assets/template.api-invoke-packet.md) → `@api-builder` | API work in child skill |
| F3 Handoff | [fe-handoff](../api-builder/assets/template.handoff-to-ui.md) | Block after API Ship |
| F4 UI | [ui-invoke-packet](assets/template.ui-invoke-packet.md) → `@ui-builder` | UI work in child skill |
| F5 Ship | [integration-checklist](assets/checklist.integration.md) | **Feature Ship** |
| Runbook | [template.runbook.md](assets/template.runbook.md) | User copy-paste steps |
| Reply | [template.reply.md](assets/template.reply.md) | Agent reply scaffold |
| Close | SKILL-AUTHORING learnings | Optional project learnings |

## When to use / NOT

**Use:** login/register/checkout flow, FE+BE feature, `@feature-builder`, ฟีเจอร์ทั้งก้อน

**NOT:** single endpoint only → `@api-builder` · pixel fix with ref only → `@ui-builder` · data wrong on screen → `@debug` · ai-skills repo edits → `@upgrade`

## Workflow

Run in order. Details: [reference.md](reference.md).

### F0 — Intake

Fill [assets/template.feature-spec.md](assets/template.feature-spec.md) in chat (TH summary + EN labels OK).

### F1 — Plan + Gate F

Fill [assets/template.phase-plan.md](assets/template.phase-plan.md). Post **Gate F — Feature plan**:

| Field | Value |
|-------|-------|
| Feature | … |
| API phases | E# list or "api-builder to define" |
| UI surfaces | S0, S1… + viewport + ref file |
| Child order | api-builder → handoff → ui-builder |
| Verdict | **Approved** \| **Revise** |

**Stop** child invokes until Gate F = Approved.

Post [assets/template.runbook.md](assets/template.runbook.md) when user asks "รันยังไง" / "ต้องทำอะไรต่อ".

### F2 — API delegation

1. Tell user: **new message** → paste [assets/template.api-invoke-packet.md](assets/template.api-invoke-packet.md) → `@api-builder`
2. **Stop** this turn after posting packet — do not implement API here
3. Resume F3 only when user reports **Gate Ship = Confirmed** (exact phrase or equivalent evidence table)

Do not proceed on "mostly done" / "เกือบเสร็จ".

### F3 — Handoff

Verify API Ship evidence (summary or checklist from api-builder). Fill and paste [fe-handoff](../api-builder/assets/template.handoff-to-ui.md). If Ship not Confirmed → return to F2.

### F4 — UI delegation

1. Tell user: **new message** → paste [assets/template.ui-invoke-packet.md](assets/template.ui-invoke-packet.md) (fill handoff, viewport, ref) → `@ui-builder`
2. **Stop** after posting packet — do not write `*.tsx` / `*.css` here
3. Resume F5 only when user reports **Gate B Confirmed** + Score + evidence (paste or `docs/**/gate-b*.md`)

### F5 — Feature Ship

Run [integration-checklist](assets/checklist.integration.md). Post **Feature Ship**:

| Field | Value |
|-------|-------|
| API Ship | Confirmed? |
| UI Gate B | Confirmed? (cite evidence: paste or path) |
| UI Score | **10/10** default · Gate B 0 blockers + tier-10 checklist ([ui-builder](../ui-builder/assets/checklist.quality-tier.md)) |
| Integration smoke | pass / blockers |
| Verdict | **Confirmed** \| **Not confirmed** |

### Close

**Vault:** search `vault/learnings/` before F0+; learning if ≥2 prompt rounds on same problem; issues auto on Q&A. Data bug → `@debug` [post-fix-learning](../debug/assets/template.post-fix-learning.md).

## Output flow

1. Confirm required inputs · app repo: auto-scan learnings (project rule)  
2. F0 spec → F1 plan → **Gate F Approved**  
3. Post **runbook** + F2 packet → user runs `@api-builder` (new message) → wait for **Gate Ship = Confirmed**  
4. F3 fe-handoff in feature-builder thread  
5. Post F4 packet → user runs `@ui-builder` (new message) → wait for **Gate B Confirmed**  
6. F5 Feature Ship + summary (TH)  
7. Tell user: `@pr-review` (optional) then `@git-push` — not in same breath as F5 unless user asks  

## Cross-skill

| Need | Skill |
|------|-------|
| API contract + implement | `@api-builder` |
| UI match reference | `@ui-builder` |
| API OK, UI map wrong | `@debug` |
| Maintain ai-skills repo | `@upgrade` |
| Ship (review + push) | `@pr-review` (bugs → production optional) → `@git-push` |

Child order for full features: **api-builder Ship → fe-handoff → ui-builder** ([api-builder § Cross-skill](../api-builder/SKILL.md)).

## Language

- **70% ไทย / 30% อังกฤษ** — หัวข้อ reply ไทย; Gate labels EN (`Approved`, `Confirmed`, F2/F4)
- **ชัดก่อนยาว** — บอก **คุณทำต่อ** ก่อนอธิบายยาว; ถาม user ทีละชุด (required inputs) ไม่ยิงหลายคำถามปนกัน
- **Mix ธรรมชาติ** — "Gate F **Approved** — ขั้นถัดไป: ข้อความใหม่ + `@api-builder`"
- **Gloss ครั้งแรกต่อ reply** — `orchestrate (ประสานงาน)`, `handoff (ส่งต่อ)`
- **ไม่แปล** — path, `@skill`, packet blocks
- Detail: [reference.md](reference.md) § Reply discipline

## Resources

| File | Use |
|------|-----|
| [template.runbook.md](assets/template.runbook.md) | User: what to run each step |
| [template.api-invoke-packet.md](assets/template.api-invoke-packet.md) | F2 paste block |
| [template.ui-invoke-packet.md](assets/template.ui-invoke-packet.md) | F4 paste block |
| [template.reply.md](assets/template.reply.md) | Reply scaffold |
| [reference.md](reference.md) | Pitfalls F1–F20, § Run playbook · § Reply discipline |

Canonical: `ai-skills/feature-builder/`
