# Debug — reference (v1.0.0)

Layer detail, fail path, breadcrumb ledger, pitfalls.

## Layer detail

### D1 — Repro (confirmed defect)

**Gate D Approved requires D1 pass.**

| Class | Criteria | Action |
|-------|----------|--------|
| **Reliable** | Same steps → same wrong **actual** at least **2 runs** | Proceed |
| **Flaky** | Sometimes wrong | Loop/stress until ≥50% or deterministic trigger; else Revise |
| **None** | Cannot reproduce | Stop — ask HAR, logs, env; label **cannot reproduce**, not "bug confirmed" |

Also check:

- Same user role, env, data seed
- Hard refresh / cache cleared
- Wait past loading skeleton before judging data
- Pin: time, network, auth token

Target: fast pass/fail signal (test, curl, one page action)

## Fail path (before hypotheses)

Narrow **where** it breaks — escalate only if prior step fails:

1. **Debugger** — breakpoint at suspected site (if env allows)
2. **Source trace** — entry → calls → branches → state mutated → exit
3. **Knobs** — flags, env, feature toggles, input shape (flip one at a time)
4. **Instrumentation** — tagged logs `[DBG-xxxx]` at fail site; grep to remove later

Do not propose a fix until fail path is plausible.

## Falsify hypotheses

- List **3–5** candidates, ranked
- For top candidate: what would **disprove** it? Run disproof **first**
- Survives disproof + fits **every** ledger row → promote to root cause
- Single-hypothesis anchoring is a failure mode

## Breadcrumb ledger

Use [assets/template.breadcrumb-ledger.md](assets/template.breadcrumb-ledger.md).

After each experiment: what changed, what happened, ruled in/out.

New theory must explain **all** prior rows or be discarded.

### D2 — API

- Status code expected?
- Body matches DB/source of truth (spot-check query or log if available)?
- Auth headers present?

### D3 — Shape

- UI expects `total` but API returns `subtotal`?
- Nested path `order.customer.name` vs flat `customerName`?
- Type coercion (`"123"` vs `123`) breaking formatters?

### D4 — Map/bind

- Wrong property in JSX/template
- i18n key or label map
- Currency/date formatter input wrong field
- GraphQL/REST client selector typo

### D5 — State/effects

- React Query / SWR key not invalidated after mutation
- Redux/Zustand slice not updated
- Optimistic update not rolled back on error
- Props drilling stale parent state

### D6 — Render logic

- Inverted boolean condition
- Sort ASC vs DESC
- Filter hiding rows incorrectly
- Off-by-one pagination

## Pitfalls

| # | Symptom | Fix |
|---|---------|-----|
| 1 | Jump to ui-builder for wrong number | Confirm API body first — debug |
| 2 | Jump to api-builder when Network 200 OK | Prove body wrong before server work |
| 3 | Fix symptom in CSS | Data bug — fix map/state |
| 4 | Large refactor without Gate D | Diagnose first |
| 5 | No sample response | Revise — ask user or reproduce call |
| 6 | Assume field name from memory | Read types/OpenAPI/component interface |
| 7 | Ignore auth on repro | 401 cached as empty list |
| 8 | Test only happy path | Include failing user data |
| 9 | Multiple root causes | Rank primary + notes |
| 10 | debug in skills repo | Wrong workspace — app repo only |
| 11 | Confuse loading skeleton with wrong data | Wait for settled state in repro |
| 12 | Server timezone vs display | Note layer D3/D4 + formatter |
| 13 | List key={index} hiding reorder bugs | Note in D6 |
| 14 | Feature-builder F4 done but data wrong | This skill — not re-run ui-builder for pixels |
| 15 | Early "fixed" without re-repro | Re-run repro after patch |
| 16 | One-off glitch called bug | Require D1 pass (2 runs or stable flake harness) |
| 17 | Hypothesis contradicts ledger | Revise Gate D |
| 18 | Fix before disproof | Falsify step skipped |

## Cross-skill matrix

| Evidence | Skill |
|----------|-------|
| Response wrong | `@api-builder` |
| Response OK, UI wrong | `@debug` |
| Values OK, layout wrong | `@ui-builder` |
| New feature | `@feature-builder` |
| Ship | `@pr-review` → `@git-push` — this skill never runs git CLI |

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

### To ui-builder (visual only, data already correct)

```text
@ui-builder
From @debug — data verified OK at D2–D3
Scope: <zone only> · Viewport <W×H> · Ref: <mockup>
Do not change API; visual delta only.
```

## Common rationalizations (agent discipline)

| Rationalization | Reality |
|-----------------|---------|
| "เห็นบั๊กแล้ว แก้เลย ไม่ต้อง repro" | D1 ต้อง pass ก่อนเรียก confirmed defect |
| "API น่าจะผิด แก้ server ก่อน" | ต้องมี evidence — ถ้า response ถูก → D4–D6 client |
| "mockup ผิด = debug" | ไม่มี expected/actual data → `@ui-builder` หรือถามข้อมูล |
| "Gate D ช้า ข้ามไป refactor" | Gate D = Approved ก่อนแก้ใหญ่ |
| "repro ครั้งเดียวพอ" | Reliable = same steps 2 runs (หรือ flake harness) |

## Red flags

- แก้หลายไฟล์โดยไม่มี breadcrumb ledger
- Hypothesis ใหม่ขัดกับแถวก่อนหน้าใน ledger
- สรุป root cause โดยไม่มี request/response sample
- User บอก "เสร็จแล้ว" แต่ไม่ re-run repro จาก D1
- เรียก `@api-builder` โดยไม่มี failing packet

## Anti-patterns

1. **debug + mockup only** — no expected/actual data → ui-builder or ask data question
2. **Implement new endpoint in debug** → api-builder
3. **Skip Gate D on multi-file refactor**

## Self-upgrade

Repeatable diagnosis gap → one pitfall row here — do not bloat [SKILL.md](SKILL.md).
