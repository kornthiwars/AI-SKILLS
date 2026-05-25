# reference — PR Review modes (v1.1.3)

## Index

Jump to section (load **active mode** + needed rows only):

| § | Section |
|---|---------|
| — | [Modes matrix](#modes-matrix) · [Mode one-liners](#mode-one-liners) · [clean-code vs production](#clean-code-vs-production) |
| — | [Ship confidence](#ship-confidence-what-ready-means) |
| P1–P12 | [P1](#p1-intent--scope) · [P2](#p2-scope-creep) · [P3](#p3-security--secrets) · [P4](#p4-correctness--edge-cases) · [P5](#p5-api-contract--breaking) · [P6](#p6-data--migration) · [P7](#p7-tests) · [P8](#p8-error-handling) · [P9](#p9-performance) · [P10](#p10-maintainability) · [P10b](#p10b-dead--unused-code) · [P10c](#p10c-clean-code-diff-only) · [P11](#p11-docs--changelog) · [P12](#p12-prior-gate-evidence) |
| — | [Performance line by mode](#performance-line-by-mode) |
| — | [Severity](#severity) · [Waivers](#waivers) · [Re-review](#re-review) |
| 0–4 | [Workflow (steps 1–4)](#workflow-steps-14) · [Combo](#combo-optional) · [Output deliverable](#output-deliverable) · [AskQuestion](#askquestion-agent--step-0) |
| — | [Common rationalizations](#common-rationalizations-agent-discipline) · [Red flags](#red-flags) |

## Modes matrix

| Check | bugs | production | clean-code | scale-security |
|-------|:----:|:----------:|:----------:|:--------------:|
| P1 Intent / scope | req | req | req | req |
| P2 Scope creep | req | req | req | req |
| P3 Security / secrets | req | req | req (blocker if found) | **req+** |
| P4 Correctness / edge cases | **req+** | req | skip | req |
| P5 API contract / breaking | note | req | skip | req |
| P6 Data / migration | note | req | skip | **req+** |
| P7 Tests | note | req | skip | req |
| P8 Error handling | **req+** | req | skip | req |
| P9 Performance | note | req | skip | **req+** |
| P10 Maintainability | note | req | **req+** | req |
| P10b Dead / unused code | note | **req** | **req** | note |
| P10c Clean code (diff) | skip | note | **req+** | skip |
| P11 Docs / changelog | skip | req | skip | req |
| P12 Prior gate evidence | skip | req | skip | note |

**req+** = extra scrutiny (more rows in table)  
**skip** = do not run unless user asks combo with another mode

### Mode one-liners

| Mode | When | User-facing label |
|------|------|-------------------|
| `bugs` | ก่อน commit | Review for bugs and edge cases |
| `production` | ก่อน PR | Review for production readiness |
| `clean-code` | ก่อน PR / หลัง implement | Structure, naming, DRY, hygiene in **diff** |
| `scale-security` | ก่อน deploy | Scalability, security, and performance |

### clean-code vs production

| Topic | `clean-code` | `production` |
|-------|--------------|----------------|
| Naming, DRY, file size in diff | **focus** | partial (P10) |
| Tests, docs, API contract | skip | req |
| Edge cases / auth paths | skip | req |
| Dead/unused in diff | **req** (P10b) | req |
| Ship bar | 0 blockers for **clean-code** only | full production checklist |

Not a separate skill — same `ready` / `revise` + `@git-push` handoff.

## Ship confidence (what `ready` means)

`ready` is **per mode only** — it does not guarantee the app will not break at runtime.

| Mode | `ready` means | Does **not** guarantee |
|------|---------------|-------------------------|
| `clean-code` | 0 blockers on hygiene in **diff** (P10c, P10b, P1–P2) | Correctness, tests, full PR readiness |
| `bugs` | 0 blockers on logic/edge in scope | Style-only pass; production checklist |
| `production` | 0 blockers on PR readiness checklist | Deploy-scale perf/security (use `scale-security`) |
| `scale-security` | 0 blockers on perf/security layers in scope | Pixel-perfect UI |

**If user asks “clean-code แล้วมั่นใจไม่พัง?”** — answer in Thai: hygiene ลดความเสี่ยงซ่อนเร้ง; ต้องรัน `bugs` + มักต้อง `production` + test/build ในโปรเจกต์

**Suggested combo before push (app repo):**

```text
@pr-review bugs → ready
@pr-review clean-code → ready   (optional)
@pr-review production → ready
@git-push
```

State which modes already `ready` when user pastes verdict to git-push.

---

## P1 Intent / scope

- Diff matches stated feature / user request?
- **blocker:** unrelated feature or missing must-have from scope

## P2 Scope creep

- Drive-by refactors, unrelated files, formatting-only churn?
- **blocker:** large unrelated change user did not ask for

## P3 Security / secrets

| Find | Action |
|------|--------|
| `.env` with real values | blocker |
| tokens, private keys | blocker |
| new route without auth when siblings use auth | blocker (production+) |
| SQL concat, `eval`, path traversal | blocker (scale-security) |

## P4 Correctness / edge cases

- null/undefined, empty array, boundary values
- race, stale state, off-by-one
- async: missing await, unhandled rejection
- **bugs mode:** treat uncertain logic as **major** minimum

## P5 API contract / breaking

- Response shape matches existing patterns / OpenAPI?
- Breaking change documented?
- **blocker:** silent breaking change (production+)

## P6 Data / migration

- destructive DDL without plan?
- **blocker:** DROP/DELETE column without backup note (scale-security)

## P7 Tests

- Behavior change with nearby tests unchanged?
- **major** if risky path; **note** if low risk (bugs)
- **blocker:** critical path untested when repo already tests similar (production+)

## P8 Error handling

- empty catch, swallowed errors
- user-facing error messages leak internals
- **blocker:** silent failure on payment/auth paths (production+)

## P9 Performance

Always output **Performance (TH):** one sentence.

### By layer (use what applies to diff)

| Layer | Look for | blocker examples |
|-------|----------|------------------|
| **P-FE** | re-render loops, huge lists without pagination/virtualize, heavy imports | `useEffect` dependency loop |
| **P-API** | N+1, unbounded `findMany`, missing limit | query in loop |
| **P-net** | huge JSON payloads, aggressive polling | full table every poll |
| **P-algo** | O(n²) on hot path, sync CPU on request | parse 50MB per request |
| **P-asset** | unoptimized images/fonts | multi-MB hero no sizing |
| **P-infra** | missing index on new filter/join columns | migration without index |

| Mode | P9 depth |
|------|----------|
| bugs | obvious regressions only |
| production | PR-safe perf (pagination, obvious N+1) |
| scale-security | full pass on all layers in table |

## P10 Maintainability

- duplicate logic, wrong abstraction layer
- **major:** copy-paste security-sensitive code

## P10b Dead / unused code

Scope: **diff only** — do not repo-wide purge unless user asks. Prefer grep/IDE hints over reading every file.

| Find | Action |
|------|--------|
| New export/function with **zero** references in repo (app code) | **major** (production+) · **note** (bugs) |
| Imports added in diff but unused | **major** (production+) |
| Large commented-out blocks left in diff | **major** |
| Deleted caller but callee / route / component still present | **major** |
| `@deprecated` re-export kept without migration note | **note** |
| Intentional stub for next PR (user said so) | skip with note |
| Generated / vendor / lockfile churn | skip |

**Token:** check symbols **touched in diff** and their immediate callers — not full dead-code audit of monorepo.

**Not here:** runtime memory leaks, deleting files user did not change — suggest separate cleanup task.

## P10c Clean code (diff-only)

**Scope:** files and hunks in this batch only — no repo-wide refactor sprint.

| Find | Severity |
|------|----------|
| Unused import / variable introduced in diff | major |
| New export with zero references in app code | major |
| Large commented-out block left in diff | major |
| Duplicate logic block copy-pasted in diff | major |
| Function/component clearly too long **in changed file** (e.g. >>80 lines added without split) | major · **note** if user justified |
| Naming inconsistent with surrounding module (casing, abbreviations) | major · nit for trivial |
| Magic number/string in diff without named constant | note · major if repeated |
| Business logic in UI layer (or API in view) introduced in diff | major |
| Deep nesting added in diff (hard to follow) | note · major if extreme |
| Drive-by rename/format unrelated to feature | major (also P2) |

**blocker:** security-sensitive copy-paste (also P3) · secrets in diff

**Not here:** pixel/layout (`@ui-builder`) · full OpenAPI review · monorepo dead-code purge · large refactor user did not scope — suggest follow-up PR

**Token:** symbols and files **touched in diff** — do not read entire codebase for style.

## Performance line by mode

Always output **Performance (TH):** one sentence at end of deliverable.

| Mode | Line (TH example) |
|------|-------------------|
| `bugs` | โฟกัส logic/edge — perf เฉพาะ regression ชัดใน diff |
| `production` | สรุป perf ระดับ PR (pagination, N+1 ชัด) ตาม § P9 |
| `clean-code` | โหมด clean-code — ไม่สแกน perf เต็ม; ใช้ `scale-security` ถ้าต้องการ |
| `scale-security` | สรุปตาม § P9 ทุก layer ที่เกี่ยวกับ diff |

## P11 Docs / changelog

- public API / env vars documented?
- **note** if minor; **major** if operators need runbook (production+)

## P12 Prior gate evidence

- ui-builder Gate B, api-builder Ship, feature-builder Feature Ship — user should paste paths or summaries
- **production:** **major** if UI/API work claimed done but no evidence
- not a pixel re-review — only “was gate satisfied?”

---

## Severity

| Level | Meaning |
|-------|---------|
| blocker | must fix before `ready` |
| major | should fix; user may waive in chat with reason |
| minor | nice to fix |
| nit | style |

## Waivers

User may waive **major** / **note** in chat (`waive P9 major: …`). **blockers** need fix or explicit waive with logged reason in table.

## Re-review

Same mode + unchanged diff → may cite prior verdict timestamp and only scan new commits/files.

---

## Workflow (steps 1–4)

Load when executing Quick ref steps 1–4 in [SKILL.md](SKILL.md).

### 1 — Scope and diff

Confirm with user if unclear: batch goal; which files/commits are in scope (no unrelated drive-by). Inspect workspace hunks or user-pasted `git diff`.

### 2 — Checklist by mode

Run only checks **required** for the active mode in § Modes above.

- **clean-code:** § Modes matrix column + § P10c — always **P10b** (diff-only).
- **Other modes:** **P10b** when in diff scope — § P10b (no full-repo purge).

Record every **blocker** and **major** in the output table. **nit** / **note** optional.

### 3 — Verdict

| Verdict | Meaning |
|---------|---------|
| **ready** | 0 blockers for this mode; user may `@git-push` (or deploy for `scale-security`) |
| **revise** | ≥1 blocker or fix majors before push/deploy |

**Ship confidence:** `ready` = 0 blockers **for this mode only** — see § Ship confidence (`clean-code` ≠ “โค้ดไม่พัง”).

**Performance line (required):** one Thai sentence — § Performance line by mode.

### 4 — Handoff

| Verdict | Next |
|---------|------|
| `ready` + before push | `@git-push` — user may paste verdict; git-push v2 does **not** re-review code |
| `revise` | list fixes; re-run `@pr-review` same mode after fix |
| `ready` + `scale-security` before deploy | deploy checklist / monitoring; still no git from pr-review |

## Combo (optional)

Separate invokes on the same diff — do not merge checklists:

1. `@pr-review` → `bugs` → `ready`
2. `@pr-review` → `clean-code` → `ready` (optional)
3. `@pr-review` → `production` → `ready`
4. `@git-push`

`clean-code` does **not** replace `production`.

## Output deliverable

Required before ending turn:

```text
[pr-review] mode: <mode> — <scope>
Diff: <description>
Verdict: ready | revise

| ID | severity | file:line | finding | suggestion |

Performance (TH): …
Summary (TH): …
Next: …
```

---

## AskQuestion (agent) — Step 0

When Step 0 runs, use the tool **AskQuestion** — do not invent a text-only menu. Single-select only.

If the environment has no AskQuestion, show the four options as a numbered list and **stop** until user replies with `bugs`, `production`, `clean-code`, or `scale-security`.

**Detect mode from message** (skip AskQuestion if any alias matches):

| Mode id | Aliases in user message |
|---------|-------------------------|
| `bugs` | `bugs`, `ก่อน commit`, `edge case`, `bug review` |
| `production` | `production`, `ก่อน PR`, `production readiness`, `พร้อม PR` |
| `scale-security` | `scale-security`, `scale`, `ก่อน deploy`, `scalability`, `security review` |
| `clean-code` | `clean-code`, `clean code`, `code smell`, `refactor hygiene`, `maintainability`, `โค้ดสะอาด`, `clean code review` |

**AskQuestion** (exact shape):

- **title:** `PR Review — เลือกโหมด`
- **question id:** `pr-review-mode`
- **prompt:** `จะรีวิวชุดงานนี้แบบไหน? (เลือก 1)`
- **allow_multiple:** `false`

| id | label |
|----|--------|
| `bugs` | ก่อน commit — Review for bugs and edge cases |
| `production` | ก่อน PR — Review for production readiness |
| `scale-security` | ก่อน deploy — Scalability, security, and performance |
| `clean-code` | โครงสร้างโค้ด — Naming, DRY, hygiene in diff (not full production pass) |

After select or typed mode, echo:

```text
[pr-review] mode: <bugs|production|clean-code|scale-security>
```

Then continue Step 1.

## Common rationalizations (agent discipline)

| Rationalization | Reality |
|-----------------|---------|
| "ready เลย ไม่มี blocker ชัด" | `ready` = 0 blockers **สำหรับโหมดนี้** — ต้องมีตาราง |
| "production ครอบ bugs แล้ว" | เลือกโหมดตรงงาน — bugs เล็กไม่ต้อง production ทุกครั้ง |
| "clean-code แทน production ได้" | clean-code ไม่มี tests/docs/contract — รัน production ถ้าจะ push PR จริง |
| "clean-code = ลบไฟล์ทั้ง repo" | P10b/P10c = **diff only** |
| "clean-code ready = โค้ดไม่พัง" | อธิบาย § Ship confidence — แนะนำ bugs + production |
| "ข้าม AskQuestion user บอก push" | Step 0 บังคับถ้าไม่ระบุโหมด |
| "git-push จะรีวิวโค้ดให้" | git-push v2 ไม่รีวิวโค้ด — ใช้ pr-review ก่อนถ้าต้องการ |
| "waive ทุก major ในหัว" | major waive ต้องเขียนใน chat ต่อแถว |

## Red flags

- Verdict `ready` โดยไม่มี `| ID | severity | file:line |`
- โหมด `scale-security` หรือ `clean-code` แต่ไม่มีบรรทัด Performance (TH) ตาม § Performance line by mode
- รีวิว pixel/layout แทน logic — ส่ง `@ui-builder`
- รัน `git add` / `commit` ใน skill นี้
- User ขอ deploy prod แต่ verdict `revise`
