---
feature: CBCLOUDV2-9577
title: "[DEV] Nâng cấp check hóa đơn API và Excel import theo dữ liệu khách hàng đẩy lên"
status: implemented
created_at: 2026-09-14
updated_at: 2026-09-14
---

# Tasks - CBCLOUDV2-9577

## Tổng quan

| # | Công việc | Repository | Trạng thái | Ghi chú |
|---|---|---|---|---|
| 1 | Rà soát toàn bộ điểm dùng `ACTIVE_ND_254` | api-cloud-service | completed | 42 dòng consumer, 5 lần đọc checker |
| 2 | Chốt danh sách field dùng để nhận diện dữ liệu NĐ254 | docs | completed | 6 field cấp hóa đơn và 15 field chi tiết |
| 3 | Thiết kế detector theo dữ liệu request/API | api-cloud-service | completed | Detector thuần dữ liệu, không đọc Redis/DB |
| 4 | Thay gate validate/map/lưu API | api-cloud-service | completed | Áp dụng chung cho hóa đơn gốc, thay thế và điều chỉnh |
| 5 | Thay gate sinh XML/PDF/HTML | api-cloud-service | completed | Chốt `UseND254` từ entity ở đầu mỗi luồng tạo XML |
| 6 | Bổ sung unit test và regression test | api-cloud-service | completed | 41/41 test pass; 3 project build pass |

## Kết luận hiện trạng

- Cấu hình `ACTIVE_ND_254` đang quyết định validate, map/lưu và sinh XML trong API.
- Task mới chuyển điều kiện API sang dữ liệu khách hàng thực sự gửi. Không dùng request `version` và không dùng Redis/DB làm gate.
- Chỉ bật NĐ254 khi có dòng `loaihoadondactrung = 1` và có ít nhất một field mới phù hợp; 15 field chi tiết chỉ được dò/validate/map trên dòng loại `1`.
- `invoicecore`/Excel import được ghi nhận nhưng nằm ngoài scope phase này.
- Source `api-cloud-service` đã được cập nhật; `invoicecore`/Excel import chưa thay đổi trong phase này.
