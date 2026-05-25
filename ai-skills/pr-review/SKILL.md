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
  version: "1.1.3"
  author: kornthiwars
  license: MIT
  surfaces:
    - ide
---

# PR Review

**Self-review** finished work in the **user's app repo** before `@git-push`. One **mode** per pass. Output: `ready` or `revise` + table — **no git commands**.

Details: [reference.md](reference.md)

## Operating stance

- **Author gate** — reviewing your own batch, not a stranger's PR on GitHub
- **Mode drives depth** — one checklist ([reference.md](reference.md) § Modes); `clean-code` ≠ full `production`
- **Read-only** — no file edits unless user asks to fix in-session
- **Hand off git** — after `ready` → `@git-push`; never `git add` / `commit` / `push`
- **Token** — load reference § for **active mode only** — not full file at start

## Language

[SKILL-AUTHORING.md](../SKILL-AUTHORING.md) § Language. **Gloss:** `ready (พร้อม push)`, `revise (ต้องแก้ก่อน)`, `blocker (ต้องแก้)` · EN: mode ids, P1–P10c, severity.

## Required inputs

- [ ] **Mode** — `bugs` | `production` | `clean-code` | `scale-security`
- [ ] **Scope** — feature or 1–2 sentences what this batch should achieve
- [ ] **Diff scope** — default unstaged + staged; or `main...HEAD` if user names base

If mode missing → **Step 0** only until mode known.

## Hard rules

- **No git commands** — [SKILL-AUTHORING.md](../SKILL-AUTHORING.md) § Git operations; review workspace/diff only
- **Step 0** — mode not in message → [reference.md](reference.md) § AskQuestion (tool + table)
- **No merge / no deploy** — advisory verdict for author
- **No ui-builder Gate A/B** — layout/pixel → `@ui-builder`
- **No rubber-stamp** — `ready` needs checklist rows for active mode

## Quick reference

| Step | Load | Outcome |
|------|------|---------|
| 0 | [reference.md](reference.md) § AskQuestion | mode echoed |
| 1–4 | [reference.md](reference.md) § Workflow | scope → checklist → verdict → handoff |

## Workflow

Run Quick ref in order. Steps 1–4 detail: [reference.md](reference.md) § Workflow. **Deliverable:** [reference.md](reference.md) § Output deliverable.

## Output flow

0 → mode · 1 → scope/diff · 2 → checklist (active mode) · 3 → `ready` \| `revise` + table + Performance (TH) · 4 → `@git-push` \| fix \| deploy note

**Combo (optional):** [reference.md](reference.md) § Combo

## Use

Implement done → pick mode → review → `ready` → `@git-push`. See `description` for WHEN NOT.

## Resources

| File | Use |
|------|-----|
| [reference.md](reference.md) | § Index · Modes · P1–P12 · Workflow · AskQuestion · Combo · deliverable |
| [assets/template.review-comment.md](assets/template.review-comment.md) | Paste-ready summary |

Canonical: `ai-skills/pr-review/`
