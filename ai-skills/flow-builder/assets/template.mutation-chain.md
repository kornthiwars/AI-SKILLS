# Mutation chain — F3 (copy into chat)

```
[flow-builder F3]
Scope: <trigger> on <screen>
Mutation chain — create / update / delete

## Your mental model (optional)
<user said: click X creates A then updates B — ใช่มั้ย?>

## Chain
| Step | After | HTTP / action | Creates | Updates | Deletes | Evidence | User confirms |
| 1 | click <trigger> | POST … | <entity> | — | — | repo \| assumed | ใช่ \| ไม่ \| ไม่แน่ |
| 2 | success <status> | PATCH … | — | <fields / stores> | — | … | … |
| 3 | … | invalidate / refetch | — | <list cache> | — | … | … |

## Side effects (non-HTTP)
| Effect | Where |
| router push | … |
| toast | … |
| modal close | … |
| localStorage | … |

## Confirm summary (ask user)
- Step 1 creates `<X>` — **ใช่มั้ย?**
- Step 2 updates `<Y>` — **ใช่มั้ย?**
```
