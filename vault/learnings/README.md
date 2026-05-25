# learnings

Lessons after **problem-solving** — one file per lesson.

## File pattern

```
YYYY-MM-DD-HHmm.md
```

Example: `2026-05-23-1545.md`

| Field | Purpose |
|-------|---------|
| Filename | Sortable id (date + time) |
| `title:` + `# H1` | **Display name** (graph / tabs with plugin) |

## Graph — show title not filename

Obsidian **core graph** uses filename (`2026-05-23-1545`) by default.

This vault ships **Property Over File Name** under `.obsidian/plugins/` (enabled in `community-plugins.json`). It reads frontmatter `title:` in graph, file explorer, and tabs.

If labels still show filenames:

1. **Settings → Community plugins** → turn **Restricted mode** off if prompted, then enable **Property Over File Name**
2. Plugin settings → **In graph view** on, property key `title`
3. Reload vault (close/reopen Obsidian or **Reload app without saving**)

## Tags

`tags: [learning, vault]` — ตัวที่สอง = `skill:` (เช่น `vault`, `debug`, `git`)

## Search (agent)

Grep with `symptoms:` / `files:` frontmatter + tags — read **≤3** files max. Rule: [ai-rules/vault-learning.mdc](../../ai-rules/vault-learning.mdc) § Search learnings.

Topic tags เดียวกับ issues: `vault`, `git`, `research`, `ui`, `api`, `infrastructure`, `debug`

## When agent writes

≥2 prompt rounds · problem solved · `tags: [learning, <skill>]`

## Template

`templates/template.learning.md`

## Git

README tracked · learning files local only
