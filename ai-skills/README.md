# ai-skills

ชุด Agent Skills — Cursor `@skill-name`

**Setup:** `.cursor/skills` → `ai-skills/` (และ `.cursor/rules`, `.cursor/vault`) — [scripts/README.md](../scripts/README.md) · `-InstallRoot` = workspace ที่เปิดใน Cursor

แต่ละ skill อยู่ที่ **`<skill-name>/`**

Universal index: [AGENTS.md](../AGENTS.md)

| Skill | Version | Path |
|-------|---------|------|
| UI Builder | 1.0.2 | [ui-builder/](ui-builder/SKILL.md) |
| API Builder | 1.0.3 | [api-builder/](api-builder/SKILL.md) |
| Feature Builder | 1.1.2 | [feature-builder/](feature-builder/SKILL.md) |
| Debug | 1.0.4 | [debug/](debug/SKILL.md) |
| PR Review | 1.0.5 | [pr-review/](pr-review/SKILL.md) — incl. P10b dead/unused code |
| Git Push | 2.0.2 | [git-push/](git-push/SKILL.md) — safety + push; no code review |
| Upgrade | 1.1.2 | [upgrade/](upgrade/SKILL.md) |

คู่มือสร้าง/แก้ skill: [SKILL-AUTHORING.md](SKILL-AUTHORING.md)

---

## เลือก skill ยังไง (สรุปเร็ว)

| อยากทำอะไร | ใช้ skill |
|------------|---------|
| ฟีเจอร์ครบ FE+BE (login, checkout) | `@feature-builder` |
| สร้าง/แก้ API, contract, migration | `@api-builder` |
| UI ตรง mockup / Figma / screenshot | `@ui-builder` |
| ข้อมูลหรือ logic บนจอผิด (API ถูกแล้ว) | `@debug` |
| รีวิวงานก่อน push / PR / deploy | `@pr-review` |
| commit + push ขึ้น remote | `@git-push` |
| แก้ skill ใน repo นี้ | `@upgrade` |

**กฎสำคัญ:** หนึ่งเทิร์นต่อหนึ่ง `@skill` — งานข้าม domain ให้ส่งต่อ skill ถัดไป  
**Git:** skill อื่นห้ามรัน git → `@git-push` for push · `@pr-review` **optional** for code review (แนะนำ app repo ก่อน push ถ้าต้องการรีวิว)

---

## รายละเอียดแต่ละ skill

### `@feature-builder` — ประสานฟีเจอร์ FE+BE

**ใช้เมื่อ**
- อยากได้ฟีเจอร์ **ครบ stack** ในครั้งเดียว (login, register, checkout)
- ยังไม่แยก scope ว่า API ก่อนหรือ UI ก่อน — ต้องการ **แผน phase + handoff**

**ต้องมีก่อนเริ่ม**
- ชื่อฟีเจอร์ + user story (เช่น login ด้วย email/password)
- repo แอปจริง (ไม่ใช่แค่ maintain ai-skills repo)
- ถ้ามี UI — ต้องมี visual ref หรือยอมรับว่า phase UI **blocked**

**อย่าใช้เมื่อ**
- แค่ endpoint เดียว → `@api-builder`
- แค่ UI ตรงรูป → `@ui-builder`
- ตัวเลข/รายการแสดงผิด → `@debug`

**ลำดับลูก:** `@api-builder` (Ship) → handoff → `@ui-builder` (Gate A→B)

**วิธีรัน:** `feature-builder/assets/template.runbook.md` · **รูปแบบตอบ agent:** `template.reply.md` (ทุกเทิร์น)

---

### `@api-builder` — API, contract, persistence

**ใช้เมื่อ**
- สร้าง/แก้ **endpoint**, validation, auth, migration, webhook, GraphQL
- ต้องการ **contract ชัด** ก่อน implement (Gate Contract / Ship)

**ต้องมีก่อนเริ่ม**
- Operation ชัด (create/change/remove endpoint ไหน)
- Contract sketch (method, path, body, response)
- AuthZ (ใครเรียกได้)
- Persistence (table/entity, migration ใหม่ไหม)
- Error model (status + body)

**อย่าใช้เมื่อ**
- งาน pixel / mockup → `@ui-builder`
- API response ถูก แต่ UI แสดงผิด → `@debug`
- ฟีเจอร์ครบ FE+BE → `@feature-builder`

---

### `@ui-builder` — UI ตรง reference

**ใช้เมื่อ**
- มี **รูปอ้างอิง** — mockup, screenshot, Figma, live URL
- ต้องการ UI **ตรงดีไซน์** ที่ viewport ที่ lock ไว้

**ต้องมีก่อนเริ่ม**
- Visual reference (รูป / Figma / URL)
- Viewport — W×H เดียว **หรือ** รายการ breakpoint ทุก width พร้อม ref ต่อ width
- Build target (repo/stack ที่จะเขียน)

**อย่าใช้เมื่อ**
- ไม่มีรูป / wireframe เปล่าๆ
- รูปเดียวแล้วบอก “ทำ responsive” โดยไม่ให้ ref ต่อ width
- ตัวเลข รายการ label ผิด (layout ตรงรูปแล้ว) → `@debug`
- แก้ API / contract → `@api-builder`

---

### `@debug` — ข้อมูล / logic ผิดบนจอ

**ใช้เมื่อ**
- ยอดรวมผิด, label ผิด, list ไม่อัปเดต, map field ผิด
- **API ตอบถูกแล้ว** แต่ค่าบนจอยังผิด
- ต้องการ **วินิจฉัยก่อน** (Gate D) แล้วค่อย fix หลัง user ยืนยัน

**ต้องมีก่อนเริ่ม**
- Symptom (อาการบนจอ)
- Expected vs actual อย่างน้อย 1 คู่
- ขั้นตอน reproduce (หรือช่วยไล่ด้วยกัน)

**อย่าใช้เมื่อ**
- สี/spacing ไม่ตรงรูป → `@ui-builder`
- ออกแบบ API ใหม่ → `@api-builder`
- ฟีเจอร์ใหม่ทั้งก้อน → `@feature-builder`

---

### `@pr-review` — self-review ก่อนส่งงาน

**ใช้เมื่อ**
- **implement เสร็จแล้ว** อยากเช็คก่อน push / เปิด PR / deploy prod
- ต้องการ verdict `ready` หรือ `revise` + ตาราง findings

**ต้องมีก่อนเริ่ม**
- **Mode:** `bugs` | `production` | `scale-security` (ไม่ระบุ → เลือกจากเมนู)
- Scope สั้นๆ ว่างานชุดนี้ควรทำอะไร
- Diff scope (default: unstaged + staged)

**อย่าใช้เมื่อ**
- งานยังไม่เสร็จ
- แค่อยาก push → `@git-push` (แต่แนะนำ pr-review ก่อนใน app repo)
- งาน visual / API / debug ยังไม่จบ — กลับไป skill นั้นก่อน

**ไม่รัน git** — อ่านและรีวิวอย่างเดียว

---

### `@git-push` — commit + push ปลอดภัย

**ใช้เมื่อ**
- อยาก **push ขึ้น GitHub / remote**
- ต้องการ inspect diff + safety (secrets/staging) + ยืนยันก่อน push — **ไม่**รีวิวโค้ด (ใช้ `@pr-review` แยกถ้าต้องการ)

**ต้องมีก่อนเริ่ม**
- Workspace เป็น git repo (มี `.git`)
- Branch / remote ชัด (default: branch ปัจจุบัน + `origin`)
- User intent: push only | commit แล้ว push | สร้าง PR (ถ้าขอ `gh`)

**อย่าใช้เมื่อ**
- force push / amend commit ที่ push แล้ว (ยกเว้น user ขอชัด)
- เปลี่ยน git config

**รีวิวโค้ด (optional):** `@pr-review` → `ready` → `@git-push`  
`@git-push` v2 — safety + push เท่านั้น ไม่รัน R1–R10 ซ้ำ

---

### `@upgrade` — แก้ skill ใน repo นี้

**ใช้เมื่อ**
- skill **ล่าสมัย, ผิด, ไม่ตรง** SKILL-AUTHORING
- อยาก audit, bump version, แก้ cross-ref

**ต้องมีก่อนเริ่ม**
- อยู่ใน **ai-skills repo** (หรือ path ไป skill ที่จะแก้)
- ระบุ skill เป้าหมาย (เช่น `@upgrade ui-builder`) หรือให้ scan ทั้ง repo

**อย่าใช้เมื่อ**
- สร้าง UI/API ใน **โปรเจกต์แอป** → `@ui-builder` / `@api-builder`
- push โค้ด → `@git-push`

---

## flow ที่ใช้บ่อย

### แอปปกติ — จบงานแล้ว ship

```
implement (skill งาน) → @pr-review → ready → @git-push
```

### ฟีเจอร์ login ครบ stack

```
@feature-builder (แผน)
  → @api-builder (contract + implement + Ship)
  → @ui-builder (Gate A→B ตาม ref)
  → @pr-review → @git-push
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
| แก้ skill canonical ระหว่างทำแอป | `@upgrade` (repo นี้เท่านั้น) |
