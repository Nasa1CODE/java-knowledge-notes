---
feature: CBCLOUDV2-9367
title: "[API] Bổ sung Tên tỉnh, tên xã - Hàng hóa đặc trưng 1"
plan-status: plan-review
service: api-cloud-service
service-repo: ./api-cloud-service
services-affected: [api-cloud-service]
owner: AI + DEV
created_at: 2026-09-10
updated_at: 2026-09-10
---

# Plan — CBCLOUDV2-9367: [API] Bổ sung Tên tỉnh, tên xã - Hàng hóa đặc trưng 1

## 1. Blocking Questions
None.

## 2. Approach Summary
Task này chỉ sửa API trong `D:\XBill\Cloud\api-cloud-service`. Mục tiêu là API hóa đơn nhận, validate, lưu, trả và sinh XML cho 2 field tên địa bàn người mua thuộc Hàng hóa đặc trưng 1: `ten_tinh` -> `<TTinh>` tối đa 50 ký tự, `ten_xa` -> `<TXa>` tối đa 50 ký tự. Không sửa FE, không sửa import Excel trong task này.

## 3. Requirement Trace
| AC trong expect.md | Covered by section |
|---|---|
| AC-1 | §5.1 |
| AC-2 | §5.2 |
| AC-3 | §5.3 |
| AC-4 | §9 |
| AC-5 | §10 |

## 4. Affected Services
| Service | Severity | Main change |
|---|---|---|
| api-cloud-service | Medium | API contract, entity mapping, save/get logic and TT78/TT32 XML buyer location fields |

## 4.1 API Scope Đối Chiếu Theo Task Cũ
Các task API cũ cùng nghiệp vụ Hàng hóa đặc trưng 1 (`CBCLOUDV2-9167`, `CBCLOUDV2-9379`, `CBCLOUDV2-9385`, `CBCLOUDV2-9397`, `CBCLOUDV2-9403`) đều áp dụng cùng call chain trong `api-cloud-service`. Vì vậy task này phải rà/sửa đúng các API sau:

### 4.1.1 API lưu cần sửa trực tiếp
| # | Endpoint | Method | Input | Cần sửa trong task này |
|---|---|---|---|---|
| 1 | `POST /api/services/hddtws/GuiHoaDon/SendInvoice` | `SendInvoice` | `GuiHDGoc` | Nhận/validate max 50/map/lưu `ten_tinh`, `ten_xa` qua luồng gốc |
| 2 | `POST /api/services/hddtws/GuiHoaDon/GuiHoaDonGoc` | `GuiHoaDonGoc` | `GuiHDGoc` | Nhận/validate max 50/map/lưu `ten_tinh`, `ten_xa` |
| 3 | `POST /api/services/hddtws/GuiHoaDon/GuiHoaDonThayThe` | `GuiHoaDonThayThe` | `GuiHoaDonTT` | Nhận/validate max 50/map/lưu `ten_tinh`, `ten_xa` |
| 4 | `POST /api/services/hddtws/GuiHoaDon/GuiHoaDonDieuChinh` | `GuiHoaDonDieuChinh` | `GuiHoaDonDC` | Nhận/validate max 50/map/lưu `ten_tinh`, `ten_xa` |

### 4.1.2 API wrapper kế thừa, không sửa duplicate logic
| # | Endpoint | Method | Gọi lại | Cách xử lý |
|---|---|---|---|---|
| 5 | `POST /api/services/hddtws/GuiHoaDon/GuiVaKyHoadonGocHSM` | `GuiVaKyHoadonGocHSM` | `GuiHoaDonGoc` | Regression, không map riêng |
| 6 | `POST /api/services/hddtws/GuiHoaDon/GuiVaKyHoaDonThayTheHSM` | `GuiVaKyHoaDonThayTheHSM` | `GuiHoaDonThayThe` | Regression, không map riêng |
| 7 | `POST /api/services/hddtws/GuiHoaDon/GuiVaKyHoaDonDieuChinhHSM` | `GuiVaKyHoaDonDieuChinhHSM` | `GuiHoaDonDieuChinh` | Regression, không map riêng |
| 8 | `POST /api/services/hddtws/GuiHoaDon/GuiVaKyHoaDonGocToken` | `GuiVaKyHoaDonGocToken` | `GuiHoaDonGoc` | Regression, không map riêng |
| 9 | `POST /api/services/hddtws/GuiHoaDon/GuiVaKyHoaDonThayTheToken` | `GuiVaKyHoaDonThayTheToken` | `GuiHoaDonThayThe` | Regression, không map riêng |
| 10 | `POST /api/services/hddtws/GuiHoaDon/GuiVaKyHoaDonDieuChinhToken` | `GuiVaKyHoaDonDieuChinhToken` | `GuiHoaDonDieuChinh` | Regression, không map riêng |
| 11 | `POST /api/services/hddtws/GuiHoaDon/GuiHoaDonVaKyMTT` | `GuiHoaDonVaKyMTT` | `GuiHoaDonGoc` | Regression, không map riêng |
| 12 | `POST /api/services/hddtws/GuiHoaDon/GuiHoaDonVaKyMTT_V2` | `GuiHoaDonVaKyMTT_V2` | `GuiHoaDonGoc` | Regression, không map riêng |

### 4.1.3 API XML regression
| # | Endpoint | Method | Gọi lại | Cách xử lý |
|---|---|---|---|---|
| 13 | `POST /api/services/hddtws/GuiHoaDon/GuiHoaDonGocXML` | `GuiHoaDonGocXML` | `GuiHoaDonGoc` | Bổ sung field DTO/XML nếu XML input cần deserialize; regression output XML |
| 14 | `POST /api/services/hddtws/GuiHoaDon/GuiHoaDonThayTheXML` | `GuiHoaDonThayTheXML` | `GuiHoaDonThayThe` | Bổ sung field DTO/XML nếu XML input cần deserialize; regression output XML |
| 15 | `POST /api/services/hddtws/GuiHoaDon/GuiHoaDonDieuChinhXML` | `GuiHoaDonDieuChinhXML` | `GuiHoaDonDieuChinh` | Bổ sung field DTO/XML nếu XML input cần deserialize; regression output XML |

### 4.1.4 Kết luận phạm vi sửa
- Code sửa trực tiếp ở DTO/input, entity mở rộng, mapper/save logic và XML utility dùng chung, nhưng chỉ được kích hoạt khi `IsActiveND254()` và hóa đơn có ít nhất một dòng `dschitiet[].loaihoadondactrung == 1`.
- Không viết logic riêng trong HSM/Token/MTT wrapper vì các task cũ đều xác định wrapper gọi lại API lưu.
- Ba API XML phải có testcase regression vì deserialize request rồi gọi lại API lưu và XML output dùng cùng utility.
## 5. Detailed Design
### 5.1 API input nhận Tên tỉnh, Tên xã
- Sửa DTO input hóa đơn trong `src/hddt/WS.Application/DataTransferObjects/GuiHoaDon/`:
  - `GuiHDGoc.cs`
  - `GuiHoaDonTT.cs`
  - `GuiHoaDonDC.cs`
- Bổ sung optional fields theo naming hiện tại của API: `ten_tinh`, `ten_xa`. Cả 2 field là chuỗi ký tự tối đa 50 ký tự theo XML `TTinh/TXa`.
- Các API cần nhận field mới qua cùng DTO:
  - `GuiHoaDonAppService.GuiHoaDonGoc`
  - `GuiHoaDonAppService.SendInvoice`
  - `GuiHoaDonAppService.GuiHoaDonThayThe`
  - `GuiHoaDonAppService.GuiHoaDonDieuChinh`
  - Các wrapper ký/gửi dùng lại các method trên: `GuiVaKyHoadonGocHSM`, `GuiVaKyHoaDonThayTheHSM`, `GuiVaKyHoaDonDieuChinhHSM`, `GuiVaKyHoaDonGocToken`, `GuiVaKyHoaDonThayTheToken`, `GuiVaKyHoaDonDieuChinhToken`, `GuiHoaDonVaKyMTT`, `GuiHoaDonVaKyMTT_V2`.

### 5.2 Lưu DB trong bảng mở rộng
- Sửa entity `src/hddt/WS.Core/Domains/HoaDon/QuanLyHoaDon/HD_HoaDon_MoRong.cs`:
  - thêm `public string ten_tinh { get; set; }`
  - thêm `public string ten_xa { get; set; }`
  - validate API trước khi lưu: `ten_tinh` tối đa 50 ký tự, `ten_xa` tối đa 50 ký tự
- DB tenant: bảng `vs_hd_tonghop_morong` cần có cột nullable đủ lưu `ten_tinh`, `ten_xa`; rule API/XML chỉ cho tối đa 50 ký tự cho mỗi field.
- Sửa `src/hddt/WS.Application/AppServices/HoaDon/GuiHoaDonAppService.cs`:
  - đổi helper `MapDiaBanDacTrung(HD_HoaDon hoaDon, string maTinh, string maXa)` thành nhận thêm `tenTinh`, `tenXa`.
  - map đủ `ma_tinh`, `ma_xa`, `ten_tinh`, `ten_xa` vào `HD_HoaDon_MoRong`.
  - cập nhật toàn bộ call hiện có quanh các luồng gốc/thay thế/điều chỉnh.
- Đảm bảo điều kiện tạo/lưu `HD_HoaDon_MoRong` chỉ xét `ten_tinh` hoặc `ten_xa` khi `ACTIVE_ND_254 = "1"` và có dòng `dschitiet[].loaihoadondactrung == 1`. Không tạo/lưu bản ghi mở rộng chỉ vì hóa đơn thường hoặc loại 2/3 gửi dư `ten_tinh`, `ten_xa`.

### 5.3 API output và XML
- Rà các projection/get detail/list trong `GuiHoaDonAppService.cs`, `GuiHoaDonV2AppService.cs`, repository liên quan nếu có mapping thủ công từ `HD_HoaDon_MoRong`.
- Với XML, chỉ render `TTinh/TXa` trong nhánh XML Hàng hóa đặc trưng 1/schema mới; không render cho hóa đơn thường hoặc đặc trưng loại 2/3.
- Sửa model XML buyer node `src/hddt/WS.Application/Commons/HoaDon/XmlHoaDonTT78/DuLieuHoaDon/NoiDungHoaDon/NMua.cs`:
  - thêm `[XmlElement(ElementName = "TTinh")] public string TTinh { get; set; }`
  - thêm `[XmlElement(ElementName = "TXa")] public string TXa { get; set; }`
- Sửa `src/hddt/WS.Application/Commons/HoaDon/HoaDonTT3278Utility.cs`:
  - `HD_HoaDon_MoRong.ten_tinh -> nMua.TTinh`
  - `HD_HoaDon_MoRong.ten_xa -> nMua.TXa`
  - giữ nguyên mapping hiện có `ma_tinh -> MTinh`, `ma_xa -> MXa`.

## 6. Implementation Order
1. Check `git -C D:\XBill\Cloud\api-cloud-service status --short --branch`.
2. Sửa DTO input: `GuiHDGoc.cs`, `GuiHoaDonTT.cs`, `GuiHoaDonDC.cs`.
3. Sửa entity `HD_HoaDon_MoRong.cs`.
4. Sửa `GuiHoaDonAppService.MapDiaBanDacTrung` và các call site.
5. Rà save/update/get để không mất dữ liệu mở rộng.
6. Sửa XML model `NMua.cs` và mapping trong `HoaDonTT3278Utility.cs`.
7. Build `D:\XBill\Cloud\api-cloud-service\VS.WS.sln` hoặc `WS.Application.csproj`.
8. Cập nhật `report.md` bằng diff và output build thật.

## 7. Database Changes
Không tạo EF migration trong source nếu repo không dùng migration cho tenant DB. Deploy SQL cần đảm bảo:
```sql
ALTER TABLE `vs_hd_tonghop_morong`
ADD COLUMN `ten_tinh` varchar(50) NULL,
ADD COLUMN `ten_xa` varchar(50) NULL;
```
Nếu DB đã có cột thì bỏ qua script này.

## 8. Configuration Changes
None.

## 9. External And Inter-Service Integrations
- REST/ABP API contract có thêm field optional, backward compatible với client cũ.
- XML hóa đơn thêm `TTinh/TXa` khi có dữ liệu; cần regression với payload có và không có field.
- Không sửa FE, không sửa import, không sửa service nền trong task API này.

## 10. Backward Compatibility
Client cũ không gửi `ten_tinh/ten_xa` vẫn chạy như cũ. Validate địa bàn vẫn dựa trên `ma_tinh/ma_xa`; `ten_tinh/ten_xa` chỉ là dữ liệu tên lưu/trả/XML, không thay thế mã.

## 11. Verification Plan
- Build: `dotnet build D:\XBill\Cloud\api-cloud-service\VS.WS.sln --no-restore --verbosity quiet` → kỳ vọng 0 error.
- API manual: gửi hóa đơn gốc/thay thế/điều chỉnh có `ma_tinh`, `ten_tinh`, `ma_xa`, `ten_xa`; test thêm boundary `ten_tinh/ten_xa` 50 pass và 51 fail; kiểm tra `vs_hd_tonghop_morong` lưu đủ.
- API regression: payload không có 2 field mới vẫn tạo hóa đơn bình thường.
- Negative gate: `ACTIVE_ND_254` tắt/thiếu/lỗi, hoặc chỉ có `loaihoadondactrung = 2/3`, hoặc không có dòng đặc trưng 1 thì không lưu/render `ten_tinh`, `ten_xa` theo rule mới.
- XML regression: XML có `MTinh/MXa/TTinh/TXa` khi payload có dữ liệu; không lỗi khi rỗng.

## 12. Risks And Rollback
| Risk | Severity | Mitigation / rollback |
|---|---|---|
| Bỏ sót wrapper API ký/gửi | Medium | Vì wrapper dùng lại `GuiHoaDonGoc/TT/DC`, chỉ cần ensure DTO và method chính map đủ |
| DB môi trường chưa có cột | High | Deploy SQL nullable trước code |
| XML tag không đúng chuẩn hoặc vượt maxlength 50 | Medium | Test XML có/không có field và boundary 50/51 ký tự |

## 13. Alternatives Considered
- Gộp với quốc tịch: loại, vì quốc tịch đã tách sang CBCLOUDV2-9373.

## 14. Assumptions
- Scope chỉ API, không sửa FE/import.
- Field name input giữ style hiện có: lower snake-ish `ten_tinh`, `ten_xa`.

## 15. Open Questions
None.

## 16. Proposed Docs Updates (Gate 2)
- DB tenant docs: cập nhật `vs_hd_tonghop_morong.ten_tinh`, `vs_hd_tonghop_morong.ten_xa` nếu chưa có.
- API/XML docs: ghi nhận `TTinh/TXa` trong buyer node khi có dữ liệu.

## 17. Deviations Found During Implementation
None yet.

## 18. Approval (Gate 1)
Pending review.




