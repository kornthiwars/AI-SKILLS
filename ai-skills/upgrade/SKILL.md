---
name: upgrade
description: >-
  Maintains and upgrades other skills in this repo — audit outdated or wrong content,
  fix to match SKILL-AUTHORING and gold skills (ui-builder, api-builder), bump
  semver. Triggers on /upgrade, @upgrade, skill upgrade,
  อัปเกรด skill, อัพเกรด skill, แก้ skill, skill ล่าสมัย, skill ผิด, ข้อดีข้อเสีย, ลด token, ประหยัด token.
  Does not apply to building app UI (ui-builder), API contracts (api-builder),
  or git push (git-push). Install-only mirror checks: mention briefly after fix.
compatibility: Cursor and Claude Code; edits under ai-skills/ only; no app UI/API implementation
disable-model-invocation: true
metadata:
  version: "1.1.2"
  author: kornthiwars
  license: MIT
  surfaces:
    - ide
---

# Skill upgrade

**Job:** Improve **other skills** in this repo that are outdated, wrong, or below standard — align with [SKILL-AUTHORING.md](../SKILL-AUTHORING.md) and gold skills (`ui-builder`, `api-builder`).

**Not:** mirror/global checks as primary work (brief only after canonical fix) · no UI/API work in child app repos.

Full audit checklist: [reference.md](reference.md)

## Operating stance

- **Canonical only** — edit under `ai-skills/<name>/` only
- **Standard is law** — [SKILL-AUTHORING.md](../SKILL-AUTHORING.md) + [reference.md](reference.md) + nearest gold skill
- **Propose before edit** — findings + plan + **pros/cons** + semver, then ask scope before touching files
- **Trade-offs required** — every upgrade plan states benefits and risks (no rubber-stamp “always better”)
- **Implement after OK** — after user confirms, change the repo (not “no upgrade needed” reports only)
- **Learnings separate** — incidents from other app repos → `vault/learnings/` there (not stuffed into canonical); this repo uses root `vault/`
- **Token-aware** — check [SKILL-AUTHORING.md](../SKILL-AUTHORING.md) § Token efficiency; move detail to `reference.md` instead of growing `SKILL.md`

## Required inputs

| Situation | Must have |
|-----------|-----------|
| In **this repo** | Clear path — use current workspace |
| Outside repo | Path to `ai-skills/` or ask first |
| Named skill | `@upgrade git-push` → focus that skill |
| Unnamed | Scan all skills in `ai-skills/` (skip `deprecated` / `in-progress` / `personal`) → table by severity or ask which first |

## Hard rules

- Do not delete `ai-skills/` canonical without explicit user request
- Do not start **ui-builder** UI work or **api-builder** API implementation in target apps
- Do not cite removed `skill-upgrade.ps1` / `scripts/upgrade-skill.ps1`
- **No git commands** — no `git status` / `add` / `commit` / `push` / `pull` / `rebase`; ship in **this repo** → `@git-push` · ship **app repo** after implement → `@pr-review` then `@git-push`
- Do not merge project learnings into canonical without user approval per row

## Workflow — upgrade another skill

Run in order. Pros/cons templates and severity examples: [reference.md](reference.md).

### 1 — Pick target

- Read `ai-skills/**/SKILL.md` → table `# | name | version | path`
- If many skills and user did not name one: sort findings by severity or ask where to start

### 2 — Load standard

1. [SKILL-AUTHORING.md](../SKILL-AUTHORING.md)
2. [reference.md](reference.md) — audit checklist · § Repo doc hygiene (when `scripts/` changed)
3. **Gold skill** by complexity:
   - Heavy gates / deliverables → `ui-builder` or `api-builder`
   - Short skills (pr-review, git-push, upgrade) → frontmatter + Language + Hard rules + clear workflow

### 3 — Audit target

Read every file in `ai-skills/<name>/` plus repo-wide cross-ref search (old names, paths, wrong `@invoke`).

Record findings:

| Severity | Meaning |
|----------|---------|
| **blocker** | Wrong context, conflicting steps, broken invoke/path |
| **major** | Missing Required inputs / Hard rules / WHEN NOT; incomplete workflow |
| **minor** | typo, stale headings, README version drift, FILES.md mismatch |

### 4 — Plan + semver

| Bump | When |
|------|------|
| PATCH | Wording, cross-ref, README version; no step change |
| MINOR | New section, checklist, template, backward-compatible workflow |
| MAJOR | Gate / invoke change; removed step users rely on |

Propose: files to edit · brief headings · new version.

**Pros / cons (required before user OK)** — [reference.md](reference.md) § Pros and cons:

| Topic | Content |
|-------|---------|
| **Benefits** | What improves (standard, fewer wrong invokes, ship flow, shorter tokens, etc.) |
| **Risks** | Longer SKILL, slower agent, MAJOR breakage, extra steps (e.g. pr-review), mirror sync |
| **If unchanged** | What risk remains |
| **Alternatives** | PATCH only vs MINOR workflow vs defer scope |

Multi-skill plans: repo-level pros/cons + **short per-skill** bump notes.

**Ask user:** confirm scope (all / blocker+major only / single item / **skip** with reason from risks).

### 5 — Implement (after OK)

- Edit `ai-skills/<name>/` and repo version tables (`README.md`, `AI-NOTES.md`, `.claude-plugin/plugin.json` if present)
- If scope includes **setup / vault path** changes: sync repo docs per [reference.md](reference.md) § Repo doc hygiene (same PR as skill edits when possible)
- Do not exceed confirmed scope
- Keep `disable-model-invocation: true` and **70% Thai / 30% English** in chat replies; **English** `SKILL.md` body per AUTHORING

### 6 — Verify

- Cross-ref in edited skills — no broken links
- Frontmatter, Required inputs, Hard rules, workflow complete
- `metadata.version` matches README / repo tables if any

### 7 — Report

Deliver:

1. What changed (short before/after)
2. New version(s)
3. **Actual benefits** vs **accepted risks** (vs plan §4 — note surprises)
4. Deferred items (if any) + reason / trade-off
5. Next: `@pr-review` (app ship) then `@git-push` for commit in this repo when user asks

### Install note (secondary)

After canonical fix, if user consumes skills from another project: briefly suggest copy/link to `.cursor/skills/<name>/` — do not end with “mirror OK” without fixing skill content.

## Output flow

```
Pick → Audit (table) → Plan + pros/cons + semver → [user OK] → Edit canonical → Verify → Report (actual pros/cons)
```

## Resources

| Resource | Use |
|----------|-----|
| [SKILL-AUTHORING.md](../SKILL-AUTHORING.md) | Repo standard |
| [reference.md](reference.md) | Audit checklist · § Rationalizations / Red flags |
| [ui-builder/SKILL.md](../ui-builder/SKILL.md) | Gates + required inputs example |
| [api-builder/SKILL.md](../api-builder/SKILL.md) | Workflow + self-upgrade example |

## Language

- **70% Thai / 30% English** in chat — audit findings, plan, pros/cons, questions in Thai; ~30% English for canonical, semver, blocker/major/minor, trade-off, gate names
- **Natural mix** — e.g. "finding **major** — missing WHEN NOT; bump **semver** PATCH"
- **Gloss once per reply** — `canonical (แหล่งจริง)`, `semver (MAJOR.MINOR.PATCH)`, `trade-off (แลกเปลี่ยน)`
- **Do not translate** — paths, PowerShell blocks

Canonical: `ai-skills/upgrade/`
