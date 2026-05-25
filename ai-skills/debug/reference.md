# Debug — reference (v1.2.0)

Production/team debugging framework — load **one § per step** ([SKILL.md](SKILL.md) Quick reference).

## Index

| § | Section |
|---|---------|
| — | [Diagnosis precision](#diagnosis-precision) |
| 0 | [Search learnings](#search-learnings-step-0) |
| 1 | [Repro reliability matrix](#repro-reliability-matrix) |
| 2 | [Evidence priority order](#evidence-priority-order) |
| — | [Layer ownership](#layer-ownership) · [Diagnosis layers D1–D6](#diagnosis-layers) · [Layer detail](#layer-detail) |
| — | [Workflow D0–D8](#workflow-d0d8) |
| — | [Fail path](#fail-path-before-hypotheses) · [Instrumentation rules](#instrumentation-rules) |
| — | [Root cause ledger](#root-cause-ledger) · [Breadcrumb ledger](#breadcrumb-ledger) · [Falsify](#falsify-hypotheses) |
| — | [Minimal patch scoring](#minimal-patch-scoring) · [Regression surface (D7)](#regression-surface-d7) |
| — | [Common false diagnoses](#common-false-diagnoses) |
| — | [Report template](#report-template) · [Cross-skill](#cross-skill-matrix) · [Handoff packets](#handoff-packets) |
| — | [Pitfalls](#pitfalls) · [Red flags](#red-flags) |

## Diagnosis precision

| Order | Step | § |
|-------|------|---|
| 1 | D1 repro class | [Repro matrix](#repro-reliability-matrix) |
| 2 | D2 evidence (priority order) | [Evidence priority](#evidence-priority-order) |
| 3 | Fail path (+ instrumentation if needed) | [Fail path](#fail-path-before-hypotheses) · [Instrumentation](#instrumentation-rules) |
| 4 | Layer + ownership + ledgers + disproof | [Ownership](#layer-ownership) · [Root cause ledger](#root-cause-ledger) |
| 5 | Gate D | [diagnosis template](assets/template.diagnosis-report.md) |
| 6 | Fix — smallest [patch tier](#minimal-patch-scoring) | D6 |
| 7 | D7 re-pro + [regression surface](#regression-surface-d7) | D7–D8 |

**Wrong handoff?** Use [Layer ownership](#layer-ownership) — do not send UI layout to `@api-builder` when API body is correct.

## Search learnings (step 0)

Before D1 — [ai-rules/vault-learning.mdc](../../ai-rules/vault-learning.mdc) § Search learnings.

| Do | Don't |
|----|-------|
| Grep `vault/learnings/` — symptom, `skill:`, `symptoms:`, `files:` | Read every learning file |
| Read ≤3 best matches | Paste full archives |

## Repro reliability matrix

Fill [assets/template.repro.md](assets/template.repro.md). Tally **fail** = wrong **actual** (not loading skeleton).

| Type | Criteria | Action |
|------|----------|--------|
| **stable** | **2/2** fails — same steps, same wrong actual | Proceed to D2 |
| **semi-flaky** | **3/5** fails (or 2/3 minimum sample) | **Instrumentation required** before Gate D Approved — [§ Instrumentation](#instrumentation-rules) |
| **flaky** | **&lt;50%** fail under repeated runs | Collect timing, network, race, state snapshots; stress or harness; else **Revise** — no fix on guess |
| **non-repro** | **0** fails when steps followed | **Revise** — HAR, logs, env, screen recording; label **cannot reproduce** |

**Async-era rules:**

- Wait past loading/skeleton before judging data
- Same role, env, seed, auth; hard refresh when cache suspected
- Pin: time, network tab, request id

**D1 pass** = `stable` or `semi-flaky` with instrumentation plan executed and noted in diagnosis report.

## Evidence priority order

Collect in this order — **stop using lower tiers to overturn higher tiers** without new runtime capture.

| Priority | Source | Use for |
|----------|--------|---------|
| 1 | **Runtime actual values** | debugger, `console.log` at read site, React DevTools, DB row |
| 2 | **Network payload** | status + body (redact secrets), compare to expected |
| 3 | **Persisted state** | store, cache, localStorage, session |
| 4 | **Logs** | server/client structured logs, request id |
| 5 | **Screenshot / video** | context only — not proof of field values |
| 6 | **Human assumption** | last — must be marked "assumption" until confirmed by 1–4 |

Template: [assets/template.evidence.md](assets/template.evidence.md). **Blocker:** Gate D Revise if root cause relies only on priority 5–6.

## Layer ownership

Maps diagnosis layers to **owner** — use for handoff and primary layer choice.

| Layer | Scope | Owner | Skill |
|-------|--------|-------|-------|
| D1 | Repro | agent + user | `@debug` |
| D2 | API response | **backend** | `@api-builder` if body wrong |
| D3 | Shape / contract vs UI | **backend** + FE contract | `@api-builder` if server truth wrong |
| D4 | Mapper / transform | **frontend data** | `@debug` |
| D5 | State / store | **frontend logic** | `@debug` |
| D5b | Selector / computed | **frontend derived** | `@debug` |
| D6 | Render / template | **UI** | `@debug` (data) · `@ui-builder` if pixels only |
| — | Browser / runtime | **platform** | env, extension, timezone — note in D3/D4 |

**Primary root cause** = one row. Supporting layers = notes only.

## Workflow (D0–D8)

### D0 — Search learnings

[§ Search learnings](#search-learnings-step-0).

### D1 — Repro

[§ Repro reliability matrix](#repro-reliability-matrix) + [template.repro](assets/template.repro.md).

### D2 — Evidence

[§ Evidence priority](#evidence-priority-order) + [template.evidence](assets/template.evidence.md).

### D3 — Fail path

[§ Fail path](#fail-path-before-hypotheses). If unclear → [§ Instrumentation](#instrumentation-rules) **before** hypotheses.

### D4 — Layers, ledgers, disproof

1. Walk [§ Diagnosis layers](#diagnosis-layers) with [§ Layer ownership](#layer-ownership).
2. Fill [root-cause ledger](assets/template.root-cause-ledger.md) — Evidence | Supports | Contradicts per hypothesis.
3. Run experiments → [breadcrumb ledger](assets/template.breadcrumb-ledger.md) (one row per change).
4. [§ Falsify](#falsify-hypotheses) — disproof top candidate first.

### D5 — Gate D

[template.diagnosis-report](assets/template.diagnosis-report.md). **Approved** only if repro class, evidence priority, ledger, disproof, and one primary layer align.

### D6 — Fix or handoff

Apply [§ Minimal patch scoring](#minimal-patch-scoring). Handoff using [§ Handoff packets](#handoff-packets) when owner ≠ `@debug`.

### D7 — Validate + regression

1. Re-run D1 steps — actual = expected (**stable** class on fix verification).
2. Complete [§ Regression surface](#regression-surface-d7).

### D8 — Report + close

[§ Report template](#report-template). Remove all `[DBG-` instrumentation. Optional [post-fix-learning](assets/template.post-fix-learning.md). Ship: `@pr-review` → `@git-push`.

## Diagnosis layers

| Layer | Name | Question |
|-------|------|----------|
| D1 | Repro | [Repro class](#repro-reliability-matrix)? |
| D2 | API | Body truth vs source? |
| D3 | Shape | Fields/types match UI contract? |
| D4 | Map/bind | Wrong path, formatter, selector? |
| D5 | State/effects | Stale cache, missing invalidation? |
| D6 | Render logic | Condition, sort, filter, pagination? |

## Layer detail

### D2 — API

Status, body vs DB/log, auth headers.

### D3 — Shape

Field rename, nesting, coercion (`"123"` vs `123`).

### D4 — Map/bind

Wrong property, i18n key, formatter input, client selector typo.

### D5 — State/effects

Query invalidation, store slice, optimistic rollback, stale props.

### D6 — Render logic

Inverted boolean, sort direction, filter, pagination off-by-one.

## Fail path (before hypotheses)

1. **Debugger** at suspected read/mutation site
2. **Source trace** — entry → branches → state write → render
3. **Knobs** — one flag/env/input change at a time
4. **Instrumentation** — [§ Instrumentation rules](#instrumentation-rules)

No hypothesis list until break site is plausible.

## Instrumentation rules

**When required:**

| Trigger | Requirement |
|---------|-------------|
| **semi-flaky** repro | Timestamps on async edges; before/after values at mutation |
| **flaky** investigation | Network waterfall + state snapshot per run |
| **fail path unclear** | Temporary `[DBG-xxxx]` logs at suspect sites |
| **race suspected** | Log ordering + request ids |

**How:**

- Capture **before/after** on state writes and API handlers
- **Timestamp** `fetch` start/end, effect runs, render with data id
- **Diff** expected vs actual at runtime (priority 1), not screenshot
- Tag logs `[DBG-xxxx]` — grep repo before commit

**Before ship:**

- [ ] Remove or gate all `[DBG-` logs
- [ ] No debug-only env flags left on
- [ ] Note instrumentation in diagnosis report if user will review diff

## Root cause ledger

Structured reasoning — **mandatory at D4** before Approved.

Template: [assets/template.root-cause-ledger.md](assets/template.root-cause-ledger.md).

| Column | Meaning |
|--------|---------|
| **Evidence** | Observed fact (priority 1–4) |
| **Supports** | Which hypothesis this fact supports |
| **Contradicts** | Which hypothesis this fact rules out |

**Rules:**

- Every row must cite evidence tier (1–4)
- Hypothesis survives only if no **Contradicts** conflict without explanation
- Pair with [§ Falsify](#falsify-hypotheses) — active disproof experiment per top row

**vs breadcrumb:** Root-cause ledger = facts ↔ theories. Breadcrumb = what you **changed** each experiment.

## Breadcrumb ledger

[assets/template.breadcrumb-ledger.md](assets/template.breadcrumb-ledger.md) — after each experiment: change | result | ruled in/out.

New theory must fit **all** prior rows or be discarded.

## Falsify hypotheses

- **3–5** ranked candidates
- Define **disproof** for #1 → run first
- Update [root-cause ledger](#root-cause-ledger) after each result
- Promote to root cause only if survives + explains all ledger + breadcrumb rows

## Minimal patch scoring

**Choose smallest patch satisfying all evidence** — no drive-by refactor.

| Patch type | Allowed | Gate |
|------------|---------|------|
| **1–5 LOC** targeted fix | **Preferred** | D5 Approved |
| **Isolated function** change | OK | D5 Approved |
| **Module rewrite** | Only with Approved + user OK | Gate D explicit |
| **Architecture change** | **Forbidden** in debug session | → feature-builder / new design |

Record in diagnosis: `patch_tier: 1-5loc | function | module`.

## Regression surface (D7)

After fix, check **all that apply** in scope:

- [ ] **Original repro** — D1 steps, expected = actual
- [ ] **Adjacent flows** — same feature, neighboring routes
- [ ] **Loading state** — no flash of wrong data
- [ ] **Empty state** — zero/null data
- [ ] **Error state** — API error, validation message
- [ ] **Retry path** — user retry, refetch button
- [ ] **Stale cache** — back navigation, second tab, hard refresh
- [ ] **Navigation** — forward/back, deep link, refresh mid-flow

Note failures in report — do not mark done until original repro passes.

## Common false diagnoses

Check before locking root cause — many map to [§ Layer ownership](#layer-ownership).

| False diagnosis | Often actually | Layer |
|-----------------|----------------|-------|
| "Backend wrong" | Response OK, mapper wrong | D4 |
| "UI CSS bug" | Wrong number in data | D4–D5 |
| "Random flake" | Race / double fetch / no D1 matrix | D1 + instrumentation |
| **Stale closure** | Old value in callback | D5 |
| **Async race** | Later response wins wrong | D5 + instrumentation |
| **Optimistic update mismatch** | UI ahead of server | D5 |
| **Stale cache** | SWR/React Query key | D5 |
| **Double fetch** | Strict mode / duplicate effect | D5–D6 |
| **Derived state drift** | Selector memo wrong | D5b |
| **Timezone mismatch** | Server UTC vs local display | D3–D4 |
| **`undefined` → default coercion** | `??` / default props hide missing | D4 |
| **key instability** | `key={index}` reorder | D6 |
| **Screenshot looked wrong** | Runtime value differed | Re-check priority 1 |

## Report template

```text
[debug] Diagnosis — <scope>
Gate D: Approved | Revise
Repro class: stable | semi-flaky | flaky | non-repro
Instrumentation: none | [DBG-ids] | removed before ship
Evidence top tier used: 1-runtime | 2-network | …
Primary layer + owner: D4_map · frontend data
Patch tier: 1-5loc | function | module

## Root cause ledger (summary)
| Evidence | Supports | Contradicts |

## Regression (D7)
| check | pass/fail |
| original repro | … |

Handoff: none | @api-builder | @ui-builder
Summary (TH): …
Next: confirm fix | D7 fail item | ship after DBG removed
```

## Cross-skill matrix

| Evidence | Skill |
|----------|-------|
| API body wrong | `@api-builder` |
| Body OK, client wrong | `@debug` |
| Values OK, layout only | `@ui-builder` |
| New feature | `@feature-builder` |
| Ship | `@pr-review` → `@git-push` |

## Handoff packets

### To api-builder

```text
@api-builder
From @debug — owner: backend (D2/D3)
Symptom: <one line>
Repro class: stable | semi-flaky
Failing call: <method> <path>
Expected body: …
Actual body: … (priority 2 evidence)
Root cause ledger row: …
```

### To ui-builder

```text
@ui-builder
From @debug — data verified (D2–D3 pass)
Scope: <zone> · Viewport · Ref mockup
Runtime values OK; visual delta only.
```

## Pitfalls

See [§ Common false diagnoses](#common-false-diagnoses). Quick ops:

| # | Symptom | Fix |
|---|---------|-----|
| 1 | Fix on non-repro | Revise — matrix |
| 2 | Screenshot as proof | Runtime capture |
| 3 | Skip regression | D7 checklist |
| 4 | DBG logs in PR | Remove before ship |
| 5 | Module rewrite | Patch tier + Gate D |

## Red flags

- Fix when repro = **non-repro** or **flaky** without harness
- **semi-flaky** without instrumentation note in report
- Root cause from priority **5–6** only
- No [root-cause ledger](#root-cause-ledger) rows
- Patch tier **module** without Approved
- **Architecture change** proposed in debug
- `[DBG-` left in diff at ship time
- D7 original repro not re-run

## Self-upgrade

New repeatable false diagnosis → one row in [§ Common false diagnoses](#common-false-diagnoses). Do not bloat [SKILL.md](SKILL.md).
