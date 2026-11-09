# CBCLOUDV2-8761 Tasks

## Task 1 - Chuan hoa STT dong hang hoa ghi chu tren FE

- Status: completed
- Area/service: `frontend_angular/`
- Description: Them helper dung chung de danh lai STT chi tiet hoa don, bo qua dong `hangHoa_Loai == 2` (`Ghi chu/dien giai`) va gan `stt = null` cho dong ghi chu.
- Acceptance criteria:
  - [x] Dong `Ghi chu/dien giai` khong duoc danh STT tren bang chi tiet hoa don.
  - [x] Cac dong hang hoa khac duoc danh lai lien tuc `1, 2, 3...` theo thu tu hien tai sau khi load, them, xoa, doi loai hang hoa va import file tren FE.
  - [x] Ap dung helper cho cac man FE co dong hang hoa ghi chu: `hoadonbanhang`, `hoadon-goc`, `hoa-don-ban-tai-san-cong`, `hoadondiennuoc`, `vemaybay`, `phieuxuatnhapkho`, `phieuxuatkhonoibo`.
  - [x] Khong thay doi backend/save API trong task nay.
- Verification:
  - [x] Source search khong con logic chay `stt = i + 1`, `stt = counter`, hoac `stt = dsChiTiet.length + 1` trong cac man da sua.
  - [x] `git diff --check` pass, chi co warning line-ending CRLF cua repo.
  - [ ] Frontend build: chua pass tren may hien tai do Node 22 khong tuong thich stack cu (`webpack` OpenSSL legacy va `node-sass@5` voi Node runtime 127). Can build lai bang Node phu hop hoac nang dependency truoc khi merge.

## Task 2 - QA thu cong tren man hoa don

- Status: pending
- Area/service: `frontend_angular/`
- Description: Kiem tra thao tac thuc te tren cac route hoa don co dong `Ghi chu/dien giai`.
- Acceptance criteria:
  - [ ] Tao/mo hoa don co it nhat 3 dong: hang hoa, ghi chu, hang hoa; STT hien thi `1`, rong, `2`.
  - [ ] Doi mot dong hang hoa thanh ghi chu; cac dong con lai duoc danh lai dung thu tu.
  - [ ] Xoa/them/import dong hang hoa sau dong ghi chu; STT van lien tuc va dong ghi chu khong co STT.
  - [ ] Luu tam/trinh ky/ky khong bi anh huong boi thay doi FE-only nay.
- Verification: [ ] QA tren route `app/hddt/hoadon-hoadonbanhang-goc?id=2000373321` va cac man hoa don ghi chu con lai neu co du lieu mau.
