# AGENTS.md

Universal agent entry point for **AI-SKILLS**

Canonical: [`ai-skills/`](ai-skills/README.md) · [`ai-rules/`](ai-rules/README.md) · [`vault/`](vault/README.md)

---

## Setup (once per clone)

| OS | Command |
|----|---------|
| Windows | `.\scripts\setup.ps1` |
| macOS / Linux | `./scripts/setup.sh` |

Creates `.cursor/` + `.claude/` links to `ai-skills/` and `ai-rules/`, plus `vault/issues/` + `vault/learnings/`. See [scripts/README.md](scripts/README.md).

Manual: [.cursor/README.md](.cursor/README.md) · [.claude/README.md](.claude/README.md)

Entry: [CLAUDE.md](CLAUDE.md) → `@AGENTS.md`

---

## Skills (`ai-skills/`)

| Skill | Use when |
|-------|----------|
| [feature-builder](ai-skills/feature-builder/SKILL.md) | Full FE+BE feature |
| [api-builder](ai-skills/api-builder/SKILL.md) | API, contract, migration |
| [ui-builder](ai-skills/ui-builder/SKILL.md) | UI from mockup / Figma |
| [debug](ai-skills/debug/SKILL.md) | Wrong data/logic on screen |
| [pr-review](ai-skills/pr-review/SKILL.md) | Self-review before push |
| [git-push](ai-skills/git-push/SKILL.md) | Commit + push (sole git skill) |
| [upgrade](ai-skills/upgrade/SKILL.md) | Maintain skills in this repo |

**Git rule:** `@git-push` for commit/push (safety only) · `@pr-review` optional for code review — [ai-skills/README.md](ai-skills/README.md)

---

## Rules (`ai-rules/`)

| Rule | Purpose |
|------|---------|
| [vault-learning](ai-rules/vault-learning.md) | daily `issues/` + `learnings/` (EN files); chat ~70% TH |

Design: [ai-rules/vault-learning/reference.md](ai-rules/vault-learning/reference.md) — **no** `.cursor/learnings.md`

---

## Vault + Obsidian

- Open **repo root** as Obsidian vault
- `vault/learnings/` · `vault/issues/YYYY-MM-DD.md` (gitignored) · `templates/` at repo root (git)

---

## Repo layout

```
ai-skills/
ai-rules/
templates/
.cursor/   skills/ rules/  → junction
.claude/   skills/ rules/  → junction
CLAUDE.md · AGENTS.md
vault/
```

---

## Language

Agent replies: **~70% Thai / ~30% English**
