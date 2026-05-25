# reference — flow-builder (v1.0.3)

**Index:** Skill boundaries · **Workflow F0–F4** · Layers · Repo discovery · Pitfalls F1–F15 · Optional handoffs · Rationalizations · Red flags · Troubleshooting

## Skill boundaries (do not duplicate)

| Question | Use | Not flow-builder |
|----------|-----|------------------|
| One button → steps → data source → create/update **ใช่มั้ย** | **flow-builder** | — |
| Wrong value **now** on screen (repro) | `@debug` | diagnose + fix |
| Full feature phases + api/ui packets | `@feature-builder` | F0–F5 orchestration |
| OpenAPI / Gate Contract / implement API | `@api-builder` | Ship |
| Pixel / Gate A·B | `@ui-builder` | visual |
| Code review before push | `@pr-review` | R1–P12 |
| What each **skill** does (catalog) | [README.md](../README.md) | no Gate Flow |
| Edit skill files in AI-SKILLS | `@upgrade` | canonical |

**Deliverable contrast**

| Artifact | Scope |
|----------|--------|
| `flow-spec` (this skill) | **One trigger** on one screen |
| `feature-spec` (feature-builder) | **Whole feature** + phases |
| `contract-spec` (api-builder) | **Endpoint contract** + gates |
| diagnosis report (debug) | **Bug** layers D1–D6 |

Suggested HTTP rows in flow-spec are **skeletons for handoff** — not Gate Contract.

## Workflow (F0–F4)

Load per step in [SKILL.md](SKILL.md) Quick reference.

### F0 — Intake

Confirm required inputs. Echo scope in Thai.

**Redirect (do not start F1–F4):**

| User asks | Action |
|-----------|--------|
| How each **@skill** works / skill catalog | [ai-skills/README.md](../README.md) — **stop** |
| Maintain or audit **AI-SKILLS** repo skills | `@upgrade` — **stop** |
| Whole app or **many** buttons at once | Pick **one trigger** or `@feature-builder` — **stop** until scoped |
| Data **already wrong** on screen | `@debug` — **stop** |

If vague feature idea with **many** buttons, ask user to **pick one trigger** for this pass.

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

Paste flow-spec to user. Optional: suggest `docs/flows/<name>.md` in app repo (user commits via `@git-push`).

## Layers

| Layer | Question | Template |
|-------|----------|----------|
| Action | What happens after click/submit? | `template.action-flow.md` |
| Data lineage | Where does each value come from? | `template.data-lineage.md` |
| Mutation | What is created/updated/deleted? | `template.mutation-chain.md` |
| Side effects | Router, toast, cache, modal | mutation § Side effects |

## Repo discovery (when code exists)

Read **narrowly** around the trigger — do not full-repo scan.

| Step | Look for |
|------|----------|
| 1 | Component for screen — button `onClick` / form `onSubmit` |
| 2 | Handler — calls service, hook, or dispatch |
| 3 | API client — method, path, body |
| 4 | State — React state, Zustand, Redux, Query keys |
| 5 | Success path — invalidate, refetch, navigate |

Tag each finding `repo` + path. If not found, `assumed` + ask user.

Stack-agnostic: adapt names (Vue action, Rails controller, etc.) — same columns.

## Pitfalls F1–F12

| ID | Pitfall | Fix |
|----|---------|-----|
| F1 | Multiple buttons in one pass | Split scope or get user pick one trigger |
| F2 | Skip **ใช่มั้ย** on mutations | Stop F3 until per-row confirm |
| F3 | Claim POST path without evidence | Tag `assumed`; ask user |
| F4 | Confuse plan with implement | Hand off `@api-builder` / `@ui-builder` |
| F5 | User reports live bug | `@debug` not flow-builder |
| F6 | Merge Gate Flow with api Contract | Keep gates separate |
| F7 | Happy path only | F4 error + loading rows |
| F8 | Data lineage for whole app | Only fields user asked + on-screen |
| F9 | Rubber-stamp Approved | F4 blockers + confirms required |
| F10 | ai-skills repo as app target | Refuse or scope = docs only |
| F11 | Long prose no tables | Use templates |
| F12 | Run git in flow-builder | Forbidden — `@git-push` |
| F13 | User wants skill catalog / “เช็คทุก skill” | [README.md](../README.md); one-skill boundary table above |
| F14 | Target is ai-skills repo maintenance | `@upgrade` |
| F15 | Whole user journey / all screens | `@feature-builder` or multiple flow-builder passes (one trigger each) |

## Optional handoffs (detail)

After **Gate Flow Approved**, user may paste `flow-spec` into:

- **api-builder** — table of method/path/body from mutation chain
- **ui-builder** — data lineage bind rows + visual ref
- **feature-builder** — optional F0 attachment; not required by this repo

## Common rationalizations (agent discipline)

| Rationalization | Reality |
|-----------------|---------|
| "User said ใช่มั้ย once = whole spec approved" | Per **row** in mutation chain |
| "I found one file = flow done" | Still need lineage + gaps |
| "I'll fix by implementing now" | Wrong skill — hand off |
| "Same as last feature" | Re-run F1–F3 for this trigger |

## Red flags

- Gate Flow **Approved** with `assumed` API and no user confirm
- No error path on auth/payment/checkout flows
- Implementing code in flow-builder thread
- `git commit` from this skill

## Troubleshooting

| Symptom | Action |
|---------|--------|
| User unsure which button | List buttons on screen; AskQuestion pick one |
| Repo too large | Scope to one folder user names |
| Conflicting files | Present both readings; ask user |
| Requirements only | All rows `user` or `assumed` + confirm |
