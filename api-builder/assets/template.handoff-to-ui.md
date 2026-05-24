# FE handoff — paste after Gate Ship (for @ui-builder)

```
[api-builder → ui-builder handoff]
Feature: <name>
API Ship: Confirmed (date/session)

## Endpoints (in scope for UI)
| E# | method | path | auth | when to call |
| E1 | POST | /api/orders | Bearer user | checkout submit |

## Success samples
### E1 201
{ "id": "uuid", "status": "pending" }

## Errors (show in UI)
| status | code | user-facing hint (TH) |
| 422 | validation_error | ตรวจสอบฟิลด์ที่ไฮไลต์ |
| 401 | unauthorized | กรุณาเข้าสู่ระบบ |

## Fields FE must bind
| UI label | JSON path | type |
| Order id | id | uuid |
| Status | status | string enum pending|… |

## Out of scope for ui-builder
- server implementation
- OpenAPI file edits

## Suggested ui-builder prompt
@ui-builder
Scope: <page/component> only · Viewport <W×H> · Ref: <screenshot>
Wire POST /api/orders — แสดง error 422 ตาม details[] · success แสดง status
```

Do not implement UI in api-builder — only fill and paste this block.
