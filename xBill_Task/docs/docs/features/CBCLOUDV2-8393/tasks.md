# CBCLOUDV2-8393 Tasks

## Task 1 - Impact Review + Docs

- [x] Đọc Word spec và xác nhận rule: cùng thuế suất theo ID hệ thống phải group một dòng.
- [x] Ghi rõ `HD_ChiTiet` lưu riêng, chỉ gom `HD_ThueSuat`.
- [x] Ghi rõ không tính lại tiền thuế theo VAT%; chỉ cộng dồn dữ liệu import.
- [x] Ghi rõ nhiều VAT thật + CKTM vẫn fail import như hiện tại.

## Task 2 - Backend Import GTGT

- [x] Tạo/helper hóa logic summary cho các block import GTGT đang group theo tên thuế.
- [x] Group `HD_ThueSuat` theo `HangHoa_MaThue + HangHoa_Thue`.
- [x] Bỏ `HangHoa_TenThue` khỏi key group để dòng âm/CKTM/chiết khấu không tách dòng riêng.
- [x] `TongTien_ChiuThue` và `TongTien_Thue` chỉ `Sum` từ dữ liệu đã import/lưu.
- [x] `TenThue` lấy từ Admin, fallback tên import nếu cần.

## Task 3 - Frontend Display/Tính Tổng Cho Import

- [x] CKTM giữ field `tongHop_TongTien_KhoanKhac`.
- [x] Tổng CKTM giữ field/tính `tongHop_TongTien_ChietKhau_ThuongMai`.
- [x] Bảng “Thông tin từng loại thuế” hiển thị khi backend trả một dòng `dsThueSuat`.
- [x] Mở sửa `tongTien_ChiuThue` cho các dòng summary thuế.
- [x] Sửa tay `tongTien_ChiuThue` chỉ tính lại tổng phụ thuộc, không rebuild `dsThueSuat`.

## Task 4 - Test/Regression + Report

- [ ] Backend build.
- [ ] Frontend build nếu môi trường cho phép.
- [ ] Manual import case `10%` có dòng âm: expected một dòng `10% | 170.000 | -1.000`.
- [ ] Manual import case `KKK + KKKNT` cùng ID có CKTM.
- [ ] Manual import case nhiều VAT thật + CKTM vẫn fail.
- [ ] Cập nhật `testcase.md` và `report.md` bằng kết quả thật.

## Task 5 - Service Import GTGT (>50 dòng)

- [x] Xác nhận điều kiện chuyển service nền: GTGT có `soLuongHangHoa > 50` và `ENABLE_IMPORT_SERVICE = 1`.
- [x] Sửa `AppServiceImportBillHost` GTGT helper để group `HD_ThueSuat` theo `MaThue + MucThue`.
- [x] Service GTGT truyền danh mục thuế suất vào helper để `TenThue` ưu tiên lấy theo Admin, fallback tên trên chi tiết.
- [x] Dòng CKTM synthetic trong service GTGT không tự tính lại tiền thuế theo VAT%.
- [x] Không sửa phiếu xuất kho, bán hàng, chứng từ ngoài scope.
- [ ] Build service import nếu môi trường cho phép.
- [ ] Manual test GTGT 50 dòng và 51 dòng.

## Cloud VE_XE Import Fix - 2026-07-29

- [x] Backend: map VE_XE `Tinh chat hang hoa = 5` thành `Chiết khấu` cho dòng chi tiết import.
- [x] Backend: build VE_XE `HD_ThueSuat` để dòng chiết khấu giảm summary bên trái.
- [x] Frontend: giữ tổng bên phải của VE_XE import khi `tinhTongChi()` chạy.
- [ ] Tester: chạy manual VE_XE import cases trong `testcase.md`.

## Cross Reference - FE Discount Task

- Generic FE discount edit calculation được theo dõi trong `CBCLOUDV2-8332`.
- `CBCLOUDV2-8393` giữ scope import/tax-summary grouping.
## Task 6 - Service Nền Sync Review

- [x] Đối chiếu `D:\XBill\Cloud\svinvoicesendemail\AppServiceImportBillHost\AppService\Service\NhapDSHoaDonExcelHelper.cs` với Cloud.
- [x] Đồng bộ rule group `HD_ThueSuat` theo `MaThue + MucThue`.
- [x] Đồng bộ cách tính summary GTGT: chi tiết lưu riêng, `TongTien_ChiuThue`/`TongTien_Thue` chỉ cộng dồn dữ liệu import.
- [x] Đối chiếu `D:\XBill\Cloud\svinvoicesendemail\AppServiceImportBillHost\AppService\Service\ImportVeXeHelper.cs` với Cloud.
- [x] Đồng bộ rule `Tinh chat hang hoa = 5` sang `Chiết khấu` cho VE_XE nền.
- [x] Kiểm tra lại phần `Tien thue chi tiet` và tổng bên phải để không bị tính ngược.
- [ ] Manual test GTGT service nền `>50` dòng.
- [ ] Manual test VE_XE service nền.
- [ ] Cập nhật `testcase.md` và `report.md` sau khi sync xong.
## Task 7 - CLOUD cases *_11/_12/_14/_15/_16/_17/_19 - 2026-07-30

- [x] Backend GTGT: add HasInput flags for right-side Excel totals: tongtienhang, tongtienthue, tongtienthanhtoan, tongtienchietkhauthuongmai.
- [x] Backend GTGT: if Excel leaves total blank, fallback from built detail/tax summary.
- [x] Backend GTGT: if Excel provides total, keep imported value and do not overwrite.
- [x] Backend GTGT: fallback TongHop_TienThue = Sum(HD_ThueSuat.TongTien_Thue).
- [x] Backend GTGT: fallback TongHop_TongTien_ChuaVAT = Sum(HD_ThueSuat.TongTien_ChiuThue).
- [x] Backend GTGT: fallback TongHop_TongTien_ChietKhau_ThuongMai = discount lines + line discount + invoice CKTM.
- [x] Backend GTGT: fallback TongHop_TongTien_CoVAT = TongHop_TongTien_ChuaVAT + TongHop_TienThue.
- [x] Service nen GTGT: sync the same HasInput/fallback logic in AppServiceImportBillHost.
- [x] FE regression *_11: right-side TongHop_TienThue edit now calls suaTongThanhTien, so payment total/words update without rebuilding dsThueSuat.
- [x] FE regression *_14: right-side TongHop_TongTien_ChuaVAT already uses suaTongThanhTien; kept as regression case.
- [x] Build backend Cloud: pass 0 errors.
- [x] Build AppServiceImportBillHost: pass 0 errors.
- [ ] Manual import/test sheet CLOUD cases *_11, *_12, *_14, *_15, *_16, *_17, *_19.

## Update 2026-08-03 - Pre-Service Sync Checklist

- [x] Docs: rechecked `CBCLOUDV2-8393` import/backend/service scope before applying similar fixes to other services.
- [x] Rule source for service sync: `HD_ThueSuat` group by `HangHoa_MaThue + HangHoa_Thue`, not `HangHoa_TenThue`.
- [x] Rule source for totals: preserve Excel/API right-side totals when provided; fallback from built tax summary when blank.
- [x] Rule source for discount/CKTM: sum imported/saved amount and tax; do not recalculate tax by VAT% or subtract discount twice.
- [x] Cross-reference: FE edit/save behavior for imported invoices with discount is documented in `CBCLOUDV2-8332`.
- [ ] For each additional service: add service-specific testcase before code sync and mark manual verification separately.

## Update 2026-09-04 - Decimal(21,7) Max Value For Import Numbers

- [x] Confirm rule: Số lượng/Đơn giá/Thành tiền theo `DECIMAL(21,7)` allows maximum value `99999999999999.9999999`.
- [x] Confirm rule: Tỷ giá tối đa 7 số nguyên và 6 số thập phân, max `9999999.999999`.
- [x] Update `invoicecore` import Excel helpers to compare Số lượng/Đơn giá/Thành tiền against `MAX_DECIMAL_21_7_VALUE` instead of counting integer digits.
- [x] Update `invoicecore` Tỷ giá validation to enforce 7 integer digits and 6 decimal digits.
- [x] Update `svinvoicesendemail/AppServiceImportBillHost` worker helpers for import nhiều dòng so Số lượng, Đơn giá, Thành tiền use the same `DECIMAL(21,7)` max value.
- [x] Update applicable worker Tỷ giá validation to enforce 7 integer digits and 6 decimal digits.
- [x] Keep rounding behavior unchanged.
- [x] Build `HDDT.Application` with 0 errors.
- [x] Build `AppServiceImportBillHost/AppService.csproj` with 0 errors.
- [ ] Manual test direct import and service import with boundary values.
