# Testcase - CBCLOUDV2-9385

Testcase automated được cập nhật theo kết quả `dotnet test`; testcase tích hợp giữ `not run` khi chưa có bằng chứng API.

## Truy vết AC -> testcase

| AC | Testcase |
|---|---|
| AC1 | TC-01, TC-09 |
| AC2 | TC-02, TC-03, TC-10 |
| AC3 | TC-11, TC-12 |
| AC4 | TC-13 |
| AC5 | TC-04, TC-05, TC-06 |
| AC6 | TC-07 |
| AC7 | TC-08 |
| AC8 | TC-14, TC-15 |

| ID | Luồng | Dữ liệu chính | Kết quả mong đợi | Auto/manual | Status |
|---|---|---|---|---|---|
| TC-01 | Shared validator | Gate true; `dnmua_email = null/""/whitespace`; buyer field khác hợp lệ | Không có `Địa chỉ thư điện tử không được để trống.` | auto | pass (3 cases) |
| TC-02 | Thay thế | `version = 1`, có subtype 1, Email trống | Không báo required Email đặc trưng | auto + manual | not run |
| TC-03 | Điều chỉnh | `version = 1`, có subtype 1, Email trống | Không báo required Email đặc trưng | auto + manual | not run |
| TC-04 | Email sai định dạng | Email `abc` hoặc domain sai | Vẫn báo `Email không đúng định dạng.` | auto + manual | not run |
| TC-05 | Danh sách Email | Danh sách `,`/`;` có một phần tử sai | Vẫn báo lỗi định dạng | auto + manual | not run |
| TC-06 | Maxlength | Email vượt 50 byte trong rule đặc trưng | Vẫn báo maxlength 50 | auto + manual | pass (auto), manual not run |
| TC-07 | Buyer field khác | Thiếu lần lượt Tên/MST/Địa chỉ/Tỉnh/Xã/SĐT/Họ tên người mua | Vẫn báo required đúng field | auto | pass |
| TC-08 | Gate không kích hoạt | `version` null/rỗng/khác 1 hoặc subtype null/2/3 | Không chạy required rule đặc trưng; luồng cũ giữ nguyên | auto + manual | pass (8 auto cases), manual not run |
| TC-09 | API gốc | `GuiHoaDonGoc`, subtype 1, Email trống, dữ liệu khác hợp lệ | Lưu thành công, `DNMua_Email` rỗng theo mapping hiện tại | manual | not run |
| TC-10 | API thay thế/điều chỉnh | Hai API lưu, Email trống | Lưu đúng nghiệp vụ thay thế/điều chỉnh, không báo required Email đặc trưng | manual | not run |
| TC-11 | Wrapper HSM | Ba API HSM với Email trống và dữ liệu hợp lệ | Kế thừa validation mới; lưu/ký theo luồng hiện tại | manual | not run |
| TC-12 | API MTT | `GuiHoaDonVaKyMTT`, `_V2` với Email trống | Kế thừa validation mới; cấp số/ký/gửi TCT theo luồng hiện tại | manual | not run |
| TC-13 | Wrapper XML | Ba payload XML có `version = 1`, subtype 1, Email trống | Deserialize và gọi API lưu, không báo required Email đặc trưng | manual | not run |
| TC-14 | Mapping/XML có Email | Email hợp lệ hoặc nhiều Email | DB giữ giá trị hiện tại; `NMua/DCTDTu` giữ rule lấy Email đầu tiên | auto + manual | not run |
| TC-15 | Rule tenant riêng | Tenant đang có rule Email riêng, Email trống | Giữ message/rule tenant hiện tại; task không vô hiệu hóa rule độc lập | manual | not run |

## Dữ liệu và an toàn kiểm thử

- Chỉ dùng tenant và dữ liệu giả trên môi trường test.
- Với HSM/MTT, trước tiên dùng request lỗi ở field khác để xác nhận dừng trước ký/cấp số/gửi TCT.
- Không gọi HSM/CQT production từ local.
- Không đánh dấu pass chỉ dựa trên build; API manual cần log/Postman/Newman hoặc mã giao dịch test.

## Bằng chứng automated

- Command: `dotnet test test/WS.Application.Tests/WS.Application.Tests.csproj --no-restore --verbosity minimal`.
- Kết quả: `Passed: 14, Failed: 0, Skipped: 0`.
- TC-04, TC-05 và TC-14 được source-review để xác nhận logic cũ còn nguyên, nhưng vẫn giữ `not run` vì chưa thực thi qua validation entry/API.
