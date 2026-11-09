# CBCLOUDV2-8919 Impact

## Mục tiêu

Đánh giá ảnh hưởng của việc hiển thị và khởi tạo checkbox CKTM (`Hóa đơn chiết khấu thương mại`) trên các màn tạo hóa đơn vé máy bay, hóa đơn bán hàng và hóa đơn gốc.

## Thành phần bị ảnh hưởng / Affected components

| Layer | File / Component | Impact level | Ghi chú |
| --- | --- | --- | --- |
| Frontend | `src/app/hddt/hoadon/vemaybay/vemaybay.component.html` | Trung bình | Mở checkbox cho `mau_HoaDon_Loai` 1, 3, 5 |
| Frontend | `src/app/hddt/hoadon/vemaybay/vemaybay.component.ts` | Trung bình | Map `quanLy_XacThuc_Loai` từ `hoaDonGoc` sang form hiện tại |
| Frontend | `src/app/hddt/hoadon/hoadonbanhang/hoadonbanhang.component.html` | Trung bình | Mở checkbox cho `mau_HoaDon_Loai` 1, 3, 5 |
| Frontend | `src/app/hddt/hoadon/hoadonbanhang/hoadonbanhang.component.ts` | Trung bình | Map trạng thái CKTM từ hóa đơn gốc |
| Frontend | `src/app/hddt/hoadon/quanlyhoadon/hoadon-goc.component.html` | Trung bình | Mở checkbox cho `mau_HoaDon_Loai` 1, 3, 5 |
| Frontend | `src/app/hddt/hoadon/quanlyhoadon/hoadon-goc.component.ts` | Trung bình | Map trạng thái CKTM từ hóa đơn gốc |
| Database | `vs_hd_tonghop.QuanLy_XacThuc_Loai` | Thấp | Field lưu trạng thái checkbox, không đổi schema |

## Không bị ảnh hưởng / Confirmed unaffected

- Logic lưu tổng CKTM `TongHop_TongTien_KhoanKhac` không đổi.
- Luồng lưu hóa đơn và ký hóa đơn không đổi.
- BE `GetHoaDonBiDieuChinh` không bị sửa.

## Rủi ro / Risks

- Nếu hóa đơn gốc không có `QuanLy_XacThuc_Loai`, checkbox sẽ không tự tick.
- Nếu một màn khác bind cùng field nhưng không copy từ `hoaDonGoc`, UI có thể lệch trạng thái.

## Ghi chú

- Đây là thay đổi FE hiển thị + bind state, không đổi cách persist DB.
- Cần build FE và kiểm tra thủ công 3 màn: vé máy bay, bán hàng, hóa đơn gốc.
