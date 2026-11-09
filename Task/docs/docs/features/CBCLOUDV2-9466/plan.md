---
feature: CBCLOUDV2-9466
title: Kế hoạch triển khai tiếp nhận và xử lý thông điệp 112 từ CQT trên BillCloud
status: in-progress
service: etran-teanant-service
services-affected: [etran-teanant-service]
owner: TBD — owner: DEV / TechLead
created_at: 2026-09-16
updated_at: 2026-09-16
---

# Plan — CBCLOUDV2-9466: Kế hoạch triển khai xử lý thông điệp 112 trên BillCloud

## 1. Mục tiêu

Bổ sung khả năng tiếp nhận và xử lý thông điệp `112` (Thông báo về việc NNT hủy tờ khai/thông báo/đề nghị) từ CQT gửi qua Kafka trong dịch vụ `etran-teanant-service` của hệ thống BillCloud, cập nhật trạng thái tờ khai đăng ký sang `CQT không tiếp nhận` (`status = 4`) và ghi nhận lịch sử giao dịch vào `vs_transaction_log`.

## 2. Bối cảnh & Phân tích kỹ thuật

- `etran-teanant-service` lắng nghe topic Kafka nhận thông điệp từ CQT (`cyberbill-out-stg` hoặc tương đương).
- Khi có thông điệp đến, `ProcessService.processStringXml()` đọc thẻ `<TTChung><MLTDiep>` để định tuyến.
- Hiện tại danh sách `maLoaiTDiepList` chỉ gồm: `102, 103, 104, 202, 204, 301, 302, 999, 110, 111, 213`.
- Khi CQT trả về thông điệp `112`:
  - Ý nghĩa: CQT thông báo về việc NNT hủy tờ khai/thông báo/đề nghị.
  - Cần cập nhật `VsServiceTax.status = 4` và `VsDnRegisterTax.status = 4`.
  - Cần ghi nhận `VsTransactionLog` với `TransformCode = "112"`, `ResponseStatus = 4`, `ResponseCode = null`.
  - Cần hỗ trợ callback API TK01 cho các doanh nghiệp cấu hình sử dụng callback.

## 3. Chi tiết các file thay đổi (Affected Files)

### Dịch vụ `etran-teanant-service`

1. **`src/main/java/vn/sample/multitenancy/service/ProcessService.java`**:
   - Thêm `"112"` vào `maLoaiTDiepList`.
   - Inject bean `ThongDiep112Service`.
   - Bổ sung `case "112"` gọi `thongDiep112Service.handleThongDiep112(...)`.

2. **[Tạo mới] `src/main/java/vn/sample/multitenancy/service/ThongDiep112Service.java`**:
   - Nhận XML thông điệp 112, parse lấy `MTDTChieu`.
   - Tìm kiếm `VsServiceTax` tương ứng trong Tenant DB.
     - Nếu chưa có: gọi `vsThongDiepDangXuLyService.save(...)` để lưu retry sau.
   - Tìm `VsDnRegisterTax` theo `referenceId` của `VsServiceTax`.
   - Cập nhật:
     - `vsServiceTax.setStatus(VsServiceTaxStatus.TCT_TU_CHOI_TIEP_NHAN.getValue());` *(status = 4)*
     - `vsDnRegisterTax.setStatus(VsRegisterStatus.TCT_TU_CHOI_TIEP_NHAN.getValue());` *(status = 4)*
     - `vsDnRegisterTax.setErrorDescription("Thông báo về việc NNT hủy tờ khai/thông báo/đề nghị.");`
   - Tạo và lưu `VsTransactionLog`:
     - `TransType = 1` (Nhận)
     - `TransformCode = "112"`
     - `TransName`: Lấy từ thẻ `<Ten>` trong XML hoặc gán `"Thông báo về việc NNT hủy tờ khai/thông báo/đề nghị"`
     - `TransactionCode = mtdtChieu`
     - `ResponseStatus = 4`
     - `ResponseCode = null`
     - `ResponseDescription = "Thông báo về việc NNT hủy tờ khai/thông báo/đề nghị."`
     - Các thông tin tenant, MST, thời gian, user tạo.
   - Lưu vào DB và thực hiện callback API TK01 nếu doanh nghiệp có cấu hình.

3. **`src/main/java/vn/sample/multitenancy/controller/Test.java`**:
   - Thêm `@GetMapping("/test-112")` hỗ trợ test thủ công.

4. **[Tạo mới] `src/test/java/vn/sample/multitenancy/service/ThongDiep112ServiceTest.java`**:
   - Unit test cho `ThongDiep112Service`.

## 4. Kế hoạch kiểm thử (Verification Plan)

- Chạy kiểm thử tự động bằng Maven Wrapper với JDK 8:
  ```powershell
  $env:JAVA_HOME="C:\Program Files\Java\jdk1.8.0_202"; .\mvnw.cmd test -Dtest=ThongDiep112ServiceTest
  ```
- Kiểm tra các assertions:
  + `vsServiceTax.status == 4`
  + `vsDnRegisterTax.status == 4`
  + `vsTransactionLog.transformCode == "112"`
  + `vsTransactionLog.responseStatus == 4`
  + `vsTransactionLog.responseCode == null`
  + Khi chưa có `VsServiceTax` thì lưu vào `vs_thongdiep_dangxuly`.
