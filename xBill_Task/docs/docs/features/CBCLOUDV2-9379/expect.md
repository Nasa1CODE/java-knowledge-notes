# Expect - CBCLOUDV2-9379: Điều chỉnh maxlength API Hàng hóa đặc trưng 1

status: testing
services-affected: api-cloud-service

## Bối cảnh

Tài liệu Hàng hóa đặc trưng 1 thay đổi maxlength của bảy trường. API tích hợp hiện vẫn kiểm tra theo giới hạn cũ, nên cần đồng bộ với CBCLOUDV2-9260 của luồng Import.

## Điều kiện áp dụng

Chỉ áp dụng khi:

- `version` khác rỗng và `version.Trim() == "1"`.
- Buyer location rule chạy khi request có ít nhất một `dschitiet[]` với `loaihoadondactrung = 1`.
- Detail rule chạy trên từng item có `loaihoadondactrung = 1`.

API không dùng điều kiện `loaihanghoa = 4` của Import Excel và không thêm điều kiện theo `loaitaisan` hoặc `tinhtrangtaisan` cho maxlength.

## Bảng giới hạn mới

| # | Field API | Vị trí | Cũ | Mới |
|---|---|---|---:|---:|
| 1 | `ma_tinh` | Người mua | 3 | 2 |
| 2 | `ma_xa` | Người mua | 8 | 5 |
| 3 | `ten_loaitaisan` | Chi tiết loại 1 | 200 | 255 |
| 4 | `ten_nhanhieu` | Chi tiết loại 1 | 200 | 255 |
| 5 | `sogiaychungnhanatkt` | Chi tiết loại 1 | 200 | 255 |
| 6 | `soseripktcl` | Chi tiết loại 1 | 200 | 255 |
| 7 | `ten_thuongmai` | Chi tiết loại 1 | 300 | 400 |

Maxlength được tính theo số ký tự, đồng bộ với CBCLOUDV2-9260 và nội dung message `ký tự`.

## API chịu thay đổi hành vi

### API lưu trực tiếp

1. `POST /api/services/hddtws/GuiHoaDon/GuiHoaDonGoc`.
2. `POST /api/services/hddtws/GuiHoaDon/GuiHoaDonThayThe`.
3. `POST /api/services/hddtws/GuiHoaDon/GuiHoaDonDieuChinh`.

### API kế thừa

4. `GuiVaKyHoadonGocHSM`.
5. `GuiVaKyHoaDonThayTheHSM`.
6. `GuiVaKyHoaDonDieuChinhHSM`.
7. `GuiHoaDonVaKyMTT`.
8. `GuiHoaDonVaKyMTT_V2`.

### API XML regression

9. `GuiHoaDonGocXML`.
10. `GuiHoaDonThayTheXML`.
11. `GuiHoaDonDieuChinhXML`.

## Acceptance Criteria

- **AC1:** Ba API lưu trực tiếp áp dụng Mã tỉnh tối đa 2 ký tự và Mã xã tối đa 5 ký tự khi request thỏa gate Hàng hóa đặc trưng loại 1.
- **AC2:** Ba API lưu trực tiếp áp dụng giới hạn 255 cho `ten_loaitaisan`, `ten_nhanhieu`, `sogiaychungnhanatkt`, `soseripktcl` và 400 cho `ten_thuongmai` trên từng item loại 1.
- **AC3:** Với từng field, giá trị đúng N ký tự không sinh lỗi maxlength; N+1 sinh đúng message `không được vượt quá N ký tự` kèm STT đối với field chi tiết.
- **AC4:** `version` null/rỗng/khác `1` hoặc item không phải `loaihoadondactrung = 1` không kích hoạt bảy rule mới.
- **AC5:** Required, enum, precision, danh mục tỉnh/xã, maxlength ngoài danh sách và điều kiện xe đã qua sử dụng/xuất xứ giữ nguyên.
- **AC6:** Năm API HSM/MTT và ba API XML kế thừa đúng validation; request lỗi phải dừng trước side effect ký/cấp số/gửi TCT.
- **AC7:** Dữ liệu boundary hợp lệ lưu đầy đủ, không truncate; DB tenant đã được mở rộng theo CBCLOUDV2-9260 trước khi deploy API.
- **AC8:** Không đổi route, DTO, response, Swagger/NSwag, XML tag, frontend, queue hoặc mapping.

## Ngoài phạm vi

- Không sửa Import Excel, worker hoặc frontend.
- Không tạo migration DB trùng với CBCLOUDV2-9260.
- Không đổi required hoặc maxlength field ngoài bảng.
- Không đổi toàn bộ helper maxlength dùng chung nếu có thể giới hạn thay đổi cho bảy field.

## Câu hỏi mở

Không có. Deployment bắt buộc xác nhận migration CBCLOUDV2-9260 đã được DBA áp dụng.

## Tài liệu liên quan

- `features/CBCLOUDV2-9260/`.
- `features/CBCLOUDV2-9385/`.
- `features/CBCLOUDV2-9167/plan.md`.
