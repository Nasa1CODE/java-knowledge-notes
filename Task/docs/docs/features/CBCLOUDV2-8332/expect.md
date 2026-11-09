# CBCLOUDV2-8332 Expect

## Tóm tắt

Fix tính toán khi người dùng edit hóa đơn có dòng chiết khấu (`HangHoa_Loai = 3`) trên frontend Cloud. Scope chỉ FE trong `D:\XBill\Cloud\frontend_angular`, không đổi backend/import/API/DB/XML/ký số/báo cáo.

## Kỳ vọng

- Dòng chiết khấu làm giảm tiền chịu thuế và tiền thuế ở bảng summary bên trái.
- Nếu tiền thuế chiết khấu đang là số dương, summary coi đó là khoản giảm.
- Nếu tiền thuế chiết khấu đã âm, summary giữ dấu âm và không trừ hai lần.
- Hóa đơn import (`mau_HinhThucNhap == 1`) giữ nguyên tổng bên phải khi user sửa bảng thuế bên trái.
- Khi user sửa dòng chi tiết, tổng bên phải vẫn tính lại bình thường theo dữ liệu UI hiện tại.

## Update 2026-08-03 - Import Discount FE

- Hóa đơn import (`mau_HinhThucNhap == 1`) có dòng chiết khấu (`HangHoa_Loai = 3`) vẫn áp dụng cùng rule dấu âm cho bảng thuế bên trái.
- Nếu amount/tax chiết khấu import đang dương, FE coi là khoản giảm khi dựng `dsThueSuat`; nếu đã âm thì giữ âm và không trừ hai lần.
- Khi user sửa bảng thuế bên trái, các tổng bên phải `TongHop_*` của hóa đơn import phải được preserve.
- Khi user sửa dòng chi tiết, tổng bên phải vẫn tính lại theo dữ liệu UI hiện tại.
- Khi lưu và mở lại hóa đơn import có chiết khấu, payload FE không được làm đảo dấu hoặc overwrite sai các tổng đã preserve.
