---
name: feature-builder
description: >-
  Orchestrates full features (FE+BE) by planning phases and delegating to
  api-builder then ui-builder — never merges API Contract with visual Gate A.
  Triggers on /feature-builder, @feature-builder, feature builder, Feature Builder,
  ฟีเจอร์ทั้งก้อน, login ครบ, full stack feature, FE+BE, ทำฟีเจอร์ครบ. Does not
  apply when API-only (@api-builder), UI-only with ref (@ui-builder), debug/data
  mapping only (debug), skills repo maintenance (@upgrade), or git push (git-push).
disable-model-invocation: true
metadata:
  version: "1.0.0"
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

## Required inputs — refuse F0 without these

- [ ] **Feature name + user story** — e.g. login with email/password
- [ ] **Target repo** — workspace with app code (not `skills` repo maintenance)
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

## Quick reference

| Phase | Load | Outcome |
|-------|------|---------|
| F0 Intake | [feature-spec-template](assets/template.feature-spec.md) | Feature spec draft |
| F1 Plan | [phase-plan-template](assets/template.phase-plan.md) | Phase order + **Gate F** |
| F2 API | packet → `@api-builder` | API work in child skill |
| F3 Handoff | [fe-handoff](../api-builder/assets/template.handoff-to-ui.md) | Block after API Ship |
| F4 UI | packet → `@ui-builder` | UI work in child skill |
| F5 Ship | [integration-checklist](assets/checklist.integration.md) | **Feature Ship** |
| Close | SKILL-AUTHORING learnings | Optional project learnings |

## When to use / NOT

**Use:** login/register/checkout flow, FE+BE feature, `@feature-builder`, ฟีเจอร์ทั้งก้อน

**NOT:** single endpoint only → `@api-builder` · pixel fix with ref only → `@ui-builder` · data wrong on screen → `@debug` · skills repo edits → `@upgrade`

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

### F2 — API delegation

Post a **copy-paste packet** for a **new chat or same thread**:

```text
@api-builder
Feature: <name> · Phase F2 (from @feature-builder)
Scope: <endpoints / CRUD / narrow delta>
Stack: <from repo>
Gate: complete Contract + Ship before returning to feature-builder.
```

Track until user reports **Gate Ship = Confirmed**. Do not proceed on "mostly done."

### F3 — Handoff

Verify API Ship evidence (summary or checklist from api-builder). Fill and paste [fe-handoff](../api-builder/assets/template.handoff-to-ui.md). If Ship not Confirmed → return to F2.

### F4 — UI delegation

Use [assets/template.ui-invoke-packet.md](assets/template.ui-invoke-packet.md). Post packet (new message strongly preferred):

```text
@ui-builder
Feature: <name> · Phase F4 (from @feature-builder)
Handoff: [paste fe-handoff block]
Scope: <S0…Sn or "full page shell"> · Viewport <W×H> · Ref: <file or URL>
Deliverables: Gate A Approved · Gate B Confirmed (0 blockers) · build screenshot @ viewport
Forbidden: ship UI without Gate B · emoji icons if ref uses SVG/icon font
Gate: complete Gate A + B before returning to feature-builder.
```

**Stop** after posting F4 — do not write `*.tsx` / `*.css` for the UI surface in the feature-builder turn.

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

**Vault:** search `vault/learnings/` before F0+; learning if ≥3 prompt rounds on same problem; issues auto on Q&A. Data bug → `@debug` [post-fix-learning](../debug/assets/template.post-fix-learning.md).

## Output flow

1. Confirm required inputs · app repo: auto-scan learnings (project rule)  
2. F0 spec → F1 plan → **Gate F Approved**  
3. F2 `@api-builder` packet → wait for **API Ship**  
4. F3 fe-handoff  
5. F4 `@ui-builder` packet → wait for **Gate B Confirmed**  
6. F5 Feature Ship + summary (TH)  
7. Suggest `@pr-review` (mode select) then `@git-push` when user wants to ship  

## Cross-skill

| Need | Skill |
|------|-------|
| API contract + implement | `@api-builder` |
| UI match reference | `@ui-builder` |
| API OK, UI map wrong | `@debug` |
| Maintain skills repo | `@upgrade` |
| Ship (review + push) | `@pr-review` (bugs → production optional) → `@git-push` |

Child order for full features: **api-builder Ship → fe-handoff → ui-builder** ([api-builder § Cross-skill](../api-builder/SKILL.md)).

## Language

- **70% ไทย / 30% อังกฤษ** — แผน, Gate F, Feature Ship, คำถามเป็นภาษาไทย; ใช้อังกฤษ ~30% สำหรับ Gate F, Approved, Confirmed, phase packets (F1–F5), handoff, orchestrate
- **Mix ธรรมชาติ** — เช่น "Gate F **Approved** — ส่ง **handoff** ให้ @api-builder ทำ contract E1"
- **Gloss ครั้งแรกต่อ reply** — `orchestrate (ประสานงาน)`, `handoff (ส่งต่อให้ skill ลูก)`
- **ไม่แปล** — path, `@skill`, phase packet blocks

## Resources

| File | Use |
|------|-----|
| [reference.md](reference.md) | Pitfalls F1–F12, § Rationalizations / Red flags |

Canonical: `skills/feature-builder/`
