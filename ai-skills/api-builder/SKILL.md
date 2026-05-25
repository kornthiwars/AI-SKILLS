---
name: api-builder
description: >-
  API Builder — designs and implements API endpoints, validation, auth, and
  persistence using repo conventions; Senior API Reviewer gates Contract/Ship.
  Stack-agnostic with optional stack appendices; narrow contract-delta for single
  endpoint fixes; CRUD pack (E1–E4) when user lists all operations. Triggers on
  /api-builder, @api-builder, API Builder, endpoint, REST, GraphQL, OpenAPI,
  migration, Prisma, validation, contract, webhook, สร้าง API, แก้ API. Does not
  apply to mockup/pixel UI, FE-only mapping when server response is already
  correct (@debug), full FE+BE without split scope (use
  @feature-builder), ai-skills repo maintenance (@upgrade), visual work (ui-builder),
  or any git commit/push (hand off @pr-review then @git-push).
compatibility: Cursor and Claude Code; project test runner and HTTP client; OpenAPI/GraphQL schema when present; stack conventions in reference.md
disable-model-invocation: true
metadata:
  version: "1.0.4"
  author: kornthiwars
  license: MIT
  surfaces:
    - ide
---

# API Builder

Build and fix **APIs, validation, auth, and persistence** to match an **approved contract** in the user's project stack. **Senior API Reviewer gates** block implementation (Contract) and delivery (Ship). Default: **one endpoint (E1)** or **narrow delta**; **CRUD pack** when user lists every operation upfront ([assets/template.crud-pack.md](assets/template.crud-pack.md)).

## Operating stance

- **Contract is law** — method, path, bodies, status codes, and errors must match the approved spec.
- **End-to-end** — spec → DTO map → implement → verify; the diff alone is not proof.
- **Gates are blocking** — Approved / Confirmed are binary; Revise and Not confirmed mean rework.
- **Actionable output** — every gate cites evidence (contract row, test name, response sample, or delta row).
- **Stack follows repo** — discovery first; follow [reference.md](reference.md) § Stack discovery and appendices.

## Required inputs — refuse Phase 1 without these

Confirm all five with the user. If any are missing, list gaps and **stop** (no contract spec, no code):

- [ ] **Operation** — create / change / remove which endpoint or GraphQL operation
- [ ] **Contract sketch** — method + path (or operation name), request body/query, success response shape
- [ ] **AuthZ** — who may call (public, authenticated user, role, service account)
- [ ] **Persistence** — entities/tables touched; new migration yes/no
- [ ] **Error model** — status codes + error body fields per project convention

**Narrow scope:** user may scope to **one E#** or **delta rows only** ([assets/template.endpoint-delta.md](assets/template.endpoint-delta.md)) — do not expand to full resource CRUD unless requested.

If the repo already has OpenAPI or GraphQL schema, treat it as baseline and document **deltas** only.

## Hard rules

- **No implementation** until Gate **Contract = Approved**
- **No deliver** until Gate **Ship = Confirmed** and contract delta **0 blockers**
- **No breaking change** without versioning or migration plan in the approved contract
- **AuthZ on server** — never rely on hiding routes in the client
- **Validation at project boundary** (middleware, DTO, schema layer) — avoid duplicate rules in handlers
- **CRUD pack:** Gate Contract/Ship **per E#** or one pack table with all E1–E4 Approved together — user chooses; default one gate for whole pack if listed in one contract doc
- Senior API Reviewer: **no implementation edits** (review contract and verify evidence only)
- **UI work is out of scope** — FE changes → `@ui-builder` with [fe-handoff template](assets/template.handoff-to-ui.md)
- **Data correct in API but wrong on screen** → `@debug`, not api-builder
- **No git commands** — [SKILL-AUTHORING.md](../SKILL-AUTHORING.md) § Git operations

## Quick reference

| Phase | Load | Outcome |
|-------|------|---------|
| 0 Intake | [reference.md](reference.md) § Stack discovery | Stack + folder conventions + appendix |
| 1 Contract | [contract template](assets/template.contract-spec.md) or [CRUD pack](assets/template.crud-pack.md) or [narrow delta](assets/template.endpoint-delta.md) | Measurable contract |
| 1.5 DTO map | [reference.md](reference.md) § Phase 1.5 | Types/DTOs traceable to E# |
| Contract | [reference.md](reference.md) § Gate Contract | Approved \| Revise |
| 2 Implement | [reference.md](reference.md) § Implementation | routes → handler → service → persistence |
| 3 Verify | [reference.md](reference.md) § Verify | 0 blockers |
| Ship | [reference.md](reference.md) § Gate Ship | Confirmed \| re-3 |
| Deliver | [reference.md](reference.md) § Gate Ship | Contract + Ship + summary + optional FE handoff |

Prefix: `[Implementer]` / `[Senior API Reviewer]`.

## Workflow

Run in order. Do not skip gates.

### 0 — Intake · 1 — Contract · 1.5 — DTO · 2 — Implement · 3 — Verify

Phases 0–1, Contract, 1.5, 3, Ship: [reference.md](reference.md). Pitfalls **#1–20**.

### Deliver

Paste Contract + Ship → summary → [FE handoff](assets/template.handoff-to-ui.md) if needed

## Output flow

Inputs → Gate Contract → DTO → implement/verify → Gate Ship → deliver + optional FE handoff · vault: [vault-learning.mdc](../../ai-rules/vault-learning.mdc) · ship: `@pr-review` → `@git-push`

## Cross-skill (feature-builder)

When user wants a **full feature** (e.g. login):

1. **api-builder** — contract + implement + Ship for API slice only.
2. Paste **FE handoff** ([assets/template.handoff-to-ui.md](assets/template.handoff-to-ui.md)).
3. **ui-builder** — separate chat/invoke with visual ref + narrow UI scope.
4. Do not merge Gate Contract with Gate A (visual).

## Language

[SKILL-AUTHORING.md](../SKILL-AUTHORING.md) § Language. **Gloss:** `Approved (อนุมัติแล้ว)`, `Not confirmed (ยังไม่ยืนยัน)`, `blocker (จุดที่ต้องแก้ก่อนส่ง)` · EN: Gate Contract/Ship, E1, pitfall #N.

**Voice:** [reference.md](reference.md) § Voice

## Resources

| File | Use when |
|------|----------|
| [reference.md](reference.md) | Workflow, gates, pitfalls, verify · § Rationalizations / Red flags |
| [assets/template.contract-spec.md](assets/template.contract-spec.md) | Single endpoint |
| [assets/template.crud-pack.md](assets/template.crud-pack.md) | E1–E4 resource pack |
| [assets/template.endpoint-delta.md](assets/template.endpoint-delta.md) | One endpoint, delta only |
| [assets/template.handoff-to-ui.md](assets/template.handoff-to-ui.md) | After Ship → ui-builder |

Authoring: `ai-skills/SKILL-AUTHORING.md`
