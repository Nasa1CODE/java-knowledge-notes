# CBCLOUDV2-8336 Impact (Draft - lập trong giai đoạn planning, cần finalize sau khi implementation/verify xong)

## Purpose

Đánh giá phạm vi ảnh hưởng của việc bỏ bắt buộc một số trường cho dòng hàng hóa loại Ghi chú (`loaihanghoa == 2`) khi nhập Excel danh sách hóa đơn — CBCLOUDV2-8336. **Đã xác nhận (user): ticket ảnh hưởng 2 loại mẫu hóa đơn**:
- **Mẫu hóa đơn ký hiệu 2** (bán hàng, C26TNT, `LoaiHoaDonMau.banhang = 2` trong `EnumCommons.cs`): bỏ bắt buộc Thành tiền, Tỷ lệ tính thuế trên doanh thu.
- **Mẫu hóa đơn ký hiệu 5** (vé xe; mã loại nội bộ dùng để route là `LoaiHoaDonMau.vexe = 6`, nhưng mẫu số/ký hiệu hiển thị cho người dùng là `5`, xác nhận qua `frontend_angular` — `loaiHoaDon_MauSo == '5' && loai_HD_DacThu == 'VE_XE'`): bỏ bắt buộc Đơn vị tính, Số lượng, Đơn giá, Thành tiền, VAT, Tiền thuế chi tiết.

## Phạm vi thay đổi / Change scope

- Logic-only. Không thay đổi schema database, không có migration, không thay đổi contract API công khai (chỉ thay đổi điều kiện validate nội bộ, message lỗi trả về ít hơn trong một số trường hợp, không thêm/xóa field DTO).
- Không thay đổi config, không thay đổi cấu trúc queue/message payload.

## Thành phần bị ảnh hưởng / Affected components

| Layer | File / Method | Impact level | Ghi chú |
| --- | --- | --- | --- |
| Backend (invoicecore) | `HDDT.Application/Commons/HoaDon/ExcelHelpers/NhapDSHoaDonExcelHelper.cs` → `ValidateAndGetData_BH` | Trung bình | Đường nhập Excel trực tiếp (≤50 dòng hoặc import-service tắt), mẫu ký hiệu 2 (bán hàng/C26TNT) |
| Backend (invoicecore) | Cùng file → `ValidateAndGetData_VeXe` | Trung bình | Đường nhập Excel trực tiếp, mẫu ký hiệu 5 (vé xe) |
| Backend (svinvoicesendemail) | `AppServiceImportBillHost/AppService/Service/BanHang_ExcelHelper.cs` → `ValidateAndGetData` | Trung bình | Đường nhập Excel qua queue/worker (>50 dòng hoặc import-service bật), mẫu ký hiệu 2 |
| Backend (svinvoicesendemail) | `AppServiceImportBillHost/AppService/Service/ImportVeXeHelper.cs` → `ValidateAndGetData` | Trung bình | Đường nhập Excel qua queue/worker, mẫu ký hiệu 5 |
| Database | Không | N/A | Không có bảng/cột nào bị đổi |
| Config/Queue | Không | N/A | Không đổi `QueueImportHoaDon`, không đổi `ImportHoaDonData` |
| Frontend | Không | N/A | Không cần đổi UI, validate hoàn toàn ở backend |

## Không thuộc phạm vi / Confirmed unaffected

- `NhapDSHoaDonExcelHelper.ValidateAndGetData` (mẫu giá trị gia tăng) — đã có `if (data.loaihanghoa != 2)` bọc toàn bộ block Thành tiền/thuế từ trước khi ticket này bắt đầu; không bị lỗi, không cần sửa.
- `svinvoicesendemail/AppServiceImportBillHost/AppService/Service/NhapDSHoaDonExcelHelper.cs` (bản sao mẫu giá trị gia tăng cho worker) — cùng lý do trên.
- `ValidateAndGetData_THUOC`, `ValidateAndGetData_NUOC`, `ValidateAndGetData_PhieuXuatKho`, `ValidateAndGetData_TaiSanCong` và các hàm mẫu khác trong `invoicecore/.../NhapDSHoaDonExcelHelper.cs` — các mẫu này không có cột "Loại hàng hóa"/"Tỷ lệ tính thuế trên doanh thu" theo layout Ghi chú tương ứng, không áp dụng.
- `ExcelNewCaHelper.cs` (dùng riêng cho `TENANT_NEWCA`) — không có field `loaihanghoa`.
- `api-cloud-service/.../GuiHoaDonAppService.cs`, `InvoiceValidation.cs` (api-cloud-service, api-qldv-service) — thuộc luồng gửi hóa đơn qua API/XML (`item.tyletinhthue`), không cùng cơ chế `loaihanghoa`/nhập Excel, không liên quan ticket này.
- Không có Báo cáo hóa đơn, không có màn hình khác bị ảnh hưởng.

## Rủi ro / Hạn chế đã biết / Known risks and limitations

- **Chưa xác nhận với BA**: hành vi khi Ghi chú nhập Thành tiền = 0 chủ động — hiện tại giá trị sẽ không được gán vào `data.thanhtien` (giữ `null`) vì toàn bộ block bị bỏ qua, không phân biệt "không nhập" và "nhập = 0". Cần BA xác nhận đây là hành vi mong muốn.
- **Rủi ro `int.Parse`**: nhánh xử lý Tỷ lệ tính thuế (mẫu bán hàng) dùng `int.Parse` không an toàn, có thể throw `FormatException` không được bắt nếu dòng Ghi chú nhập dữ liệu rác. Chưa quyết định có đưa vào scope ticket này (xem `plan.md` Task 3, chờ TechLead).
- **Đã xác nhận (không còn là rủi ro mở)**: ticket chính thức ảnh hưởng cả 2 mẫu hóa đơn (ký hiệu 2 - bán hàng, ký hiệu 5 - vé xe). Bug report gốc chỉ mô tả mẫu ký hiệu 2 nhưng user đã xác nhận mẫu ký hiệu 5 cũng thuộc scope. Ghi lại ở đây để tránh nhầm lẫn cho QA khi so với bug report gốc.
- **Rủi ro kiến trúc có sẵn, không phải do ticket này gây ra**: `invoicecore` và `svinvoicesendemail` chứa các bản sao code validate riêng biệt (không share code) cho mỗi mẫu hóa đơn. Mọi thay đổi validate loại này trong tương lai cần áp dụng đồng thời ở cả 2 nơi cho từng mẫu, nếu không sẽ gây khác biệt hành vi tùy theo số dòng file Excel (route khác nhau).
- Đã review downstream builders (`GetChiTiet_BH`/`GetHoaDon_BH`, `GetChiTiet_VeXe`/`GetHoaDon_VeXe` trong invoicecore; `GetHoaDon`/`GetChiTiet` trong `BanHang_ExcelHelper.cs`; `HoaDonHelper.GetChiTiet` dùng bởi `ImportVeXeHelper`) bằng đọc code tĩnh — tất cả xử lý `null` an toàn (`?? 0`, `x > 0 ? x : null`), không phát hiện `NullReferenceException`/tính sai số liệu. Chưa verify bằng test thực tế.

## Chưa được kiểm chứng / Not verified

- `git pull` trong `docs/` chưa xác nhận thành công trong phiên làm việc này (lỗi công cụ shell).
- Chưa chạy `dotnet build` cho cả 2 project (`HDDT.Application.csproj`, `AppService.csproj` của `AppServiceImportBillHost`).
- Chưa test thủ công trên môi trường thực/staging theo Acceptance Criteria trong `expect.md`.
- Chưa xác nhận đường queue/worker (>50 dòng) hoạt động đúng trong môi trường có RabbitMQ thực.

## Kết luận / Conclusion

Rủi ro tổng thể: **Thấp-Trung bình**. Thay đổi giới hạn ở 4 hàm validate (2 mẫu hóa đơn — ký hiệu 2 bán hàng và ký hiệu 5 vé xe — x 2 code path mỗi mẫu), không đổi schema/contract, đã xác nhận downstream builders xử lý an toàn qua đọc source trực tiếp. Scope 2 mẫu hóa đơn đã được xác nhận. Điểm còn cần quyết định trước khi release: (1) xác nhận với BA về hành vi "Thành tiền = 0"; (2) xác nhận với TechLead việc có nhận Task 3 (TryParse) vào scope. Khuyến nghị chạy build thực tế (`dotnet build` cả 2 project) trước khi xin Gate 1 approve.
