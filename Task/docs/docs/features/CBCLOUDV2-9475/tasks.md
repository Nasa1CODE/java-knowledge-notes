# Tasks — CBCLOUDV2-9475: Cấu hình phương thức thanh toán mặc định khi lập hóa đơn

> Sinh theo [rules/01-create-plan.md](../../rules/01-create-plan.md). Cập nhật status và link commit/PR trong lúc làm.
> **Service** là `service-key` đúng theo Service registry ([../../AGENTS.md](../../AGENTS.md)).

## Tổng quan

| # | Task | Service | Status | Ước lượng | Commit/PR |
|---|---|---|---|---|---|
| 1 | Thêm trường Entity và DTO Backend | invoicecore | completed | S | |
| 2 | Bổ sung API danh mục phương thức thanh toán và xử lý lưu/validate cấu hình | invoicecore | completed | S | |
| 3 | Cập nhật logic khởi tạo hóa đơn và bảo toàn phương thức thay thế/tùy chỉnh | invoicecore | completed | S | |
| 4 | Cập nhật NSwag service proxies Frontend | frontend_angular | completed | S | |
| 5 | Thêm switch và dropdown cấu hình trên giao diện Cấu hình Doanh nghiệp | frontend_angular | completed | S | |
| 6 | Tập trung quy tắc xác định phương thức mặc định trong HoaDonService | frontend_angular | completed | S | |
| 7 | Loại bỏ fallback cục bộ tại các màn hình lập hóa đơn | frontend_angular | completed | M | |
| 8 | Tạo script SQL triển khai và rollback | docs | completed | XS | |
| 9 | Kiểm thử và xác nhận biên dịch hệ thống | invoicecore, frontend_angular | completed | S | |

---

## Task 1 — Thêm trường Entity và DTO Backend

- **Status:** completed
- **Service:** `invoicecore`
- **Mô tả:** Thêm `Cauhinh_PhuongThucThanhToan` và `IsPhuongThucThanhToan` vào entity `DoanhNghiep_CauHinh` và DTO `DoanhNghiep_CauHinhDto`.
- **Tiêu chí chấp nhận:**
  - [x] Entity `DoanhNghiep_CauHinh` có 2 property nullable ánh xạ tới DB.
  - [x] DTO `DoanhNghiep_CauHinhDto` có 2 property tương ứng phục vụ API.
- **Kiểm chứng:**
  - [x] `dotnet build src/hddt/HDDT.Application/HDDT.Application.csproj` → biên dịch thành công (0 error).
- **Phụ thuộc:** Không
- **File dự kiến chạm:**
  - `invoicecore/aspnet-core/src/hddt/HDDT.Core/Domains/CauHinh/DoanhNghiep_CauHinh.cs`
  - `invoicecore/aspnet-core/src/hddt/HDDT.Application/DataTransferObjects/CauHinh/ThongTinDoanhNghiep/DoanhNghiep_CauHinhDto.cs`
- **Ước lượng:** S
- **Commit/PR:**

---

## Task 2 — Bổ sung API danh mục phương thức thanh toán và xử lý lưu/validate cấu hình

- **Status:** completed
- **Service:** `invoicecore`
- **Mô tả:** Inject repository `vs_dm_ncc_phuongthucthanhtoan`, thêm API `GetListPhuongThucThanhToan`, kiểm tra tính hợp lệ khi lưu cấu hình và xóa cache theo tenant/MST.
- **Tiêu chí chấp nhận:**
  - [x] Có API `GetListPhuongThucThanhToan()` trả về danh sách phương thức đang hiệu lực (`PhuongThuc_HieuLuc == true`).
  - [x] `Update()` từ chối lưu nếu bật nhưng không chọn phương thức hoặc phương thức không tồn tại/ngừng hiệu lực.
  - [x] `Update()` reset mã về `null` nếu tắt cấu hình.
  - [x] Xóa cache cấu hình doanh nghiệp sau khi lưu thành công.
- **Kiểm chứng:**
  - [x] `dotnet build src/hddt/HDDT.Application/HDDT.Application.csproj` → biên dịch thành công (0 error).
- **Phụ thuộc:** Task 1
- **File dự kiến chạm:**
  - `invoicecore/aspnet-core/src/hddt/HDDT.Application/AppServices/CauHinh/DoanhNghiep_CauHinhAppService.cs`
- **Ước lượng:** S
- **Commit/PR:**

---

## Task 3 — Cập nhật logic khởi tạo hóa đơn và bảo toàn phương thức thay thế/tùy chỉnh

- **Status:** completed
- **Service:** `invoicecore`
- **Mô tả:** Thêm `GetPhuongThucThanhToanMacDinh()` trong `HoaDonAppService`, áp dụng vào `InforHoaDonTongHop`, bảo toàn tên tùy chỉnh cho hóa đơn thay thế và không ghi đè phương thức tùy chỉnh mã 0.
- **Tiêu chí chấp nhận:**
  - [x] Hóa đơn mới tạo lấy theo cấu hình mặc định (hoặc fallback mã 1).
  - [x] Hóa đơn thay thế sao chép cả mã và tên phương thức từ hóa đơn gốc.
  - [x] Phương thức thanh toán tùy chỉnh mã 0 không bị ghi đè thành 1.
- **Kiểm chứng:**
  - [x] `dotnet build src/hddt/HDDT.Application/HDDT.Application.csproj` → biên dịch thành công (0 error).
- **Phụ thuộc:** Task 2
- **File dự kiến chạm:**
  - `invoicecore/aspnet-core/src/hddt/HDDT.Application/AppServices/HoaDon/HoaDonAppService.cs`
- **Ước lượng:** S
- **Commit/PR:**

---

## Task 4 — Cập nhật NSwag service proxies Frontend

- **Status:** completed
- **Service:** `frontend_angular`
- **Mô tả:** Thêm thuộc tính vào `DoanhNghiep_CauHinhDto` và method `getListPhuongThucThanhToan()` vào `DoanhNghiep_CauHinhServiceProxy`.
- **Tiêu chí chấp nhận:**
  - [x] `service-proxies.ts` định nghĩa đúng contract DTO và API method.
- **Kiểm chứng:**
  - [x] Không có lỗi type error liên quan đến `DoanhNghiep_CauHinhServiceProxy` (`npx tsc -p src/tsconfig.json --noEmit` exit 0).
- **Phụ thuộc:** Task 2
- **File dự kiến chạm:**
  - `frontend_angular/src/shared/service-proxies/service-proxies.ts`
- **Ước lượng:** S
- **Commit/PR:**

---

## Task 5 — Thêm switch và dropdown cấu hình trên giao diện Cấu hình Doanh nghiệp

- **Status:** completed
- **Service:** `frontend_angular`
- **Mô tả:** Thêm UI cấu hình phương thức thanh toán mặc định vào tab Cấu hình hiển thị của `doanhnghiep-cauhinh-tab`.
- **Tiêu chí chấp nhận:**
  - [x] Switch toggle bật/tắt đúng trạng thái `isPhuongThucThanhToan`.
  - [x] Dropdown hiển thị danh sách phương thức thanh toán lấy từ API khi switch bật.
  - [x] Hiển thị thông báo cảnh báo nếu bật nhưng chưa chọn phương thức khi lưu.
- **Kiểm chứng:**
  - [x] Chạy kiểm tra compile template và code frontend (`npx tsc -p src/tsconfig.json --noEmit` exit 0).
- **Phụ thuộc:** Task 4
- **File dự kiến chạm:**
  - `frontend_angular/src/app/hddt/cauhinh/thongtindoanhnghiep/doanhnghiep-cauhinh-tab.component.html`
  - `frontend_angular/src/app/hddt/cauhinh/thongtindoanhnghiep/doanhnghiep-cauhinh-tab.component.ts`
- **Ước lượng:** S
- **Commit/PR:**

---

## Task 6 — Tập trung quy tắc xác định phương thức mặc định trong HoaDonService

- **Status:** completed
- **Service:** `frontend_angular`
- **Mô tả:** Cập nhật `HoaDonService` để lấy danh mục PTTT trong `loadDataInit`, thêm `getPhuongThucThanhToanMacDinh()`, áp dụng cho hóa đơn mới, hóa đơn điều chỉnh và bảo toàn cho hóa đơn thay thế.
- **Tiêu chí chấp nhận:**
  - [x] Hóa đơn mới/POS/bảng kê được gán phương thức mặc định.
  - [x] Hóa đơn thay thế sao chép đủ mã và tên từ hóa đơn gốc.
  - [x] Hóa đơn điều chỉnh lấy theo cấu hình mặc định (không sao chép từ hóa đơn gốc).
- **Kiểm chứng:**
  - [x] Frontend compile không lỗi (`npx tsc -p src/tsconfig.json --noEmit` exit 0).
- **Phụ thuộc:** Task 4
- **File dự kiến chạm:**
  - `frontend_angular/src/app/hddt/hoadon/quanlyhoadon/hoadon.service.ts`
- **Ước lượng:** S
- **Commit/PR:**

---

## Task 7 — Loại bỏ fallback cục bộ tại các màn hình lập hóa đơn

- **Status:** completed
- **Service:** `frontend_angular`
- **Mô tả:** Khởi tạo `pttt_Obj = null` và phân biệt giữa chọn từ danh mục với nhập tên tùy chỉnh (mã 0) trên 5 màn hình lập hóa đơn.
- **Tiêu chí chấp nhận:**
  - [x] Không gán cứng Tiền mặt trong constructor.
  - [x] Tôn trọng giá trị phương thức từ `HoaDonService`.
  - [x] Nhập tên tùy chỉnh gán đúng mã 0 và tên tùy chỉnh, không bị đổi thành 1.
- **Kiểm chứng:**
  - [x] Frontend compile không lỗi (`npx tsc -p src/tsconfig.json --noEmit` exit 0).
- **Phụ thuộc:** Task 6
- **File dự kiến chạm:**
  - `frontend_angular/src/app/hddt/hoadon/quanlyhoadon/hoadon-goc.component.ts`
  - `frontend_angular/src/app/hddt/hoadon/hoadonbanhang/hoadonbanhang.component.ts`
  - `frontend_angular/src/app/hddt/hoadon/hoadondiennuoc/hoadondiennuoc.component.ts`
  - `frontend_angular/src/app/hddt/hoadon/hoa-don-ban-tai-san-cong/hoa-don-ban-tai-san-cong.component.ts`
  - `frontend_angular/src/app/hddt/hoadon/vemaybay/vemaybay.component.ts`
- **Ước lượng:** M
- **Commit/PR:**

---

## Task 8 — Tạo script SQL triển khai và rollback

- **Status:** completed
- **Service:** `docs`
- **Mô tả:** Soạn thảo hướng dẫn deploy và script SQL thêm/xóa cột trong `deploy.md`.
- **Tiêu chí chấp nhận:**
  - [x] Có câu lệnh ALTER TABLE thêm 2 cột nullable.
  - [x] Có câu lệnh ALTER TABLE rollback tương ứng.
- **Kiểm chứng:**
  - [x] Cú pháp SQL MySQL/MariaDB chính xác.
- **Phụ thuộc:** Không
- **File dự kiến chạm:**
  - `docs/features/CBCLOUDV2-9475/deploy.md`
- **Ước lượng:** XS
- **Commit/PR:**

---

## Task 9 — Kiểm thử và xác nhận biên dịch hệ thống

- **Status:** completed
- **Service:** `invoicecore`, `frontend_angular`
- **Mô tả:** Biên dịch toàn bộ các service thay đổi và rà soát ma trận kiểm thử TC01 - TC15.
- **Tiêu chí chấp nhận:**
  - [x] `HDDT.Application.csproj` build 0 error.
  - [x] `frontend_angular` build/typecheck 0 error.
  - [x] Báo cáo nghiệm thu đầy đủ trong `report.md`.
- **Kiểm chứng:**
  - [x] Lệnh build dotnet và npx tsc hoàn tất thành công 0 lỗi.
- **Phụ thuộc:** Task 1 - Task 8
- **File dự kiến chạm:**
  - `docs/features/CBCLOUDV2-9475/report.md`
- **Ước lượng:** S
- **Commit/PR:**
