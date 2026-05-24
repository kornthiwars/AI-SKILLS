# reference — PR Review modes

## Modes matrix

| Check | bugs | production | scale-security |
|-------|:----:|:----------:|:--------------:|
| P1 Intent / scope | req | req | req |
| P2 Scope creep | req | req | req |
| P3 Security / secrets | req | req | **req+** |
| P4 Correctness / edge cases | **req+** | req | req |
| P5 API contract / breaking | note | req | req |
| P6 Data / migration | note | req | **req+** |
| P7 Tests | note | req | req |
| P8 Error handling | **req+** | req | req |
| P9 Performance | note | req | **req+** |
| P10 Maintainability | note | req | req |
| P10b Dead / unused code | note | **req** | note |
| P11 Docs / changelog | skip | req | req |
| P12 Prior gate evidence | skip | req | note |

**req+** = extra scrutiny (more rows in table)

### Mode one-liners

| Mode | When | User-facing label |
|------|------|-------------------|
| `bugs` | ก่อน commit | Review for bugs and edge cases |
| `production` | ก่อน PR | Review for production readiness |
| `scale-security` | ก่อน deploy | Scalability, security, and performance |

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

## AskQuestion (agent)

When Step 0 runs, use the tool **AskQuestion** — do not invent a text-only menu. Single-select only.

If the environment has no AskQuestion, show the three options as a numbered list and **stop** until user replies with `bugs`, `production`, or `scale-security`.

## Common rationalizations (agent discipline)

| Rationalization | Reality |
|-----------------|---------|
| "ready เลย ไม่มี blocker ชัด" | `ready` = 0 blockers **สำหรับโหมดนี้** — ต้องมีตาราง |
| "production ครอบ bugs แล้ว" | เลือกโหมดตรงงาน — bugs เล็กไม่ต้อง production ทุกครั้ง |
| "ข้าม AskQuestion user บอก push" | Step 0 บังคับถ้าไม่ระบุโหมด |
| "git-push จะรีวิวโค้ดให้" | git-push v2 ไม่รีวิวโค้ด — ใช้ pr-review ก่อนถ้าต้องการ |
| "waive ทุก major ในหัว" | major waive ต้องเขียนใน chat ต่อแถว |

## Red flags

- Verdict `ready` โดยไม่มี `| ID | severity | file:line |`
- โหมด `scale-security` แต่ไม่มีบรรทัด Performance (TH)
- รีวิว pixel/layout แทน logic — ส่ง `@ui-builder`
- รัน `git add` / `commit` ใน skill นี้
- User ขอ deploy prod แต่ verdict `revise`
