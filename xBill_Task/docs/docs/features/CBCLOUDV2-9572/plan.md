---
feature: CBCLOUDV2-9572
title: "[Import] [CLOUD] [xBill] Bổ sung validate của hàng hóa đặc trưng 1"
plan-status: implemented
service: invoicecore, svinvoicesendemail
service-repo: D:\XBill\Cloud\invoicecore; D:\XBill\Cloud\svinvoicesendemail
created_at: 2026-09-14
updated_at: 2026-09-14
---

# Plan - CBCLOUDV2-9572

## 1. Phạm vi

Triển khai đồng bộ trong:

- `D:\XBill\Cloud\invoicecore`: luồng import cloud/API chính.
- `D:\XBill\Cloud\svinvoicesendemail`: service nền xử lý import khi job được đẩy qua background service.

Tập trung vào validate import Excel cho:

- Import hóa đơn Bán hàng.
- Import hóa đơn GTGT.
- Import Vé xe.

Rule áp dụng khi bản ghi/dòng chi tiết import có hàng hóa đặc trưng loại `1`.

Rule import vẫn giữ gate hiện tại bằng cấu hình `ACTIVE_ND_254` qua `IsActiveND254()`. Khi `ACTIVE_ND_254` tắt thì không bật validate NĐ254 mới.

## 2. Rule Cần Chốt

Khi import có hàng hóa đặc trưng `1`:

| XML | Dữ liệu nghiệp vụ | Trạng thái |
|---|---|---|
| `<Ten>` | Tên đơn vị người mua | Bắt buộc |
| `<MST>` | MST/CCCD chủ hộ | Bắt buộc |
| `<CCCDan>` | CCCD người mua | Không bắt buộc |

`<CCCDan>` là optional. Nếu có nhập thì vẫn validate theo rule hiện tại, nếu có; nếu bỏ trống thì không được trả lỗi required.

## 3. Hướng Rà Soát Source

Tìm các vị trí import/validate liên quan:

- Helper đọc Excel import hóa đơn GTGT.
- Helper đọc Excel import Bán hàng.
- Helper đọc Excel import Vé xe.
- Validator chung hoặc duplicate validate cho hàng hóa đặc trưng loại `1`.
- Mapping từ row import sang entity `HD_HoaDon`/`HD_HoaDon_MoRong`.
- Mapping/sinh XML `<NMua><Ten>`, `<NMua><MST>`, `<NMua><CCCDan>` nếu import có bước preview/render.

Các từ khóa cần search:

```text
loaihoadondactrung
LoaiHangHoaDacTrung
Loai_HangHoa_DacTrung
CCCDan
dnmua_cccd
DNMua_CCCD
MST/CCCD
Tên đơn vị
Ten
MST
```

## 4. Thiết Kế Validate

Nên gom về một helper validate chung nếu ba luồng import đang duplicate logic:

```text
HasHangHoaDacTrung1 = any detail row has loaihoadondactrung/LoaiHangHoaDacTrung = 1

if HasHangHoaDacTrung1:
    require Ten
    require MST
    do not require CCCD
```

Quy tắc dữ liệu:

- String null/rỗng/whitespace sau trim được xem là thiếu.
- Tên đơn vị và MST/CCCD chủ hộ bắt buộc theo cấp hóa đơn/người mua, không phải theo từng dòng chi tiết.
- Nếu workbook có nhiều dòng cùng một hóa đơn, lỗi nên trả một lần theo hóa đơn hoặc theo dòng đầu tiên của hóa đơn, tùy pattern hiện có.
- Giữ cách cộng dồn lỗi hiện tại của import, không dừng ở lỗi đầu tiên nếu luồng đang cộng dồn.

## 5. Vị Trí Ảnh Hưởng Dự Kiến

| Thành phần | Ảnh hưởng |
|---|---|
| Đọc Excel | Không đổi mapping cột nếu các cột đã có sẵn |
| Validate import | Thêm required `<Ten>`, `<MST>` khi có hàng hóa đặc trưng `1`; bỏ required `<CCCDan>` |
| Mapping DB | Giữ nguyên |
| XML | Giữ nguyên schema; đảm bảo dữ liệu required đã có trước khi sinh |
| File mẫu Excel | Chưa đổi nếu không cần |

## 6. Chi Tiết Service Nền `svinvoicesendemail`

Service nền có bộ helper import riêng, không dùng trực tiếp helper của `invoicecore`, nên phải sửa đồng bộ để tránh lệch hành vi giữa import trực tiếp và import qua job nền.

### Hiện trạng đã rà

| File | Dòng/Method | Hiện trạng |
|---|---|---|
| `D:\XBill\Cloud\svinvoicesendemail\AppServiceImportBillHost\AppService\Process.cs` | `IsActiveND254()` dòng 182, 328 | Đã đọc config `ACTIVE_ND_254`; không cần đổi gate |
| `D:\XBill\Cloud\svinvoicesendemail\AppServiceImportBillHost\AppService\Process.cs` | dòng 190, 217, 337, 344, 371 | Đã truyền `activeND254` vào import GTGT/BH/Vé xe |
| `D:\XBill\Cloud\svinvoicesendemail\AppServiceImportBillHost\AppService\Models\VehicleAssetImportHelper.cs` | `ValidateBuyerFields` dòng 252 | Validator chung cho người mua khi có hàng hóa đặc trưng `1` |
| `D:\XBill\Cloud\svinvoicesendemail\AppServiceImportBillHost\AppService\Models\VehicleAssetImportHelper.cs` | `ValidateBuyerFields` | Hiện đang required `nguoimuahang`, `diachi`, `sdt`; chưa required `tendonvi`, `mst`; không required `cccd` |
| `D:\XBill\Cloud\svinvoicesendemail\AppServiceImportBillHost\AppService\Service\NhapDSHoaDonExcelHelper.cs` | dòng 100, 1177 | GTGT gọi validate NĐ254 khi `activeND254` và dòng là hàng hóa đặc trưng `1` |
| `D:\XBill\Cloud\svinvoicesendemail\AppServiceImportBillHost\AppService\Service\BanHang_ExcelHelper.cs` | dòng 95, 967 | Bán hàng gọi validate NĐ254 khi `activeND254` và dòng là hàng hóa đặc trưng `1` |
| `D:\XBill\Cloud\svinvoicesendemail\AppServiceImportBillHost\AppService\Service\ImportVeXeHelper.cs` | dòng 220, 1203 | Vé xe gọi validate NĐ254 khi `activeND254` và dòng là hàng hóa đặc trưng `1` |

### Cần sửa

1. Sửa `D:\XBill\Cloud\svinvoicesendemail\AppServiceImportBillHost\AppService\Models\VehicleAssetImportHelper.cs`, method `ValidateBuyerFields`.
2. Bổ sung required:
   - `data.tendonvi` với message theo pattern hiện tại, ví dụ `Tên đơn vị không được để trống.`
   - `data.mst` với message theo nghiệp vụ `MST/CCCD chủ hộ không được để trống.`
3. Không thêm required cho `data.cccd`. Nếu `cccd` có dữ liệu thì vẫn giữ validate độ dài hiện tại ở từng helper đọc Excel.
4. Không sửa `Process.cs` về gate `ACTIVE_ND_254`, vì service nền đã truyền `activeND254` đúng vào ba luồng import.
5. Không đổi mapping:
   - GTGT map `DNMua_MST = data.mst`, `DNMua_Ten = data.tendonvi` tại `NhapDSHoaDonExcelHelper.cs` dòng 1292-1293.
   - Bán hàng map `DNMua_MST = data.mst`, `DNMua_Ten = data.tendonvi` tại `BanHang_ExcelHelper.cs` dòng 1080-1081.
   - `DNMua_CCCD = hdrow.cccd` đang optional ở GTGT dòng 125, BH dòng 120, Vé xe dòng 244.

## 7. Test/Build Dự Kiến

Sau khi sửa source:

- Build project `HDDT.Application`.
- Build project `D:\XBill\Cloud\svinvoicesendemail\AppServiceImportBillHost\AppService\AppService.csproj`.
- Chạy test import hiện có nếu project test khả dụng.
- Manual import file mẫu Bán hàng, GTGT, Vé xe với các case thiếu `<Ten>`, thiếu `<MST>`, thiếu `<CCCDan>` trên cả import trực tiếp và import qua service nền.

## 8. Ngoài Scope

- Không thay đổi API tích hợp `api-cloud-service`.
- Không đổi config `ACTIVE_ND_254`; chỉ giữ gate hiện có.
