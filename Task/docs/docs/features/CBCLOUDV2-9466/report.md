---
feature: CBCLOUDV2-9466
status: completed
owner: DEV
updated_at: 2026-09-16
---

# Report — CBCLOUDV2-9466: Tiếp nhận và xử lý thông điệp 112 trên BillCloud

## 1. Tóm tắt kết quả thực hiện

Đã hoàn thành việc bổ sung tiếp nhận và xử lý thông điệp 112 (Thông báo về việc NNT hủy tờ khai/thông báo/đề nghị) từ CQT vào dịch vụ `etran-teanant-service` (Cloud) theo đúng ma trận nghiệp vụ và tài liệu thiết kế:

1. **`etran-teanant-service` (Java Spring Boot Consumer):**
   - **Tạo mới `ThongDiep112Service.java`**:
     - Parse XML thông điệp 112, trích xuất `MTDTChieu`.
     - Tìm kiếm `VsServiceTax` tương ứng. Nếu chưa có, lưu vào bảng retry `vs_thongdiep_dangxuly`.
     - Lấy `VsDnRegisterTax` theo `referenceId` của `VsServiceTax`.
     - Cập nhật trạng thái:
       - `vsServiceTax.status = 4` (`VsServiceTaxStatus.TCT_TU_CHOI_TIEP_NHAN`).
       - `vsDnRegisterTax.status = 4` (`VsRegisterStatus.TCT_TU_CHOI_TIEP_NHAN`).
       - `vsDnRegisterTax.errorDescription = "Thông báo về việc NNT hủy tờ khai/thông báo/đề nghị."`.
       - `errorCode = null` (theo ma trận STT 3: không có mã lỗi).
     - Ghi bản ghi lịch sử vào `VsTransactionLog`:
       - `transType = 1` (Nhận thông điệp)
       - `transformCode = "112"`
       - `transName = "Thông báo về việc NNT hủy tờ khai/thông báo/đề nghị"`
       - `transactionCode = mtdtChieu`
       - `responseStatus = 4` (CQT không tiếp nhận)
       - `responseCode = null`
       - `responseDescription = "Thông báo về việc NNT hủy tờ khai/thông báo/đề nghị."`
     - Lưu các thực thể vào Tenant Database và gọi callback API TK01 nếu doanh nghiệp có cấu hình callback (`systemName.equals("cloud")`).
   - **Cập nhật `ProcessService.java`**:
     - Bổ sung `"112"` vào `maLoaiTDiepList`.
     - Inject `ThongDiep112Service` và thêm nhánh `case "112":` điều hướng tới `thongDiep112Service.handleThongDiep112(...)`.
   - **Bổ sung endpoint test trong `Test.java`**:
     - Inject `ThongDiep112Service` bằng `@Autowired` độc lập (tránh làm thay đổi constructor của Test).
     - Thêm endpoint `@GetMapping("/test-112")` để hỗ trợ gọi kiểm thử thủ công qua HTTP API.
   - **Tạo mới Unit Test `ThongDiep112ServiceTest.java`**:
     - Kiểm tra đầy đủ 2 kịch bản:
       - Xử lý thành công: cập nhật status = 4 cho cả `VsServiceTax` và `VsDnRegisterTax`, ghi log `VsTransactionLog` mã 112.
       - Khi chưa tìm thấy `VsServiceTax`: lưu retry vào `vs_thongdiep_dangxuly` và ném ngoại lệ `ErrorException`.

---

## 2. Danh sách file thay đổi

| Thao tác | File | Ghi chú |
| :---: | :--- | :--- |
| **NEW** | `etran-teanant-service/src/main/java/vn/sample/multitenancy/service/ThongDiep112Service.java` | Service tiếp nhận và xử lý thông điệp 112 |
| **MODIFY** | `etran-teanant-service/src/main/java/vn/sample/multitenancy/service/ProcessService.java` | Bổ sung routing mã 112 trong switch-case |
| **MODIFY** | `etran-teanant-service/src/main/java/vn/sample/multitenancy/controller/Test.java` | Bổ sung endpoint `/api/test-112` |
| **MODIFY** | `etran-teanant-service/src/main/java/vn/sample/multitenancy/controller/XMLController.java` | Bổ sung endpoint chuyên dụng `/api/thong-diep-112`, `/api/td112` nhận XML và trả về JSON chi tiết |
| **NEW** | `etran-teanant-service/src/test/java/vn/sample/multitenancy/service/ThongDiep112ServiceTest.java` | Unit test cho ThongDiep112Service |
| **NEW** | `CBCLOUDV2-9466_ThongDiep112.postman_collection.json` | Bộ Postman Collection kiểm thử 6 kịch bản thông điệp 112 |
| **NEW** | `Etran_Local.postman_environment.json` | Bộ biến môi trường Postman (base_url, mst, mtdtChieu) |

---

## 3. Kết quả xác nhận kiểm thử (Verification Output)

Chạy kiểm thử tự động với Maven Wrapper trên JDK 8:
```powershell
$env:JAVA_HOME="C:\Program Files\Java\jdk1.8.0_202"; $env:Path="C:\Program Files\Java\jdk1.8.0_202\bin;" + $env:Path; .\mvnw.cmd test -Dtest=ThongDiep112ServiceTest
```

Kết quả:
```text
[INFO] -------------------------------------------------------
[INFO]  T E S T S
[INFO] -------------------------------------------------------
[INFO] Running vn.sample.multitenancy.service.ThongDiep112ServiceTest
16:18:21.932 [main] INFO vn.sample.multitenancy.service.ThongDiep112Service - ===== handleThongDiep112: mtdtChieu: V0105232093-9983CF323577BC5479E9FC14C3711E37F6D
16:18:21.939 [main] INFO vn.sample.multitenancy.service.ThongDiep112Service - ================= Connection Info: null ========================
16:18:21.962 [main] INFO vn.sample.multitenancy.service.ThongDiep112Service - ============== vsServiceTax STATUS: TCT từ chối tiếp nhận, id=100  ===========
16:18:21.964 [main] INFO vn.sample.multitenancy.service.ThongDiep112Service - ============== vsDnRegisterTax STATUS: TCT từ chối tiếp nhận, id=200  ===========
16:18:21.964 [main] INFO vn.sample.multitenancy.service.ThongDiep112Service - ============== handleThongDiep112 MTDTChieu = V0105232093-9983CF323577BC5479E9FC14C3711E37F6D SUCCESS ==============
16:18:22.008 [main] INFO vn.sample.multitenancy.service.ThongDiep112Service - ===== handleThongDiep112: mtdtChieu: UNKNOWN_MTDT
16:18:22.009 [main] INFO vn.sample.multitenancy.service.ThongDiep112Service - ================= Connection Info: null ========================
16:18:22.012 [main] INFO vn.sample.multitenancy.service.ThongDiep112Service - ============== save to vs_thongdiep_dangxuly SUCCESS, mtdtChieu = UNKNOWN_MTDT ==============
[INFO] Tests run: 2, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 1.949 s - in vn.sample.multitenancy.service.ThongDiep112ServiceTest
[INFO] 
[INFO] Results:
[INFO] 
[INFO] Tests run: 2, Failures: 0, Errors: 0, Skipped: 0
[INFO] 
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
```

- Các giá trị chuẩn hóa theo tài liệu thiết kế:
  - **Trạng thái tờ khai**: `status = 4` (`CQT không tiếp nhận`)
  - **Thông điệp tiếp nhận**: `112`
  - **Mã lỗi**: `null` (Không có mã lỗi)
  - **Mô tả phản hồi**: `"Thông báo về việc NNT hủy tờ khai/thông báo/đề nghị."`
