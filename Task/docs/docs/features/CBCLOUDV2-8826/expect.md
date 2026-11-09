# CBCLOUDV2-8826 Expect

## Feature Status

- Status: in-progress
- Class: XS

## Business Goal

Trên ô chọn (selectbox) **Chi cục thuế** ở tab **Thông tin chung** của màn Thông tin doanh nghiệp, hiển thị thêm **Tên viết tắt** của cơ quan thuế để người dùng phân biệt nhanh các chi cục có tên gần giống nhau. Giá trị Tên viết tắt lấy từ cột **Tên tắt** trong danh mục **Chi cục thuế**.

## Scope

- Frontend (màn khách hàng): `frontend_angular/`
  - Màn: `/app/hddt/cauhinh/thongtindoanhnghiep/thongtinchung`
- Frontend (màn Admin): `invoice-management/angular/`
  - Màn: `/app/hddt/quanly/capnhapthongtin-doanhnghiep?tenantid={tenantId}&mstdoanhnghiep={mst}`
- Tab: **Thông tin chung**
- Trường: ô chọn (selectbox) **Chi cục thuế**
- Nguồn dữ liệu: cột **Tên tắt** trong danh mục Chi cục thuế (`ccT_TenTat` / `CCT_TenTat`).

## Expected Behavior

- Mỗi dòng (option) trong ô chọn **Chi cục thuế** hiển thị theo 2 dòng:
  - Dòng 1: `{Tên chi cục} - Mã: {Mã chi cục}` (giữ nguyên như hiện tại).
  - Dòng 2 (mới): `Tên viết tắt: {Tên tắt}` hiển thị bên dưới, dạng chữ phụ (subtext) như minh hoạ.
- Giá trị Tên viết tắt được lấy từ cột **Tên tắt** của danh mục Chi cục thuế (`ccT_TenTat`).
- Khi cơ quan thuế không có Tên tắt, dòng "Tên viết tắt" không hiển thị (hoặc để trống), không hiển thị chữ `undefined`/`null`.
- Áp dụng cho cả màn khách hàng và màn Admin; hai màn hiển thị định dạng giống nhau: dòng chính `{Tên} - Mã: {Mã}`, dòng phụ `Tên viết tắt: {Tên tắt}`.
- Việc chọn/lưu Chi cục thuế vẫn dựa trên **Mã chi cục** (`ccT_Ma`) như hiện tại — chỉ thay đổi phần hiển thị nhãn của option.

## Out Of Scope

- Không đổi giá trị lưu của trường Chi cục thuế (vẫn lưu `ccT_Ma`).
- Không đổi cấu trúc bảng danh mục Chi cục thuế (`vs_dm_ncc_chicucthue`) và không thêm cột mới.
- Không đổi API tải danh mục Chi cục thuế; chỉ dùng lại field `CCT_TenTat` đã có trong DTO.
- Không thay đổi các ô chọn khác trên tab Thông tin chung.
- Không đổi luồng lưu Thông tin doanh nghiệp ngoài phần hiển thị này.

## Acceptance Criteria

- Trên `/app/hddt/cauhinh/thongtindoanhnghiep/thongtinchung`, ô chọn Chi cục thuế hiển thị dòng phụ `Tên viết tắt: {ccT_TenTat}` bên dưới `{ccT_Ten} - Mã: {ccT_Ma}`.
- Trên `/app/hddt/quanly/capnhapthongtin-doanhnghiep`, ô chọn Chi cục thuế hiển thị định dạng tương tự (dòng chính `{ccT_Ten} - Mã: {ccT_Ma}` + dòng phụ `Tên viết tắt: {ccT_TenTat}`).
- Tên tắt hiển thị đúng theo cột Tên tắt của từng chi cục trong danh mục.
- Chi cục không có Tên tắt: không hiển thị dòng phụ rỗng có chữ `undefined`/`null`.
- Chọn và lưu Chi cục thuế vẫn hoạt động đúng, giá trị lưu là `ccT_Ma`.

## Open Questions

- Màn Admin hiện chỉ hiển thị `{ccT_Ten}` (không có `- Mã: {ccT_Ma}`). Task này chuẩn hoá về cùng định dạng `{ccT_Ten} - Mã: {ccT_Ma}` + `Tên viết tắt: {ccT_TenTat}` cho đồng nhất hai màn — cần BA xác nhận có muốn thêm phần `- Mã:` trên màn Admin hay giữ nguyên chỉ `{ccT_Ten}` cho dòng chính.
- Cần xác nhận API tải danh mục có trả `ccT_TenTat` đã có dữ liệu (field có trong DTO nhưng cần dữ liệu thực).
