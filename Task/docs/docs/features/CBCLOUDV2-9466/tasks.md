---
feature: CBCLOUDV2-9466
status: completed
owner: DEV
updated_at: 2026-09-16
---

# Tasks — CBCLOUDV2-9466: Tiếp nhận và xử lý thông điệp 112 trên BillCloud

## Danh sách công việc tổng quan

| Mã Task | Trạng thái | Dịch vụ | Nội dung công việc | Độ phức tạp | Phụ thuộc |
| :---: | :---: | :--- | :--- | :---: | :---: |
| **T1** | done | `etran-teanant-service` | Tạo mới service `ThongDiep112Service.java` xử lý thông điệp 112 từ CQT | M | — |
| **T2** | done | `etran-teanant-service` | Cập nhật `ProcessService.java` và `Test.java` định tuyến thông điệp 112 | S | T1 |
| **T3** | done | `etran-teanant-service` | Viết Unit Test `ThongDiep112ServiceTest.java` giả lập xử lý XML thông điệp 112 | M | T1, T2 |
| **T4** | done | `etran-teanant-service` | Chạy biên dịch và kiểm thử tự động với Maven Wrapper | S | T3 |

---

## Chi tiết từng Task

### Task T1 — Tạo service ThongDiep112Service trong etran-teanant-service
- **Trạng thái:** done
- **Dịch vụ:** `etran-teanant-service`
- **Mô tả:** Viết mới service `ThongDiep112Service.java` nhận XML thông điệp 112, trích xuất `MTDTChieu`, cập nhật `VsServiceTax` (status = 4), cập nhật `VsDnRegisterTax` (status = 4), ghi bản ghi vào `VsTransactionLog` và xử lý callback API nếu có cấu hình.
- **Tiêu chí nghiệm thu:**
  - [x] Tìm được `VsServiceTax` qua `mtdtChieu` và `isDeleted = false`.
  - [x] Nếu không tìm thấy, lưu thông điệp vào bảng `vs_thongdiep_dangxuly`.
  - [x] Cập nhật `status = 4` cho `VsServiceTax` và `VsDnRegisterTax`.
  - [x] Lưu bản ghi vào `VsTransactionLog` với `transformCode = "112"`, `responseStatus = 4`, `responseCode = null`.
  - [x] Xử lý gọi callback API TK01 nếu doanh nghiệp cấu hình sử dụng callback.
- **File tác động:**
  - `etran-teanant-service/src/main/java/vn/sample/multitenancy/service/ThongDiep112Service.java`

### Task T2 — Cập nhật định tuyến thông điệp trong ProcessService
- **Trạng thái:** done
- **Dịch vụ:** `etran-teanant-service`
- **Mô tả:** Bổ sung mã `"112"` vào `maLoaiTDiepList` và thêm nhánh `case "112"` gọi `thongDiep112Service.handleThongDiep112(...)`.
- **Tiêu chí nghiệm thu:**
  - [x] Danh sách `maLoaiTDiepList` chứa mã `"112"`.
  - [x] Khi XML có `MLTDiep = "112"` thì điều hướng chính xác vào `ThongDiep112Service`.
  - [x] Thêm endpoint test `/api/test-112` trong `Test.java`.
- **File tác động:**
  - `etran-teanant-service/src/main/java/vn/sample/multitenancy/service/ProcessService.java`
  - `etran-teanant-service/src/main/java/vn/sample/multitenancy/controller/Test.java`

### Task T3 — Viết Unit Test cho ThongDiep112Service
- **Trạng thái:** done
- **Dịch vụ:** `etran-teanant-service`
- **Mô tả:** Viết unit test giả lập xử lý chuỗi XML thông điệp 112 để kiểm tra logic cập nhật entity và lưu log.
- **Tiêu chí nghiệm thu:**
  - [x] Test case cập nhật trạng thái `4`, lưu `VsTransactionLog` mã `112`.
  - [x] Test case khi chưa có `VsServiceTax` thì lưu retry vào `vs_thongdiep_dangxuly`.
- **File tác động:**
  - `etran-teanant-service/src/test/java/vn/sample/multitenancy/service/ThongDiep112ServiceTest.java`

### Task T4 — Chạy biên dịch và kiểm thử tự động
- **Trạng thái:** done
- **Dịch vụ:** `etran-teanant-service`
- **Mô tả:** Biên dịch toàn bộ source code và chạy unit test với Maven Wrapper trên JDK 8.
- **Tiêu chí nghiệm thu:**
  - [x] `BUILD SUCCESS` không có lỗi.
