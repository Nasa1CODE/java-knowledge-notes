---
feature: CBCLOUDV2-9386
title: Bỏ bắt buộc Địa chỉ thư điện tử khi import Hàng hóa đặc trưng 1
plan-status: plan-review
service: invoicecore
service-repo: ../invoicecore
services-affected: [invoicecore, svinvoicesendemail]
owner: DEV + AI
created_at: 2026-09-08
updated_at: 2026-09-08
---

# Plan - CBCLOUDV2-9386

## 1. Câu hỏi chặn

Không có.

## 2. Tóm tắt cách làm

Sửa đúng hai shared buyer validators tại `invoicecore` và `svinvoicesendemail`: bỏ duy nhất required check của `data.email`, nhưng chỉ trong luồng đã được gate bởi điều kiện Hàng hóa đặc trưng loại 1 tại §5.0. Giữ nguyên việc đọc cột Excel `Email`, map `DNMua_Email`, kiểm tra định dạng ở parser và maxlength của rule hàng hóa đặc trưng. Vì GTGT, Bán hàng và Vé xe đều dùng các validator chung này, không sửa riêng từng router.

## 3. Truy vết yêu cầu

| AC | Phần thiết kế |
|---|---|
| AC1-AC3 | §5.0, §5.1, §5.2 |
| AC4 | §5.3 |
| AC5 | §5.4 |
| AC6 | §5.5 |
| AC7 | §5.6 |

## 4. Service bị ảnh hưởng

| Service | Mức | Thay đổi chính |
|---|---|---|
| `invoicecore` | Trung bình | Import trực tiếp GTGT/Bán hàng/Vé xe; bỏ required Email trong buyer validator dùng chung |
| `svinvoicesendemail` | Trung bình | Import nền GTGT/Bán hàng/Vé xe; đồng bộ cùng rule |

## 5. Thiết kế chi tiết

### 5.0. Điều kiện kích hoạt Hàng hóa đặc trưng loại 1

Chỉ bỏ bắt buộc Email khi **đồng thời** thỏa toàn bộ điều kiện sau:

1. Sử dụng template import mới có nhóm cột Hàng hóa đặc trưng.
2. Loại hóa đơn thuộc một trong ba luồng: GTGT, Bán hàng hoặc Vé xe.
3. Hóa đơn có ít nhất một dòng thỏa:
   - Cột nghiệp vụ `Tính chất = 4`, được parser map vào `HoaDonRow.loaihanghoa == 4`.
   - Cột `Loại hàng hóa đặc trưng = 1`, được parser map vào `HoaDonRow.loaidactrung == 1`.

Điều kiện nhận diện trong code phải giữ nguyên:

```csharp
data != null && data.loaihanghoa == 4 && data.loaidactrung == 1
```

- `invoicecore` dùng `IsVehicleAssetImportRow(data)` với đúng biểu thức trên.
- `svinvoicesendemail` dùng `VehicleAssetImportHelper.IsVehicleAssetRow(data)` với đúng biểu thức trên.
- Nếu dòng hóa đơn cha thỏa điều kiện, buyer validator được gọi qua `ValidateVehicleAssetImportInvoiceFields(...)`/`ValidateInvoiceFields(...)` với `hasVehicleAssetRow = true`.
- Nếu dòng cha không thỏa nhưng có ít nhất một dòng con thỏa điều kiện, router đặt `hasChildVehicleAssetRow = true` rồi gọi buyer validator cho thông tin người mua trên dòng cha.
- Nếu không thỏa một trong các điều kiện trên, không đi vào nhánh validation được sửa bởi task này; rule Email hiện tại của các luồng khác phải giữ nguyên.

### 5.1. Import trực tiếp `invoicecore` - AC1, AC2, AC3

- **File:** `aspnet-core/src/hddt/HDDT.Application/Commons/HoaDon/ExcelHelpers/NhapDSHoaDonExcelHelper.cs`.
- **Method:** `ValidateVehicleAssetImportBuyerFields(HoaDonRow data, bool hasVehicleAssetRow)`.
- Chỉ thực hiện thay đổi trong method này vì mọi call site thuộc phạm vi đều truyền `hasVehicleAssetRow = true` sau khi đã xác định điều kiện tại §5.0; không mở rộng điều kiện sang `loaihanghoa`/`loaidactrung` khác.
- Xóa duy nhất điều kiện sinh message required:
  `if (string.IsNullOrWhiteSpace(data.email)) message += "Địa chỉ thư điện tử không được để trống.";`.
- Giữ nguyên `ValidateVehicleAssetImportInvoiceFields(...)`, `ValidateVehicleAssetImportLocationFields(...)` và các call site của GTGT, Bán hàng, Vé xe.
- Không sửa ba parser `ValidateAndGetData(...)`, `ValidateAndGetData_BH(...)`, `ValidateAndGetData_VeXe(...)`.

### 5.2. Import nền `svinvoicesendemail` - AC1, AC2, AC3

- **File:** `AppServiceImportBillHost/AppService/Models/VehicleAssetImportHelper.cs`.
- **Method:** `ValidateBuyerFields(HoaDonRow data, bool hasVehicleAssetRow)`.
- Chỉ thực hiện thay đổi trong method này vì mọi router thuộc phạm vi đều gọi helper sau khi đã xác định điều kiện tại §5.0; không mở rộng sang các loại hàng hóa đặc trưng 2, 3 hoặc hóa đơn thường.
- Xóa duy nhất lệnh `Require(message, data.email, "Địa chỉ thư điện tử");`.
- Giữ nguyên `ValidateInvoiceFields(...)`, `ValidateLocationFields(...)` và ba router:
  `Service/NhapDSHoaDonExcelHelper.cs`, `Service/BanHang_ExcelHelper.cs`, `Service/ImportVeXeHelper.cs`.

### 5.3. Email có dữ liệu vẫn validate - AC4

- Giữ parser Email và regex hiện tại ở từng loại import.
- Giữ check `IsTooLong(data.email, 50)` trong buyer validator của hai service.
- Không thay đổi giới hạn 250 byte ở parser import hiện tại; với hóa đơn hàng hóa đặc trưng, rule 50 ký tự/byte hiện có tiếp tục được áp dụng sau parser.
- Không thay đổi message `Email không đúng định dạng.`, `Email quá dài.` hoặc `Địa chỉ thư điện tử không được vượt quá 50 ký tự.`.

### 5.4. Rule người mua và hàng hóa khác giữ nguyên - AC5

- Tiếp tục required `Tên`, `Địa chỉ`, `Số điện thoại`, `Mã tỉnh`, `Mã xã`.
- Không thay đổi validate/mapping của các field hàng hóa đặc trưng, xuất xứ, tình trạng tài sản hoặc loại tài sản.

### 5.5. Dòng hàng hóa đặc trưng nằm ở dòng con - AC6

- Các call site hiện xác định `hasChildVehicleAssetRow` và gọi buyer validator trên `hdrow` của dòng hóa đơn cha.
- Do sửa shared buyer validator, Email trống ở dòng cha không còn bị báo required khi dòng con kích hoạt rule.
- Không thay đổi cách lấy Mã tỉnh/Mã xã theo dòng hàng hóa đặc trưng.

### 5.6. Luồng không kích hoạt - AC7

- Giữ nguyên điều kiện template mới và biểu thức `loaihanghoa == 4 && loaidactrung == 1` trong `IsVehicleAssetImportRow(...)`/`IsVehicleAssetRow(...)`.
- Không thay đổi luồng template cũ; `loaihanghoa != 4`; hoặc `loaidactrung` null, 2, 3.
- Không thay đổi rule Email thông thường liên quan `GuiEmail_TuDong` ở các parser khác.

## 6. Thứ tự triển khai

1. Sửa buyer validator tại `invoicecore`.
2. Sửa buyer validator tại `svinvoicesendemail`.
3. Cập nhật automated test của worker để Email trống không còn expected required, đồng thời giữ test invalid/maxlength.
4. Build `HDDT.Application`, chạy test/build worker.
5. Manual import GTGT/Bán hàng/Vé xe với file `<= 50` và `> 50` dòng.
6. Cập nhật `tasks.md`, `testcase.md`, `impact.md`, `report.md` theo kết quả thật.

## 7. Thay đổi database

None. Không có schema, migration hoặc chuyển đổi dữ liệu.

## 8. Thay đổi cấu hình

None. Không thay đổi cấu hình gửi email tự động, queue hoặc environment key.

## 9. Tích hợp ngoài và liên service

- Queue import hiện tại: không đổi tên queue hoặc message DTO.
- Excel template: không đổi header/cột.
- API/NSwag: không đổi contract.
- XML/PDF/FTP/HSM/CQT: không đổi.

## 10. Tương thích ngược

Tương thích về contract và dữ liệu. Đây là thay đổi nới validation required cho Email trên đúng hóa đơn có hàng hóa đặc trưng loại 1. Email có dữ liệu và các luồng import không kích hoạt vẫn dùng validation hiện tại.

## 11. Kế hoạch kiểm chứng

| # | Service | Lệnh / bước kiểm | Kết quả kỳ vọng |
|---|---|---|---|
| 1 | `invoicecore` | `dotnet build aspnet-core/src/hddt/HDDT.Application/HDDT.Application.csproj --no-restore` | Build thành công, 0 error |
| 2 | `svinvoicesendemail` | `dotnet test AppServiceImportBillHost/AppServiceTest/AppServiceTest.csproj --no-restore` | Test Email optional và regression pass |
| 3 | `svinvoicesendemail` | `dotnet build AppServiceImportBillHost/AppService.sln --no-restore` | Build thành công, 0 error |
| 4 | Hai service | Manual GTGT/Bán hàng/Vé xe `<= 50` và `> 50` dòng | Email trống import được; kết quả hai luồng giống nhau |
| 5 | Hai service | Manual Email sai định dạng và vượt maxlength | Vẫn trả đúng lỗi hiện tại |

## 12. Rủi ro và rollback

| Rủi ro | Mức | Giảm thiểu / rollback |
|---|---|---|
| Chỉ sửa một trong hai service | Trung bình | Sửa và test đồng bộ; rollback hai required check cùng lúc |
| Xóa nhầm maxlength/regex | Trung bình | Diff chỉ xóa required; test Email có dữ liệu sai |
| Bỏ required cho trường người mua khác | Cao | Regression test Tên/Địa chỉ/SĐT/Tỉnh/Xã |
| Dòng con kích hoạt nhưng dòng cha vẫn báo Email | Trung bình | Test riêng cấu trúc cha/con cho cả ba loại hóa đơn |

## 13. Phương án khác đã cân nhắc

- Thêm cờ `emailRequired` vào helper: không chọn vì nghiệp vụ mới bỏ required Email cho toàn bộ phạm vi hàng hóa đặc trưng loại 1 và helper đã được gọi đúng phạm vi.
- Sửa riêng sáu router: không chọn vì tạo duplication và nguy cơ lệch giữa loại hóa đơn/luồng xử lý.

## 14. Giả định

- “Bỏ bắt buộc” chỉ bỏ lỗi khi Email trống; không bỏ validate khi có dữ liệu.
- Phạm vi bao gồm cả dòng chính và trường hợp hàng hóa đặc trưng nằm ở dòng con của cùng hóa đơn.

## 15. Câu hỏi mở

Không có.

## 16. Đề xuất cập nhật docs (Gate 2)

- `specs/system.md`: N/A, thay đổi hẹp trong validation import đã có.
- `architecture.md`, `design.md`, `databases/`: N/A.
- Cập nhật feature docs CBCLOUDV2-9386 sau implementation.

## 17. Sai lệch trong lúc triển khai

- Không có sai lệch về thiết kế hoặc phạm vi code.
- Repo `svinvoicesendemail` đã có sẵn thay đổi chưa commit ở `AppServiceTest.csproj` và file test `VehicleAssetImportHelperTests.cs` trước khi thực hiện CBCLOUDV2-9386. Task này giữ nguyên phần test có sẵn, chỉ cập nhật expected Email và bổ sung case khóa điều kiện loại đặc trưng 1.
- Manual import với tenant/file thật chưa chạy; được giữ ở trạng thái `not run` trong `testcase.md`.
