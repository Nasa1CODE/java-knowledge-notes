# CBCLOUDV2-8393 Expect

## Tóm tắt

Fix Import GTGT để summary thuế suất phản ánh đúng dữ liệu đã import: cùng thuế suất theo ID hệ thống thì gom một dòng trong `HD_ThueSuat`, không tách dòng vì khác/raw/null `HangHoa_TenThue`.

## Kỳ vọng lưu dữ liệu

- `HD_ChiTiet` vẫn lưu riêng từng dòng hàng hóa import từ Excel/API.
- `HD_ThueSuat` gom mọi dòng cùng `MaThue + MucThue` thành một dòng summary.
- Không so sánh raw text như `KKK`, `KKKNT`, `10%` để quyết định cùng loại thuế; mã đầu vào vẫn phải map về ID hệ thống trước.
- Không dùng `HangHoa_TenThue` làm key group vì dòng âm/CKTM/chiết khấu có thể null hoặc khác tên.
- `HD_ThueSuat.TenThue` lấy từ `ThueSuat_Ten` cấu hình Admin, fallback tên đã import nếu không tìm thấy cấu hình.
- Khác VAT thật + CKTM vẫn fail import như hiện tại.

## Công thức cần giữ

- `TongHop_TongTien_KhoanKhac` là CKTM cấp hóa đơn import từ Excel/API.
- `HD_ThueSuat.TongTien_ChiuThue = Sum(TongTien_ChuaThue)` của các dòng cùng `MaThue + MucThue`.
- `HD_ThueSuat.TongTien_Thue = Sum(TongTien_Thue)` của các dòng cùng `MaThue + MucThue`.
- Không tự tính lại `TongTien_Thue = TongTien_ChiuThue * VAT%` trong scope này.
- `TongHop_TongTien_ChuaVAT`, `TongHop_TienThue`, `TongHop_TongTien_CoVAT` phải dựa trên dữ liệu đã lưu/cộng dồn, không trừ CKTM lặp lần hai.

## Ví dụ bắt buộc

- Case `10%`: trước group có `10% | 180.000 | 0` và `10% | -10.000 | -1.000`; sau group phải là một dòng `10% | 170.000 | -1.000`.
- Case `KKK + KKKNT` cùng ID: chi tiết lưu riêng, summary gom một dòng tên theo Admin, tiền thuế là tổng dữ liệu import, thường là `0`.

## Out Of Scope

- Không tính lại tiền thuế theo VAT% nếu import/API đã gửi tiền thuế chi tiết.
- Không đổi DB schema, migration, backfill hóa đơn cũ.
- Không đổi XML, ký số, truyền CQT, báo cáo, bảng kê.
- Không đổi behavior nhiều VAT thật + CKTM từ fail sang warning.
- Generic FE discount edit calculation nằm ở `CBCLOUDV2-8332`.
- Service nền `svinvoicesendemail` là luồng riêng; cho tới khi Task 6 hoàn tất, không dùng kết quả Cloud để kết luận đã sync phần GTGT/VE_XE nền.

## Update 2026-08-03 - Pre-Service Sync Expectation

- Khi fix tương tự ở service khác, rule import phải đồng bộ với Cloud: `HD_ChiTiet` lưu riêng, `HD_ThueSuat` group theo `HangHoa_MaThue + HangHoa_Thue`, không group theo `HangHoa_TenThue`.
- Dòng âm/CKTM/chiết khấu chỉ cộng dồn dữ liệu import/lưu vào summary, không tự tính lại thuế theo VAT%.
- Nếu file/API có right-side total thì giữ giá trị import; nếu blank thì fallback từ `HD_ThueSuat` sau khi build detail/summary.
- FE edit import discount nằm ở `CBCLOUDV2-8332`; service sync không được coi là thay thế regression FE save/open.
