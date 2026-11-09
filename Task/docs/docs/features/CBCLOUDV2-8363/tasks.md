# CBCLOUDV2-8363 Tasks

## Status

- Feature status: code implemented; chờ build + kiểm thử thủ công.

## Tasks

| Status | Area | Task |
| --- | --- | --- |
| completed | frontend_angular | Thêm tham số `delay` + xử lý lỗi cho `loadChungThu` trong `doanhnghiep-chungthu-tab.component.ts`. |
| completed | frontend_angular | Đổi luồng xóa (`xoaChungThu`) sang gọi `loadChungThu(0)` thay cho `reloadPage()`. |
| completed | frontend_angular | Thêm xử lý lỗi cho `timKiemChungThu` để luôn tắt loading. |
| completed | frontend_angular | Đổi binding `(modalSave)` sang `loadChungThu(0)` trong `doanhnghiep-chungthu-tab.component.html`. |
| completed | docs | Tạo `expect.md`, `plan.md`, `tasks.md`, `impact.md`, `report.md`. |
| pending | Verification | Chạy `npm run build` (frontend_angular) và kiểm thử thủ công thêm/xóa chứng thư số trên môi trường chạy. |

## Task Details

### Task 1 - Sửa refresh danh sách chứng thư số

- Area/service: `frontend_angular/`
- Description: Thống nhất refresh sau thêm/xóa về `loadChungThu()` (`getAll_Mst`, đường dẫn giống F5), thêm `delay` param và xử lý lỗi để loading không bị treo.
- Acceptance criteria: thêm/xóa chứng thư số cập nhật danh sách ngay, không loading treo, không cần F5.
- Verification: `get_diagnostics` — no issues. `npm run build` + kiểm thử thủ công: chưa chạy.
- Likely touched files:
  - `frontend_angular/src/app/hddt/cauhinh/thongtindoanhnghiep/doanhnghiep-chungthu-tab.component.ts`
  - `frontend_angular/src/app/hddt/cauhinh/thongtindoanhnghiep/doanhnghiep-chungthu-tab.component.html`
- Estimated scope: XS
