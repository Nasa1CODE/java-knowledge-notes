---
feature: CBCLOUDV2-9373
title: "[API] Bổ sung Mã quốc tịch, Quốc tịch"
plan-status: plan-review
service: api-cloud-service
service-repo: ./api-cloud-service
services-affected: [api-cloud-service]
owner: AI + DEV
created_at: 2026-09-10
updated_at: 2026-09-10
---

# Plan — CBCLOUDV2-9373: [API] Bổ sung Mã quốc tịch, Quốc tịch

## 1. Blocking Questions
None.

## 2. Approach Summary
Ticket này chỉ làm API trong `D:\XBill\Cloud\api-cloud-service`. Bổ sung dữ liệu quốc tịch người mua cho API hóa đơn và XML: `Quốc tịch` map `<QTNMua>` tối đa 50 ký tự; `Mã quốc tịch` map `<MQTNMua>` tối đa 2 ký tự. Rule quốc tịch áp dụng khi `ACTIVE_ND_254 = "1"`, không phụ thuộc Hàng hóa đặc trưng 1 và không phụ thuộc request `version`. FE dropdown/search/disable nằm ngoài scope code của ticket này, nhưng API cần có dữ liệu/danh mục để FE dùng.

## 3. Requirement Trace
| AC trong expect.md | Covered by section |
|---|---|
| AC-1 | §5.1 |
| AC-2 | §5.2 |
| AC-3 | §5.3 |
| AC-4 | §5.4 |
| AC-5 | §10 |
| AC-6 | §11 |

## 4. Affected Services
| Service | Severity | Main change |
|---|---|---|
| api-cloud-service | Medium | API contract, validation, entity mapping, XML mapping and nationality catalog endpoint |

## 4.1 API Scope Đối Chiếu Theo Task Cũ
Các task API cũ cùng nhóm hóa đơn (`CBCLOUDV2-9167`, `CBCLOUDV2-9379`, `CBCLOUDV2-9385`, `CBCLOUDV2-9397`, `CBCLOUDV2-9403`) cho thấy cùng call chain trong `api-cloud-service`. Riêng quốc tịch của `CBCLOUDV2-9373` áp dụng theo `ACTIVE_ND_254`, không phụ thuộc Hàng hóa đặc trưng 1. Vì vậy task này phải rà/sửa đúng các API sau:

### 4.1.1 API lưu cần sửa trực tiếp
| # | Endpoint | Method | Input | Cần sửa trong task này |
|---|---|---|---|---|
| 1 | `POST /api/services/hddtws/GuiHoaDon/SendInvoice` | `SendInvoice` | `GuiHDGoc` | Nhận/map/lưu `quoc_tich_nguoi_mua`, `ma_quoc_tich_nguoi_mua` qua luồng gốc |
| 2 | `POST /api/services/hddtws/GuiHoaDon/GuiHoaDonGoc` | `GuiHoaDonGoc` | `GuiHDGoc` | Nhận/map/lưu/validate maxlength quốc tịch |
| 3 | `POST /api/services/hddtws/GuiHoaDon/GuiHoaDonThayThe` | `GuiHoaDonThayThe` | `GuiHoaDonTT` | Nhận/map/lưu/validate maxlength quốc tịch |
| 4 | `POST /api/services/hddtws/GuiHoaDon/GuiHoaDonDieuChinh` | `GuiHoaDonDieuChinh` | `GuiHoaDonDC` | Nhận/map/lưu/validate maxlength quốc tịch |

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
| 13 | `POST /api/services/hddtws/GuiHoaDon/GuiHoaDonGocXML` | `GuiHoaDonGocXML` | `GuiHoaDonGoc` | Bổ sung field DTO/XML nếu XML input cần deserialize; regression output XML `QTNMua/MQTNMua` |
| 14 | `POST /api/services/hddtws/GuiHoaDon/GuiHoaDonThayTheXML` | `GuiHoaDonThayTheXML` | `GuiHoaDonThayThe` | Bổ sung field DTO/XML nếu XML input cần deserialize; regression output XML `QTNMua/MQTNMua` |
| 15 | `POST /api/services/hddtws/GuiHoaDon/GuiHoaDonDieuChinhXML` | `GuiHoaDonDieuChinhXML` | `GuiHoaDonDieuChinh` | Bổ sung field DTO/XML nếu XML input cần deserialize; regression output XML `QTNMua/MQTNMua` |

### 4.1.4 API danh mục cần bổ sung
| # | Endpoint | Method | Input/Output | Cần sửa trong task này |
|---|---|---|---|---|
| 16 | `GET/POST /api/services/hddtws/DM_NCC_QuocTich/GetAllNoPage` | `GetAllNoPage` | `ListResultDto<DMNCCQuocTichDto>` | Tạo AppService/DTO/domain/DbSet theo pattern danh mục để FE ticket khác lấy dropdown quốc tịch |

### 4.1.5 Kết luận phạm vi sửa
- Code sửa trực tiếp ở DTO/input, entity mở rộng, mapper/save logic, validation maxlength, XML utility và API danh mục quốc tịch.
- Không viết logic riêng trong HSM/Token/MTT wrapper vì các task cũ đều xác định wrapper gọi lại API lưu.
- Ba API XML phải có testcase regression vì deserialize request rồi gọi lại API lưu và XML output dùng cùng utility.
- `quoc_tich_nguoi_mua` và `ma_quoc_tich_nguoi_mua` được gate theo `IsActiveND254()`, không phụ thuộc `loaihoadondactrung == 1`; request `version` không điều khiển rule này.
## 5. Detailed Design
### 5.1 API input nhận quốc tịch người mua
- Sửa DTO input hóa đơn trong `src/hddt/WS.Application/DataTransferObjects/GuiHoaDon/`:
  - `GuiHDGoc.cs`
  - `GuiHoaDonTT.cs`
  - `GuiHoaDonDC.cs`
- Bổ sung optional fields theo style API hiện có:
  - `quoc_tich_nguoi_mua` tương ứng XML `<QTNMua>`, maxlength 50.
  - `ma_quoc_tich_nguoi_mua` tương ứng XML `<MQTNMua>`, maxlength 2.
- Các API cần nhận field mới qua cùng DTO:
  - `GuiHoaDonAppService.GuiHoaDonGoc`
  - `GuiHoaDonAppService.SendInvoice`
  - `GuiHoaDonAppService.GuiHoaDonThayThe`
  - `GuiHoaDonAppService.GuiHoaDonDieuChinh`
  - Các wrapper ký/gửi HSM, token, MTT dùng lại các method trên.

### 5.2 Lưu DB trong bảng mở rộng
- Sửa entity `src/hddt/WS.Core/Domains/HoaDon/QuanLyHoaDon/HD_HoaDon_MoRong.cs`:
  - thêm `public string ma_quoc_tich_nguoi_mua { get; set; }` hoặc property có `[Column("ma_quoc_tich_nguoi_mua")]` theo convention EF hiện tại.
  - thêm `public string quoc_tich_nguoi_mua { get; set; }` hoặc property có `[Column("quoc_tich_nguoi_mua")]`.
- DB tenant: bảng `vs_hd_tonghop_morong` cần cột nullable `ma_quoc_tich_nguoi_mua`, `quoc_tich_nguoi_mua`.
- Sửa `src/hddt/WS.Application/AppServices/HoaDon/GuiHoaDonAppService.cs`:
  - map 2 field vào `HD_HoaDon_MoRong` ở luồng hóa đơn gốc/thay thế/điều chỉnh khi `IsActiveND254()` true.
  - đảm bảo điều kiện tạo/lưu `HD_HoaDon_MoRong` không bỏ qua bản ghi khi NĐ254 bật và payload chỉ có quốc tịch. Khi NĐ254 tắt/thiếu/lỗi thì không xử lý quốc tịch theo task này.

### 5.3 Validate maxlength API
- Validate trước khi lưu trong `GuiHoaDonAppService` theo pattern hiện có:
  - `ma_quoc_tich_nguoi_mua`: tối đa 2 ký tự.
  - `quoc_tich_nguoi_mua`: tối đa 50 ký tự.
- Field không bắt buộc; payload rỗng/null vẫn hợp lệ.
- Không gắn điều kiện `loaihoadondactrung == 1` cho 2 field này. Chỉ validate/map/lưu/render XML khi `IsActiveND254()` true; request `version` được bỏ qua.


### 5.3.1 Validate tồn tại Mã quốc tịch
- Chỉ chạy khi `IsActiveND254()` true.
- Field không bắt buộc: nếu `ma_quoc_tich_nguoi_mua` null/rỗng/whitespace thì bỏ qua validate tồn tại.
- Nếu có `ma_quoc_tich_nguoi_mua`, normalize bằng `Trim()`, giữ nguyên leading zero/ký tự mã, không parse số.
- Check mã tồn tại trong danh mục quốc tịch dùng cùng nguồn dữ liệu với API `DM_NCC_QuocTich/GetAllNoPage`.
- Nếu mã không tồn tại hoặc đã bị xóa/ngừng hiệu lực theo rule danh mục thì trả message: `Mã quốc tịch không tồn tại.`
- `quoc_tich_nguoi_mua` là tên hiển thị, chỉ validate maxlength 50; không dùng tên để thay thế mã khi check tồn tại.
- Không gắn điều kiện `loaihoadondactrung == 1`; khi NĐ254 bật, hóa đơn loại khác vẫn check mã quốc tịch nếu có gửi.

### 5.3.2 Validate tồn tại Mã nước sản xuất
- Field API: `dschitiet[].ma_nuocsx`.
- XML tag tương ứng: `<MNSXuat>`.
- DB/entity tương ứng: `HD_ChiTiet_MoRong.mnsxuat`, bảng `vs_hd_chitiet_morong.mnsxuat`.
- Rule này vẫn thuộc Hàng hóa đặc trưng 1, nên chỉ chạy khi:
  - `IsActiveND254()` true.
  - Dòng chi tiết hiện tại có `loaihoadondactrung == 1`.
- `ma_nuocsx` đang là field bắt buộc của Hàng hóa đặc trưng 1; sau required và maxlength, phải check mã tồn tại trong danh mục quốc tịch/quốc gia dùng cùng nguồn với API `DM_NCC_QuocTich/GetAllNoPage`.
- Normalize bằng `Trim()`, giữ nguyên leading zero/ký tự mã, không parse số.
- Nếu mã không tồn tại hoặc đã bị xóa/ngừng hiệu lực theo rule danh mục thì trả message API: `Mã nước sản xuất không tồn tại.`
- Không dùng tên nước/quốc tịch để thay thế mã khi check tồn tại.
### 5.4 XML mapping
- Sửa model XML buyer node `src/hddt/WS.Application/Commons/HoaDon/XmlHoaDonTT78/DuLieuHoaDon/NoiDungHoaDon/NMua.cs`:
  - thêm `[XmlElement(ElementName = "QTNMua")] public string QTNMua { get; set; }`
  - thêm `[XmlElement(ElementName = "MQTNMua")] public string MQTNMua { get; set; }`
- Sửa `src/hddt/WS.Application/Commons/HoaDon/HoaDonTT3278Utility.cs`:
  - `HD_HoaDon_MoRong.quoc_tich_nguoi_mua -> nMua.QTNMua`
  - `HD_HoaDon_MoRong.ma_quoc_tich_nguoi_mua -> nMua.MQTNMua`

### 5.5 Danh mục Quốc tịch cho API
- Source `api-cloud-service` hiện chưa thấy `DM_NCC_QuocTichAppService`.
- Bổ sung tương tự pattern `DM_NCC_TinhThanhAppService`:
  - domain/model danh mục quốc tịch trong `WS.Core` theo table danh mục hiện có của hệ thống.
  - DTO trong `src/hddt/WS.Application/DataTransferObjects/DanhMuc/DMNhaCungCap/`.
  - AppService `DM_NCC_QuocTichAppService` có endpoint `GetAllNoPage` để FE lấy dropdown/search.
  - DbSet trong `src/hddt/WS.EntityFrameworkCore/EntityFrameworkCore/HDDTDbContext.cs` nếu EF repository cần.
- Endpoint dự kiến: `DM_NCC_QuocTich/GetAllNoPage`.

## 6. Implementation Order
1. Check `git -C D:\XBill\Cloud\api-cloud-service status --short --branch`.
2. Sửa DTO input: `GuiHDGoc.cs`, `GuiHoaDonTT.cs`, `GuiHoaDonDC.cs`.
3. Sửa entity `HD_HoaDon_MoRong.cs`.
4. Sửa `GuiHoaDonAppService` để validate maxlength, validate tồn tại mã quốc tịch, validate tồn tại mã nước sản xuất và map save/update quốc tịch.
5. Sửa XML model `NMua.cs` và mapping trong `HoaDonTT3278Utility.cs`.
6. Bổ sung danh mục `DM_NCC_QuocTich/GetAllNoPage` theo pattern danh mục nhà cung cấp.
7. Build `D:\XBill\Cloud\api-cloud-service\VS.WS.sln` hoặc `WS.Application.csproj`.
8. Cập nhật `report.md` bằng diff và output build thật.

## 7. Database Changes
Không tạo EF migration nếu repo không dùng migration cho tenant DB. Deploy SQL cần đảm bảo:
```sql
ALTER TABLE `vs_hd_tonghop_morong`
ADD COLUMN `quoc_tich_nguoi_mua` varchar(255) NULL,
ADD COLUMN `ma_quoc_tich_nguoi_mua` varchar(255) NULL;
```
Theo rule API/XML, code validate độ dài thực tế là 50 và 2 ký tự.

Nếu bổ sung danh mục quốc tịch bằng EF, cần xác nhận table master quốc tịch đang dùng trong môi trường trước khi code domain/DbSet.

## 8. Configuration Changes
None.

## 9. External And Inter-Service Integrations
- REST/ABP API contract: thêm field optional, backward compatible.
- XML hóa đơn: thêm `QTNMua/MQTNMua` khi `ACTIVE_ND_254 = "1"` và có dữ liệu quốc tịch; khi cờ tắt không sinh lại thẻ từ dữ liệu lịch sử.
- FE code out of scope, nhưng API danh mục `DM_NCC_QuocTich/GetAllNoPage` là đầu vào cho dropdown FE ở ticket khác.
- Import Excel out of scope.

## 10. Backward Compatibility
Client cũ không gửi quốc tịch vẫn hoạt động. Field mới optional, gate theo `ACTIVE_ND_254`, không phụ thuộc request `version` hoặc `loaihoadondactrung`.

## 11. Verification Plan
- Build: `dotnet build D:\XBill\Cloud\api-cloud-service\VS.WS.sln --no-restore --verbosity quiet` → kỳ vọng 0 error.
- API manual: gửi hóa đơn gốc/thay thế/điều chỉnh có `quoc_tich_nguoi_mua`, `ma_quoc_tich_nguoi_mua`; kiểm tra DB và response.
- API validate: gửi mã quốc tịch > 2 ký tự, quốc tịch > 50 ký tự → nhận lỗi validate tiếng Việt.
- API validate tồn tại: bật NĐ254 và gửi `ma_quoc_tich_nguoi_mua` không có trong danh mục → nhận `Mã quốc tịch không tồn tại.`
- API validate tồn tại: gửi dòng Hàng hóa đặc trưng 1 có `ma_nuocsx` không có trong danh mục → nhận `Mã nước sản xuất không tồn tại.`
- API regression: payload cũ không có quốc tịch vẫn thành công.
- Feature gate: NĐ254 bật thì validate/map/lưu/render quốc tịch; thay đổi request `version` không làm thay đổi kết quả.
- Không yêu cầu có dòng `dschitiet[].loaihoadondactrung == 1`; hóa đơn version 1 loại khác vẫn áp dụng quốc tịch.
- Catalog: gọi `DM_NCC_QuocTich/GetAllNoPage` trả danh sách quốc tịch còn hiệu lực theo pattern danh mục.
- XML regression: XML có `<QTNMua>` và `<MQTNMua>` khi có dữ liệu; không lỗi khi rỗng.

## 12. Risks And Rollback
| Risk | Severity | Mitigation / rollback |
|---|---|---|
| Chưa xác định đúng table master quốc tịch trong API service | Medium | Rà DB/domain hiện có trước khi code danh mục và dùng cùng nguồn với `GetAllNoPage` |
| Validate nhầm theo tên quốc tịch thay vì mã | Medium | Chỉ check tồn tại bằng `ma_quoc_tich_nguoi_mua`; tên chỉ maxlength |
| Bỏ sót mã nước sản xuất ở chi tiết | Medium | Check `dschitiet[].ma_nuocsx` trong cùng catalog quốc tịch/quốc gia khi `version = 1` và `loaihoadondactrung = 1` |
| DB môi trường chưa có cột mở rộng | High | Deploy SQL nullable trước code |
| XML tag sai tên chuẩn | Medium | Test XML với tag `QTNMua`, `MQTNMua` đúng tài liệu |

## 13. Alternatives Considered
- Làm FE dropdown trong ticket này: loại vì user đã chốt CBCLOUDV2-9373 chỉ làm API.
- Không gate quốc tịch theo `ACTIVE_ND_254`: loại theo correction mới của task API; quy định quốc tịch độc lập trong `CBCLOUDV2-9418` chỉ áp dụng luồng Import.
- Gắn thêm gate Hàng hóa đặc trưng 1: loại, vì quốc tịch áp dụng cho mọi hóa đơn khi NĐ254 bật, không chỉ `loaihoadondactrung = 1`.

## 14. Assumptions
- API input dùng naming lower snake-ish để đồng bộ `ma_tinh`, `ma_xa`, `mdvqhns` hiện có.
- Field DB nullable; code enforce maxlength 2/50 theo yêu cầu API/XML.

## 15. Open Questions
None.

## 16. Proposed Docs Updates (Gate 2)
- DB tenant docs: cập nhật `vs_hd_tonghop_morong.ma_quoc_tich_nguoi_mua`, `vs_hd_tonghop_morong.quoc_tich_nguoi_mua` nếu chưa có.
- API/XML docs: ghi nhận `QTNMua/MQTNMua`.

## 17. Deviations Found During Implementation
None yet.

## 18. Approval (Gate 1)
Pending review.







