# scripts

Post-clone setup for **AI-SKILLS** — **Windows** and **macOS/Linux** use the same behavior.

| OS | Script | Links |
|----|--------|--------|
| **Windows** | [setup-windows.ps1](setup-windows.ps1) · [setup-windows.bat](setup-windows.bat) | NTFS junction (`mklink /J`) |
| **macOS / Linux** | [setup-macos-linux.sh](setup-macos-linux.sh) | symlink (`ln -sfn`) |

## What setup creates (both platforms)

1. `.cursor/skills`, `.cursor/rules`, `.claude/skills`, `.claude/rules` → `ai-skills` / `ai-rules`
2. `vault/issues/YYYY-MM-DD.md` bootstrap (in the clone)
3. `.cursor/ai-skills-vault.json` — tells agents where `vault/` lives
4. **Workspace mode:** `vault/` symlink/junction at the folder you open in Cursor

## Layout: AI-SKILLS + web + api (multi-project)

```
your-workspace/          ← open this in Cursor (any folder name)
├── AI-SKILLS/           ← clone
├── web/
└── api/
```

**One command** (from inside the clone):

```bash
# macOS / Linux
chmod +x scripts/setup-macos-linux.sh
./scripts/setup-macos-linux.sh
```

```powershell
# Windows
.\scripts\setup-windows.ps1
```

If **any project folder** sits next to the clone (`web/`, `api/`, or e.g. `twitch-drops/`), setup **auto-installs on the parent** — junctions/symlinks + `vault/` + `ai-skills-vault.json`. No fixed workspace name required.

**macOS/Linux from parent** (like `setup-windows.bat` on Windows):

```bash
chmod +x AI-SKILLS/scripts/setup-macos-linux-parent.sh
./AI-SKILLS/scripts/setup-macos-linux-parent.sh
```

## Modes

| Mode | When | Command |
|------|------|---------|
| **Auto parent** | Siblings `web/`, `api/`, … detected | `./scripts/setup-macos-linux.sh` (default) |
| **Explicit parent** | Any layout | `WORKSPACE_ROOT=/path ./scripts/setup-macos-linux.sh` or `-WorkspaceRoot` (Windows) |
| **Repo only** | Cursor opens only `AI-SKILLS/` | `REPO_ONLY=1` / `-RepoOnly` |

## Verify (both)

- `.cursor/skills/upgrade/SKILL.md` resolves
- `vault/issues/<today>.md` exists in clone
- Workspace mode: `../vault/issues/<today>.md` and `.cursor/ai-skills-vault.json` at parent

## Requirements

- **Windows:** NTFS; Admin only if `mklink /J` fails
- **macOS / Linux:** `bash`, `ln`
