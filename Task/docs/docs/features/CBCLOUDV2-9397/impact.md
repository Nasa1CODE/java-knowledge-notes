# Impact - CBCLOUDV2-9397

## 1. Mục đích

Điều chỉnh validation tại `api-cloud-service` để 9 field hàng hóa đặc trưng loại 1 chỉ bắt buộc với tài sản đã qua sử dụng, đồng nhất nghiệp vụ CBCLOUDV2-9257.

## 2. Phạm vi thay đổi

- Chỉ logic: có.
- Đụng dữ liệu: không thay đổi schema hoặc dữ liệu cũ.
- Đổi schema / migration: không.
- Đổi hợp đồng API: có thay đổi hành vi validation; không đổi DTO/route/response schema.

## 3. Thành phần bị ảnh hưởng

### Backend

| Service | File / method | Mức | Lý do |
|---|---|---|---|
| api-cloud-service | `GuiHoaDonAppService.ValidateHangHoaDacTrungXeValues(...)` | Trung bình | Đã sửa required condition dùng chung cho hóa đơn gốc/thay thế/điều chỉnh và wrapper ký |
| api-cloud-service | `test/WS.Application.Tests/HoaDon/VehicleAssetRequiredRuleTests.cs` | Thấp | Automated regression cho rule mới và rule giữ nguyên |

### API

| Nhóm | Endpoint | Mức |
|---|---|---|
| Lưu trực tiếp | `GuiHoaDonGoc`, `GuiHoaDonThayThe`, `GuiHoaDonDieuChinh` | Trung bình |
| Kế thừa HSM/MTT | `GuiVaKyHoadonGocHSM`, `GuiVaKyHoaDonThayTheHSM`, `GuiVaKyHoaDonDieuChinhHSM`, `GuiHoaDonVaKyMTT`, `GuiHoaDonVaKyMTT_V2` | Trung bình |
| Regression gián tiếp | `GuiHoaDonGocXML`, `GuiHoaDonThayTheXML`, `GuiHoaDonDieuChinhXML` | Thấp |

### Frontend

Không ảnh hưởng; API tích hợp không yêu cầu thay đổi UI/proxy trong task này.

### Database

| Bảng / cột | Thay đổi | Mức | Migration |
|---|---|---|---|
| `vs_hd_chitiet_morong` và `vs_hd_tonghop_morong` | Không đổi | Không | Không |

### Hàng đợi / tích hợp / cấu hình

Không đổi queue, topic, DTO message hoặc khóa cấu hình.

## 4. Xác nhận KHÔNG bị ảnh hưởng

| Vùng | Vì sao không bị ảnh hưởng |
|---|---|
| Import Excel BE/service nền | Đã thuộc CBCLOUDV2-9257, không nằm trong repo API này |
| Mapping DB và XML | Chỉ thay required condition trước bước lưu |
| Maxlength/precision/enum | Giữ nguyên các check hiện có |
| Hàng hóa đặc trưng loại 2/3 | Helper return khi subtype khác 1 |
| Request version cũ | Validator mới chỉ được gọi theo `IsNghiDinhMoi(version)` |

## 5. Rủi ro & hạn chế đã biết

| Rủi ro / hạn chế | Mức | Xử lý |
|---|---|---|
| Helper dùng chung có blast radius trên nhiều endpoint | Trung bình | Unit test helper và test đủ ba DTO |
| Giá trị null và parse lỗi cùng dùng nullable | Trung bình | Giữ sentinel `MinValue`, test riêng invalid input |
| API ký có side effect cấp số/gửi TCT | Cao | Dùng môi trường test; request validation lỗi phải dừng trước side effect |
| Dữ liệu hóa đơn đa tenant | Cao | Chỉ dùng tenant test và dữ liệu giả; không kiểm tra chéo dữ liệu khách hàng thật |

## 6. Chưa được kiểm chứng

| Việc chưa làm | Vì sao |
|---|---|
| Postman/Newman 8 API | Chưa triển khai |
| Regression 3 API XML | Chưa triển khai |
| Cách ly tenant | Chưa có hai tenant test local |

## 7. Kết luận

Rủi ro code đã được giảm bằng 20 unit test và build 0 error. Rủi ro tổng thể vẫn ở mức trung bình cho tới khi hoàn tất regression API có side effect HSM/MTT/XML trên môi trường test.
