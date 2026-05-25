# Flow gaps checklist — F4

Use for **one trigger** scope. Mark pass / fail / n/a + one-line note.

| # | Check | pass | note |
|---|--------|:----:|------|
| 1 | Trigger and screen named | | |
| 2 | Happy path steps complete (no magic “then it works”) | | |
| 3 | Loading / disabled state during async | | |
| 4 | Error path: 4xx/5xx / network — what UI shows | | |
| 5 | Auth: step needs session? role? | | |
| 6 | Double-submit / duplicate create | | |
| 7 | Optimistic UI vs wait for server | | |
| 8 | List/detail refresh after mutation | | |
| 9 | Navigation / modal close after success | | |
| 10 | Data lineage for every field user asked | | |
| 11 | Mutation chain matches user “ใช่มั้ย” answers | | |
| 12 | No assumed endpoint without evidence tag | | |

**Blocker examples:** missing error path on paid/auth flow · mutation step user answered **ไม่** but no revised model · assumed POST with no repo/user evidence and user did not confirm
