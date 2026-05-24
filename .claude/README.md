# .claude (Claude Code)

Junctions to canonical folders — **แก้ที่ `ai-skills/` และ `ai-rules/` เท่านั้น**

| Path | Target | Setup (จาก repo root) |
|------|--------|------------------------|
| `skills/` | `ai-skills/` | `.\scripts\setup.ps1` (Win) · `./scripts/setup.sh` (Mac/Linux) |
| `rules/` | `ai-rules/` | (same script) |

Manual Win: `cmd /c mklink /J .claude\skills ai-skills` · `mklink /J .claude\rules ai-rules`

Entry point: [CLAUDE.md](../CLAUDE.md) imports [AGENTS.md](../AGENTS.md).

Vault learning: [ai-rules/vault-learning.md](../ai-rules/vault-learning.md) (portable) · Cursor uses [vault-learning.mdc](../ai-rules/vault-learning.mdc)

Cursor mirror: [.cursor/README.md](../.cursor/README.md)
