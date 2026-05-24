# Feature spec — F0 (copy into chat)

```
[feature-builder F0]
Feature: <name>
User story: <As a … I want … so that …>
Target repo: <path or workspace name>
Stack (detected): <e.g. Next.js + Prisma, .NET 8>

## Success criteria
- [ ] …
- [ ] …

## API scope (rough)
| E# | intent | notes |
| E1 | POST login | returns token |
| E2 | GET me | Bearer |

## UI scope
| S# | surface | viewport | visual ref |
| S1 | Login form | 390×844 | login.png |

## Auth / session
<JWT in header | httpOnly cookie | …>

## Out of scope
- …

## UI phase status
[ ] ref ready  →  UI phase allowed after API Ship
[ ] ref missing →  UI blocked until user supplies ref
```
