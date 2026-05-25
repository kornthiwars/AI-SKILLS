# Root cause ledger — copy into chat (D4, before Gate D Approved)

```
[debug root-cause ledger]
Primary hypothesis (rank 1): …

| Evidence (tier 1–4) | Supports | Contradicts |
|---------------------|----------|-------------|
| e.g. GET /x body.total=100 | H1 backend wrong | H2 render only |
| e.g. runtime OrderRow shows 50 | H2 mapper | H1 backend |
| … | … | … |

Disproof run (top hypothesis): …
Result: survived | ruled out

Breadcrumb experiments: see [debug ledger] table
Rule: new hypothesis must not contradict Evidence rows without new facts.
```
