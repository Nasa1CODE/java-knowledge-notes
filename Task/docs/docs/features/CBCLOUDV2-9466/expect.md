---
feature: CBCLOUDV2-9466
title: Tiếp nhận và xử lý thông điệp 112 (Thông báo về việc NNT hủy tờ khai/thông báo/đề nghị) trên BillCloud
status: in-progress
service: etran-teanant-service
services-affected: [etran-teanant-service]
owner: TBD — owner: DEV / TechLead
created_at: 2026-09-16
updated_at: 2026-09-16
---

# Expectation — CBCLOUDV2-9466: Tiếp nhận và xử lý thông điệp 112 từ CQT trên BillCloud

## 1. Hiện trạng

- `etran-teanant-service` trên hệ thống BillCloud là Java Spring Boot consumer nhận các thông điệp phản hồi từ CQT qua Kafka và cập nhật vào Tenant DB.
- Trong `ProcessService.java`, danh sách các mã loại thông điệp hỗ trợ hiện tại chỉ gồm:
  `["102", "103", "104", "202", "204", "301", "302", "999", "110", "111", "213"]`.
- **Hệ thống hiện tại CHƯA CÓ xử lý thông điệp 112**:
  - Không có class `ThongDiep112Service`.
  - Chưa bổ sung mã `"112"` vào `maLoaiTDiepList` của `ProcessService`.
  - Khi CQT gửi thông điệp `112` (Thông báo về việc NNT hủy tờ khai/thông báo/đề nghị), consumer bỏ qua, không ghi nhận vào `vs_transaction_log`, không cập nhật trạng thái tờ khai đăng ký (`vs_service_tax`, `vs_dn_register_tax`).
- Phía giao diện và API Cloud (`cyberbillcloudv2` / `invoicecore`):
  - Backend đã hỗ trợ lấy log giao dịch chứa mã thông điệp `112` và FE đã có cấu hình hiển thị tương ứng.

## 2. Kỳ vọng (Expected Behavior)

Theo ma trận thông báo phản hồi tờ khai:

| STT | Trạng thái | Mã thông điệp trả về | Mã lỗi | Cột thông báo hiển thị | Điều kiện hiển thị |
| :---: | :--- | :---: | :---: | :--- | :--- |
| 1 | CQT đã tiếp nhận | 102 | Không có | Quý khách vui lòng thực hiện sinh trắc học/OTP qua ứng dụng eTax Mobile trước HH:mm ngày dd/MM/yyyy<br>Hướng dẫn xác thực xem tại: Link | `doanhNghiep_NgayKy` có mặt (không null).<br>`doanhNghiep_NgayKy` lớn hơn ngày cutover cấu hình (`NGAY_APDUNG_SINH_TRAC_HOC`). |
| 2 | CQT không tiếp nhận | 102 | Có mã lỗi | Hiển thị trống | *(Không)* |
| **3** | **CQT không tiếp nhận** | **112** | **Không có** | **Thông báo về việc NNT hủy tờ khai/thông báo/đề nghị.** | *(Không - hiển thị khi nhận thông điệp 112)* |
| 4 | CQT Chấp nhận | 103 | Không có | Hiển thị trống | *(Không)* |
| 5 | CQT Không chấp nhận | 103 | 20013 | Quá hạn thực hiện sinh trắc học/OTP. | *(Không)* |
| 6 | CQT không chấp nhận | 103 | Khác 20013 | Hiển thị trống | *(Không)* |

### Chi tiết phía consumer (`etran-teanant-service`):
- Bổ sung mã `"112"` vào `maLoaiTDiepList` trong `ProcessService.java` và định tuyến thông điệp 112 vào `ThongDiep112Service`.
- Tạo mới `ThongDiep112Service.java`:
  - Tiếp nhận XML thông điệp 112 từ CQT.
  - Lấy `MTDTChieu` và tìm bản ghi `VsServiceTax` tương ứng (`isDeleted = false`).
  - Nếu chưa tìm thấy `VsServiceTax`, lưu vào bảng retry `vs_thongdiep_dangxuly`.
  - Lấy `VsDnRegisterTax` theo `referenceId` của `VsServiceTax`.
  - Cập nhật trạng thái:
    - `VsServiceTax.status = 4` (`VsServiceTaxStatus.TCT_TU_CHOI_TIEP_NHAN`).
    - `VsDnRegisterTax.status = 4` (`VsRegisterStatus.TCT_TU_CHOI_TIEP_NHAN`).
    - Cập nhật mô tả trạng thái phản hồi: mã lỗi để trống (null), mô tả: *"Thông báo về việc NNT hủy tờ khai/thông báo/đề nghị."*.
  - Ghi bản ghi lịch sử vào `VsTransactionLog`:
    - `transType = 1` (Nhận)
    - `transformCode = "112"`
    - `transName`: Tên thông báo từ XML hoặc *"Thông báo về việc NNT hủy tờ khai/thông báo/đề nghị"*
    - `transactionCode = mtdtChieu`
    - `responseStatus = 4`
    - `responseCode = null` (Mã lỗi: Không có)
    - `responseDescription = "Thông báo về việc NNT hủy tờ khai/thông báo/đề nghị."`
    - Gán các trường metadata: `tenantId`, `doanhNghiepMst`, `creationTime`, `serviceTaxId`, `creatorUserId`.
  - Lưu các entity vào Tenant DB.
  - Hỗ trợ gửi callback API (`CallBackApiTK01`) nếu tenant cấu hình callback API.

## 3. Tiêu chí nghiệm thu (Acceptance Criteria)

- **AC-1**: Khi `etran-teanant-service` nhận được XML thông điệp 112 có `MTDTChieu`:
  - Bản ghi `vs_service_tax` tương ứng được cập nhật `status = 4` (`TCT_TU_CHOI_TIEP_NHAN`).
  - Bản ghi `vs_dn_register_tax` tương ứng được cập nhật `status = 4` (`TCT_TU_CHOI_TIEP_NHAN`).
  - Tạo 1 bản ghi mới trong `vs_transaction_log` với `transform_code = '112'`, `trans_type = 1`, `response_status = 4`, `response_code = null`.
- **AC-2**: Nếu chưa tìm thấy `VsServiceTax`, lưu thông điệp vào bảng `vs_thongdiep_dangxuly` để retry sau.
- **AC-3**: Gọi callback API TK01 nếu doanh nghiệp cấu hình sử dụng callback API.
- **AC-4**: Không làm ảnh hưởng đến các luồng xử lý thông điệp hiện tại (102, 103, 104, 301, 302, 110, 111...).

## 4. Phạm vi loại trừ (Out Of Scope)

- Không thay đổi schema database hay tạo migration mới.
- Không thay đổi luồng ký gửi tờ khai ban đầu.
