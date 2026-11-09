---
feature: CBCLOUDV2-9260
title: Điều chỉnh maxlength khi import Hàng hóa đặc trưng 1
plan-status: plan-review
service: invoicecore
service-repo: ../invoicecore
services-affected: [invoicecore, svinvoicesendemail]
owner: DEV + AI
created_at: 2026-09-08
updated_at: 2026-09-08
---

# Plan - CBCLOUDV2-9260

## 1. Câu hỏi chặn

Không có. Plan dùng số ký tự theo tài liệu nghiệp vụ; DBA vẫn phải chạy schema precheck trước deploy.

## 2. Tóm tắt cách làm

Đổi đúng bảy ngưỡng maxlength trong shared validator của import trực tiếp `invoicecore` và shared helper của import nền `svinvoicesendemail`. Không sửa ba router riêng vì GTGT, Bán hàng và Vé xe đã cùng truyền dữ liệu qua các helper này. Mở rộng năm cột tenant DB đang có độ dài 200/300 trước khi cho phép dữ liệu 255/400. Giữ nguyên gate Hàng hóa đặc trưng loại 1, required, parser, mapping và XML.

## 3. Truy vết yêu cầu

| AC | Phần thiết kế |
|---|---|
| AC1 | §5.0, §5.1 |
| AC2 | §5.0, §5.2 |
| AC3 | §5.1, §5.2, §11 |
| AC4 | §5.0, §11 |
| AC5 | §5.1, §5.2 |
| AC6 | §5.3, §7 |
| AC7 | §5.4, §9, §10 |

## 4. Service bị ảnh hưởng

| Service | Mức | Thay đổi chính |
|---|---|---|
| `invoicecore` | Cao | Validation import trực tiếp và SQL tenant cho cột được nới |
| `svinvoicesendemail` | Trung bình | Validation import nền dùng chung và automated test |
| `docs` | Thấp | Feature docs, DB current-state docs và báo cáo thực thi |

## 5. Thiết kế chi tiết

### 5.0 Điều kiện kích hoạt và router

Giữ nguyên điều kiện source:

```csharp
data != null && data.loaihanghoa == 4 && data.loaidactrung == 1
```

Chỉ đọc/validate khi template mới đủ số cột. Không thêm điều kiện theo `loaitaisan`, `tinhtrangtaisan` hoặc `xuatxu` cho maxlength.

- `invoicecore`: ba block `VehicleAssetImportColumns` trong `NhapDSHoaDonExcelHelper.cs` gọi `ReadVehicleAssetImportFields(...)` và `ValidateVehicleAssetImportInvoiceFields(...)` cho GTGT, Bán hàng, Vé xe.
- `svinvoicesendemail`: `Service/NhapDSHoaDonExcelHelper.cs`, `Service/BanHang_ExcelHelper.cs`, `Service/ImportVeXeHelper.cs` cùng gọi `VehicleAssetImportHelper.ReadFields(...)` và `ValidateInvoiceFields(...)`.

### 5.1 AC1/AC3/AC5 - Import trực tiếp

File:

`invoicecore/aspnet-core/src/hddt/HDDT.Application/Commons/HoaDon/ExcelHelpers/NhapDSHoaDonExcelHelper.cs`

Trong `ValidateVehicleAssetImportDetailFields(...)`, thay đúng năm ngưỡng:

| Property | Message | Cũ | Mới |
|---|---|---:|---:|
| `sogiaychungnhanatkt` | Số Giấy chứng nhận... | 200 | 255 |
| `soseripktcl` | Số seri Phiếu kiểm tra... | 200 | 255 |
| `ten_loaitaisan` | Tên loại tài sản đăng ký | 200 | 255 |
| `ten_thuongmai` | Tên thương mại | 300 | 400 |
| `ten_nhanhieu` | Tên nhãn hiệu | 200 | 255 |

Trong `ValidateVehicleAssetImportLocationFields(...)`, thay:

- `ma_tinh`: 3 -> 2.
- `ma_xa`: 8 -> 5.

Không sửa `ReadVehicleAssetImportFields`, `IsVehicleAssetImportRow`, required hoặc mapping `ApplyHoaDonMoRongFields`/`ApplyChiTietMoRongFields`. Vì `invoicecore.IsTooLong(...)` hiện tính byte UTF-8, tạo helper phạm vi hẹp dùng `value.Length` và chỉ áp dụng cho bảy field của task; không đổi helper cũ để tránh ảnh hưởng maxlength ngoài scope.

### 5.2 AC2/AC3/AC5 - Import nền

File:

`svinvoicesendemail/AppServiceImportBillHost/AppService/Models/VehicleAssetImportHelper.cs`

- Trong `ValidateDetailFields(...)`, đổi cùng năm ngưỡng 200/300 thành 255/400.
- Trong `ValidateLocationFields(...)`, đổi `ma_tinh` 3 -> 2 và `ma_xa` 8 -> 5.
- Giữ nguyên `ReadFields`, `IsVehicleAssetRow`, required, parser và mapping.
- Không sửa ba router; chỉ review call-site để xác nhận vẫn dùng helper chung.

`svinvoicesendemail.IsTooLong(...)` đã dùng `value.Length`, phù hợp đơn vị ký tự. Chỉ đổi bảy constants, không thay helper toàn cục.

### 5.3 AC6 - Dữ liệu tenant

Actual migration cũ tại `invoicecore/aspnet-core/database/2026-08-13-add-vehicle-asset-columns-to-vs_hd_chitiet_morong.sql` đang khai báo:

- `sgcnatkthuat varchar(200)` -> `varchar(255)`.
- seri phiếu kiểm tra `varchar(200)` -> `varchar(255)`.
- `tltsdky varchar(200)` -> `varchar(255)`.
- `ttmai varchar(300)` -> `varchar(400)`.
- `tnhieu varchar(200)` -> `varchar(255)`.

Tạo SQL forward/rollback trong `deploy.md` với cột `sspktclxxuong` theo Dapper repository và mapping CBCLOUDV2-9167. DBA bắt buộc xác nhận bằng `SHOW COLUMNS` vì migration cũ ghi nhầm `sspktcclxxuong`.

`ma_tinh` và `ma_xa` không cần thu hẹp DB; validator siết input xuống 2/5, tránh rollback dữ liệu và không ảnh hưởng bản ghi cũ. Cập nhật `docs/databases/databasetenant.vs_hd_chitiet_morong.sql` sau khi schema được xác nhận vì snapshot hiện chưa liệt kê nhóm cột mới.

### 5.4 AC7 - Contract và mapping giữ nguyên

- Không đổi cột Excel, `HoaDonRow`, queue DTO, route, API hoặc frontend.
- Không đổi `HD_HoaDon_MoRong.Ma_Tinh/Ma_Xa` và `HD_ChiTiet_MoRong` mapping.
- Không đổi XML tag `SGCNATKThuat`, `SSPKTCLXXuong`, `TLTSDKy`, `TTMai`, `TNHieu`.
- Không sửa maxlength của `ma_nuocsx`, `sokhung`, `somay`, `kieuloaixe`, `thetich_congsuat`, `sobienkiemsoat` hoặc buyer fields.

## 6. Thứ tự triển khai

1. Gate 1 duyệt phạm vi bảy field, cách tính theo ký tự và SQL precheck.
2. Review SQL tenant; triển khai mở rộng năm cột trước code hoặc trong cùng release trước khi nhận dữ liệu mới.
3. Sửa validator `invoicecore`.
4. Sửa validator `svinvoicesendemail` và automated tests.
5. Build/test tuần tự, sau đó manual import sáu luồng direct/background.
6. Cập nhật docs/report theo output thật.

## 7. Thay đổi database

Có. `ALTER TABLE vs_hd_chitiet_morong MODIFY COLUMN` cho năm cột mô tả tại §5.3. Không thu hẹp `ma_tinh`/`ma_xa`. Rollback chỉ được hạ cột về 200/300 sau khi query xác nhận không có dữ liệu vượt giới hạn cũ; nếu có, rollback code nhưng giữ schema mở rộng.

## 8. Thay đổi cấu hình

None.

## 9. Tích hợp ngoài và liên service

- Queue import: backward compatible, không đổi message contract.
- Excel template: không đổi cấu trúc hoặc vị trí cột.
- DB tenant: thay đổi mở rộng, tương thích ngược; phải triển khai trước code nhận dữ liệu dài.
- XML: không đổi tag/contract, chỉ có thể chứa giá trị dài hơn trong giới hạn mới.

## 10. Tương thích ngược

Giá trị cũ tiếp tục hợp lệ, ngoại trừ `ma_tinh` dài 3 và `ma_xa` dài 6-8 sẽ bị từ chối ở import Hàng hóa đặc trưng loại 1 theo tài liệu mới. Dữ liệu đã lưu không bị sửa. Client/template không cần thay đổi contract.

## 11. Kế hoạch kiểm chứng

### `invoicecore`

```powershell
dotnet build aspnet-core/src/hddt/HDDT.Application/HDDT.Application.csproj --no-restore --verbosity minimal
```

- Kỳ vọng 0 error.
- Manual từng loại GTGT/Bán hàng/Vé xe với file `<= 50` dòng: mỗi field ở N và N+1; đối chiếu message mới.

### `svinvoicesendemail`

```powershell
dotnet test AppServiceImportBillHost/AppServiceTest/AppServiceTest.csproj --no-restore --verbosity minimal
dotnet build AppServiceImportBillHost/AppService.sln --no-restore --verbosity minimal
```

- Thêm parameterized tests cho bảy field ở N/N+1, gate negative và required regression.
- Manual cùng dữ liệu với file `> 50` dòng qua queue; kết quả đồng nhất direct import.

### Database

- Trước deploy: `SHOW COLUMNS FROM vs_hd_chitiet_morong` và xác nhận tên/type năm cột.
- Sau deploy: query `CHARACTER_MAXIMUM_LENGTH` trả 255/255/255/400/255.
- Import và đọc lại giá trị boundary để xác nhận không truncate.

## 12. Rủi ro và rollback

| Rủi ro | Mức | Giảm thiểu / rollback |
|---|---|---|
| Validator cho phép dài hơn DB | Cao | Deploy schema trước code; test đọc lại dữ liệu boundary |
| Direct hiện tính byte, worker tính ký tự | Cao | Dùng helper ký tự phạm vi bảy field ở direct; test Unicode hai luồng |
| Dùng sai tên cột seri | Cao | `SHOW COLUMNS` trước khi chốt SQL; không đoán từ migration typo |
| Siết mã tỉnh/xã làm file cũ lỗi | Trung bình | Regression template cũ/subtype khác; thông báo QA dữ liệu mã mới |
| Sửa router riêng gây lệch ba loại hóa đơn | Trung bình | Chỉ sửa helper chung, review ba call-site |

Rollback: hoàn tác constants code. Giữ schema mở rộng nếu đã có dữ liệu vượt giới hạn cũ; chỉ thu hẹp sau precheck an toàn.

## 13. Phương án khác đã xem xét

- Chỉ đổi validator, không đổi DB: loại vì năm giới hạn mới lớn hơn capacity migration hiện có.
- Đổi global `IsTooLong`: loại vì có thể ảnh hưởng nhiều field ngoài task; dùng helper ký tự phạm vi hẹp ở direct.
- Sửa từng router: loại vì cả ba đã dùng shared helper.

## 14. Giả định

- `BH` trong tiêu đề là hóa đơn Bán hàng, tương ứng `BanHang_ExcelHelper.cs`.
- Task chỉ đổi bảy field trong ảnh, không đổi maxlength khác.
- Maxlength mới được tính theo số ký tự (`string.Length`) vì tài liệu và message nghiệp vụ ghi ký tự.
- Tên cột seri đích là `sspktclxxuong` theo repository đang ghi dữ liệu; migration cũ có typo và không được dùng để đoán schema runtime.
- User đã cho phép lập docs trên branch hiện tại và giữ nguyên worktree đang có của các task khác.

## 15. Câu hỏi mở

Không có. DBA schema precheck là điều kiện triển khai, không phải câu hỏi thiết kế.

## 16. Cập nhật docs đề xuất (Gate 2)

- Cập nhật `docs/databases/databasetenant.vs_hd_chitiet_morong.sql` theo schema thật sau deploy.
- Không cần sửa `architecture.md`, `design.md` hoặc specs contract vì không đổi kiến trúc/UI/API.
- Hoàn thiện `impact.md`, `testcase.md`, `report.md` theo bằng chứng thực thi.

## 17. Sai lệch khi triển khai

- User cho phép bỏ qua DEV self-review và TechLead approval ngày 2026-09-08. Implementation tiếp tục trên branch hiện tại, không chuyển branch và không commit/push.
- Schema runtime chưa được kết nối trong phiên làm việc; SQL được chuẩn bị theo repository source, còn `SHOW COLUMNS` giữ là precheck bắt buộc của DBA.
- `svinvoicesendemail` thay đổi trạng thái bên ngoài trước implementation: test source của task trước không còn trong worktree. Đã tạo test độc lập `VehicleAssetMaxLengthTests.cs`; không khôi phục file đã biến mất.
- Test lần đầu bị sandbox từ chối ghi `obj`; chạy lại ngoài sandbox thành công 16/16. Không phải lỗi production code.
- `bash scripts/check-layout.sh` không chạy được vì máy không có executable `bash`.

## 18. Phê duyệt Gate 1

- DEV self-review: bypass theo yêu cầu user ngày 2026-09-08.
- TechLead approval: bypass theo yêu cầu user ngày 2026-09-08.
