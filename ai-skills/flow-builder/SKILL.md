---
name: flow-builder
description: >-
  Flow Builder — maps pre-build action flows, data lineage, and create/update
  chains for one UI trigger; asks the user to confirm "ใช่มั้ย" before
  implementation. Triggers on /flow-builder, @flow-builder, flow builder,
  ไล่ flow, กดปุ่มแล้วเกิดอะไร, ข้อมูลมาจากไหน, สร้างแล้วอัปเดต, mutation chain,
  one button flow. Does not apply when the app already fails on screen (use
  @debug), pixel/mockup work (@ui-builder), API implementation (@api-builder),
  full FE+BE orchestration (@feature-builder), skill catalog or how @skills work
  (read ai-skills/README.md), whole-app architecture review, ai-skills repo
  maintenance (@upgrade), or git commit/push (hand off @pr-review then @git-push).
compatibility: Cursor and Claude Code; user app repo or requirements only; read-only code inspection; optional mermaid in chat
disable-model-invocation: true
metadata:
  version: "1.0.2"
  author: kornthiwars
  license: MIT
  surfaces:
    - ide
---

# Flow Builder

**Clarify** how one **trigger** (button, submit, link) behaves **before** implementation: action steps, **where data comes from**, and **what gets created/updated** — with explicit **ใช่มั้ย** confirmation. **Do not** write application code in this skill.

## Operating stance

- **Analyst, not implementer** — diagrams + tables + questions; no routes, components, or migrations
- **One trigger per pass** — one button/event on one screen; split extra triggers to another invoke
- **Evidence tags** — every row: `repo` | `user` | `assumed` (assumed needs confirm)
- **Confirm mutations** — F3 ends with user answers per chain row (ใช่ / ไม่ / ไม่แน่)
- **Standalone** — Gate Flow Approved does **not** require `@feature-builder`; optional handoff after
- **Reply scaffold** — [assets/template.reply.md](assets/template.reply.md) every turn (TH)

## Required inputs — refuse F0 without these

- [ ] **Trigger** — e.g. button "สร้างออเดอร์", form Submit, menu item
- [ ] **Screen / surface** — page, modal, or component zone
- [ ] **Expected outcome** — what user thinks should happen (1–3 sentences)
- [ ] **Target** — app repo path in workspace **or** requirements-only (no code yet)

Optional (ask if missing and needed for F2/F3):

- [ ] **Fields to trace** — labels or controls user cares about
- [ ] **User hypothesis** — e.g. "กดแล้วสร้าง A แล้วอัปเดต B ใช่มั้ย"

List gaps in Thai and **stop**.

## Hard rules

- **No app implementation** — no TS/JS/CSS/SQL edits in this skill/thread
- **No git commands** — [SKILL-AUTHORING.md](../SKILL-AUTHORING.md) § Git operations
- **No pixel gates** — not `@ui-builder` Gate A/B
- **No API Contract/Ship** — not `@api-builder` gates; flow-spec may list **endpoint skeletons only** (method/path/body intent) — not OpenAPI, status matrix, or Gate Contract
- **No full-feature orchestration** — use `@feature-builder` when user wants phased FE+BE build
- **No runtime debug** — wrong data already on screen → `@debug`
- **No rubber-stamp Gate Flow** — F4 checklist + resolved **ใช่มั้ย** on mutations before **Approved**
- **No multi-trigger soup** — second button = new scope or user confirms expand
- **No wall of text** — ≤5 bullets in สรุป; templates in separate fenced blocks

## Quick reference

| Step | Load | Outcome |
|------|------|---------|
| F0 | — | inputs OK or stop |
| F1 | [template.action-flow.md](assets/template.action-flow.md) | steps + mermaid sequence |
| F2 | [template.data-lineage.md](assets/template.data-lineage.md) | field → source table |
| F3 | [template.mutation-chain.md](assets/template.mutation-chain.md) | create/update + **User confirms** |
| F4 | [checklist.flow-gaps.md](assets/checklist.flow-gaps.md) | gap table |
| Gate Flow | [template.flow-spec.md](assets/template.flow-spec.md) | **Approved** \| **Revise** |

Detail: [reference.md](reference.md) § Repo discovery · § Pitfalls

## Workflow

### F0 — Intake

Confirm required inputs. Echo scope in Thai.

**Redirect (do not start F1–F4):**

| User asks | Action |
|-----------|--------|
| How each **@skill** works / skill catalog | Point to [ai-skills/README.md](../README.md) — **stop** |
| Maintain or audit **AI-SKILLS** repo skills | `@upgrade` — **stop** |
| Whole app or **many** buttons at once | Pick **one trigger** or `@feature-builder` for multi-phase — **stop** until scoped |
| Data **already wrong** on screen | `@debug` — **stop** |

If user only has a vague feature idea with **many** buttons, ask them to **pick one trigger** for this pass.

### F1 — Action flow

1. Load [template.action-flow.md](assets/template.action-flow.md).
2. Build happy path: validate → network → UI feedback → navigation.
3. Add mermaid `sequenceDiagram` when helpful.
4. Tag evidence on API rows (`repo` | `user` | `assumed`).

### F2 — Data lineage

1. Load [template.data-lineage.md](assets/template.data-lineage.md).
2. For each field user asked (or visible on screen): source = API path, local state, props, cache.
3. If repo present: grep/read handler, store, query hooks — cite file path in Evidence.

### F3 — Mutation chain

1. Load [template.mutation-chain.md](assets/template.mutation-chain.md).
2. Restate user hypothesis ("สร้างแล้วอัปเดต … ใช่มั้ย") if given.
3. List Creates / Updates / Deletes per step; ask **User confirms** per row.
4. **Stop** until user answers ใช่ / ไม่ / ไม่แน่ for every row (revise model on **ไม่**).

### F4 — Gap check

Run [checklist.flow-gaps.md](assets/checklist.flow-gaps.md). Record blockers.

### Gate Flow

Merge F1–F4 into [template.flow-spec.md](assets/template.flow-spec.md).

| Verdict | Meaning |
|---------|---------|
| **Approved** | 0 blockers; mutations confirmed; gaps acceptable or documented |
| **Revise** | open questions, user **ไม่** on chain, or critical gap |

Paste flow-spec to user. Optional: suggest saving as `docs/flows/<name>.md` in app repo (user commits via `@git-push`).

## Reply format

Every turn: [assets/template.reply.md](assets/template.reply.md).

## Optional handoffs (after Gate Flow Approved)

| User goal | Skill | Bring |
|-----------|-------|-------|
| Build API | `@api-builder` | mutation HTTP rows + samples to draft |
| Bind UI | `@ui-builder` | data lineage + ref screenshot |
| Full feature plan | `@feature-builder` | paste flow-spec in F0 |
| Fix wrong on-screen data | `@debug` | not flow-builder |

## Output flow

1. F0 inputs  
2. F1 action flow  
3. F2 data lineage  
4. F3 mutation chain + **ใช่มั้ย** answers  
5. F4 gaps → Gate Flow **Approved** \| **Revise**  
6. Optional: child skill or stop  

## Handoffs

| Need | Skill |
|------|-------|
| Implement API / UI | `@api-builder` / `@ui-builder` |
| Full feature | `@feature-builder` |
| Wrong on screen | `@debug` |
| Ship | `@pr-review` → `@git-push` |

## Language

[SKILL-AUTHORING.md](../SKILL-AUTHORING.md) § Language. **Gloss:** `lineage (แหล่งข้อมูล)`, `mutation chain (สร้าง/อัปเดต)` · EN: Gate Flow, F1–F4.

## Resources

| File | Use |
|------|-----|
| [FILES.md](FILES.md) | Inventory |
| [reference.md](reference.md) | Discovery, pitfalls, rationalizations |
| [assets/template.flow-spec.md](assets/template.flow-spec.md) | Gate deliverable |

Canonical: `ai-skills/flow-builder/`
