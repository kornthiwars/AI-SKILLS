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
  version: "2.0.2"
  author: kornthiwars
  license: MIT
  surfaces:
    - ide
---

# Git push

**Commit and push** for the current workspace repo: inspect → **safety checks** (not code review) → commit (if needed) → confirm → push.

**Code review** → [`@pr-review`](../pr-review/SKILL.md) — optional, separate skill. **Do not** run R1–R10 or duplicate pr-review in this skill.

Details: [reference.md](reference.md)

## Operating stance

- **Git only** — status, diff, commit, push; no reviewing logic/tests/style here
- **Safety, not review** — block secrets and wrong staging paths; do not judge correctness (R4–R10)
- **Push confirmation gate** — no `git push` until user confirms **after** step 3 table
- **No destructive git** — no force-push to main, no config changes, no hook skip unless user explicitly asks
- **Optional pr-review** — if user already ran `@pr-review`, paste verdict in summary only; **do not** re-scan the diff for code quality

## Language

- **70% ไทย / 30% อังกฤษ** — สรุป, คำถามยืนยัน, ตารางเป็นภาษาไทย; git terms, blocker, safety check
- **Gloss ครั้งแรกต่อ reply** — `blocker (ต้องแก้ก่อน push)`, `ahead (นำหน้า origin)`
- **ไม่แปล** — คำสั่ง git, path, branch name

## Required inputs

- [ ] **Workspace is a git repo** (`.git` exists)
- [ ] **Target branch** — default current branch; ask if user names another
- [ ] **Remote** — default `origin`; ask if unclear
- [ ] **User intent** — push only | commit then push | create PR after push (use `gh` only if user asks)

If nothing to push and nothing to commit, report and **stop**.

## Hard rules

- **Sole git skill in this repo** — only `@git-push` may run git CLI or `gh` for commit/push/PR sync
- **No code review** — do not run R1–R10, correctness, tests, or "production readiness" checks; suggest `@pr-review` if user wants that
- **Safety checks before push** — [reference.md](reference.md) § Secret scan + § AI-SKILLS staging (and § Search learnings on git friction only)
- **Never** `git config` changes
- **Never** `push --force` to `main`/`master` unless user **explicitly** requests — warn about overwrite
- **Never** `--no-verify` / skip hooks unless user explicitly requests
- **Never** `commit --amend` unless [reference.md](reference.md) § Amend rules all pass
- **Never** commit `.env`, credentials, `*.pem`, tokens
- **Never** push if **safety** reports **blocker** unless user waives in writing in chat
- **Never** run `git push` without push confirmation after step 3 table
- **Stop after step 3** when confirmation is missing — step 4 only after user confirms
- **Do not** create commits unless user asked to commit (or "push my work" with uncommitted changes)
- **AI-SKILLS staging** — stage only paths in [reference.md](reference.md) § AI-SKILLS repo; **never** `.cursor/*` junctions (skills, rules, vault, `ai-skills-vault.json`) or `vault/issues|learnings/*.md` notes

## Quick reference

| Step | Action |
|------|--------|
| 1 | `git status` + `git diff` (+ staged) |
| 2 | Safety checks (secrets + staging scope) — **not** code review |
| 3 | Commit (if requested) |
| 4 | **Confirm gate** — table + wait for user |
| 5 | `git push` — after user confirms |
| 6 | Report `git status -sb` |

## Workflow

Run in order. Details: [reference.md](reference.md).

### 1 — Inspect

```powershell
git status -sb
git diff
git diff --cached
git log -3 --oneline
git rev-parse --abbrev-ref HEAD
```

Note: ahead/behind origin, untracked files, staged vs unstaged.

Classify paths with [reference.md](reference.md) § **AI-SKILLS repo**. Short summary of what will be committed/pushed — **no** review table for code quality.

### 2 — Safety checks (not code review)

Load [reference.md](reference.md) § Secret scan + § AI-SKILLS repo now.

| Check | Blocker? |
|-------|----------|
| Secrets in diff (`.env`, tokens, keys) | yes |
| Junctions / local vault notes staged | yes |
| Wrong paths for this repo layout | yes |
| Logic bugs, missing tests, style | **out of scope** — suggest `@pr-review` |

**Git friction** (rebase, hooks, auth): [reference.md](reference.md) § Search vault learnings — Grep → ≤3 reads.

If user pasted `@pr-review` `ready` — note in summary only; **do not** re-audit code.

Output (short):

```text
[git-push] Safety — <branch>
Files: N changed | commits to push: N
Verdict: pass | block
Blockers: … (secrets/staging only)
```

### 3 — Commit (optional)

Only if user asked to commit or said "push my changes" with uncommitted work:

1. Stage only allowed paths ([reference.md](reference.md) § AI-SKILLS repo).
2. Message: 1–2 sentences, **why** ([reference.md](reference.md) § Commit message).
3. If hook fails → **new commit**, do not amend unless amend rules pass.

### 4 — Confirm (push gate)

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

Trigger alone (`/git-push`, "push เลย") is **not** confirmation. See [reference.md](reference.md) § Push confirmation gate.

### 5 — Push (after confirm)

```powershell
git push -u origin HEAD
```

If behind remote → [reference.md](reference.md) § Behind remote.

### 6 — Report

- `git status -sb` after push
- `gh pr create` only if user asked

## When to use / NOT

**Use:** push to remote, commit + push, sync GitHub, `@git-push`

**NOT:** code review → `@pr-review` · force push without ask · `@upgrade` (ai-skills repo) · rebase -i

## Output flow

1. Inspect → 2. Safety (secrets/staging) → 3. Commit? → 4. Confirm gate → 5. Push → 6. Report

**Two turns normal:** turn 1 ends at step 4 · turn 2 after user confirms = steps 5–6

## Project learnings

Git friction → [ai-rules/vault-learning.mdc](../../ai-rules/vault-learning.mdc) § Search learnings before guessing.

## Resources

| File | Use |
|------|-----|
| [reference.md](reference.md) | Secrets, staging, amend, confirm gate |
| [pr-review/SKILL.md](../pr-review/SKILL.md) | Optional code review before push |

Canonical: `ai-skills/git-push/`
