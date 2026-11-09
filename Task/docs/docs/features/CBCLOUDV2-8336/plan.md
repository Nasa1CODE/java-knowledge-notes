# CBCLOUDV2-8336 Plan

## Status

- Status: plan-review (chờ Gate 1: DEV review + TechLead approve)
- `git pull` trong `docs/` chưa xác nhận thành công trong phiên làm việc này do lỗi công cụ shell — cần user tự xác nhận `docs/` đã cập nhật trước khi duyệt Gate 1.
- Code thay đổi thực tế đã tồn tại dưới dạng **uncommitted working-tree changes** ở 2 file (không phải do AI viết trong phiên này — đã được viết từ trước, phiên này chỉ đọc/review/đối chiếu và lập plan chính thức). Chưa build, chưa test.

## Goal

Cho phép dòng hàng hóa có tính chất "Ghi chú" (`loaihanghoa == 2`) trong file Excel nhập danh sách hóa đơn mẫu C26TNT (bán hàng, `LoaiHoaDonMau.banhang = 2`) không bị bắt buộc nhập **Thành tiền** và **Tỷ lệ tính thuế trên doanh thu**, theo `expect.md`.

**Xác nhận scope (user, 2026-07-17)**: ticket chính thức ảnh hưởng 2 mẫu hóa đơn theo ký hiệu mẫu số hiển thị — **ký hiệu 2** (bán hàng/C26TNT) và **ký hiệu 5** (vé xe). Mẫu ký hiệu 5 bỏ bắt buộc Đơn vị tính/Số lượng/Đơn giá/Thành tiền/VAT/Tiền thuế chi tiết cho dòng Ghi chú — rộng hơn mẫu ký hiệu 2 (chỉ Thành tiền/Tỷ lệ tính thuế). Lưu ý: mã loại nội bộ dùng route code của mẫu vé xe là `LoaiHoaDonMau.vexe = 6` trong `EnumCommons.cs`, khác với ký hiệu mẫu số hiển thị `5` — không nhầm lẫn 2 giá trị này khi đọc code.

## Context

- `docs/AGENTS.md`: `invoicecore/` (backend `HDDT.Application`) và `svinvoicesendemail/` (worker import/export/print/XML, tên git repo/README ghi "email sending" nhưng source thực tế không phải vậy) là 2 canonical folder liên quan.
- Không có mục trong `docs/architecture.md`/`docs/design.md`/`docs/specs/` mô tả riêng luồng nhập Excel hóa đơn theo mẫu C26TNT ở mức chi tiết cột/dòng — plan này dựa trên đọc trực tiếp source code (đã đọc `NhapDSHoaDonExcelHelper.cs` và `BanHang_ExcelHelper.cs`).
- Luồng nhập Excel mẫu C26TNT có 2 đường xử lý song song tùy số dòng và cấu hình import-service:
  1. Đường trực tiếp: `HoaDonAppService` (invoicecore) → `NhapDSHoaDonExcelHelper.ImportExcelFile_BH` → `ValidateAndGetData_BH`.
  2. Đường queue/worker: `HoaDonAppService` gửi `ImportHoaDonData` qua RabbitMQ (`SendQueueMessage.SendImportData`, queue `QueueImportHoaDon`) → `svinvoicesendemail/AppServiceImportBillHost` xử lý bằng `BanHang_ExcelHelper.ValidateAndGetData`.
- Cả hai hàm có cấu trúc code gần như song song (copy-paste giữa 2 repo), cùng đọc cột 29 (Thành tiền) và cột 38 (Tỷ lệ tính thuế trên doanh thu).

## Assumptions / Open Questions / Out Of Scope

Đã liệt kê đầy đủ trong `expect.md` (mục Assumptions/Open Questions/Out Of Scope/Known Risk). Nhắc lại các điểm ảnh hưởng trực tiếp đến cách triển khai:

- **Chưa xác nhận với BA**: khi Ghi chú nhập Thành tiền = 0 một cách chủ động, `data.thanhtien` sẽ giữ `null` (không lưu 0) vì toàn bộ block bị bỏ qua khi `loaihanghoa == 2`. Plan này giữ nguyên hành vi đã viết (bỏ qua hoàn toàn), không tự ý đổi thành "lưu giá trị nếu có nhập". Cần BA xác nhận trước khi chốt.
- **Chưa xác nhận với BA/TechLead**: có đưa việc đổi `int.Parse` → `int.TryParse` (rủi ro crash `FormatException` khi Ghi chú nhập rác vào cột tỷ lệ thuế) vào scope ticket này không. Plan này đề xuất đưa vào scope (Task 3) vì cùng file, cùng đoạn code, rủi ro thấp, chi phí sửa nhỏ — nhưng cần TechLead xác nhận tại Gate 1.
- Out of scope: các mẫu hóa đơn khác, các bản sao `ValidateAndGetData`/`ValidateAndGetData_THUOC`/`ValidateAndGetData_NUOC`/... đã có exemption từ trước hoặc không áp dụng khái niệm này (đã liệt kê chi tiết trong `expect.md`).

## Impact Assessment

### Backend — invoicecore (đường nhập Excel trực tiếp)

| Hàm | File | Trạng thái hiện tại (uncommitted) |
| --- | --- | --- |
| `ValidateAndGetData_BH` (mẫu ký hiệu 2 - bán hàng) | `invoicecore/aspnet-core/src/hddt/HDDT.Application/Commons/HoaDon/ExcelHelpers/NhapDSHoaDonExcelHelper.cs` (dòng ~7709-7734) | Đã sửa: thêm `&& data.loaihanghoa != 2` vào 2 nhánh kiểm tra Thành tiền; đổi `else` → `else if (!string.IsNullOrWhiteSpace(tyLeTinhThue))` cho Tỷ lệ tính thuế |
| `ValidateAndGetData_VeXe` (mẫu ký hiệu 5 - vé xe) | Cùng file (dòng ~9220-9310) | Đã sửa: thêm `&& data.loaihanghoa != 2` / `else if (data.loaihanghoa != 2)` cho Đơn vị tính, Số lượng, Đơn giá, Thành tiền, VAT, Tiền thuế chi tiết |

### Backend — svinvoicesendemail (đường nhập Excel qua queue/worker)

| Hàm | File | Trạng thái hiện tại (uncommitted) |
| --- | --- | --- |
| `ValidateAndGetData` (mẫu ký hiệu 2 - bán hàng) | `svinvoicesendemail/AppServiceImportBillHost/AppService/Service/BanHang_ExcelHelper.cs` (dòng ~776-803) | Đã sửa: cùng pattern với `invoicecore`, thêm `&& data.loaihanghoa != 2` và đổi `else` → `else if (!string.IsNullOrWhiteSpace(...))` |
| `ValidateAndGetData` (mẫu ký hiệu 5 - vé xe) | `svinvoicesendemail/AppServiceImportBillHost/AppService/Service/ImportVeXeHelper.cs` (dòng ~854-923) | Đã sửa: cùng pattern với `ValidateAndGetData_VeXe` ở invoicecore |

### Downstream builders đã kiểm tra an toàn (không cần sửa)

| File | Hàm | Kết luận |
| --- | --- | --- |
| `invoicecore/.../NhapDSHoaDonExcelHelper.cs` | `GetChiTiet_BH`, `GetHoaDon_BH` | Dùng `data.thanhtien ?? 0`, `data.dongia > 0 ? ... : null` — an toàn với `null` |
| `invoicecore/.../NhapDSHoaDonExcelHelper.cs` | `GetChiTiet_VeXe`, `GetHoaDon_VeXe` | Tương tự, dùng `?? 0`/kiểm tra `> 0` trước khi gán — an toàn |
| `svinvoicesendemail/.../BanHang_ExcelHelper.cs` | `GetChiTiet`, `GetHoaDon` | Cùng pattern `?? 0`/`> 0 ? ... : null` — an toàn |
| `svinvoicesendemail/.../HoaDonHelper.cs` (dùng bởi `ImportVeXeHelper`) | `GetChiTiet` | `data.dongia > 0 ? ... : null`, `data.thanhtien ?? 0` — an toàn; `int? thue * decimal? thanhtien` tự propagate `null` không throw |

### Database

- Không có thay đổi schema. Không có migration.

### Config / Queue

- Không có thay đổi config hoặc cấu trúc queue. Vẫn dùng `QueueImportHoaDon` hiện tại, không đổi payload `ImportHoaDonData`.

### Frontend

- Không cần thay đổi. Đây là validate phía backend, UI nhập Excel không đổi.

### Không thuộc phạm vi (confirmed unaffected)

- `NhapDSHoaDonExcelHelper.ValidateAndGetData` (mẫu giá trị gia tăng) — đã có `if (data.loaihanghoa != 2)` bọc toàn bộ block từ trước.
- `svinvoicesendemail/AppServiceImportBillHost/AppService/Service/NhapDSHoaDonExcelHelper.cs` (bản sao mẫu giá trị gia tăng cho worker) — đã có `if (data.loaihanghoa != 2)` bọc từ trước.
- `ExcelNewCaHelper.cs` — không có field `loaihanghoa`, không áp dụng.
- `ValidateAndGetData_THUOC`, `ValidateAndGetData_NUOC`, `ValidateAndGetData_PhieuXuatKho`, `ValidateAndGetData_TaiSanCong` và các hàm mẫu khác trong cùng file `invoicecore` — không có cột "Loại hàng hóa"/"Tỷ lệ tính thuế trên doanh thu" theo layout này.
- `api-cloud-service`, `api-qldv-service` (GuiHoaDonAppService, InvoiceValidation.cs) — đây là validate cho luồng gửi hóa đơn qua API/XML, không phải luồng nhập Excel danh sách hóa đơn, không cùng cơ chế `loaihanghoa`.

## Dependency & Implementation Order

4 file độc lập nhau về mặt compile (2 repo, 2 mẫu hóa đơn khác nhau), nhưng chia thành 2 cặp theo mẫu hóa đơn — mỗi cặp (invoicecore + svinvoicesendemail) cùng chung 1 business rule và cùng phải được review/build/verify đồng thời vì cùng phục vụ 1 mẫu hóa đơn (chỉ khác route theo số dòng dữ liệu):
- Cặp 1 (mẫu bán hàng): `ValidateAndGetData_BH` + `BanHang_ExcelHelper.ValidateAndGetData`.
- Cặp 2 (mẫu vé xe): `ValidateAndGetData_VeXe` + `ImportVeXeHelper.ValidateAndGetData`.

Không có thứ tự phụ thuộc bắt buộc giữa các cặp — có thể làm song song. Task 3 (đổi `TryParse`) chỉ áp dụng cho cặp 1 (mẫu bán hàng có cột Tỷ lệ tính thuế; mẫu vé xe không có cột này) và phụ thuộc vào Task 1/2 đã tồn tại đúng vị trí code.

## Implementation Approach

### Task 1 — Review & xác nhận fix `ValidateAndGetData_BH` (invoicecore, mẫu bán hàng)

Code đã tồn tại uncommitted. Đã đọc lại toàn bộ hàm và downstream `GetChiTiet_BH`/`GetHoaDon_BH` — xác nhận an toàn (xem Impact Assessment). Việc còn lại: build + test thủ công.

### Task 2 — Review & xác nhận fix `ValidateAndGetData` (svinvoicesendemail, BanHang_ExcelHelper.cs, mẫu bán hàng)

Tương tự Task 1, áp dụng cho bản sao trong worker. Đã đọc `GetHoaDon`/`GetChiTiet` trong cùng file — an toàn (dùng `?? 0`, `> 0 ? ... : null`).

### Task 3 (tùy chọn, chờ TechLead quyết định scope) — Đổi `int.Parse` → `int.TryParse` cho Tỷ lệ tính thuế ở 2 file mẫu bán hàng

Tránh crash `FormatException` không được bắt khi dòng Ghi chú nhập dữ liệu rác (không rỗng, không hợp lệ) vào cột Tỷ lệ tính thuế trên doanh thu. Chỉ áp dụng cho mẫu bán hàng (mẫu vé xe không có cột này).

### Task 5 — Review & xác nhận fix `ValidateAndGetData_VeXe` (invoicecore, mẫu ký hiệu 5 - vé xe)

Scope đã xác nhận (user). Đã đọc lại toàn bộ hàm và downstream `GetChiTiet_VeXe`/`GetHoaDon_VeXe` — an toàn.

### Task 6 — Review & xác nhận fix `ValidateAndGetData` (svinvoicesendemail, ImportVeXeHelper.cs, mẫu ký hiệu 5 - vé xe)

Tương tự Task 5, áp dụng cho worker. Đã đọc `HoaDonHelper.GetChiTiet` (dùng chung bởi `ImportVeXeHelper`) — an toàn.

### Task 4 — Cập nhật tài liệu

Hoàn thiện `impact.md`, chuẩn bị `testcase.md` (Rule 03) sau khi Gate 1 approve, chuẩn bị `report.md` sau khi build/test xong (Rule 02).

## Verification Plan

- Build invoicecore:
  - `dotnet build "d:\Source\billcloud\invoicecore\aspnet-core\src\hddt\HDDT.Application\HDDT.Application.csproj" --nologo -v:minimal`
  - Kỳ vọng: `Build succeeded. 0 Error(s).`
- Build worker svinvoicesendemail:
  - `dotnet build "d:\Source\billcloud\svinvoicesendemail\AppServiceImportBillHost\AppService\AppService.csproj" --nologo -v:minimal`
  - Kỳ vọng: `Build succeeded. 0 Error(s).`
- Manual test (theo `expect.md` Acceptance Criteria, cần môi trường thực/staging, không thể tự chạy trong phiên này):
  - Nhập Excel mẫu C26TNT với dòng Ghi chú không nhập Thành tiền → không có lỗi "Thành tiền không được để trống.", hóa đơn tạo thành công.
  - Nhập Excel mẫu C26TNT với dòng Ghi chú nhập Thành tiền = 0 → không có lỗi, hóa đơn tạo thành công.
  - Nhập Excel mẫu C26TNT với dòng Ghi chú không nhập Tỷ lệ tính thuế → không có lỗi định dạng, hóa đơn tạo thành công.
  - Lặp lại với file có >50 dòng (hoặc bật `ENABLE_IMPORT_SERVICE`) để bắt buộc đi qua đường queue/worker, xác nhận hành vi giống đường trực tiếp.
  - Nhập Excel mẫu C26TNT với dòng hàng hóa thường (`loaihanghoa != 2`) không nhập Thành tiền → vẫn phải báo lỗi như cũ (regression check).
  - (Nếu Task 3 được chấp thuận) Nhập dữ liệu rác (chữ) vào cột Tỷ lệ tính thuế cho dòng Ghi chú → phải trả về thông báo lỗi hợp lệ, không crash 500.
  - Nhập Excel mẫu vé xe (ký hiệu 5) với dòng Ghi chú không nhập Đơn vị tính/Số lượng/Đơn giá/Thành tiền/VAT/Tiền thuế chi tiết → không có lỗi, hóa đơn tạo thành công. Lặp lại cho cả đường trực tiếp và đường queue/worker.
  - Nhập Excel mẫu vé xe với dòng hàng hóa thường (`loaihanghoa != 2`) thiếu các trường trên → vẫn phải báo lỗi như cũ (regression check).

## Risk Matrix

| Risk | Impact | Mitigation | Rollback |
| --- | --- | --- | --- |
| `data.thanhtien`/`data.TyLeTinhThue` = null cho dòng Ghi chú gây lỗi khi tính tổng tiền hóa đơn ở bước sau (build `HD_ChiTiet`, tổng hợp `HD_HoaDon`) | Trung bình — có thể sai số liệu hoặc lỗi runtime nếu code sau không kiểm tra null | Đọc kỹ toàn bộ hàm build kết quả ở cả 2 file (Task 1/2) trước khi coi là hoàn tất | Revert 2 đoạn sửa, quay về validate bắt buộc như cũ |
| `int.Parse` crash khi dòng Ghi chú nhập rác vào cột tỷ lệ thuế | Thấp-Trung bình — lỗi 500 không thân thiện, nhưng chỉ xảy ra khi user chủ động nhập sai | Task 3 (tùy chọn theo quyết định TechLead) đổi sang `TryParse` | Không cần rollback riêng, đây là fix bổ sung |
| 2 file (invoicecore/svinvoicesendemail) lệch nhau nếu chỉ sửa 1 bên trong tương lai (duplicate code, không share) | Trung bình — hành vi khác nhau tùy số dòng file Excel, khó phát hiện qua test thủ công (test <50 dòng sẽ không phát hiện lỗi ở đường queue) | Ghi rõ trong `impact.md`/`report.md` rằng đây là code trùng lặp giữa 2 repo, mọi thay đổi validate loại này cần áp dụng đồng thời cả 2 nơi | N/A — rủi ro kiến trúc có sẵn, không phải do ticket này tạo ra |
| Chưa xác nhận `git pull` trong `docs/` thành công trong phiên này | Thấp — có thể làm việc trên tài liệu cũ nếu có người khác đã cập nhật `docs/` | User cần tự chạy `git -C d:\Source\billcloud\docs pull` và xác nhận trước khi duyệt Gate 1 | N/A |

## Deployment Notes

- Không cần deploy.md — không có thay đổi database, config, hoặc environment.
- Deploy tiêu chuẩn: build & deploy `invoicecore` (HDDT.Application) và `svinvoicesendemail/AppServiceImportBillHost` (worker service) theo quy trình hiện có.

## Rollback

- Revert 2 đoạn sửa trong `NhapDSHoaDonExcelHelper.cs` (invoicecore) và `BanHang_ExcelHelper.cs` (svinvoicesendemail) về bản gốc (bỏ điều kiện `&& data.loaihanghoa != 2`, đổi `else if` về lại `else`).
- Không có dữ liệu cần rollback vì đây chỉ là thay đổi validate, không có migration.
