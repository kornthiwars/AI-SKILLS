# AGENTS.md

Universal agent entry point for **AI-SKILLS**

Canonical: [`ai-skills/`](ai-skills/README.md) · [`ai-rules/`](ai-rules/README.md) · [`vault/`](vault/README.md)

---

## Cursor setup (once per clone)

```powershell
cmd /c mklink /J .cursor\skills ai-skills
cmd /c mklink /J .cursor\rules ai-rules
```

Details: [.cursor/README.md](.cursor/README.md) · [.claude/README.md](.claude/README.md)

## Claude Code setup (once per clone)

```powershell
cmd /c mklink /J .claude\skills ai-skills
cmd /c mklink /J .claude\rules ai-rules
```

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

**Git rule:** `@pr-review` then `@git-push` — [ai-skills/README.md](ai-skills/README.md)

---

## Rules (`ai-rules/`)

| Rule | Purpose |
|------|---------|
| [vault-learning](ai-rules/vault-learning.md) | daily `issues/` + `learnings/` (EN files); chat ~70% TH |

Design: [ai-rules/vault-learning/reference.md](ai-rules/vault-learning/reference.md) — **no** `.cursor/learnings.md`

---

## Vault + Obsidian

- Open **repo root** as Obsidian vault
- `vault/learnings/` · `vault/issues/YYYY-MM-DD.md` (gitignored) · templates in git

---

## Repo layout

```
ai-skills/
ai-rules/
.cursor/   skills/ rules/  → junction
.claude/   skills/ rules/  → junction
CLAUDE.md · AGENTS.md
vault/
```

---

## Language

Agent replies: **~70% Thai / ~30% English**
