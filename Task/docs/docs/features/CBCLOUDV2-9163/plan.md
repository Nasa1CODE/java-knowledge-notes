# Plan CBCLOUDV2-9163 - Xuất Excel nâng cao bổ sung field hàng hóa đặc trưng

## Summary
- Bổ sung 2 field cấp hóa đơn `Mã tỉnh`, `Mã xã` và 16 field hàng hóa đặc trưng vào luồng **Xuất Excel nâng cao trong danh sách hóa đơn**.
- API lấy cấu hình cột: `services/hddt/DataInvoices/LoadDataForConfigsList`.
- API xuất Excel: `/hddt/HoaDon/XuatExcelNangCao`.
- Luồng trực tiếp xử lý ở BE `\XBill\Cloud\invoicecore`.
- Luồng xuất nền xử lý ở service `\XBill\Cloud\svinvoicesendemail`.
- FE `\XBill\Cloud\frontend_angular` render modal chọn cột theo response động từ API cấu hình nên không đổi request/response.
- Không thay đổi DB, không thêm validate, không ảnh hưởng xuất thuế suất.

## Field Contract
Cột cũ giữ nguyên thứ tự. Cột mới được sắp theo thứ tự file import: `Mã tỉnh`, `Mã xã`, sau đó đến nhóm hàng hóa đặc trưng.

### ListTongHop
Thêm 2 field cấp hóa đơn vào `DanhsachTruongTongHop()`:

| Id | Tên hiển thị | Nguồn dữ liệu |
|---:|---|---|
| 59 | Mã tỉnh | `HD_HoaDon_MoRong.Ma_Tinh` |
| 60 | Mã xã | `HD_HoaDon_MoRong.Ma_Xa` |

### ListChiTiet
Giữ nguyên các field chi tiết cũ id `39-58`. Bổ sung 16 field hàng hóa đặc trưng sau `Mã tỉnh`, `Mã xã`; tổng id xuất nâng cao mới chạy đến `76`.

| Id | Tên hiển thị | Nguồn dữ liệu |
|---:|---|---|
| 61 | Loại tài sản | `HD_ChiTiet_MoRong.LTSan` |
| 62 | Tình trạng tài sản | `HD_ChiTiet_MoRong.TTTSan` |
| 63 | Xuất xứ | `HD_ChiTiet_MoRong.XXu` |
| 64 | Số GCN chất lượng ATKT | `HD_ChiTiet_MoRong.SGCNATKThuat` |
| 65 | Số seri phiếu KTCL xuất xưởng | `HD_ChiTiet_MoRong.SSPKTCLXXuong` |
| 66 | Mã nước sản xuất | `HD_ChiTiet_MoRong.MNSXuat` |
| 67 | Tên loại tài sản đăng ký | `HD_ChiTiet_MoRong.TLTSDKy` |
| 68 | Năm sản xuất | `HD_ChiTiet_MoRong.NSXuat` |
| 69 | Tên thương mại | `HD_ChiTiet_MoRong.TTMai` |
| 70 | Tên nhãn hiệu | `HD_ChiTiet_MoRong.TNHieu` |
| 71 | Kiểu loại xe | `HD_ChiTiet_MoRong.KLXe` |
| 72 | Thể tích làm việc hoặc Công suất | `HD_ChiTiet_MoRong.TTLVHCSuat` |
| 73 | Trọng tải | `HD_ChiTiet_MoRong.TTai` |
| 74 | Số người cho phép chở | `HD_ChiTiet_MoRong.SCNgoi` |
| 75 | Chất lượng tài sản % | `HD_ChiTiet_MoRong.CLTSan` |
| 76 | Số biển kiểm soát | `HD_ChiTiet_MoRong.SBKSoat` |

Lưu ý tên cột DB đúng là `sspktclxxuong`, không dùng `sspktcclxxuong`.

## Chi tiết cần làm

### 1. BE `invoicecore` - API cấu hình cột
File cần sửa:
- `\XBill\Cloud\invoicecore\aspnet-core\src\hddt\HDDT.Application\AppServices\HoaDon\HoaDonAppService.cs`

Việc cần làm:
- Cập nhật `DanhsachTruongTongHop()` thêm `Mã tỉnh` id `59`, `Mã xã` id `60`.
- Cập nhật `DanhsachTruongChiTiet()` để nhóm hàng hóa đặc trưng dùng id `61-76`.
- Giữ nguyên field cũ id `1-38` và `39-58`.
- Không đổi `DanhsachTruongThueSuat()`.

### 2. BE `invoicecore` - Xuất Excel trực tiếp
File cần sửa:
- `\XBill\Cloud\invoicecore\aspnet-core\src\hddt\HDDT.Application\Commons\HoaDon\ExcelHelpers\NhapDSHoaDonExcelHelper.cs`

Việc cần làm:
- `ExportToFileHoaDonNangCao(...)`: thêm header/selector `Mã tỉnh`, `Mã xã`; map từ `HD_HoaDon_MoRong.Ma_Tinh`, `HD_HoaDon_MoRong.Ma_Xa`.
- `ExportToFileHoaDonNangCao(...)`: cập nhật logic xóa cột để hỗ trợ id không liên tục trong `ListTongHop` (`1-38`, `59-60`).
- `ExportToFileHoaDonNangCaoChitiet(...)`: thêm `Mã tỉnh`, `Mã xã` sau field cũ id `58`, rồi đến 16 field hàng hóa đặc trưng id `61-76`.
- `ExportToFileHoaDonNangCaoChitiet(...)`: cập nhật max field từ `74` lên `76`, gồm xóa cột và AutoFit/format.
- DTO export nội bộ thêm `Ma_Tinh`, `Ma_Xa`.
- `chuyendoidulieuexcel(...)` và `chuyendoidulieuexcelChitiet(...)` map `Ma_Tinh`, `Ma_Xa` từ `HD_HoaDon_MoRong`.

### 3. Service nền `svinvoicesendemail`
Files cần sửa:
- `\XBill\Cloud\svinvoicesendemail\AppServiceExportBillHost\AppService\Service\NhapDSHoaDonExcelHelper.cs`
- `\XBill\Cloud\svinvoicesendemail\AppServiceExportBillHost\AppService\Models\DTO.cs`
- `\XBill\Cloud\svinvoicesendemail\AppServiceExportBillHost\AppService\Domain\HD_HoaDon_MoRong.cs`
- `\XBill\Cloud\svinvoicesendemail\AppServiceExportBillHost\AppService\Repositories\HD_HoaDonRepository.cs`

Việc cần làm:
- Đồng bộ export tổng hợp và export chi tiết giống BE.
- DTO thêm `Ma_Tinh`, `Ma_Xa`.
- Domain `HD_HoaDon_MoRong` thêm `Ma_Tinh`, `Ma_Xa` để Dapper map từ `vs_hd_tonghop_morong`.
- Repository thêm `Mã tỉnh`, `Mã xã` vào điều kiện nhận diện trường mở rộng để join `vs_hd_tonghop_morong` khi export nền.

### 4. FE `frontend_angular`
Kết luận:
- Không cần sửa FE nếu modal đang render động từ `listTongHop` và `listChiTiet`.
- Cần verify modal hiển thị `Mã tỉnh`, `Mã xã` ở nhóm tổng hợp và 16 field hàng hóa đặc trưng theo id mới `61-76`.

## Test Plan
- Gọi `services/hddt/DataInvoices/LoadDataForConfigsList`, kiểm tra:
  - `listTongHop` có `Mã tỉnh` id `59`, `Mã xã` id `60`.
  - `listChiTiet` có đủ id `61-76`.
- Xuất tổng hợp chọn riêng `Mã tỉnh`, `Mã xã`, kiểm tra header và dữ liệu đúng.
- Xuất tổng hợp chọn subset field cũ + `Mã tỉnh/Mã xã`, kiểm tra không xóa lệch cột.
- Xuất chi tiết chọn `Mã tỉnh`, `Mã xã`, `Loại tài sản`, `Số GCN chất lượng ATKT`, `Số biển kiểm soát`, kiểm tra đúng thứ tự.
- Xuất chi tiết chọn toàn bộ field, kiểm tra tổng id chạy đến `76`, không lệch cột.
- Test luồng xuất trực tiếp trong BE.
- Test luồng xuất nền qua `svinvoicesendemail`.
- Regression: field cũ id `1-58` vẫn giữ nguyên thứ tự.
- Regression: xuất thuế suất không đổi.

## Impact
- Người dùng không chọn field mới thì file xuất cũ không đổi.
- Người dùng chọn `Mã tỉnh`, `Mã xã` thì hệ thống phải lấy thêm dữ liệu từ `HD_HoaDon_MoRong`.
- Export trực tiếp và export nền cần deploy đồng bộ để tránh lệch id field.
- Không phát sinh thay đổi DB và không yêu cầu migrate.
