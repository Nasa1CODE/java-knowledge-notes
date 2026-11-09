# CBCLOUDV2-8815 Plan

## Goal

Fix `etran-teanant-service` để thông điệp `111` của tờ khai `01` chứng từ điện tử gọi QLDV/callback sau khi CQT trả kết quả, giúp QLDV cập nhật trạng thái hoạt động và cho phép phát hành chứng từ bình thường.

## Context

- `ProcessService` đã support `MLTDiep=111` và route vào `ThongDiep111Service.handleThongDiep111(...)`.
- `ThongDiep111Service` đang xét trạng thái theo `TBao/DLTBao/TTXNCQT`.
- `TTXNCQT=1` hiện set:
  - `VsServiceTax.status = TCT_DA_CHAP_NHAN`
  - `VsChungTuKhauTruRegisterTax.status = TCT_DA_CHAP_NHAN`
  - `VsDoanhNghiepChungThu.chungthuDangky = true`
- `TTXNCQT=2` hiện set:
  - `VsServiceTax.status = TCT_TU_CHOI_CHAP_NHAN`
  - `VsChungTuKhauTruRegisterTax.status = TCT_TU_CHOI_CHAP_NHAN`
  - mã lỗi/lý do từ `TBao/DLTBao/DSLDKCNhan/LDo/MLoi` và `MTa`
- `ThongDiep111Service` đã có đoạn `statusSendQLDV`, `guiXacNhanQLDV`, `CallBackApiTK01` nhưng đang comment.
- `ThongDiep104Service` là pattern active gần nhất cho callback TK01 sau khi CQT chấp nhận/từ chối chấp nhận.

## Affected Files

- `etran-teanant-service/src/main/java/vn/sample/multitenancy/service/ThongDiep111Service.java`
  - Bật lại và chuẩn hóa logic `statusSendQLDV`.
  - Bật lại call `etranService.guiXacNhanQLDV(...)`.
  - Bật lại call `etranService.CallBackApiTK01(...)`.
- Test file dự kiến:
  - `etran-teanant-service/src/test/java/vn/sample/multitenancy/service/ThongDiep111ServiceTest.java`

## Implementation Plan

1. Giữ nguyên toàn bộ logic nghiệp vụ hiện có của thông điệp `111`:
   - tìm `VsServiceTax` theo `MTDTChieu`;
   - tìm `VsChungTuKhauTruRegisterTax` theo `VsServiceTax.referenceId`;
   - parse `TTXNCQT`;
   - cập nhật `VsServiceTax`;
   - cập nhật `VsChungTuKhauTruRegisterTax`;
   - cập nhật `VsDoanhNghiepChungThu.chungthuDangky=true` khi CQT chấp nhận;
   - ghi `VsTransactionLog`.
2. Khai báo lại biến:
   - `Integer statusSendQLDV = null;`
3. Trong nhánh `TTXNCQT=1`, sau khi cập nhật trạng thái chấp nhận:
   - set `statusSendQLDV = 3`.
   - Ý nghĩa: `TCT đã chấp nhận TK01`.
4. Trong nhánh `TTXNCQT=2`, sau khi cập nhật trạng thái từ chối:
   - set `statusSendQLDV = 2`.
   - Ý nghĩa: `TCT từ chối TK01`.
5. Sau khi save nội bộ hoặc trước phần log cuối, bật lại call QLDV theo đúng điều kiện đang dùng ở `ThongDiep104Service`:
   - Nếu `BillVariable.TENANT_INFO_MAP.get(String.valueOf(tenantId)).getTenantName().contains("DULIEU")`
   - và `statusSendQLDV` khác null
   - thì gọi `etranService.guiXacNhanQLDV(mst, String.valueOf(tenantId), statusSendQLDV, vsServiceTax.getReferenceId())`.
6. Bật lại callback TK01 theo đúng điều kiện đang dùng ở `ThongDiep104Service`:
   - Nếu `systemName.equals("cloud")`
   - và `statusSendQLDV` khác null
   - tìm `VsDnCauHinh` theo MST;
   - nếu `dnCauHinh != null`, `isUsingCallbackApi == 1`, `domainCallbackApi` không rỗng
   - thì gọi `etranService.CallBackApiTK01(mst, String.valueOf(tenantId), statusSendQLDV, vsServiceTax.getReferenceId(), dnCauHinh.getDomainCallbackApi())`.
7. Không đổi mapping của `102` và `104`.
8. Không thêm call QLDV cho thông điệp `301`.
9. Không thay đổi chữ ký method `EtranService.guiXacNhanQLDV` và `EtranService.CallBackApiTK01`.

## Status Mapping

| Message | Condition | statusSendQLDV | Meaning |
| --- | --- | --- | --- |
| `102` | Có `DSLDKCNhan/LDo` | `1` | TCT từ chối tiếp nhận TK01 |
| `102` | Không có `DSLDKCNhan/LDo` | `2` | TCT tiếp nhận TK01 |
| `104` | `TTXNCQT=1` | `3` | TCT đã chấp nhận TK01 |
| `104` | `TTXNCQT=2` | `2` | TCT từ chối TK01 |
| `111` | `TTXNCQT=1` | `3` | TCT đã chấp nhận TK01 chứng từ điện tử |
| `111` | `TTXNCQT=2` | `2` | TCT từ chối TK01 chứng từ điện tử |

## Impact Assessment

- Có thay đổi integration side effect của `111`: sau khi xử lý sẽ có call QLDV/callback.
- Không thay đổi trạng thái nội bộ đã set cho `111`.
- Không thay đổi DB schema.
- Không thay đổi route Kafka/message.
- Không thay đổi `102/104`; chỉ dùng làm pattern.
- Rủi ro chính là gửi callback lặp nếu cùng message `111` được reprocess nhiều lần. Cần kiểm tra cơ chế hiện hành của `VsServiceTax`/`VsTransactionLog` và phía QLDV có idempotent theo `referenceId`/tenant/MST hay không.

## Verification Plan

1. Unit test `TTXNCQT=1`:
   - `VsServiceTax.status = TCT_DA_CHAP_NHAN`.
   - `VsChungTuKhauTruRegisterTax.status = TCT_DA_CHAP_NHAN`.
   - `statusSendQLDV = 3`.
   - Với tenant `DULIEU`, verify gọi `guiXacNhanQLDV(..., 3, referenceId)`.
2. Unit test `TTXNCQT=2`:
   - `VsServiceTax.status = TCT_TU_CHOI_CHAP_NHAN`.
   - `VsChungTuKhauTruRegisterTax.status = TCT_TU_CHOI_CHAP_NHAN`.
   - Lấy đúng `MLoi/MTa` từ `DSLDKCNhan/LDo`.
   - `statusSendQLDV = 2`.
   - Với tenant `DULIEU`, verify gọi `guiXacNhanQLDV(..., 2, referenceId)`.
3. Unit test callback:
   - `systemName=cloud`, `isUsingCallbackApi=1`, có `domainCallbackApi`: verify gọi `CallBackApiTK01`.
   - `systemName` khác `cloud`: không gọi `CallBackApiTK01`.
   - Không có domain callback: không gọi `CallBackApiTK01`.
4. Regression:
   - `102` vẫn giữ mapping `1/2`.
   - `104` vẫn giữ mapping `3/2`.
   - `301` không phát sinh call QLDV/TK01 callback.
5. Manual/integration:
   - Đẩy XML `111` chấp nhận vào Kafka hoặc gọi consumer với XML mẫu.
   - Kiểm tra DB tenant đã update.
   - Kiểm tra log có request `GUI QLDV`.
   - Kiểm tra QLDV đã cập nhật dịch vụ chứng từ điện tử sang hoạt động/phát hành bình thường.

## Rollback

- Comment hoặc revert lại các đoạn gọi QLDV/callback trong `ThongDiep111Service`.
- Giữ nguyên phần cập nhật nội bộ của `111`.
