---
feature: CBCLOUDV2-9577
updated_at: 2026-09-14
---

# Expect - CBCLOUDV2-9577

## Mục tiêu

`api-cloud-service` tự xác định rule NĐ254 từ dữ liệu khách hàng gửi:

- Có ít nhất một dòng `loaihoadondactrung = 1` và một field mới phù hợp: xử lý theo rule NĐ254 hiện có.
- Không có dòng loại `1`, hoặc có loại `1` nhưng không có field mới phù hợp: xử lý theo rule cũ.
- Không phụ thuộc `ACTIVE_ND_254` hoặc request `version`.

## Acceptance Criteria đề xuất

- **AC1:** Detector dùng chung định nghĩa chính xác danh sách field mới; field cũ như `sokhung`, `somay`, `loaihoadondactrung`, `dnmua_ten`, `dnmua_mst`, `dnmua_cccd` không tự kích hoạt rule mới.
- **AC2:** String null/rỗng/whitespace không được tính là có dữ liệu; số nullable có `HasValue`, kể cả `0`, được tính là có dữ liệu.
- **AC3:** Dữ liệu số mới sai kiểu trên dòng loại `1` vẫn phải kích hoạt rule mới và trả lỗi validation, không bị coi như không gửi.
- **AC4:** `UseND254 = true` khi đồng thời có dòng `loaihoadondactrung = 1` và có một trong 6 field mới cấp hóa đơn hoặc một trong 15 field mới trên chính dòng loại `1`.
- **AC5:** Validation/map 15 field chi tiết chỉ áp dụng cho dòng `loaihoadondactrung = 1`, đồng thời giữ các điều kiện theo `xuatxu` và `tinhtrangtaisan`.
- **AC6:** Giữ nguyên rule required/maxlength/domain hiện tại của API, chỉ thay điều kiện bật rule.
- **AC7:** Khi không đủ cả hai điều kiện loại `1` và field mới phù hợp, validate/map/XML giữ hành vi cũ; không sinh node NĐ254 rỗng.
- **AC8:** XML sinh lại dùng cùng công thức trên dữ liệu DB; chỉ xét 15 field chi tiết thuộc dòng loại `1`. `PBan = 2.1.1` khi dòng loại `1` có dữ liệu xe NĐ254; nếu không thì giữ `2.1.0`.
- **AC9:** XML đã ký trên FTP không bị sửa.
- **AC10:** Áp dụng đồng nhất cho gốc/thay thế/điều chỉnh và toàn bộ wrapper dùng lại các luồng này.
- **AC11:** Giữ hành vi cộng dồn validation hiện tại: toàn bộ lỗi được trả một lần trong `motaketqua`, không dừng ở lỗi đầu tiên.
- **AC12:** Phase này không thay đổi `invoicecore` hoặc Excel import.
