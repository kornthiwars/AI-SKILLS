# Flow spec — Gate Flow (copy into chat or save as docs/flows/<name>.md)

```
[flow-builder Flow spec]
Title: <short name>
Scope: <one trigger on one screen>
Repo: <path or n/a>
Date/session: <optional>

**Not API contract:** HTTP rows below are skeletons for discussion/handoff — full contract → `@api-builder` Gate Contract.

## F1 Action flow
<paste or link template.action-flow summary>

## F2 Data lineage
<paste or link template.data-lineage summary>

## F3 Mutation chain
<paste or link template.mutation-chain summary>

## F4 Gap check
| Check | pass | note |
| loading/disabled during submit | yes/no | … |
| error path (4xx/5xx) documented | yes/no | … |
| auth required | yes/no | … |
| double-submit risk | yes/no | … |
| stale list after mutation | yes/no | … |
| navigation after success | yes/no | … |

## Gate Flow
Verdict: Approved | Revise

Blockers (if Revise):
| # | gap | need from user |
| 1 | … | … |

## Optional next (standalone — user chooses)
| Goal | Suggested skill | Paste |
| API contract + build | @api-builder | endpoints from mutation chain |
| UI bind fields | @ui-builder | rows from data lineage + ref |
| Full FE+BE feature | @feature-builder | this flow-spec in F0 |
| Data wrong on screen already | @debug | not this skill |
```
