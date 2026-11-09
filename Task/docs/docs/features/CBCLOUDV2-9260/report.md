---
feature: CBCLOUDV2-9260
status: testing
services: [invoicecore, svinvoicesendemail]
executed_at: 2026-09-08
---

# Report - CBCLOUDV2-9260

## Kết quả triển khai

- `invoicecore`: bảy field dùng giới hạn 2/5/255/400 theo số ký tự; tạo helper phạm vi hẹp để không đổi maxlength field khác.
- `svinvoicesendemail`: đổi cùng bảy constants trong shared worker helper.
- Tạo SQL mở rộng năm cột `vs_hd_chitiet_morong`; chưa apply vì không có kết nối tenant/DBA precheck.
- Không đổi required, gate `loaihanghoa == 4 && loaidactrung == 1`, parser, router, queue, mapping hoặc XML tag.

## File source thay đổi

### `invoicecore`

- `aspnet-core/src/hddt/HDDT.Application/Commons/HoaDon/ExcelHelpers/NhapDSHoaDonExcelHelper.cs`.
- `aspnet-core/database/2026-09-08-CBCLOUDV2-9260-adjust-vehicle-asset-maxlength.sql`.

### `svinvoicesendemail`

- `AppServiceImportBillHost/AppService/Models/VehicleAssetImportHelper.cs`.
- `AppServiceImportBillHost/AppServiceTest/VehicleAssetMaxLengthTests.cs`.

## Automated test

```powershell
dotnet test AppServiceImportBillHost/AppServiceTest/AppServiceTest.csproj --no-restore --filter "FullyQualifiedName~VehicleAssetMaxLengthTests" --verbosity minimal
```

Kết quả cuối: `Passed: 16, Failed: 0, Skipped: 0`, 147 ms.

Không chạy toàn bộ test project vì `UnitTest1.TestImportFile` hiện chứa kết nối DB cứng và là integration test ngoài phạm vi/an toàn local.

## Build

```powershell
dotnet build AppServiceImportBillHost/AppService.sln --no-restore --verbosity quiet
```

Kết quả: `Build succeeded`, 10 warning, 0 error, 2.15 giây.

```powershell
dotnet build aspnet-core/src/hddt/HDDT.Application/HDDT.Application.csproj --no-restore --verbosity quiet
```

Kết quả: build thành công, 220 warning, 0 error, 26.06 giây. Warning là dependency/framework legacy và warning code có sẵn; không có error liên quan task.

## Sự cố

- Lần test worker đầu tiên lỗi `MSB3491 Access denied` khi sandbox không được ghi `obj`. Chạy lại với quyền phù hợp thành công 16/16.
- `check-layout.sh` không chạy được vì Windows environment không có `bash`.

## Chưa chạy

- `SHOW COLUMNS` và apply migration trên tenant DB.
- Manual import GTGT/Bán hàng/Vé xe với file `<= 50` và `> 50` dòng.
- DB/XML read-back boundary và direct Unicode boundary.

Feature giữ trạng thái `testing`; chưa đủ điều kiện `done` cho tới khi hoàn tất các mục trên.

## Git

- `invoicecore`: branch `manh/dev_v2`, tracking `origin/manh/dev_T06`.
- `svinvoicesendemail`: branch `dev_cloud`.
- `docs`: branch `docs/xbill-cloud`.
- Chưa commit, chưa push, không chuyển branch.
