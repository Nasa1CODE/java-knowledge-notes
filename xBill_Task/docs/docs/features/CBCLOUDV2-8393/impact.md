# CBCLOUDV2-8393 Impact Review

## Ảnh hưởng chính

- Backend import GTGT: ảnh hưởng trung bình, vì thay đổi cách tạo `HD_ThueSuat` từ group theo tên thuế sang group theo `MaThue + MucThue`.
- `HD_ChiTiet`: không đổi cách lưu. Mỗi dòng Excel/API vẫn lưu riêng.
- `HD_ThueSuat`: thay đổi dữ liệu summary. Các dòng cùng `MaThue + MucThue` sẽ gom một dòng, bao gồm dòng âm/CKTM/chiết khấu.
- Tiền thuế: không tính lại theo VAT%; summary lấy tổng từ dữ liệu import/lưu.
- Danh mục thuế Admin: chỉ đọc để lấy tên hiển thị, không cập nhật DB.
- API contract, DTO, DB schema, migration, backfill: không đổi.
- XML, ký số, truyền CQT, báo cáo, bảng kê: không đổi trực tiếp.
- Hóa đơn cũ đã import: không hồi tố.

## Tester Impact Notes

- Kiểm tra bảng `HD_ThueSuat` và màn “Thông tin từng loại thuế”: các dòng cùng `MaThue + MucThue` phải gom thành một dòng.
- `HD_ChiTiet` không được gom; số dòng chi tiết sau import/API vẫn giữ như dữ liệu đầu vào.
- `TongTien_Thue` summary phải bằng tổng `TongTien_Thue` chi tiết đã import/lưu, không tự tính lại theo VAT%.
- Case `10%` có dòng âm/chiết khấu: không tạo dòng `10%` âm riêng; phải cộng dồn vào dòng `10%` chính.
- Case `KKK + KKKNT` cùng ID hệ thống: phải gom một dòng, tên thuế lấy theo cấu hình Admin.
- Case nhiều VAT thật + CKTM: giữ behavior hiện tại là fail import.

## Service Import GTGT Impact

- Ảnh hưởng khi file GTGT có `soLuongHangHoa > 50`, cấu hình `ENABLE_IMPORT_SERVICE = 1`, backend gửi queue `TypeHd == gtgt`.
- File đúng 50 dòng hàng hóa không vào service nền; file 51 dòng có thể vào service nền nếu đủ cấu hình.
- Service nền phải tạo summary trong vòng lặp từng hóa đơn theo `TongHop_Id`, không cộng lẫn giữa các mã hóa đơn.

## VE_XE Import Impact

- Scope: Cloud import hóa đơn vé xe (`Mau_Loai_HD_DacThu = VE_XE`, `Mau_HinhThucNhap = 1`).
- Tổng bên phải giữ theo giá trị import: `TongHop_TongTien_ChuaVAT`, `TongHop_TienThue`, `TongHop_TongTien_CoVAT`, tiền bằng chữ, CKTM, tổng CKTM.
- Bảng thuế bên trái tính từ chi tiết, group theo `HangHoa_MaThue + HangHoa_Thue`.
- Với VE_XE import có `Tinh chat hang hoa = 5`, dòng hiển thị là chiết khấu và làm giảm summary bên trái. Chi tiết vẫn lưu riêng.

## Cross Reference

- Ảnh hưởng FE edit chiết khấu generic được theo dõi trong `CBCLOUDV2-8332`.
## Service Nền Sync Gap

- `svinvoicesendemail` là luồng tách riêng; GTGT service nền và VE_XE service nền hiện chưa thể coi là đồng bộ hoàn toàn với Cloud.
- Tester cần mở lại kiểm tra cho GTGT > 50 dòng, VE_XE `Tinh chat = 5`, tiền thuế chi tiết, và right-side totals sau khi code nền được sync.
## Service Nền Verification

- Build `AppServiceImportBillHost` đã pass với 0 errors; còn warnings môi trường cũ.
- Manual regression GTGT > 50 dòng và VE_XE nền vẫn cần tester chạy theo `testcase.md`.

## Update 2026-08-03 - Pre-Service Sync Impact

- Trước khi fix service khác, cần coi `CBCLOUDV2-8393` là nguồn rule cho import/backend/service: grouping tax summary, fallback right-side totals, và service nền GTGT/VE_XE.
- Service khác nếu import hóa đơn có chiết khấu phải giữ cùng nguyên tắc: chi tiết lưu riêng, summary cộng dồn theo mã/mức thuế, discount dương là khoản giảm nếu được map thành dòng chiết khấu, discount âm không trừ hai lần.
- Không dùng `CBCLOUDV2-8332` để suy luận backend import; `8332` chỉ cover FE edit/preserve khi user sửa hóa đơn import trên màn hình.
- Khi service tạo/lưu hóa đơn import, cần kiểm tra cả right-side totals được cung cấp từ file và fallback khi file để blank.

## Update 2026-09-04 - Decimal(21,7) Max Value Impact

- Ảnh hưởng trực tiếp tới validate import Excel các trường số: Số lượng, Đơn giá, Thành tiền và Tỷ giá.
- Ảnh hưởng cả hai đường xử lý:
  - Import đồng bộ trong `invoicecore` khi file không đi service nền.
  - Import nhiều dòng qua `svinvoicesendemail/AppServiceImportBillHost` khi đủ điều kiện queue/service nền.
- Giá trị `99999999999999.9999999` là biên tối đa theo `DECIMAL(21,7)` cho Số lượng/Đơn giá/Thành tiền và không bị chặn bởi validate max mới.
- Tỷ giá dùng rule riêng 7 số nguyên và 6 số thập phân; giá trị `9999999.999999` là biên tối đa hợp lệ.
- Giá trị lớn hơn biên tối đa sẽ bị chặn sớm bằng message vượt quá giá trị tối đa hoặc vượt quá 7 số nguyên và 6 số thập phân, tránh lỗi lưu DB khi quản lý xuất file/import nhiều.
- Không thay đổi cách tính tổng, group `HD_ThueSuat`, dữ liệu hóa đơn đã import trước đó, DB schema/migration, XML, ký số, gửi CQT, báo cáo hoặc export.
- Lưu ý kỹ thuật: thay đổi này chỉ sửa validation max/precision theo field; không thay đổi logic làm tròn hiện có.
