# CBCLOUDV2-8336 Expect

## Feature Status

- Status: draft
- Class: Small (bug fix)
- Source: Bug report từ BA/QA, môi trường demo `https://demo.cyberbill.vn`

## Pre-condition (theo báo cáo lỗi)

- URL: `https://demo.cyberbill.vn/app/hddt/hoadon-danhsachhoadon`
- Tài khoản test: `0105232093-999` (không ghi lại thông tin đăng nhập nhạy cảm trong tài liệu)

## Xác nhận scope (user, 2026-07-17)

Ticket ảnh hưởng **2 mẫu hóa đơn** theo ký hiệu mẫu số hiển thị cho người dùng:
- **Ký hiệu 2** — bán hàng (C26TNT). Mã loại nội bộ dùng để route code là `LoaiHoaDonMau.banhang = 2` trong `EnumCommons.cs`, khớp với ký hiệu hiển thị.
- **Ký hiệu 5** — vé xe. Lưu ý: mã loại nội bộ dùng để route code (`LoaiHoaDonMau.vexe = 6`) khác với ký hiệu mẫu số hiển thị (`5`) — xác nhận qua `frontend_angular/.../hoadon-goc.component.html` dùng điều kiện `loaiHoaDon_MauSo == '5' && loai_HD_DacThu == 'VE_XE'`. Không nhầm với giá trị enum `6`.

Đây thay thế Open Question 5 (đã đóng) — mẫu vé xe **chính thức thuộc scope**, không cần chờ xác nhận thêm.

## Steps To Reproduce

1. Hóa đơn > Danh sách hóa đơn > Danh sách hóa đơn.
2. Click Tạo mới > chọn mẫu hóa đơn `2 - C26TNT` (ký hiệu 2, bán hàng) > chọn checkbox nhập Excel.
3. Upload file Excel mẫu (`HoadonBH_FileMau (2).xlsx`) có dòng hàng hóa với **Loại hàng hóa = Ghi chú** (`loaihanghoa = 2` / cột "Tính chất hàng hóa" giá trị `2`) > Click Tạo hóa đơn.

(Bug report gốc chỉ mô tả mẫu ký hiệu 2; mẫu ký hiệu 5 - vé xe - được xác nhận bổ sung vào scope, cùng cơ chế `loaihanghoa == 2`.)

## Actual Result (bug)

Với dòng hàng hóa Ghi chú (`loaihanghoa == 2`):
- Không nhập **Thành tiền**, hoặc nhập **Thành tiền = 0** → hệ thống vẫn hiển thị lỗi "Thành tiền không được để trống." / lỗi định dạng.
- Không nhập **Tỷ lệ tính thuế trên doanh thu** (áp dụng cho hóa đơn bán hàng) → hệ thống vẫn hiển thị lỗi "Tỷ lệ tính thuế trên doanh thu không đúng định dạng."

Kỳ vọng: hàng hóa loại Ghi chú không bắt buộc nhập hai trường này, import phải thành công.

## Root Cause Analysis (đã xác nhận qua đọc source, `git pull` trong `docs/` chưa kiểm chứng được trong phiên làm việc này do lỗi công cụ shell — cần xác nhận thủ công trước khi duyệt Gate 1)

Luồng nhập Excel mẫu C26TNT (`banhang = 2`) đi qua 2 code path song song, tùy số lượng dòng hàng hóa và cấu hình `ENABLE_IMPORT_SERVICE`:

1. **Đường trực tiếp (≤50 dòng hoặc import-service tắt)**: `HoaDonAppService.NhapExcel` → `NhapDSHoaDonExcelHelper.ImportExcelFile_BH` → `ValidateAndGetData_BH` (file `invoicecore/aspnet-core/src/hddt/HDDT.Application/Commons/HoaDon/ExcelHelpers/NhapDSHoaDonExcelHelper.cs`, quanh dòng 7705-7733).
2. **Đường queue/worker (>50 dòng và import-service bật)**: `HoaDonAppService.NhapExcel` gửi `ImportHoaDonData` qua RabbitMQ (`SendQueueMessage.SendImportData`) → xử lý bởi `svinvoicesendemail/AppServiceImportBillHost/AppService/Service/BanHang_ExcelHelper.cs` → `ValidateAndGetData` (quanh dòng 776-803).

Cả hai hàm validate đều có logic giống nhau: kiểm tra bắt buộc "Thành tiền" và định dạng "Tỷ lệ tính thuế trên doanh thu" (cột 29 và cột 38) **không loại trừ trường hợp `loaihanghoa == 2`** (Ghi chú) trong bản gốc.

**Hiện trạng đã sửa (uncommitted, chưa qua review/Gate 1) tại cả hai file** theo cùng một pattern:
- Thêm điều kiện `&& data.loaihanghoa != 2` vào 2 nhánh kiểm tra bắt buộc/định dạng của "Thành tiền".
- Đổi `else` thành `else if (!string.IsNullOrWhiteSpace(tyLeTinhThue))` cho "Tỷ lệ tính thuế", tránh gọi `int.Parse` trên chuỗi rỗng, đồng thời bỏ qua kiểm tra định dạng khi `loaihanghoa == 2`.

**Phát hiện thêm khi soát lại toàn bộ `git diff` (không chỉ đọc source tĩnh)**: uncommitted changes còn áp dụng cùng business rule cho **mẫu vé xe**, rộng hơn phạm vi mô tả gốc trong bug report (bug report chỉ nói mẫu "2 - C26TNT"/bán hàng):

3. `invoicecore/.../NhapDSHoaDonExcelHelper.cs` → `ValidateAndGetData_VeXe` (dòng ~9215-9310): thêm `&& data.loaihanghoa != 2` / `else if (data.loaihanghoa != 2)` cho **Đơn vị tính, Số lượng, Đơn giá, Thành tiền, VAT, Tiền thuế chi tiết** — phạm vi rộng hơn mẫu bán hàng vì mẫu vé xe vốn bắt buộc cả các trường này (mẫu bán hàng thì Đơn vị tính/Số lượng/Đơn giá đã luôn là optional từ trước, chỉ Thành tiền/Tỷ lệ thuế mới cần sửa).
4. `svinvoicesendemail/AppServiceImportBillHost/AppService/Service/ImportVeXeHelper.cs` → `ValidateAndGetData` (dòng ~854-923): cùng pattern như (3), bản sao cho đường queue/worker.

Đã đọc downstream (`GetChiTiet_BH`/`GetHoaDon_BH` trong invoicecore, `GetChiTiet_VeXe`/`GetHoaDon_VeXe` trong invoicecore, `HoaDonHelper.GetChiTiet` trong svinvoicesendemail): tất cả xử lý giá trị `null` an toàn bằng `?? 0` hoặc `x > 0 ? x : null`, phép tính `int? * decimal?` tự propagate `null` (không throw). Không phát hiện `NullReferenceException`/tính sai số liệu ở downstream cho cả 2 mẫu.

Ticket này dùng để review, hoàn thiện, và chốt chính thức 4 thay đổi trên trước khi đưa lên Gate 1/merge.

## Scope

- `invoicecore/` — `HDDT.Application/Commons/HoaDon/ExcelHelpers/NhapDSHoaDonExcelHelper.cs`:
  - `ValidateAndGetData_BH` (đường nhập Excel trực tiếp, mẫu C26TNT/bán hàng) — Thành tiền, Tỷ lệ tính thuế trên doanh thu.
  - `ValidateAndGetData_VeXe` (đường nhập Excel trực tiếp, mẫu vé xe) — Đơn vị tính, Số lượng, Đơn giá, Thành tiền, VAT, Tiền thuế chi tiết.
- `svinvoicesendemail/` — `AppServiceImportBillHost/AppService/Service/`:
  - `BanHang_ExcelHelper.cs` → `ValidateAndGetData` (đường nhập Excel qua queue/worker, mẫu C26TNT/bán hàng).
  - `ImportVeXeHelper.cs` → `ValidateAndGetData` (đường nhập Excel qua queue/worker, mẫu vé xe).

**Xác nhận scope**: bug report gốc (Pre-condition/Steps To Reproduce ở trên) chỉ mô tả mẫu ký hiệu 2 (C26TNT/bán hàng). Mẫu ký hiệu 5 (vé xe) đã được user xác nhận bổ sung vào scope chính thức của ticket này (xem mục "Xác nhận scope" ở trên).

## Out Of Scope

- `NhapDSHoaDonExcelHelper.ValidateAndGetData` (mẫu giá trị gia tăng, `LoaiHoaDonMau.giatrigiatang = 1`) — hàm này **đã có** điều kiện `if (data.loaihanghoa != 2)` bọc toàn bộ block Thành tiền/VAT/Tiền thuế chi tiết từ trước, không bị lỗi này.
- `ValidateAndGetData_THUOC`, `ValidateAndGetData_NUOC`, `ValidateAndGetData_DIEN`, `ValidateAndGetData_PhieuXuatKho`, `ValidateAndGetData_TaiSanCong` — các mẫu này không có cột "Loại hàng hóa"/"Tỷ lệ tính thuế trên doanh thu" theo layout Ghi chú, không áp dụng khái niệm `loaihanghoa == 2` theo cùng cách.
- `ExcelNewCaHelper.cs` (dùng riêng cho `TENANT_NEWCA`) — không có field `loaihanghoa`/`TyLeTinhThue`, không thuộc phạm vi.
- `svinvoicesendemail/AppServiceImportBillHost/AppService/Service/NhapDSHoaDonExcelHelper.cs` (mẫu giá trị gia tăng bản sao cho worker) — đã có `if (data.loaihanghoa != 2)` bọc block tương ứng từ trước, không bị lỗi.
- Không thay đổi schema database, không có migration.

## Known Risk (cần quyết định trước Gate 1)

- **`int.Parse` không an toàn với dữ liệu rác**: ở nhánh `else if (!string.IsNullOrWhiteSpace(tyLeTinhThue)) data.TyLeTinhThue = int.Parse(tyLeTinhThue);` (cả 2 file), nếu dòng Ghi chú (`loaihanghoa == 2`) có nhập giá trị không rỗng nhưng không phải số hợp lệ ở cột "Tỷ lệ tính thuế trên doanh thu" (ví dụ nhập chữ), `int.Parse` sẽ throw `FormatException` không được bắt, gây lỗi 500 thay vì thông báo lỗi hợp lệ cho người dùng. Đề xuất đổi thành `int.TryParse` để trả thông báo lỗi thân thiện. Cần xác nhận có đưa vào phạm vi sửa của ticket này hay tách ticket riêng.

## Open Questions (cần trả lời trước khi duyệt Gate 1)

1. Xác nhận `git pull` trong `docs/` đã chạy thành công và không có cập nhật mới trước khi duyệt (không thực hiện được trong phiên làm việc do lỗi công cụ shell).
2. Có đưa việc đổi `int.Parse` → `int.TryParse` cho "Tỷ lệ tính thuế trên doanh thu" (rủi ro đã nêu trên) vào phạm vi ticket này không?
3. Khi dòng Ghi chú nhập "Thành tiền = 0" một cách chủ động, hành vi mong đợi là: giá trị 0 được lưu, hay hoàn toàn bỏ qua/không lưu trường Thành tiền (giữ `null`)? Theo code đã sửa, do toàn bộ block bị bỏ qua khi `loaihanghoa == 2`, giá trị nhập vào (kể cả 0) sẽ không được gán vào `data.thanhtien` (giữ `null`). Cần BA xác nhận đây là hành vi đúng.
4. Cần review lại 4 bản fix uncommitted hiện tại (2 file mẫu ký hiệu 2 + 2 file mẫu ký hiệu 5) có đủ, đúng, và nhất quán với nhau không trước khi merge — xem `plan.md`.
5. ~~Có đưa mẫu vé xe vào scope ticket này không~~ — **Đã đóng, đã xác nhận (user, 2026-07-17)**: ticket ảnh hưởng cả mẫu ký hiệu 2 và ký hiệu 5, xem mục "Xác nhận scope".

## Acceptance Criteria

- Nhập Excel mẫu C26TNT (banhang) với dòng hàng hóa Ghi chú (`loaihanghoa == 2`):
  - Không nhập Thành tiền → không hiển thị lỗi "Thành tiền không được để trống.".
  - Nhập Thành tiền = 0 → không hiển thị lỗi.
  - Không nhập Tỷ lệ tính thuế trên doanh thu → không hiển thị lỗi "Tỷ lệ tính thuế trên doanh thu không đúng định dạng.".
  - Hóa đơn được tạo thành công (`result.Status == 1`).
- Nhập Excel mẫu vé xe (ký hiệu 5) với dòng hàng hóa Ghi chú (`loaihanghoa == 2`):
  - Không nhập Đơn vị tính/Số lượng/Đơn giá/Thành tiền/VAT/Tiền thuế chi tiết → không hiển thị lỗi tương ứng.
  - Hóa đơn được tạo thành công.
- Hành vi áp dụng nhất quán cho cả 2 đường xử lý (import trực tiếp `invoicecore` và import qua queue/worker `svinvoicesendemail`) cho mỗi mẫu hóa đơn, vì cùng một mẫu hóa đơn có thể đi qua 1 trong 2 đường tùy số lượng dòng.
- Không thay đổi hành vi validate của các dòng hàng hóa không phải Ghi chú (`loaihanghoa != 2`) — vẫn bắt buộc các trường tương ứng đúng định dạng như hiện tại, cho cả 2 mẫu.
- Không ảnh hưởng đến các mẫu hóa đơn khác (giá trị gia tăng, thuốc, nước, điện, phiếu xuất kho, tài sản công).
- Open Questions ở trên được trả lời và phản ánh trong `plan.md` trước khi bắt đầu implementation.
