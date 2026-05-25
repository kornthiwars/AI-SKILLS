# Feature Builder — reference (v1.1.1)

Orchestration detail, run playbook, pitfalls, troubleshooting.

## Run playbook (agent)

When user asks how to proceed or after Gate F Approved:

1. Paste [assets/template.runbook.md](assets/template.runbook.md) (short TH intro OK).
2. Post the **next** packet only (F2 or F4) — not both unless F2 already Confirmed.
3. End turn with explicit **stop line**: what user must run and exact resume phrase.

| Phase | User runs | Agent stops until |
|-------|-----------|-------------------|
| F2 | New msg + `@api-builder` + F2 packet | `Gate Ship = Confirmed` |
| F3 | `@feature-builder` + fe-handoff | handoff complete |
| F4 | New msg + `@ui-builder` + F4 packet | `Gate B Confirmed` + Score |
| F5 | `@feature-builder` | Feature Ship table |

Do not say "ทำต่อได้เลย" without naming **which @skill** and **new message vs same thread**.

## Reply discipline

Every orchestrator turn uses [assets/template.reply.md](assets/template.reply.md).

| Rule | Detail |
|------|--------|
| Order | สถานะ → สรุป → **คุณทำต่อ** (1 step) → หยุดจนกว่า → อย่าทำ |
| คุณทำต่อ | One numbered line; must include `@skill` when delegating |
| หยุดจนกว่า | Backticks with exact user phrase (`Gate Ship = Confirmed`) |
| Questions | F0 gaps: numbered list; do not mix with F2 packet in same reply |
| Packets | After reply scaffold; full packet in ` ```text ` block — not paraphrased |
| Runbook | Paste [template.runbook.md](assets/template.runbook.md) only when user asks how to run |

**Bad:** "เสร็จแล้วค่อยบอก" / "ทำ UI ต่อได้" / paragraph without หยุดจนกว่า  
**Good:** "## คุณทำต่อ … ข้อความใหม่ + `@api-builder`" + "## หยุดจนกว่า `Gate Ship = Confirmed`"

## Phase detail

### F0 — Intake

Capture **who**, **what**, **success criteria**, **out of scope**. If UI ref missing, mark UI phase **blocked** in plan — do not pretend ui-builder can run.

### F1 — Plan

Minimum rows in phase plan:

| Step | Owner skill | Done when |
|------|-------------|-----------|
| API | `@api-builder` | Gate Ship Confirmed |
| Handoff | feature-builder | fe-handoff pasted |
| UI | `@ui-builder` | Gate B Confirmed |
| Integration | feature-builder | Feature Ship Confirmed |

### F2 — API delegation

- Packet file: [template.api-invoke-packet.md](assets/template.api-invoke-packet.md) — do not shorten below template headings.
- Prefer **narrow delta** when user names one endpoint; **CRUD pack** when user lists E1–E4 for a resource.
- Tell user **new message** before `@api-builder`.
- If api-builder stops at Revise → update plan or fix blockers; do not skip to UI.

### F3 — Handoff

Copy structure from [api-builder fe-handoff](../api-builder/assets/template.handoff-to-ui.md). Required: endpoints table, success samples, error table, FE bind fields.

### F4 — UI delegation

- **Default:** one surface per invoke (login form only).
- **Full shell OK** when user names every S0…Sn + one viewport + ref (e.g. Discord 4-pane) — still **only** via `@ui-builder`, not feature-builder code.
- Must include viewport + ref path/URL.
- Attach fe-handoff block verbatim.
- Packet: [ui-invoke-packet](assets/template.ui-invoke-packet.md).

### F5 — Feature Ship

Manual smoke only in v1 ([integration-checklist](assets/checklist.integration.md)). No automated E2E in this skill.

## Pitfalls

| # | Symptom | Fix |
|---|---------|-----|
| F1 | UI built before API Ship | Stop; return to F2 until Ship Confirmed |
| F2 | No fe-handoff | Fill F3 before F4 |
| F3 | Merged Gate Contract + Gate A | Split chats/skills; refuse single combined gate |
| F4 | Whole-app ui-builder scope | Narrow to S# + one viewport |
| F5 | No visual ref | Pause UI phase; ask user for mockup |
| F6 | feature-builder writes API code | Move work to `@api-builder` packet |
| F7 | feature-builder writes components | Move work to `@ui-builder` packet |
| F8 | "Done" without Gate B | Require ui-builder Confirmed evidence |
| F9 | Skipped auth in plan | Add session model to F0/F1 |
| F10 | ai-skills repo mistaken for app | Confirm target workspace |
| F11 | Data correct in API, wrong on UI | After F4, suggest `@debug` — not api-builder |
| F12 | User wants push in same breath | After Feature Ship → `@pr-review` → `@git-push` |
| F13 | User says "ทำครบ/ฟังก์ชันครบ" one message | F0–F1 + F2 packet + F4 packet; **stop** — no TSX/CSS in orchestrator turn |
| F14 | Feature Ship without Gate B paste | **Not confirmed** until ui-builder B evidence |
| F15 | UI ~6/10 but "works" | Re-run `@ui-builder` for Gate A→B at locked viewport; do not lower bar in Feature Ship |
| F16 | Multi-pane layout floats | Hand off layout fix to `@ui-builder` (pitfall #25) or `@debug` if data OK but wrong bind |
| F17 | User ไม่รู้ว่าต้องรัน skill ไหน | Post [template.runbook.md](assets/template.runbook.md) + บอก step ถัดไปเดียว |
| F18 | F2/F4 ในเทรดเดียวกับ orchestrator ยาว | แนะนำข้อความใหม่ + @skill ลูก; F3/F5 กลับ feature-builder |
| F19 | Reply ยาวไม่มี "คุณทำต่อ" | บังคับ [template.reply.md](assets/template.reply.md) |
| F20 | หลายคำถาม + packet ปนกัน | แยกเทิร์น: ถาม input ก่อน หรือส่ง packet หลัง Gate F |

## Cross-skill

| Situation | Skill |
|-----------|-------|
| Endpoint/validation/DB | `@api-builder` |
| Pixel/layout vs ref | `@ui-builder` |
| JSON correct, UI map wrong | `@debug` |
| Maintain ai-skills canonical | `@upgrade` |
| Ship | `@pr-review` → `@git-push` — orchestrator never runs git CLI |

## Common rationalizations (agent discipline)

| Rationalization | Reality |
|-----------------|---------|
| "ทำ login ครบในเทิร์นเดียว" | ต้อง F0–F1 + Gate F Approved ก่อน child packets |
| "UI เสร็จแล้ว ไม่ต้องส่ง Gate B" | Feature Ship ต้องมี ui-builder Gate B evidence |
| "เขียน component ในเทิร์น feature-builder เร็วกว่า" | F4 = packet ไป `@ui-builder` — orchestrator ไม่เขียน TSX/CSS |
| "API เกือบ Ship ไป UI ก่อน" | Hard stop ที่ F3 — ต้อง API Ship Confirmed |
| "push ทันทีหลัง Feature Ship" | Ship → `@pr-review` แล้ว `@git-push` |
| "รันยังไง / ต่อยังไง" | Paste runbook; ระบุ @skill + new message + stop until phrase |
| "ตอบยาวไม่รู้ขั้นถัดไป" | ใช้ reply template — คุณทำต่อ 1 ขั้น + หยุดจนกว่า |

## Red flags

- ไม่มี Gate F Approved แต่ส่ง F2/F4 packet
- Feature Ship โดยไม่ paste Gate B / Score
- Orchestrator แก้ `routes` / `*.tsx` ในเทิร์นเดียวกัน
- ไม่มี visual ref + viewport ใน F4 packet
- User urgency แทน checklist evidence

## Anti-patterns

1. **Single mega-prompt** — "build login FE+BE" with no phases → produce F0–F1 first.
2. **Implement in orchestrator chat** — any route/component change belongs in child skill.
3. **Skip Gate F** — user urgency is not approval.
4. **ui-builder without API Ship** — hard stop at F3.

## Troubleshooting

| Issue | Action |
|-------|--------|
| User only has mockup | F0 + API plan first; UI blocked until Ship + ref confirmed |
| API and UI in different repos | Two plans or monorepo paths explicit in F1 |
| feature-builder invoked inside api-builder thread | Finish API Ship; start new packet for ui-builder |
| Child skill not available | Paste packet anyway; user invokes manually |

## Self-upgrade

Repeatable orchestration gap → one row in Pitfalls F# — do not bloat [SKILL.md](SKILL.md).
