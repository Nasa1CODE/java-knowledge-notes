# Impact - CBCLOUDV2-9379

## 1. Mục đích

Đánh giá ảnh hưởng khi đồng bộ bảy maxlength Hàng hóa đặc trưng loại 1 cho API tích hợp.

## 2. Thành phần ảnh hưởng

| Service | File/method | Mức | Lý do |
|---|---|---|---|
| `api-cloud-service` | `ValidateNguoiMuaDacTrungXeValues(...)` | Trung bình | Mã tỉnh/Mã xã dùng chung ba input |
| `api-cloud-service` | `ValidateHangHoaDacTrungXeValues(...)` | Trung bình | Năm maxlength detail dùng chung ba input |
| `api-cloud-service` | 3 API lưu | Trung bình | Gọi validation trực tiếp |
| `api-cloud-service` | 3 HSM, 2 MTT, 3 XML | Cao khi test | Kế thừa behavior, có side effect |
| tenant DB | `vs_hd_chitiet_morong` | Cao | Phải mở rộng theo CBCLOUDV2-9260 trước API |

## 3. API ảnh hưởng

- Trực tiếp: `GuiHoaDonGoc`, `GuiHoaDonThayThe`, `GuiHoaDonDieuChinh`.
- Kế thừa: `GuiVaKyHoadonGocHSM`, `GuiVaKyHoaDonThayTheHSM`, `GuiVaKyHoaDonDieuChinhHSM`, `GuiHoaDonVaKyMTT`, `GuiHoaDonVaKyMTT_V2`.
- Regression: `GuiHoaDonGocXML`, `GuiHoaDonThayTheXML`, `GuiHoaDonDieuChinhXML`.

## 4. Dữ liệu và contract

- Không đổi DTO/entity/mapping/XML tag.
- Năm field có thể lưu chuỗi dài hơn; DB migration thuộc CBCLOUDV2-9260.
- Mã tỉnh/xã bị siết validation nhưng không thu hẹp cột DB.
- REST/queue/XML contract giữ nguyên.

## 5. Không ảnh hưởng

| Vùng | Lý do |
|---|---|
| Import/worker | Thuộc CBCLOUDV2-9260 |
| Frontend/NSwag | Không đổi contract |
| Required/enum/precision | Chỉ đổi maxlength |
| Field ngoài danh sách | Dùng helper cũ |
| Template/API subtype 2/3 | Gate giữ nguyên |
| DB migration ownership | Không tạo SQL trùng |

## 6. Rủi ro

| Rủi ro | Mức | Xử lý |
|---|---|---|
| API deploy trước DB | Cao | Dependency deploy CBCLOUDV2-9260 |
| Byte/ký tự lệch Import | Trung bình | Helper ký tự riêng; Unicode test |
| Bỏ sót buyer location | Trung bình | Test riêng `ma_tinh`/`ma_xa` |
| HSM/MTT side effect | Cao | Chỉ test tenant/môi trường an toàn |

## 7. Kết quả và phần chưa kiểm chứng

- Đã sửa đúng shared buyer/detail validators và thêm helper đếm ký tự phạm vi hẹp.
- Automated test pass 25/25; build `WS.Application` thành công với 0 error, 19 warning tồn tại sẵn.
- Chưa xác nhận migration CBCLOUDV2-9260 đã apply trên tenant runtime.
- Chưa gọi 11 API regression.

## 8. Kết luận

Thay đổi thực tế giới hạn trong một AppService và một file test, nhưng ảnh hưởng nhiều API qua shared validators và phụ thuộc DB. Rủi ro tổng thể trung bình; rủi ro deploy cao nếu API đi trước migration CBCLOUDV2-9260.
