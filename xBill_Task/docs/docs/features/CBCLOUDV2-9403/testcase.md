# Testcase - CBCLOUDV2-9403

Automated test và source review được cập nhật theo kết quả chạy ngày 2026-09-08; các bước cần môi trường tích hợp vẫn giữ `not run`.

## Truy vết AC

| AC | Testcase |
|---|---|
| AC1 | TC-01, TC-02 |
| AC2 | TC-03, TC-04, TC-05 |
| AC3 | TC-06, TC-07 |
| AC4 | TC-08, TC-09, TC-10 |
| AC5 | TC-11, TC-12 |
| AC6 | TC-13, TC-14 |
| AC7 | TC-15 |
| AC8 | TC-10, TC-16, TC-17 |
| AC9 | TC-15, TC-16, TC-17 |

| ID | Luồng | Dữ liệu/bước chính | Kết quả mong đợi | Loại | Status |
|---|---|---|---|---|---|
| TC-01 | DTO contract | Reflection ba detail DTO | Không có property `chatluongtaisan` | auto | passed |
| TC-02 | Swagger | Sinh/đọc schema ba request model | Không công bố field quality; route/response giữ nguyên | manual | not run |
| TC-03 | API gốc | `version = "1"`, subtype 1, xe cũ đủ field trừ quality | Thành công, không message quality | auto + manual | auto passed; manual not run |
| TC-04 | API thay thế | Dữ liệu tương tự TC-03 | Không message quality, nghiệp vụ thay thế giữ nguyên | manual | not run |
| TC-05 | API điều chỉnh | Dữ liệu tương tự TC-03 | Không message quality, nghiệp vụ điều chỉnh giữ nguyên | manual | not run |
| TC-06 | JSON cũ | Gửi quality null, chuỗi, `99.99`, `123.45` | Property dư bị bỏ qua; không lỗi quality | auto + manual | auto passed; manual not run |
| TC-07 | Mapping | Gửi quality trong payload cũ, biển số hợp lệ | DB `cltsan` null, `sbksoat` đúng | auto + DB | auto passed; DB not run |
| TC-08 | HSM | Ba wrapper HSM, payload không quality | Kế thừa API lưu; lỗi khác không gọi HSM | manual | not run |
| TC-09 | MTT | Hai API MTT, payload không quality | Kế thừa API lưu; lỗi khác không cấp số/ký/gửi TCT | manual | not run |
| TC-10 | XML | Ba API XML với payload mới và payload cũ còn node quality | Deserialize được, không lưu quality và XML output không có `CLTSan` | manual | not run |
| TC-11 | Thiếu biển số | Xe cũ thiếu `sobienkiemsoat` | Vẫn báo bắt buộc biển số | auto + manual | auto passed; manual not run |
| TC-12 | Regression field khác | Thiếu/sai enum, maxlength, number của từng field còn lại | Message hiện tại giữ nguyên | auto | passed |
| TC-13 | Version gate | Version null/rỗng/`0`/`2` | Không kích hoạt rule subtype 1 mới | auto | passed |
| TC-14 | Subtype gate | Subtype null/2/3 | Không chạy validate/map Hàng hóa đặc trưng loại 1 | auto | passed |
| TC-15 | Tenant DB | Đọc lại hóa đơn mới trong đúng tenant | `cltsan` null; không truy vấn chéo tenant | manual | not run |
| TC-16 | Dữ liệu lịch sử | Hóa đơn cũ có `cltsan`, đọc/xuất XML | DB vẫn giữ giá trị nhưng XML không còn `CLTSan` | manual | not run |
| TC-17 | Source contract | Rà entity/repository/XML/constants | Giữ domain/DB, bỏ call-site và constant XML `CLTSan`, không migration | source review | passed |

## An toàn kiểm thử

- Chỉ dùng tenant test và dữ liệu giả.
- Không gọi HSM/MTT/CQT production.
- Với request dự kiến lỗi, xác nhận không phát sinh ký, cấp số hoặc gửi TCT.
- Không ghi payload, token, credential hoặc dữ liệu khách hàng thật vào docs/log.
