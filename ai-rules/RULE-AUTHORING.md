# Rule authoring

> อ่านก่อนสร้างหรือแก้ rule ใน `ai-rules/`

## โครงสร้าง

```
ai-rules/
├── <rule-name>.mdc         ← Cursor (flat ที่ root)
├── <rule-name>.md          ← portable
└── <rule-name>/
    └── reference.md        ← design (optional)
```

## Cursor mirror

ใช้ [scripts/README.md](../scripts/README.md) — `-InstallRoot` ชี้ workspace ที่เปิดใน Cursor:

```powershell
.\scripts\setup-windows.ps1 -InstallRoot <workspace>
```

สร้าง `.cursor/rules` → `ai-rules/` (พร้อม `skills`, `vault`)

## หลัก

| หลัก | นำมาใช้ |
|------|---------|
| `.mdc` ที่ root ของ `ai-rules/` | Cursor โหลดผ่าน junction |
| แก้ `ai-rules/` เท่านั้น | อย่าแก้ใน `.cursor/rules/` โดยตรง |
