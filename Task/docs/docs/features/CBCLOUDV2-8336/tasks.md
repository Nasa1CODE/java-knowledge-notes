# CBCLOUDV2-8336 Tasks

## Task 1 - Review fix Thành tiền/Tỷ lệ tính thuế cho dòng Ghi chú (invoicecore)

- Status: pending
- Area/service: `invoicecore/`
- Description: Đọc lại toàn bộ `ValidateAndGetData_BH` trong `NhapDSHoaDonExcelHelper.cs` (đoạn uncommitted hiện có, dòng ~7709-7734) và phần code build kết quả phía sau trong cùng hàm để xác nhận không có tác dụng phụ khi `data.thanhtien`/`data.TyLeTinhThue` là `null` cho dòng `loaihanghoa == 2`. Giữ nguyên nếu đúng, chỉnh nếu phát hiện lỗi.
- Acceptance criteria:
  - [ ] Dòng Ghi chú không nhập Thành tiền → không có lỗi "Thành tiền không được để trống.".
  - [ ] Dòng Ghi chú nhập Thành tiền = 0 → không có lỗi.
  - [ ] Dòng Ghi chú không nhập Tỷ lệ tính thuế trên doanh thu → không có lỗi định dạng.
  - [ ] Dòng hàng hóa thường (`loaihanghoa != 2`) vẫn bị báo lỗi như cũ khi thiếu Thành tiền/Tỷ lệ tính thuế sai định dạng (regression).
  - [ ] Không có `NullReferenceException`/tính sai tổng tiền khi build `HD_ChiTiet`/`HD_HoaDon` cho dòng Ghi chú.
- Verification:
  - [ ] `dotnet build "d:\Source\billcloud\invoicecore\aspnet-core\src\hddt\HDDT.Application\HDDT.Application.csproj" --nologo -v:minimal` → `Build succeeded. 0 Error(s).`
  - [ ] Test thủ công: nhập file Excel mẫu C26TNT (≤50 dòng, đường trực tiếp) theo 4 acceptance criteria trên.
- Dependencies: None
- Likely touched files:
  - `invoicecore/aspnet-core/src/hddt/HDDT.Application/Commons/HoaDon/ExcelHelpers/NhapDSHoaDonExcelHelper.cs`
- Estimated scope: S

## Task 2 - Review fix Thành tiền/Tỷ lệ tính thuế cho dòng Ghi chú (svinvoicesendemail worker)

- Status: pending
- Area/service: `svinvoicesendemail/`
- Description: Đọc lại toàn bộ `ValidateAndGetData` trong `AppServiceImportBillHost/AppService/Service/BanHang_ExcelHelper.cs` (đoạn uncommitted hiện có, dòng ~776-803) và phần code build kết quả (`GetHoaDon`/`GetChiTiet` tương ứng trong cùng file, có tính `SoTien406ChiTiet` dựa trên `TyLeTinhThue`) để xác nhận không có tác dụng phụ khi các trường là `null` cho dòng Ghi chú.
- Acceptance criteria:
  - [ ] Cùng 4 tiêu chí như Task 1, áp dụng cho đường xử lý qua queue/worker (file Excel >50 dòng hoặc `ENABLE_IMPORT_SERVICE` bật).
  - [ ] `SoTien406ChiTiet` không tính sai/không throw exception khi `TyLeTinhThue` là `null` cho dòng Ghi chú.
- Verification:
  - [ ] `dotnet build "d:\Source\billcloud\svinvoicesendemail\AppServiceImportBillHost\AppService\AppService.csproj" --nologo -v:minimal` → `Build succeeded. 0 Error(s).`
  - [ ] Test thủ công: nhập file Excel mẫu C26TNT (>50 dòng, đường queue/worker) theo các tiêu chí trên.
- Dependencies: None
- Likely touched files:
  - `svinvoicesendemail/AppServiceImportBillHost/AppService/Service/BanHang_ExcelHelper.cs`
- Estimated scope: S

## Task 3 - (Tùy chọn, chờ TechLead xác nhận scope) Đổi int.Parse thành int.TryParse cho Tỷ lệ tính thuế

- Status: pending
- Area/service: `invoicecore/` và `svinvoicesendemail/`
- Description: Ở cả 2 file, nhánh `else if (!string.IsNullOrWhiteSpace(tyLeTinhThue)) data.TyLeTinhThue = int.Parse(tyLeTinhThue);` có thể throw `FormatException` không được bắt nếu dòng Ghi chú nhập dữ liệu không hợp lệ (không rỗng, không match `^[0-5]$`, không phải số). Đổi sang `int.TryParse` và trả thông báo lỗi hợp lệ khi parse thất bại. **Chỉ thực hiện nếu TechLead xác nhận đưa vào scope ticket này** (xem Open Questions trong `expect.md`).
- Acceptance criteria:
  - [ ] Dòng Ghi chú nhập giá trị không hợp lệ (không rỗng, không phải số 0-5) vào cột Tỷ lệ tính thuế → trả về thông báo lỗi định dạng, không crash.
  - [ ] Hành vi hiện tại (dòng thường, dòng Ghi chú với giá trị hợp lệ hoặc rỗng) không đổi.
- Verification:
  - [ ] `dotnet build` cả 2 project như Task 1/2 → 0 lỗi.
  - [ ] Test thủ công: nhập ký tự chữ vào cột Tỷ lệ tính thuế cho dòng Ghi chú → nhận thông báo lỗi, không lỗi 500.
- Dependencies: Task 1, Task 2 (cần tồn tại đúng vị trí code trước)
- Likely touched files:
  - `invoicecore/aspnet-core/src/hddt/HDDT.Application/Commons/HoaDon/ExcelHelpers/NhapDSHoaDonExcelHelper.cs`
  - `svinvoicesendemail/AppServiceImportBillHost/AppService/Service/BanHang_ExcelHelper.cs`
- Estimated scope: S

## Task 5 - Review fix Đơn vị tính/Số lượng/Đơn giá/Thành tiền/VAT/Tiền thuế chi tiết cho dòng Ghi chú, mẫu ký hiệu 5 - vé xe (invoicecore)

- Status: pending
- Area/service: `invoicecore/`
- Description: Đọc lại toàn bộ `ValidateAndGetData_VeXe` trong `NhapDSHoaDonExcelHelper.cs` (đoạn uncommitted hiện có, dòng ~9220-9310) và downstream `GetChiTiet_VeXe`/`GetHoaDon_VeXe` để xác nhận không có tác dụng phụ. Đã đọc và xác nhận an toàn trong giai đoạn planning (xem `plan.md` Impact Assessment). Scope đã được user xác nhận (mẫu ký hiệu 5).
- Acceptance criteria:
  - [ ] Dòng Ghi chú không nhập Đơn vị tính/Số lượng/Đơn giá/Thành tiền/VAT/Tiền thuế chi tiết → không có lỗi tương ứng.
  - [ ] Dòng hàng hóa thường (`loaihanghoa != 2`) vẫn bị báo lỗi như cũ khi thiếu các trường trên (regression).
  - [ ] Không có `NullReferenceException`/tính sai tổng tiền khi build `HD_ChiTiet`/`HD_HoaDon` cho dòng Ghi chú.
- Verification:
  - [ ] `dotnet build "d:\Source\billcloud\invoicecore\aspnet-core\src\hddt\HDDT.Application\HDDT.Application.csproj" --nologo -v:minimal` → `Build succeeded. 0 Error(s).`
  - [ ] Test thủ công: nhập file Excel mẫu vé xe (ký hiệu 5, đường trực tiếp) theo các tiêu chí trên.
- Dependencies: None
- Likely touched files:
  - `invoicecore/aspnet-core/src/hddt/HDDT.Application/Commons/HoaDon/ExcelHelpers/NhapDSHoaDonExcelHelper.cs`
- Estimated scope: S

## Task 6 - Review fix tương tự Task 5 cho mẫu ký hiệu 5 - vé xe (svinvoicesendemail worker)

- Status: pending
- Area/service: `svinvoicesendemail/`
- Description: Đọc lại toàn bộ `ValidateAndGetData` trong `AppServiceImportBillHost/AppService/Service/ImportVeXeHelper.cs` (đoạn uncommitted hiện có, dòng ~854-923) và downstream `HoaDonHelper.GetChiTiet`/`GetHoaDon` để xác nhận không có tác dụng phụ. Đã đọc và xác nhận an toàn trong giai đoạn planning.
- Acceptance criteria:
  - [ ] Cùng tiêu chí như Task 5, áp dụng cho đường xử lý qua queue/worker.
- Verification:
  - [ ] `dotnet build "d:\Source\billcloud\svinvoicesendemail\AppServiceImportBillHost\AppService\AppService.csproj" --nologo -v:minimal` → `Build succeeded. 0 Error(s).`
  - [ ] Test thủ công: nhập file Excel mẫu vé xe (ký hiệu 5, >50 dòng hoặc import-service bật, đường queue/worker) theo các tiêu chí trên.
- Dependencies: None
- Likely touched files:
  - `svinvoicesendemail/AppServiceImportBillHost/AppService/Service/ImportVeXeHelper.cs`
- Estimated scope: S

## Task 4 - Hoàn thiện tài liệu feature

- Status: pending
- Area/service: `docs/`
- Description: Sau khi Task 1-3, 5-6 (nếu được chấp thuận) hoàn tất và build/test xong, cập nhật `impact.md` (finalize), tạo `testcase.md` theo Rule 03, và tạo `report.md` theo Rule 02 với kết quả build/test thực tế.
- Acceptance criteria:
  - [ ] `impact.md` phản ánh đúng danh sách file đã đổi thực tế và các hạn chế/rủi ro còn tồn đọng.
  - [ ] `report.md` chứa output build thực tế (không tự bịa kết quả).
  - [ ] `testcase.md` bao phủ đủ Acceptance Criteria trong `expect.md`.
- Verification:
  - [ ] Review chéo giữa `expect.md`/`plan.md`/`report.md`/`impact.md` không có mâu thuẫn.
- Dependencies: Task 1, Task 2, Task 3 (nếu được chấp thuận), Task 5, Task 6
- Likely touched files:
  - `docs/features/CBCLOUDV2-8336/impact.md`
  - `docs/features/CBCLOUDV2-8336/report.md`
  - `docs/features/CBCLOUDV2-8336/testcase.md`
- Estimated scope: XS
