# Impact - CBCLOUDV2-9404

## 1. Mục đích

Đánh giá ảnh hưởng khi bỏ trường Chất lượng tài sản khỏi import Hàng hóa đặc trưng loại 1 cho GTGT, Bán hàng và Vé xe ở direct/background flow.

## 2. Phạm vi thay đổi

- Logic parser/validator/mapping import: có.
- Layout file mẫu runtime: có.
- Dữ liệu mới: `cltsan` không được ghi từ import.
- Schema/migration: không.
- API/queue contract: không.
- Frontend code: không.

## 3. Thành phần bị ảnh hưởng

| Service/thành phần | File/vùng | Mức | Lý do |
|---|---|---|---|
| `invoicecore` | `NhapDSHoaDonExcelHelper.cs` | Cao | Shared parser ba loại, dịch cột và bỏ validation/map |
| `invoicecore` | Test project `VS.Tests` | Thấp | Test layout/gate/regression |
| `svinvoicesendemail` | `VehicleAssetImportHelper.cs`, `HoaDonRow.cs` | Cao | Shared helper import nền |
| `svinvoicesendemail` | Ba service helper GTGT/BH/Vé xe | Trung bình | Cập nhật vị trí biển số/LastColumn |
| `svinvoicesendemail` | `AppServiceTest` | Thấp | Test đồng bộ worker |
| File storage/runtime | 5 biến thể `FileMau/HoaDon/*.xlsx` | Cao | Người dùng tải trực tiếp các binary này |
| Tenant DB | `vs_hd_chitiet_morong.cltsan`, `sbksoat` | Trung bình | Không đổi schema; giá trị import mới thay đổi |

## 4. Xác nhận không ảnh hưởng

| Vùng | Vì sao không bị ảnh hưởng |
|---|---|
| API tạo hóa đơn và `api-cloud-service` | Ticket chỉ `[Import]`; không sửa DTO/validator API |
| Frontend/NSwag | Không đổi route/contract hoặc UI tạo hóa đơn |
| Entity và DB column `CLTSan/cltsan` | Giữ để đọc dữ liệu cũ và phục vụ luồng ngoài import |
| XML tag `CLTSan` | Không xóa; hóa đơn cũ vẫn có thể emit giá trị |
| Export/report hóa đơn | Không xóa cột ngoài file mẫu import |
| Queue | Không đổi queue name/message contract |
| Subtype 2/3 | Gate `loaidactrung == 1` giữ nguyên |
| Field xe khác | Chỉ bỏ quality và dịch biển số |

## 5. Rủi ro và hạn chế

| Rủi ro/hạn chế | Mức | Xử lý |
|---|---|---|
| File cũ bị đọc lệch quality thành biển số | Cao | Nhận diện header và test cả hai layout |
| Quên đổi gate tổng cột khiến file mới không kích hoạt rule | Cao | Sửa đủ 3 gate mỗi service: 73/64/62 thành 72/63/61 |
| Direct/background không đồng nhất | Cao | Sửa hai service cùng release, dùng chung ma trận test |
| Binary file mẫu không thuộc git | Cao | Chốt owner/path/hash, backup và deploy checklist |
| Xóa nhầm domain field làm mất dữ liệu cũ | Cao | Do-not-touch entity/DB/XML/repository chung |
| Worktree hai repo đang có thay đổi CBCLOUDV2-9260 | Trung bình | Không restore; review diff theo từng task |
| Dữ liệu tenant bị lộ trong log/test | Cao | Dùng dữ liệu giả, không log payload/secret |

## 6. Chưa được kiểm chứng

| Việc chưa làm | Vì sao |
|---|---|
| Nội dung thực tế của cả 5 binary runtime | Không nằm trong git; cần owner artifact xác nhận |
| Test tự động `invoicecore` | `VS.Tests.csproj` có sẵn `ProjectReference` sai tới hai project không tồn tại |
| Full solution `invoicecore` | `VS.Web.sln` tham chiếu project `TraceIdMiddleware.Tests` không tồn tại; riêng `HDDT.Application` build 0 error |
| Sáu luồng direct/background | Cần tenant test và queue |
| Dữ liệu read-back `cltsan/sbksoat` | Cần tenant DB test |

## 7. Kết quả kỹ thuật

- `svinvoicesendemail`: test 21/21 pass; solution build thành công, 0 error.
- `invoicecore`: project chứa code sửa `HDDT.Application` build thành công, 0 error.
- `git diff --check`: sạch ở cả hai repository.
- Parser đã được rà đủ ba vị trí GTGT/Bán hàng/Vé xe ở cả direct và background; biển số lần lượt chuyển thành 72/63/61.

## 8. Kết luận

Rủi ro tổng thể cao vì thay layout positional của Excel và phải đồng bộ code với artifact ngoài git. Chỉ phát hành khi đã test cả file mới/file cũ trên hai tuyến và có rollback binary.
