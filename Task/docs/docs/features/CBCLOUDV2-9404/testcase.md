# Testcase - CBCLOUDV2-9404

Tất cả case giữ `not run` tới khi có bằng chứng thực thi.

## Truy vết AC

| AC | Testcase |
|---|---|
| AC1 | TC-01, TC-02, TC-03 |
| AC2 | TC-04, TC-06, TC-08, TC-18 |
| AC3 | TC-05, TC-07, TC-09, TC-18 |
| AC4 | TC-10 |
| AC5 | TC-11, TC-12 |
| AC6 | TC-13, TC-14 |
| AC7 | TC-15 |
| AC8 | TC-16, TC-17 |

| ID | Luồng | Dữ liệu/bước chính | Kết quả mong đợi | Loại | Status |
|---|---|---|---|---|---|
| TC-01 | File mẫu GTGT | Tải mọi biến thể GTGT qua API | Không có header chất lượng; biển số ngay sau số người | manual | not run |
| TC-02 | File mẫu Bán hàng | Tải `HoadonBH_FileMau.xlsx` | Layout cuối nhóm xe đúng | manual | not run |
| TC-03 | File mẫu Vé xe | Tải `HoadonVEXE_FileMau.xlsx` | Layout cuối nhóm xe đúng | manual | not run |
| TC-04 | GTGT direct | File mới `<= 50` dòng, loại 1, xe cũ đủ field và biển số | Thành công, không message quality, `cltsan` null | auto + manual | not run |
| TC-05 | GTGT background | Cùng dữ liệu `> 50` dòng | Kết quả giống direct | manual | not run |
| TC-06 | Bán hàng direct | File mới `<= 50` dòng | Thành công, biển số đúng, quality null | auto + manual | not run |
| TC-07 | Bán hàng background | File mới `> 50` dòng | Kết quả giống direct | manual | not run |
| TC-08 | Vé xe direct | File mới `<= 50` dòng | Thành công, biển số đúng, quality null | auto + manual | not run |
| TC-09 | Vé xe background | File mới `> 50` dòng | Kết quả giống direct | manual | not run |
| TC-10 | Xe đã qua sử dụng không quality | `tinhtrangtaisan = 1`, đủ field khác | Không báo thiếu/sai Chất lượng tài sản | auto | pass (worker) |
| TC-11 | Thiếu biển số | Xe đã qua sử dụng, bỏ biển số | Vẫn báo `Số biển kiểm soát không được để trống.` | auto | pass (worker) |
| TC-12 | Regression field khác | Sai required/enum/maxlength/number của field còn lại | Message hiện tại giữ nguyên | auto | not run |
| TC-13 | File cũ direct | Cột quality chứa `99.99`, cột sau là `30A-12345` | Bỏ qua `99.99`, đọc đúng biển số, `cltsan` null | auto + manual | not run |
| TC-14 | File cũ background | Giống TC-13 với `> 50` dòng | Không đọc lệch, kết quả giống direct | auto + manual | auto pass; manual not run |
| TC-15 | Negative gate | `loaihanghoa != 4`; subtype null/2/3 | Không chạy rule loại 1 mới | auto | pass (worker) |
| TC-16 | Contract/schema | So sánh API/queue/entity/schema/XML tag | Không đổi contract hoặc drop field domain | source review | pass |
| TC-17 | Dữ liệu cũ | Hóa đơn cũ có `cltsan`, xem/xuất XML | Giá trị cũ không bị xóa hoặc đổi | manual | not run |
| TC-18 | Gate tổng số cột mới | GTGT đúng 72 cột, Bán hàng 63, Vé xe 61 ở direct và worker | Cả sáu luồng nhận diện là template Hàng hóa đặc trưng mới và chạy validation còn lại | auto | source verified; worker build pass |

## An toàn kiểm thử

- Dùng tenant test và dữ liệu giả.
- Không vận hành queue production.
- Backup file mẫu runtime trước khi thay.
- Không đánh dấu manual pass chỉ dựa trên build/source review.
