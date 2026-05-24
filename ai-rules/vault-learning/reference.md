# Vault layout

> Rules: [vault-learning.mdc](../vault-learning.mdc)

## โครงสร้าง

```
templates/                   repo root — template.issue.md, template.learning.md
vault/
├── issues/YYYY-MM-DD.md     tags: [issues, …topics]
└── learnings/YYYY-MM-DD-HHmm.md   tags: [learning] + title: (graph label via plugin)
```

**No hub file** — graph groups by type + topic tags (`#issues`, `#learning`, `#vault`, …).

## Flow

```
work Q&A        → issues/YYYY-MM-DD.md (append, tags [issues, …topics])
off-topic       → skip
problem ≥3 rnds → learnings/ (tags [learning])
```

## Obsidian graph

- Config: `vault/.obsidian/graph.json`
- **Display → Tags: ON** (optional)
- **Groups (2 only):** `path:issues` (coral) · `path:learnings` (gold) — file color by folder
- **Topic tags** in notes: `vault`, `git`, `research`, `ui`, `api`, `infrastructure`, `debug` (see rule table)
- **Filter:** `-path:templates -file:README`
- **Orphans:** ON — note ไม่ต้อง wikilink กัน
- No hub file · no wikilink footers

## Agent search (token-efficient)

Many learning files → **Grep narrow, read few**.

1. Grep `vault/learnings/` — symptom, error, `skill:`, `symptoms:`, `files:` (from frontmatter)
2. `head_limit` ~15 matches
3. Read **≤3** best-matching notes
4. Optional: same-day `vault/issues/YYYY-MM-DD.md` if still unclear

No hub/index file — optional `symptoms` / `files` arrays in [template.learning.md](../../templates/template.learning.md) replace a central catalog.

## Git

Notes local · `templates/` + vault README + `.obsidian` in git
