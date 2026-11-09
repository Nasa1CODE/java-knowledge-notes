# CBCLOUDV2-8352 Impact

## Purpose

Đánh giá phạm vi ảnh hưởng của việc bổ sung 2 trạng thái con "CQT chấp nhận và đã gửi mail" / "CQT chấp nhận và chưa gửi mail" cho trạng thái "CQT chấp nhận" hiện có (`QuanLy_TrangThai` / `Ct_TrangThai == 8`).

Trong quá trình implement, scope đã mở rộng thêm (theo yêu cầu người dùng, xem `plan.md` mục Status) để bao gồm: tách trạng thái "Đã ký" cho chứng từ (`13`/`14`), đồng bộ toàn diện luồng export nền (>200 dòng) với màn danh sách, sửa 1 bug filter `NguoiMua` có sẵn, và bổ sung filter hóa đơn máy tính tiền (`IsPos`) cho cả Xuất Excel thường và nâng cao. Tài liệu này phản ánh đầy đủ toàn bộ các thay đổi đó, không chỉ phần gốc trong `expect.md`.

## Phạm vi thay đổi

- Chỉ thay đổi logic filter (tìm kiếm/lọc) và nhãn trong dropdown bộ lọc. Nhãn trạng thái hiển thị trong bảng (badge) được giữ nguyên như cũ.
- Không thay đổi dữ liệu: không có migration, không thay đổi giá trị `QuanLy_TrangThai`/`Ct_TrangThai`/`quanly_guiemail`/`IsPos` hiện có trong database.
- Không thay đổi API contract công khai theo cách phá vỡ tương thích — chỉ thêm giá trị/field filter mới (`11`-`14`, `TrangThaiChiTiet`, `IsPos`), giá trị/field cũ vẫn hoạt động như trước.
- Có 2 mục vượt phạm vi filter/label thuần túy: (a) fix bug filter `NguoiMua` có sẵn trong `XuatExcelNangCao`, và (b) fix bug filter tab + fix filter `NguoiMua`/`Filter.*` thiếu trong worker export nền — cả hai là sửa lỗi hành vi filter sai từ trước, không phải thêm nghiệp vụ mới, nhưng làm thay đổi kết quả trả về của các luồng đó so với trước khi sửa.

## Thành phần bị ảnh hưởng

### 1. Backend — `invoicecore/aspnet-core/`

| Service | File | Method | Mức ảnh hưởng |
| --- | --- | --- | --- |
| HDDT.Application | `HoaDonAppService.cs` | `GetDataFilterTable_New` | Trung bình — thêm 2 branch filter mới, không sửa branch cũ |
| HDDT.Application | `HoaDonAppService.cs` | `XuatExcel` (gọi `GetDataFilterTable_New`) | Thấp — hưởng lợi gián tiếp từ thay đổi trên, không sửa trực tiếp |
| HDDT.Application | `HoaDonAppService.cs` | `XuatExcelNangCao` | Trung bình — thêm nhánh `TrangThaiChiTiet == 8/11/12` vào cả 3 branch (0/1/thuế suất) qua field DTO mới |
| HDDT.Application | `DanhSachHoaDonNangCaoInput.cs` | (DTO) | Thấp — thêm field `TrangThaiChiTiet` (int?) |
| HDDT.Application | `ChungTuKhauTruThueAppService.cs` | `Filter` | Trung bình — thêm 2 branch filter mới (`11`/`12`) và 2 branch mới cho "Đã ký" (`13`/`14`, `Ct_TrangThai == daky`) |
| HDDT.Application | `ChungTuKhauTruThueAppService.cs` | `ExportExcelCt` | Trung bình — đồng bộ với `Filter` (`11`/`12`/`13`/`14`) |
| HDDT.Application | `HoaDonAppService.cs` | `FilterByIsPos` (helper mới) + gọi trong `XuatExcel`/`XuatExcelNangCao` (3 nhánh) | Trung bình — thêm filter hóa đơn máy tính tiền cho export, dùng `EXISTS`/`NOT EXISTS` (tối ưu hơn `Contains` trên subquery cũ) |
| HDDT.Application | `HoaDonAppService.cs`, `XuatExcelNangCao` nhánh `LoaiXuatExcel == 0` | Fix bug filter `NguoiMua` (điều kiện cuối dùng nhầm `input.SoHoaDon`) | Trung bình — sửa lỗi có sẵn, thay đổi kết quả filter theo NguoiMua ở nhánh này |
| HDDT.Application | `DanhSachHoaDonNangCaoInput.cs` | (DTO) | Thấp — thêm field `IsPos` (int?), ngoài `TrangThaiChiTiet` đã thêm trước đó |

Không thay đổi: `HDDT.Core` (entity, enum), `HDDT.EntityFrameworkCore` (không có migration).

### 1b. Backend — `svinvoicesendemail/AppServiceExportBillHost/` (worker xử lý queue export >200 dòng)

| File | Thay đổi | Mức ảnh hưởng |
| --- | --- | --- |
| `Models/DanhSachHoaDonNangCaoInput.cs` | Thêm field `TrangThaiChiTiet`, sau đó thêm `IsPos` | Thấp |
| `Models/DanhSachHoaDonInput.cs` | Thêm field `IsPos` | Thấp |
| `Repositories/HD_HoaDonRepository.cs` | 3 hàm nâng cao: thêm branch `TrangThaiChiTiet == 8/11/12` + fix filter tab (`input.TrangThai`) + thêm điều kiện `IsPos` (`EXISTS`/`NOT EXISTS`). Hàm `GetDataExcel(DanhSachHoaDonInput)`: **sửa lại từ đầu** — đọc đúng `Filter.TrangThai_HoaDon`, fix filter tab, bổ sung toàn bộ field `Filter.*` còn thiếu (`Mau_So`, `TongTienTu/Den`, `Mau_HoaDon_Loai`, `KyHieuSelects`, `ThanhToan_PhuongThuc`, `TaiKhoanTao`/`TaiKhoanKy`), và thêm điều kiện `IsPos` | Cao — sửa lại toàn bộ logic filter cho luồng Xuất Excel (thường + nâng cao) khi >200 dòng, đảm bảo khớp 100% với màn danh sách |

Bối cảnh: khi `XuatExcel`/`XuatExcelNangCao` trả về >200 dòng, request được đẩy vào queue (`vs_service_exportbill`) và xử lý bởi worker riêng biệt (`AppServiceExportBillHost`), có DTO và raw-SQL (Dapper) riêng, không dùng chung code với `invoicecore`. Đã phát hiện và sửa (theo lựa chọn của người dùng — làm đầy đủ để khớp 100% với màn danh sách, option 2):
1. Gap do chính ticket này gây ra: field `TrangThaiChiTiet` mới thêm không tồn tại ở DTO của worker → bị bỏ qua khi deserialize JSON.
2. Bug có từ trước (không do ticket này gây ra): hàm xử lý Xuất Excel thường của worker chưa từng đọc `Filter.TrangThai_HoaDon` — mọi trạng thái chi tiết (0-10) đều bị bỏ qua khi >200 dòng. Đồng thời filter theo tab (Lưu tạm/Trình ký/Ký lỗi/Đã ký) cũng sai logic ở cả 4 hàm worker.
3. Rà soát toàn diện: bổ sung các field filter khác mà màn danh sách/Xuất Excel gửi lên nhưng worker chưa từng xử lý — khoảng tổng tiền, chọn nhiều ký hiệu, phương thức thanh toán, tài khoản tạo/ký (dạng LIKE).
4. Gap do phần mở rộng `IsPos` gây ra (phát hiện và sửa ngay trong cùng lượt): worker chưa từng lọc theo hóa đơn máy tính tiền cho luồng export — thêm `EXISTS`/`NOT EXISTS` subquery (join `vs_hd_thongbao_hdmau` theo `mau_hdmau_id`) vào cả 4 hàm, cùng ngữ nghĩa với `FilterByIsPos` ở `invoicecore` (mặc định/không phải `1` → loại trừ HĐ MTT).

### 2. Frontend — `frontend_angular/`

| Screen | File | Thay đổi | Mức ảnh hưởng |
| --- | --- | --- | --- |
| Danh sách hóa đơn | `hoadon.component.ts` | Thêm 2 entry vào `loaiTrangThaiList`; `xuatExcel()`/`xuatExcelNangcao()` truyền thêm `trangThaiChiTiet = filterTable.trangThai_HD` và `isPos = this.loaiHoaDonIsPos` | Thấp |
| Danh sách hóa đơn | `service-proxies.ts` | Vá tay field `trangThaiChiTiet` và `isPos` trên `DanhSachHoaDonNangCaoInput` (chưa regen NSwag) | Thấp-Trung bình |
| Danh sách hóa đơn | `hoadon.component.html` | Badge trạng thái trong bảng (`quanLy_TrangThai==8`) **giữ nguyên** nhãn gốc `CQT đã chấp nhận` — không tách theo email | Không đổi |
| Danh sách chứng từ khấu trừ thuế | `dschungtukhautruthue.component.html` | Thêm 4 `<option>` vào filter (`11`/`12` CQT chấp nhận, `13`/`14` Đã ký). Badge trạng thái trong bảng **giữ nguyên** nhãn gốc | Thấp |

Không thay đổi: badge/nhãn trạng thái trong bảng (chỉ sửa ở filter theo yêu cầu), routing, permission, các component khác trong module hddt. Lưu ý: `service-proxies.ts` được vá tay 1 field (`trangThaiChiTiet`) cho Xuất Excel nâng cao — các DTO khác không đổi (`quanLy_GuiEmail` đã tồn tại sẵn).

### 3. Database

- Không có thay đổi schema. Cột `quanly_guiemail` đã tồn tại sẵn (nullable int) trên cả `vs_hd_tonghop` và `vs_chungtu_khautru`.
- Không cần migration hoặc script deploy DB.

### 4. Các chức năng liên quan không thuộc phạm vi (không bị ảnh hưởng, đã xác nhận không đổi)

| Chức năng | Vì sao không bị ảnh hưởng |
| --- | --- |
| Báo cáo hóa đơn (mọi màn: `BaoCaoDoanhThuTheoSanPham`, `TinhHinhSuDungHoaDonTheoBenMua`,...) | Nằm ngoài scope theo `expect.md`, không đụng tới |
| Danh sách hóa đơn máy tính tiền dạng batch (`quanlyhdpos`, bảng `vs_hdpos`) | Là trạng thái lô gửi (batch), khác với trạng thái hóa đơn đơn lẻ — không có cột tương đương `quanly_guiemail`, không đụng đến |
| ~~Chứng từ trạng thái "Đã ký" (`Ct_TrangThai == 3`)~~ | Đã được implement (theo yêu cầu người dùng) — tách thành `13` (Đã ký và đã gửi mail) / `14` (Đã ký và chưa gửi mail) trong `Filter`/`ExportExcelCt` và dropdown; không còn ngoài phạm vi |
| Các trạng thái khác (Mới tạo, Trình ký, Đã cấp số, Đang gửi CQT, TVAN đã/không tiếp nhận, CQT từ chối, Gửi CQT lỗi) | Không đổi logic filter/hiển thị |
| `svinvoicesendemail/AppServicePrintBill/AppService/Repositories/HD_HoaDonRepository.cs` (có method `GetDataExcel*` cùng tên) | Xác nhận project này chỉ consume queue `PrintPDFData` (in PDF) qua `PrintPdfProcess.cs`, không xử lý `ServiceExportBill`/Excel export — các method trùng tên là code chết/trùng lặp cho luồng này, không sửa |
| Chứng từ khấu trừ thuế — luồng export nền >200 dòng | `ChungTuKhauTruThueAppService.Filter`/`ExportExcelCt` chạy đồng bộ (không có cơ chế queue tương tự `vs_service_exportbill`), nên không có gap worker tương ứng như hóa đơn |

## Rủi ro / Hạn chế đã biết

1. **Xuất Excel nâng cao đã được bổ sung filter theo trạng thái CQT chấp nhận (8/11/12)** (theo yêu cầu người dùng) qua field mới `TrangThaiChiTiet` trên `DanhSachHoaDonNangCaoInput`, áp dụng cho cả 3 nhánh (`LoaiXuatExcel` 0/1/thuế suất). Lưu ý: `service-proxies.ts` được **vá tay** (chưa regen NSwag) — cần regen proxy chính thức khi có môi trường. Field này chỉ mang giá trị dropdown chi tiết; logic tab cũ giữ nguyên.
2. **Giá trị dropdown mới (`11`, `12`) chưa được BA xác nhận chính thức** — được chọn để không đụng giá trị `0`-`10` đang dùng, nhưng cần confirm trước khi release chính thức.
3. **Option "CQT đã chấp nhận" cũ (value `8`) vẫn được giữ nguyên**, không xóa như tài liệu gốc ghi "(bỏ trạng thái)" — quyết định giữ để tránh phá vỡ hành vi cũ, cần BA xác nhận.
4. **Ngữ nghĩa "chưa gửi mail"**: tài liệu gốc ghi hóa đơn dùng `=0` còn chứng từ dùng `=null`; implementation này áp dụng cả `NULL` và `0` cho cả hai loại để an toàn hơn — cần BA xác nhận đúng ý định.
5. **Chứng từ "Đã ký và đã/chưa gửi mail" đã được làm** (theo yêu cầu người dùng) — tách `Ct_TrangThai == 3` thành `13`/`14`. Giá trị `13`/`14` cũng cần BA xác nhận như `11`/`12`.
6. **Scope đã vượt ra ngoài tiêu đề ticket gốc** ở nhiều phần (xem `plan.md` mục Status): sync worker toàn diện, filter `IsPos` cho export, 2 bug fix có sẵn. Toàn bộ được thực hiện theo yêu cầu trực tiếp của người dùng trong chat, chưa qua Gate 1/BA sign-off chính thức cho các phần mở rộng này — khuyến nghị BA/TechLead review lại trước khi release, và xem xét tách thành ticket riêng nếu cần truy vết.
7. **Worker (`svinvoicesendemail/AppServiceExportBillHost`) chỉ được xác minh bằng `dotnet build`**, chưa chạy thực tế qua queue với dữ liệu thật. Đây là luồng dùng raw SQL string nối tay (Dapper), không có compiler kiểm tra cú pháp SQL — rủi ro cao hơn code LINQ thông thường nếu có lỗi tên cột/tham số không lộ ra khi build.
8. **Filter hóa đơn máy tính tiền (`IsPos`) cho export chưa có trong `expect.md` gốc** — là bổ sung theo yêu cầu người dùng ngoài luồng, cần xác nhận với BA rằng đây là hành vi mong muốn (Xuất Excel tôn trọng đúng loại màn hình thường/MTT đang xem).

## Bug có sẵn được phát hiện và sửa thêm (không thuộc scope gốc của ticket)

1. **`NguoiMua` filter dùng nhầm `SoHoaDon`**: trong lúc đối chiếu filter `NguoiMua` giữa `invoicecore` và worker để đảm bảo khớp nhau, phát hiện `HoaDonAppService.XuatExcelNangCao` (nhánh `LoaiXuatExcel == 0`) có lỗi có sẵn: 1/7 điều kiện `OR` trong block `NguoiMua` dùng nhầm `input.SoHoaDon` thay vì `input.NguoiMua`. Đã sửa lại cho khớp 6 điều kiện còn lại. `XuatExcel` (thường) và 2 nhánh nâng cao khác không bị lỗi này. Worker (`svinvoicesendemail`) đã đúng từ đầu, không cần sửa thêm.
2. **Filter tab (`chonTab()`) sai logic ở worker export nền**: cả 4 hàm query của worker chỉ check `input.TrangThai != null → quanly_trangthai <> 0` (không đúng với logic tab thật: Lưu tạm/Trình ký/Ký lỗi so khớp chính xác, Đã ký = nhóm `{3,5,6,7,8,9}`). Đã sửa để khớp đúng logic của `HoaDonAppService.XuatExcel`. Bug này có từ trước, ảnh hưởng mọi lần export >200 dòng có chọn tab cụ thể (không phải "Tất cả").

## Chưa được kiểm chứng (Not Verified)

- Build ban đầu (`dotnet build`/`npm run build`) bị bỏ qua theo yêu cầu người dùng ở lượt implement đầu tiên. Các lượt sau đã build thực tế:
  - `dotnet build "HDDT.Application.csproj"` → **Build succeeded, 0 Error(s)**.
  - `dotnet build "svinvoicesendemail/AppServiceExportBillHost/AppService/AppService.csproj"` → **Build succeeded, 0 Error(s)**.
  - `npm run build` cho `frontend_angular` vẫn **chưa** được chạy trong session này.
- Kiểm thử thủ công trên môi trường thật (filter, xuất Excel, hiển thị badge, filter IsPos) — chưa thực hiện, xem `testcase.md`.
- Kiểm thử luồng queue >200 dòng (cả Xuất Excel thường và nâng cao) qua worker thật — chỉ soát code + build, chưa chạy thực tế với dữ liệu qua queue.

## Kết luận

Thay đổi ban đầu có phạm vi hẹp (2 AppService backend + 3 file frontend), nhưng đã mở rộng đáng kể qua nhiều lượt theo yêu cầu người dùng: thêm split "Đã ký" cho chứng từ, đồng bộ toàn diện worker export nền (>200 dòng) với màn danh sách, sửa 2 bug filter có sẵn (`NguoiMua`, filter tab ở worker), và thêm filter hóa đơn máy tính tiền (`IsPos`) cho cả 2 luồng export. Không đổi schema DB. Đã build thành công cả 2 project backend (`HDDT.Application`, worker `AppService`), nhưng chưa build frontend và chưa test thực tế end-to-end (đặc biệt luồng queue >200 dòng). Rủi ro chính: (1) nhiều quyết định thiết kế chưa được BA xác nhận chính thức, (2) scope đã vượt ticket gốc mà chưa qua Gate 1 lại cho các phần mở rộng, (3) worker dùng raw SQL chưa test thực tế. Khuyến nghị: chạy `npm run build` + test thủ công đầy đủ (bao gồm trigger luồng >200 dòng) trước khi release, và đưa toàn bộ Open Questions + các mục mở rộng scope cho BA/TechLead xác nhận.

## Latest Worker Impact — 2026-07-15

- Plain export and all three advanced worker methods now join `vs_hd_tonghop_morong` through one `MAX(id)` row per `tonghop_id` when extension fields are selected.
- Detail export still intentionally returns multiple rows per invoice for multiple `vs_hd_chitiet` rows; tax-rate export still intentionally returns multiple rows for multiple `vs_hd_thuesuat` rows. The fix only removes multiplication caused by multiple invoice-extension rows.
- Tenant isolation was tightened in affected worker queries: invoice rows require `TenantId = @TenantId`; POS template lookups require `IsDeleted = 0` and the same tenant.
- Advanced worker methods now parenthesize the type 6/7 condition, which can reduce rows previously admitted due to raw SQL operator precedence.
- No schema/data migration is required. The `MAX(id)` selection policy is an implementation decision and should be confirmed if extension-row history has a different canonical-row rule.
- The worker build succeeded with 0 errors using a temporary output directory. No live queue/database run has been performed.
