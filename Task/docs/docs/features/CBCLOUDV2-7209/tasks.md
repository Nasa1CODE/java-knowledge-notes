# CBCLOUDV2-7209 - Công việc

## Công việc 1 - Tạo XML MTT chưa ký

- Trạng thái: completed
- Khu vực/dịch vụ: `api-cloud-service/`
- Mô tả: Thêm `TaiXmlMTTChuaKy` và helper tạo XML MTT chưa ký, kiểm tra điều kiện hóa đơn, lưu mã phiên ngắn hạn và trả XML Base64.
- Tiêu chí chấp nhận:
  - [x] Hóa đơn hợp lệ trả `maketqua = "01"`, `base64xml`, `maphiengiaodich`.
  - [x] Doanh nghiệp, ngày lập hoặc trạng thái hóa đơn không hợp lệ trả kết quả lỗi hiện hữu.
  - [x] Mã phiên được lưu qua cache helper.
- Kiểm chứng:
  - [x] Source xác nhận API gọi `KyToken_TaiXMLMTTChuaKyAsync`.
  - [ ] Chạy TC01-TC04 trong `testcase.md`.
- Phụ thuộc: Không có
- File liên quan: `XuLyHoaDonAppService.cs`, `HoaDonHelper.cs`

## Công việc 2 - Nhận và lưu XML MTT đã ký

- Trạng thái: completed
- Khu vực/dịch vụ: `api-cloud-service/`
- Mô tả: Thêm `GuiXmlMTTDaKy` và helper để kiểm tra phiên/chữ ký, cấp số khi cần, lưu XML, cập nhật hóa đơn và xóa cache ký.
- Tiêu chí chấp nhận:
  - [x] Phiên thiếu/sai, chữ ký sai hoặc trạng thái không hợp lệ không tạo kết quả ký thành công.
  - [x] XML hợp lệ cập nhật trạng thái/thông tin ký và trả dữ liệu hóa đơn.
  - [x] Email tự động vẫn phụ thuộc cấu hình doanh nghiệp cũ.
- Kiểm chứng:
  - [x] Source xác nhận các nhánh kiểm tra, upload, cập nhật và xóa cache.
  - [ ] Chạy TC05-TC08 trong `testcase.md`.
- Phụ thuộc: Công việc 1
- File liên quan: `XuLyHoaDonAppService.cs`, `HoaDonHelper.cs`, `appsettings.json`

## Công việc 3 - Gửi XML MTT đủ điều kiện tới TCT

- Trạng thái: completed
- Khu vực/dịch vụ: `api-cloud-service/`
- Mô tả: Thêm `GuiTCTMTT` để chống gửi trùng, tạo bản ghi theo dõi, lưu XML thông điệp, cập nhật trạng thái và phát Kafka.
- Tiêu chí chấp nhận:
  - [x] Luồng TT78 Token gửi từng hóa đơn gọi `GuiTCTMTT` sau khi ký thành công.
  - [x] Mã thông điệp được lấy từ XML đã ký.
  - [x] Gửi trùng không phải retry bị từ chối.
  - [x] Producer thành công chuyển trạng thái sang `DangGuiTCT`.
- Kiểm chứng:
  - [x] Source có thao tác `ServiceTax`, `Transaction_Log`, file upload, cập nhật trạng thái và Kafka producer.
  - [ ] Chạy TC09-TC12 và kiểm tra bản ghi/log.
- Phụ thuộc: Công việc 2
- File liên quan: `TCTAppService.cs`, `XuLyHoaDonAppService.cs`

## Công việc 4 - Cập nhật tài liệu

- Trạng thái: completed
- Khu vực/dịch vụ: `docs/`
- Mô tả: Tạo đủ bộ tài liệu feature theo source đã thay đổi, không đưa dữ liệu nhạy cảm vào tài liệu.
- Tiêu chí chấp nhận:
  - [x] Có `expect.md`, `plan.md`, `tasks.md`, `testcase.md`, `impact.md`, `report.md`, `deploy.md`.
  - [x] Dùng tên dịch vụ chuẩn `api-cloud-service/`.
  - [x] Không ghi cấu hình cụ thể, secret, dữ liệu khách hàng hoặc XML đã ký.
- Kiểm chứng: [x] Kiểm tra thư mục `docs/features/CBCLOUDV2-7209/`.
- Phụ thuộc: Công việc 1, 2, 3
