# CBCLOUDV2-8826 Impact

## Purpose

Đánh giá ảnh hưởng của việc thêm dòng hiển thị **Tên viết tắt** (từ cột Tên tắt `CCT_TenTat` của danh mục Chi cục thuế) vào ô chọn Chi cục thuế, tab Thông tin chung, trên màn khách hàng và màn Admin (ticket CBCLOUDV2-8826).

## Phạm vi thay đổi / Change scope

- Chỉ thay đổi **hiển thị nhãn (UI)** của option trong ô chọn Chi cục thuế.
- **Không** thay đổi DB/schema/migration (field `CCT_TenTat` đã tồn tại trong bảng `vs_dm_ncc_chicucthue` và DTO).
- **Không** thay đổi contract API (dùng lại field đã có trong `DMNCCChiCucThueDto`).
- **Không** thay đổi giá trị lưu của trường (vẫn là `ccT_Ma`).

## Thành phần bị ảnh hưởng / Affected components

| Layer | File / Component | Impact level | Ghi chú |
| --- | --- | --- | --- |
| Frontend (KH) | `frontend_angular/src/app/hddt/cauhinh/thongtindoanhnghiep/doanhnghiep-thongtinchung-tab.component.html` | Thấp | Option Chi cục thuế dùng `[attr.data-content]="buildChiCucThueContent(...)"` |
| Frontend (KH) | `frontend_angular/src/app/hddt/cauhinh/thongtindoanhnghiep/doanhnghiep-thongtinchung-tab.component.ts` | Thấp | Thêm helper `buildChiCucThueContent` (dòng `<p>` 0.8rem) + `styles` `:host ::ng-deep` ẩn `<p>` trong nút |
| Frontend (Admin) | `invoice-management/angular/src/app/hddt/quanly/capnhapthongtindoanhnghiep/doanhnghiep-thongtinchung-tab.component.html` | Thấp | Option dùng `data-content`; dòng chính chuẩn hoá `{ccT_Ten} - Mã: {ccT_Ma}` |
| Frontend (Admin) | `invoice-management/angular/src/app/hddt/quanly/capnhapthongtindoanhnghiep/doanhnghiep-thongtinchung-tab.component.ts` | Thấp | Thêm helper `buildChiCucThueContent` + `styles` `:host ::ng-deep` ẩn `<p>` trong nút |
| Backend | `api-cloud-service/.../DMNCCChiCucThueDto.cs` (`CCT_TenTat`) | Thấp | Chỉ kiểm chứng field được map, không sửa |
| Database | `vs_dm_ncc_chicucthue.CCT_TenTat` | Thấp | Field đã có sẵn, không đổi schema |

## Không thuộc phạm vi / Confirmed unaffected

- Giá trị lưu của Chi cục thuế (`ccT_Ma`) và luồng lưu Thông tin doanh nghiệp — không đổi, chỉ đổi nhãn hiển thị.
- Các ô chọn khác trên tab Thông tin chung — không đụng tới.
- API tải danh mục và mapping DTO — không sửa code.
- Schema DB — không thêm/đổi cột.

## Rủi ro / Hạn chế đã biết / Known risks and limitations

- Ô chọn dùng bootstrap-select (`data-live-search`); nếu component không refresh selectpicker sau khi nạp `lstchicucthue`, subtext có thể không hiển thị → cần gọi `selectpicker('refresh')`.
- Nếu API danh mục trả `ccT_TenTat` rỗng (chưa nhập Tên tắt), dòng phụ sẽ không hiển thị — đây là hành vi mong muốn, nhưng cần dữ liệu Tên tắt để nghiệm thu thực tế.
- Khác biệt định dạng dòng chính giữa 2 màn (Admin hiện chỉ có `{ccT_Ten}`) cần BA chốt trước khi đồng nhất.

## Đã kiểm chứng / Verified

- Đã sửa 2 file HTML (KH + Admin); TS 2 app đã sẵn gọi `selectpicker('refresh')` sau khi nạp danh mục.
- `ccT_TenTat` có trong proxy FE của cả hai app và DTO/entity BE.
- Backend map bằng AutoMapper full-map (`ObjectMapper.Map`) → `CCT_TenTat` tự map, không sửa BE.

## Chưa được kiểm chứng / Not verified

- Build FE của cả hai app (chưa chạy).
- Kiểm thử thủ công trên trình duyệt cho cả hai màn (chưa chạy).
- Xác nhận payload API thực tế có **dữ liệu** `ccT_TenTat`.
- Nhánh đổi tỉnh (`tinhThanhChange`) hiển thị subtext sau reload danh mục.

## Kết luận / Conclusion

Thay đổi rủi ro thấp, chỉ ảnh hưởng hiển thị UI của một ô chọn trên 2 màn, không đổi DB/API/giá trị lưu. Code đã sửa (chưa commit). Cần chốt câu hỏi mở về định dạng dòng chính màn Admin và kiểm thử thủ công trước khi phát hành.
