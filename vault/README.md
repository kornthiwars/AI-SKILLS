# vault

Obsidian vault root = **`AI/vault`**

## โครงสร้าง

```
vault/
├── .obsidian/         ← graph: tags ON + color groups
├── templates/
├── issues/YYYY-MM-DD.md
└── learnings/YYYY-MM-DD-HHmm.md
```

## Tags

### Type (บังคับ)

| Tag | ใช้กับ |
|-----|--------|
| `#issues` | ไฟล์รายวัน `issues/` (หนึ่งไฟล์ต่อวัน) |
| `#learning` | ไฟล์ lesson `learnings/` |

### Topic (เลือก 1–3 ต่อ section หรือ note)

| Tag | หัวข้อ |
|-----|--------|
| `#vault` | โครง vault, rules การเขียน |
| `#git` | gitignore, commit, push |
| `#research` | graph, plugins, investigation |
| `#ui` | Cursor UI, editor, agent UX |
| `#api` | REST/API, endpoints, backend |
| `#infrastructure` | repo layout, CI, agent policies |
| `#debug` | แก้ bug / error |

**Issues:** ใส่ใน frontmatter (รวมทุก topic ของวัน) + บรรทัด `#vault` ใต้ `##` แต่ละข้อ  
**Learnings:** `tags: [learning, vault]` — `skill:` ต้องตรงกับ topic tag

Graph สี: `#issues` · `#learning` · `#vault` · `#research` · `#git` · `#ui` · `#api` · `#infrastructure`

## Learnings — ชื่อไฟล์ vs ชื่อแสดง

| ที่ | ค่า |
|----|-----|
| ไฟล์ | `2026-05-23-1545.md` |
| Graph / tabs | **`title:`** (plugin Property Over File Name) |

**ไม่มี hub file** — เชื่อม graph ด้วย tags เปิด ไม่ใช้ wikilink footer

Rule: `../ai-rules/vault-learning.mdc`

## Git

**ใน git:** README, templates, `.obsidian`  
**local:** `issues/*.md`, `learnings/*.md`
