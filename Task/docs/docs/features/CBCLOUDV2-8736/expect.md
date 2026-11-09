# CBCLOUDV2-8736 Expect

## Scope

Thay doi tong tien 406 cho `/app/hddt/hoadon-hoadonbanhang-goc` trong `frontend_angular/`. Shared service chi chay branch moi khi caller truyen `apDungTongTienBanHang406 === true`; scope caller va route con pending code verification.

## Membership va cong thuc

- Valid monetary row co `tongTien_ChuaThue` finite. `khuyenMai: true` khong contribute, dung nhu code hien co.
- Branch active iff context true, `loaiHoaDon406 > 0`, va co >= 1 valid monetary non-promotion row co finite `vat_Rate > 0`.
- Positive-rate rows vao group theo `vat_Rate`: goods la `hangHoa_Loai != 3`, discount product la `hangHoa_Loai == 3`; rate factor = `vat_Rate / 100`; missing side = 0.
- `groupReduction = (goodsByRate - discountByRate) * (vatRate / 100) * 0.20` va `groupedReductionTotal` la tong signed reductions.
- Valid monetary non-promotion row co `vat_Rate` null, NaN/nonfinite, zero, hoac am la ungrouped legacy contribution: goods cong signed `tongTien_ChuaThue` theo existing sign convention `dieuChinh_TangGiam + '' == 'false' ? -1 : 1`; discount product tru signed `tongTien_ChuaThue` theo current sales-invoice legacy semantics; VAT reduction cua row = 0. Day la code-derived convention can xac minh lai khi trien khai; fixture `dieuChinh_TangGiam:true` dung sign `+1`.
- Exact special total: `tongHop_TienHang = groupedGoodsTotal - groupedReductionTotal - groupedDiscountProductTotal - invoiceCommercialDiscount + ungroupedGoodsSigned - ungroupedDiscountProductSigned`.
- `perLineDiscountTotal` = tong `tongTien_ChietKhau` cua goods/service rows, nhung da nam trong `tongTien_ChuaThue` va khong tru lan nua. `commercialDiscountTotal = groupedDiscountProductTotal + ungroupedDiscountProductTotal + perLineDiscountTotal + invoiceCommercialDiscount`; gan `tongHop_TongTien_ChietKhau_ThuongMai = null` neu zero, nguoc lai giu signed amount. `invoiceCommercialDiscount = tongHop_TongTien_KhoanKhac`, null = 0.
- Khong dung `Math.abs` trong aggregate. `tongHop_TienThue` giu output `tinhChiTietThue_406()`; payment = total goods + total tax. Tinh full precision va chi apply `lamTronSoTien` / `isLamTron_TienCuoi` khi assign final field.
- Neu branch condition fail, retain existing `tinhTongChi_406()` aggregation unchanged. Invalid-rate rows khong duoc silently drop.

## Caller scope pending

- Candidate references can xac minh khi trien khai: resolution selector template around line 550; detail value/rate bindings around 1170, 1475, 1484; TypeScript import call around 707; deletion call around 938; service indirect `tinhThanhTienCoThue_406` -> `tinhChiTietThue_406` around 3542-3558. Inventory truoc code change va record actual paths/lines/old arguments trong `report.md`.
- Pass/retain context tren moi target invocation; chi `HoaDonBanHangComponent` cua route dich pass true. Caller khac false/default va giu old argument behavior. Scope chua confirmed cho den source trace va route QA.

## UI

- Controls trong `hoadonbanhang.component.html`: `tongHop_TienHang`, `tongHop_TongTien_ChietKhau_ThuongMai`, `tongHop_TongTien_CoVAT`; text `tongHop_TongTien_CoVAT_Chu`.
- Add `disabled` va right-aligned `inputClass` cho ca ba numeric controls; remove `inputModelChange` tu CKTM; text payment display-only trong right-aligned container.
- Giu exact two required tooltips in source: `T&#7893;ng ti&#7873;n h&#224;ng l&#224; t&#7893;ng c&#7897;ng th&#224;nh ti&#7873;n ch&#432;a c&#243; thu&#7871; gi&#225; tr&#7883; gia t&#259;ng`; `T&#7893;ng ti&#7873;n chi&#7871;t kh&#7845;u th&#432;&#417;ng m&#7841;i l&#224; t&#7893;ng ti&#7873;n c&#7911;a c&#225;c lo&#7841;i h&#224;ng h&#243;a chi&#7871;t kh&#7845;u v&#224; t&#7893;ng th&#224;nh ti&#7873;n chi&#7871;t kh&#7845;u cho t&#7915;ng h&#224;ng h&#243;a/d&#7883;ch v&#7909; v&#224; chi&#7871;t kh&#7845;u th&#432;&#417;ng m&#7841;i`.
- Payment tooltip semantic text: `Tong tien thanh toan bang tong tien hang cong tong tien thue`; implementation render Vietnamese diacritics.

## Data impact va out of scope

Khong doi API, DTO, proxy, schema, migration, contract, worker, queue, config, deployment, import, XML, ky so, CQT, report, hay detail entry. Client-calculated invoice model values co the thay doi va persist khi luu.
