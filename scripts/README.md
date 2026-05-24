# scripts

Post-clone setup for **AI-SKILLS**.

## What it does

1. Links `.cursor/skills` + `.cursor/rules` → `ai-skills` / `ai-rules`
2. Links `.claude/skills` + `.claude/rules` → same canonical folders
3. Creates `vault/issues/` and `vault/learnings/` if missing

| OS | Command (from repo root) |
|----|---------------------------|
| **Windows** | `.\scripts\setup.ps1` or double-click `scripts\setup.bat` |
| **macOS / Linux** | `chmod +x scripts/setup.sh && ./scripts/setup.sh` |

## Requirements

- **Windows:** NTFS; junctions usually work without Admin on a local drive. If `mklink` fails, run PowerShell as Administrator once.
- **macOS / Linux:** `bash`, `ln`. No extra packages.

## Re-run

Safe to run again — skips links that already point to the right target.

## Do not commit

Junctions/symlinks under `.cursor/` and `.claude/` stay local (gitignored or untracked). Edit **only** `ai-skills/` and `ai-rules/`.
