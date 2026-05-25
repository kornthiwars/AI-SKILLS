---
name: debug
description: >-
  Debug — traces wrong data/display/logic: API evidence vs client map, state,
  and render conditions. Diagnose-first; fix after user confirms. Triggers on
  /debug, @debug, debug, ข้อมูลผิด, แสดงผิด, map ผิด, state ไม่อัปเดต,
  API ถูกแต่ UI ผิด, render ผิด, ไล่บั๊กข้อมูล. Does not apply to
  pixel/mockup (ui-builder), new API design (api-builder), full FE+BE
  orchestration (feature-builder), git commit/push (hand off @pr-review then @git-push)
  maintenance (@upgrade).
compatibility: Cursor and Claude Code; project test runner and HTTP client; optional browser MCP for repro
disable-model-invocation: true
metadata:
  version: "1.0.4"
  author: kornthiwars
  license: MIT
  surfaces:
    - ide
---

# Debug

**Diagnose** wrong **data or logic** on screen in the user's app repo — trace API → map → state → render. **Fix** only after **Gate D Approved** and user confirms (or one obvious typo). **Not** visual pixel work or new API design.

## Operating stance

- **Four disciplines** (adapted from reproducibility-first debug practice):
  1. **Reproducibility** — reliable repro before any hypothesis or fix
  2. **Know the fail path** — trace where it breaks before guessing (debugger → source trace → targeted logs)
  3. **Falsify hypotheses** — try to disprove; rank 3–5 candidates; disproof before confirmation
  4. **Breadcrumb ledger** — every experiment logged; new theory must fit all prior runs
- **Diagnose before fix** — layers D1–D6 with evidence; no guessing
- **Data vs visual** — wrong values/list/logic here; wrong color/spacing → `@ui-builder`
- **Server vs client** — if response is wrong → `@api-builder`; if response is right → stay in debug
- **Minimal patch** — smallest change that fixes root cause; no drive-by refactors
- **Stack-agnostic** — follow repo conventions; read actual code and samples

## Required inputs — refuse without these

- [ ] **Symptom** — what is wrong on screen
- [ ] **Expected vs actual** — at least one measurable pair
- [ ] **Repro steps** — page/URL + actions, or clear scenario
- [ ] **Scope** — narrow: component, page zone, or endpoint
- [ ] **Evidence hint** — sample JSON, Network capture, or permission to inspect repo/runtime

If user only says "doesn't match design" with mockup and no data claim → suggest `@ui-builder`.

List gaps in Thai and **stop**.

## Hard rules

- **No pixel/layout gate work** — no Gate A/B; not ui-builder
- **No new API contract** — no Gate Contract/Ship; hand off `@api-builder` when server is wrong
- **No full-feature orchestration** — use `@feature-builder` for greenfield FE+BE
- **No git commands** — no `git status` / `add` / `commit` / `push` / `pull` / `rebase` / `merge`; ship work → `@pr-review` then `@git-push` only
- **No ai-skills repo canonical edits** — use `@upgrade`
- **Gate D before large fix** — do not rewrite modules without Approved diagnosis
- **Read-only default** — diagnose and table first; patch after confirm (or trivial one-line map typo)
- **No fix before D1 pass** — no reliable repro → Revise or stop; do not declare "bug confirmed"
- **No hypothesis before fail path** — narrow where it breaks (step 2) before layer guesses

## Diagnosis layers

| Layer | Name | Question |
|-------|------|----------|
| D1 | Repro | Repeatable? (see [reference.md](reference.md) § D1) |
| D2 | API | Status/body truth vs reality? |
| D3 | Shape | Field names/types match UI expectations? |
| D4 | Map/bind | Wrong path, formatter, or binding? |
| D5 | State/effects | Stale cache, key, missing invalidate/refetch? |
| D6 | Render logic | Wrong condition, sort, filter, empty state? |

Record each layer in the report. **Primary root cause** = one layer.

## Gate D — Diagnosis

| Verdict | Meaning |
|---------|---------|
| **Approved** | **D1 pass** + root cause evidenced against breadcrumb ledger — may fix or hand off |
| **Revise** | No reliable repro, weak evidence, or hypothesis contradicted by ledger |

Use [assets/template.diagnosis-report.md](assets/template.diagnosis-report.md).

## Quick reference

| Step | Load | Outcome |
|------|------|---------|
| 1 Repro | [repro-template](assets/template.repro.md) | Symptom + steps |
| 2 Evidence | [evidence-template](assets/template.evidence.md) | API + client paths |
| 3 Fail path | [reference.md](reference.md) § Fail path | Where it breaks |
| 4 Layers | [reference.md](reference.md) | D2–D6 + hypotheses |
| 5 Ledger | [breadcrumb-ledger](assets/template.breadcrumb-ledger.md) | Experiments |
| 6 Gate D | diagnosis template | Approved / Revise |
| 7 Fix | user confirm | Patch or handoff packet |
| 8 Validate | re-pro | Same steps → expected |
| 9 Close | [post-fix-learning](assets/template.post-fix-learning.md) | `vault/learnings/YYYY-MM-DD-HHmm.md` if ≥3 prompt rounds on same problem |

## When to use / NOT

**Use:** wrong total, wrong label, list not updating, map field error, `@debug`, ข้อมูลผิด

**NOT:** mockup-only mismatch → `@ui-builder` · new endpoint → `@api-builder` · login full stack → `@feature-builder` · ship → `@pr-review` then `@git-push`

## Workflow

Run in order. Details: [reference.md](reference.md).

### 0 — Search learnings (if vault exists)

Per [ai-rules/vault-learning.mdc](../../ai-rules/vault-learning.mdc) § Search learnings — **before D1**:

1. Grep `vault/learnings/` for symptom, error text, `skill:`, `symptoms:`, `files:` (English)
2. `head_limit` ~15 — do **not** read the whole folder
3. Read **≤3** best matches only
4. If none relevant, continue; optional grep today's `vault/issues/YYYY-MM-DD.md`

Load [reference.md](reference.md) § Search learnings only if grep hits need interpretation.

### 1 — Repro (D1)

Fill [assets/template.repro.md](assets/template.repro.md).

| Repro class | Rule |
|-------------|------|
| **Reliable** | Same steps → same wrong actual (run twice) |
| **Flaky** | Raise rate (loop, stress, narrow timing) until debuggable — or Revise |
| **None** | Stop — ask env, HAR, logs; **do not** confirm bug |

Only after **D1 pass** → call it a **confirmed defect** (ไม่ใช่แค่สงสัยครั้งเดียว).

### 2 — Evidence

Fill [assets/template.evidence.md](assets/template.evidence.md). Capture or ask for:

- Request (method, path, headers if auth)
- Response body (redact secrets)
- Client file(s): component, hook, store, selector

### 3 — Fail path

Per [reference.md](reference.md): trace entry → break site before ranking hypotheses.

### 4 — Layer pass + hypotheses

Walk D2→D6 (hand off `@api-builder` if server wrong). List **3–5 ranked hypotheses**; run **disproof** for top candidate first.

Maintain [assets/template.breadcrumb-ledger.md](assets/template.breadcrumb-ledger.md) — update every experiment.

### 5 — Gate D

Post [assets/template.diagnosis-report.md](assets/template.diagnosis-report.md). **Approved** only if D1 pass + ledger consistent. **Stop** large fixes if Revise.

### 6 — Fix or handoff

| Root cause | Action |
|------------|--------|
| D2–D3 server | Packet → `@api-builder` with failing sample |
| D4–D6 client | Minimal fix after user OK, or narrow `@ui-builder` if purely visual styling |
| Mixed | Fix server first, re-run D4–D6 |

### 7 — Validate

Re-run **same repro steps** from D1. Actual must match expected before "done."

### 8 — Report

```
[debug] Diagnosis — <scope>
Gate D: Approved | Revise
Root cause layer: D4_map
| Layer | status | evidence | finding |
Handoff: none | @api-builder | @ui-builder
Summary (TH): …
Next: …
```

## Output flow

1. Confirm required inputs · **step 0** search learnings (Grep → ≤3 reads) if `vault/learnings/` exists  
2. D1 repro (pass / flaky / none)  
3. Evidence + fail path trace  
4. Layer table + breadcrumb ledger → hypotheses falsified  
5. **Gate D** (Approved only if D1 pass)  
6. User confirms fix → minimal patch **or** handoff  
7. Re-pro validate  
8. Write [post-fix-learning](assets/template.post-fix-learning.md) → `vault/learnings/` if ≥3 prompt rounds on same problem (rule vault-learning)  
9. Suggest `@pr-review` (select mode) then `@git-push` when user wants to ship  

## Cross-skill

| Situation | Skill |
|-----------|-------|
| Wrong response / validation / DB | `@api-builder` |
| Response OK, map/state/logic wrong | `@debug` |
| Values OK, layout vs mockup wrong | `@ui-builder` |
| New full feature | `@feature-builder` |
| After feature-builder F4 still wrong data | `@debug` |
| Ship (review + push) | `@pr-review` → `@git-push` |

## Language

- **70% ไทย / 30% อังกฤษ** — diagnosis, สรุป repro, คำถาม user เป็นภาษาไทย; ใช้อังกฤษ ~30% สำหรับ Gate D, layer IDs (D1–D4), root cause, handoff, pitfall #N
- **Mix ธรรมชาติ** — เช่น "Gate D **Approved** — **root cause** อยู่ที่ D4_map ไม่ใช่ API"
- **Gloss ครั้งแรกต่อ reply** — `root cause (สาเหตุหลัก)`, `handoff (ส่งต่อ skill อื่น)`
- **ไม่แปล** — path, layer IDs ในตาราง

## Resources

| File | Use |
|------|-----|
| [reference.md](reference.md) | Pitfalls, layers, handoff · § Rationalizations / Red flags |

Canonical: `ai-skills/debug/`
