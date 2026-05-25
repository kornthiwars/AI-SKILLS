# Gate D — diagnosis report

```
[debug] Diagnosis — <scope>
Gate D: Approved | Revise
Repro class: stable | semi-flaky | flaky | non-repro
Instrumentation: none | [DBG-…] planned | removed
Evidence top tier: 1 | 2 | 3 | 4 | 5 | 6

## Root cause ledger (summary)
| Evidence | Supports | Contradicts |

## Breadcrumb ledger
| # | change | result | ruled in | ruled out |

## Hypotheses
| rank | hypothesis | disproof | survived? |

## Layer + ownership
| Layer | owner | status | finding |
| D2 API | backend | pass/fail | … |
| D4 Map | frontend data | pass/fail | … |

Primary root cause layer: D?_…
Patch tier: 1-5loc | function | module

## Regression (D7)
| check | pass |
| original repro | |
| adjacent flows | |
| loading / empty / error | |
| retry / stale cache / nav | |

## Handoff
none | @api-builder | @ui-builder

## Blockers (if Revise)
| # | need |

Summary (TH): …
Next: confirm fix | handoff | D7 item | remove DBG before ship
```
