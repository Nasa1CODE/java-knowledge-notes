# CBCLOUDV2-8761 Impact

## Scope

Task nay chi thay doi frontend `frontend_angular/` de chuan hoa STT dong chi tiet hoa don khi co dong `hangHoa_Loai == 2` (`Ghi chu/dien giai`).

Helper dung chung:

- `frontend_angular/src/helpers/invoice-detail-stt.helper.ts`

Quy tac moi tren FE:

- Dong `Ghi chu/dien giai`: `stt = null`, khong hien thi/danh so nhu dong hang hoa.
- Dong khac ghi chu: danh lai STT lien tuc `1, 2, 3...` theo thu tu hien tai.
- Dong nao cung duoc cap nhat `indexKey` theo vi tri that trong bang de FE track row dung sau khi them/xoa/doi loai.

## Affected Invoice Screens

Tester can regression cac man sau neu co nghiep vu/dataset tuong ung:

| Man hoa don | File FE | Can test lai |
| --- | --- | --- |
| Hoa don ban hang | `hoadonbanhang.component.ts` | Load hoa don, them dong, xoa dong, doi loai sang `Ghi chu/dien giai`, import file, luu tam/trinh ky/ky neu route ho tro. |
| Hoa don goc/GTGT | `hoadon-goc.component.ts` | Load hoa don, them/xoa/doi loai/import, tinh thue/tong tien sau khi co dong ghi chu. |
| Hoa don ban tai san cong | `hoa-don-ban-tai-san-cong.component.ts` | Load hoa don, them/xoa/doi loai/import, tinh thue/tong tien sau khi co dong ghi chu. |
| Hoa don dien nuoc | `hoadondiennuoc.component.ts` | Load hoa don, them/xoa/doi loai/import, tinh thanh tien sau khi co dong ghi chu. |
| Ve may bay | `vemaybay.component.ts` | Load hoa don, them/xoa/doi loai/import, tinh thanh tien va thong tin mo rong sau khi co dong ghi chu. |
| Phieu xuat nhap kho | `phieuxuatnhapkho.component.ts` | Load phieu, them/xoa/doi loai/import, so luong nhap/xuat sau khi co dong ghi chu. |
| Phieu xuat kho noi bo | `phieuxuatkhonoibo.component.ts` | Load phieu, them/xoa/doi loai/import, so luong nhap/xuat sau khi co dong ghi chu. |

## Regression Test Matrix

Tester nen lap lai cung mot pattern cho tung man trong danh sach affected:

1. Mo hoa don co san 3 dong: Hang hoa, Ghi chu, Hang hoa.
   - Expected: cot STT hien thi `1`, rong, `2`.
   - Expected: tong tien/thue khong tinh dong ghi chu nhu dong hang hoa.

2. Doi dong thu 2 tu `Hang hoa` sang `Ghi chu/dien giai`.
   - Expected: dong vua doi khong co STT.
   - Expected: cac dong hang hoa con lai duoc danh lai lien tuc.

3. Doi dong `Ghi chu/dien giai` ve `Hang hoa`.
   - Expected: dong do duoc cap STT theo thu tu moi.
   - Expected: cac truong tien/thue/tong tien tinh lai theo logic man hien tai.

4. Xoa mot dong hang hoa truoc dong ghi chu.
   - Expected: STT cac dong hang hoa phia sau duoc danh lai.
   - Expected: dong ghi chu van khong co STT.

5. Them dong hang hoa sau dong ghi chu.
   - Expected: dong moi co STT tiep theo.
   - Expected: khong co hien tuong nhay so nhu `1, rong, 3`.

6. Import file co ca dong hang hoa va dong ghi chu neu man co nut import.
   - Expected: sau import, dong ghi chu khong co STT, dong hang hoa danh lai lien tuc.

7. Luu tam/trinh ky/ky/xem truoc neu man ho tro.
   - Expected: khong loi validate moi do STT dong ghi chu.
   - Expected: mo lai hoa don sau luu van hien thi STT dung.

## Confirmed Unaffected Areas

- Khong sua backend API.
- Khong sua service save hoa don.
- Khong sua XML/signing/export PDF.
- Khong sua database/schema.
- Khong sua logic tinh tien/thue, ngoai viec goi lai helper STT truoc/sau cac thao tac FE hien co.

## Risk Notes

- Rui ro chinh la cac man co binding cot STT hoac validate bat buoc STT tren FE. Tester can uu tien test cac thao tac luu sau khi co dong ghi chu nam giua cac dong hang hoa.
- Build frontend chua xac minh duoc tren moi truong hien tai do Node 22 khong tuong thich stack cu (`webpack` OpenSSL legacy va `node-sass@5`). Can build lai bang Node phu hop truoc merge/deploy.
