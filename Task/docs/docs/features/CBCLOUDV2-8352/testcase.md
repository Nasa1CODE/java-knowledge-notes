# CBCLOUDV2-8352 Testcase

## Source

- Based on `expect.md` (Expected Behavior, Acceptance Criteria, Out Of Scope).
- `plan.md` referenced only to identify affected files/services for test setup guidance.

## Precondition (all test cases)

- Tester is logged in with a tenant that has:
  - At least one invoice (Danh sách hóa đơn) with `Trạng thái = CQT chấp nhận` where email has been sent (`quanly_guiemail` khác 0/null).
  - At least one invoice with `Trạng thái = CQT chấp nhận` where email has NOT been sent (`quanly_guiemail` bằng 0 hoặc null).
  - At least one chứng từ khấu trừ thuế (Danh sách chứng từ) in the same two email-sent/not-sent combinations for `Trạng thái = CQT chấp nhận`.
  - At least one invoice/chứng từ of the MTT type (`Mau_HoaDon_Loai` 6/7) with `Trạng thái = CQT chấp nhận`, one with email sent and one without, if the tenant supports MTT invoices.

## Test Cases — Danh sách hóa đơn

| ID | Scenario | Steps | Expected Result | Status |
| --- | --- | --- | --- | --- |
| TC-01 | Filter by "CQT chấp nhận và đã gửi mail" | Vào Danh sách hóa đơn → mở dropdown Trạng thái → chọn "CQT chấp nhận và đã gửi mail" → bấm Tìm kiếm. | Chỉ hiển thị các hóa đơn có trạng thái CQT chấp nhận VÀ đã gửi email. Không hiển thị hóa đơn CQT chấp nhận chưa gửi email hoặc hóa đơn ở trạng thái khác. | not run |
| TC-02 | Filter by "CQT chấp nhận và chưa gửi mail" | Vào Danh sách hóa đơn → mở dropdown Trạng thái → chọn "CQT chấp nhận và chưa gửi mail" → bấm Tìm kiếm. | Chỉ hiển thị các hóa đơn có trạng thái CQT chấp nhận VÀ chưa gửi email (bao gồm cả trường hợp chưa từng gửi lẫn giá trị null). Không hiển thị hóa đơn đã gửi email hoặc trạng thái khác. | not run |
| TC-03 | Cột Trạng thái giữ nhãn hiện tại — đã gửi mail | Trong danh sách hóa đơn, quan sát một hóa đơn CQT chấp nhận đã gửi email. | Cột Trạng thái vẫn hiển thị nhãn gốc "CQT đã chấp nhận"; nhãn tách chỉ áp dụng ở dropdown filter. | not run |
| TC-04 | Cột Trạng thái giữ nhãn hiện tại — chưa gửi mail | Quan sát một hóa đơn CQT chấp nhận chưa gửi email. | Cột Trạng thái vẫn hiển thị nhãn gốc "CQT đã chấp nhận"; nhãn tách chỉ áp dụng ở dropdown filter. | not run |
| TC-05 | HD MTT được áp dụng cùng logic | Lặp lại TC-01/TC-02 trên Danh sách hóa đơn máy tính tiền (hoặc filter Loại hóa đơn = MTT trong Danh sách hóa đơn). | Kết quả lọc và nhãn hiển thị đúng như hóa đơn thường, dựa trên cùng điều kiện trạng thái + gửi email. | not run |
| TC-06 | Xuất Excel phản ánh đúng trạng thái mới | Filter theo "CQT chấp nhận và đã gửi mail" → bấm Xuất Excel. Lặp lại với "CQT chấp nhận và chưa gửi mail". | File Excel xuất ra chỉ chứa các hóa đơn khớp với điều kiện filter đã chọn, giống với danh sách hiển thị trên màn hình. | not run |
| TC-07 | Xuất Excel nâng cao theo trạng thái chi tiết | Bấm Xuất Excel nâng cao khi đang filter theo "CQT chấp nhận" hoặc một trong hai trạng thái email chi tiết. Lặp lại cho tổng hợp, chi tiết và thuế suất. | Kết quả áp dụng `TrangThaiChiTiet` cùng filter tab hiện tại; luồng queue >200 dòng sử dụng worker tương ứng. | not run |
| TC-08 | Không ảnh hưởng trạng thái khác | Filter lần lượt qua các trạng thái cũ: Mới tạo, Trình ký, Đã ký và đã/chưa gửi mail, Đã cấp số, Đang gửi CQT, TVAN đã/không tiếp nhận, CQT đã chấp nhận (cũ, value 8), CQT từ chối. | Tất cả các trạng thái cũ trả về kết quả và nhãn hiển thị giống như trước khi có thay đổi này. | not run |
| TC-09 | Option "CQT đã chấp nhận" (cũ, aggregate) vẫn còn | Mở dropdown Trạng thái, kiểm tra danh sách option. | Option "CQT đã chấp nhận" (value cũ) vẫn còn trong dropdown, cạnh 2 option mới. **Chưa xác nhận với BA** liệu option này có nên bị xóa theo tài liệu gốc hay không — nếu BA yêu cầu xóa, test case này sẽ cần cập nhật. | not run |

## Test Cases — Danh sách chứng từ khấu trừ thuế

| ID | Scenario | Steps | Expected Result | Status |
| --- | --- | --- | --- | --- |
| TC-10 | Filter by "CQT chấp nhận và đã gửi mail" | Vào Danh sách chứng từ khấu trừ thuế → mở dropdown Trạng thái → chọn "CQT chấp nhận và đã gửi mail" → tìm kiếm. | Chỉ hiển thị chứng từ có trạng thái CQT chấp nhận VÀ đã gửi email. | not run |
| TC-11 | Filter by "CQT chấp nhận và chưa gửi mail" | Chọn "CQT chấp nhận và chưa gửi mail" → tìm kiếm. | Chỉ hiển thị chứng từ có trạng thái CQT chấp nhận VÀ chưa gửi email (kể cả giá trị null). | not run |
| TC-12 | Cột Trạng thái giữ nhãn hiện tại | Quan sát một chứng từ CQT chấp nhận đã gửi email và một chưa gửi email. | Cột Trạng thái vẫn hiển thị nhãn gốc "CQT đã chấp nhận"; nhãn tách chỉ áp dụng ở dropdown filter. | not run |
| TC-13 | Xuất Excel chứng từ phản ánh đúng trạng thái | Filter theo từng trạng thái mới → bấm Xuất Excel (chứng từ). | File Excel xuất ra chỉ chứa chứng từ khớp điều kiện filter đã chọn. | not run |
| TC-14 | Không ảnh hưởng trạng thái khác | Filter lần lượt qua các trạng thái cũ khác của chứng từ (Mới tạo, Trình ký, Đã ký, Đã cấp số,...). | Kết quả và nhãn hiển thị giống như trước khi có thay đổi này. | not run |
| TC-15 | "Đã ký và đã/chưa gửi mail" cho chứng từ | Kiểm tra dropdown chứng từ và chọn lần lượt giá trị `13`/`14`. | Bộ lọc tách `Ct_TrangThai == 3` theo `QuanLy_GuiEmail > 0` và `NULL/0`; badge trong bảng giữ nhãn gốc. | not run |

## Regression / Edge Cases

| ID | Scenario | Steps | Expected Result | Status |
| --- | --- | --- | --- | --- |
| TC-16 | Không có dữ liệu khớp | Filter theo một trong hai trạng thái mới khi không có bản ghi nào khớp. | Hệ thống hiển thị danh sách rỗng / thông báo không có dữ liệu, không lỗi. | not run |
| TC-17 | Kết hợp filter khác cùng lúc | Filter theo trạng thái mới kết hợp thêm điều kiện khác (khoảng ngày, ký hiệu, người mua,...). | Kết quả thỏa mãn đồng thời tất cả điều kiện filter, không chỉ riêng trạng thái. | not run |
| TC-18 | Phân trang | Nếu có nhiều bản ghi khớp trạng thái mới, kiểm tra phân trang hoạt động đúng. | Phân trang hiển thị đúng tổng số bản ghi và điều hướng trang bình thường. | not run |

## Out Of Scope (do not test as defects if observed)

- Báo cáo hóa đơn (mọi màn báo cáo) không áp dụng 2 trạng thái mới — theo `expect.md`.
- `vs_hdpos` (Danh sách hóa đơn máy tính tiền dạng batch/lô riêng ở màn `quanlyhdpos`) không thay đổi.
- Không có thay đổi dữ liệu (`QuanLy_TrangThai`/`Ct_TrangThai`/`quanly_guiemail`) — chỉ thay đổi logic filter và hiển thị.

## Verification Evidence

- Backend/worker đã có evidence build thành công; test thủ công và end-to-end queue vẫn chưa chạy — xem `report.md` mục Verification.
- Tất cả test case ở trạng thái `not run` cho đến khi tester thực hiện thủ công trên môi trường thật.

## Background Export Regression — Invoice Extension Rows

| ID | Scenario | Steps | Expected Result | Status |
| --- | --- | --- | --- | --- |
| TC-19 | Plain export does not duplicate extension rows | Prepare one invoice with at least two `vs_hd_tonghop_morong` rows, trigger a queued plain export (>200 rows), then inspect the generated file. | The invoice-extension fields come from the row with the greatest `id`; the parent invoice is not duplicated because of `vs_hd_tonghop_morong`. | not run |
| TC-20 | Advanced summary export does not duplicate extension rows | Select extended invoice fields, trigger queued advanced summary export, and inspect invoices with multiple extension rows. | Each parent invoice has at most one invoice-extension row, selected by greatest `id`. | not run |
| TC-21 | Advanced detail export preserves intended detail rows | Prepare one invoice with multiple `vs_hd_chitiet` rows and multiple extension rows, then run queued detail export. | Multiple detail rows remain because the export is detail-oriented, but invoice-extension data does not multiply each detail row beyond the intended detail join. | not run |
| TC-22 | Advanced tax-rate export preserves intended tax-rate rows | Prepare one invoice with multiple `vs_hd_thuesuat` rows and multiple invoice-extension rows, then run queued tax-rate export. | Multiple tax-rate rows remain because the export is tax-rate-oriented, but invoice-extension data comes from only the greatest-id extension row. | not run |
| TC-23 | Tenant/POS predicates remain isolated | Run queued export with same MST present in more than one tenant and with deleted POS templates. | Only the requested tenant's invoice rows are returned; deleted or other-tenant POS templates do not affect POS inclusion/exclusion. | not run |
