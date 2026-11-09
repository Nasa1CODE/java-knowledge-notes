# Expect - CBCLOUDV2-9397: Đồng bộ điều kiện bắt buộc hàng hóa đặc trưng 1 cho API tích hợp

status: draft

## Bối cảnh

Task CBCLOUDV2-9167 đã bổ sung bộ dữ liệu hàng hóa đặc trưng xe cho các API tích hợp tại `api-cloud-service`. Validator hiện bắt buộc 9 trường cho mọi tài sản có `version = 1` và `loaihoadondactrung = 1`, chưa đồng nhất với nghiệp vụ CBCLOUDV2-9257.

## Mong muốn

Với request có `version = 1` và dòng `dschitiet[]` có `loaihoadondactrung = 1`:

- Chỉ bắt buộc 9 trường dưới đây khi `tinhtrangtaisan = 1` (đã qua sử dụng):
  - `ma_nuocsx`.
  - `ten_loaitaisan`.
  - `namsanxuat`.
  - `ten_thuongmai`.
  - `ten_nhanhieu`.
  - `kieuloaixe`.
  - `thetich_congsuat`.
  - `trongtai`.
  - `sochongoi`.
- Khi `tinhtrangtaisan = 0` (chưa qua sử dụng), 9 trường được phép để trống.
- Không phân biệt `loaitaisan` khi áp dụng điều kiện required.
- Nếu trường optional có giá trị thì vẫn kiểm tra kiểu, format và maxlength hiện tại.

## Acceptance Criteria

- **AC1:** Xe chưa qua sử dụng có thể để trống cả 9 trường và không nhận message required của 9 trường.
- **AC2:** Xe đã qua sử dụng thiếu bất kỳ trường nào trong 9 trường phải nhận đúng message `... không được để trống.` theo STT dòng.
- **AC3:** Xe chưa qua sử dụng truyền giá trị sai kiểu, sai format hoặc vượt maxlength vẫn bị từ chối theo message hiện tại.
- **AC4:** Rule cho kết quả nhất quán trên API hóa đơn gốc, thay thế, điều chỉnh và các wrapper HSM/MTT dùng lại các API lưu.
- **AC5:** Giữ nguyên required của `sokhung`, `somay`, `loaitaisan`, `tinhtrangtaisan`, `xuatxu`; chứng từ theo `xuatxu`; `chatluongtaisan` và `sobienkiemsoat` khi tài sản đã qua sử dụng.
- **AC6:** Request không có `version = 1` hoặc dòng không có `loaihoadondactrung = 1` giữ nguyên luồng cũ.

## Ngoài phạm vi

- Không sửa frontend, import Excel, service nền hoặc `invoicecore`.
- Không sửa DTO, mapping DB, XML, schema/migration, queue hoặc cấu hình.
- Không thay đổi giá trị maxlength, precision, enum hoặc nội dung message hiện tại.
- Không bổ sung điều kiện theo `loaitaisan`.

## Câu hỏi mở

| # | Câu hỏi | Người trả lời | Trạng thái |
|---|---|---|---|
| 1 | Xác nhận vị trí source của test project HDDT: `test/WS.Application.Tests` hiện chỉ còn `bin/obj` trong worktree local | DEV/TechLead | chờ |

## Ảnh hưởng người dùng / dữ liệu

Đối tác gọi API tích hợp có thể gửi xe chưa qua sử dụng mà không cần 9 trường nêu trên. Không chuyển đổi dữ liệu cũ và không thay đổi dữ liệu đã lưu.

## Tài liệu liên quan

- `features/CBCLOUDV2-9167/plan.md`.
- `features/CBCLOUDV2-9257/expect.md`.
- `specs/system.md` - API integration.
