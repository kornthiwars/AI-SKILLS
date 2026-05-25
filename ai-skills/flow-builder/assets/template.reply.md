# Reply template — every turn (flow-builder)

```markdown
## สถานะ
- Phase: **F?_** · Scope: **<trigger> on <screen>**
- Gate ล่าสุด: **<รอ input | F1 done | … | Gate Flow Approved | Revise>**

## สรุปเทิร์นนี้
- <bullet สั้น ไทย — สูงสุด 5 ข้อ>

## คุณทำต่อ (ทำอย่างเดียว)
1. <ตอบคำถาม | ยืนยัน mutation step | ส่ง Gate Flow verdict>

## หยุดจนกว่า
`<ประโยคที่ user ต้องพิมพ์กลับ — เช่น ใช่มั้ย step 2 อัปเดต cart>`

## อย่าทำตอนนี้
- <1–2 ข้อ — เช่น อย่า @api-builder ก่อน Gate Flow Approved>
```

### After F3 (confirm mutations)

```markdown
## คุณทำต่อ (ทำอย่างเดียว)
1. ตอบคอลัมน์ **User confirms** ทุกแถวใน mutation chain (ใช่ / ไม่ / ไม่แน่)

## หยุดจนกว่า
`ยืนยัน mutation chain ครบทุกแถว`
```
