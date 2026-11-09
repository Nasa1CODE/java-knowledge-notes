# Impact - CBCLOUDV2-9418

## Purpose

Đánh giá ảnh hưởng của việc nâng cấp file import GTGT, Bán hàng, Vé xe: thêm `MDVQHNS`, `Mã quốc tịch`, `Quốc tịch` độc lập ND254; sắp xếp lại cột Hàng hóa đặc trưng 1/xe và đọc flag `ACTIVE_ND_254` từ Redis trước khi fallback DB.

## Phạm vi thay đổi

- Logic import Excel: có.
- API boolean phục vụ FE: có, không đổi contract.
- DB schema/migration: có bốn cột nullable trong `vs_hd_tonghop_morong` nếu môi trường chưa có.
- XML tag: không.
- Queue contract: không.
- Frontend: không sửa.
- File mẫu runtime: có, cần deploy đồng bộ.

## Thành phần bị ảnh hưởng

| Layer | Service | File/Thành phần | Mức ảnh hưởng | Ghi chú |
|---|---|---|---|---|
| API | invoicecore | `DoanhNghiep_ThongTinChungAppService.GetActiveND254()` | Trung bình | Thêm Redis-first, DB fallback |
| Import direct | invoicecore | `NhapDSHoaDonExcelHelper.cs` | Trung bình | Đổi mapping cột và lưu `MaDVQHNS` |
| Import worker | svinvoicesendemail | `VehicleAssetImportHelper.cs` | Trung bình | Đổi helper đọc/validate/map |
| Import worker | svinvoicesendemail | `NhapDSHoaDonExcelHelper.cs`, `BanHang_ExcelHelper.cs`, `ImportVeXeHelper.cs` | Trung bình | Đổi cột GTGT/Bán hàng/Vé xe |
| Data | tenant DB | `vs_hd_tonghop_morong` | Trung bình | `MaDVQHNS` đã có; bổ sung `ten_tinh`, `ten_xa`, `quoc_tich_nguoi_mua`, `ma_quoc_tich_nguoi_mua` |
| Redis | host/cache | Hash `QLCAUHINH`, field `ACTIVE_ND_254` | Trung bình | Sai value làm bật/tắt sai tính năng |
| Excel template | runtime artifact | GTGT/Bán hàng/Vé xe | Cao | File mẫu phải khớp code, nếu không import lệch cột |

## Confirmed unaffected

- Không đổi type của `MaDVQHNS`; chỉ validate import tối đa 7 ký tự.
- Không đổi XML tag `MDVQHNSach`.
- Không đổi queue name/payload bên ngoài.
- Không sửa FE component/proxy.
- Không áp dụng cho API tích hợp tạo hóa đơn ngoài import Excel.
- Không áp dụng cho LS/MSP/FUTA trong ticket Cloud.

## Known risks and limitations

- Nếu runtime vẫn phát hành file mẫu cũ nhưng code đã dùng layout mới, dữ liệu có thể lệch cột.
- Nếu Redis `QLCAUHINH.ACTIVE_ND_254` không đồng bộ với DB, Redis thắng khi có field hợp lệ.
- Test manual cần môi trường có Redis/DB/tenant thật; local chỉ kiểm được build/unit/source-level.

## Not verified

- Chưa code.
- Chưa chạy build/test cho task này.
- Chưa kiểm file mẫu runtime qua API tải mẫu.

## Conclusion

Rủi ro chính nằm ở đồng bộ layout Excel với code và cấu hình Redis. Nên deploy file mẫu, code và Redis flag theo cùng một checklist.

