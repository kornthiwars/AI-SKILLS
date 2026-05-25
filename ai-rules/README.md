# ai-rules

Rules canonical — Cursor: junction `.cursor/rules` → `ai-rules`

| Rule | Files |
|------|-------|
| Vault learning | [vault-learning.mdc](vault-learning.mdc) · [vault-learning.md](vault-learning.md) · [design](vault-learning/reference.md) |

[AGENTS.md](../AGENTS.md) · [RULE-AUTHORING.md](RULE-AUTHORING.md)

---

## Cursor setup

รัน [scripts/README.md](../scripts/README.md) — สร้าง `.cursor/rules` (และ `skills`, `vault`) ที่ **install root**:

```powershell
cd AI-SKILLS
.\scripts\setup-windows.ps1 -InstallRoot ..   # Cursor opens parent SK/
# or -InstallRoot . when workspace is AI-SKILLS
```

แก้ rule ที่ `ai-rules/` เท่านั้น — ไม่แก้ใน `.cursor/rules/` โดยตรง

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
