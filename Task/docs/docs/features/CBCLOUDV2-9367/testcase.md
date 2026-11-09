---
feature: CBCLOUDV2-9367
updated_at: 2026-09-10
---

# Testcase — CBCLOUDV2-9367

| # | Case | Expected |
|---|---|---|
| 1 | Gửi hóa đơn gốc có `ma_tinh`, `ten_tinh`, `ma_xa`, `ten_xa` | DB `vs_hd_tonghop_morong` lưu đủ 4 field địa bàn |
| 2 | Gửi hóa đơn thay thế có `ten_tinh`, `ten_xa` | Lưu thành công, không mất dữ liệu khi map hóa đơn thay thế |
| 3 | Gửi hóa đơn điều chỉnh có `ten_tinh`, `ten_xa` | Lưu thành công, response không lỗi |
| 4 | Payload cũ không có `ten_tinh`, `ten_xa` | Vẫn xử lý bình thường |
| 5 | Xuất XML với đủ field địa bàn | Buyer node có `MTinh`, `MXa`, `TTinh`, `TXa` đúng dữ liệu |
| 6 | `ten_tinh`, `ten_xa` dài đúng 50 ký tự | API pass và XML render đúng |
| 7 | `ten_tinh` dài 51 ký tự | API trả lỗi maxlength `Tên tỉnh không được vượt quá 50 ký tự.` |
| 8 | `ten_xa` dài 51 ký tự | API trả lỗi maxlength `Tên xã không được vượt quá 50 ký tự.` |


