# vault

Obsidian vault root = **`AI/vault`**

## โครงสร้าง

```
templates/             ← repo root (not inside vault/)
vault/
├── .obsidian/         ← graph: 2 color groups by folder
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

### Graph สี (Groups — แค่ 2 กลุ่ม)

| Query | โฟลเดอร์ | สี |
|-------|----------|-----|
| `path:issues` | `issues/` | ฟ้าหม่น `#7494B0` |
| `path:learnings` | `learnings/` | ดินอ่อน `#B59688` |

ตั้งใน `vault/.obsidian/graph.json` — **ไม่ใช้ tag groups** อีกแล้ว

โหนด `#tag` (ถ้าเปิด Display → Tags) ยังเป็นสีเขียวคงที่ของ Obsidian · สีโฟลเดอร์ดูที่ **จุดชื่อไฟล์**

## Learnings — ชื่อไฟล์ vs ชื่อแสดง

| ที่ | ค่า |
|----|-----|
| ไฟล์ | `2026-05-23-1545.md` |
| Graph / tabs | **`title:`** (plugin Property Over File Name) |

**ไม่มี hub file** — เชื่อม graph ด้วย tags เปิด ไม่ใช้ wikilink footer

Rule: `../ai-rules/vault-learning.mdc`

## Git

**ใน git:** README, `.obsidian` · templates อยู่ที่ `../templates/`  
**local:** `issues/*.md`, `learnings/*.md`
