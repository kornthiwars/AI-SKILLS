# Data lineage — F2 (copy into chat)

```
[flow-builder F2]
Scope: <trigger> on <screen>
Data lineage

## Fields in scope
| UI label / control | Shown value comes from | Evidence |
| <label> | GET <path> → `json.path` | repo \| user \| assumed |
| <label> | local state `<name>` | … |
| <label> | props / parent | … |
| <label> | cache key `<queryKey>` | … |

## Load timing
| Field | Initial load | After trigger |
| … | on mount / on open | refetch / optimistic / parent push |

## Open questions
| # | question |
| 1 | … |
```
