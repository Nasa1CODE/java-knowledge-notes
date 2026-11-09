# CBCLOUDV2-7209 - Mong đợi

## Trạng thái

- Trạng thái: done
- Độ lớn: M

## Mục tiêu nghiệp vụ

Hỗ trợ luồng ký Token MTT cho hóa đơn TT78: ứng dụng khách tải XML chưa ký, ký bằng Token, sau đó gửi XML đã ký về API. API kiểm tra, lưu XML đã ký và gửi thông điệp đến TCT khi doanh nghiệp được cấu hình gửi từng hóa đơn.

## Phạm vi

- Dịch vụ: `api-cloud-service/`.
- API: `TaiXmlMTTChuaKy`, `GuiXmlMTTDaKy` trong `XuLyHoaDonAppService`.
- Xử lý ký: `KyToken_TaiXMLMTTChuaKyAsync`, `KyToken_GuiXmlMTTDaKyTT78Async` trong `HoaDonHelper`.
- Gửi TCT: `TCTAppService.GuiTCTMTT`.
- Phụ thuộc: dịch vụ kiểm tra chữ ký XML được cấu hình tại host.

## Hành vi mong đợi

- Người dùng tenant được phân quyền có thể tải XML MTT chưa ký của hóa đơn thuộc doanh nghiệp hiện tại.
- Hóa đơn hợp lệ trả về XML Base64 và mã phiên giao dịch ngắn hạn.
- API từ chối doanh nghiệp, hóa đơn, ngày lập hoặc trạng thái hóa đơn không hợp lệ; đồng thời từ chối hóa đơn đã ký/đã gửi theo quy tắc TT78 hiện hữu.
- Sau khi nhận XML đã ký, API kiểm tra mã phiên và chữ ký XML, lưu XML, cập nhật trạng thái và thông tin người ký.
- Với hóa đơn TT78 đủ điều kiện gửi từng lần, API lấy mã thông điệp từ XML đã ký, tạo `ServiceTax` và `Transaction_Log`, lưu XML thông điệp và phát Kafka tới luồng TCT.
- Gửi email tự động chỉ diễn ra theo cấu hình doanh nghiệp hiện có.

## Ngoài phạm vi

- Không có thay đổi frontend, generated proxy hoặc thành phần ký Token phía ứng dụng khách trong source đã xem.
- Không thay đổi schema, migration, thiết kế lại DTO hoặc xóa API hiện hữu.
- Không thay đổi Kafka consumer, xử lý phản hồi TCT hoặc worker service.
- Không ghi endpoint, secret, credential, Token hoặc dữ liệu hóa đơn thật vào tài liệu.

## Tiêu chí chấp nhận

- `TaiXmlMTTChuaKy` trả XML Base64 và `maphiengiaodich` cho hóa đơn đủ điều kiện.
- `GuiXmlMTTDaKy` không được đánh dấu hóa đơn đã ký khi mã phiên hoặc chữ ký XML không hợp lệ.
- XML hợp lệ được lưu, cập nhật thông tin ký và trả kết quả hóa đơn đã ký.
- Luồng TCT đủ điều kiện tạo bản ghi theo dõi, chuyển hóa đơn sang `DangGuiTCT`, lưu XML thông điệp và phát Kafka.
- Gửi TCT không phải gửi lại bị từ chối khi đã tồn tại bản ghi gửi.
- Không cần migration; môi trường triển khai phải có dịch vụ kiểm tra chữ ký XML hoạt động.
