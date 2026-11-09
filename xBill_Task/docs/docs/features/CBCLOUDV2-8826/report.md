# CBCLOUDV2-8826 Report

## Summary

Thêm dòng phụ **Tên viết tắt** (subtext) vào ô chọn Chi cục thuế ở tab Thông tin chung, trên cả màn khách hàng (`frontend_angular/`) và màn Admin (`invoice-management/angular/`). Giá trị lấy từ field `ccT_TenTat` (cột Tên tắt của danh mục Chi cục thuế). Chỉ thay đổi hiển thị nhãn option; không đổi backend/DB/giá trị lưu.

## Root Cause / Context

- Field `ccT_TenTat` (FE) / `CCT_TenTat` (BE, entity `DM_NCC_ChiCucThue` → bảng `vs_dm_ncc_chicucthue`) đã tồn tại sẵn trong model của cả hai app nhưng **chưa được dùng** trong nhãn option.
- Ô chọn là `<select>` gốc khởi tạo bằng bootstrap-select (`data-live-search`), hỗ trợ thuộc tính `data-subtext` để render dòng phụ (chữ xám) — phù hợp minh hoạ yêu cầu.

## Changes

### 1. Màn khách hàng — `frontend_angular/`

File: `src/app/hddt/cauhinh/thongtindoanhnghiep/doanhnghiep-thongtinchung-tab.component.html` (option Chi cục thuế).

Trước:

```html
<option
    *ngFor="let chicucthue of lstchicucthue"
    [value]="chicucthue.ccT_Ma"
>
    {{ chicucthue.ccT_Ten }} - Mã: {{ chicucthue.ccT_Ma }}
</option>
```

Sau:

```html
<option
    *ngFor="let chicucthue of lstchicucthue"
    [value]="chicucthue.ccT_Ma"
    [attr.data-content]="buildChiCucThueContent(chicucthue)"
>
    {{ chicucthue.ccT_Ten }} - Mã: {{ chicucthue.ccT_Ma }}
</option>
```

Dùng `data-content` (bootstrap-select cho phép HTML tùy biến) để nhúng dòng "Tên viết tắt" bằng thẻ `<p>` font-size 0.8rem, xuống dòng riêng. Nội dung dựng trong helper TS:

```ts
buildChiCucThueContent(chicucthue: DMNCCChiCucThueDto): string {
  const main = `${chicucthue.ccT_Ten} - Mã: ${chicucthue.ccT_Ma}`;
  if (!chicucthue.ccT_TenTat) { return main; }
  return `${main}<p class="cct-tentat text-muted" style="font-size: 0.8rem; margin: 0;">Tên viết tắt: ${chicucthue.ccT_TenTat}</p>`;
}
```

**Xử lý nút đã chọn**: tại `bootstrap-select.js:1358-1361`, khi option có `data-content` thì nút cũng render nguyên HTML → nút sẽ cao 2 dòng. Thêm style `:host ::ng-deep` ẩn thẻ `<p>` trong nút để nút chỉ hiển thị 1 dòng:

```ts
styles: [`
  :host ::ng-deep .bootstrap-select .filter-option-inner-inner .cct-tentat {
    display: none;
  }
`]
```

Text node `{{ ccT_Ten }} - Mã: {{ ccT_Ma }}` được giữ để live-search vẫn lọc theo tên/mã. Component TS đã sẵn gọi `selectpicker('refresh')` sau khi nạp `lstchicucthue`. Đã xác minh bootstrap-select **1.13.1** (cả 2 app): `data-content` render qua `innerHTML` (`bootstrap-select.js:946,986,1404`).

### 2. Màn Admin — `invoice-management/angular/`

File: `src/app/hddt/quanly/capnhapthongtindoanhnghiep/doanhnghiep-thongtinchung-tab.component.html` (option Chi cục thuế).

Trước:

```html
<option *ngFor="let chicucthue of lstchicucthue"
    [value]="chicucthue.ccT_Ma">
    {{chicucthue.ccT_Ten}}
</option>
```

Sau:

```html
<option *ngFor="let chicucthue of lstchicucthue"
    [value]="chicucthue.ccT_Ma"
    [attr.data-content]="buildChiCucThueContent(chicucthue)">
    {{chicucthue.ccT_Ten}} - Mã: {{chicucthue.ccT_Ma}}
</option>
```

Dùng cùng cách như màn khách hàng: helper `buildChiCucThueContent` + `data-content` với thẻ `<p>` 0.8rem, và style `:host ::ng-deep` ẩn `<p>` trong nút. Dòng chính cũng được chuẩn hoá thêm `- Mã: {{ccT_Ma}}` cho đồng nhất (chờ BA xác nhận — xem `expect.md` Open Questions). Component TS đã sẵn gọi `selectpicker('refresh')` sau khi nạp danh mục.

### 3. Backend — `api-cloud-service/` (không sửa)

- `DoanhNghiep_ThongTinChungAppService.GetDoanhNghiep()` map danh mục bằng `ObjectMapper.Map<List<DMNCCChiCucThueDto>>(...)` (dòng 91). Đây là AutoMapper full-map nên `CCT_TenTat` tự được map từ entity sang DTO. DTO `DMNCCChiCucThueDto` đã có `CCT_TenTat`. Không cần sửa code backend.

## Persistence

- Không đổi. Giá trị Chi cục thuế vẫn lưu qua `ccT_Ma` (trường `chiCucThue_Ma`).
- Không thêm/đổi cột; `CCT_TenTat` đã có sẵn trong `vs_dm_ncc_chicucthue`.

## Verification

- [x] Đọc & sửa code 2 file HTML; xác nhận TS 2 app đã refresh selectpicker sau khi nạp danh mục.
- [x] Xác nhận `ccT_TenTat`/`CCT_TenTat` có trong proxy FE (cả 2 app) và DTO/entity BE.
- [x] Xác nhận mapping backend dùng AutoMapper full-map (không select thủ công bỏ sót field).
- [ ] Build FE 2 app — **chưa chạy** trong session này.
- [ ] Kiểm thử thủ công trên trình duyệt (2 màn) — chưa chạy.
- [ ] Xác nhận payload API thực tế có dữ liệu `ccT_TenTat` — chưa chạy.

## Notes / Follow-up

- Chưa commit theo yêu cầu.
- Cần BA chốt Open Question: màn Admin có giữ phần `- Mã: {ccT_Ma}` mới thêm ở dòng chính không.
- Nhánh đổi tỉnh (`tinhThanhChange`) cần được kiểm thử thủ công để chắc subtext hiển thị sau khi reload danh mục theo tỉnh.
