# CBCLOUDV2-9020 Test Cases

## TC01 - Create adjustment from CKTM original invoice

- Open create adjustment URL with `loaiHoaDon=5` and `hdGocId` from an original invoice where `quanLy_XacThuc_Loai = 1`.
- Expected: CKTM checkbox is visible and checked.
- Save.
- Expected: request sends `quanLy_XacThuc_Loai = 1`.

## TC02 - Create replacement from CKTM original invoice

- Open create replacement URL with `loaiHoaDon=3` and `hdGocId` from an original invoice where `quanLy_XacThuc_Loai = 1`.
- Expected: CKTM checkbox is visible and checked.

## TC03 - Edit saved adjustment/replacement with CKTM unchecked

- Save an adjustment/replacement invoice with CKTM unchecked.
- Reopen edit URL by `id`.
- Expected: API current invoice value `quanLy_XacThuc_Loai = 0` renders checkbox unchecked, even if original invoice has CKTM checked.
