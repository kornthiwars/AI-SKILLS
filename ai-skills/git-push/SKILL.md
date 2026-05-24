---
name: git-push
description: >-
  Safe git commit and push workflow — inspect status/diff, pre-push review
  (secrets, debug noise, scope, correctness), confirm with user, push to remote.
  Triggers on /git-push, @git-push, git push, push ขึ้น git, push github, อัปโค้ด,
  ส่งขึ้น remote, ตรวจโค้ดก่อน push. Often after @pr-review ready on same diff.
  Does not apply to force-push unless user
  explicitly requests, amending pushed commits, git config changes, or non-git VCS.
disable-model-invocation: true
metadata:
  version: "1.0.0"
  author: kornthiwars
  license: MIT
  surfaces:
    - ide
---

# Git push

**Safe push** for the current workspace repo: inspect → pre-push review → commit (if needed) → confirm → push.

Details: [reference.md](reference.md)

## Operating stance

- **Safe by default** — inspect and review before any push
- **Pre-push gate** — no push while review reports blockers unless user waives in chat
- **Push confirmation gate (ยืนยันก่อน push จริง)** — ห้ามรัน `git push` จนกว่าผู้ใช้ตอบยืนยันในแชท **หลัง** ตาราง step 4 (ดู § Confirm)
- **No destructive git** — no force-push to main, no config changes, no hook skip unless user explicitly asks
- **Token** — after `@pr-review` `ready` on same diff: step 2 runs R1–R10 **gaps only**; load [reference.md](reference.md) § Pre-push when step 2 starts

## Language

- **70% ไทย / 30% อังกฤษ** — สรุป, คำถามยืนยัน, ตาราง pre-push เป็นภาษาไทย; ใช้อังกฤษ ~30% สำหรับ git term (branch, remote, ahead, force push), blocker, R1–R10
- **Mix ธรรมชาติ** — เช่น "branch **ahead** origin 2 commits — มี **blocker** 1 จุดก่อน push"
- **Gloss ครั้งแรกต่อ reply** — `force push (บังคับ push ทับ remote)`, `ahead (นำหน้า origin)`, `blocker (ต้องแก้ก่อน push)`
- **ไม่แปล** — คำสั่ง git, path, branch name

## Required inputs

- [ ] **Workspace is a git repo** (`.git` exists)
- [ ] **Target branch** — default current branch; ask if user names another
- [ ] **Remote** — default `origin`; ask if unclear
- [ ] **User intent** — push only | commit then push | create PR after push (use `gh` only if user asks)

If nothing to push and nothing to commit, report and **stop**.

## Hard rules

- **Sole git skill in this repo** — only `@git-push` may run git CLI or `gh` for commit/push/PR sync; other skills must hand off here
- **Pre-push review before push** — run checklist R1–R10 ([reference.md](reference.md) § Pre-push review) on diff before `git push`
- **Never** `git config` changes
- **Never** `push --force` to `main`/`master` unless user **explicitly** requests — warn about overwrite
- **Never** `--no-verify` / skip hooks unless user explicitly requests
- **Never** `commit --amend` unless [reference.md](reference.md) § Amend rules all pass
- **Never** commit `.env`, credentials, `*.pem`, tokens — see [reference.md](reference.md) § Secret scan
- **Never** push if review reports **blocker** unless user waives in writing in chat
- **Never** run `git push` without **push confirmation** in the **same chat turn** after step 4 table — `/git-push`, `@git-push`, or "push" alone is **not** confirmation (see step 4)
- **Stop after step 4** when confirmation is missing — do not run step 5 in that turn
- **Do not** create commits unless user asked to commit (or changes are clearly part of "push my work")

## Quick reference

| Step | Action |
|------|--------|
| 1 | `git status` + `git diff` (+ staged) |
| 2 | Pre-push review (R1–R10) |
| 3 | Commit (if requested) — message from actual diff |
| 4 | **Confirm gate** — ตาราง + รอคำยืนยัน (ห้าม push ในเทิร์นเดียวกัน) |
| 5 | `git push` — **เฉพาะหลัง** ผู้ใช้ยืนยัน |
| 6 | Report URL / `git status -sb` |

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

### 2 — Pre-push review

On **staged + unstaged** diff (or full PR range if user says). Load [reference.md](reference.md) § Pre-push review **now** (not at step 1).

**If user already ran `@pr-review` → `ready` on this diff:** paste or cite the pr-review table; run R1–R10 only for axes **not** covered or findings still open — **do not** duplicate the full review.

**Otherwise:** full R1–R10 on the diff.

- **Blockers** → fix or stop; do not push
- **Notes** → list in push summary

Output header:

```text
[git-push] Review — <branch or scope>
Files: N changed
Verdict: pass | block

| ID | severity | file:line | finding | suggestion |
```

### 3 — Commit (optional)

Only if user asked to commit or said "push my changes" with uncommitted work:

1. Stage only relevant paths (not secrets).
2. Message: 1–2 sentences, **why** not just what ([reference.md](reference.md) § Commit message).
3. PowerShell: use here-string for message (see reference).
4. If hook fails → **new commit**, do not amend unless amend rules pass.

### 4 — Confirm (push gate — บังคับ)

**ห้าม** รัน `git push` ในเทิร์นเดียวกับ step 1–3 จนกว่าผู้ใช้ตอบยืนยันในแชท **หลัง** ตารางนี้

แสดงตาราง (ครบทุกแถวที่มีข้อมูล):

| Field | Value |
|-------|-------|
| repo | path หรือชื่อโฟลเดอร์ |
| branch | … |
| remote | … |
| commits to push | N (พร้อม `git log origin/<branch>..HEAD --oneline` ถ้า N > 0) |
| review | pass / block / notes |
| force? | no (unless explicit) |

ถ้า N = 0 และไม่มีงาน commit ที่ผู้ใช้ขอ → รายงานแล้ว **หยุด** (ไม่ถามยืนยัน push)

ถ้ามี commit จะ push → ถาม **หนึ่งครั้ง** เป็นภาษาไทย:

```text
ยืนยัน push ขึ้น <remote>/<branch> จำนวน <N> commit ตอนนี้ไหม?
(ตอบ: ยืนยัน / push / ใช่ — หรือ ยกเลิก)
```

**ไม่นับเป็นยืนยัน push:** `/git-push`, `@git-push`, "push ให้หน่อย", "ส่งขึ้น git" ในข้อความแรก — นี่คือแค่เริ่ม workflow

**นับเป็นยืนยัน push (ข้อความถัดไปของผู้ใช้):** `ยืนยัน`, `push`, `ใช่`, `ok`, `confirm`, `go ahead` (หรือชัดเจนเทียบเท่า)

**ยกเลิก:** `ยกเลิก`, `cancel`, `ไม่`, `stop` → หยุด ไม่ push

ถ้าผู้ใช้ยืนยันแล้วแต่ diff/commit เปลี่ยนก่อน push → กลับ step 1–2 แล้วถามยืนยันใหม่

รายละเอียด: [reference.md](reference.md) § Push confirmation gate

### 5 — Push (หลังยืนยันเท่านั้น)

รัน **เฉพาะ** เมื่อได้ push confirmation ในเทิร์นถัดไป (หรือข้อความเดียวกันที่ตอบยืนยันชัดเจน **หลัง** ตาราง step 4)

```powershell
git push -u origin HEAD
```

Use `-u` when upstream not set. If behind remote → `git pull --rebase` only if user agrees ([reference.md](reference.md) § Behind remote).

### 6 — Report

- `git status -sb` after push
- If `gh` available and user wanted PR → remind `gh pr create` or run if they asked

## When to use / NOT

**Use:** push ขึ้น GitHub, sync remote, ส่ง commit, `@git-push`, ตรวจ diff ก่อน push

**After `@pr-review`:** if same diff and verdict `ready`, step 2 may cite pr-review table and run R1–R10 only for gaps.

**NOT:** force push without explicit ask · rebase -i · change git config · monorepo deploy · @upgrade (skills repo)

## Output flow

1. Inspect → 2. Pre-push review → 3. Commit? → 4. Confirm gate (รอผู้ใช้) → 5. Push → 6. Report  

**สองเทิร์นเป็นปกติ:** เทิร์นแรกจบที่ step 4 · เทิร์นที่สอง (หลังผู้ใช้ยืนยัน) = step 5–6
7. **Vault:** search `vault/learnings/` before git friction; learning if ≥3 prompt rounds on same problem; issues auto on Q&A.

## Project learnings

Git friction (rebase, hook fail, auth) → search `vault/learnings/` first; write learning if ≥3 prompt rounds — not in `skills/git-push/` canonical.

## Resources

| File | Use |
|------|-----|
| [reference.md](reference.md) | R1–R10, amend, secrets · § Rationalizations / Red flags |

Canonical: `skills/git-push/`
