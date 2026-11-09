# CBCLOUDV2-8826 Plan

## Goal

Thêm dòng hiển thị **Tên viết tắt** (từ cột Tên tắt của danh mục Chi cục thuế) bên dưới nhãn `{Tên} - Mã: {Mã}` trong ô chọn Chi cục thuế, tab Thông tin chung, trên cả màn khách hàng và màn Admin. Chỉ thay đổi phần hiển thị nhãn option; không đổi giá trị lưu (`ccT_Ma`).

## Context

- Ô chọn Chi cục thuế là `<select>` gốc có `[attr.data-live-search]="true"`, được khởi tạo bằng bootstrap-select (selectpicker), nên có thể dùng thuộc tính `data-subtext` để hiển thị dòng phụ (subtext) như minh hoạ trong yêu cầu.
- Field Tên tắt đã tồn tại sẵn trong model ở cả hai app (`ccT_TenTat` trên FE, `CCT_TenTat` trên BE / entity `DM_NCC_ChiCucThue` → bảng `vs_dm_ncc_chicucthue`), hiện **chưa được dùng** trong nhãn option.
- Màn khách hàng: `frontend_angular/`.
- Màn Admin: `invoice-management/angular/` — là app riêng, có bản sao component tương ứng.

### Vị trí liên quan

| App | File | Ghi chú |
| --- | --- | --- |
| `frontend_angular/` | `src/app/hddt/cauhinh/thongtindoanhnghiep/doanhnghiep-thongtinchung-tab.component.html` (dòng 216-233, nhãn option dòng 230) | Nhãn hiện tại: `{{ chicucthue.ccT_Ten }} - Mã: {{ chicucthue.ccT_Ma }}` |
| `frontend_angular/` | `src/app/hddt/cauhinh/thongtindoanhnghiep/doanhnghiep-thongtinchung-tab.component.ts` | `lstchicucthue: DMNCCChiCucThueDto[]` nạp từ `result.lstChiCucThue` |
| `invoice-management/angular/` | `src/app/hddt/quanly/capnhapthongtindoanhnghiep/doanhnghiep-thongtinchung-tab.component.html` (dòng 251-266, nhãn option dòng 261-264) | Nhãn hiện tại chỉ có `{{chicucthue.ccT_Ten}}` |
| `invoice-management/angular/` | `src/app/hddt/quanly/capnhapthongtindoanhnghiep/doanhnghiep-thongtinchung-tab.component.ts` | `lstchicucthue` nạp từ `result.lstChiCucThue` (QuanLyDoanhNghiepServiceProxy) |
| `api-cloud-service/` | `src/hddt/.../DMNCCChiCucThue/DMNCCChiCucThueDto.cs` (`CCT_TenTat` dòng 11) | DTO đã có field, không sửa |

## Assumptions

- Ô chọn dùng bootstrap-select (`data-live-search`), nên `data-subtext` sẽ render dòng phụ như trong ảnh minh hoạ (dòng chính đậm + dòng phụ xám).
- Danh mục Chi cục thuế đã có dữ liệu ở cột Tên tắt cho các bản ghi cần hiển thị.
- Hai màn nên hiển thị cùng định dạng để đồng nhất trải nghiệm.
- Không cần đổi backend/DTO/API vì `CCT_TenTat` đã có sẵn và được map trong danh sách trả về.

## Open Questions

- Màn Admin có muốn bổ sung `- Mã: {ccT_Ma}` vào dòng chính (hiện chỉ `{ccT_Ten}`) để đồng nhất với màn khách hàng không? Mặc định plan này đề xuất đồng nhất — chờ BA chốt.

## Out Of Scope

- Không sửa backend, DTO, hay API tải danh mục.
- Không đổi schema DB / thêm cột.
- Không đổi giá trị lưu (`ccT_Ma`) và luồng lưu Thông tin doanh nghiệp.
- Không đụng tới các ô chọn khác trên tab.

## Impact Assessment

| Layer | File / Component | Impact level | Ghi chú |
| --- | --- | --- | --- |
| Frontend (KH) | `frontend_angular/.../doanhnghiep-thongtinchung-tab.component.html` | Thấp | Thêm `data-subtext` "Tên viết tắt: {ccT_TenTat}" vào option Chi cục thuế |
| Frontend (Admin) | `invoice-management/angular/.../doanhnghiep-thongtinchung-tab.component.html` | Thấp | Thêm `data-subtext` "Tên viết tắt: {ccT_TenTat}"; (tuỳ chọn) bổ sung `- Mã: {ccT_Ma}` vào dòng chính |
| Backend | `DMNCCChiCucThueDto` / API danh mục | Thấp | Chỉ dùng lại field `CCT_TenTat` đã có; không sửa |
| Database | `vs_dm_ncc_chicucthue.CCT_TenTat` | Thấp | Field đã có sẵn, không đổi schema |

## Implementation Steps

1. **Màn khách hàng** — trong option Chi cục thuế (`doanhnghiep-thongtinchung-tab.component.html` dòng 226-231), thêm subtext:
   - Giữ nhãn chính `{{ chicucthue.ccT_Ten }} - Mã: {{ chicucthue.ccT_Ma }}`.
   - Thêm `[attr.data-subtext]="chicucthue.ccT_TenTat ? ('Tên viết tắt: ' + chicucthue.ccT_TenTat) : null"` trên `<option>`.
2. **Màn Admin** — trong option Chi cục thuế (`doanhnghiep-thongtinchung-tab.component.html` dòng 261-264), thêm subtext tương tự; (tuỳ BA) bổ sung `- Mã: {{chicucthue.ccT_Ma}}` vào dòng chính cho đồng nhất.
3. Sau khi đổ danh mục, đảm bảo gọi refresh selectpicker (`$('#ChiCucThueCombobox').selectpicker('refresh')`) nếu component chưa refresh sau khi nạp `lstchicucthue`, để subtext hiển thị.
4. Xử lý trường hợp `ccT_TenTat` rỗng: không set subtext (để tránh hiển thị `undefined`).
5. Cập nhật docs: tasks, impact, testcase, report.

## Verification

- Build FE nếu môi trường cho phép:
  - `frontend_angular/`: `npm run build`
  - `invoice-management/angular/`: build tương ứng.
- Manual:
  - Mở `/app/hddt/cauhinh/thongtindoanhnghiep/thongtinchung`, mở ô chọn Chi cục thuế, xác nhận dòng phụ `Tên viết tắt: ...` hiển thị đúng theo Tên tắt của từng chi cục.
  - Mở `/app/hddt/quanly/capnhapthongtin-doanhnghiep?tenantid={tenantId}&mstdoanhnghiep={mst}`, xác nhận hiển thị tương tự.
  - Chi cục không có Tên tắt: không hiển thị `undefined`.
  - Chọn & lưu Chi cục thuế: giá trị lưu vẫn là `ccT_Ma`, không lỗi.

## Risk Matrix

| Risk | Impact | Mitigation | Rollback |
| --- | --- | --- | --- |
| Selectpicker không refresh sau khi nạp danh mục → subtext không hiển thị | Trung bình | Gọi `selectpicker('refresh')` sau khi set `lstchicucthue` | Bỏ subtext, quay lại nhãn cũ |
| API danh mục không trả `ccT_TenTat` (dữ liệu rỗng) | Thấp | Guard rỗng → không hiển thị dòng phụ | Không ảnh hưởng dòng chính |
| Khác biệt hành vi bootstrap-select giữa 2 app | Thấp | Kiểm thử riêng từng app | Sửa theo cơ chế của từng app |

## Deployment Notes

- Không có thay đổi DB, config, migration. Chỉ build lại FE của hai app bị ảnh hưởng.
