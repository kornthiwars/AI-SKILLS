# Feature Builder — runbook (copy for user)

```
[feature-builder — วิธีรัน]

Step 0  คุณ: @feature-builder + ชื่อฟีเจอร์ + user story + repo แอป
        หยุดจน: required inputs ครบ (มี UI ref หรือ defer UI ชัด)

Step 1  คุณ: ตอบ "Gate F Approved" (หลังเห็นแผน F1)
        หยุดจน: Gate F = Approved — อย่าเริ่ม API/UI ก่อน

Step 2  คุณ: ข้อความใหม่ → วาง F2 packet (template.api-invoke-packet.md) → @api-builder
        หยุดจน: คุณพิมพ์กลับ "Gate Ship = Confirmed" + สรุป/หลักฐาน

Step 3  คุณ: กลับเทรด @feature-builder → fe-handoff จาก F3
        หยุดจน: handoff ครบ (endpoints, samples, errors, bind fields)

Step 4  คุณ: ข้อความใหม่ → วาง F4 packet (template.ui-invoke-packet.md) → @ui-builder
        หยุดจน: Gate B Confirmed + Score + screenshot @ viewport (tier 10)

Step 5  คุณ: @feature-builder → Feature Ship checklist (F5)
        หยุดจน: Feature Ship = Confirmed

Step 6  (optional) @pr-review → @git-push เมื่อจะ commit/push
```

**แชทใหม่เมื่อไหร่:** F2 (@api-builder) และ F4 (@ui-builder) — **แนะนำข้อความใหม่**  
**เทรดเดิมเมื่อไหร่:** F0–F1, F3, F5 กับ @feature-builder

**ห้าม:** บอก "ทำครบเลย" แล้วให้ orchestrator เขียน route/component ในเทิร์นเดียว — ต้องแยก packet ตามตาราง
