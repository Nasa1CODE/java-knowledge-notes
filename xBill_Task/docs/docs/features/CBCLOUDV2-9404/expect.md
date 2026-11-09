---
feature: CBCLOUDV2-9404
status: testing
services-affected: [invoicecore, svinvoicesendemail]
updated_at: 2026-09-08
---

# Expect - CBCLOUDV2-9404: Bỏ trường Chất lượng tài sản khi import Hàng hóa đặc trưng 1

## Bối cảnh

File import Hàng hóa đặc trưng loại 1 hiện có cột `Chất lượng tài sản %`. Hệ thống đọc cột này vào `chatluongtaisan`, bắt buộc khi `tinhtrangtaisan = 1`, kiểm tra `decimal(4,2)` và lưu xuống `CLTSan/cltsan`. Yêu cầu mới bỏ trường này khỏi luồng Import.

## Đối tượng và phạm vi áp dụng

- Người dùng tải file mẫu và import Excel hóa đơn GTGT, Bán hàng hoặc Vé xe.
- Import trực tiếp `<= 50` dòng tại `invoicecore` và import nền `> 50` dòng tại `svinvoicesendemail`.
- Chỉ áp dụng cho dòng đồng thời có `loaihanghoa = 4` và `loaidactrung = 1`.

## Mong muốn

- File mẫu mới không còn cột `Chất lượng tài sản %`; `Số biển kiểm soát` đứng ngay sau `Số người cho phép chở`.
- Import không đọc, không validate bắt buộc/định dạng và không lưu `chatluongtaisan`.
- Xe đã qua sử dụng vẫn bắt buộc `Số biển kiểm soát` và các trường hiện hành khác.
- Import trực tiếp và import nền có hành vi giống nhau cho cả GTGT, Bán hàng và Vé xe.
- File mẫu cũ có cột `Chất lượng tài sản %` được nhận diện để không đọc lệch `Số biển kiểm soát`; giá trị tại cột chất lượng bị bỏ qua.

## Acceptance Criteria

- **AC1:** Các file mẫu GTGT, Bán hàng và Vé xe được tải sau deploy không còn header `Chất lượng tài sản %`; thứ tự cuối nhóm xe là `Trọng tải`, `Số người cho phép chở`, `Số biển kiểm soát`.
- **AC2:** Với file mẫu mới và dòng `loaihanghoa = 4`, `loaidactrung = 1`, import trực tiếp của cả ba loại hóa đơn không sinh message chứa `Chất lượng tài sản` và không lưu `CLTSan`.
- **AC3:** Import nền của cả ba loại hóa đơn cho kết quả giống AC2.
- **AC4:** Xe đã qua sử dụng (`tinhtrangtaisan = 1`) import thành công khi không có trường chất lượng nhưng có `Số biển kiểm soát` và đủ các field bắt buộc còn lại.
- **AC5:** Xe đã qua sử dụng thiếu `Số biển kiểm soát` vẫn báo lỗi bắt buộc; required/enum/maxlength/định dạng của các field khác giữ nguyên.
- **AC6:** File mẫu cũ còn hai cột `Chất lượng tài sản %`, `Số biển kiểm soát` không bị đọc lệch: bỏ qua chất lượng, lấy đúng biển số và không ghi `CLTSan`.
- **AC7:** Dòng không thỏa gate (`loaihanghoa != 4` hoặc `loaidactrung` null/2/3) giữ hành vi hiện tại, không kích hoạt rule Hàng hóa đặc trưng loại 1.
- **AC8:** Không đổi API, queue contract, entity/DB schema, XML tag, frontend hoặc dữ liệu `cltsan` đã lưu của hóa đơn cũ.

## Ngoài phạm vi

- Không xóa `CLTSan/cltsan` khỏi entity, bảng tenant hoặc XML toàn hệ thống.
- Không xóa/đổi dữ liệu chất lượng tài sản đã lưu trước đây.
- Không sửa API tạo hóa đơn thủ công/tích hợp hoặc màn hình nhập hóa đơn.
- Không sửa các field Hàng hóa đặc trưng loại 1 khác.
- Không đổi queue name/payload hoặc ngưỡng phân tuyến direct/background.

## Giả định cần reviewer xác nhận

- Phạm vi `Import` gồm GTGT, Bán hàng và Vé xe như các task CBCLOUDV2-9168/CBCLOUDV2-9260.
- File mẫu cũ vẫn được hỗ trợ, nhưng cột chất lượng bị bỏ qua thay vì lưu dữ liệu.
- Tất cả biến thể file GTGT do `TaiFileMau(...)` trả về phải được rà và cập nhật nếu còn cột này.

## Câu hỏi mở

| # | Câu hỏi | Người trả lời | Trạng thái |
|---|---|---|---|
| 1 | Ai sở hữu và phát hành các binary dưới `FileMau/HoaDon` vì file không nằm trong git checkout? | DevOps/TechLead | Chờ xác nhận trước deploy |

## Ảnh hưởng người dùng / dữ liệu

Người dùng không cần nhập Chất lượng tài sản cho xe đã qua sử dụng. Import mới ghi `CLTSan = null`; dữ liệu cũ và cột DB vẫn được giữ nguyên để không ảnh hưởng API/XML ngoài phạm vi.

## Tài liệu liên quan

- `features/CBCLOUDV2-9168/`
- `features/CBCLOUDV2-9260/`
- `specs/system.md`, `architecture.md`
