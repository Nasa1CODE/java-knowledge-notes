# CBCLOUDV2-8815 Expect

## Goal

Thông điệp `111` của tờ khai `01` chứng từ điện tử phải cập nhật được QLDV để trạng thái dịch vụ hoạt động và cho phép phát hành chứng từ bình thường sau khi CQT chấp nhận.

## Current Behavior

- `ProcessService` đã route `MLTDiep=111` vào `ThongDiep111Service`.
- `ThongDiep111Service` đã cập nhật nội bộ:
  - `VsServiceTax`
  - `VsChungTuKhauTruRegisterTax`
  - `VsTransactionLog`
  - `VsDoanhNghiepChungThu.chungthuDangky=true` khi `TTXNCQT=1`
- Logic gọi QLDV/callback trong `ThongDiep111Service` hiện đang bị comment, nên QLDV không nhận xác nhận trạng thái tờ khai `01` chứng từ điện tử.

## Expected Behavior

- Khi nhận thông điệp `111` và xử lý thành công, service phải gọi QLDV/callback theo cùng điều kiện hiện hành của luồng tờ khai `01`.
- Với `TTXNCQT=1`:
  - Nội bộ vẫn cập nhật `VsServiceTax.status = TCT_DA_CHAP_NHAN`.
  - Nội bộ vẫn cập nhật `VsChungTuKhauTruRegisterTax.status = TCT_DA_CHAP_NHAN`.
  - Vẫn set chứng thư đăng ký sang đã đăng ký.
  - Gửi QLDV/callback với trạng thái tương đương `TCT đã chấp nhận TK01`: `statusSendQLDV = 3`.
- Với `TTXNCQT=2`:
  - Nội bộ vẫn cập nhật `VsServiceTax.status = TCT_TU_CHOI_CHAP_NHAN`.
  - Nội bộ vẫn cập nhật `VsChungTuKhauTruRegisterTax.status = TCT_TU_CHOI_CHAP_NHAN`.
  - Vẫn ghi mã lỗi/lý do từ `TBao/DLTBao/DSLDKCNhan/LDo`.
  - Gửi QLDV/callback với trạng thái tương đương `TCT từ chối TK01`: `statusSendQLDV = 2`.

## Out Of Scope

- Không thay đổi route message `111`.
- Không thay đổi XML schema.
- Không thay đổi DB schema/migration.
- Không thay đổi logic xử lý `102`, `103`, `104`, `110`, `301`.
- Không thay đổi API contract của `guiXacNhanQLDV` hoặc `CallBackApiTK01`.
- Không thay đổi điều kiện tenant `DULIEU` hiện hành khi gọi `guiXacNhanQLDV`.
