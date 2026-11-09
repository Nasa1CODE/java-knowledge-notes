---
feature: CBCLOUDV2-9404
plan-status: plan-review
services-affected: [invoicecore, svinvoicesendemail]
service-repos: [../invoicecore, ../svinvoicesendemail]
updated_at: 2026-09-08
---

# Plan - CBCLOUDV2-9404: Bỏ trường Chất lượng tài sản khi import Hàng hóa đặc trưng 1

## 1. Mục tiêu

Thực hiện AC1-AC8 bằng cách bỏ cột/đọc/validate/map `chatluongtaisan` khỏi riêng luồng import Hàng hóa đặc trưng loại 1, đồng bộ import trực tiếp và nền, không xóa domain field `CLTSan` khỏi phần còn lại của hệ thống.

## 2. Câu hỏi chặn

Không có câu hỏi chặn implementation code. Việc phát hành file mẫu runtime phụ thuộc DevOps/TechLead xác nhận nguồn artifact tại `FileMau/HoaDon`.

## 3. Source hiện tại

### `invoicecore`

- `NhapDSHoaDonExcelHelper.cs` có ba map cột:

| Loại import | Chất lượng hiện tại | Biển số hiện tại | LastColumn hiện tại | Layout mới |
|---|---:|---:|---:|---|
| GTGT | 72 | 73 | 73 | Biển số 72, LastColumn 72 |
| Bán hàng | 63 | 64 | 64 | Biển số 63, LastColumn 63 |
| Vé xe | 61 | 62 | 62 | Biển số 61, LastColumn 61 |

Vì `Chất lượng tài sản %` là cột áp chót và `Số biển kiểm soát` là cột cuối, chỉ cột biển số dịch trái một vị trí. Tất cả cột từ `Mã tỉnh` tới `Số người cho phép chở` giữ nguyên chỉ số.

Ngoài ba block map, source còn sáu gate hard-code độc lập phải đổi đồng bộ:

| Service | Luồng | Gate hiện tại | Gate mới | Vị trí source hiện tại |
|---|---|---:|---:|---|
| `invoicecore` | GTGT | 73 | 72 | `NhapDSHoaDonExcelHelper.cs` khoảng dòng 3720 |
| `invoicecore` | Bán hàng | 64 | 63 | cùng file, khoảng dòng 4164 |
| `invoicecore` | Vé xe | 62 | 61 | cùng file, khoảng dòng 5594 |
| `svinvoicesendemail` | GTGT | 73 | 72 | `Service/NhapDSHoaDonExcelHelper.cs` khoảng dòng 155 |
| `svinvoicesendemail` | Bán hàng | 64 | 63 | `Service/BanHang_ExcelHelper.cs` khoảng dòng 142 |
| `svinvoicesendemail` | Vé xe | 62 | 61 | `Service/ImportVeXeHelper.cs` khoảng dòng 265 |

- `ReadVehicleAssetImportFields(...)` đọc/parse chất lượng rồi truyền raw value vào `ValidateVehicleAssetImportDetailFields(...)`.
- Validator bắt buộc chất lượng khi `tinhtrangtaisan = 1` và kiểm tra `decimal(4,2)` khi có giá trị.
- `ApplyImportChiTietMoRongFields(...)` map `source.chatluongtaisan` sang `target.CLTSan`.
- `checkSaveChiTietMoRong(...)` coi `chatluongtaisan` là dấu hiệu tạo bản ghi mở rộng.
- `TaiFileMau(...)` tải binary runtime, không sinh file mẫu từ code.

### `svinvoicesendemail`

- Ba router `NhapDSHoaDonExcelHelper.cs`, `BanHang_ExcelHelper.cs`, `ImportVeXeHelper.cs` dùng các vị trí 72/73, 63/64, 61/62 tương ứng.
- Shared `VehicleAssetImportHelper.ReadFields(...)`, `ValidateDetailFields(...)`, `HasChiTietMoRongFields(...)`, `ApplyChiTietMoRong(...)` vẫn đọc/validate/map chất lượng.
- `HoaDonRow.cs` còn property import `chatluongtaisan`.

### File mẫu runtime

`TaiFileMau(...)` có thể trả năm artifact dưới `FileMau/HoaDon`:

- `Hoadon_FileMau.xlsx`
- `Hoadon_FileMau_NewCa.xlsx`
- `Hoadon_FileMau_LienSon.xlsx`
- `HoadonBH_FileMau.xlsx`
- `HoadonVEXE_FileMau.xlsx`

Các binary không nằm trong git checkout. File tham chiếu hiện có ở `D:\XBill\File\Cloud` chỉ dùng để đối chiếu, không tự coi là artifact deploy.

## 4. Gate nghiệp vụ

Giữ nguyên gate đã có:

```text
loaihanghoa == 4 && loaidactrung == 1
```

Không thêm điều kiện theo `loaitaisan`. `tinhtrangtaisan = 1` chỉ tiếp tục điều khiển required của các field xe đã qua sử dụng còn lại, đặc biệt `sobienkiemsoat`.

## 5. Cách làm step by step

### Step 1 - Khóa trạng thái và bảo vệ worktree

- Trước code phải xác nhận branch đích với user: `invoicecore` hiện ở `manh/dev_v2` nhưng tracking `origin/manh/dev_T06`; `svinvoicesendemail` hiện ở `dev_cloud`.
- Giữ nguyên thay đổi đang có của CBCLOUDV2-9260 trong:
  - `invoicecore`: `NhapDSHoaDonExcelHelper.cs` và SQL untracked.
  - `svinvoicesendemail`: `VehicleAssetImportHelper.cs` và test untracked.
- Không restore/ghi đè các thay đổi này; patch CBCLOUDV2-9404 trên trạng thái hiện tại.

### Step 2 - Sửa layout/parser import trực tiếp `invoicecore`

File: `aspnet-core/src/hddt/HDDT.Application/Commons/HoaDon/ExcelHelpers/NhapDSHoaDonExcelHelper.cs`.

1. Bỏ property `ChatLuongTaiSan` khỏi `VehicleAssetImportColumns`.
2. Với ba block GTGT/Bán hàng/Vé xe, dịch `SoBienKiemSoat` và `LastColumn` sang trái một cột theo bảng §3.
3. Đổi ba gate cấp hóa đơn `IsNewVehicleAssetImportTemplate(sheet, 73/64/62)` thành `72/63/61`; không để gate cấp nhóm khác gate trong parser dòng.
4. Trong `ReadVehicleAssetImportFields(...)`, không đọc raw cell chất lượng, không parse vào `data.chatluongtaisan`, không truyền tham số này xuống validator.
5. Trong `ValidateVehicleAssetImportDetailFields(...)`, bỏ tham số `chatLuongTaiSanText` và ba nhánh message bắt buộc/sai kiểu/sai precision của Chất lượng tài sản.
6. Trong `ApplyImportChiTietMoRongFields(...)`, bỏ assignment `target.CLTSan = source.chatluongtaisan`.
7. Trong `checkSaveChiTietMoRong(...)`, bỏ `dt.chatluongtaisan.HasValue` khỏi điều kiện.
8. Trong `ExcelAudience.cs`, bỏ property import `HoaDonRow.chatluongtaisan` sau khi mọi reference import đã được loại bỏ.

### Step 3 - Nhận diện an toàn layout mới/cũ

- Không chỉ dựa vào `sheet.Dimension.End.Column`, vì file cũ có thêm cột chất lượng.
- Xác định cột `Số biển kiểm soát` bằng header hàng 1 tại vị trí cuối nhóm xe:
  - layout mới: biển số ở cột mới 72/63/61;
  - layout cũ: cột mới đang là `Chất lượng tài sản %`, biển số ở cột kế tiếp 73/64/62.
- Với layout cũ, bỏ qua hoàn toàn cell chất lượng và chỉ đọc đúng cell biển số.
- Nếu không tìm thấy header biển số ở cả hai vị trí, dùng validation template hiện có/return lỗi header rõ ràng; không đoán cột.

### Step 4 - Sửa import nền `svinvoicesendemail`

1. Trong ba file router dưới `AppServiceImportBillHost/AppService/Service/`, cập nhật `SoBienKiemSoat`/`LastColumn` sang 72, 63, 61.
2. Trong chính ba router này, đổi các gate cấp hóa đơn `IsNewTemplate(sheet, 73/64/62)` thành `72/63/61`.
3. Trong `Models/VehicleAssetImportHelper.cs`:
   - bỏ `ChatLuongTaiSan` khỏi cấu hình cột;
   - thêm nhận diện layout cũ/mới giống direct flow;
   - bỏ đọc/parse/validate `chatluongtaisan`;
   - bỏ khỏi `HasChiTietMoRongFields(...)`;
   - bỏ assignment `target.CLTSan` trong `ApplyChiTietMoRong(...)`.
4. Trong `Models/HoaDonRow.cs`, bỏ property import `chatluongtaisan` khi không còn reference.
5. Không đổi `HD_ChiTiet_MoRong.CLTSan`, repository SQL hoặc queue DTO.

### Step 5 - Cập nhật file mẫu runtime

- Với từng artifact thực tế trong §3 có header chất lượng, backup bản đang deploy.
- Xóa nguyên cột `Chất lượng tài sản %` trên sheet import, để `Số biển kiểm soát` dịch trái cùng style/data validation.
- Không xóa field khỏi file export/report vì ticket chỉ có prefix `[Import]`.
- Kiểm tra lại bằng tải file qua API `HoaDon/TaiFileMau`, không chỉ mở file tham chiếu local.

### Step 6 - Automated tests

`invoicecore`:

- Bổ sung test source/helper phù hợp trong `aspnet-core/test/VS.Tests/HoaDon/` hoặc test project hiện có.
- Case layout mới và layout cũ cho ba bộ chỉ số; assert đúng biển số, `CLTSan` null và không có message chất lượng.
- Case gate template tại đúng tổng cột mới 72/63/61, bảo đảm không bị coi nhầm là template cũ.
- Case `tinhtrangtaisan = 1` thiếu biển số vẫn lỗi.
- Case gate `loaihanghoa != 4`, subtype null/2/3 không chạy rule.

`svinvoicesendemail`:

- Cập nhật/bổ sung `AppServiceImportBillHost/AppServiceTest/VehicleAssetImportHelperTests.cs` hoặc file test đang có.
- Chạy cùng ma trận layout/gate/required và xác nhận không còn reference chất lượng trong import helper.
- Cập nhật test fixture đang dùng `ChatLuongTaiSan = 17`, `SoBienKiemSoat = 18`, `LastColumn = 18` sang fixture mới không còn quality; thêm fixture legacy riêng để kiểm tương thích.

### Step 7 - Build và manual regression

- Build/test hai repo tuần tự.
- Manual 6 luồng: GTGT/Bán hàng/Vé xe x direct/background.
- Mỗi luồng chạy file mẫu mới; thêm regression file cũ.
- Đọc lại `vs_hd_chitiet_morong`: `sbksoat` đúng, `cltsan` null cho hóa đơn mới.

### Step 8 - Docs và bàn giao

- Cập nhật `testcase.md`, `impact.md`, tạo `report.md` từ output thật.
- Tạo/chốt `deploy.md` cho artifact file mẫu; không tạo SQL migration.
- Ghi các manual case chưa chạy là `not run`.

## 6. File dự kiến thay đổi

### `invoicecore`

- `aspnet-core/src/hddt/HDDT.Application/Commons/HoaDon/ExcelHelpers/NhapDSHoaDonExcelHelper.cs`
- `aspnet-core/src/hddt/HDDT.Application/Commons/HoaDon/ExcelHelpers/ExcelAudience.cs`
- `aspnet-core/test/VS.Tests/HoaDon/VehicleAssetImportQualityRemovalTests.cs` (mới, nếu test project compile được helper)

### `svinvoicesendemail`

- `AppServiceImportBillHost/AppService/Models/VehicleAssetImportHelper.cs`
- `AppServiceImportBillHost/AppService/Models/HoaDonRow.cs`
- `AppServiceImportBillHost/AppService/Service/NhapDSHoaDonExcelHelper.cs`
- `AppServiceImportBillHost/AppService/Service/BanHang_ExcelHelper.cs`
- `AppServiceImportBillHost/AppService/Service/ImportVeXeHelper.cs`
- `AppServiceImportBillHost/AppServiceTest/VehicleAssetImportHelperTests.cs` hoặc test file chuyên biệt mới

## 7. Không sửa

- `HD_ChiTiet_MoRong.CLTSan`, `cltsan` DB, repository insert/update chung.
- XML constant/tag `CLTSan` và logic xuất XML cho dữ liệu cũ.
- `api-cloud-service`, frontend, NSwag proxy.
- `AppServiceExportBillHost` và các báo cáo/export danh sách hóa đơn.

## 8. DB và dữ liệu

- Không migration, không drop/null cột `cltsan`.
- Hóa đơn import mới không ghi chất lượng nên `cltsan` null.
- Hóa đơn cũ giữ nguyên giá trị và vẫn có thể phát XML/hiển thị qua luồng ngoài import.

## 9. API, queue và bảo mật

- Không đổi route `HoaDon/TaiFileMau`, request/response hay queue contract.
- Chỉ thay nội dung binary trả về và cách hai consumer đọc sheet.
- Không log dữ liệu file hoặc thông tin khách hàng; giữ tenant routing hiện tại.

## 10. Kế hoạch kiểm chứng

| # | Lệnh/bước | Kết quả kỳ vọng |
|---|---|---|
| 1 | `rg -n -i "chatluongtaisan|Chất lượng tài sản" <các file import đã sửa>` | Không còn reference trong parser/validator/map import; reference domain/export ngoài scope được giải thích |
| 2 | `dotnet test aspnet-core/test/VS.Tests/VS.Tests.csproj --no-restore --filter "FullyQualifiedName~VehicleAssetImportQualityRemoval" --verbosity minimal` | Test direct pass, 0 failed |
| 3 | `dotnet build aspnet-core/VS.sln --no-restore --verbosity minimal` hoặc solution đúng của repo | Build `invoicecore` 0 error |
| 4 | `dotnet test AppServiceImportBillHost/AppServiceTest/AppServiceTest.csproj --no-restore --filter "FullyQualifiedName~VehicleAsset" --verbosity minimal` | Test worker pass, 0 failed |
| 5 | `dotnet build AppServiceImportBillHost/AppService.sln --no-restore --verbosity minimal` | Build worker 0 error |
| 6 | Tải 5 biến thể file qua `HoaDon/TaiFileMau`, kiểm header | Không còn cột chất lượng ở artifact áp dụng |
| 7 | Import 3 loại x direct/background với template mới | Thành công khi thiếu chất lượng, biển số map đúng |
| 8 | Import file cũ có quality + plate | Quality bị bỏ qua, plate không đọc lệch |
| 9 | Query `cltsan`, `sbksoat` trên tenant test | `cltsan` null, `sbksoat` đúng |

## 11. Ma trận rủi ro

| Rủi ro | Mức | Giảm thiểu | Rollback |
|---|---|---|---|
| Dịch cột làm đọc quality thành biển số | Cao | Nhận diện bằng header và test cả layout cũ/mới | Hoàn tác parser + khôi phục artifact backup |
| Direct/background lệch behavior | Cao | Shared ma trận test cho 3 loại x 2 tuyến | Rollback đồng thời hai service |
| Chỉ đổi code nhưng quên file mẫu runtime | Cao | Deploy checklist 5 artifact và tải lại qua API | Khôi phục artifact cũ |
| Xóa domain field làm mất dữ liệu cũ/XML | Cao | Chỉ xóa import property/reference, giữ entity/DB/XML | Rà diff do-not-touch trước merge |
| Worktree có code task 9260 | Trung bình | Patch trên thay đổi hiện có, không restore | Tách diff theo ticket trước commit |

## 12. Thứ tự deploy và rollback

1. Backup các artifact file mẫu đang dùng.
2. Deploy `invoicecore` và `svinvoicesendemail` cùng phiên bản tương thích cả layout cũ/mới.
3. Thay file mẫu runtime.
4. Smoke direct/background rồi đọc lại DB.

Rollback: khôi phục đồng thời code hai service và các binary đã backup. Không rollback DB.

## 13. Giả định

- `BH` là hóa đơn Bán hàng.
- File cũ được hỗ trợ và quality bị bỏ qua.
- Không xóa field khỏi API/manual/XML vì title chỉ giới hạn `[Import]`.

## 14. Đề xuất cập nhật docs (Gate 2)

- `specs/system.md`: đề xuất ghi import Hàng hóa đặc trưng loại 1 không nhận `CLTSan` sau khi nghiệp vụ được TechLead xác nhận.
- `architecture.md`, `databases/*`, `design.md`: không đổi.

## 15. Sai lệch khi triển khai

- User xác nhận ngày 2026-09-08: bỏ qua Gate 1 và triển khai trên branch hiện tại.
- Branch triển khai: `invoicecore/manh/dev_v2` (đang tracking `origin/manh/dev_T06`) và `svinvoicesendemail/dev_cloud`.

## 16. Phê duyệt Gate 1

- DEV self-review: <tên, ngày, commit/PR>
- TechLead approval: <tên, ngày, commit/PR>
- Ngoại lệ: user bypass Gate 1 ngày 2026-09-08; không tự điền hai chữ ký approval.
