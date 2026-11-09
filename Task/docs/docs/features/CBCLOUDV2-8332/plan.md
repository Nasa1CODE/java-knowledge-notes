# CBCLOUDV2-8332 Plan

## Tóm tắt

Sửa FE edit recalculation cho hóa đơn chiết khấu trong Cloud frontend. Scope chỉ `D:\XBill\Cloud\frontend_angular`.

## Changes

- Sửa `hoadon.service.ts`:
  - thêm helper capture/restore tổng import;
  - thêm preserve mode cho flow sửa summary;
  - giữ contribution âm của dòng chiết khấu trong tax summary;
  - giữ behavior cũ cho hóa đơn không có chiết khấu và branch hóa đơn điều chỉnh.
- Sửa `hoadon-goc.component.html`:
  - chỉ các field bảng thuế bên trái gọi preserve mode;
  - detail-row và tổng bên phải vẫn dùng flow tính lại bình thường.
- Không sửa backend, import Excel/API, DB schema, XML, ký số, báo cáo, hoặc dữ liệu cũ.

## Update 2026-08-03 - Import Discount FE Plan Addendum

- Đối chiếu code FE import discount trước khi sync tương tự sang service khác.
- Xác nhận helper capture/restore tổng import chỉ dùng cho flow sửa bảng thuế bên trái.
- Xác nhận rule dấu âm cho `HangHoa_Loai = 3`: amount/tax dương chuyển thành contribution âm; amount/tax âm giữ nguyên.
- Bổ sung testcase save/open lại cho hóa đơn import có chiết khấu để xác nhận payload FE không overwrite sai tổng import.
