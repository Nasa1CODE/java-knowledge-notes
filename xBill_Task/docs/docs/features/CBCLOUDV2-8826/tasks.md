# CBCLOUDV2-8826 Tasks

## Task 1 - Hiển thị Tên viết tắt trong ô chọn Chi cục thuế (màn khách hàng)

- Status: completed
- Area/service: `frontend_angular/`
- Description: Thêm dòng phụ `Tên viết tắt: {ccT_TenTat}` (subtext) bên dưới nhãn `{ccT_Ten} - Mã: {ccT_Ma}` trong ô chọn Chi cục thuế ở tab Thông tin chung, màn `/app/hddt/cauhinh/thongtindoanhnghiep/thongtinchung`.
- Acceptance criteria:
  - [x] Option Chi cục thuế hiển thị dòng phụ `Tên viết tắt: {ccT_TenTat}` (qua `data-subtext` bootstrap-select).
  - [x] Chi cục không có Tên tắt: không hiển thị `undefined`/`null` (guard `ccT_TenTat ? ... : null`).
  - [x] Giá trị chọn/lưu vẫn là `ccT_Ma` (không đổi `[value]`).
- Verification:
  - [ ] Manual: mở ô chọn Chi cục thuế, xác nhận dòng phụ đúng theo Tên tắt từng chi cục.
  - [ ] `npm run build` (nếu môi trường cho phép) — chưa chạy.
- Dependencies: None
- Likely touched files:
  - `frontend_angular/src/app/hddt/cauhinh/thongtindoanhnghiep/doanhnghiep-thongtinchung-tab.component.html`
  - `frontend_angular/src/app/hddt/cauhinh/thongtindoanhnghiep/doanhnghiep-thongtinchung-tab.component.ts` (chỉ khi cần gọi `selectpicker('refresh')`)
- Estimated scope: XS

## Task 2 - Hiển thị Tên viết tắt trong ô chọn Chi cục thuế (màn Admin)

- Status: completed
- Area/service: `invoice-management/angular/`
- Description: Thêm dòng phụ `Tên viết tắt: {ccT_TenTat}` (subtext) trong ô chọn Chi cục thuế ở tab Thông tin chung, màn `/app/hddt/quanly/capnhapthongtin-doanhnghiep`. Chuẩn hoá dòng chính về `{ccT_Ten} - Mã: {ccT_Ma}` cho đồng nhất với màn khách hàng (chờ BA xác nhận phần `- Mã:`).
- Acceptance criteria:
  - [x] Option Chi cục thuế hiển thị dòng phụ `Tên viết tắt: {ccT_TenTat}` (qua `data-subtext`).
  - [x] Chi cục không có Tên tắt: không hiển thị `undefined`/`null` (guard tương tự màn KH).
  - [x] Giá trị chọn/lưu vẫn là `ccT_Ma`.
  - [x] Dòng chính chuẩn hoá về `{ccT_Ten} - Mã: {ccT_Ma}` (chờ BA xác nhận — xem Open Questions).
- Verification:
  - [ ] Manual: mở `/app/hddt/quanly/capnhapthongtin-doanhnghiep?tenantid={tenantId}&mstdoanhnghiep={mst}`, xác nhận dòng phụ hiển thị đúng.
  - [ ] Build FE admin app (nếu môi trường cho phép) — chưa chạy.
- Dependencies: None
- Likely touched files:
  - `invoice-management/angular/src/app/hddt/quanly/capnhapthongtindoanhnghiep/doanhnghiep-thongtinchung-tab.component.html`
  - `invoice-management/angular/src/app/hddt/quanly/capnhapthongtindoanhnghiep/doanhnghiep-thongtinchung-tab.component.ts` (chỉ khi cần gọi `selectpicker('refresh')`)
- Estimated scope: XS

## Task 3 - Xác nhận API danh mục trả về Tên tắt

- Status: completed
- Area/service: `api-cloud-service/`
- Description: Xác nhận API tải danh mục Chi cục thuế (`DoanhNghiep_ThongTinChung` / `QuanLyDoanhNghiep`) trả về `CCT_TenTat` có dữ liệu trong `lstChiCucThue`. Field đã có trong DTO; chỉ cần kiểm tra mapping và dữ liệu, không sửa code nếu đã đủ.
- Acceptance criteria:
  - [x] Mapping `result.LstChiCucThue = ObjectMapper.Map<List<DMNCCChiCucThueDto>>(...)` là full AutoMapper → `CCT_TenTat` tự map (DTO + entity đều có field). Không cần sửa code.
  - [ ] Response `lstChiCucThue` chứa `ccT_TenTat` có **dữ liệu** cho các chi cục có Tên tắt (cần dữ liệu thực để nghiệm thu).
- Verification:
  - [x] Đọc code: mapping AutoMapper tại `DoanhNghiep_ThongTinChungAppService.cs:91`.
  - [ ] Manual: kiểm tra payload API trên Network tab hoặc gọi trực tiếp endpoint (chưa chạy).
- Dependencies: None
- Likely touched files:
  - (không sửa, chỉ kiểm chứng) `api-cloud-service/src/hddt/WS.Application/AppServices/CauHinh/DoanhNghiep_ThongTinChungAppService.cs`
- Estimated scope: XS

## Validation

- [ ] Frontend build (2 app).
- [ ] Manual check màn khách hàng.
- [ ] Manual check màn Admin.
- [ ] Manual check chi cục không có Tên tắt.
