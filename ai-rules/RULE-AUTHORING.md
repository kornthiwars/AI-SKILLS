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

```powershell
cmd /c mklink /J .cursor\rules ai-rules
cmd /c mklink /J .claude\rules ai-rules
```

รันจาก **repo root** (เหมือน skills)

## หลัก

| หลัก | นำมาใช้ |
|------|---------|
| `.mdc` ที่ root ของ `ai-rules/` | Cursor โหลดผ่าน junction |
| แก้ `ai-rules/` เท่านั้น | อย่าแก้ใน `.cursor/rules/` โดยตรง |
