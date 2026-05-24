# scripts

Links under `.cursor/` (Windows: NTFS junction · macOS/Linux: symlink):

| Link | Target |
|------|--------|
| `.cursor/skills` | `ai-skills/` |
| `.cursor/rules` | `ai-rules/` |
| `.cursor/vault` | `vault/` |

Also writes `.cursor/ai-skills-vault.json` (`issuesRelative`: `.cursor/vault/issues`).

Pass **install root** = the folder you open in Cursor (workspace root).

## Windows

**Cursor opens `AI-SKILLS/`** — double-click [setup-windows.bat](setup-windows.bat)

```powershell
.\scripts\setup-windows.ps1 -InstallRoot C:\path\to\workspace
```

**Cursor opens parent `SK/`** (clone inside):

```powershell
cd AI-SKILLS
.\scripts\setup-windows.ps1 -InstallRoot ..
```

## macOS / Linux

```bash
chmod +x scripts/setup-macos-linux.sh
./scripts/setup-macos-linux.sh .          # workspace = AI-SKILLS
./scripts/setup-macos-linux.sh ..         # workspace = parent (e.g. SK)
```

Requires `python3` (for `ai-skills-vault.json`).

Edit canonical folders in the repo only — not inside `.cursor/`.
