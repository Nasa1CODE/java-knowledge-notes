# Plan — CBCLOUDV2-9475: Cấu hình phương thức thanh toán mặc định khi lập hóa đơn

> DEV sở hữu. Sinh cùng AI theo [rules/01-create-plan.md](../../rules/01-create-plan.md).
> Status vòng đời feature nằm ở `expect.md`. Ở đây chỉ là trạng thái của bản plan.

plan-status: approved   # draft → plan-review → approved

service: invoicecore, frontend_angular
service-repo: invoicecore, frontend_angular

## Câu hỏi chặn (blocking)

- Không có câu hỏi chặn.

## Mục tiêu

Giải quyết các tiêu chí chấp nhận AC1 - AC9 trong `expect.md`:
- Cho phép người dùng cấu hình phương thức thanh toán mặc định tại Cấu hình doanh nghiệp.
- Tự động điền phương thức mặc định khi tạo mới hóa đơn (thường, POS, điều chỉnh).
- Fallback về Tiền mặt (mã 1) khi tắt/chưa cấu hình/phương thức hết hiệu lực.
- Sao chép đủ mã và tên phương thức cho hóa đơn thay thế; hóa đơn điều chỉnh lấy theo cấu hình mặc định.
- Bảo vệ phương thức thanh toán tùy chỉnh (mã 0) và lựa chọn của người dùng khi sửa hóa đơn.

## Bối cảnh

Hệ thống BillCloud gồm backend ASP.NET Zero/ABP (.NET Core 3.1) trong `invoicecore` và frontend Angular 6 trong `frontend_angular`.
Dữ liệu cấu hình doanh nghiệp lưu trong bảng `vs_doanhnghiep_cauhinh` của database tenant.
Danh mục phương thức thanh toán lưu trong bảng `vs_dm_ncc_phuongthucthanhtoan` ở tầng Host (`MultiTenancySides.Host`).

## Nguyên nhân gốc (nếu là bug)

Tại `HoaDonAppService.InforHoaDonTongHop` và `hoadon.service.ts`, mã nguồn đang gán cứng:
`if (result.ThanhToan_PhuongThuc == 0) result.ThanhToan_PhuongThuc = 1;` và `if (!hd.thanhToan_PhuongThuc) hd.thanhToan_PhuongThuc = 1;`.
Logic này bỏ qua cấu hình người dùng và vô tình ghi đè phương thức tùy chỉnh mã 0 khi có tên tùy chỉnh.
Ngoài ra, `vs_doanhnghiep_cauhinh` chưa có cột lưu cấu hình phương thức thanh toán mặc định.

## Giả định · Câu hỏi mở · Ngoài phạm vi

- **Giả định:** Bảng `vs_dm_ncc_phuongthucthanhtoan` đã có sẵn các phương thức thanh toán chuẩn (1: Tiền mặt, 2: Chuyển khoản, 3: Tiền mặt/Chuyển khoản, v.v.).
- **Câu hỏi mở:** Không.
- **Ngoài phạm vi:** Không sửa đổi cấu trúc mẫu hóa đơn, không đổi format XML/PDF, không cập nhật hóa đơn lịch sử.

## Cách làm

Chia thành các bước:
1. **Database:** Chuẩn bị script SQL thêm 2 cột nullable vào `vs_doanhnghiep_cauhinh` trong `deploy.md`.
2. **Backend Entity & DTO:** Thêm thuộc tính `Cauhinh_PhuongThucThanhToan` và `IsPhuongThucThanhToan` vào `DoanhNghiep_CauHinh` và `DoanhNghiep_CauHinhDto`.
3. **Backend AppService:**
   - Cung cấp API `GetListPhuongThucThanhToan` lấy danh mục phương thức hiệu lực.
   - Thêm validation và cập nhật dữ liệu kèm xóa cache trong `DoanhNghiep_CauHinhAppService.Update`.
   - Bổ sung `GetPhuongThucThanhToanMacDinh` và chuẩn hóa `InforHoaDonTongHop` trong `HoaDonAppService`.
4. **Frontend Service Proxies:** Cập nhật DTO và phương thức API trong `service-proxies.ts`.
5. **Frontend UI Cấu hình:** Thêm switch toggle và dropdown chọn phương thức trong `doanhnghiep-cauhinh-tab`.
6. **Frontend Khởi tạo Hóa đơn:** Cập nhật `hoadon.service.ts` và 5 component hóa đơn để áp dụng phương thức mặc định và bảo toàn phương thức tùy chỉnh/thay thế.

## Thay đổi kỹ thuật

| Hạng mục | Có/Không | Chi tiết |
|---|---|---|
| Entity / migration | Có | Thêm 2 field vào `DoanhNghiep_CauHinh.cs`; SQL script trong `deploy.md` (không dùng EF migration) |
| DTO / AppService | Có | Thêm field vào `DoanhNghiep_CauHinhDto.cs`; update `DoanhNghiep_CauHinhAppService` và `HoaDonAppService` |
| Màn hình / route | Có | Sửa `doanhnghiep-cauhinh-tab.component.{html,ts}`; chuẩn hóa `hoadon.service.ts` và 5 component hóa đơn |
| Hàng đợi / tích hợp | Không | Không thay đổi RabbitMQ, Kafka hay tích hợp bên thứ ba |
| Cấu hình (tên khóa) | Có | `cauhinh_phuongthucthanhtoan`, `isphuongthucthanhtoan` |

## Thứ tự thực hiện & phụ thuộc

1. Chuẩn bị SQL script trong `deploy.md`.
2. Cập nhật Backend (`invoicecore`): Entity -> DTO -> AppServices.
3. Cập nhật Frontend (`frontend_angular`): `service-proxies.ts` -> `doanhnghiep-cauhinh-tab` -> `hoadon.service.ts` -> Invoice components.
4. Build và verify backend & frontend.

## Kế hoạch kiểm chứng

| # | Lệnh / bước kiểm | Kết quả kỳ vọng |
|---|---|---|
| 1 | `cd invoicecore/aspnet-core && dotnet build src/hddt/HDDT.Application/HDDT.Application.csproj` | Build thành công 0 lỗi |
| 2 | `cd frontend_angular && npm run build` hoặc check TS compile | Compile thành công không lỗi syntax/type |
| 3 | Kiểm thử ma trận chức năng TC01 - TC15 theo `testcase.md` | Đạt tất cả tiêu chí chấp nhận AC1 - AC9 |

## Ma trận rủi ro

| Rủi ro | Ảnh hưởng | Giảm thiểu | Rollback |
|---|---|---|---|
| Chạy backend trước khi chạy SQL | Lỗi runtime `Unknown column` khi truy vấn cấu hình | DBA/TechLead chạy SQL trước khi deploy code | Chạy rollback SQL trong `deploy.md` |
| Quên xóa cache cấu hình doanh nghiệp | Hóa đơn mới tạo không nhận cấu hình vừa lưu | Gọi `_cacheHelper.ClearCache` theo đúng tenant và MST | Xóa cache thủ công trên Redis hoặc đợi TTL hết hạn |
| Ghi đè phương thức tùy chỉnh mã 0 | Mất tên phương thức thanh toán người dùng nhập tay | Ràng buộc điều kiện `string.IsNullOrWhiteSpace(ThanhToan_PhuongThuc_Ten)` | Revert commit xử lý fallback |

## Ghi chú triển khai

Chi tiết trong `deploy.md`. Cần chạy script SQL thêm 2 cột nullable cho bảng `vs_doanhnghiep_cauhinh` trên tenant database.

## Đề xuất cập nhật docs (Gate 2)

- Không cần sửa đổi kiến trúc tổng thể `architecture.md` vì đây là cấu hình nội bộ trong domain HDDT.

## Phê duyệt (Gate 1) — chỉ người điền, AI không tự điền

- [x] DEV tự review: AI Assistant — 2026-09-24
- [x] TechLead approve: luanlm — 2026-09-24
