---
feature: CBCLOUDV2-9379
title: Điều chỉnh maxlength API Hàng hóa đặc trưng 1
plan-status: plan-review
service: api-cloud-service
service-repo: ../api-cloud-service
services-affected: [api-cloud-service]
owner: DEV + AI
created_at: 2026-09-08
updated_at: 2026-09-08
---

# Plan - CBCLOUDV2-9379

## 1. Câu hỏi chặn

Không có. Trước deploy cần kiểm chứng dependency DB CBCLOUDV2-9260.

## 2. Tóm tắt cách làm

Sửa đúng hai shared validator trong `GuiHoaDonAppService`: buyer validator cho Mã tỉnh/Mã xã và detail validator cho năm field mô tả/chứng từ. API hiện đo bằng byte UTF-8; thêm helper đếm ký tự phạm vi hẹp và chỉ dùng cho bảy field để không ảnh hưởng maxlength khác. Ba API lưu dùng trực tiếp logic mới; HSM/MTT/XML kế thừa, không duplicate validation.

## 3. Truy vết yêu cầu

| AC | Phần thiết kế |
|---|---|
| AC1 | §5.1 |
| AC2 | §5.2 |
| AC3 | §5.1, §5.2, §11 |
| AC4 | §5.0, §11 |
| AC5 | §5.3 |
| AC6 | §5.4, §11 |
| AC7 | §7, §11 |
| AC8 | §9, §10 |

## 4. Service bị ảnh hưởng

| Service | Mức | Thay đổi chính |
|---|---|---|
| `api-cloud-service` | Trung bình | Shared validation của gốc/thay thế/điều chỉnh và wrapper |

## 5. Thiết kế chi tiết

### 5.0 Gate giữ nguyên

Buyer validator:

```csharp
IsNghiDinhMoi(version)
&& dschitiet != null
&& dschitiet.Any(x => x?.loaihoadondactrung == 1)
```

Detail validator được gọi trong block `IsNghiDinhMoi(version)` và tự return rỗng khi `loaiHoaDonDacTrung != 1`.

Không thêm `loaihanghoa == 4`; đó là property/gate của luồng Import, không phải API.

### 5.1 AC1/AC3 - Mã tỉnh và Mã xã

File: `src/hddt/WS.Application/AppServices/HoaDon/GuiHoaDonAppService.cs`.

Method: `ValidateNguoiMuaDacTrungXeValues(...)`.

- `maTinh`: 3 -> 2, message `Mã tỉnh không được vượt quá 2 ký tự.`.
- `maXa`: 8 -> 5, message `Mã xã không được vượt quá 5 ký tự.`.
- Giữ required và `ValidateDiaBanDacTrungXe(...)` để kiểm tra catalog tỉnh/xã.

### 5.2 AC2/AC3 - Năm field chi tiết

Method: `ValidateHangHoaDacTrungXeValues(...)`.

| Parameter | Cũ | Mới | Message có prefix STT |
|---|---:|---:|---|
| `soGiayChungNhanAtkt` | 200 | 255 | Có |
| `soSeriPktcl` | 200 | 255 | Có |
| `tenLoaiTaiSan` | 200 | 255 | Có |
| `tenThuongMai` | 300 | 400 | Có |
| `tenNhanHieu` | 200 | 255 | Có |

Thêm helper như `IsCharacterTooLong(value, maxLength)` dùng `value.Trim().Length` và chỉ thay bảy call-site của task. Giữ `IsTooLong(...)` UTF-8 hiện tại cho các field ngoài scope.

### 5.3 AC4/AC5 - Regression validation

- Giữ `IsNghiDinhMoi`, `HasHangHoaDacTrungXeMoi` và check subtype.
- Giữ required theo `tinhTrangTaiSan`, `xuatXu`, enum, decimal precision, catalog địa bàn và STT prefix.
- Giữ maxlength của Tên/MST/Địa chỉ/SĐT/Email/Họ tên, Số khung/Số máy/Mã nước/Kiểu xe/Công suất/Biển kiểm soát.

### 5.4 AC6 - API call chain

- Trực tiếp: `ValidateHDGoc`, `ValidateHDTT`, `ValidateHDDC`.
- HSM gọi lại `GuiHoaDonGoc`, `GuiHoaDonThayThe`, `GuiHoaDonDieuChinh`.
- MTT và MTT V2 gọi lại `GuiHoaDonGoc`.
- XML deserialize rồi gọi API lưu tương ứng.

Không sửa wrapper. Manual regression request lỗi trước side effect.

## 6. Thứ tự triển khai

1. Xác nhận migration CBCLOUDV2-9260 đã sẵn sàng trên tenant test.
2. Sửa helper ký tự và bảy call-site trong `GuiHoaDonAppService.cs`.
3. Bổ sung unit test reflection cho buyer/detail validator, boundary N/N+1, Unicode và negative gate.
4. Test/build `WS.Application`.
5. Manual ba API lưu, sau đó HSM/MTT/XML trên môi trường test.
6. Cập nhật docs/report theo output thật.

## 7. Thay đổi database

Không tạo migration mới. CBCLOUDV2-9379 phụ thuộc migration của CBCLOUDV2-9260 mở rộng năm cột `vs_hd_chitiet_morong` lên 255/400. Mã tỉnh/Mã xã chỉ siết validation 2/5, không thu hẹp cột DB.

## 8. Thay đổi cấu hình

None.

## 9. Tích hợp ngoài và liên service

- REST/DTO/response: backward compatible về contract, thay đổi validation boundary.
- HSM/CQT/MTT: không đổi contract; request validation lỗi phải dừng trước tích hợp.
- XML: không đổi schema/tag; dữ liệu hợp lệ có thể dài hơn.
- Tenant DB: phụ thuộc CBCLOUDV2-9260 deploy trước API.

## 10. Tương thích ngược

Giá trị cũ vẫn hợp lệ, ngoại trừ Mã tỉnh dài 3 và Mã xã dài 6-8 bị từ chối theo tài liệu mới. Client gửi năm field từ 201/301 tới giới hạn mới sẽ được chấp nhận sau khi DB đã mở rộng.

## 11. Kế hoạch kiểm chứng

```powershell
dotnet test test/WS.Application.Tests/WS.Application.Tests.csproj --no-restore --verbosity minimal
dotnet build src/hddt/WS.Application/WS.Application.csproj --no-restore --verbosity minimal
```

- Unit test bảy field tại N/N+1 và Unicode.
- Unit test `version` null/rỗng/khác 1, details null/rỗng và subtype null/2/3.
- Manual ba API lưu với request loại 1.
- Manual ba HSM, hai MTT bằng request dừng trước side effect khi validation lỗi.
- Manual ba XML và DB read-back boundary.

## 12. Rủi ro và rollback

| Rủi ro | Mức | Giảm thiểu / rollback |
|---|---|---|
| API nhận chuỗi dài trước DB migration | Cao | Verify CBCLOUDV2-9260 trước deploy |
| Đổi global helper ảnh hưởng field khác | Trung bình | Helper ký tự riêng cho bảy field |
| Bỏ sót Mã tỉnh/Mã xã vì nằm ở buyer validator | Trung bình | Unit test riêng buyer boundary |
| Wrapper HSM/MTT có side effect | Cao | Test lỗi trước ký/cấp số/gửi TCT trên tenant test |

Rollback code: hoàn tác bảy call-site/helper. Giữ DB mở rộng vì tương thích ngược.

## 13. Phương án khác đã xem xét

- Đổi global `IsTooLong` sang ký tự: loại vì blast radius ngoài task.
- Sửa từng API/wrapper: loại vì shared validators đã bao phủ call chain.
- Tạo migration DB mới: loại vì CBCLOUDV2-9260 đã sở hữu migration dùng chung.

## 14. Giả định

- “Tương tự” nghĩa là cùng bảy field và giới hạn của CBCLOUDV2-9260.
- Đơn vị là số ký tự, đồng bộ với tài liệu/message.
- Thư mục test untracked hiện tại thuộc task trước; implementation phải giữ và bổ sung test mới, không xóa.

## 15. Câu hỏi mở

Không có.

## 16. Cập nhật docs đề xuất (Gate 2)

- Hoàn thiện `testcase.md`, `impact.md`, `report.md` theo kết quả thật.
- Không sửa architecture/design/database docs trong task này; DB docs thuộc CBCLOUDV2-9260.

## 17. Sai lệch khi triển khai

- Người dùng xác nhận ngày 2026-09-08: bỏ qua Gate 1 và triển khai trực tiếp.
- Nhánh được yêu cầu ghi là `manh/dev_2`, nhưng repo chỉ có `manh/dev_v2`; tiếp tục trên nhánh hiện có `manh/dev_v2` theo ngữ cảnh đã thống nhất trước đó.

## 18. Phê duyệt Gate 1

- DEV self-review: <tên, ngày, commit/PR>
- TechLead approval: <tên, ngày, commit/PR>
- Ngoại lệ: user bypass Gate 1 ngày 2026-09-08; không tự điền hai chữ ký approval.
