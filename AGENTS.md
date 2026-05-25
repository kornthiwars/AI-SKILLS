# AGENTS.md

Universal agent entry point for **AI-SKILLS**

Canonical: [`ai-skills/`](ai-skills/README.md) · [`ai-rules/`](ai-rules/README.md) · [`vault/`](vault/README.md)

---

## Setup (once per clone)

Pass **install root** = the folder you open in Cursor (workspace root). See [scripts/README.md](scripts/README.md).

| OS | Command |
|----|---------|
| Windows | `.\scripts\setup-windows.ps1 -InstallRoot <workspace>` |
| macOS / Linux | `./scripts/setup-macos-linux.sh <workspace>` (requires `python3`) |

**Examples**

| Cursor workspace | From inside `AI-SKILLS` clone |
|------------------|-------------------------------|
| Repo root only | `-InstallRoot .` or `.\scripts\setup-windows.ps1 -InstallRoot (Get-Location)` |
| Parent (e.g. `SK/` with clone inside) | `-InstallRoot ..` |

Creates under `<workspace>/.cursor/`:

- `skills` → `ai-skills/`
- `rules` → `ai-rules/`
- `vault` → `vault/` (junction/symlink)
- `ai-skills-vault.json` (paths for agents)

Canonical notes stay in `<AI-SKILLS>/vault/issues/` and `vault/learnings/` (same files via `.cursor/vault`).

Entry: [CLAUDE.md](CLAUDE.md) → `@AGENTS.md`

---

## Skills (`ai-skills/`)

| Skill | Use when |
|-------|----------|
| [feature-builder](ai-skills/feature-builder/SKILL.md) | Full FE+BE feature |
| [flow-builder](ai-skills/flow-builder/SKILL.md) | Pre-build flow, data lineage, mutations |
| [api-builder](ai-skills/api-builder/SKILL.md) | API, contract, migration |
| [ui-builder](ai-skills/ui-builder/SKILL.md) | UI from mockup / Figma |
| [debug](ai-skills/debug/SKILL.md) | Wrong data/logic on screen |
| [pr-review](ai-skills/pr-review/SKILL.md) | Self-review before push — modes: bugs, production, clean-code, scale-security |
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
.cursor/   skills/ rules/ vault/  → link at workspace root (after setup)
CLAUDE.md · AGENTS.md
vault/     canonical (in clone)
```

---

## Language

Agent replies: **~70% Thai / ~30% English**
