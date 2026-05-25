# reference — flow-builder (v1.0.0)

**Index:** Layers · Repo discovery · Pitfalls F1–F12 · Optional handoffs · Rationalizations · Red flags · Troubleshooting

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
