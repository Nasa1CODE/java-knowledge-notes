# CBCLOUDV2-7209 - Kế hoạch

## Mục tiêu

Tài liệu hóa thay đổi đã triển khai cho luồng ký Token MTT và gửi TCT trong `api-cloud-service/`, bao gồm API, dữ liệu, tích hợp, rủi ro, kiểm thử và triển khai.

## Bối cảnh

- `XuLyHoaDonAppService` là lớp API HDDT; `HoaDonHelper` xử lý XML/ký; `TCTAppService` tạo dữ liệu theo dõi và phát thông điệp TCT.
- Đây là tài liệu dựa trên source đã thay đổi. Build và kiểm thử chưa có bằng chứng không được ghi nhận là đã thành công.

## Giả định và câu hỏi mở

- MTT là tên luồng ký Token theo thông điệp có trong source; source không mô tả đầy đủ tên viết tắt nghiệp vụ.
- Frontend/client phải gửi mã phiên và XML Base64 đã ký; source client không nằm trong thay đổi được xem.
- Dịch vụ kiểm tra chữ ký XML phải sẵn sàng từ API host; đội vận hành cần xác nhận chủ sở hữu, SLA và cơ chế bảo mật.
- Phát Kafka chỉ xác nhận producer dispatch, không khẳng định TCT đã tiếp nhận.

## Tác động

- Thêm hai HTTP POST API tại dịch vụ hóa đơn.
- Thành công ký cập nhật trạng thái, XML, người ký, ngày ký và có thể cấp số hóa đơn.
- Thành công gửi TCT thêm `ServiceTax`, `Transaction_Log`, chuyển trạng thái `DangGuiTCT`, lưu XML thông điệp và phát Kafka.
- Có thêm cấu hình trỏ tới dịch vụ kiểm tra chữ ký; giá trị cụ thể không được tài liệu hóa.
- Không có migration hoặc thay đổi schema.

## Hạng mục tài liệu

### Hạng mục 1 - Ghi nhận hợp đồng chức năng

- Trạng thái: completed
- Khu vực: `docs/`, `api-cloud-service/`
- Kết quả: `expect.md` mô tả API, điều kiện hợp lệ, luồng thành công/thất bại và phạm vi loại trừ.
- Kiểm chứng: đối chiếu `XuLyHoaDonAppService.cs`, `HoaDonHelper.cs`, `TCTAppService.cs`.

### Hạng mục 2 - Ghi nhận ảnh hưởng và test case

- Trạng thái: completed
- Khu vực: `docs/`, `api-cloud-service/`
- Kết quả: `impact.md`, `testcase.md`, `deploy.md` phân biệt rõ dữ kiện đã xem với kiểm chứng chưa chạy.
- Kiểm chứng: kiểm tra staged source/config và tìm test theo tên phương thức mới.

### Hạng mục 3 - Báo cáo bằng chứng source

- Trạng thái: completed
- Khu vực: `docs/`, `api-cloud-service/`
- Kết quả: `tasks.md`, `report.md` ghi file đã đổi và các kiểm chứng còn thiếu.
- Kiểm chứng: đối chiếu với `git diff --cached --name-only` trong `api-cloud-service/`.

## Kế hoạch kiểm chứng

```powershell
dotnet build src\hddt\WS.Application\WS.Application.csproj
```

- Chạy các kịch bản trong `testcase.md` trên môi trường cô lập có tenant, hóa đơn, Token, Kafka, file storage và dịch vụ kiểm tra chữ ký.
- Kiểm tra bản ghi hóa đơn, `ServiceTax`, `Transaction_Log`, file XML và log producer sau luồng TCT thành công.

## Rủi ro và rollback

| Rủi ro | Tác động | Giảm thiểu | Rollback/theo dõi |
| --- | --- | --- | --- |
| Dịch vụ kiểm tra chữ ký lỗi/chậm | Cao | Kiểm tra kết nối, timeout và lỗi trước rollout | Deploy lại artifact API trước đó. |
| XML đã ký không hợp lệ | Trung bình | Bắt buộc kiểm tra chữ ký trước khi lưu | Trả lỗi, client yêu cầu XML chưa ký mới. |
| Gửi trùng/gửi lại xung đột | Trung bình | Kiểm tra `ServiceTax`, `Transaction_Log` hiện hữu | Rà soát lịch sử trước khi gửi lại. |
| Lỗi file storage hoặc Kafka | Cao | Theo dõi log producer/file | Kiểm tra trạng thái, file và lịch sử thông điệp trước retry. |

## Triển khai

- Deploy artifact `api-cloud-service/` có `WS.Application` mới.
- Cấp cấu hình dịch vụ kiểm tra chữ ký theo cơ chế cấu hình của môi trường; không hard-code hay ghi giá trị cấu hình vào ticket.
- Xác nhận Kafka và file storage có quyền truy cập trước rollout.
