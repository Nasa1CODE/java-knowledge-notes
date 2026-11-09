# CBCLOUDV2-7209 - Báo cáo

## Tổng quan

Đã tài liệu hóa thay đổi staged trong `api-cloud-service/` cho luồng ký Token MTT: tạo XML chưa ký, kiểm tra/nhận XML đã ký, cập nhật trạng thái ký và gửi hóa đơn TT78 đủ điều kiện tới TCT qua file management và Kafka producer hiện hữu.

## Source đã thay đổi

| File | Thay đổi quan sát được |
| --- | --- |
| `api-cloud-service/src/hddt/WS.Application/AppServices/HoaDon/GuiHoaDonAppService.cs` | Dùng system ID hóa đơn MTT khi ký và trả thông báo từ kết quả ký MTT. |
| `api-cloud-service/src/hddt/WS.Application/AppServices/HoaDon/TCTAppService.cs` | Thêm `GuiTCTMTT`: kiểm tra điều kiện, xử lý trùng/gửi lại, tạo dữ liệu theo dõi, lưu XML và phát Kafka. |
| `api-cloud-service/src/hddt/WS.Application/AppServices/HoaDon/XuLyHoaDonAppService.cs` | Thêm `TaiXmlMTTChuaKy`, `GuiXmlMTTDaKy`; điều phối ký, gửi TCT, email và xóa cache. |
| `api-cloud-service/src/hddt/WS.Application/Commons/HoaDon/HoaDonHelper.cs` | Thêm tạo XML MTT chưa ký, quản lý phiên, kiểm tra/lưu XML đã ký. Diff staged cũng có chỉnh sửa mã hóa ký tự không thuộc luồng chính. |
| `api-cloud-service/src/zero/VS.Web.Host/appsettings.json` | Thêm tham chiếu dịch vụ kiểm tra chữ ký XML; giá trị cấu hình không được sao chép vào tài liệu. |

## Luồng đã triển khai

1. `TaiXmlMTTChuaKy` kiểm tra doanh nghiệp và hóa đơn.
2. `KyToken_TaiXMLMTTChuaKyAsync` tạo thông điệp XML chưa ký, lưu cache phiên và trả XML Base64/mã phiên.
3. Client ký XML ngoài API rồi gọi `GuiXmlMTTDaKy` cùng XML Base64 và mã phiên.
4. `KyToken_GuiXmlMTTDaKyTT78Async` kiểm tra phiên/chữ ký, cấp số nếu cần, lưu XML và cập nhật trạng thái/thông tin ký.
5. Khi thỏa điều kiện TT78 gửi từng lần, `GuiTCTMTT` lấy mã thông điệp, tạo bản ghi theo dõi, lưu XML thông điệp, chuyển `DangGuiTCT` và phát Kafka.
6. Email tự động tiếp tục theo cấu hình doanh nghiệp hiện hữu.

## Bằng chứng kiểm chứng

### Kiểm tra source

- `git diff --cached --name-only` xác định năm file source/config thay đổi như bảng trên.
- Tìm kiếm source xác định các phương thức MTT mới trong `XuLyHoaDonAppService.cs`, `HoaDonHelper.cs`, `TCTAppService.cs`.
- Không có test source khớp với `GuiTCTMTT`, `TaiXmlMTTChuaKy`, `GuiXmlMTTDaKy`, `KyToken_TaiXMLMTTChuaKyAsync`, `KyToken_GuiXmlMTTDaKyTT78Async` dưới `api-cloud-service/test/`.

### Chưa thực hiện

- Chưa chạy `dotnet build`.
- Chưa chạy unit test, integration test hoặc API test.
- Chưa kiểm tra tích hợp chữ ký XML, file storage, Kafka, TCT, email hoặc database.
- Chưa deploy staging/production.

## Ghi chú triển khai

- Cần deploy artifact `api-cloud-service/` chứa `WS.Application` đã cập nhật.
- Môi trường đích phải có dịch vụ kiểm tra chữ ký, file storage và Kafka/TCT producer hoạt động.
- Không có migration được quan sát.

## Theo dõi tiếp

- Chạy toàn bộ test case trong `testcase.md` trước release.
- Xác nhận client/frontend gọi API và hợp đồng payload ký Token.
- Bổ sung test tự động cho phiên ký, chữ ký sai và gửi TCT trùng khi test harness legacy cho phép.
