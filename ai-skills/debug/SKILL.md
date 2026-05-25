---
name: debug
description: >-
  Debug — production-style data/logic diagnosis: repro reliability matrix,
  evidence priority, layer ownership, root-cause ledger, instrumentation,
  minimal patch scoring, regression surface. Diagnose-first; repeat to confirm;
  fix after Gate D Approved + user confirms. Triggers on /debug, @debug, debug,
  ข้อมูลผิด, แสดงผิด, map ผิด, state ไม่อัปเดต, API ถูกแต่ UI ผิด, render ผิด,
  ไล่บั๊กข้อมูล, ทำซ้ำยืนยัน, flaky, async bug. Does not apply to pixel/mockup
  (ui-builder), new API design (api-builder), full FE+BE orchestration
  (feature-builder), unclear pre-build flow (@flow-builder), git commit/push
  (@pr-review then @git-push), ai-skills maintenance (@upgrade).
compatibility: Cursor and Claude Code; project test runner and HTTP client; optional browser MCP for repro
disable-model-invocation: true
metadata:
  version: "1.2.0"
  author: kornthiwars
  license: MIT
  surfaces:
    - ide
---

# Debug

**Diagnose** wrong **data or logic** — repro matrix, ranked evidence, layer ownership, root-cause ledger, then fix after **Gate D Approved** + user OK.

Details: [reference.md](reference.md)

## Operating stance

- **Framework in reference** — load § per Quick ref; do not read full reference at invoke
- **Pinpoint before patch** — one primary layer + [§ Minimal patch scoring](reference.md#minimal-patch-scoring)
- **Repeat to confirm** — [§ Repro reliability matrix](reference.md#repro-reliability-matrix); D7 + [§ Regression surface](reference.md#regression-surface-d7)
- **Evidence over assumption** — [§ Evidence priority](reference.md#evidence-priority-order) (runtime before screenshot)
- **Server vs client** — [§ Layer ownership](reference.md#layer-ownership); handoff by owner
- **Remove temp instrumentation** before ship — [§ Instrumentation rules](reference.md#instrumentation-rules)

## Required inputs — refuse without these

- [ ] **Symptom** · **Expected vs actual** · **Repro steps** · **Scope** · **Evidence hint**

Mockup-only → `@ui-builder`. List gaps in Thai and **stop**.

## Hard rules

- **No pixel/API orchestration/git/ai-skills edits** — see `description` WHEN NOT
- **No git commands** — [SKILL-AUTHORING.md](../SKILL-AUTHORING.md) § Git operations
- **No fix before repro class allows** — `non-repro` → Revise; `semi-flaky` / `flaky` → [§ Instrumentation](reference.md#instrumentation-rules) before Approved
- **No hypothesis before fail path** — [reference.md](reference.md) § Fail path first
- **No root cause without root-cause ledger + disproof** — [template.root-cause-ledger](assets/template.root-cause-ledger.md)
- **No patch above tier without Gate D** — module rewrite / architecture → Revise or re-approve
- **No "done" without D7 + regression checklist** — [§ Regression surface](reference.md#regression-surface-d7)
- **No ship with `[DBG-` logs** — remove temp instrumentation first

## Gate D — Diagnosis

| Verdict | Meaning |
|---------|---------|
| **Approved** | Repro class **stable** or **semi-flaky** with instrumentation note + evidence priority satisfied + root-cause ledger consistent + one layer + patch tier chosen |
| **Revise** | `non-repro`, `flaky` without harness, fail path empty, ledger contradicts, or evidence is assumption-only |

Templates: [diagnosis-report](assets/template.diagnosis-report.md) · [root-cause-ledger](assets/template.root-cause-ledger.md)

## Quick reference

| Step | Load | Outcome |
|------|------|---------|
| 0 | § Search learnings | ≤3 prior lessons |
| 1 | [template.repro](assets/template.repro.md) · § Repro matrix | stable / semi-flaky / flaky / non-repro |
| 2 | [template.evidence](assets/template.evidence.md) · § Evidence priority | ranked evidence |
| 3 | § Fail path · § Instrumentation | break site; logs if unclear |
| 4 | § Layer ownership · § Falsify · [root-cause-ledger](assets/template.root-cause-ledger.md) · [breadcrumb](assets/template.breadcrumb-ledger.md) | owner + ledger + experiments |
| 5 | diagnosis template | Approved / Revise |
| 6 | § Minimal patch · § Cross-skill | smallest patch / handoff |
| 7–8 | § Regression surface · § Report | D7 re-pro + checklist · close |

## Workflow

Run Quick ref. Detail: [reference.md](reference.md) § Workflow (D0–D8) · § Diagnosis precision.

## Output flow

D0 → D1 matrix → D2 priority evidence → fail path → layers + ledger + disproof → Gate D → patch tier → D7 regression → ship `@pr-review` → `@git-push`

## Language

[SKILL-AUTHORING.md](../SKILL-AUTHORING.md) § Language. **Gloss:** `stable (2/2 fail)`, `semi-flaky (3/5)` · EN: Gate D, layer ownership, patch tier.

## Resources

| File | Use |
|------|-----|
| [reference.md](reference.md) | Framework § Index — matrix, evidence, ownership, instrumentation, regression, false diagnoses |
| [assets/](assets/) | repro · evidence · root-cause-ledger · breadcrumb · diagnosis-report |

Canonical: `ai-skills/debug/`
