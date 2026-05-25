# Debug — reference (v1.1.0)

Layer detail, workflow, fail path, falsify, ledger, handoffs.

## Index

| § | Section |
|---|---------|
| — | [Diagnosis precision](#diagnosis-precision) |
| 0 | [Search learnings](#search-learnings-step-0) |
| — | [Workflow D0–D8](#workflow-d0d8) |
| — | [Diagnosis layers](#diagnosis-layers) · [Layer detail D1–D6](#layer-detail) |
| — | [Fail path](#fail-path-before-hypotheses) · [Falsify](#falsify-hypotheses) · [Breadcrumb ledger](#breadcrumb-ledger) |
| — | [Report template](#report-template) |
| — | [Cross-skill matrix](#cross-skill-matrix) · [Handoff packets](#handoff-packets) |
| — | [Pitfalls](#pitfalls) · [Red flags](#red-flags) |

## Diagnosis precision

Use this order so findings stay **targeted** and **repeatable** — do not skip steps.

| Order | Step | Goal |
|-------|------|------|
| 1 | D1 repro | **Confirm** defect — same steps, same wrong actual **≥2 runs** (or flake harness) |
| 2 | D2 evidence | Sample request/response + client path — no guessing field names |
| 3 | Fail path | Narrow **where** execution breaks before naming a cause |
| 4 | Layers D2→D6 | Mark pass/fail per layer — **one** primary root cause layer |
| 5 | Hypotheses + disproof | 3–5 ranked; **disprove #1 first**; ledger row per experiment |
| 6 | Gate D | Approved only if 1–5 consistent |
| 7 | Fix + D7 | Minimal patch → **re-run D1 steps** — actual must match expected |

**Wrong layer?** If D2 passes (body correct) do not hand off to `@api-builder` — continue D3–D6.

## Search learnings (step 0)

Before D1 — [ai-rules/vault-learning.mdc](../../ai-rules/vault-learning.mdc) § Search learnings.

| Do | Don't |
|----|-------|
| Grep `vault/learnings/` with symptom, `skill:`, `symptoms:`, `files:` | Read every file in learnings/ |
| Read ≤3 best matches | Load learnings into context "just in case" |
| `head_limit` on grep output | Paste full archive of old lessons |

If a prior lesson matches, cite filename in diagnosis — do not duplicate long bodies in chat.

## Workflow (D0–D8)

Load per [SKILL.md](SKILL.md) Quick reference. Full order: [§ Diagnosis precision](#diagnosis-precision).

### D0 — Search learnings

[§ Search learnings](#search-learnings-step-0) — before D1.

### D1 — Repro (confirm)

Fill [assets/template.repro.md](assets/template.repro.md). **D1 pass** = confirmed defect — not a single glance.

| Class | Criteria | Action |
|-------|----------|--------|
| **Reliable** | Same steps → same wrong **actual** ≥ **2 runs** | Proceed |
| **Flaky** | Intermittent | Stress until ≥50% or deterministic trigger; else Revise |
| **None** | Cannot reproduce | Stop — HAR/logs/env; label **cannot reproduce** |

Also: same role/env/seed · hard refresh · wait past skeleton · pin time/network/auth.

### D2 — Evidence

Fill [assets/template.evidence.md](assets/template.evidence.md) — request/response (redact secrets), client paths, types/OpenAPI.

### D3 — Fail path

[§ Fail path](#fail-path-before-hypotheses) — **before** hypotheses. No fix until plausible break site.

### D4 — Layers + hypotheses

Walk [§ Diagnosis layers](#diagnosis-layers) D2→D6. Server wrong → `@api-builder` packet. Client: **3–5** hypotheses, [§ Falsify](#falsify-hypotheses), [breadcrumb ledger](assets/template.breadcrumb-ledger.md).

### D5 — Gate D

[assets/template.diagnosis-report.md](assets/template.diagnosis-report.md). **Approved** = D1 pass + disproof done + ledger explains all rows + one primary layer.

### D6 — Fix or handoff

| Root cause | Action |
|------------|--------|
| D2–D3 server | [§ Handoff packets](#handoff-packets) → `@api-builder` |
| D4–D6 client | Minimal fix after user OK |
| Styling only, data OK | `@ui-builder` packet |
| Mixed | Server first, re-run D4–D6 |

### D7 — Validate (repeat to confirm fix)

**Re-run D1 repro steps** — not "looks fine". Actual must match **expected**. If still wrong → Revise Gate D, new ledger rows.

### D8 — Report + close

[§ Report template](#report-template). Optional [post-fix-learning](assets/template.post-fix-learning.md) if ≥2 rounds. Ship: `@pr-review` → `@git-push`.

## Report template

```text
[debug] Diagnosis — <scope>
Gate D: Approved | Revise
D1 repro: pass (reliable x2 | flaky harness) | fail | none
Root cause layer: D4_map
| Layer | status | evidence | finding |
Disproof: <top hypothesis> — survived? yes/no
Handoff: none | @api-builder | @ui-builder
Summary (TH): …
Next: user confirm fix | handoff | D7 re-pro
```

## Diagnosis layers

**Primary root cause** = exactly **one** layer. Supporting notes allowed; do not ship multiple "equals" without ranking.

| Layer | Name | Question |
|-------|------|----------|
| D1 | Repro | Repeatable wrong actual? ([§ D1](#d1--repro-confirm)) |
| D2 | API | Status/body truth vs source? |
| D3 | Shape | Fields/types match what UI reads? |
| D4 | Map/bind | Wrong path, formatter, i18n key? |
| D5 | State/effects | Stale cache, missing invalidation? |
| D6 | Render logic | Wrong condition, sort, filter, pagination? |

## Layer detail

### D2 — API

- Status code expected?
- Body matches DB/source (spot-check query or log)?
- Auth headers present?

### D3 — Shape

- UI expects `total` but API returns `subtotal`?
- Nested path vs flat field?
- Type coercion breaking formatters?

### D4 — Map/bind

- Wrong property in JSX/template
- i18n key or label map
- Currency/date formatter on wrong field
- Client selector typo

### D5 — State/effects

- Query key not invalidated after mutation
- Store slice not updated
- Optimistic update not rolled back
- Stale props from parent

### D6 — Render logic

- Inverted boolean condition
- Sort ASC vs DESC
- Filter hiding rows
- Off-by-one pagination

## Fail path (before hypotheses)

Narrow **where** it breaks — escalate only if prior step fails:

1. **Debugger** — breakpoint at suspected site (if env allows)
2. **Source trace** — entry → calls → branches → state mutated → exit
3. **Knobs** — flags, env, toggles, input shape (one change at a time)
4. **Instrumentation** — tagged logs `[DBG-xxxx]` at fail site; grep to remove later

Do not list hypotheses until fail path is plausible.

## Falsify hypotheses

- **3–5** candidates, ranked by likelihood
- Top candidate: define **disproof** → run disproof **first**
- Survives disproof **and** explains **every** ledger row → promote to root cause
- New theory contradicting a ledger row → **discard** theory, not the row
- Single-hypothesis anchoring without disproof → Revise Gate D

## Breadcrumb ledger

Use [assets/template.breadcrumb-ledger.md](assets/template.breadcrumb-ledger.md).

After **each** experiment: what changed, what happened, ruled in/out.

New theory must explain **all** prior rows or be discarded.

## Pitfalls

| # | Symptom | Fix |
|---|---------|-----|
| 1 | Jump to ui-builder for wrong number | Confirm API body first |
| 2 | api-builder when Network 200 OK | Prove body wrong first |
| 3 | Fix symptom in CSS | Data bug — map/state |
| 4 | Large refactor without Gate D | Diagnose first |
| 5 | No sample response | Revise — reproduce call |
| 6 | Assume field name from memory | Read types/OpenAPI/UI |
| 7 | Ignore auth on repro | 401 → empty list |
| 8 | Test only happy path | Use failing user data |
| 9 | Multiple "equal" root causes | Rank one primary |
| 10 | debug in ai-skills repo | App repo only |
| 11 | Skeleton mistaken for wrong data | Wait for settled state |
| 12 | Timezone vs display | D3/D4 + formatter |
| 13 | key={index} reorder bugs | Note in D6 |
| 14 | One-off glitch = bug | D1 pass required |
| 15 | Fix before disproof | Run falsify step |
| 16 | "Done" without D7 | Re-run D1 steps |
| 17 | Hypothesis vs ledger clash | Revise Gate D |
| 18 | mockup-only, no data values | ui-builder or ask data |

## Cross-skill matrix

| Evidence | Skill |
|----------|-------|
| Response wrong | `@api-builder` |
| Response OK, UI wrong | `@debug` |
| Values OK, layout wrong | `@ui-builder` |
| New feature | `@feature-builder` |
| Ship | `@pr-review` → `@git-push` |

## Handoff packets

### To api-builder

```text
@api-builder
From @debug — server layer D2/D3
Symptom: <one line>
Failing call: <method> <path>
Expected body: …
Actual body: …
Fix contract/implementation; return Ship evidence.
```

### To ui-builder (visual only, data verified)

```text
@ui-builder
From @debug — data verified OK at D2–D3
Scope: <zone> · Viewport <W×H> · Ref: <mockup>
Do not change API; visual delta only.
```

## Red flags

Stop or Revise Gate D if any:

- Fix or large diff **before D1 pass** (≥2 runs)
- Hypotheses **before** fail path
- No request/response sample at D2
- No disproof run on top hypothesis
- Multi-file change **without** breadcrumb ledger
- New hypothesis **contradicts** ledger rows
- User says "เสร็จ" but **D7 re-pro** not run
- `@api-builder` without handoff packet
- **debug + mockup only** — no expected/actual data
- New endpoint work in debug session → use api-builder

| Rationalization | Reality |
|-----------------|---------|
| "เห็นแล้ว แก้เลย" | D1 pass first |
| "API น่าผิด" | Prove body wrong |
| "repro ครั้งเดียวพอ" | Reliable = ≥2 identical wrong actuals |
| "Gate D ช้า" | Approved before big refactor |

## Self-upgrade

Repeatable diagnosis gap → one pitfall row here — do not bloat [SKILL.md](SKILL.md).
