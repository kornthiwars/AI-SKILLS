# Repro — copy into chat

```
[debug repro]
Symptom: <what user sees wrong>
Expected: <value / behavior>
Actual: <value / behavior>
Page/URL: <path or route>
Steps:
1. …
2. …
Scope: <component or endpoint>
Environment: <local | staging> · user role: <…>

## Repro reliability (tally fails = wrong actual)
Runs attempted: 2 | 3 | 5
| run | actual | fail? |
| 1 | … | y/n |
| 2 | … | y/n |
| 3 | … | y/n |
| 4 | … | y/n |
| 5 | … | y/n |

Repro class: stable | semi-flaky | flaky | non-repro
  stable = 2/2 fail · semi-flaky = 3/5 fail · flaky = <50% · non-repro = 0 fail

Instrumentation required: yes (semi-flaky/flaky) | no (stable)
```
