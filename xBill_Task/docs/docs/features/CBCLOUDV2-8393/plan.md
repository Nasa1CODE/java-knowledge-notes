# CBCLOUDV2-8393 Plan

## Tóm tắt

Fix luồng import GTGT để các dòng cùng một loại thuế suất theo ID hệ thống được gom đúng trong `HD_ThueSuat`. Chi tiết hàng hóa vẫn lưu riêng trong `HD_ChiTiet`. Không tính lại tiền thuế theo VAT%; import/API gửi dữ liệu thế nào thì summary chỉ cộng dồn theo dữ liệu đó.

## Phạm vi

- Backend import GTGT trong Cloud.
- Service import nền GTGT khi file đủ điều kiện chạy service.
- VE_XE import fix liên quan dòng chiết khấu đã được ghi nhận trong task này vì phát sinh trong cùng chuỗi import.
- Không sửa DB schema, migration, XML, ký số, truyền CQT, báo cáo, bảng kê.
- Không hồi tố hóa đơn đã import trước release.

## Backend Import GTGT

- Khi tạo `HD_ThueSuat`, group theo `HangHoa_MaThue + HangHoa_Thue`.
- Không dùng `HangHoa_TenThue` làm key group.
- Dòng âm/CKTM/chiết khấu cùng `MaThue + MucThue` phải cộng vào đúng group, không tạo dòng summary riêng.
- `TongTien_ChiuThue = Sum(TongTien_ChuaThue)` từ dữ liệu đã import/lưu.
- `TongTien_Thue = Sum(TongTien_Thue)` từ dữ liệu đã import/lưu.
- Không tự tính lại `TongTien_Thue = TongTien_ChiuThue * VAT%`.
- `TenThue` ưu tiên lấy từ Admin theo `HangHoa_MaThue`, fallback về tên thuế import nếu không tìm thấy cấu hình.
- Giữ behavior nhiều VAT thật + CKTM như hiện tại: fail import, chưa chuyển sang warning-only.

## Service Import GTGT

- Điều kiện chuyển service nền giữ nguyên: GTGT có `soLuongHangHoa > 50`, `ENABLE_IMPORT_SERVICE = 1`, queue `TypeHd == gtgt`.
- Service nền dùng cùng rule group `HD_ThueSuat` theo `MaThue + MucThue`.
- Không sửa service/helper ngoài scope GTGT nếu không liên quan.

## Cross Reference

- Generic FE discount edit recalculation được tách sang task `CBCLOUDV2-8332`.
- Task `CBCLOUDV2-8393` chỉ giữ scope import/gom nhóm thuế suất và các note import liên quan.
## Import Nền - Plan Đồng Bộ

### Mục tiêu

- Đồng bộ `svinvoicesendemail` với Cloud cho 2 luồng: GTGT service nền và VE_XE service nền.
- Giữ nguyên public contract, DB schema, XML, ký số, truyền CQT, báo cáo, bảng kê.
- Code nền đã sync; chỉ chốt hoàn tất khi GTGT > 50 dòng và VE_XE nền pass test manual theo cùng rule với Cloud.

### GTGT Service Nền

- Đối chiếu `D:\XBill\Cloud\svinvoicesendemail\AppServiceImportBillHost\AppService\Service\NhapDSHoaDonExcelHelper.cs` với Cloud.
- Sửa helper summary thuế để group `HD_ThueSuat` theo `MaThue + MucThue`.
- Bỏ phụ thuộc vào `HangHoa_TenThue` khi gom summary.
- Dòng âm/CKTM/chiết khấu cùng mã thuế phải cộng vào đúng group.
- `TongTien_ChiuThue` và `TongTien_Thue` phải lấy từ dữ liệu import/lưu, không tự tính lại theo VAT%.
- `TenThue` ưu tiên danh mục thuế Admin, fallback tên import nếu thiếu cấu hình.

### VE_XE Service Nền

- Đối chiếu `D:\XBill\Cloud\svinvoicesendemail\AppServiceImportBillHost\AppService\Service\ImportVeXeHelper.cs` với Cloud.
- Sửa mapping `Tính chất = 5` sang `Chiết khấu` đúng rule hiện tại, không còn coi là khuyến mại.
- Tách rõ hai vùng dữ liệu: chi tiết lưu riêng, summary bên trái tự cộng dồn theo thuế suất.
- Kiểm tra lại `Tien thue chi tiet` để không bị tính ngược khi file đã có giá trị.
- Giữ các tổng bên phải theo dữ liệu import, không để summary bên trái ghi đè ngược.

### Trình tự thực hiện

1. Đồng bộ GTGT service nền trước.
2. Đồng bộ VE_XE service nền sau.
3. Chạy manual regression riêng cho từng luồng.
4. Cập nhật `testcase.md` và `report.md` khi có kết quả thật.

## Update 2026-08-03 - Service Sync Guardrails

- Trước khi sync sang service khác, đối chiếu các điểm đã fix trong Cloud/service nền hiện tại:
  - group `HD_ThueSuat` theo `HangHoa_MaThue + HangHoa_Thue`;
  - bỏ `HangHoa_TenThue` khỏi key group;
  - `TongTien_ChiuThue` và `TongTien_Thue` chỉ sum dữ liệu import/lưu;
  - right-side totals có input thì preserve, blank thì fallback sau khi build `HD_ThueSuat`;
  - discount/CKTM không được làm summary bị trừ hai lần;
  - nhiều VAT thật + CKTM giữ behavior fail import hiện tại nếu chưa có scope mới.
- Cross-check FE import-discount edit/preserve ở `CBCLOUDV2-8332` sau khi service sync, vì service đúng nhưng FE vẫn có thể gửi payload sai khi user save lại.

## Update 2026-09-04 - Decimal(21,7) Max Value

### Mục tiêu

- Sửa lỗi import Excel báo max length/quá lớn khi nhập các trường số.
- Áp dụng cho cả import đồng bộ trong `invoicecore` và import nhiều dòng qua worker `svinvoicesendemail/AppServiceImportBillHost`.
- Số lượng, Đơn giá, Thành tiền dùng giá trị tối đa trực tiếp của `DECIMAL(21,7)`: `99999999999999.9999999`.
- Tỷ giá dùng rule riêng: tối đa 7 số nguyên và 6 số thập phân, max `9999999.999999`.

### Phạm vi code

- `invoicecore/aspnet-core/src/hddt/HDDT.Application/Commons/HoaDon/ExcelHelpers/NhapDSHoaDonExcelHelper.cs`:
  - Số lượng, Số lượng thực xuất, Số lượng thực nhập, Đơn giá, Giá vé, Thành tiền theo max `DECIMAL(21,7)`.
  - Tỷ giá theo rule 7 số nguyên và 6 số thập phân.
- `invoicecore/aspnet-core/src/hddt/HDDT.Application/Commons/HoaDon/ExcelHelpers/NewCa/ExcelNewCaHelper.cs`:
  - Số lượng, Đơn giá, Thành tiền.
- `svinvoicesendemail/AppServiceImportBillHost/AppService/Service/NhapDSHoaDonExcelHelper.cs`:
  - Số lượng, Đơn giá, Thành tiền theo max `DECIMAL(21,7)`; Tỷ giá theo rule 7 số nguyên và 6 số thập phân.
- `svinvoicesendemail/AppServiceImportBillHost/AppService/Service/BanHang_ExcelHelper.cs`:
  - Số lượng, Đơn giá, Thành tiền theo max `DECIMAL(21,7)`; Tỷ giá theo rule 7 số nguyên và 6 số thập phân.
- `svinvoicesendemail/AppServiceImportBillHost/AppService/Service/ImportVeXeHelper.cs`:
  - Số lượng, Đơn giá, Thành tiền theo max `DECIMAL(21,7)`; Tỷ giá theo rule 7 số nguyên và 6 số thập phân.
- `svinvoicesendemail/AppServiceImportBillHost/AppService/Service/PhieuXuatKhoExcelHelper.cs`:
  - Số lượng thực xuất, Số lượng thực nhập, Đơn giá, Thành tiền.

### Ngoài phạm vi

- Không đổi DB schema/migration/backfill.
- Không đổi logic làm tròn/scale đang có.
- Không đổi công thức tính tiền, group `HD_ThueSuat`, XML, ký số, gửi CQT, báo cáo hoặc export.
- Không sửa Tỷ giá trong worker Phiếu xuất kho vì helper hiện không parse/gán `tygiatiente`.

### Verification plan

- Build `invoicecore` project `HDDT.Application`.
- Build worker project `AppServiceImportBillHost/AppService.csproj`.
- Manual test boundary value `99999999999999.9999999` và over-bound value `100000000000000` cho Số lượng/Đơn giá/Thành tiền trên cả import trực tiếp và import nhiều dòng.
- Manual test Tỷ giá với boundary `9999999.999999`; values quá 7 số nguyên hoặc quá 6 số thập phân phải bị chặn.
