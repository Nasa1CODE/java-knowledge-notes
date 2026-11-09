# CBCLOUDV2-9181 Tasks

## Task 1 - Fix checkbox CKTM khi edit hoa don thay the/dieu chinh

- Status: implementation complete, verification partially blocked
- Area/service: `frontend_angular`
- Related: `CBCLOUDV2-8919`
- Description: Khi edit hoa don thay the (`mau_HoaDon_Loai = 3`) hoac hoa don dieu chinh (`mau_HoaDon_Loai = 5`), checkbox "Hoa don chiet khau thuong mai" phai hien thi theo gia tri da luu cua hoa don hien tai (`quanLy_XacThuc_Loai`) thay vi bi copy lai tu `hoaDonGoc`.
- Root cause:
  - BE va DB da luu dung `QuanLy_XacThuc_Loai`.
  - API `GetHoaDon?Id=...&isView=false` tra dung top-level `quanLy_XacThuc_Loai = 0`.
  - Frontend sau khi load lai dang gan `hoaDon.quanLy_XacThuc_Loai = hoaDon.hoaDonGoc.quanLy_XacThuc_Loai` cho loai `3/5`, lam checkbox bi tick lai neu hoa don goc co gia tri `1`.
- Acceptance criteria:
  - [x] Tao moi hoa don thay the/dieu chinh van ke thua tick checkbox tu hoa don goc nhu task `CBCLOUDV2-8919`.
  - [x] Edit hoa don thay the/dieu chinh da co `id` khong copy lai `quanLy_XacThuc_Loai` tu `hoaDonGoc`.
  - [x] Checkbox bind theo `hoaDon.quanLy_XacThuc_Loai` cua hoa don hien tai khi load edit.
  - [x] Neu gia tri hien tai la `0`, checkbox phai bo tick.
  - [x] Neu gia tri hien tai la `1`, checkbox phai tick.
  - [x] Save sau khi tick/bo tick van gui dung top-level `quanLy_XacThuc_Loai`.

## Task 2 - Ra soat 3 man co checkbox CKTM

- Status: implementation complete, verification partially blocked
- Area/service: `frontend_angular`
- Description: Ap dung cung nguyen tac cho cac man da duoc mo trong `CBCLOUDV2-8919`, tranh sua le rieng man `hoadon-goc`.
- Files:
  - `src/app/hddt/hoadon/quanlyhoadon/hoadon-goc.component.ts`
  - `src/app/hddt/hoadon/hoadonbanhang/hoadonbanhang.component.ts`
  - `src/app/hddt/hoadon/vemaybay/vemaybay.component.ts`
- Acceptance criteria:
  - [x] Neu man co logic copy `hoaDonGoc.quanLy_XacThuc_Loai`, chi copy khi tao moi.
  - [x] Sau load, bien checkbox `tinhChatHoaDon` duoc set ca hai chieu true/false tu `hoaDon.quanLy_XacThuc_Loai`.

## Verification

- Manual QA truoc/sau save tren hoa don dieu chinh va thay the: pending.
- Build frontend: blocked by environment. `npm run build` fail voi Node 22/OpenSSL; rerun voi `NODE_OPTIONS=--openssl-legacy-provider` qua loi OpenSSL nhung fail do `node-sass@5.0.0` khong ho tro Node runtime 127.
