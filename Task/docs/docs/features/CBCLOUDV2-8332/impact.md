# CBCLOUDV2-8332 Impact

## Ảnh hưởng FE chiết khấu

- Scope: chỉ Cloud frontend edit trong `D:\XBill\Cloud\frontend_angular`.
- Ảnh hưởng cao: hóa đơn có dòng chiết khấu (`HangHoa_Loai = 3`) được sửa trên màn hóa đơn gốc.
- Ảnh hưởng trung bình: hóa đơn import khi user sửa bảng thuế bên trái.
- Ảnh hưởng thấp: hóa đơn không có dòng chiết khấu, vì branch normalize dương cũ vẫn áp dụng cho non-discount.
- Bảng thuế bên trái (`dsThueSuat`) giữ contribution âm cho `TongTien_ChiuThue` và `TongTien_Thue` của dòng chiết khấu.
- Tổng bên phải của hóa đơn import chỉ được preserve trong flow sửa summary; sửa chi tiết vẫn tính lại từ dữ liệu UI hiện tại.
- Cần regression: hóa đơn điều chỉnh, MTT, VE_XE, NUOC/DIEN, custom rounding, dữ liệu legacy chiết khấu.

## Update 2026-08-03 - Import Discount FE Impact

- Ảnh hưởng cao: hóa đơn import có dòng chiết khấu (`mau_HinhThucNhap == 1`, `HangHoa_Loai = 3`) vì vừa phải giữ contribution âm ở bảng thuế bên trái vừa phải preserve tổng import bên phải.
- `dsThueSuat.TongTien_ChiuThue` và `dsThueSuat.TongTien_Thue` phải coi discount dương là khoản giảm; discount đã âm không được trừ hai lần.
- Flow sửa summary bên trái preserve `TongHop_TongTien_ChuaVAT`, `TongHop_TienThue`, `TongHop_TongTien_CoVAT`, `TongHop_TongTien_CoVAT_Chu`, `TongHop_TongTien_KhoanKhac`, `TongHop_TongTien_ChietKhau_ThuongMai`.
- Flow sửa detail-row vẫn tính lại tổng bên phải theo UI, vì đó là chủ đích user thay đổi dữ liệu hóa đơn.
- Cần regression save/open lại để chắc payload FE không gửi tổng hoặc dấu đã bị normalize sai.
