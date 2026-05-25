# Evidence — copy into chat (priority order)

```
[debug evidence]
## Priority (fill highest available first)
1-runtime actual: …
2-network payload: …
3-persisted state: …
4-logs: …
5-screenshot/video: … (context only)
6-assumption (mark unverified): …

## API (priority 2)
| call | status | notes |
| GET /api/… | 200 | … |

### Response sample (redact secrets)
{ … }

## Client (paths)
| file | role |
| hooks/useOrders.ts | fetch + cache |
| components/OrderRow.tsx | displays total |

## User-provided
- [ ] HAR / curl
- [ ] Screenshot (not sufficient alone for root cause)
```
