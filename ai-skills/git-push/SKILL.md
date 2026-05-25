---
name: git-push
description: >-
  Git commit and push — inspect diff, safety checks (secrets, staging scope),
  user confirmation, push. No code review (use @pr-review separately if needed).
  Triggers on /git-push, @git-push, git push, push ขึ้น git, push github, อัปโค้ด,
  ส่งขึ้น remote. Does not apply to force-push unless user explicitly requests,
  amending pushed commits, git config changes, non-git VCS, or code-quality review
  (pr-review).
compatibility: Cursor and Claude Code; git CLI; gh for PR only when user asks
disable-model-invocation: true
metadata:
  version: "2.0.5"
  author: kornthiwars
  license: MIT
  surfaces:
    - ide
---

# Git push

**Commit and push:** inspect → **safety** (not code review) → commit? → **confirm** → push.

**Code review** → [`@pr-review`](../pr-review/SKILL.md) — optional. **Do not** R1–R10 or duplicate pr-review here.

Details: [reference.md](reference.md)

## Operating stance

- **Git only** — status, diff, commit, push
- **Safety, not review** — secrets + staging scope only
- **Push confirmation gate** — no `git push` until user confirms **after** step 4 table below
- **No destructive git** — no force main, no config change, no hook skip unless user asks
- **Optional pr-review** — paste verdict only; do not re-scan diff

## Language

[SKILL-AUTHORING.md](../SKILL-AUTHORING.md) § Language. **Gloss:** `blocker (ต้องแก้ก่อน push)`, `ahead (นำหน้า origin)` · EN: git terms, safety check.

## Required inputs

- [ ] **Workspace is a git repo** (`.git` exists)
- [ ] **Target branch** — default current; ask if named
- [ ] **Remote** — default `origin`
- [ ] **User intent** — push only | commit then push | PR after push (`gh` if asked)

If nothing to push and nothing to commit → report and **stop**.

## Hard rules

- **Sole git skill** — only `@git-push` runs git CLI / `gh` for commit/push/PR
- **No code review** — suggest `@pr-review` for correctness/tests/style
- **Safety before push** — [reference.md](reference.md) § Secret scan · § AI-SKILLS repo · § Search learnings (friction only)
- **Never** `git config` · **never** `push --force` main/master without explicit ask + warn
- **Never** `--no-verify` / skip hooks unless user asks
- **Never** `commit --amend` unless [reference.md](reference.md) § Amend rules all pass
- **Never** commit secrets (`.env`, credentials, tokens)
- **Never** push on safety **blocker** unless user waives in writing
- **Never** `git push` without confirm after step 4 table
- **Stop after step 3** if no confirm — step 5 only after user confirms
- **Do not** commit unless user asked (or "push my work" with local changes)
- **AI-SKILLS staging** — [reference.md](reference.md) § AI-SKILLS repo only; **never** `.cursor/*` junctions or `vault/issues|learnings/*.md` notes

## Quick reference

| Step | Load | Action |
|------|------|--------|
| 1 | [reference.md](reference.md) § Workflow §1 | inspect |
| 2 | § Secret scan · § AI-SKILLS repo | safety |
| 3 | § Workflow §3 · § Commit message | commit? |
| 4 | **table below** · § Push confirmation gate | wait for user |
| 5 | § Workflow §5 · § Behind remote | push after confirm |
| 6 | § Workflow §6 | report `git status -sb` |

## Workflow

Run Quick ref. Steps 1–3, 5–6 detail: [reference.md](reference.md) § Workflow.

### 4 — Confirm (push gate) — in SKILL (required)

**Do not** run `git push` in the same turn as steps 1–3 until user confirms **after** this table.

| Field | Value |
|-------|-------|
| repo | path |
| branch | … |
| remote | … |
| commits to push | N (+ `git log origin/<branch>..HEAD --oneline` if N > 0) |
| scope | paths in commit/push |
| safety | pass / block |
| pr-review | optional note if user ran it |
| force? | no |

Ask once in Thai: ยืนยัน push ขึ้น `<remote>/<branch>` จำนวน N commit ตอนนี้ไหม?

`/git-push` alone is **not** confirmation — see [reference.md](reference.md) § Push confirmation gate.

## Output flow

1 → inspect · 2 → safety · 3 → commit? · **4 → confirm (this table)** · 5 → push · 6 → report

**Two turns normal:** turn 1 ends at step 4 · turn 2 after confirm = 5–6

## Resources

| File | Use |
|------|-----|
| [reference.md](reference.md) | § Workflow · secrets · staging · amend · behind remote |
| [pr-review/SKILL.md](../pr-review/SKILL.md) | Optional review before push |

Canonical: `ai-skills/git-push/`
