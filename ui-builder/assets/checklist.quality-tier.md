# Quality tier — default **10/10** for @ui-builder

**Default:** every `@ui-builder` deliverable targets **tier 10** unless the user explicitly asks for **tier 8** (draft / เร็วๆ / prototype).

## Score rubric

| Score | Gate B | Evidence | Typical gaps |
|-------|--------|----------|--------------|
| **≤7** | Not confirmed | Missing A or many blockers | emoji icons, wrong layout, no verify |
| **8** | Confirmed | 0 blockers · CSS audit only | "ใกล้เคียง" ไม่มี side-by-side |
| **9** | Confirmed | screenshot + 0 blockers · 1–2 **documented** waivers | placeholder avatars, substitute font |
| **10** | Confirmed | screenshot @ locked W×H · 0 blockers · **0 tier-10 waivers** | indistinguishable at locked width |

**Rule:** Post `Score: 10/10` in Gate B only when the tier-10 checklist below is fully satisfied. Otherwise post actual score (e.g. `9/10`) and list waivers.

## Tier 10 checklist (all required)

### Gate A (spec)

- [ ] Every S# has layout px + type px/`#hex` + surface `#hex`
- [ ] **Font:** family + weights from ref (or closest licensed webfont named in spec)
- [ ] **Icons:** SVG/icon-font per control — sizes 18–24px in hit box (#9, #26)
- [ ] **Imagery:** if ref shows photos/avatars/logos → asset plan (file path) or **user waiver** row in A
- [ ] Multi-pane: each pane width + scroll owner (#25)

### Build

- [ ] Tokens table traces every color/spacing to spec
- [ ] No emoji in toolbars, channel list, or chrome (#26)
- [ ] Pitfalls #1–27 + #28–32 scanned

### Verify (mandatory for tier 10)

- [ ] `cursor-ide-browser` (or dev server) — **not** CSS-only
- [ ] Viewport locked to spec W×H before screenshot
- [ ] **Side-by-side** ref vs build (chat attachment or `docs/**/gate-b.md`)
- [ ] **Full shell** screenshot when scope is S0…Sn (#27, #28)
- [ ] Zone pass: each S# L/T/C/S/M/E in delta table

### Gate B

- [ ] Delta **0 blockers**
- [ ] **Tier-10 waivers: none** (or each row has user OK in chat)
- [ ] `Score: 10/10` only if checklist complete

## Tier-10 waivers (forbidden without user OK)

| Waiver | Tier 9 OK? | Tier 10 |
|--------|------------|---------|
| Letter avatar แทนรูปใน ref | yes, document | **blocker** unless user waives |
| System font แทน brand font | yes, document | **blocker** unless user waives |
| CSS audit แทน screenshot | yes | **Not confirmed** |
| Cropped screenshot (single S# only) | yes for component scope | **blocker** for full-page scope |
| ≤2px minor | yes | yes only if invisible at locked width |

## Downgrade to tier 8

User says explicitly: `draft`, `prototype`, `8 พอ`, `ไม่ต้อง pixel perfect` → skip tier-10 checklist; still need Gate A + B with 0 blockers at chosen bar.
