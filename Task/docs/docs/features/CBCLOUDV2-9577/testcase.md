---
feature: CBCLOUDV2-9577
updated_at: 2026-09-14
---

# Testcase - CBCLOUDV2-9577

| ID | Input | Kết quả mong đợi |
|---|---|---|
| TC-01 | API không có 21 field mới | Chạy rule cũ |
| TC-02 | API chỉ gửi string mới là whitespace | Chạy rule cũ |
| TC-03 | Có dòng loại `1` và gửi một string mới ở cấp hóa đơn hoặc trên chính dòng loại `1` | Bật `UseND254` và chạy toàn bộ rule NĐ254 hiện tại |
| TC-04 | Dòng loại `1` gửi field số mới bằng `0` | Được coi là có dữ liệu; chạy rule mới |
| TC-05 | Dòng loại `1` gửi field số mới sai kiểu | Chạy rule mới và trả message dữ liệu không hợp lệ |
| TC-06 | Chỉ gửi `ma_quoc_tich_nguoi_mua`, không có dòng loại `1` | Chạy rule cũ |
| TC-07 | Gửi `quoc_tich_nguoi_mua` và có dòng loại `1` | Bật NĐ254 và cộng dồn các required error hiện tại |
| TC-08 | Gửi một field xe và subtype 1 | Chạy toàn bộ validation xe hiện tại của dòng |
| TC-09 | Field mới chỉ nằm trên dòng subtype khác `1`/null | Không dùng làm tín hiệu; chạy rule cũ nếu không có tín hiệu khác |
| TC-10 | Chỉ gửi field cũ `sokhung`/`somay` | Không tự kích hoạt rule NĐ254 |
| TC-11 | Gửi địa bàn cùng dòng xe NĐ254 | Validate/map đủ field địa bàn có dữ liệu |
| TC-12 | XML entity không có field mới | `PBan = 2.1.0`, không có tag NĐ254 |
| TC-13 | XML entity có một trong 15 field xe trên dòng loại `1` | `PBan = 2.1.1`, chỉ sinh tag có dữ liệu |
| TC-14 | XML entity chỉ có quốc tịch nhưng không có dòng loại `1` | Xử lý theo rule cũ, không sinh tag NĐ254 |
| TC-15 | Redis/DB config bật, request không có field mới | Vẫn chạy rule cũ |
| TC-16 | Redis/DB config tắt/lỗi, request có dòng loại `1` và field mới phù hợp | Vẫn chạy rule NĐ254 |
| TC-17 | `version` null/`0`/`1`, dữ liệu giống nhau | Kết quả giống nhau |
| TC-18 | XML đã ký trên FTP | Nội dung và chữ ký không thay đổi |
| TC-19 | Request đã bật `UseND254`, đồng thời sai nhiều field người mua và nhiều dòng chi tiết loại `1` | `motaketqua` chứa đầy đủ tất cả lỗi, không chỉ lỗi đầu tiên |
| TC-20 | Cùng payload lỗi trước và sau khi đổi gate | Mã kết quả và cách nối message không thay đổi |
| TC-21 | Có field mới cấp hóa đơn nhưng không có dòng loại `1` | Chạy rule cũ; không validate 15 field chi tiết |
| TC-22 | Có dòng loại `1` và loại `2/3` | Validation/map 15 field mới chỉ áp dụng trên dòng loại `1` |

## Regression API

Chạy cho hóa đơn gốc, thay thế, điều chỉnh và các wrapper XML/HSM/Token/MTT.

## Regression XML

Chạy XML ký `Type = 2`, XML view `Type = 1`, custom layout và phân trang.

## Ngoài scope

Không chạy hoặc sửa testcase Excel import trong phase API này.
