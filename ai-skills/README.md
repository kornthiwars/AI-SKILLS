# ai-skills

ชุด Agent Skills — Cursor `@skill-name`

**Setup:** `.cursor/skills` → `ai-skills/` (และ `.cursor/rules`, `.cursor/vault`) — [scripts/README.md](../scripts/README.md) · `-InstallRoot` = workspace ที่เปิดใน Cursor

แต่ละ skill อยู่ที่ **`<skill-name>/`**

Universal index: [AGENTS.md](../AGENTS.md)

| Skill | Version | Path |
|-------|---------|------|
| UI Builder | 1.0.3 | [ui-builder/](ui-builder/SKILL.md) |
| API Builder | 1.0.4 | [api-builder/](api-builder/SKILL.md) |
| Feature Builder | 1.1.4 | [feature-builder/](feature-builder/SKILL.md) |
| Flow Builder | 1.0.3 | [flow-builder/](flow-builder/SKILL.md) |
| Debug | 1.2.0 | [debug/](debug/SKILL.md) — repro matrix, evidence priority, root-cause ledger |
| PR Review | 1.1.3 | [pr-review/](pr-review/SKILL.md) — modes: bugs, production, clean-code, scale-security |
| Git Push | 2.0.5 | [git-push/](git-push/SKILL.md) — safety + push; no code review |
| Upgrade | 1.1.5 | [upgrade/](upgrade/SKILL.md) |

คู่มือสร้าง/แก้ skill: [SKILL-AUTHORING.md](SKILL-AUTHORING.md)

---

## เลือก skill ยังไง (สรุปเร็ว)

| อยากทำอะไร | ใช้ skill |
|------------|---------|
| ฟีเจอร์ครบ FE+BE (login, checkout) | `@feature-builder` |
| ไล่ flow ปุ่ม/ข้อมูล/สร้าง-อัปเดต ก่อนลงมือ | `@flow-builder` |
| สร้าง/แก้ API, contract, migration | `@api-builder` |
| UI ตรง mockup / Figma / screenshot | `@ui-builder` |
| ข้อมูลหรือ logic บนจอผิด (API ถูกแล้ว) | `@debug` |
| รีวิวงานก่อน push / PR / deploy | `@pr-review` (เลือกโหมด) |
| โครงสร้างโค้ด / naming / dead code ใน diff | `@pr-review` → `clean-code` |
| commit + push ขึ้น remote | `@git-push` |
| แก้ skill ใน repo นี้ | `@upgrade` |

**กฎสำคัญ:** หนึ่งเทิร์นต่อหนึ่ง `@skill` — งานข้าม domain ให้ส่งต่อ skill ถัดไป  
**Git:** skill อื่นห้ามรัน git → `@git-push` for push · `@pr-review` **optional** for code review (แนะนำ app repo ก่อน push ถ้าต้องการรีวิว)

---

## รายละเอียดแต่ละ skill

Agent: invoke `@skill-name` — rules อยู่ใน **SKILL.md** (และ `reference.md` / `assets/` ตาม Quick ref).  
ไม่ duplicate เนื้อหาใน README นี้ (ประหยัด token ตอนอ่าน index)

| Skill | SKILL.md | เอกสารเพิ่ม |
|-------|----------|-------------|
| feature-builder | [SKILL.md](feature-builder/SKILL.md) | [reference.md](feature-builder/reference.md) · [runbook](feature-builder/assets/template.runbook.md) |
| flow-builder | [SKILL.md](flow-builder/SKILL.md) | [reference.md](flow-builder/reference.md) · [flow-spec](flow-builder/assets/template.flow-spec.md) |
| api-builder | [SKILL.md](api-builder/SKILL.md) | [reference.md](api-builder/reference.md) · [contract](api-builder/assets/template.contract-spec.md) |
| ui-builder | [SKILL.md](ui-builder/SKILL.md) | [reference.md](ui-builder/reference.md) · [quality-tier](ui-builder/assets/checklist.quality-tier.md) |
| debug | [SKILL.md](debug/SKILL.md) | [reference.md](debug/reference.md) |
| pr-review | [SKILL.md](pr-review/SKILL.md) | [reference.md](pr-review/reference.md) — modes: bugs, production, clean-code, scale-security |
| git-push | [SKILL.md](git-push/SKILL.md) | [reference.md](git-push/reference.md) |
| upgrade | [SKILL.md](upgrade/SKILL.md) | [reference.md](upgrade/reference.md) |

---

## flow ที่ใช้บ่อย

### แอปปกติ — จบงานแล้ว ship

```
implement (skill งาน) → @pr-review → ready → @git-push
```

### ไม่ชัด flow ปุ่ม / ข้อมูล / สร้าง-อัปเดต

```
@flow-builder (Gate Flow Approved + flow-spec)
  → @api-builder และ/หรือ @ui-builder ตามต้องการ
  → หรือ @feature-builder (แนบ flow-spec ใน F0)
```

### ฟีเจอร์ login ครบ stack

```
@feature-builder (แผน)
  → @api-builder (contract + implement + Ship)
  → @ui-builder (Gate A→B ตาม ref)
  → @pr-review bugs → @pr-review clean-code (optional) → @pr-review production → @git-push
```

### UI ตรงรูป แต่ตัวเลขผิด

```
@ui-builder ไม่ใช่ตัวนี้ → @debug (API ถูกแล้ว แต่ map/state/render ผิด)
```

### แก้ skill ใน repo นี้

```
@upgrade (audit + แก้ canonical) → @git-push (เมื่อ user ขอ commit)
```

---

## สิ่งที่ skill ไม่ทำ

| ห้าม | ใครทำแทน |
|------|----------|
| git status / commit / push (skill งาน) | `@git-push` |
| รีวิวโค้ดก่อน push (skill งาน) | `@pr-review` |
| รวม UI + API ใน skill เดียว | `@feature-builder` แล้วส่งต่อ |
| ไล่ flow ก่อน implement | `@flow-builder` |
| แก้ skill canonical ระหว่างทำแอป | `@upgrade` (repo นี้เท่านั้น) |
