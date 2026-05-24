# .cursor (Cursor IDE)

Junctions to canonical folders — **แก้ที่ `ai-skills/` และ `ai-rules/` เท่านั้น**

| Path | Target | Setup (จาก repo root) |
|------|--------|------------------------|
| `skills/` | `ai-skills/` | `.\scripts\setup.ps1` (Win) · `./scripts/setup.sh` (Mac/Linux) |
| `rules/` | `ai-rules/` | (same script) |

Manual Win: `cmd /c mklink /J .cursor\skills ai-skills` · `mklink /J .cursor\rules ai-rules`

Vault: [ai-rules/vault-learning.mdc](../ai-rules/vault-learning.mdc) (rules only, no hooks)
