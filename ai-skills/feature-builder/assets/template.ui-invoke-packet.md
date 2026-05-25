# F4 UI packet — paste for @ui-builder (from @feature-builder)

**วิธีรัน:** ข้อความใหม่ (หลัง API Ship + fe-handoff) → วางบล็อกด้านล่าง → `@ui-builder` → รอ **Gate B Confirmed** → กลับ `@feature-builder`

```text
@ui-builder
Feature: <name> · Phase F4 (from @feature-builder)

Handoff:
[paste fe-handoff block from F3]

Scope: <S0 server rail · S1 channels · S2 chat · S3 members | or single S#>
Viewport: <W×H locked> · Ref: <path under public/refs/ or URL>

Quality bar (default tier 10):
- Gate A Approved before any UI code
- Gate B Confirmed · Score: 10/10 · 0 blockers · 0 tier-10 waivers
- ui-builder: assets/checklist.quality-tier.md + browser screenshot @ viewport side-by-side ref
- Save evidence: docs/<feature>/gate-a.md + gate-b.md (required for Feature Ship)

Layout (if multi-pane):
- Each pane: flex column, min-height: 0, scroll inside pane
- Composer/footer: flex-shrink: 0 inside main pane — no position:fixed on viewport (#25 ui-builder)

Deliverables back to feature-builder:
1. Gate A verdict + spec excerpt
2. Gate B verdict + delta 0 blockers + Score __/10
3. Full-shell screenshot @ <W×H> (tier 10 — not CSS-only)

Forbidden in this phase:
- Implementing API routes (already Ship)
- Feature Ship without Gate B paste
```
