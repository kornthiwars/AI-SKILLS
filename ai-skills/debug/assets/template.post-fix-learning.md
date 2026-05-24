# Post-fix RCA snippet — paste into project `.cursor/learnings.md` (not a separate skill)

Use **after** fix validated (repro passes). Keep 5–15 lines. **Offer user before append.**

Format matches `templates/project-learnings-template.md` in the skills repo — new entry at **top** of file.

```
## YYYY-MM-DD · @debug · <ticket or symptom>

**แท็ก:** `#debug` `#…`

- **อาการ:** …
- **สาเหตุ (root cause):** … · layer D?_… · file:line ถ้ามี
- **แก้:** … (PR/commit)
- **validate:** repro ซ้ำผ่าน · …
- **ทำไมหลุด:** CI gap | latent | workload | review miss | …
- **อย่าทำซ้ำ:** …
- **action (ถ้ามี):** regression test / …
```
