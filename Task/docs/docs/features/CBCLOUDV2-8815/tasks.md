# CBCLOUDV2-8815 Tasks

## Planning

- [x] Xác nhận `MLTDiep=111` đã được route vào `ThongDiep111Service`.
- [x] Xác nhận `ThongDiep111Service` hiện đã update nội bộ nhưng call QLDV/callback đang bị comment.
- [x] Xác nhận pattern active từ `ThongDiep104Service`.
- [x] Tạo feature docs trong `docs/features/CBCLOUDV2-8815`.

## Implementation

- [x] Trong `ThongDiep111Service`, khai báo `Integer statusSendQLDV = null`.
- [x] Nhánh `TTXNCQT=1`: set `statusSendQLDV = 3` và comment rõ case TCT chấp nhận TK01.
- [x] Nhánh `TTXNCQT=2`: set `statusSendQLDV = 2` và comment rõ case TCT từ chối TK01.
- [x] Bật lại call `etranService.guiXacNhanQLDV(...)` theo điều kiện tenant `DULIEU`.
- [x] Bật lại call `etranService.CallBackApiTK01(...)` theo điều kiện `systemName=cloud` và cấu hình callback.
- [x] Không thay đổi logic trạng thái nội bộ của `111`.
- [x] Không thay đổi logic `102`, `104`, `301`.

## Test

- [x] Unit test `111` chấp nhận: `TTXNCQT=1`, gửi QLDV status `3`.
- [x] Unit test `111` từ chối: `TTXNCQT=2`, gửi QLDV status `2`.
- [x] Unit test callback active khi đủ config.
- [x] Unit test không gọi callback khi không phải `cloud`.
- [x] Unit test tenant không phải `DULIEU` thì không gọi QLDV/callback.
- [x] Source check `102`: logic QLDV/callback hiện hữu không bị sửa.
- [x] Source check `104`: logic QLDV/callback hiện hữu không bị sửa.
- [x] Source check `301`: không phát sinh call QLDV/TK01 callback.
- [ ] Manual/integration với XML `111` thật hoặc XML mẫu.

## Documentation

- [x] `expect.md`
- [x] `plan.md`
- [x] `tasks.md`
- [x] `testcase.md`
- [x] `impact.md`
- [x] `report.md` sau khi implement.
