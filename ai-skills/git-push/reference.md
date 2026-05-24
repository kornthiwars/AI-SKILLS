# reference — git-push safety

## Secret scan (block commit/push)

Block if diff adds or modifies:

| Pattern | Examples |
|---------|----------|
| Env secrets | `.env`, `.env.local`, `credentials.json` |
| Keys | `API_KEY=`, `SECRET=`, `password=`, `BEGIN PRIVATE KEY` |
| Tokens | `ghp_`, `sk-`, `xoxb-` |

If user insists on committing env **example**, only `*.example` with placeholders.

## AI-SKILLS repo — what to change / stage (scope)

Use when workspace is this monorepo (`ai-skills/`, `ai-rules/`, `vault/`). In **step 1** and **step 3**, classify paths before `git add`.

### Usually commit (tracked · shareable)

| Area | Paths | แก้ประมาณไหน |
|------|--------|----------------|
| Skills | `ai-skills/**` | SKILL.md, reference.md, assets — skill behavior only |
| Rules | `ai-rules/**` | `.mdc`, `reference.md` — agent rules |
| Vault docs | `vault/README.md`, `vault/issues/README.md`, `vault/learnings/README.md` | user-facing vault docs |
| Vault templates | `vault/templates/**` | `template.issue.md`, `template.learning.md` |
| Obsidian shared | `vault/.obsidian/graph.json`, `app.json`, `core-plugins.json`, `community-plugins.json`, `appearance.json`, `plugins/**` | graph groups, plugins shipped with vault |
| Obsidian snippets | `vault/.obsidian/snippets/*.css` | optional CSS (if any) |
| Repo root | `AGENTS.md`, `CLAUDE.md`, `README.md`, `.gitignore` | entry docs, gitignore exceptions |

### Do not stage (blocker in R3 if staged)

| Path | Why |
|------|-----|
| `.cursor/skills`, `.cursor/rules` | junction → `ai-skills` / `ai-rules` — edit canonical only |
| `.claude/skills`, `.claude/rules` | same |
| `vault/issues/20*.md`, `vault/learnings/20*.md` | personal notes — **gitignored** |
| `.env`, credentials, tokens | secrets (R1) |

### Usually skip unless user asks

| Path | Why |
|------|-----|
| `vault/.obsidian/workspace.json` | local UI layout (panes, zoom) — machine-specific |
| `vault/.obsidian/workspace-mobile.json` | same |

### Commit scope by change type

| User changed | Stage roughly |
|--------------|----------------|
| Skill / rule only | `ai-skills/...` and/or `ai-rules/...` |
| Vault policy / tags / graph | `ai-rules/vault-learning*`, `vault/README.md`, `vault/.obsidian/graph.json`, templates |
| Plugin bump | `vault/.obsidian/plugins/<id>/**` + `community-plugins.json` |
| Docs only | `**/*.md` under paths above — no junctions |

In **step 4** confirm table, add row **scope** listing staged paths (or “already committed”) so user sees what will push.

## Pre-push review (R1–R10)

Run on **staged + unstaged** diff (or range user gives). Judge what changed; open surrounding context for changed symbols.

| Verdict | Meaning |
|---------|---------|
| **pass** | 0 blockers; notes optional |
| **block** | ≥1 blocker — fix before push |

| ID | Check | Blocker if |
|----|-------|------------|
| R1 | Secrets / credentials in diff | keys, tokens, `.env` production values |
| R2 | Debug noise | `console.log`, `print(`, `debugger`, commented-out blocks left in |
| R3 | Scope creep | unrelated files, drive-by refactors, or **junction / local vault notes** staged (see § AI-SKILLS repo) |
| R4 | Correctness | obvious logic bug, wrong condition, off-by-one, null unsafe |
| R5 | Error handling | swallowed errors, empty catch, missing return on failure path |
| R6 | Tests | behavior change without test update when repo already has tests nearby |
| R7 | Types / compile | obvious type errors in typed languages from diff |
| R8 | Security | SQL string concat, `eval`, path traversal, missing auth on new route |
| R9 | Data loss | destructive migration without backup note |
| R10 | Docs drift | public API changed but README/OpenAPI not updated (note or blocker per severity) |

Severity:

- **blocker** — must fix before push
- **note** — recommend fix; push allowed if user accepts in chat

### R1 Secrets (detail)

| Find | Action |
|------|--------|
| `.env` with real values | blocker — use `.env.example` |
| Private keys | blocker |
| Hardcoded production URLs with tokens | blocker |

### R2 Debug noise (detail)

| Find | Action |
|------|--------|
| `console.log` / `print(` in production paths | note or blocker if many |
| `debugger` | blocker |
| `TODO FIXME` without ticket | note |

### R4 Correctness hints

- Changed `if` without else branch when contract requires handling
- Async without await on critical path
- Resource not closed in language that needs it

### R6 Tests

If diff touches `src/foo.ts` and `foo.test.ts` exists but unchanged → **note** or **blocker** if risky behavior change.

### R8 Security (API)

New route without auth middleware when siblings use auth → **blocker**.

### R9 Migrations

DROP column/table without migration plan in commit message → **blocker**.

### Waivers

User may accept **notes** in chat. **Blockers** need fix or explicit "waive R3" with reason logged in review table.

If diff unchanged after a completed review in the same session, step 2 may cite prior verdict and skip re-scan.

## Commit message

- 1–2 sentences, focus **why**
- Match repo style from `git log -5`

PowerShell:

```powershell
git commit -m @"
Short title line.

Why this change matters.
"@
```

## Amend rules (all required)

Amend **only** if:

1. User explicitly requested amend, **or** hook auto-modified files after successful commit
2. HEAD commit was created in **this** session by you
3. Commit **not** pushed yet (`git status` not ahead-only on remote for that commit)

If commit **failed** or hook **rejected** → fix and **new commit**, never amend.

If already pushed → never amend unless user explicitly wants force push (warn).

## Behind remote

| Situation | Action |
|-----------|--------|
| behind origin | Stop; show `git log origin/branch..HEAD` and `git log HEAD..origin/branch` |
| user wants sync | `git pull --rebase origin <branch>` then re-run pre-push review if conflict resolution touched code |
| diverged | Ask: merge vs rebase — do not guess |

## Force push

- **Refuse** `push --force` to `main`/`master` without explicit user request + warning
- Feature branch: only if user names branch and accepts data loss risk

## Non-interactive git

Never use `-i` flags (`rebase -i`, `add -i`).

## Common rationalizations (agent discipline)

| Rationalization | Reality |
|-----------------|---------|
| "/git-push = ยืนยัน push แล้ว" | Trigger เท่านั้น — ต้องยืนยัน **หลัง** ตาราง step 4 |
| "pr-review แล้ว ไม่ต้อง R1–R10" | หลัง `ready` ทำ **gap only** — ไม่ข้าม secrets/debug |
| "push ในเทิร์นเดียวกับ review" | ห้าม same-turn push |
| "แค่ note ไม่มี blocker ก็ push" | blocker = หยุด unless user waives **ในแชท** |
| "commit .env.local ชั่วคราว" | Secret scan = block |

## Red flags

- `git push` ก่อนข้อความยืนยันของ user หลังตาราง
- Review verdict `block` แต่เสนอ push ต่อ
- `--no-verify` / `--force` โดย user ไม่ขอชัด
- Duplicate full R1–R10 หลัง pr-review table ครบแล้ว
- `git config` เปลี่ยนใน workflow

## Push confirmation gate

**บังคับก่อน `git push`:** agent ต้องแสดงตาราง step 4 แล้ว **หยุด** — รอข้อความถัดไปจากผู้ใช้

| Rule | Detail |
|------|--------|
| No same-turn push | ห้ามรัน `git push` ในเทิร์นเดียวกับ inspect / review / commit / ตารางยืนยัน |
| Trigger ≠ confirm | `/git-push`, `@git-push`, "push github" = เริ่ม workflow เท่านั้น |
| Valid confirm | ข้อความชัดเจนหลังตาราง: ยืนยัน, push, ใช่, ok, confirm |
| Invalid confirm | เงียบ, คำถามอื่น, แก้โค้ดต่อ — ยังไม่ push |
| Diff changed | หลังยืนยันแต่ก่อน push มี commit/stage ใหม่ → ตาราง + ถามใหม่ |
| Cancel | ยกเลิก / cancel / ไม่ → จบ workflow |

ตัวอย่างเทิร์นแรก (จบที่ gate):

```text
[git-push] พร้อม push — ยืนยัน push ขึ้น origin/main จำนวน 1 commit ตอนนี้ไหม?
```

ตัวอย่างเทิร์นที่สอง (ผู้ใช้: "ยืนยัน") → รัน `git push` แล้ว report
