# Testcase - CBCLOUDV2-9379

Automated test đã chạy ngày 2026-09-08; các phần cần tenant/auth/DB hoặc tích hợp giữ `not run`.

## Truy vết AC

| AC | Testcase |
|---|---|
| AC1 | TC-01, TC-03, TC-05 |
| AC2 | TC-02, TC-04, TC-06 |
| AC3 | TC-07, TC-08 |
| AC4 | TC-09, TC-10 |
| AC5 | TC-11, TC-12 |
| AC6 | TC-13, TC-14, TC-15 |
| AC7 | TC-16 |
| AC8 | TC-17 |

| ID | Luồng | Dữ liệu | Kết quả mong đợi | Loại | Status |
|---|---|---|---|---|---|
| TC-01 | API gốc - địa bàn | `ma_tinh` 2/3, `ma_xa` 5/6 | N hợp lệ; N+1 báo giới hạn mới | auto + manual | auto pass; manual not run |
| TC-02 | API gốc - detail | N/N+1 cho năm field | Đúng message 255/400 có STT | auto + manual | auto pass; manual not run |
| TC-03 | API thay thế - địa bàn | Boundary 2/5 | Giống API gốc | manual | not run |
| TC-04 | API thay thế - detail | Boundary 255/400 | Giống API gốc | manual | not run |
| TC-05 | API điều chỉnh - địa bàn | Boundary 2/5 | Giống API gốc | manual | not run |
| TC-06 | API điều chỉnh - detail | Boundary 255/400 | Giống API gốc | manual | not run |
| TC-07 | Unit boundary | Parameterized bảy field tại N/N+1 | N pass; N+1 đúng message | auto | pass |
| TC-08 | Unicode | Chuỗi Unicode có byte > N nhưng ký tự = N | Hợp lệ theo số ký tự | auto + manual | auto pass; manual not run |
| TC-09 | Version negative | null/rỗng/whitespace/khác `1` | Không chạy rule mới | auto + manual | auto pass; manual not run |
| TC-10 | Subtype negative | details null/rỗng; subtype null/2/3 | Không chạy rule loại 1 | auto + manual | auto pass; manual not run |
| TC-11 | Required/enum/precision | Thiếu/sai dữ liệu hiện có | Message cũ giữ nguyên | auto | partial: buyer required pass |
| TC-12 | Field ngoài scope | Boundary maxlength khác | Không đổi hành vi | regression auto | pass |
| TC-13 | HSM | Ba wrapper với request lỗi/hợp lệ | Kế thừa validation; lỗi dừng trước ký | manual | not run |
| TC-14 | MTT | Hai API với request lỗi/hợp lệ | Lỗi dừng trước cấp số/ký/gửi TCT | manual | not run |
| TC-15 | XML | Ba XML wrapper | Deserialize và dùng validation mới | manual | not run |
| TC-16 | DB read-back | Năm field mở rộng tại N | Lưu đủ, không truncate | manual + SQL | not run |
| TC-17 | Contract | So sánh route/DTO/response/XML tag | Không thay đổi contract | source review | pass |

## An toàn kiểm thử

- Chỉ dùng tenant test đã apply CBCLOUDV2-9260.
- HSM/MTT dùng request validation lỗi trước để xác nhận không có side effect.
- Không gọi tích hợp production từ local.
