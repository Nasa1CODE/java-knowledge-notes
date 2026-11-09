# CBCLOUDV2-8393 Report

## Changed

- Backend import route các block tạo `HD_ThueSuat` qua helper/group theo `MaThue + MucThue`.
- Không group theo `HangHoa_TenThue` cho summary import GTGT.
- `TongTien_ChiuThue` và `TongTien_Thue` trong summary là tổng dữ liệu đã import/lưu, không tự tính lại theo VAT%.
- Tên thuế ưu tiên lấy từ Admin, fallback tên chi tiết nếu cần.
- Service import GTGT nền trong `svinvoicesendemail` đã được sync code với Cloud theo scope hiện tại.
- VE_XE import Cloud đã xử lý `Tinh chat hang hoa = 5` thành chiết khấu và service nền `svinvoicesendemail` đã được đồng bộ theo cùng rule.

## Verification

- Backend build `HDDT.Application` đã từng pass với 0 errors; existing warnings remain.
- Frontend build/package không chạy trong phần cập nhật docs này.
- Manual import cases vẫn cần tester xác nhận theo `testcase.md`.

## Notes

- Không đổi DB schema/migration/backfill.
- Không đổi XML/ký số/truyền CQT/báo cáo/bảng kê.
- Multi-real-tax + CKTM vẫn giữ behavior fail import theo scope.
- Generic FE discount edit calculation nằm ở `CBCLOUDV2-8332`.
## Service Nền Status

- `svinvoicesendemail` GTGT/VE_XE import nền đang ở trạng thái đối chiếu; chưa coi là đồng bộ hoàn tất với Cloud.
- Không dùng report này để kết luận pass cho service nền cho tới khi Task 6 hoàn tất.
## Service Nền Sync Result

- GTGT service nền: group summary theo `MaThue + MucThue`, dòng chiết khấu/CKTM được cộng dồn theo dữ liệu import.
- VE_XE service nền: `Tinh chat hang hoa = 5` đổi sang `Chiết khấu`, giữ `Tien thue chi tiet`, summary bên trái tự tổng hợp lại.
- Build solution `AppServiceImportBillHost` pass 0 errors.
## Update 2026-07-30 - CLOUD blank right-side totals + edit regression

Changed:
- Backend Cloud GTGT now tracks whether Excel right-side total fields were actually provided.
- Blank Excel totals are no longer treated as intentional zero; they fallback after details and HD_ThueSuat are built.
- Service nen GTGT in svinvoicesendemail is synced with the same HasInput/fallback logic.
- FE right-side TongHop_TienThue edit now uses suaTongThanhTien, matching *_11 expected behavior.

Verification:
- dotnet build HDDT.Application: passed, 0 errors; existing warnings remain.
- dotnet build AppServiceImportBillHost/AppService.sln: passed, 0 errors; existing warnings remain.
- FE package/publish was not run. FE change is 2-line handler-only diff.

Pending manual test:
- CLOUD *_11, *_12, *_14, *_15, *_16, *_17, *_19 from the testcase workbook.
- GTGT service nen >50 rows for the same blank-total fallback behavior.

## Update 2026-08-03 - Documentation Recheck Before Other Services

- Rechecked `CBCLOUDV2-8393` against the current import/backend/service fixes before starting similar service work.
- `8393` remains the source of truth for import summary grouping, right-side total fallback/preserve, GTGT service nền, and VE_XE service nền behavior.
- `8332` remains the source of truth for FE edit/preserve behavior on imported invoices with discount rows.
- Added explicit guardrails and service-sync testcase templates so each additional service can be documented before code sync.
- Manual verification is still required per service; synced code and docs do not imply pass until service-specific import cases are run.

## Update 2026-09-04 - Import Decimal(21,7) Max Value

Changed:
- Backend import đồng bộ `invoicecore` đổi kiểm tra max của Số lượng, Đơn giá và Thành tiền sang giá trị tối đa theo `DECIMAL(21,7)`: `99999999999999.9999999`.
- Backend import đồng bộ `invoicecore` đổi Tỷ giá sang rule riêng: tối đa 7 số nguyên và 6 số thập phân, max `9999999.999999`.
- Helper `NewCa` trong `invoicecore` cũng dùng cùng giá trị max `DECIMAL(21,7)` cho Số lượng, Đơn giá và Thành tiền.
- Worker import nhiều dòng `svinvoicesendemail/AppServiceImportBillHost` đồng bộ cùng giá trị max `DECIMAL(21,7)` cho Số lượng, Đơn giá, Thành tiền trong các helper GTGT, Bán hàng, Vé xe và Phiếu xuất kho.
- Worker import nhiều dòng GTGT/Bán hàng/Vé xe đồng bộ Tỷ giá theo rule 7 số nguyên và 6 số thập phân.
- Riêng Phiếu xuất kho worker không thêm check Tỷ giá vì helper hiện không parse/gán `tygiatiente`.
- Không đổi DB schema, migration, XML, ký số, truyền CQT, báo cáo hoặc logic làm tròn hiện có.

Verification:
- `dotnet build svinvoicesendemail/AppServiceImportBillHost/AppService/AppService.csproj --no-restore`: passed, 0 errors; existing warnings remain.
- `dotnet build invoicecore/aspnet-core/src/hddt/HDDT.Application/HDDT.Application.csproj --no-restore`: passed, 0 errors; existing warnings remain.
- `docs` repo chưa pull được trong phiên này do GitLab credential prompt không có TTY: `fatal: could not read Username`.

Pending manual test:
- Import trực tiếp và import nhiều dòng qua service nền với Số lượng/Đơn giá/Thành tiền đúng bằng `99999999999999.9999999` phải pass.
- Số lượng/Đơn giá/Thành tiền lớn hơn max, ví dụ `100000000000000`, phải báo lỗi vượt quá giá trị tối đa cho đúng field.
- Tỷ giá đúng bằng `9999999.999999` phải pass; Tỷ giá quá 7 số nguyên hoặc quá 6 số thập phân phải báo `Tỷ giá không được vượt quá 9999999.999999.`
