# reference — contract, verify, pitfalls, Gate Contract / Gate Ship

**Index:** Stack discovery · Stack appendices · Contract spec · Narrow scope · CRUD pack · Phase 1.5 DTO · Gate Contract · Implementation · Verify · Delta · Gate Ship · Cross-skill · Pitfalls · **Rationalizations · Red flags** · Troubleshooting

## Stack discovery (Phase 0)

Before Phase 1, scan the **user's project** (not this ai-skills repo). Record findings in the intake summary.

| Signal | Look for |
|--------|----------|
| Node/TS | `package.json`, `src/routes`, `app/api`, Nest modules, `prisma/schema.prisma` |
| .NET | `*.csproj`, `Controllers/`, minimal APIs, `Program.cs` |
| Go | `go.mod`, `internal/handler`, chi/gin/fiber patterns |
| Python | `pyproject.toml`, FastAPI routers, Django `urls.py` |
| Contract file | `openapi.yaml`, `swagger.json`, GraphQL `.graphql` |
| Tests | `*.test.ts`, `*_test.go`, `*Tests.cs`, integration folder |
| Errors | global exception handler, `{ code, message }` shape, Problem Details |
| Auth | JWT middleware, session, API keys, policy attributes |

**Rule:** new code follows the **same folder and naming** as the nearest existing endpoint. Do not introduce a second error JSON shape without documenting a migration.

## Stack appendices (load after Phase 0)

Follow **repo samples** for the detected stack (Node/TS, .NET, Go, Python). Record folder layout, error shape, auth middleware, and test patterns from the nearest existing endpoint. Other stacks: stay generic; cite repo samples only — no new gates.

## Contract spec (Phase 1)

Each endpoint gets an ID **E1, E2…** (or GraphQL operation name).

| Field | Required |
|-------|----------|
| E# | stable ID for gates and delta |
| Method + path | or GraphQL operation + type |
| AuthZ | role / scope / public |
| Request | query, path params, body fields + types + required |
| Success | status + body schema |
| Errors | per status: body fields + when triggered |
| Persistence | create/read/update/delete which entities |
| Idempotency | for POST that must not double-charge |
| Pagination | cursor/limit/offset if list |
| Breaking change | yes/no + version or deprecation note |
| Optional blocks | file upload, webhook, bulk, ETag — see [contract template](assets/template.contract-spec.md) |

Templates:

| Mode | Template |
|------|----------|
| Single endpoint | [assets/template.contract-spec.md](assets/template.contract-spec.md) |
| Resource CRUD E1–E4 | [assets/template.crud-pack.md](assets/template.crud-pack.md) |
| Fix one endpoint only | [assets/template.endpoint-delta.md](assets/template.endpoint-delta.md) |

**Revise** if vague types ("object"), missing auth, or undefined 4xx for validation failures.

## Narrow scope

| User says | Contract mode |
|-----------|---------------|
| "แก้ validation endpoint เดียว" | narrow delta — E1 only, change rows |
| "ทำ CRUD products" | CRUD pack E1–E4 |
| "POST order" | single E1 |

Do not add E2–E4 unless user lists them.

## CRUD pack

When user requests full resource API:

- Fill [assets/template.crud-pack.md](assets/template.crud-pack.md) (typical E1=POST, E2=GET list, E3=GET :id, E4=PATCH/DELETE).
- **Gate Contract:** one review for whole pack **or** per E# if user ships incrementally — state which in contract header.
- **Gate Ship:** verify **each E#** in pack table; 0 blockers on all in-scope E#.

## Phase 1.5 — DTO / schema map (after Contract Approved, before code)

Turn approved contract fields into implementable types:

1. List each E# → request DTO, response DTO, error shape keys.
2. Map field types to stack types (Zod, class-validator, FluentValidation, etc.).
3. Note shared types (e.g. `PaginationQuery`, `ErrorBody`).
4. One table:

```
| E# | request type | response type | validation layer |
| E1 | CreateOrderDto | OrderResponse | route middleware |
```

Values must trace to contract — no extra fields (#6 mass assignment).

## Gate Contract (Senior API Reviewer)

```
[Senior API Reviewer] Gate Contract — <feature name>
Mode: single | narrow-delta | crud-pack
Contract ref: <path or paste>
| E# | method/path | auth | request | response | errors | persistence |
| E1 | POST /api/orders | user | ✓ | ✓ | ✓ | Order |
Breaking change: no
Security notes: authZ on mutate · no PII in logs
Verdict: Approved | Revise
Blockers (if Revise):
| E# | issue | required fix |
```

**Stop:** no Phase 1.5–3 until **Approved**.

## Implementation (Phase 2)

Stack-agnostic layer order (adapt names to repo):

1. **Route / router** — register method + path (or schema resolver)
2. **Auth middleware** — enforce AuthZ from contract before handler logic
3. **Input validation** — DTO/schema at boundary; map to 4xx per contract
4. **Handler** — thin: parse → call service → map response
5. **Service** — business rules, transactions
6. **Persistence** — ORM/repository; migrations if contract says new tables/columns

| Rule | Detail |
|------|--------|
| Status codes | exact match contract (201 vs 200, 404 vs 400) |
| Error body | same keys as existing API (`code`, `message`, `details`) |
| Logging | no PII/secrets in info logs (#12) |
| Transactions | multi-step writes in one transaction when contract implies atomicity |
| Webhooks | verify signature header per contract (#17) |
| File upload | size/MIME limits in validation (#18) |

## Verify (Phase 3)

Pick methods that fit the repo; record which ran in Gate Ship.

| Method | When |
|--------|------|
| Unit tests | validation, service rules |
| Integration / API tests | full request/response against test DB |
| HTTP manual | `curl`, REST Client, Bruno — when tests missing |
| OpenAPI diff | if spec file is source of truth — **sync or list delta in deliver** |
| GraphQL schema check | introspection or codegen diff for mutations |
| Migration check | `migrate` dry-run or ORM diff for new schema |
| Auth negative | 401 no token, 403 wrong role — required for mutating E# |
| List performance | spot-check N+1 (#1, #13) on GET list E# |

**Blocker examples:** test expects 422 but API returns 400; response missing field; N+1 on list; OpenAPI drift undocumented.

## Delta table (before Gate Ship)

```
| E# | check | expected (contract) | actual | severity |
| E1 | status invalid email | 422 | 400 | blocker |
```

**0 blockers** required for Confirmed.

## Gate Ship (Senior API Reviewer)

```
[Senior API Reviewer] Gate Ship — <feature name>
Verify: <test cmd> + <HTTP tool>
| E# | tests | HTTP | schema | authZ | perf |
| E1 | 5/5 | 201 sample | ✓ | user-only ✓ | list N+1 OK |
OpenAPI synced: yes | no — delta listed
Delta blockers: none
Verdict: Confirmed | Not confirmed
```

| Column | Meaning |
|--------|---------|
| authZ | 401/403 cases run for mutating routes |
| perf | list endpoints: no obvious N+1 (#1) |

## Cross-skill

| Need | Skill |
|------|-------|
| FE forms / display new API fields | `@ui-builder` + [fe-handoff](assets/template.handoff-to-ui.md) |
| API JSON correct, UI still wrong | `@debug` |
| Install skills / mirrors | `@upgrade` |
| Full login FE+BE one request | `@feature-builder` — **order:** api-builder Ship → handoff → ui-builder |

## Pitfalls #1–20

| # | Symptom | Fix |
|---|---------|-----|
| 1 | List endpoint slow | eager load / join; pagination |
| 2 | 404 vs 400 confused | 404 missing resource; 400 malformed input |
| 3 | Validation only in FE | duplicate at server boundary |
| 4 | Leaked stack trace | map to contract error body in prod |
| 5 | Wrong 201 body | include `Location` or id per convention |
| 6 | Mass assignment | allow-list fields on write DTO |
| 7 | Missing authZ check | policy on every mutating route |
| 8 | Inconsistent error shape | reuse global handler |
| 9 | Double POST | idempotency key or unique constraint |
| 10 | Migration without rollback note | document down migration or backup |
| 11 | Breaking rename without version | `/v2` or deprecation header |
| 12 | PII in logs | redact email, token, password |
| 13 | N+1 in nested JSON | batch load or select related |
| 14 | Timezone bugs on dates | UTC storage + ISO8601 in JSON |
| 15 | Early done | 0 blockers before Ship |
| 16 | Rate limit missing | throttle sensitive POST/login per repo pattern |
| 17 | Webhook forged | HMAC/signature header + replay window |
| 18 | Upload bomb | max size, MIME allow-list, virus scan if required |
| 19 | Stale OpenAPI | update spec or document waiver in Ship |
| 20 | Optimistic lock ignored | If-Match / version column on PATCH conflict → 409 |

## Troubleshooting

| Issue | Action |
|-------|--------|
| User gave only "fix API" | ask operation + failing request/response sample |
| Repo has no tests | HTTP verify + propose minimal test in deliver |
| OpenAPI out of date | contract lists delta; task to sync in deliver |
| GraphQL + REST mixed | one contract section per surface |
| feature-builder invoked | refuse merged gates; split api then ui |

## Common rationalizations (agent discipline)

| Rationalization | Reality |
|-----------------|---------|
| "แก้ validation ใน component เร็วกว่า" | Validation อยู่ boundary ตาม contract — ไม่ซ้ำใน handler |
| "Ship ได้แล้ว แค่ endpoint เล็ก" | Gate Ship = Confirmed ต้องมี verify evidence + 0 blockers |
| "ข้าม Contract ไป implement ก่อน" | ห้าม Phase 2 จน Gate Contract = Approved |
| "UI map ผิด — แก้ใน api-builder" | Response ถูกแล้ว → `@debug`; FE → handoff `@ui-builder` |
| "breaking change เล็ก ไม่ต้องบอก" | ต้อง version/migration ใน contract |

## Red flags

- Code routes/handlers ก่อน Contract Approved
- Gate Ship โดยไม่มี delta table 0 blockers
- Secret ใน sample/log ใน deliver
- New endpoint ไม่มี auth บน server
- OpenAPI/public API เปลี่ยนแต่ไม่ note ใน deliver

## Self-upgrade

After delivery, add **one row** to Pitfalls or Stack discovery if needed — do not bloat SKILL.md.
