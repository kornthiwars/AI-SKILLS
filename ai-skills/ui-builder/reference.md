# reference — spec, verify, pitfalls, Gate A/B forms

**Index:** Spec · Scope · Motion · RTL · Figma · Measure · Live URL · Fixtures · Phase 2 tokens · **Quality tier 10** · Pitfalls · A11y · Verify · Visual compare · Preview · Delta · A/B · Self-upgrade · Multi-breakpoint · **Rationalizations · Red flags** · Troubleshooting

## Spec (per section ID)

Layout · Type (font/px/weight/lh/`#hex`) · Surface · Media · optional placeholder/focus if in reference

Canvas: viewport W×H, bg, gutters. **Revise** if named colors or missing zone. Template: [assets/template.viewport-spec.md](assets/template.viewport-spec.md)

States in spec when reference shows them: default · hover · focus · disabled · active (px/`#hex` each — no "slightly darker").

## Scope

| Scope | Spec map | Rule |
|-------|----------|------|
| Full page | S0 canvas + S1… | Default |
| Single component | One S# (e.g. S1 card) | Spec lists only that subtree; build must not add chrome outside reference crop |
| Partial zone | Named S# only | Other zones out of scope unless user adds them |

**Overflow:** long copy in reference → note `truncate` / `line-clamp` / `min-w` / `max-w` in spec per S#.

**Direction:** `ltr` (default) or `rtl` — set on canvas S0 when reference is RTL ([§ RTL](#rtl--direction)).

## Motion

When reference shows animation or moving UI:

| In spec (per S#) | Rule |
|------------------|------|
| Static reference | No animation in build unless user asks |
| Visible motion | `duration` ms · `easing` name · property (opacity, transform, …) |
| Loop / skeleton | note cycle ms; respect `prefers-reduced-motion` (#21) |
| Loading spinner | size px · stroke `#hex` · speed ms/rotation |

Gate A: motion either fully specified or explicitly **static**. Gate B: compare **end state** at locked width; note if motion was omitted vs reference.

## RTL / direction

| Item | LTR | RTL |
|------|-----|-----|
| Canvas S0 | `direction: ltr` | `direction: rtl` |
| Alignment | physical left/right as in reference | mirror horizontal placement vs reference |
| Icons with direction | as drawn | flip only if reference flips (chevrons, back arrows) |
| Numbers / phone / URL | LTR digits often stay LTR | spec per field |

**Required:** user confirms **rtl** (or reference is clearly RTL). Do not assume RTL from language alone.

**Default:** one viewport + one direction per task. **Multi-breakpoint:** see [§ Multi-breakpoint](#multi-breakpoint). LTR+RTL at same width = two tasks (or two B# rows with same W×H).

## Figma

- Export frame **1× PNG** at target width, or Dev Mode → copy px/hex into spec  
- Figma link alone → ask export; do not guess from thumbnail

## Measure

`@2x` halve · blur → re-export · gradient stops+deg · shadow layers · pad ≠ margin ≠ gap

## Live URL

1. `browser_navigate` to URL (MCP below)  
2. Lock viewport width + note theme (light/dark)  
3. `browser_snapshot` or screenshot → section map S0…  
4. Exclude promo overlays unless user requested (#17)

## Phase 2 — Tokens (after Gate A, before code)

Stack-agnostic: turn the **approved spec** into a token table the build must use. Do not invent values not in spec.

1. Collect unique **colors** (`#hex`), **spacing** (px), **radii** (px), **type** (family/size/weight/lh), **shadows** (layer list) from all S#.
2. Name tokens for traceability (e.g. `color-primary`, `space-12`, `radius-6`) — names are internal; values stay spec px/`#hex`.
3. Map each S# zone → token keys used in that zone (one line per S#).
4. **Webfonts:** if reference uses a non-system face, note family + weights loaded; fallback stack if load fails (#4).
5. **Icons:** note SVG path / export file / icon set + size + stroke per S# (#9); no substitute glyph without documenting deviation.
6. **Motion:** if spec includes animation — tokenize duration/easing per S#; static build = no motion tokens.

```
| token | value | used in |
| color-primary | #1877F2 | S2 border, S3 bg |
| space-12 | 12px gap | S2 stack |
```

Implement with whatever the target project uses (plain CSS, variables, utility classes, components) — **values** must match this table.

## Quality tier 10 (default)

Load [assets/checklist.quality-tier.md](assets/checklist.quality-tier.md) at intake. **Deliverable default = tier 10.**

| Phase | Extra rule |
|-------|------------|
| Gate A | Font + icon + imagery rows filled; waivers need user OK |
| Verify | Browser screenshot @ locked W×H; side-by-side ref |
| Gate B | Post `Score: __/10`; **10/10** only if tier-10 checklist complete |

Downgrade to tier 8 only when user explicitly opts out of pixel-perfect.

## Icons (buttons & toolbars)

Icon-only controls must center the glyph in the hit box (Gate B: layout **L**).

| Spec field | Rule |
|------------|------|
| Hit box | w×h in px (e.g. 32×32, 24×24) |
| Icon size | 18–24px inside box; stroke/bbox per reference (#9) |
| Alignment | `display: inline-flex; align-items: center; justify-content: center` |
| Padding | `padding: 0` on icon buttons — no asymmetric pad |
| Line-height | `line-height: 0` or 1 on button; icon `display: block` |
| Font icon | Material Symbols / SVG — avoid emoji in buttons (baseline drift) |

**Verify:** screenshot or computed — icon bbox centered ±1px in button box.

## Pitfalls #1–32

| # | Symptom | Fix |
|---|---------|-----|
| 1 | Column shrinks | flex-shrink 0 / fixed w |
| 2 | Box drift | border-box on scope |
| 3 | Text height | lh in px |
| 4 | Weight | match spec + font file |
| 5 | Color | exact #hex |
| 6 | Hairline | 1px at DPR |
| 7 | Flat shadow | multi box-shadow |
| 8 | Image squash | aspect-ratio / w×h |
| 9 | Icon wrong size/stroke | stroke + bbox per spec |
| 10 | Early done | 0 blockers before B |
| 11 | Scale | body width = viewport px |
| 12 | Named CSS colors | #hex only |
| 13 | Field layout | column + gap |
| 14 | Margin collapse | flex gap over margin |
| 15 | Placeholder | from spec |
| 16 | Wrong theme | match capture |
| 17 | Promo overlays | omit; document |
| 18 | Modal under header | z-index / stacking context per S# |
| 19 | Scrollbar shifts layout | `scrollbar-gutter` or pad for gutter |
| 20 | Notch / safe-area | `env(safe-area-inset-*)` on fixed footers/headers |
| 21 | Motion without reduced | `@media (prefers-reduced-motion: reduce)` + static fallback |
| 22 | RTL mirrored wrong | `direction: rtl` on scope; mirror padding/icons per reference |
| 23 | Icon off-center in button | flex center on hit box; fixed icon 20–24px; no emoji/line-height drift |
| 24 | User reports wrong total/label/list | Confirm expected vs actual; if data/logic mismatch → `@debug` (not pixel Gate B) |
| 25 | Multi-pane shell: composer/header "floats" off column | Root: `position:fixed` on viewport or footer outside flex pane. Fix: each pane `display:flex; flex-direction:column; min-height:0`; scroll `flex:1; overflow-y:auto`; composer `flex-shrink:0` **inside** main pane |
| 26 | Emoji/text stand in for toolbar icons | Match ref: SVG/icon font size 20–24px, stroke, hit box — no 🔍👥⚙ unless reference uses emoji |
| 27 | Gate B on cropped zone only | Composite apps: screenshot **full viewport** S0…Sn together at locked W×H before Confirmed |
| 28 | Claimed 10/10 with placeholders | Ref shows photos/avatars → use assets or Gate A waiver + user OK; else max **9/10** |
| 29 | Substitute font undocumented | Brand font in ref → load closest webfont in spec; else **blocker** at tier 10 |
| 30 | CSS audit only at tier 10 | Tier 10 requires MCP/browser screenshot — audit is fallback for tier ≤8 |
| 31 | "Close enough" delivery | If visible mismatch at locked width → **Not confirmed** regardless of function |
| 32 | Score 10 without checklist | Must paste tier-10 rows from [checklist.quality-tier.md](assets/checklist.quality-tier.md) in Gate B |

## Multi-pane shells (Discord, Slack, IDE)

At Gate A, map **each pane** as its own S# with width px + bg `#hex`. At Gate B:

1. Verify **all panes** in one screenshot at locked viewport (#27).
2. Apply #25 to chat/main pane before signing B.
3. Data wiring from `@feature-builder` fe-handoff is `@debug` if wrong values — stay in pixel gates here.

## A11y (verify at Gate B)

Minimum when reference implies interactive UI:

| Check | Rule |
|-------|------|
| Labels | Every input has visible or `aria-label` text matching reference |
| Focus | Focus ring visible if reference shows focus state |
| Icons alone | Decorative → `aria-hidden`; actionable → `aria-label` |
| Contrast | Text on bg: note if borderline; blocker only if illegible vs reference intent |
| Touch | Mobile width: hit area ≥ spec box (do not shrink below spec h/w) |
| Motion | Respect `prefers-reduced-motion` (#21); end state matches reference |
| RTL | `dir` on root; logical padding matches reference at locked width |

Do not add a11y chrome not in reference (extra skip links, etc.) unless user asked.

## Verify

### Browser MCP — `cursor-ide-browser` (preferred)

**Preview build**

1. Start preview: `npm run dev` or `npx --yes serve <dir> -p 8765`  
2. `browser_tabs` `action: list` — reuse tab if already on preview URL  
3. `browser_navigate` → `http://localhost:8765/...` (never `file://`)  
4. `browser_lock` `action: lock`  
5. Set viewport to spec width (`browser_cdp` / DevTools layout)  
6. `browser_take_screenshot` — label **build**  
7. Compare to reference image side by side → delta table → fix blockers → repeat  
8. `browser_lock` `action: unlock` when done  

**Live URL intake (Phase 0)**

1. `browser_navigate` → target URL  
2. `browser_lock` → set viewport → `browser_snapshot` for structure / labels  
3. Screenshot for theme + visual spec → unlock  

Optional: `browser_snapshot` on build page to cross-check text nodes vs spec.

### CSS audit (fallback)

Per section ID: spec ↔ computed (display, flex, gap, pad, margin, font-*, color, bg, radius, box-shadow). Gate B: `verify: CSS audit`

### User screenshot

If no serve/MCP: ask user for build screenshot at locked width.

## Visual compare

Before Gate B, compare **reference** vs **build** at locked width:

1. **Align structure** — same section order S0…; header/footer baselines line up first.
2. **Side-by-side** — reference image left, build screenshot right (chat or notes); label viewport + theme.
3. **Zone pass** — one S# at a time: layout → type → color → media; log deltas in table.
4. **Overlay mental model** — if sizes match, check edges (full-bleed bg, 1px borders, sticky overlap #18).
5. **CSS audit** when screenshot unavailable — per S#, spec ↔ computed; cite property names in delta.

Blocker = visible mismatch or wrong `#hex`/px vs spec. Minor ≤2px only if waived in B. At **tier 10**, undocumented placeholder/font/asset = **blocker** (#28–29).

## Preview

`npm run dev` if exists · else `npx --yes serve <dir> -p 8765`

## Delta

| Sec | El | Ref | Built | Sev | Fix |

blocker = wrong vs spec/visible · minor ≤2px (waive at B)

## A — Spec sign-off

```
Ref: ___ | Viewport: ___×___ | Direction: ltr / rtl | Map: S1…
[ ] zones [ ] hex/px [ ] roles [ ] icons [ ] @2x [ ] theme [ ] promos excluded
[ ] motion: static / specified | [ ] rtl alignment checked
Verdict: Approved / Revise | Blockers: | # | sec | fix |
```

## B — Build sign-off

Use [assets/template.gate-b.md](assets/template.gate-b.md). Minimum:

```
Viewport: ___ | Tier target: 10 (default) | Verify: screenshot @ W×H | MCP: yes
| ID | L | T | C | S | M | E | a11y | ✓ |
Tier 10: [ ] side-by-side [ ] full shell [ ] no emoji chrome [ ] font [ ] assets
Score: __/10 | Tier-10 waivers: none / table
Verdict: Confirmed / Not confirmed
```

Designer: **Confirmed** at tier 10 only when `Score: 10/10`, 0 blockers, tier-10 checklist complete. No code in this role.

## Self-upgrade (after deliver)

If the same mistake repeats across tasks, add **one** row to Pitfalls or one bullet under Verify/Troubleshooting — do not bloat SKILL.md.

Example (sticky header under modal):

```
| 18 | Modal under header | z-index / stacking context per S# |
```

## Multi-breakpoint

When the user names **two or more widths** (e.g. 390 + 768 + 1440), or provides refs per width:

### Mode selection

| Mode | When | Spec file | Gates |
|------|------|-----------|-------|
| **Single** (default) | One width only | [template.viewport-spec.md](assets/template.viewport-spec.md) | One A → one B |
| **Multi** | User lists ≥2 widths with refs | [template.breakpoints-spec.md](assets/template.breakpoints-spec.md) | **Per B#:** A then build then B |

### Multi-breakpoint rules

1. **User must name every width** (W×H) and supply a ref per B# (image, URL, or fixture). Do not invent B# between listed widths.
2. Mark **B0 = primary** (implement first unless user orders otherwise).
3. **Phase 1:** fill breakpoints template — shared tokens + per-B# section map (S0… per width).
4. **Gate A:** per B# — Approved on B0 before coding B0; repeat for B1, B2… (or user approves all specs in one message with explicit B# list).
5. **Phase 2 tokens:** one shared table + per-B# overrides only where spec differs.
6. **Phase 3–4:** build and verify **one B# at a time**; do not mix screenshots across widths in one delta.
7. **Gate B:** per B# — 0 blockers at that width before marking B# Confirmed.
8. **Deliver:** summary table of all B# with A/B status and deviations.

### Single mockup only

If user has **one** image and asks for “responsive” without other refs:

1. **Revise** — ask for refs per target width, or confirm **single-width only** (default).
2. Do not infer tablet/desktop layout from one mobile mockup.

### Production CSS note

Multi-breakpoint in this skill = **multiple locked QA viewports**, not one fluid responsive pass. Production media queries are out of scope unless user adds a separate task.

## Voice

| Role | Do | Don't |
|------|-----|-------|
| Implementer | spec, code, verify, fix | Skip gates; "done" with blockers |
| Senior Designer | A/B vs reference | Write or edit code |

## Operating rules

- **No rubber-stamp gates** — cite section IDs and evidence in A/B.
- **Cite or it didn't happen** — delta rows reference S# and property.
- **Distinguish spec claim vs build** — "spec says #1877F2" vs "computed/#hex on element."
- **No flattery** — Confirmed only with 0 blockers; **10/10** only when tier-10 checklist is complete.

## Common rationalizations (agent discipline)

| Rationalization | Reality |
|-----------------|---------|
| "โครงใกล้พอแล้ว แก้สีทีหลัง" | Gate A ต้อง **Approved** ก่อน code — สี/px อยู่ใน spec |
| "CSS audit แทน screenshot ก็ได้ 10/10" | Tier 10 ต้อง screenshot @ locked W×H — pitfall #30 |
| "รูปมีแต่ยอดรวมผิด — ปรับ layout ใน ui-builder" | ตัวเลข/logic ผิด → `@debug` ก่อน (pitfall #24) |
| "responsive จาก mockup เดียวได้" | **Revise** — ต้องมี ref ต่อ B# หรือ single-width only |
| "ไม่ต้อง Gate B แค่ deploy" | ห้าม deliver จน B = Confirmed + 0 blockers |

## Red flags

- เขียน `*.tsx` / `*.css` ก่อน Gate A = Approved
- โพสต์ `Score: 10/10` โดยไม่มี browser screenshot @ viewport
- เพิ่มปุ่ม/แถบโปรโมที่ไม่มีใน reference (#17)
- User ให้แค่ `response.json` ไม่มี visual ref — หยุดที่ Required inputs
- ข้าม verify / delta แล้วสรุป "ตรงรูปแล้ว"

## Troubleshooting

| Issue | Action |
|-------|--------|
| `file://` blocked in agent browser | `npx --yes serve <dir> -p 8765` then `browser_navigate` |
| No Python / `http.server` fails | Use `npx serve` or CSS audit |
| Node not in PATH (Windows) | Full path e.g. `C:\Program Files\nodejs\npx.cmd` |
| Mirror drift after edit | Edit canonical only; re-link mirrors if needed |
| Figma link only | Ask 1× PNG export at target width |
| Live URL promo noise | Exclude #17; document if user insisted |
| Animation in reference | Spec duration/easing in ms; static OK if reference static |
| Component-only crop | Scope table — no extra page chrome |
| RTL unclear | Ask user; set S0 `direction: rtl` before spec |
| Practice without mockup | Ask user for a PNG/SVG or live URL at target width |
| Wrong number on screen, layout matches ref | `@debug` — pitfall #24 |
