---
feature: CBCLOUDV2-9572
title: "[Import] [CLOUD] [xBill] Bổ sung validate của hàng hóa đặc trưng 1"
status: implemented
created_at: 2026-09-14
updated_at: 2026-09-14
---

# Tasks - CBCLOUDV2-9572

## Tổng Quan

| # | Công việc | Repository | Trạng thái | Ghi chú |
|---|---|---|---|---|
| 1 | Rà soát import Bán hàng | invoicecore | done | Đã xác định dùng `ValidateVehicleAssetImportBuyerFields` |
| 2 | Rà soát import GTGT | invoicecore | done | Đã xác định dùng `ValidateVehicleAssetImportBuyerFields` |
| 3 | Rà soát import Vé xe | invoicecore | done | Đã xác định dùng `ValidateVehicleAssetImportBuyerFields` |
| 4 | Chốt field người mua map `<Ten>`, `<MST>`, `<CCCDan>` | invoicecore/docs | done | `<Ten>` = `tendonvi`, `<MST>` = `mst`, `<CCCDan>` = `cccd` |
| 5 | Bổ sung required tên đơn vị khi có hàng hóa đặc trưng `1` | invoicecore | done | Đã thêm check `data.tendonvi` |
| 6 | Bổ sung required MST/CCCD chủ hộ khi có hàng hóa đặc trưng `1` | invoicecore | done | Đã thêm check `data.mst` |
| 7 | Bỏ required CCCD trong rule hàng hóa đặc trưng `1` | invoicecore | done | Không thêm required `data.cccd` |
| 8 | Regression ba loại import | invoicecore | done | Build `HDDT.Application` pass |
| 9 | Rà soát service nền import | svinvoicesendemail | done | Đã xác định service có helper riêng và gate `ACTIVE_ND_254` sẵn |
| 10 | Bổ sung required tên đơn vị trong validator nền | svinvoicesendemail | done | Đã sửa `Models\VehicleAssetImportHelper.cs` method `ValidateBuyerFields` |
| 11 | Bổ sung required MST/CCCD chủ hộ trong validator nền | svinvoicesendemail | done | Đã sửa `Models\VehicleAssetImportHelper.cs` method `ValidateBuyerFields` |
| 12 | Giữ CCCD optional trong service nền | svinvoicesendemail | done | Đã thêm test đảm bảo không required `data.cccd` |
| 13 | Regression ba loại import qua service nền | svinvoicesendemail | done | `dotnet test AppServiceTest.csproj` pass 26/26 |
| 14 | Cập nhật report sau khi code/test | docs | done | Đã ghi build/test |

## Checklist Dev

- [x] Không đổi DB schema.
- [x] Không đổi XML schema.
- [x] Không đổi layout file mẫu.
- [x] Không ảnh hưởng hàng hóa đặc trưng loại `2/3`.
- [x] Không làm required CCCD quay lại qua validator duplicate.
- [x] Message lỗi giữ pattern import hiện tại.
- [x] Đồng bộ rule giữa `invoicecore` và `svinvoicesendemail`.
- [x] Giữ gate import qua `ACTIVE_ND_254`/`IsActiveND254()`.

## Kết Luận Hiện Trạng

Đã rà source `invoicecore` và `svinvoicesendemail`, đã sửa code theo Plan và đã chạy build/test.

Service nền `D:\XBill\Cloud\svinvoicesendemail` đã sửa đồng bộ tại `AppServiceImportBillHost\AppService\Models\VehicleAssetImportHelper.cs`, method `ValidateBuyerFields`.
