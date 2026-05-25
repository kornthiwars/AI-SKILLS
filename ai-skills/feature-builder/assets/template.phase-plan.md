# Phase plan — F1 + Gate F (copy into chat)

```
[feature-builder F1]
Feature: <name>
Gate F — Feature plan

## Phase order
| # | Phase | Skill | You run (next action) | Done when |
| 1 | F2 API | @api-builder | New message: paste F2 packet + `@api-builder` | Gate Ship Confirmed |
| 2 | F3 Handoff | feature-builder | Same thread: `@feature-builder` + fe-handoff | fe-handoff pasted |
| 3 | F4 UI | @ui-builder | New message: paste F4 packet + `@ui-builder` | Gate B Confirmed |
| 4 | F5 Integration | feature-builder | `@feature-builder` + integration checklist | Feature Ship Confirmed |

## API slice (for F2 packet)
Mode: narrow-delta | crud-pack | single
Endpoints: …

## UI slice (for F4 packet)
Surfaces: S0 … Sn · Viewport W×H · Ref: path/URL
Quality: ui-builder tier 10 default (Gate B Score 10/10 or documented 9/10)
Blocked until ref: yes | no
F4 owner: @ui-builder only (feature-builder posts packet, no TSX/CSS)

## Risks / dependencies
- …

## Gate F verdict
Approved | Revise
Blockers (if Revise):
| # | issue | fix |
```
