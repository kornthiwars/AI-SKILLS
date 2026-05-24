# CRUD pack template — resource E1–E4

Use when user asks for **full resource API** (create, list, get, update/delete).

```
Feature: <ResourceName> CRUD
Mode: crud-pack
Entity: <Product | Order | …>
Gate mode: one Contract for E1–E4 | per-E# incremental — <pick>
Breaking change: no

Shared model (all E#):
| field | type | notes |
|-------|------|-------|
| id | uuid | |
| … | | |

Shared errors: { code, message, details? }

## E1 — Create
POST /api/<resources>
AuthZ: <role>
Request: …
Success: 201 …
Errors: 400, 422, 401, 403

## E2 — List
GET /api/<resources>?cursor=&limit=
AuthZ: …
Success: 200 { items[], nextCursor? }
Errors: 400
Pagination: cursor | offset

## E3 — Get by id
GET /api/<resources>/:id
AuthZ: …
Success: 200 …
Errors: 404

## E4 — Update / Delete
PATCH or DELETE /api/<resources>/:id
AuthZ: …
Success: 200 | 204
Errors: 404, 409 (version conflict if If-Match)
Persistence: soft-delete? yes/no

### Pack verify (Gate Ship)
| E# | tests | HTTP | authZ negative | perf (E2) |
| E1 | | | | n/a |
| E2 | | | | N+1 checked |
| E3 | | | | n/a |
| E4 | | | | n/a |
```

Implement E# in dependency order if migrations needed: E1 schema → E2–E4 read/update same tables.
