# CBCLOUDV2-8815 Impact

## Scope

Task chỉ thay đổi luồng xử lý thông điệp `111` trong `etran-teanant-service`.

## Affected Components

| Component | Impact | Note |
| --- | --- | --- |
| `ThongDiep111Service` | Medium | Bật call QLDV/callback sau khi xử lý kết quả CQT |
| `EtranService.guiXacNhanQLDV` | Indirect | Dùng lại method hiện có, không đổi contract |
| `EtranService.CallBackApiTK01` | Indirect | Dùng lại method hiện có, không đổi contract |
| `VsServiceTax` | Low | Vẫn update như hiện hành |
| `VsChungTuKhauTruRegisterTax` | Low | Vẫn update như hiện hành |
| `VsTransactionLog` | Low | Vẫn ghi log như hiện hành |
| QLDV | Medium | Bắt đầu nhận xác nhận cho thông điệp `111` |

## Unchanged

- Route `MLTDiep=111` trong `ProcessService`.
- Logic xử lý `102`.
- Logic xử lý `104`.
- Logic xử lý `301`.
- Kafka topic/consumer group.
- DB schema/migration.
- API contract của QLDV/callback.

## Business Impact

- Sau khi CQT chấp nhận tờ khai `01` chứng từ điện tử qua thông điệp `111`, QLDV được cập nhật để dịch vụ hoạt động và phát hành chứng từ bình thường.
- Khi CQT từ chối thông điệp `111`, QLDV nhận trạng thái từ chối tương ứng.
- Nội bộ tenant DB vẫn là nguồn update chính; QLDV/callback là side effect bổ sung.

## Risks

| Risk | Impact | Mitigation |
| --- | --- | --- |
| Message `111` bị reprocess | Có thể gửi QLDV/callback lặp | Kiểm tra idempotency phía QLDV theo `referenceId`/tenant/MST hoặc thêm guard nếu cần |
| Tenant không có trong `TENANT_INFO_MAP` | Có thể lỗi khi check tenant name | Cân nhắc null-safe giống các service khác nếu phát hiện rủi ro runtime |
| Callback domain cấu hình sai | Gọi callback lỗi | `EtranService` đã catch/log exception; cần kiểm tra log khi test |
| Mapping status sai | QLDV cập nhật sai trạng thái | Dùng mapping giống `104`: `3` chấp nhận, `2` từ chối |

## Verification Summary

- Cần unit test cả `TTXNCQT=1` và `TTXNCQT=2`.
- Cần regression `102/104`.
- Cần manual/integration để xác nhận QLDV thật cập nhật trạng thái hoạt động/phát hành chứng từ.
