# Integration checklist — F5 (manual smoke)

Run in the **target app** after API Ship + UI Gate B. Record pass/fail in Feature Ship summary.

## Auth flow (if applicable)

- [ ] Login success path returns expected token/session
- [ ] Invalid credentials show contract error (not silent fail)
- [ ] Authenticated call (e.g. GET me) works with session from login
- [ ] Logout / expiry handled per product rules (if in scope)

## FE ↔ API binding

- [ ] UI calls correct method + path from fe-handoff
- [ ] Success body fields bound per handoff table
- [ ] 422/401/403 display user-facing message from handoff

## Regression

- [ ] No unrelated pages broken (spot-check nav)
- [ ] No secrets in browser network tab sample (manual)

## Blockers

Any failed row above → Feature Ship **Not confirmed** unless user waives in chat with explicit acceptance.
