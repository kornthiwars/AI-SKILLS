# ai-rules

Rules canonical — Cursor: junction `.cursor/rules` → `ai-rules`

| Rule | Files |
|------|-------|
| Vault learning | [vault-learning.mdc](vault-learning.mdc) · [vault-learning.md](vault-learning.md) · [design](vault-learning/reference.md) |

[AGENTS.md](../AGENTS.md) · [RULE-AUTHORING.md](RULE-AUTHORING.md)

---

## Cursor setup (จาก repo root)

```powershell
cmd /c mklink /J .cursor\rules ai-rules
cmd /c mklink /J .claude\rules ai-rules
```

Setup ครบ: [scripts/README.md](../scripts/README.md) · [AGENTS.md](../AGENTS.md) § Setup

---

## โครงสร้าง

```
ai-rules/
├── vault-learning.mdc      ← Cursor (alwaysApply)
├── vault-learning.md       ← portable
├── vault-learning/reference.md
├── README.md
└── RULE-AUTHORING.md
```

แก้ที่ `ai-rules/` เท่านั้น
