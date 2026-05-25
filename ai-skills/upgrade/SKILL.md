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
  version: "1.1.5"
  author: kornthiwars
  license: MIT
  surfaces:
    - ide
---

# Skill upgrade

**Job:** Improve **other skills** in this repo that are outdated, wrong, or below standard — align with [SKILL-AUTHORING.md](../SKILL-AUTHORING.md) and gold skills (`ui-builder`, `api-builder`).

**Not:** mirror/global checks as primary work (brief only after canonical fix) · no UI/API work in child app repos.

Details: [reference.md](reference.md)

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

## Quick reference

| Step | Load | Action |
|------|------|--------|
| 1 | [reference.md](reference.md) § Workflow §1 | pick target · version table |
| 2 | § Workflow §2 · gold skills | load standard |
| 3 | § Workflow §3 · § Per-skill checklist · § Repo-wide stale patterns | audit |
| 4 | § Workflow §4 · § Pros and cons | plan + semver · **user OK** |
| 5 | § Workflow §5 · § Repo doc hygiene (if setup) | implement |
| 6 | § Workflow §6 | verify cross-ref + versions |
| 7 | § Workflow §7 · § Install note | report · mirror hint |

## Workflow

Run Quick ref in order. Steps 1–7 detail: [reference.md](reference.md) § Workflow — upgrade another skill. **Do not edit** until step 4 scope confirmed.

## Output flow

```
Pick → Audit (table) → Plan + pros/cons + semver → [user OK] → Edit canonical → Verify → Report (actual pros/cons)
```

## Resources

| Resource | Use |
|----------|-----|
| [SKILL-AUTHORING.md](../SKILL-AUTHORING.md) | Repo standard |
| [reference.md](reference.md) | Workflow · audit checklist · pros/cons · rationalizations |
| [ui-builder/SKILL.md](../ui-builder/SKILL.md) | Gates + required inputs example |
| [api-builder/SKILL.md](../api-builder/SKILL.md) | Workflow + self-upgrade example |

## Language

[SKILL-AUTHORING.md](../SKILL-AUTHORING.md) § Language. **Gloss:** `canonical (แหล่งจริง)`, `semver (MAJOR.MINOR.PATCH)`, `trade-off (แลกเปลี่ยน)` · EN: blocker/major/minor.

Canonical: `ai-skills/upgrade/`
