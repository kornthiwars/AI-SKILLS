---
name: pr-review
description: >-
  PR Review — author self-review before commit, PR, or deploy. Modes: bugs (edge
  cases), production (readiness), clean-code (structure, naming, hygiene in diff),
  scale-security (scalability, security, performance). User picks mode via select when
  not specified. Triggers on /pr-review, @pr-review, pr review, รีวิวก่อน push,
  รีวิวก่อน commit, production readiness, clean code, code smell, refactor hygiene,
  dead code, unused code, โค้ดไม่ใช้, ลบโค้ดค้าง.
  Does not apply to pixel/mockup (ui-builder), API implementation (api-builder),
  full feature orchestration (feature-builder), debugging fixes (debug), ai-skills repo
  maintenance (@upgrade), or any git commit/push (git-push only).
compatibility: Cursor and Claude Code; read-only review; AskQuestion for mode when not specified
disable-model-invocation: true
metadata:
  version: "1.1.0"
  author: kornthiwars
  license: MIT
  surfaces:
    - ide
---

# PR Review

**Self-review** finished work in the **user's app repo** before `@git-push`. Pick a **mode** (select menu or explicit in chat). Output: `ready` or `revise` + table — **no git commands**.

Details: [reference.md](reference.md)

## Operating stance

- **Author gate** — you are reviewing your own batch of work, not a stranger's PR on GitHub
- **Mode drives depth** — pick one checklist ([reference.md](reference.md) § Modes); `clean-code` ≠ full `production`
- **Read-only** — do not edit files unless user asks to fix findings in the same session
- **Hand off git** — after `ready`, tell user `@git-push`; never run `git add` / `commit` / `push`
- **Token** — one mode per pass unless user asks for combo; load [reference.md](reference.md) § for active mode only — not full file at start

## Language

- **70% ไทย / 30% อังกฤษ** — สรุป findings, คำถาม, ข้อเสนอแก้เป็นภาษาไทย; ใช้อังกฤษ ~30% สำหรับ mode ids (bugs, production, clean-code, scale-security), severity, ready/revise, blocker, P1–P10c
- **Mix ธรรมชาติ** — เช่น "โหมด **production** — ผล **ready** มี blocker 0 จุด"
- **Gloss ครั้งแรกต่อ reply** — `ready (พร้อม push)`, `revise (ต้องแก้ก่อน)`, `blocker (ต้องแก้)`
- **ไม่แปล** — file paths, mode ids ในตาราง

## Required inputs

- [ ] **Mode** — `bugs` | `production` | `clean-code` | `scale-security` (from select or user message)
- [ ] **Scope** — feature name or 1–2 sentences what this batch should achieve
- [ ] **Diff scope** — default: unstaged + staged; or `main...HEAD` if user names a base branch

If mode missing → **Step 0 select only** (do not start checklist until mode is known).

## Hard rules

- **No git commands** — no `git status` / `add` / `commit` / `push` / `pull` / `rebase`; user may run git locally — you review output they have or files in workspace
- **Step 0 select** — if mode not in user message, run **AskQuestion** (§ Mode select) before review
- **No merge / no deploy** — verdict is advisory for the author
- **No ui-builder Gate A/B** — layout/pixel → `@ui-builder` in a separate pass
- **No rubber-stamp** — every `ready` needs checklist rows for the active mode

## Step 0 — Mode select (AskQuestion)

Run **when the user did not already set mode** in the same message.

Detect mode from message (skip AskQuestion if any match):

| Mode id | Aliases in user message |
|---------|-------------------------|
| `bugs` | `bugs`, `ก่อน commit`, `edge case`, `bug review` |
| `production` | `production`, `ก่อน PR`, `production readiness`, `พร้อม PR` |
| `scale-security` | `scale-security`, `scale`, `ก่อน deploy`, `scalability`, `security review` |
| `clean-code` | `clean-code`, `clean code`, `code smell`, `refactor hygiene`, `maintainability`, `โค้ดสะอาด`, `clean code review` |

**AskQuestion** (exact shape — single choice):

- **title:** `PR Review — เลือกโหมด`
- **question id:** `pr-review-mode`
- **prompt:** `จะรีวิวชุดงานนี้แบบไหน? (เลือก 1)`
- **allow_multiple:** `false`
- **options:**

| id | label |
|----|--------|
| `bugs` | ก่อน commit — Review for bugs and edge cases |
| `production` | ก่อน PR — Review for production readiness |
| `scale-security` | ก่อน deploy — Scalability, security, and performance |
| `clean-code` | โครงสร้างโค้ด — Naming, DRY, hygiene in diff (not full production pass) |

After the user selects (or types mode in chat), echo:

```text
[pr-review] mode: <bugs|production|clean-code|scale-security>
```

Then continue from Step 1.

## Quick reference

| Step | Action |
|------|--------|
| 0 | Mode select (AskQuestion) if needed |
| 1 | Confirm scope + diff range |
| 2 | Run mode checklist ([reference.md](reference.md)) |
| 3 | Verdict + table + Performance line |
| 4 | Next: fix / re-review / `@git-push` |

## Workflow

### 1 — Scope and diff

Confirm with user if unclear:

- What should this change achieve?
- Which files/commits are in scope (avoid reviewing unrelated drive-by)?

Inspect changed files in the workspace (open files around hunks). User may paste `git diff` output — use that if present.

### 2 — Checklist by mode

Run only checks marked **required** for the active mode in [reference.md](reference.md) § Modes.

**clean-code:** load § Modes matrix column + [reference.md](reference.md) § P10c — always include **P10b** (diff-only).

**Other modes:** include **P10b** when in diff scope — [reference.md](reference.md) § P10b (no full-repo purge).

Record every **blocker** and **major** in the output table. **nit** / **note** optional.

### 3 — Verdict

| Verdict | Meaning |
|---------|---------|
| **ready** | 0 blockers for this mode; user may proceed to `@git-push` (or deploy for `scale-security`) |
| **revise** | ≥1 blocker or user should fix majors before push/deploy |

**Performance line (required):** one Thai sentence — [reference.md](reference.md) § Performance line by mode.

### 4 — Handoff

| Verdict | Next |
|---------|------|
| `ready` + before push | `@git-push` — optional: user may paste this verdict; git-push does **not** re-run code review (v2) |
| `revise` | list fixes; offer to apply if user wants; then re-run `@pr-review` same mode |
| `ready` + `scale-security` before deploy | remind deploy checklist / monitoring; still no git from this skill |

## Output flow

1. **Step 0** — mode select (AskQuestion) if not in user message  
2. **Scope + diff** — confirm batch goal and file range  
3. **Checklist** — active mode only ([reference.md](reference.md) § Modes)  
4. **Verdict** — `ready` | `revise` + findings table + Performance line (TH)  
5. **Handoff** — `@git-push` (safety only) | fix + re-review | deploy note for `scale-security`

**Deliverable (required before ending turn):**

```text
[pr-review] mode: <mode> — <scope>
Diff: <description>
Verdict: ready | revise

| ID | severity | file:line | finding | suggestion |

Performance (TH): …
Summary (TH): …
Next: …
```

## When to use / NOT

**Use:** งาน implement เสร็จแล้ว ก่อน `@git-push`; ก่อนเปิด PR; ก่อน deploy prod

**NOT:** งานยังไม่เสร็จ · แค่ push → `@git-push` · หน้าตา → `@ui-builder` · บั๊กไล่ยาว → `@debug`

## Combo (optional)

User may run **multiple modes** on the same diff in one session (separate invokes):

1. `@pr-review` → `bugs` → `ready`
2. `@pr-review` → `clean-code` → `ready` (optional between bugs and production)
3. `@pr-review` → `production` → `ready`
4. then `@git-push`

Do not merge checklists without running each mode. `clean-code` does **not** replace `production`.

## Resources

| File | Use |
|------|-----|
| [reference.md](reference.md) | P1–P12 · P10b · P10c clean-code · § Rationalizations / Red flags |
| [assets/template.review-comment.md](assets/template.review-comment.md) | Paste-ready summary |

Canonical: `ai-skills/pr-review/`
