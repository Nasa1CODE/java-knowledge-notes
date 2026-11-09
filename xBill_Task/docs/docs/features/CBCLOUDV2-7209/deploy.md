# CBCLOUDV2-7209 - Ghi chú triển khai

## Trạng thái

- Tác động triển khai: deploy `api-cloud-service/` và kiểm tra cấu hình/phụ thuộc vận hành.
- Database migration: không có thay đổi quan sát được.
- Worker/consumer: không có thay đổi quan sát được.
- Rủi ro: trung bình-cao do phụ thuộc dịch vụ kiểm tra chữ ký, file storage, Kafka và xử lý TCT phía sau.

## Phụ thuộc runtime

- API host phải truy cập được dịch vụ kiểm tra chữ ký XML đã cấu hình.
- File storage hiện hữu phải cho phép ghi XML hóa đơn đã ký và XML thông điệp TCT.
- Kafka producer phải có cấu hình và quyền phát tới topic TCT.
- Tenant/hóa đơn/cấu hình TCT phải hỗ trợ luồng TT78 gửi từng lần cần triển khai.

## Cấu hình

- File cấu hình thay đổi: `api-cloud-service/src/zero/VS.Web.Host/appsettings.json`.
- Khóa cấu hình thêm mới: `validateservice.xml`, xác định dịch vụ kiểm tra chữ ký XML được `HoaDonHelper.CheckSignInXML` gọi khi nhận XML MTT đã ký.
- Cấp giá trị `validateservice.xml` qua cơ chế cấu hình được phê duyệt của từng môi trường đích.
- Không commit, dán vào ticket hoặc ghi trong tài liệu endpoint, credential, token, password hay certificate secret.
- Giữ nguyên cấu hình Kafka, file storage, TCT hiện hữu; thay đổi này không định nghĩa credential mới.

## Các bước rollout

1. Build và deploy artifact `api-cloud-service/` chứa `WS.Application` đã cập nhật.
2. Xác nhận host đọc được cấu hình và kết nối dịch vụ kiểm tra chữ ký mà không ghi log dữ liệu nhạy cảm.
3. Chạy TC01, TC05, TC08, TC09, TC11 trong `testcase.md` với tenant/hóa đơn cô lập.
4. Kiểm tra XML đã ký và XML thông điệp được lưu tại vị trí hiện hữu.
5. Kiểm tra producer log và monitoring phía sau để xác nhận Kafka/TCT handoff.
6. Theo dõi trạng thái hóa đơn, `ServiceTax`, `Transaction_Log`, API error, validation-service error và Kafka producer error trong giai đoạn đầu.

## Rollback

- Deploy lại artifact `api-cloud-service/` trước đó nếu luồng ký hoặc gửi TCT gặp lỗi.
- Không cần rollback database schema vì không có thay đổi schema.
- Trước khi retry một hóa đơn, kiểm tra trạng thái, XML đã ký, `ServiceTax`, `Transaction_Log` và log producer/file để tránh gửi TCT trùng.
