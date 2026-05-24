# scripts

Junction `.cursor/skills` and `.cursor/rules` only.

**Cursor opens `AI-SKILLS/`** — double-click [setup-windows.bat](setup-windows.bat)

**Cursor opens parent `SK/`** (has `AI-SKILLS` inside):

```powershell
cd AI-SKILLS
.\scripts\setup-windows.ps1 -InstallRoot ..
```

Or one line from `SK/`:

```powershell
.\AI-SKILLS\scripts\setup-windows.ps1 -InstallRoot .
```

No batch file at the parent folder — keeps everything inside this repo.
