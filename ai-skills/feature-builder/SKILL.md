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
  version: "1.1.4"
  author: kornthiwars
  license: MIT
  surfaces:
    - ide
---

# Feature Builder

**Orchestrate** FE+BE features — plan, gate, delegate to [@api-builder](../api-builder/SKILL.md) then [@ui-builder](../ui-builder/SKILL.md). **No app code** in this skill.

## Operating stance

- **Conductor** — phase packets for child skills; **one next action** + **หยุดจนกว่า** every turn
- **API before UI** — Gate Ship Confirmed + fe-handoff before `@ui-builder`
- **Gates separate** — Gate F / Feature Ship ≠ Contract ≠ Gate A/B
- **Gate B evidence required** — paste or `docs/**/gate-b*.md`; default UI bar **10/10**
- **Reply:** [assets/template.reply.md](assets/template.reply.md) · discipline: [reference.md](reference.md) § Reply discipline

## Required inputs — refuse F0 without these

- [ ] **Feature + user story** · **Target app repo** · **API scope (rough)** · **UI scope** · **Visual ref** (or defer UI) · **Auth model** (if any)

List gaps in Thai and **stop**.

## Hard rules

- **No app implementation** / **no same-thread FE+BE implement** — F2/F4 packets → child skills
- **No ui-builder** before API **Gate Ship = Confirmed** + fe-handoff + visual ref
- **No Feature Ship** without **Gate B Confirmed** evidence
- **No merged gates** · **no rubber-stamp** Gate F / Feature Ship
- **No git** — [SKILL-AUTHORING.md](../SKILL-AUTHORING.md) § Git operations
- **No wall of text** — ≤5 bullets; full runbook only when user asks "รันยังไง"

## Quick reference

| Phase | Load | Outcome |
|-------|------|---------|
| F0 | [template.feature-spec](assets/template.feature-spec.md) | spec |
| F1 | [template.phase-plan](assets/template.phase-plan.md) | **Gate F** |
| F2 | [api-invoke-packet](assets/template.api-invoke-packet.md) → `@api-builder` | wait `Gate Ship = Confirmed` |
| F3 | [fe-handoff](../api-builder/assets/template.handoff-to-ui.md) | handoff |
| F4 | [ui-invoke-packet](assets/template.ui-invoke-packet.md) → `@ui-builder` | wait `Gate B Confirmed` |
| F5 | [checklist.integration](assets/checklist.integration.md) | **Feature Ship** |
| Runbook | [template.runbook](assets/template.runbook.md) | when user asks how to run |
| Reply | [template.reply](assets/template.reply.md) | every turn |

**Resume phrases:** `Gate Ship = Confirmed · …` · `Gate B Confirmed · Score: 10/10 · evidence: …`

## Gate F — Feature plan

| Field | Value |
|-------|-------|
| Feature | … |
| API phases | E# or api-builder defines |
| UI surfaces | S0… + viewport + ref |
| Child order | api-builder → handoff → ui-builder |
| Verdict | **Approved** \| **Revise** |

**Stop** child invokes until Gate F = Approved.

## Feature Ship

| Field | Value |
|-------|-------|
| API Ship | Confirmed? |
| UI Gate B | Confirmed? (cite evidence) |
| UI Score | **10/10** default ([quality-tier](../ui-builder/assets/checklist.quality-tier.md)) |
| Integration smoke | pass / blockers |
| Verdict | **Confirmed** \| **Not confirmed** |

## Workflow

F0–F5 detail: [reference.md](reference.md) § Phase detail · § Run playbook.  
F2/F4: **new message** + packet + `@skill` — **stop** after packet. No "เกือบเสร็จ".

## Output flow

Inputs → F0 → F1 Gate F → F2 packet → Ship Confirmed → F3 handoff → F4 packet → Gate B → F5 → optional `@pr-review` → `@git-push`

**Vault:** [ai-rules/vault-learning.mdc](../../ai-rules/vault-learning.mdc) § Search learnings before F0. Data bug → `@debug`.

## Handoffs

| Need | Skill |
|------|-------|
| API | `@api-builder` |
| UI | `@ui-builder` |
| Data on screen | `@debug` |
| ai-skills repo | `@upgrade` |
| Ship | `@pr-review` → `@git-push` |

## Language

[SKILL-AUTHORING.md](../SKILL-AUTHORING.md) § Language. **Gloss:** `orchestrate (ประสานงาน)`, `handoff (ส่งต่อ)` · EN: Gate F, F2/F4, Approved, Confirmed.

## Resources

| File | Use |
|------|-----|
| [reference.md](reference.md) | Phase detail · Run playbook · Reply discipline · pitfalls |
| [template.runbook.md](assets/template.runbook.md) | User step list |
| [template.reply.md](assets/template.reply.md) | Reply scaffold |

Canonical: `ai-skills/feature-builder/`
