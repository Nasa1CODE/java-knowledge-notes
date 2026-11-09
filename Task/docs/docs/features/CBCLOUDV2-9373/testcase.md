---
feature: CBCLOUDV2-9373
updated_at: 2026-09-11
---

# Testcase — CBCLOUDV2-9373

| # | Case | Expected |
|---|---|---|
| 1 | Gửi hóa đơn gốc có `quoc_tich_nguoi_mua = Việt Nam`, `ma_quoc_tich_nguoi_mua = VN` | DB lưu đủ, API không lỗi |
| 2 | Gửi hóa đơn thay thế có quốc tịch | Lưu thành công, không mất dữ liệu mở rộng |
| 3 | Gửi hóa đơn điều chỉnh có quốc tịch | Lưu thành công, response không lỗi |
| 4 | `ma_quoc_tich_nguoi_mua` dài hơn 2 ký tự | API trả lỗi validate tiếng Việt |
| 5 | `quoc_tich_nguoi_mua` dài hơn 50 ký tự | API trả lỗi validate tiếng Việt |
| 6 | Payload cũ không có quốc tịch | Vẫn xử lý bình thường |
| 7 | Gọi `DM_NCC_QuocTich/GetAllNoPage` | Trả danh sách quốc tịch cho dropdown FE ticket khác |
| 8 | Xuất XML với quốc tịch | Buyer node có `<QTNMua>` và `<MQTNMua>` đúng dữ liệu |

| 9 | `ACTIVE_ND_254 = "1"`, hóa đơn không có `loaihoadondactrung = 1` | Vẫn validate/map/lưu/render quốc tịch |
| 10 | `ACTIVE_ND_254` tắt/thiếu/lỗi, request có gửi quốc tịch | Không xử lý quốc tịch theo rule mới |
| 11 | `ACTIVE_ND_254 = "1"`, gửi `ma_quoc_tich_nguoi_mua` không có trong danh mục | API trả lỗi `Mã quốc tịch không tồn tại.` |
| 12 | Cùng trạng thái ND254 nhưng thay đổi request `version` | Kết quả gate không thay đổi |

| 13 | ND254 bật, dòng `loaihoadondactrung = 1` gửi `ma_nuocsx` không có trong danh mục | API trả lỗi `Mã nước sản xuất không tồn tại.` |
| 14 | ND254 bật, dòng `loaihoadondactrung = 2/3` gửi `ma_nuocsx` không có trong danh mục | Không chạy rule tồn tại mã nước sản xuất của Hàng hóa đặc trưng 1 |
| 15 | ND254 bật, DB có đủ dữ liệu người mua và xe loại 1 | XML có `QTNMua/MQTNMua`, `MTinh/MXa/TTinh/TXa`, đủ 15 trường xe mới và `PBan = 2.1.1` |
| 16 | ND254 tắt nhưng DB còn dữ liệu NĐ254 lịch sử | XML sinh lại không có các thẻ NĐ254, không có node rỗng và `PBan = 2.1.0` |
| 17 | ND254 tắt, DB có `SKhung`, `SMay`, `MDVQHNSach` | XML vẫn giữ các thẻ cũ/độc lập này; không sinh `CLTSan` |
| 18 | ND254 bật, có quốc tịch nhưng không có dữ liệu xe loại 1 | XML có `QTNMua/MQTNMua`, không có bốn thẻ địa bàn và giữ `PBan = 2.1.0` |
| 19 | ND254 bật nhưng field mới null/rỗng | Không sinh phần tử XML rỗng tương ứng |
| 20 | Sinh XML ký `Type = 2`, view `Type = 1`, custom và phân trang | Mọi biến thể dùng cùng trạng thái ND254 đã chốt ở đầu lần sinh |
| 21 | Redis trả `"1"` hoặc `" 1 "` | Checker trả `true`; giá trị khác/rỗng trả `false` |
| 22 | Redis thiếu/lỗi | Fallback host DB; DB thiếu/lỗi thì trả `false` |
| 23 | Gọi checker nhiều lần trong cùng instance | Redis/DB chỉ được đọc một lần |
| 24 | Tải XML đã ký đã lưu trên FTP sau khi đổi cờ | Trả nguyên file đã lưu, không sửa XML hoặc làm mất chữ ký |


