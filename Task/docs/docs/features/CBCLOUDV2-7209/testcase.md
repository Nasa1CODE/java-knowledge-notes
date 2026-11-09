# CBCLOUDV2-7209 - Kiểm thử

## Phạm vi và điều kiện

Kiểm thử ký Token MTT trong `api-cloud-service/` trên tenant không phải production. Cần có user được phân quyền, hóa đơn TT78 đủ điều kiện, Token hợp lệ, file storage, Kafka và dịch vụ kiểm tra chữ ký hoạt động. Không đính kèm XML đã ký, chứng thư, credential hoặc dữ liệu khách hàng thật vào bằng chứng test.

## TC01 - Tải XML chưa ký thành công

- Loại: Dương tính
- Thực hiện: Gọi `TaiXmlMTTChuaKy` với doanh nghiệp hiện tại, mã giao dịch/hóa đơn hợp lệ.
- Mong đợi: `maketqua = "01"`; có `base64xml`, `maphiengiaodich`; thông báo tải hóa đơn thành công.
- Trạng thái: Chưa chạy cục bộ.

## TC02 - Từ chối doanh nghiệp không hợp lệ

- Loại: Âm tính
- Thực hiện: Gọi `TaiXmlMTTChuaKy` với mã doanh nghiệp không qua kiểm tra hiện hữu.
- Mong đợi: Không trả XML chưa ký; trả thông báo không tìm thấy doanh nghiệp hoặc kết quả lỗi mặc định.
- Trạng thái: Chưa chạy cục bộ.

## TC03 - Từ chối hóa đơn đã ký/đã gửi

- Loại: Âm tính/hồi quy
- Thực hiện: Tải XML cho hóa đơn có trạng thái bị chặn theo TT78.
- Mong đợi: `maketqua = "03"`, không tạo mã phiên mới.
- Trạng thái: Chưa chạy cục bộ.

## TC04 - Từ chối ngày lập không hợp lệ

- Loại: Âm tính
- Thực hiện: Tải XML cho hóa đơn có ngày lập trước ngày được phép ký.
- Mong đợi: `maketqua = "04"`, thông báo ngày lập không hợp lệ.
- Trạng thái: Chưa chạy cục bộ.

## TC05 - Gửi XML đã ký hợp lệ

- Loại: Dương tính
- Thực hiện: Ký XML từ TC01 bằng Token hợp lệ, gọi `GuiXmlMTTDaKy` với XML Base64 và mã phiên.
- Mong đợi: `maketqua = "01"`; XML được lưu; hóa đơn có thông tin ký và trạng thái `DaKy` hoặc `DangGuiTCT` khi đủ điều kiện TC09.
- Trạng thái: Chưa chạy cục bộ.

## TC06 - Thiếu mã phiên

- Loại: Âm tính
- Thực hiện: Gọi `GuiXmlMTTDaKy` không có `maphiengiaodich`.
- Mong đợi: Không cập nhật hóa đơn; trả kết quả lỗi mặc định hiện hữu.
- Trạng thái: Chưa chạy cục bộ.

## TC07 - Mã phiên hết hạn hoặc không hợp lệ

- Loại: Âm tính
- Thực hiện: Gửi mã phiên sai định dạng, hết hạn hoặc không tồn tại trong cache.
- Mong đợi: `maketqua = "07"` khi không có nội dung phiên hoặc `maketqua = "11"` khi sai định dạng; không lưu XML đã ký.
- Trạng thái: Chưa chạy cục bộ.

## TC08 - Chữ ký XML không hợp lệ

- Loại: Âm tính
- Thực hiện: Gửi XML Base64 không qua dịch vụ kiểm tra chữ ký.
- Mong đợi: `maketqua = "08"`, `Chữ ký không hợp lệ!`, không ký thành công và không gửi TCT.
- Trạng thái: Chưa chạy cục bộ.

## TC09 - Gửi TCT thành công

- Loại: Tích hợp dương tính
- Điều kiện: TT78, Token, doanh nghiệp được TCT phê duyệt, gửi từng lần, hóa đơn gốc/điều chỉnh/thay thế.
- Thực hiện: Hoàn thành TC05 với XML có `TTChung.MTDiep`.
- Mong đợi: Tạo `ServiceTax`, `Transaction_Log`; trạng thái `DangGuiTCT`; lưu XML thông điệp; gọi Kafka producer.
- Trạng thái: Chưa chạy cục bộ.

## TC10 - XML thiếu mã thông điệp

- Loại: Âm tính
- Thực hiện: Gửi XML đã ký thiếu `TTChung` hoặc `TTChung.MTDiep`.
- Mong đợi: `maketqua = "10"`; không tạo bản ghi gửi TCT mới.
- Trạng thái: Chưa chạy cục bộ.

## TC11 - Từ chối gửi TCT trùng

- Loại: Âm tính/hồi quy
- Điều kiện: Hóa đơn/doanh nghiệp đã có `ServiceTax`.
- Thực hiện: Gọi lại luồng `GuiTCTMTT` không phải gửi lại.
- Mong đợi: Báo hóa đơn đã gửi TCT; không có `ServiceTax` trùng.
- Trạng thái: Chưa chạy cục bộ.

## TC12 - Doanh nghiệp chưa được TCT phê duyệt

- Loại: Âm tính
- Thực hiện: Đi vào `GuiTCTMTT` với doanh nghiệp chưa được TCT phê duyệt.
- Mong đợi: Không phát Kafka; trả thông báo chưa được TCT phê duyệt.
- Trạng thái: Chưa chạy cục bộ.

## Build

```powershell
dotnet build src\hddt\WS.Application\WS.Application.csproj
```

Mong đợi: build thành công, không có error. Lệnh chưa chạy trong lần lập tài liệu này.
