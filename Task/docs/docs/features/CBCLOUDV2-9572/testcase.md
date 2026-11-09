---
feature: CBCLOUDV2-9572
updated_at: 2026-09-14
---

# Testcase - CBCLOUDV2-9572

## Matrix Chung

Chạy matrix dưới đây cho từng loại import:

- Bán hàng.
- GTGT.
- Vé xe.

Chạy trên cả hai luồng:

- Import trực tiếp/cloud qua `D:\XBill\Cloud\invoicecore`.
- Import nền qua `D:\XBill\Cloud\svinvoicesendemail`.

| ID | Input | Kết quả mong đợi |
|---|---|---|
| TC-01 | Hàng hóa đặc trưng `1`, thiếu tên đơn vị | Báo lỗi tên đơn vị/`<Ten>` không được để trống |
| TC-02 | Hàng hóa đặc trưng `1`, tên đơn vị chỉ có khoảng trắng | Báo lỗi tên đơn vị/`<Ten>` không được để trống |
| TC-03 | Hàng hóa đặc trưng `1`, thiếu MST/CCCD chủ hộ | Báo lỗi MST/CCCD chủ hộ/`<MST>` không được để trống |
| TC-04 | Hàng hóa đặc trưng `1`, MST/CCCD chủ hộ chỉ có khoảng trắng | Báo lỗi MST/CCCD chủ hộ/`<MST>` không được để trống |
| TC-05 | Hàng hóa đặc trưng `1`, thiếu CCCD người mua | Không báo lỗi required CCCD/`<CCCDan>` |
| TC-06 | Hàng hóa đặc trưng `1`, đủ tên đơn vị + MST/CCCD chủ hộ, CCCD rỗng | Import thành công nếu không lỗi rule khác |
| TC-07 | Hàng hóa đặc trưng `1`, đủ tên đơn vị + MST/CCCD chủ hộ + CCCD | Import thành công nếu không lỗi rule khác; CCCD vẫn lưu/map theo rule hiện tại |
| TC-08 | Không có hàng hóa đặc trưng `1`, thiếu tên đơn vị | Giữ hành vi cũ |
| TC-09 | Không có hàng hóa đặc trưng `1`, thiếu MST/CCCD chủ hộ | Giữ hành vi cũ |
| TC-10 | Hàng hóa đặc trưng `2/3`, thiếu CCCD | Không áp required CCCD theo rule loại `1` |
| TC-11 | Một hóa đơn nhiều dòng, chỉ một dòng là loại `1`, thiếu tên đơn vị | Báo lỗi required tên đơn vị |
| TC-12 | Một hóa đơn nhiều dòng, chỉ một dòng là loại `1`, thiếu MST/CCCD chủ hộ | Báo lỗi required MST/CCCD chủ hộ |
| TC-13 | `ACTIVE_ND_254` tắt, hàng hóa đặc trưng `1`, thiếu tên đơn vị | Không bật rule required mới; giữ hành vi cũ |
| TC-14 | `ACTIVE_ND_254` tắt, hàng hóa đặc trưng `1`, thiếu MST/CCCD chủ hộ | Không bật rule required mới; giữ hành vi cũ |

## Riêng Service Nền

Khi test `D:\XBill\Cloud\svinvoicesendemail`, cần xác nhận:

- Job GTGT đi qua `AppServiceImportBillHost\AppService\Service\NhapDSHoaDonExcelHelper.cs`.
- Job Bán hàng đi qua `AppServiceImportBillHost\AppService\Service\BanHang_ExcelHelper.cs`.
- Job Vé xe đi qua `AppServiceImportBillHost\AppService\Service\ImportVeXeHelper.cs`.
- `Process.cs` truyền đúng `activeND254` lấy từ `IsActiveND254()`.
- Lỗi thiếu `tendonvi`/`mst` xuất hiện từ `Models\VehicleAssetImportHelper.cs`, method `ValidateBuyerFields`.
- Không có lỗi required cho `cccd` khi `<CCCDan>` rỗng.

## Regression

- Import file hợp lệ hiện tại không có hàng hóa đặc trưng `1`.
- Import file hợp lệ có hàng hóa đặc trưng `1` và đủ `<Ten>`, `<MST>`.
- Import file có lỗi nhiều dòng để kiểm tra cách cộng dồn lỗi không bị thay đổi.
- Kiểm tra preview/lưu/sinh XML nếu luồng import có bước sinh file ngay sau import.
