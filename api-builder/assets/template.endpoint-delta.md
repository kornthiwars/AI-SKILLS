# Narrow delta contract — one endpoint, change rows only

Use when user scopes **a single fix** (validation, status code, one field) — not full CRUD.

```
Feature: <name>
Mode: narrow-delta
Scope: E1 only — do not add E2+
Baseline: <openapi path | handler file | none>
Breaking change: no | yes — <note>

## E1 — <method> <path>
AuthZ: <unchanged | new rule>

### Delta (what changes)
| area | before | after |
|------|--------|-------|
| invalid email | 400 | 422 + details[] |
| response field X | optional | required |

### Unchanged (explicit)
- success 200 body shape except rows above
- auth middleware order

### Errors (full table after delta)
| status | body | when |
|--------|------|------|
| 422 | … | validation |

### Persistence
- none | migration <name>

### Tests to update
- [ ] <test name>
```

Gate Contract reviews **delta table** + full error table for E1 only.
