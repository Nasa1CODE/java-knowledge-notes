# Testcase - CBCLOUDV2-9386

Chỉ đánh dấu `pass` cho phần đã có bằng chứng tự động; các case manual giữ `not run` cho tới khi có bằng chứng runtime.

## Truy vết AC -> case

| AC | Case |
|---|---|
| AC1 | TC-01, TC-02 |
| AC2 | TC-03, TC-04 |
| AC3 | TC-05, TC-06 |
| AC4 | TC-07, TC-08 |
| AC5 | TC-09, TC-10 |
| AC6 | TC-11, TC-12 |
| AC7 | TC-13, TC-14 |

| ID | Luồng | Dữ liệu chính | Kết quả mong đợi | Auto/manual | Status |
|---|---|---|---|---|---|
| TC-01 | GTGT trực tiếp | Template mới, loại 1, Email trống, <=50 dòng | Import không báo required Email | manual | not run |
| TC-02 | GTGT nền | Cùng dữ liệu, >50 dòng | Worker không báo required Email | manual | not run |
| TC-03 | Bán hàng trực tiếp | Template mới, loại 1, Email trống, <=50 dòng | Import không báo required Email | manual | not run |
| TC-04 | Bán hàng nền | Cùng dữ liệu, >50 dòng | Worker không báo required Email | manual | not run |
| TC-05 | Vé xe trực tiếp | Template mới, loại 1, Email trống, <=50 dòng | Import không báo required Email | manual | not run |
| TC-06 | Vé xe nền | Cùng dữ liệu, >50 dòng | Worker không báo required Email | manual | not run |
| TC-07 | Email sai định dạng | Nhập `abc` trong từng loại hóa đơn | Vẫn báo `Email không đúng định dạng.` | auto + manual | not run |
| TC-08 | Email vượt độ dài | Email vượt giới hạn rule hiện tại | Vẫn báo lỗi độ dài hiện tại | auto + manual | pass (auto) |
| TC-09 | Thiếu buyer field khác | Thiếu Tên/Địa chỉ/SĐT | Vẫn báo required đúng field | auto | pass |
| TC-10 | Thiếu địa bàn | Thiếu/sai Mã tỉnh, Mã xã | Vẫn báo lỗi hiện tại | auto | pass |
| TC-11 | Dòng con đặc trưng | Dòng cha Email trống, dòng con kích hoạt loại 1, <=50 dòng | Không báo required Email tại dòng cha | manual | not run |
| TC-12 | Dòng con đặc trưng nền | Cùng dữ liệu, >50 dòng | Worker không báo required Email tại dòng cha | manual | not run |
| TC-13 | Template cũ | Email trống | Giữ hành vi import cũ, không kích hoạt rule đặc trưng mới | regression manual | not run |
| TC-14 | Không phải loại 1 | Template mới, subtype null/2/3 hoặc `loaihanghoa != 4` | Không kích hoạt rule Hàng hóa đặc trưng loại 1 | auto + manual | pass (auto) |

## Dữ liệu và lưu ý kiểm thử

- Chỉ dùng tenant và dữ liệu giả phục vụ test.
- Lặp manual case với GTGT, Bán hàng, Vé xe và đối chiếu kết quả giữa file `<= 50` và `> 50` dòng.
- Xác nhận Email có dữ liệu hợp lệ vẫn map vào `DNMua_Email`.
- Không đánh dấu pass chỉ dựa trên build; cần output test hoặc bằng chứng import tương ứng.
