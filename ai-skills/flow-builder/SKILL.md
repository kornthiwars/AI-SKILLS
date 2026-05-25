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
  version: "1.0.3"
  author: kornthiwars
  license: MIT
  surfaces:
    - ide
---

# Flow Builder

**Clarify** one **trigger** before implementation: steps, **data lineage**, **mutations** + **ใช่มั้ย**. **No app code** in this skill.

## Operating stance

- **Analyst, not implementer** — tables + mermaid + questions
- **One trigger per pass** — split extra triggers to another invoke
- **Evidence tags** — `repo` | `user` | `assumed` (assumed → confirm)
- **Confirm mutations** — F3 per-row ใช่ / ไม่ / ไม่แน่
- **Reply:** [assets/template.reply.md](assets/template.reply.md) every turn

## Required inputs — refuse F0 without these

- [ ] **Trigger** · **Screen / surface** · **Expected outcome** (1–3 sentences) · **Target** (app repo or requirements-only)

Optional: **Fields to trace** · **User hypothesis** (สร้างแล้วอัปเดต … ใช่มั้ย)

List gaps in Thai and **stop**.

## Hard rules

- **No app implementation** · **no API Contract/Ship** · **no pixel gates**
- **No git** — [SKILL-AUTHORING.md](../SKILL-AUTHORING.md) § Git operations
- **No full-feature orchestration** → `@feature-builder` · **no runtime debug** → `@debug`
- **No rubber-stamp Gate Flow** — F4 + **ใช่มั้ย** on mutations before **Approved**
- **No multi-trigger soup** · **≤5 bullets** in สรุป; templates in fenced blocks

## Quick reference

| Step | Load | Outcome |
|------|------|---------|
| F0 | [reference.md](reference.md) § Workflow F0 | inputs OK or redirect/stop |
| F1 | [template.action-flow](assets/template.action-flow.md) | steps + mermaid |
| F2 | [template.data-lineage](assets/template.data-lineage.md) | field → source |
| F3 | [template.mutation-chain](assets/template.mutation-chain.md) | mutations + confirms |
| F4 | [checklist.flow-gaps](assets/checklist.flow-gaps.md) | gap table |
| Gate | [template.flow-spec](assets/template.flow-spec.md) | **Approved** \| **Revise** |

Step detail: [reference.md](reference.md) § Workflow (F0–F4) · § Repo discovery · § Pitfalls

## Gate Flow — verdict

| Verdict | Meaning |
|---------|---------|
| **Approved** | 0 blockers; mutations confirmed |
| **Revise** | open questions, **ไม่** on chain, or critical gap |

Deliverable: [assets/template.flow-spec.md](assets/template.flow-spec.md) — merge F1–F4.

## Workflow

Run Quick ref in order. F0 redirects + F1–F4 + Gate: [reference.md](reference.md) § Workflow.

## Output flow

F0 → F1 → F2 → F3 (ใช่มั้ย) → F4 → Gate Flow → optional handoff

## Handoffs (after Approved)

| Goal | Skill |
|------|-------|
| Build API | `@api-builder` |
| Bind UI | `@ui-builder` |
| Full feature | `@feature-builder` (paste flow-spec in F0) |
| Wrong on screen | `@debug` |
| Ship | `@pr-review` → `@git-push` |

Detail: [reference.md](reference.md) § Optional handoffs

## Language

[SKILL-AUTHORING.md](../SKILL-AUTHORING.md) § Language. **Gloss:** `lineage (แหล่งข้อมูล)`, `mutation chain (สร้าง/อัปเดต)` · EN: Gate Flow, F1–F4.

## Resources

| File | Use |
|------|-----|
| [FILES.md](FILES.md) | Inventory |
| [reference.md](reference.md) | § Workflow · boundaries · pitfalls |
| [assets/template.flow-spec.md](assets/template.flow-spec.md) | Gate deliverable |

Canonical: `ai-skills/flow-builder/`
