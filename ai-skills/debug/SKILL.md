---
name: debug
description: >-
  Debug — traces wrong data/display/logic: API evidence vs client map, state,
  and render conditions. Diagnose-first; fix after user confirms. Triggers on
  /debug, @debug, debug, ข้อมูลผิด, แสดงผิด, map ผิด, state ไม่อัปเดต,
  API ถูกแต่ UI ผิด, render ผิด, ไล่บั๊กข้อมูล. Does not apply to
  pixel/mockup (ui-builder), new API design (api-builder), full FE+BE
  orchestration (feature-builder), unclear pre-build button/data flow before implement
  (@flow-builder), git commit/push (hand off @pr-review then @git-push) maintenance
  (@upgrade).
compatibility: Cursor and Claude Code; project test runner and HTTP client; optional browser MCP for repro
disable-model-invocation: true
metadata:
  version: "1.0.6"
  author: kornthiwars
  license: MIT
  surfaces:
    - ide
---

# Debug

**Diagnose** wrong **data or logic** on screen — API → map → state → render. **Fix** after **Gate D Approved** + user confirms. Not pixel work or new API design.

## Operating stance

- **Four disciplines:** reproducibility → fail path → falsify hypotheses → breadcrumb ledger ([reference.md](reference.md))
- **Diagnose before fix** — layers D1–D6 with evidence
- **Data vs visual** — values/logic here; color/spacing → `@ui-builder`
- **Server vs client** — wrong response → `@api-builder`; right response → stay in debug
- **Minimal patch** — smallest fix; no drive-by refactors

## Required inputs — refuse without these

- [ ] **Symptom** · **Expected vs actual** · **Repro steps** · **Scope** · **Evidence hint**

Mockup-only "doesn't match design" → suggest `@ui-builder`. List gaps in Thai and **stop**.

## Hard rules

- **No pixel/API orchestration/git/ai-skills edits** — see `description` WHEN NOT
- **No git commands** — [SKILL-AUTHORING.md](../SKILL-AUTHORING.md) § Git operations
- **Gate D before large fix** — no module rewrite without Approved diagnosis
- **No fix before D1 pass** — no reliable repro → Revise or stop
- **No hypothesis before fail path** — [reference.md](reference.md) § Fail path first

## Diagnosis layers

| Layer | Name | Question |
|-------|------|----------|
| D1 | Repro | Repeatable? ([reference.md](reference.md) § D1) |
| D2 | API | Status/body truth? |
| D3 | Shape | Fields match UI? |
| D4 | Map/bind | Wrong path/formatter? |
| D5 | State/effects | Stale cache/refetch? |
| D6 | Render logic | Wrong condition/sort/filter? |

**Primary root cause** = one layer.

## Gate D — Diagnosis

| Verdict | Meaning |
|---------|---------|
| **Approved** | **D1 pass** + root cause vs breadcrumb ledger — may fix or handoff |
| **Revise** | No reliable repro or ledger contradicts hypothesis |

Template: [assets/template.diagnosis-report.md](assets/template.diagnosis-report.md).

## Quick reference

| Step | Load | Outcome |
|------|------|---------|
| 0 | [reference.md](reference.md) § Search learnings | ≤3 prior lessons |
| 1 | [template.repro](assets/template.repro.md) | D1 pass / flaky / none |
| 2 | [template.evidence](assets/template.evidence.md) | API + client paths |
| 3–4 | [reference.md](reference.md) § Workflow · § Fail path | layers + ledger |
| 5 | diagnosis template | Approved / Revise |
| 6–8 | [reference.md](reference.md) § Workflow | fix · validate · report |

## Workflow

Quick ref order. Step detail: [reference.md](reference.md) § Workflow (D0–D8). Report block: § Report template.

## Output flow

Inputs → D0 learnings (if vault) → D1 repro → evidence + fail path → Gate D → fix/handoff → re-pro → optional learning (≥2 rounds) → ship: `@pr-review` → `@git-push`

## Handoffs

| Situation | Skill |
|-----------|--------|
| Wrong API / validation / DB | `@api-builder` |
| API OK, map/state/logic | `@debug` |
| Layout vs mockup | `@ui-builder` |
| Full feature | `@feature-builder` |
| Ship | `@pr-review` → `@git-push` |

## Language

[SKILL-AUTHORING.md](../SKILL-AUTHORING.md) § Language. **Gloss:** `root cause (สาเหตุหลัก)`, `handoff (ส่งต่อ skill)` · EN: Gate D, D1–D6.

## Resources

| File | Use |
|------|-----|
| [reference.md](reference.md) | Workflow · layers · pitfalls · rationalizations |

Canonical: `ai-skills/debug/`
