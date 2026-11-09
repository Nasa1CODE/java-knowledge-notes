# Deploy - CBCLOUDV2-9404

status: code-ready-artifact-pending

## Trigger

Không có SQL/config/queue change. `deploy.md` vẫn bắt buộc vì task thay artifact file mẫu trong file storage/runtime ngoài git.

## Artifact cần rà

| Loại | Tên runtime |
|---|---|
| GTGT mặc định | `FileMau/HoaDon/Hoadon_FileMau.xlsx` |
| GTGT NewCA | `FileMau/HoaDon/Hoadon_FileMau_NewCa.xlsx` |
| GTGT Liên Sơn | `FileMau/HoaDon/Hoadon_FileMau_LienSon.xlsx` |
| Bán hàng | `FileMau/HoaDon/HoadonBH_FileMau.xlsx` |
| Vé xe | `FileMau/HoaDon/HoadonVEXE_FileMau.xlsx` |

Chỉ thay artifact thực tế có nhóm cột Hàng hóa đặc trưng loại 1 và header `Chất lượng tài sản %`.

## Pre-deploy

1. Xác nhận owner, môi trường và đường dẫn file storage thật.
2. Tải/backup từng binary đang dùng; lưu tên, SHA-256 và thời điểm.
3. Kiểm tra sheet/header hiện tại và xác định vị trí `Chất lượng tài sản %`, `Số biển kiểm soát`.
4. Chuẩn bị file mới bằng cách xóa nguyên cột chất lượng, giữ style/data validation của biển số.
5. Verify code hai service hỗ trợ đồng thời layout cũ/mới.

## Thứ tự deploy

1. Deploy `invoicecore` và `svinvoicesendemail` có parser tương thích hai layout.
2. Smoke bằng file cũ để xác nhận không đọc lệch.
3. Thay các binary file mẫu áp dụng.
4. Tải lại file qua `HoaDon/TaiFileMau` và kiểm header.
5. Smoke GTGT/Bán hàng/Vé xe direct/background bằng file mới.
6. Query tenant test: `cltsan` null, `sbksoat` đúng.

## Rollback

1. Khôi phục các binary theo backup/hash.
2. Rollback đồng thời code `invoicecore` và `svinvoicesendemail` nếu cần.
3. Không chạy rollback DB vì task không đổi schema/dữ liệu cũ.

## Bằng chứng cần lưu trong report

- Hash artifact trước/sau và nơi deploy.
- Header của file tải lại qua API.
- Build/test output hai service.
- Kết quả 6 luồng import và DB read-back trên tenant test.

## Trạng thái thực hiện 2026-09-08

- Code parser tương thích mẫu cũ/mới đã hoàn tất ở `invoicecore` và `svinvoicesendemail`.
- Chưa cập nhật 5 binary runtime vì artifact triển khai không có trong source checkout và chưa xác định owner/path phát hành.
- Không có SQL, config hoặc thay đổi queue cần deploy.
