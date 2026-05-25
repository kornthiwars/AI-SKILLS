# Action flow — F1 (copy into chat)

```
[flow-builder F1]
Scope: <trigger> on <screen>
Action flow — <short title>

## Trigger
| Field | Value |
| Trigger | <button / link / submit / route enter> |
| Screen | <page / modal / component> |
| Preconditions | <logged in, form valid, …> |

## Steps (happy path)
| # | Actor | Action | System response | Notes |
| 1 | User | … | … | |
| 2 | Client | … | … | validate / loading |
| 3 | API | … | … | method path |
| 4 | UI | … | … | toast / redirect / close modal |

## Mermaid (sequence)
```mermaid
sequenceDiagram
  participant U as User
  participant UI as Client
  participant API as Server
  U->>UI: click <trigger>
  UI->>API: <METHOD> <path>
  API-->>UI: <status>
  UI-->>U: <visible outcome>
```

## Open questions
| # | question | default assumption |
| 1 | … | … |
```
