# CBCLOUDV2-8393 Test Cases

| Case | Expected | Actual | Status |
| --- | --- | --- | --- |
| Backend build `HDDT.Application` | Build succeeds with 0 errors | Build succeeded with 0 errors; existing warnings remain | passed |
| Frontend production build | Build succeeds | `yarn.cmd run build` exceeded timeout and background build was stopped | blocked |
| `KKK + KKKNT` same ID with CKTM | Import pass; details separate; one `HD_ThueSuat` row | Not run in this session | not run |
| `KKK + KKKNT` same ID without CKTM | Import pass; one `HD_ThueSuat` row | Not run in this session | not run |
| `10% + 10%` | Existing grouping unchanged | Not run in this session | not run |
| `KKKNT + 10%` with CKTM | Import fail as current behavior | Not run in this session | not run |
| Required amount example | `18.000.000 - 10.000 = 17.990.000`, tax `0` | Not run in this session | not run |

## Tester Checklist

| Case | Expected |
| --- | --- |
| Import/API `10%` có dòng âm `-10.000`, tiền thuế `-1.000` | `HD_ThueSuat` một dòng `10%`, tổng chưa thuế cộng dồn, tổng thuế cộng dồn; không tự đổi thuế thành `17.000` nếu import không gửi vậy. |
| Import/API `KKK + KKKNT` cùng ID | Chi tiết lưu riêng; summary một dòng; tên thuế theo Admin. |
| Import/API cùng thuế suất thường `10% + 10%`, `5% + 5%`, `0% + 0%` | Summary gom một dòng theo từng thuế suất. |
| Nhiều VAT thật + CKTM | Vẫn fail import như hiện tại. |
| Nhiều VAT thật không CKTM | Giữ behavior hiện tại, summary nhiều dòng theo từng VAT thật. |
| FE hóa đơn gốc từ Import/API | `Tổng tiền chưa thuế` cho sửa; sửa xong tổng phụ thuộc cập nhật, không rebuild `dsThueSuat`. |

## Service Import GTGT Checklist

| Case | Expected |
| --- | --- |
| GTGT đúng 50 dòng hàng hóa | Không chuyển service nền; xử lý qua backend chính. |
| GTGT 51 dòng hàng hóa, `ENABLE_IMPORT_SERVICE = 1` | Chuyển service nền, tạo `HD_HoSo.HoSo_Loai = Service`, queue `TypeHd == gtgt`. |
| GTGT service nền 51 dòng, cùng VAT `10%`, có dòng âm/CKTM | `HD_ChiTiet` giữ riêng; `HD_ThueSuat` một dòng `10%`; tổng chưa thuế/tổng thuế cộng dồn dữ liệu import. |
| GTGT service nền 51 dòng, `KKK + KKKNT` cùng ID | Summary gom một dòng theo `MaThue + MucThue`. |
| GTGT service nền nhiều hóa đơn trong cùng file | Mỗi hóa đơn có `HD_ThueSuat` riêng theo `TongHop_Id`; không cộng lẫn summary giữa các mã hóa đơn. |
| GTGT service nền nhiều VAT thật + CKTM | Giữ behavior hiện tại. |

## Cloud VE_XE Import Checklist - 2026-07-29

| Case | Expected |
| --- | --- |
| VE_XE import có 4 detail rows, mỗi dòng `Tien thue chi tiet = 1.000`, CKTM `100`, VAT `8%` | Details giữ `1.000`; left tax summary có thể trừ thuế CKTM; right-side `TongHop_TienThue` giữ đúng giá trị import. |
| VE_XE import có `Tinh chat hang hoa = 5` với amount/tax dương | Detail hiển thị `Chiết khấu`; left `HD_ThueSuat` trừ amount và tax khỏi VAT group tương ứng. |
| VE_XE import có `Tinh chat hang hoa = 5` với amount/tax âm nếu validation cho phép | Summary giữ dấu âm và không trừ hai lần. |
| VE_XE import không nhập `Tien thue chi tiet` | Detail fallback công thức VAT; left summary dùng fallback đó; right-side totals vẫn ưu tiên field tổng import. |
| Edit left tax summary trên hóa đơn VE_XE import | Left summary đổi; right-side totals không bị overwrite từ `dsThueSuat`. |
## Service Nền Sync Checklist - svinvoicesendemail

| Case | Expected |
| --- | --- |
| GTGT service nền 51 dòng | Đồng bộ code xong; tester cần verify summary/grouping và right-side totals. |
| VE_XE service nền `Tinh chat = 5` | Đồng bộ code xong; tester cần verify detail là chiết khấu và right-side totals giữ theo import. |
| VE_XE service nền tiền thuế chi tiết | `Tien thue chi tiet` được giữ theo file nếu đã cung cấp. |
## CLOUD cases *_11/_12/_14/_15/_16/_17/_19 - 2026-07-30

| Case | Expected | Code status | Manual status |
| --- | --- | --- | --- |
| *_11 | Edit right-side TongHop_TienThue updates TongHop_TongTien_CoVAT and TongHop_TongTien_CoVAT_Chu; does not rebuild dsThueSuat | FE handler changed to suaTongThanhTien | not run |
| *_12 | If Excel total tax is blank, TongHop_TienThue = Sum(HD_ThueSuat.TongTien_Thue). Example 65,000 + (-10,000) = 55,000 | Backend + service fallback added | not run |
| *_14 | Edit right-side TongHop_TongTien_ChuaVAT updates payment total and words; does not rebuild dsThueSuat | Existing handler uses suaTongThanhTien; kept for regression | not run |
| *_15 | If Excel total goods is blank, TongHop_TongTien_ChuaVAT = Sum(HD_ThueSuat.TongTien_ChiuThue). Example 600,000 + (-200,000) = 400,000 | Backend + service fallback added | not run |
| *_16 | If total commercial discount is blank with one VAT, calculate discount lines + line discount + invoice CKTM | Backend + service fallback added | not run |
| *_17 | If total commercial discount is blank with multiple VAT, use same discount formula and do not depend on VAT count | Backend + service fallback added | not run |
| *_19 | If payment total is blank, TongHop_TongTien_CoVAT = final goods total + final tax total | Backend + service fallback added | not run |

Regression notes:
- Excel totals provided by file are preserved.
- HD_ChiTiet still saves each imported detail row separately.
- HD_ThueSuat still groups by HangHoa_MaThue + HangHoa_Thue.
- Discount line HangHoa_Loai = 3 contributes negative value to tax summary: positive import amount is converted to negative for summary; already negative value is kept.
- Many real VAT + invoice-level CKTM keeps current fail-import behavior.

## Update 2026-08-03 - Additional Service Sync Cases

| Case | Expected | Status |
| --- | --- | --- |
| Service import with same VAT and discount/negative line | `HD_ChiTiet` keeps separate rows; `HD_ThueSuat` has one row per `MaThue + MucThue`; amount/tax are summed from imported data | template for next service |
| Service import with right-side totals provided | `TongHop_TongTien_ChuaVAT`, `TongHop_TienThue`, `TongHop_TongTien_CoVAT`, CKTM totals keep imported values | template for next service |
| Service import with right-side totals blank | Right-side totals fallback from built `HD_ThueSuat` after summary is created | template for next service |
| Service import discount amount/tax positive | If mapped as discount row, summary treats it as reduction and does not create a separate tax-name group | template for next service |
| Service import discount amount/tax negative | Summary keeps negative contribution and does not subtract twice | template for next service |
| FE save/open after service-created import invoice | Covered by `CBCLOUDV2-8332`; must still be manually checked because FE can overwrite service-correct totals on save | cross-task |

## Update 2026-09-04 - Decimal(21,7) Max Value Cases

| Case | Expected | Status |
| --- | --- | --- |
| Import trực tiếp `invoicecore` với Số lượng = `99999999999999.9999999` | Không báo lỗi max value | not run |
| Import trực tiếp `invoicecore` với Đơn giá/Thành tiền = `99999999999999.9999999` | Không báo lỗi max value | not run |
| Import trực tiếp `invoicecore` với Tỷ giá = `9999999.999999` | Không báo lỗi max/precision Tỷ giá | not run |
| Import trực tiếp `invoicecore` với Tỷ giá quá 7 số nguyên hoặc quá 6 số thập phân | Báo lỗi `Tỷ giá không được vượt quá 9999999.999999.` | not run |
| Import trực tiếp `invoicecore` với Số lượng/Đơn giá/Thành tiền = `100000000000000` | Báo lỗi vượt quá giá trị tối đa đúng tên field | not run |
| Import nhiều dòng qua `svinvoicesendemail` GTGT/Bán hàng/Vé xe với Số lượng/Đơn giá/Thành tiền = `99999999999999.9999999` | Không báo lỗi max value do service nền dùng cùng biên max | not run |
| Import nhiều dòng qua `svinvoicesendemail` GTGT/Bán hàng/Vé xe với Tỷ giá = `9999999.999999` | Không báo lỗi max/precision Tỷ giá do service nền dùng cùng rule | not run |
| Import nhiều dòng qua `svinvoicesendemail` GTGT/Bán hàng/Vé xe với Tỷ giá quá 7 số nguyên hoặc quá 6 số thập phân | Báo lỗi `Tỷ giá không được vượt quá 9999999.999999.` | not run |
| Import nhiều dòng qua `svinvoicesendemail` Phiếu xuất kho với Số lượng thực xuất/thực nhập, Đơn giá, Thành tiền = `99999999999999.9999999` | Không báo lỗi max value | not run |
| Import nhiều dòng qua `svinvoicesendemail` với Số lượng/Đơn giá/Thành tiền lớn hơn `99999999999999.9999999` | Báo lỗi vượt quá giá trị tối đa trước khi lưu DB | not run |
