# F2 API packet — paste for @api-builder (from @feature-builder)

**วิธีรัน:** ข้อความใหม่ในแชท (แนะนำ) → วางบล็อกด้านล่างทั้งก้อน → ส่ง → รอจน **Gate Ship = Confirmed** → กลับ `@feature-builder` รายงานผล

```text
@api-builder
Feature: <name> · Phase F2 (from @feature-builder)

Scope:
Mode: narrow-delta | crud-pack | single
Endpoints: <E1 POST /api/... · or list from Gate F>

Stack: <จาก repo — e.g. Next.js API routes + Prisma>
AuthZ: <public | user JWT | role>

Gate:
- Complete Gate Contract = Approved before code
- Complete Gate Ship = Confirmed before returning to feature-builder
- Fill fe-handoff template when Ship Confirmed (api-builder/assets/template.handoff-to-ui.md)

Deliverables back to feature-builder:
1. Gate Contract verdict (Approved)
2. Gate Ship verdict (Confirmed) + test/evidence summary
3. fe-handoff block ready for F3 (หรือ paste ในเทรด feature-builder)

Forbidden in this phase:
- UI / components / CSS (@ui-builder ทำหลัง Ship)
- Feature Ship without Ship Confirmed
```
