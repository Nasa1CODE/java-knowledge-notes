---
feature: CBCLOUDV2-9403
title: Bỏ trường Chất lượng tài sản trên API Hàng hóa đặc trưng 1
plan-status: implemented
service: api-cloud-service
service-repo: ../api-cloud-service
services-affected: [api-cloud-service]
owner: DEV + AI
created_at: 2026-09-08
updated_at: 2026-09-08
---

# Plan - CBCLOUDV2-9403

## 1. Mục tiêu

Bỏ `chatluongtaisan` khỏi request API Hàng hóa đặc trưng loại 1, bỏ validation/mapping vào `cltsan` và không sinh `CLTSan` trong XML cho cả dữ liệu mới lẫn lịch sử. Entity, cột DB và dữ liệu vật lý vẫn giữ nguyên.

## 2. Căn cứ và trạng thái source

- `api-cloud-service`, nhánh hiện tại `manh/dev_v2`.
- Worktree có sẵn thư mục untracked `test/WS.Application.Tests/` từ task trước; không được xóa hoặc ghi đè ngoài các test liên quan.
- `GuiHoaDonAppService.cs` có ba overload validate/map cho `ChiTietHDG`, `ChiTietTT`, `ChiTietDC`, hội tụ về hai shared method.
- Ba DTO khai báo `chatluongtaisan` kèm `NullableDecimalVehicleAssetJsonConverter`.
- `HoaDonTT3278Utility.HasHangHoaDacTrungXeMoi(...)` hiện tính `cltsan.HasValue` và `GetTHHDTrung(...)` sinh `ConstantTTin.CLTSan` trong block chỉ dành cho `Loai_HangHoa_Dac_Trung == 1`.
- `ConstantTTin.CLTSan` chỉ được tham chiếu tại dòng render trên, nên có thể xóa sau khi bỏ XML field.

## 3. Gate nghiệp vụ giữ nguyên

Validation/map subtype 1 chỉ chạy khi:

```csharp
IsNghiDinhMoi(version) && item.loaihoadondactrung == 1
```

Trong đó `IsNghiDinhMoi(version)` yêu cầu `version.Trim() == "1"`. Không thêm `loaihanghoa == 4` vì API không có gate này.

## 4. Danh sách API

- Lưu trực tiếp: `GuiHoaDonGoc`, `GuiHoaDonThayThe`, `GuiHoaDonDieuChinh`.
- Kế thừa qua API lưu: `GuiVaKyHoadonGocHSM`, `GuiVaKyHoaDonThayTheHSM`, `GuiVaKyHoaDonDieuChinhHSM`, `GuiHoaDonVaKyMTT`, `GuiHoaDonVaKyMTT_V2`.
- XML chịu thay đổi input/output: `GuiHoaDonGocXML`, `GuiHoaDonThayTheXML`, `GuiHoaDonDieuChinhXML` và XML phát sinh từ ba API lưu/wrapper.

## 5. Cách làm step by step

### Step 1 - Khóa repo và bảo vệ thay đổi sẵn có

1. Xác nhận nhánh triển khai với DEV trước khi code theo branch rule.
2. Chụp `git status --short` và `git diff --stat`.
3. Không restore thư mục test untracked của CBCLOUDV2-9379/CBCLOUDV2-9385; đọc và mở rộng test theo pattern hiện có.

### Step 2 - Bỏ field khỏi ba DTO request

Sửa:

- `src/hddt/WS.Application/DataTransferObjects/GuiHoaDon/GuiHDGoc.cs`: `ChiTietHDG`.
- `src/hddt/WS.Application/DataTransferObjects/GuiHoaDon/GuiHoaDonTT.cs`: `ChiTietTT`.
- `src/hddt/WS.Application/DataTransferObjects/GuiHoaDon/GuiHoaDonDC.cs`: `ChiTietDC`.

Trong mỗi DTO:

1. Xóa property `decimal? chatluongtaisan`.
2. Xóa attribute `[JsonConverter(typeof(NullableDecimalVehicleAssetJsonConverter))]` gắn riêng với property đó.
3. Không xóa converter vì các numeric field đặc trưng khác vẫn có thể dùng.
4. Kiểm tra Swagger/metadata không còn property này trong ba request model.

### Step 3 - Bỏ validation Chất lượng tài sản

File: `src/hddt/WS.Application/AppServices/HoaDon/GuiHoaDonAppService.cs`.

1. Bỏ `item.chatluongtaisan` khỏi ba overload `ValidateHangHoaDacTrungXe(...)`.
2. Bỏ tham số `decimal? chatLuongTaiSan` khỏi `ValidateHangHoaDacTrungXeValues(...)`.
3. Xóa ba nhánh validation:
   - sentinel `decimal.MinValue` / sai kiểu;
   - bắt buộc khi `tinhTrangTaiSan == 1`;
   - precision `decimal(4,2)`.
4. Giữ nguyên required `sobienkiemsoat` khi xe đã qua sử dụng và toàn bộ rule field khác.

### Step 4 - Bỏ mapping/lưu giá trị mới

Cũng trong `GuiHoaDonAppService.cs`:

1. Bỏ `item.chatluongtaisan` khỏi ba overload `MapHangHoaDacTrungXe(...)`.
2. Bỏ tham số `chatLuongTaiSan` khỏi `MapHangHoaDacTrungXeValues(...)`.
3. Xóa assignment `mr.cltsan = chatLuongTaiSan`.
4. Giữ map `mr.sbksoat` và các field khác nguyên trạng.
5. Không gán `cltsan = null` trên entity dùng chung ngoài create flow; chỉ để giá trị mặc định null cho bản ghi mới.

### Step 5 - Bỏ `CLTSan` khỏi XML và giữ dữ liệu DB

Sửa `src/hddt/WS.Application/Commons/HoaDon/HoaDonTT3278Utility.cs`:

1. Bỏ `hdmr.cltsan.HasValue` khỏi `HasHangHoaDacTrungXeMoi(...)`.
2. Bỏ lệnh `AddTTinDacTrung(... ConstantTTin.CLTSan, hdmr.cltsan)` khỏi block subtype 1 trong `GetTHHDTrung(...)`.
3. Giữ điều kiện `hdmr.Loai_HangHoa_Dac_Trung == 1` và các field XML đặc trưng còn lại.

Sửa `src/hddt/WS.Application/Commons/HoaDon/XmlHoaDonTT78/ThongTinKhac/TTin.cs`:

4. Xóa `ConstantTTin.CLTSan` sau khi `rg` xác nhận không còn call-site.

Không sửa:

- `WS.Core/Domains/HoaDon/QuanLyHoaDon/HD_ChiTiet_MoRong.cs` property `cltsan`.
- Repository/table tenant `vs_hd_chitiet_morong.cltsan`.
- DTO/response đọc hóa đơn ngoài ba request detail nếu có.
- Dữ liệu `cltsan` đã lưu; giá trị này chỉ không còn được render ra XML.

### Step 6 - Automated test

Thêm test dưới `test/WS.Application.Tests/HoaDon/`:

1. Reflection/source contract: ba DTO không còn property `chatluongtaisan`.
2. Shared validator: subtype 1, xe cũ thiếu quality không có message quality.
3. Xe cũ thiếu biển số vẫn báo lỗi.
4. Negative gate subtype null/2/3 không chạy rule.
5. Shared mapper: bản ghi mới không gán `cltsan`, biển số và các field khác vẫn map.
6. JSON compatibility: payload có property dư `chatluongtaisan` deserialize không lỗi và property bị bỏ qua.
7. XML subtype 1 không chứa `CLTSan` khi `cltsan` null hoặc có giá trị lịch sử; các field đặc trưng khác vẫn xuất đúng.
8. Regression các test maxlength/required hiện có bằng cách cập nhật signature reflection sau khi bỏ tham số.

### Step 7 - Build và kiểm thử API

1. Chạy unit test project với output tối giản.
2. Build `WS.Application.csproj`.
3. Gọi ba API lưu với subtype 1: không gửi field, gửi field dư và thiếu biển số.
4. Regression ba HSM, hai MTT và ba XML trên tenant test; request lỗi phải dừng trước side effect và XML output không có `CLTSan`.
5. Query tenant test xác nhận bản ghi mới `cltsan IS NULL`, `sbksoat` đúng.

### Step 8 - Docs và bàn giao

1. Cập nhật `tasks.md`, `testcase.md`, `impact.md` từ bằng chứng thật.
2. Tạo `report.md`; không đánh dấu API/manual/DB pass nếu chưa chạy.
3. Đề xuất cập nhật `specs/system.md` qua Gate 2 vì request contract thay đổi.
4. Cập nhật báo cáo token `D:\XBill\Cloud\Token\CBCLOUDV2-9403.md`.

## 6. File dự kiến thay đổi

| File | Nội dung |
|---|---|
| `src/hddt/WS.Application/DataTransferObjects/GuiHoaDon/GuiHDGoc.cs` | Bỏ field khỏi `ChiTietHDG` |
| `src/hddt/WS.Application/DataTransferObjects/GuiHoaDon/GuiHoaDonTT.cs` | Bỏ field khỏi `ChiTietTT` |
| `src/hddt/WS.Application/DataTransferObjects/GuiHoaDon/GuiHoaDonDC.cs` | Bỏ field khỏi `ChiTietDC` |
| `src/hddt/WS.Application/AppServices/HoaDon/GuiHoaDonAppService.cs` | Bỏ tham số, validation và mapping |
| `src/hddt/WS.Application/Commons/HoaDon/HoaDonTT3278Utility.cs` | Bỏ nhận diện và render `CLTSan` |
| `src/hddt/WS.Application/Commons/HoaDon/XmlHoaDonTT78/ThongTinKhac/TTin.cs` | Bỏ constant `CLTSan` không còn dùng |
| `test/WS.Application.Tests/HoaDon/*VehicleAsset*Tests.cs` | Test contract/validator/mapper/regression |

## 7. Thay đổi contract, DB và tích hợp

| Hạng mục | Kết luận |
|---|---|
| Request DTO/Swagger | Có: bỏ `chatluongtaisan` khỏi ba detail model |
| Route/response | Không đổi |
| JSON client cũ | Dự kiến tương thích: property dư bị bỏ qua; phải có test |
| XML input/output | Bỏ field input; output subtype 1 không còn `CLTSan`, kể cả dữ liệu lịch sử |
| Entity/DB/schema | Không đổi, không migration |
| Queue/config/dependency | Không đổi |
| Multi-tenant/auth | Không đổi; verify trên tenant test |
| Frontend/NSwag nội bộ | Không sửa trong task; chỉ regenerate client nếu consumer thực sự sử dụng ba model này và TechLead yêu cầu |

## 8. Kế hoạch kiểm chứng

| # | Command/kiểm tra | Kỳ vọng |
|---|---|---|
| 1 | `rg -n "chatluongtaisan|chatLuongTaiSan|CLTSan" <các file sửa>` | Không còn trong request DTO, validator/mapper và XML renderer/constants; `cltsan` chỉ còn domain/DB/response ngoài scope |
| 2 | `dotnet test test/WS.Application.Tests/WS.Application.Tests.csproj --no-restore --verbosity minimal` | Test mới và regression pass, 0 failed |
| 3 | `dotnet build src/hddt/WS.Application/WS.Application.csproj --no-restore --verbosity minimal` | Build thành công, 0 error |
| 4 | Postman/Newman ba API lưu | Không message quality; `cltsan` null, biển số đúng |
| 5 | Manual HSM/MTT | Kế thừa validation; lỗi khác dừng trước side effect |
| 6 | Manual ba API XML và XML output | Payload mới/cũ deserialize đúng; XML không chứa `CLTSan` |
| 7 | Query tenant test | Bản ghi mới `cltsan IS NULL`; dữ liệu cũ trong DB không đổi nhưng XML không xuất field |
| 8 | `git diff --check` và diff scoped | Không whitespace error, không sửa ngoài phạm vi |

## 9. Rủi ro và rollback

| Rủi ro | Mức | Giảm thiểu / rollback |
|---|---|---|
| Xóa field khỏi Swagger làm generated client thay đổi | Cao | Gate 1 xác nhận contract; kiểm consumer trước release; rollback ba DTO |
| XML cũ còn node quality deserialize khác JSON | Cao | Test đủ ba wrapper XML với payload cũ trước release |
| Chỉ bỏ required nhưng vẫn lưu quality | Cao | Bỏ cả mapping và assert DB `cltsan` null |
| Bỏ XML nhầm ngoài subtype 1 | Cao | Source test khóa call-site chỉ trong block loại 1; regression loại 2/3 |
| Reflection tests cũ lỗi do đổi signature | Trung bình | Cập nhật fixture đúng tham số mới, giữ các assertion field khác |
| Side effect HSM/MTT xảy ra trước khi phát hiện lỗi khác | Cao | Manual request lỗi và xác nhận không ký/cấp số/gửi TCT |

Rollback bằng cách khôi phục ba property DTO, tham số shared validator/mapper, ba nhánh validation, assignment `mr.cltsan`, dòng render XML và constant `CLTSan`; không rollback DB.

## 10. Phương án khác đã xem xét

- Chỉ bỏ required nhưng vẫn nhận/map field: không đáp ứng “Bỏ trường”.
- Giữ DTO và bỏ mapping: tương thích contract tốt hơn nhưng Swagger vẫn công bố field đã bị loại bỏ.
- Xóa entity/cột DB `cltsan`: loại vì không cần migration; yêu cầu chỉ bỏ field khỏi API và XML.

## 11. Đề xuất cập nhật docs Gate 2

Đề xuất cập nhật `specs/system.md`: request API và XML Hàng hóa đặc trưng loại 1 không còn `chatluongtaisan/CLTSan`; entity/cột DB được giữ để không migration. Chỉ merge sau TechLead approval.

## 12. Sai lệch khi triển khai

- Ngày 2026-09-08, người dùng xác nhận bỏ qua Gate 1 và triển khai trên nhánh hiện tại `manh/dev_v2`.
- Worktree có sẵn `test/WS.Application.Tests/` untracked từ các task trước; giữ nguyên và chỉ cập nhật test liên quan theo phạm vi.

## 13. Phê duyệt Gate 1

- DEV self-review: `<tên> - <ngày> - <commit/PR>`
- TechLead approval: `<tên> - <ngày> - <commit/PR>`
- Trạng thái: user đã yêu cầu bỏ qua Gate 1 ngày 2026-09-08; AI không tự điền DEV/TechLead approval.
