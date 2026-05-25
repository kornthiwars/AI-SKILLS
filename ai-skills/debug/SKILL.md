---
name: debug
description: >-
  Debug — traces wrong data/display/logic: API evidence vs client map, state,
  and render conditions. Diagnose-first; repeat repro to confirm; fix after
  Gate D Approved + user confirms. Triggers on /debug, @debug, debug, ข้อมูลผิด,
  แสดงผิด, map ผิด, state ไม่อัปเดต, API ถูกแต่ UI ผิด, render ผิด, ไล่บั๊กข้อมูล,
  ทำซ้ำยืนยัน, ยืนยันบั๊ก. Does not apply to pixel/mockup (ui-builder), new API
  design (api-builder), full FE+BE orchestration (feature-builder), unclear
  pre-build button/data flow before implement (@flow-builder), git commit/push
  (hand off @pr-review then @git-push) maintenance (@upgrade).
compatibility: Cursor and Claude Code; project test runner and HTTP client; optional browser MCP for repro
disable-model-invocation: true
metadata:
  version: "1.1.0"
  author: kornthiwars
  license: MIT
  surfaces:
    - ide
---

# Debug

**Diagnose** wrong **data or logic** — narrow with evidence, **repeat to confirm**, then fix after **Gate D Approved** + user OK. Not pixel work or new API design.

Details: [reference.md](reference.md)

## Operating stance

- **Pinpoint before patch** — one primary layer (D1–D6); no fix until fail path + disproof ([reference.md](reference.md) § Diagnosis precision)
- **Repeat to confirm** — D1 = same steps → same wrong **actual** ≥2 runs; D7 = re-run D1 after fix
- **Diagnose before fix** — API → map → state → render; evidence at each layer
- **Data vs visual** — values/logic here; layout → `@ui-builder`
- **Server vs client** — wrong response → `@api-builder`; body OK → stay in debug
- **Minimal patch** — smallest fix; no drive-by refactors

## Required inputs — refuse without these

- [ ] **Symptom** · **Expected vs actual** · **Repro steps** · **Scope** · **Evidence hint**

Mockup-only "doesn't match design" → `@ui-builder`. List gaps in Thai and **stop**.

## Hard rules

- **No pixel/API orchestration/git/ai-skills edits** — see `description` WHEN NOT
- **No git commands** — [SKILL-AUTHORING.md](../SKILL-AUTHORING.md) § Git operations
- **Gate D before large fix** — no module rewrite without Approved diagnosis
- **No fix before D1 pass** — no reliable repro → Revise or stop ([reference.md](reference.md) § D1)
- **No hypothesis before fail path** — [reference.md](reference.md) § Fail path first
- **No root cause without disproof** — top hypothesis disproved first; ledger must fit all rows
- **No "done" without D7** — re-run D1 steps after patch; actual must match expected

## Gate D — Diagnosis

| Verdict | Meaning |
|---------|---------|
| **Approved** | **D1 pass** (≥2 identical wrong actuals or flake harness) + one layer + ledger consistent |
| **Revise** | No D1 pass, fail path empty, disproof skipped, or ledger contradicts hypothesis |

Template: [assets/template.diagnosis-report.md](assets/template.diagnosis-report.md). Layers: [reference.md](reference.md) § Diagnosis layers.

## Quick reference

| Step | Load | Outcome |
|------|------|---------|
| 0 | [reference.md](reference.md) § Search learnings | ≤3 prior lessons |
| 1 | [template.repro](assets/template.repro.md) · § D1 | D1 pass / flaky / none (**2 runs**) |
| 2 | [template.evidence](assets/template.evidence.md) | API + client paths |
| 3 | § Fail path | narrow **where** it breaks |
| 4 | § Diagnosis layers · § Falsify · [breadcrumb](assets/template.breadcrumb-ledger.md) | one layer + disproof |
| 5 | diagnosis template | Approved / Revise |
| 6–8 | § Workflow D6–D8 · § Cross-skill | fix/handoff · **D7 re-pro** · report |

## Workflow

Run Quick ref in order. **Do not skip step 3 or disproof in step 4.** Detail: [reference.md](reference.md) § Workflow (D0–D8) · § Diagnosis precision.

## Output flow

Inputs → D0 → D1 repro (confirm) → evidence → fail path → layers + disproof → Gate D → fix/handoff → **D7 re-pro** → ship `@pr-review` → `@git-push`

## Language

[SKILL-AUTHORING.md](../SKILL-AUTHORING.md) § Language. **Gloss:** `root cause (สาเหตุหลัก)`, `D1 pass (ยืนยันซ้ำได้)` · EN: Gate D, D1–D6.

## Resources

| File | Use |
|------|-----|
| [reference.md](reference.md) | § Index · Diagnosis precision · Workflow · layers · handoffs · pitfalls |
| [assets/](assets/) | repro · evidence · ledger · diagnosis-report |

Canonical: `ai-skills/debug/`
