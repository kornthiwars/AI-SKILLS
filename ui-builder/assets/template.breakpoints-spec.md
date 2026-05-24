# breakpoints-spec-template — multi-breakpoint (Phase 1)

Use when user requests **more than one width**. One file; **Gate A/B per breakpoint** (B0, B1, …).

**Task ID:** ___ · **Theme:** light / dark · **Direction:** ltr / rtl · **Ref:** file / URL / fixture per B#  
**Scope:** full page / component (S#: ___)

| B# | Viewport | Primary? | Ref | Gate A | Gate B |
|----|----------|----------|-----|--------|--------|
| B0 | ___×___ | yes | | pending | pending |
| B1 | ___×___ | | | pending | pending |
| B2 | ___×___ | | | pending | pending |

## Shared (all B#)
- Font family / stack: ___
- Brand colors used everywhere: `#______` …
- Components that must match across widths (header, nav): note IDs

## B0 — ___×___
Copy [template.viewport-spec.md](template.viewport-spec.md) sections below for this width only.

### S0 canvas
- bg · font · direction

### S1 …
- (per-zone spec)

## B1 — ___×___
(repeat)

## Cross-breakpoint rules
- What may change between B#: layout reflow / hide / stack only if reference shows it at that width
- What must stay identical: brand colors, icon set, copy (unless reference differs per B#)
- Do **not** invent breakpoints between listed B# widths

## Deviations
- ___
