# CBCLOUDV2-8815 Test Cases

## Unit Test Cases

### TC01 - 111 CQT chấp nhận

- Input XML: `MLTDiep=111`, `TBao/DLTBao/TTXNCQT=1`.
- Expected internal:
  - `VsServiceTax.status = TCT_DA_CHAP_NHAN`.
  - `VsChungTuKhauTruRegisterTax.status = TCT_DA_CHAP_NHAN`.
  - Chứng thư đăng ký được set `chungthuDangky=true`.
- Expected QLDV:
  - `statusSendQLDV = 3`.
  - Tenant `DULIEU`: gọi `guiXacNhanQLDV(mst, tenantId, 3, referenceId)`.

### TC02 - 111 CQT từ chối

- Input XML: `MLTDiep=111`, `TBao/DLTBao/TTXNCQT=2`, có `TBao/DLTBao/DSLDKCNhan/LDo`.
- Expected internal:
  - `VsServiceTax.status = TCT_TU_CHOI_CHAP_NHAN`.
  - `VsChungTuKhauTruRegisterTax.status = TCT_TU_CHOI_CHAP_NHAN`.
  - `VsServiceTax.responsecode = MLoi`.
  - `VsServiceTax.responsedescription = MTa`.
  - `VsChungTuKhauTruRegisterTax.errorCode = MLoi`.
  - `VsChungTuKhauTruRegisterTax.errorDescription = MTa`.
- Expected QLDV:
  - `statusSendQLDV = 2`.
  - Tenant `DULIEU`: gọi `guiXacNhanQLDV(mst, tenantId, 2, referenceId)`.

### TC03 - 111 callback TK01 active

- Điều kiện:
  - `systemName=cloud`.
  - `statusSendQLDV` khác null.
  - `VsDnCauHinh.isUsingCallbackApi = 1`.
  - `domainCallbackApi` có giá trị.
- Expected:
  - Gọi `CallBackApiTK01(mst, tenantId, statusSendQLDV, referenceId, domainCallbackApi)`.

### TC04 - 111 không callback khi thiếu config

- Điều kiện:
  - `systemName=cloud`.
  - `statusSendQLDV` khác null.
  - Không có `VsDnCauHinh` hoặc `isUsingCallbackApi != 1` hoặc `domainCallbackApi` rỗng.
- Expected:
  - Không gọi `CallBackApiTK01`.
  - Vẫn save nội bộ thành công.

### TC05 - 111 không gọi QLDV với tenant không phải DULIEU

- Điều kiện:
  - Tenant name không chứa `DULIEU`.
  - `statusSendQLDV` khác null.
- Expected:
  - Không gọi `guiXacNhanQLDV`.
  - Callback TK01 vẫn theo điều kiện `systemName=cloud` và cấu hình callback nếu có.

## Regression Cases

### TC06 - 102 giữ nguyên mapping

- Có `DSLDKCNhan/LDo`: `statusSendQLDV=1`.
- Không có `DSLDKCNhan/LDo`: `statusSendQLDV=2`.
- Không bị thay đổi bởi task này.

### TC07 - 104 giữ nguyên mapping

- `TTXNCQT=1`: `statusSendQLDV=3`.
- `TTXNCQT=2`: `statusSendQLDV=2`.
- Không bị thay đổi bởi task này.

### TC08 - 301 không phát sinh callback TK01

- Xử lý XML `301` bất kỳ.
- Expected:
  - Không gọi `guiXacNhanQLDV`.
  - Không gọi `CallBackApiTK01`.

## Manual/Integration Cases

### TC09 - 111 chấp nhận cập nhật QLDV hoạt động

- Gửi XML `111` có `TTXNCQT=1`.
- Check:
  - Tenant DB đã update `VsServiceTax` và `VsChungTuKhauTruRegisterTax`.
  - Log có request `GUI QLDV`.
  - QLDV cập nhật trạng thái dịch vụ chứng từ điện tử sang hoạt động/phát hành bình thường.

### TC10 - 111 từ chối cập nhật QLDV từ chối

- Gửi XML `111` có `TTXNCQT=2`.
- Check:
  - Tenant DB ghi mã lỗi/lý do.
  - Log có request `GUI QLDV` với status `2`.
  - QLDV hiển thị trạng thái từ chối tương ứng.
