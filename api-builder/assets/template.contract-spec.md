# Contract spec template — copy for Phase 1 (single endpoint)

```
Feature: <name>
Mode: single
Repo stack: <discovered>
Baseline: <openapi.yaml | GraphQL schema | none>
Breaking change: no | yes — <plan>

## E1 — <short title>
Method + path: POST /api/orders
AuthZ: authenticated user (role: customer)
Idempotency: Idempotency-Key header | none

### Request
| field | type | required | notes |
|-------|------|----------|-------|
| productId | uuid | yes | |

### Success — 201
| field | type | notes |
|-------|------|-------|
| id | uuid | |

### Errors
| status | body | when |
|--------|------|------|
| 400 | { code, message } | malformed JSON |
| 422 | { code, message, details[] } | validation |
| 401 | { code, message } | no token |
| 403 | { code, message } | wrong role |
| 404 | { code, message } | productId not found |

### Persistence
- Insert Order …
- Migration: none | <name>

### Optional blocks (include if in scope)
#### File upload
- field name, max bytes, MIME allow-list, storage path

#### Webhook (outbound)
- URL, signing header, retry policy, payload schema

#### Bulk
- max items per request, partial success rules

#### Versioning / ETag
- If-Match on PATCH, 409 conflict body

#### Deprecation
- Sunset header, replacement path /v2/...
```

CRUD: use [template.crud-pack.md](template.crud-pack.md). Narrow fix: [template.endpoint-delta.md](template.endpoint-delta.md).
