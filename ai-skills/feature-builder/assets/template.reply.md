# Reply template — บังคับทุกเทิร์น (feature-builder)

คัดลอกโครงนี้ท้ายทุก reply — ปรับค่าใน `<>` เท่านั้น

```markdown
## สถานะ
- Phase: **F?_** · Feature: **<name>**
- Gate ล่าสุด: **<Approved | Revise | รอ Ship | รอ Gate B | …>**

## สรุปเทิร์นนี้
- <bullet สั้น ไทย — สูงสุด 5 ข้อ>

## คุณทำต่อ (ทำอย่างเดียว)
1. <ข้อความใหม่ | เทรดเดิม> → <@skill หรือคำสั่งเดียว>

## หยุดจนกว่า
`<ประโยคที่ user ต้องพิมพ์กลับ หรือ Gate verdict>`

## อย่าทำตอนนี้
- <1–2 ข้อ — เช่น อย่า @ui-builder ก่อน Ship>
```

### หลัง Gate F Approved (ตัวอย่าง)

```markdown
## คุณทำต่อ (ทำอย่างเดียว)
1. **ข้อความใหม่** → วาง F2 packet จาก `template.api-invoke-packet.md` → พิมพ์ `@api-builder`

## หยุดจนกว่า
`Gate Ship = Confirmed` + สรุปสั้น
```

### หลังโพสต์ F2 packet (ตัวอย่าง)

```markdown
## คุณทำต่อ (ทำอย่างเดียว)
1. เปิด **ข้อความใหม่** → วาง packet ด้านบน → ส่ง `@api-builder` — **อย่า** implement ในเทรดนี้

## หยุดจนกว่า
`Gate Ship = Confirmed`
```
