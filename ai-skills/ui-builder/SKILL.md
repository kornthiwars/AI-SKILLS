---
name: ui-builder
description: >-
  UI Builder — builds UI to match reference images at locked viewport(s); Senior
  Designer gates A/B per width. Single-width default; multi-breakpoint when user
  lists every W×H with a ref per width. Triggers on /ui-builder, @ui-builder,
  UI Builder, mockup, screenshot, multi-breakpoint, responsive refs, Figma,
  live URL clone, pixel-perfect, ตรงรูป, ตามดีไซน์, สร้าง UI จากรูป, design QA,
  10/10, 9-10, คุณภาพสูงสุด, UI สวยสุด.
  Does not apply when there is no visual reference, only a rough wireframe,
  responsive layout from one mockup without per-width refs, backend-only tasks,
  wrong totals/labels/list data or API-vs-UI logic (use @debug), design critique
  without implementation, deliverable for another tool only, or any git commit/push (hand off
  @pr-review then @git-push).
compatibility: Cursor and Claude Code; cursor-ide-browser MCP; npx serve for preview; file:// blocked in agent browser
disable-model-invocation: true
metadata:
  version: "1.0.1"
  author: kornthiwars
  license: MIT
  surfaces:
    - ide
---

# UI Builder

Build UI to **match the reference at locked viewport(s)** using the project stack. **Senior Designer gates** block coding (A) and delivery (B). **Default quality tier: 10/10** ([assets/checklist.quality-tier.md](assets/checklist.quality-tier.md)) — side-by-side screenshot, 0 blockers, 0 tier-10 waivers. Default: **one width**; **multi-breakpoint** when user supplies every width + ref ([reference.md](reference.md) § Multi-breakpoint).

## Operating stance

- **Reference is law** at the locked width — not "close enough."
- **End-to-end** — spec → build → verify against reference; the diff alone is not proof.
- **Gates are blocking** — Approved / Confirmed are binary; Revise and Not confirmed mean rework.
- **Actionable output** — every gate cites evidence (px, `#hex`, screenshot, or delta row).
- **10/10 is the default bar** — score 9 only with documented waivers; never claim 10 without tier-10 checklist.

## Required inputs — refuse Phase 1 without these

Confirm all three with the user. If any are missing, list gaps and **stop** (no spec, no code):

- [ ] **Visual reference** — image, Figma export, or live URL to capture
- [ ] **Viewport** — one W×H locked, **or** user lists all breakpoints (B0, B1…) each with W×H + ref
- [ ] **Build target** — existing repo/stack, or user names the stack for a greenfield file
- [ ] **Quality tier** — default **10**; tier **8** only if user says draft / prototype / ไม่ต้อง pixel-perfect

## Hard rules

- **No code** until Gate **A = Approved**
- **No deliver** until Gate **B = Confirmed** and delta **0 blockers**
- **Tier 10 deliver** — browser screenshot @ locked W×H required; **no** `Score: 10/10` with CSS-audit-only (#30)
- **Tier 10** — no emoji chrome (#26); ref imagery needs assets or **user-approved** waiver in Gate A (#29)
- **Single-width** unless user explicitly requests **multi-breakpoint** (every width + ref named)
- **Multi-breakpoint:** Gate A/B **per B#**; build/verify one width at a time ([assets/template.breakpoints-spec.md](assets/template.breakpoints-spec.md))
- **px / `#hex` only** in spec
- **No extra UI** vs reference (#17 promos unless requested)
- Senior Designer: **no code**
- **Wrong data/logic on screen** (totals, labels, list not updating, API OK but UI wrong) → `@debug`, not ui-builder — even if user attached a mockup
- **No git commands** — no `git status` / `add` / `commit` / `push` / `pull` / `rebase`; ship → `@pr-review` then `@git-push` only

## Quick reference

| Phase | Load | Outcome |
|-------|------|---------|
| 0 Intake | [reference.md](reference.md) | Viewport + map S0… |
| 1 Spec | viewport or [breakpoints template](assets/template.breakpoints-spec.md) | Measurable spec |
| A | [reference.md](reference.md) | Approved \| Revise |
| 2 Tokens | [reference.md](reference.md) § Phase 2 | Token table from spec |
| 3 Build | [reference.md](reference.md) pitfalls | Layers + code |
| 4 Verify | [reference.md](reference.md) § Verify | 0 blockers |
| B | [gate-b-template](assets/template.gate-b.md) + [reference.md](reference.md) | Confirmed \| Score __/10 |
| Deliver | [reference.md](reference.md) § Gate B + tier 10 | A + B + summary |

Prefix: `[Implementer]` / `[Senior Designer]`.

## When to use / NOT

**Use:** mockup, screenshot, Figma, live URL, ตรงรูป, `/ui-builder`, `@ui-builder`, UI Builder

**NOT:** no reference · wireframe-only · one mockup + “make responsive” without per-width refs · backend-only → `@api-builder` · **wrong data/logic** (ตัวเลข รายการ map/state) → `@debug` · critique-only · other-tool deliverable · analytical canvas

## Cross-skill

| Situation | Skill |
|-----------|--------|
| Server contract / wrong API response | `@api-builder` |
| API JSON correct, wrong value on screen | `@debug` |
| Full FE+BE feature (login, checkout) | `@feature-builder` plans · **you** implement UI after API Ship |
| feature-builder posted F4 only | Run full Gate A→B; return B evidence — orchestrator must not ship without it |
| Pixel/color/spacing vs reference only | stay in ui-builder |
| Multi-pane app shell (Discord, Slack) | Full S0…Sn OK at one locked viewport — see pitfalls #25–#27 |
| Ship (review + push) | `@pr-review` → `@git-push` — not Gate A/B (visual) |

## Workflow

Run in order. Do not skip gates.

### 0 — Intake · 1 — Spec · 2 — Tokens · 3 — Build · 4 — Verify

Phases 0–1, A, 4, B: [reference.md](reference.md). Pitfalls **#1–32**. Tier 10: [assets/checklist.quality-tier.md](assets/checklist.quality-tier.md). Verify: `cursor-ide-browser` required for tier 10 ([§ Visual compare](reference.md)).

### Deliver

Paste A + B → summary (viewport, theme, verify, deviations)

## Output flow

1. Confirm **required inputs** (above).
2. Phase 0–1 → **Gate A** ([reference.md](reference.md) form).
3. Phase 2 (token table) → Phase 3–4 only if **Approved**.
4. **Gate B** — 0 blockers; post **Score** using [assets/checklist.quality-tier.md](assets/checklist.quality-tier.md) (default target **10/10**).
5. Post A + B ([assets/template.gate-b.md](assets/template.gate-b.md)) + summary in chat.
6. Repeatable gap → patch [reference.md](reference.md) (one pitfall or verify note).
7. **Vault:** search `vault/learnings/` before heavy UI debug; learning if ≥3 prompt rounds on same problem; issues auto on Q&A — [vault/README.md](../../vault/README.md).
8. When user will **commit/push** → suggest `@pr-review` (e.g. `production`) then `@git-push` (code/quality — not visual Gate A/B).

## Language

- **70% ไทย / 30% อังกฤษ** — spec อธิบาย, สรุป, คำถาม user เป็นภาษาไทย; ใช้อังกฤษ ~30% สำหรับ Gate A/B, Approved, Revise, Confirmed, Phase 2, viewport, pitfall #N, S0/B0, tier 10
- **Mix ธรรมชาติ** — เช่น "Gate A **Approved** — เริ่ม Phase 2 token table ที่ viewport 390×844"
- **Gloss ครั้งแรกต่อ reply** — `Approved (อนุมัติแล้ว)`, `Not confirmed (ยังไม่ยืนยัน)`, `blocker (จุดที่ต้องแก้ก่อนส่ง)`
- ตาราง Gate / delta: หัวแถวไทยได้; ค่าเทคนิค EN + วงเล็บแปลไทยเมื่อจำเป็น
- **ไม่แปล** — `@ui-builder`, path, โค้ด

## Voice

| Role | Do | Don't |
|------|-----|-------|
| Implementer | spec, code, verify, fix | Skip gates; "done" with blockers |
| Senior Designer | A/B vs reference | Write or edit code |

## Operating rules

- **No rubber-stamp gates** — cite section IDs and evidence in A/B.
- **Cite or it didn't happen** — delta rows reference S# and property.
- **Distinguish spec claim vs build** — "spec says #1877F2" vs "computed/#hex on element."
- **No flattery** — Confirmed only with 0 blockers; **10/10** only when tier-10 checklist is complete.

## Maintainer

Canonical: `ai-skills/ui-builder/`

## Resources

| File | Use when |
|------|----------|
| [reference.md](reference.md) | Spec, pitfalls, verify, Gate A/B · § Rationalizations / Red flags |
| [assets/template.viewport-spec.md](assets/template.viewport-spec.md) | Phase 1 single width |
| [assets/template.breakpoints-spec.md](assets/template.breakpoints-spec.md) | Phase 1 multi-breakpoint |
| [assets/checklist.quality-tier.md](assets/checklist.quality-tier.md) | Default bar 10/10 · waivers |
| [assets/template.gate-b.md](assets/template.gate-b.md) | Gate B + Score |

Authoring: `ai-skills/SKILL-AUTHORING.md`
