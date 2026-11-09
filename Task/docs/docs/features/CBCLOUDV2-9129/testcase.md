# Testcase — CBCLOUDV2-9129

> Testcase sinh từ [expect.md](expect.md) và [plan.md](plan.md) cho Gate 1. Chạy chi tiết sau khi Rule 02 implement xong.

## Phạm vi test

- Màn hình admin Cloud danh mục **Loại chứng từ điện tử**.
- Backend AppService CRUD/search/export/import/cache.
- Bảng `vs_dm_ncc_loaictdt` và seed 8 dòng.
- Permission/menu/action theo pattern danh mục quốc tịch.
- An toàn thông tin cho Export/Import/logging.

## Điều kiện test chung

- Backend và frontend đã deploy/build từ branch `hungtq_dev_cloud_CBCLOUDV2-9129` hoặc branch thực tế được ghi rõ.
- DB test/dev có bảng `vs_dm_ncc_loaictdt` và seed theo [deploy.md](deploy.md).
- Có tối thiểu 2 tài khoản/role test:
  - Role A: có đầy đủ permission `Admin.DanhMuc.LoaiCTDT*`.
  - Role B: không có permission danh mục loại chứng từ điện tử hoặc thiếu từng child permission để test ẩn nút.
- Redis/cache dev có thể quan sát hoặc ít nhất kiểm tra qua hành vi API trước/sau mutation.
- Không dùng dữ liệu thật nhạy cảm trong file import/export test.

## Ma trận testcase

| ID | Nhóm | Mục tiêu | Dữ liệu/Bước chính | Kết quả kỳ vọng |
|---|---|---|---|---|
| TC-001 | Menu/permission | User có quyền xem mở được màn hình | Login Role A, mở menu danh mục loại chứng từ điện tử | Menu hiển thị; route load không lỗi; title đúng nghiệp vụ. |
| TC-002 | Menu/permission | User không có quyền xem không truy cập được | Login Role B không có `Admin.DanhMuc.LoaiCTDT` | Không thấy menu; truy cập route trực tiếp bị chặn hoặc không load dữ liệu. |
| TC-003 | Permission action | Nút thêm mới theo permission | Role thiếu `.Create`, mở màn hình | Không thấy hoặc không dùng được nút thêm mới. |
| TC-004 | Permission action | Nút sửa theo permission | Role thiếu `.Edit`, mở danh sách | Không thấy hoặc không dùng được action sửa. |
| TC-005 | Permission action | Nút ngừng hiệu lực theo permission | Role thiếu `.Delete`, mở danh sách | Không thấy hoặc không dùng được action ngừng hiệu lực. |
| TC-006 | Permission action | Nút import theo permission | Role thiếu `.Import`, mở màn hình | Không thấy hoặc không dùng được nút import. |
| TC-007 | Seed | Kiểm tra seed 8 dòng | Query/list màn hình sau deploy DB | Có đủ mã `1`, `2`, `3`, `4`, `CTT50`, `6`, `7`, `8`; dòng `7` không còn chuỗi lỗi `Arm...enia`. |
| TC-008 | List | Hiển thị danh sách | Mở màn hình bằng Role A | Bảng có STT, mã, mô tả, ngày bắt đầu, ngày kết thúc, hiệu lực, thao tác. |
| TC-009 | Search | Tìm theo mã | Tìm `CTT50` | Chỉ/trong kết quả có bản ghi mã `CTT50`, không trả sai dữ liệu không liên quan. |
| TC-010 | Search | Tìm theo mô tả | Tìm `Nghị định 254` | Trả các bản ghi có mô tả chứa từ khóa phù hợp. |
| TC-011 | Search | Tìm không có kết quả | Tìm chuỗi ngẫu nhiên không tồn tại | Danh sách rỗng, UI không lỗi. |
| TC-012 | Paging/sort | Phân trang/sort hoạt động | Đổi page size, sort theo mã/mô tả | API nhận skip/max/sorting; UI hiển thị đúng page/sort. |
| TC-013 | Create | Thêm mới hợp lệ | Mã `TEST01`, mô tả hợp lệ, hiệu lực bật | Lưu thành công; danh sách refresh; bản ghi xuất hiện. |
| TC-014 | Create validation | Mã bắt buộc | Bỏ trống mã | Không lưu; báo lỗi validate. |
| TC-015 | Create validation | Mô tả bắt buộc | Bỏ trống mô tả | Không lưu; báo lỗi validate. |
| TC-016 | Create validation | Mã quá dài | Nhập mã > 200 ký tự | Không lưu; báo lỗi độ dài. |
| TC-017 | Create validation | Mô tả quá dài | Nhập mô tả > 1500 ký tự | Không lưu; báo lỗi độ dài. |
| TC-018 | Create validation | Trùng mã | Tạo mới mã `TEST01` lần 2 | Không lưu; báo lỗi mã đã tồn tại. |
| TC-019 | Create validation | Ngày bắt đầu > ngày kết thúc | Start date sau End date | Không lưu; báo lỗi khoảng ngày. |
| TC-020 | Create normalize | Trim input | Nhập mã/mô tả có khoảng trắng đầu/cuối | Dữ liệu lưu sau trim; không tạo duplicate do whitespace. |
| TC-021 | Edit | Sửa mô tả/ngày/hiệu lực | Mở `TEST01`, sửa mô tả và ngày | Lưu thành công; danh sách refresh; dữ liệu mới hiển thị. |
| TC-022 | Edit | Mã disabled khi edit | Mở modal sửa bản ghi | Trường mã không chỉnh sửa được hoặc backend không cho đổi mã. |
| TC-023 | Edit validation | Date range khi sửa | Sửa start date > end date | Không lưu; báo lỗi. |
| TC-024 | Ngừng hiệu lực | Xóa nghiệp vụ là ngừng hiệu lực | Chọn ngừng hiệu lực `TEST01`, xác nhận | Bản ghi không bị hard delete; `LoaiCTDT_HieuLuc = 0`; danh sách refresh. |
| TC-025 | Ngừng hiệu lực cancel | Không thay đổi khi cancel confirm | Chọn ngừng hiệu lực rồi bấm hủy | Bản ghi giữ nguyên hiệu lực. |
| TC-026 | Cache | Cache refresh sau create | Gọi list/cache lookup, tạo record mới, gọi lại | Lần sau thấy record mới, không trả dữ liệu cache cũ. |
| TC-027 | Cache | Cache refresh sau edit | Gọi cache lookup, sửa mô tả, gọi lại | Lần sau thấy mô tả mới. |
| TC-028 | Cache | Cache refresh sau ngừng hiệu lực | Gọi cache lookup, ngừng hiệu lực, gọi lại | Lần sau thấy trạng thái hiệu lực mới. |
| TC-029 | Export | Export theo filter/sorting | Filter `254`, sort mã, bấm Export | File Excel tải được; chỉ chứa dữ liệu theo filter/sorting. |
| TC-030 | Export content | Kiểm tra cột export | Mở file export | Có STT, Mã, Mô tả, Bắt đầu, Kết thúc, Hiệu lực; không có audit/internal IDs. |
| TC-031 | Export security | Không lộ dữ liệu nhạy cảm | Kiểm tra file export và log liên quan | Không có secrets, connection string, JWT/token, password, raw customer-tax data ngoài scope. |
| TC-032 | Import template | Tải file mẫu | Mở import modal, bấm tải file mẫu | Tải được `.xlsx` template; header đúng loại chứng từ điện tử. |
| TC-033 | Import valid | Import file hợp lệ | File `.xlsx` đúng header, mã mới `IMP01` | Import thành công; danh sách có `IMP01`; cache refresh. |
| TC-034 | Import header | Sai header | File `.xlsx` sai tên cột/thứ tự cột | Không import; báo lỗi header/template. |
| TC-035 | Import extension | Sai định dạng file | Chọn `.txt`/`.xls`/file đổi đuôi không hợp lệ | Không xử lý hoặc backend reject; thông báo an toàn. |
| TC-036 | Import required | Dòng thiếu mã/mô tả | File có dòng trống mã hoặc mô tả | Không import dòng lỗi; trả lỗi dòng/field rõ ràng. |
| TC-037 | Import length | Dòng quá độ dài | File có mã > 200 hoặc mô tả > 1500 | Không import; trả lỗi độ dài. |
| TC-038 | Import duplicate in file | Trùng mã trong cùng file | File có 2 dòng mã `IMP_DUP` | Không import hoặc trả lỗi trùng trong file theo pattern hiện hữu. |
| TC-039 | Import duplicate in DB | Trùng mã đã có DB | File có mã `CTT50` | Không import dòng trùng; báo mã đã tồn tại. |
| TC-040 | Import date | Sai date range/format | Start > End hoặc format ngày sai template | Không import; trả lỗi ngày. |
| TC-041 | Import security log | Không log raw file/base64 | Import file lỗi, kiểm tra log app dev | Log không chứa `fileData`, base64 raw, nội dung Excel đầy đủ, secrets/token/password. |
| TC-042 | Error handling | API trả lỗi an toàn | Gây lỗi validate/import | UI hiện message nghiệp vụ; không hiện stack trace/path nội bộ/secrets. |
| TC-043 | Regression QuocTich | Không làm hỏng danh mục quốc tịch | Mở danh mục quốc tịch, search/export/import cơ bản nếu có thể | Chức năng quốc tịch vẫn hoạt động. |
| TC-044 | Regression LoaiHoaDon | Không làm hỏng danh mục loại hóa đơn | Mở danh mục loại hóa đơn, search cơ bản | Chức năng hiện hữu vẫn hoạt động. |
| TC-045 | Build BE | Backend build | `dotnet build "D:\BILL\invoicemanagement\aspnet-core\VS.Web.sln"` | Build pass. |
| TC-046 | Build FE | Frontend type-check/build | Command build/type-check phù hợp trong `D:\BILL\invoicemanagement\angular` | Build/type-check pass. |

## Chi tiết testcase trọng yếu

### TC-024 — Ngừng hiệu lực không hard delete

- **Tiền điều kiện:** Có record `TEST01` hiệu lực `1`.
- **Bước:**
  1. Mở màn hình danh mục loại chứng từ điện tử.
  2. Chọn action ngừng hiệu lực cho `TEST01`.
  3. Xác nhận confirm.
  4. Refresh danh sách hoặc query DB test nếu được phép.
- **Kỳ vọng:**
  - UI thông báo thành công.
  - Record vẫn còn trong bảng/danh sách quản trị.
  - `LoaiCTDT_HieuLuc = 0`.
  - Không gọi hard delete làm mất record khỏi DB.
  - Cache được clear; lookup sau đó không trả trạng thái cũ.

### TC-031 — Export an toàn thông tin

- **Bước:**
  1. Tạo/filter một số record test.
  2. Export Excel.
  3. Mở file và kiểm tra sheet/header/cột.
  4. Kiểm tra log app phát sinh khi export nếu có quyền xem log dev.
- **Kỳ vọng:**
  - File chỉ có các cột whitelist: STT, Mã, Mô tả, Bắt đầu, Kết thúc, Hiệu lực.
  - Không có `Id`, audit fields, user id, tenant info ngoài scope, connection string, Redis endpoint/password, JWT/token, stack trace.
  - Log không in dữ liệu nhạy cảm hoặc secrets.

### TC-041 — Import an toàn thông tin

- **Bước:**
  1. Import file sai header/sai dữ liệu để phát sinh lỗi.
  2. Import file hợp lệ để phát sinh luồng thành công.
  3. Kiểm tra UI message/file lỗi/log dev.
- **Kỳ vọng:**
  - UI trả lỗi nghiệp vụ đủ hiểu, không có stack trace/path nội bộ/secrets.
  - Log không chứa raw base64 `fileData`, nội dung Excel đầy đủ, password/token/JWT/connection string.
  - Tên file nếu log thì đã được kiểm soát/truncate, không gây log injection.
  - File lỗi nếu có chỉ chứa dòng/cột lỗi cần thiết, không thêm dữ liệu ngoài template.

## Test data đề xuất

| Mã | Mô tả | Ghi chú |
|---|---|---|
| `TEST01` | Loại chứng từ điện tử test 01 | Dùng cho create/edit/ngừng hiệu lực. |
| `IMP01` | Loại chứng từ điện tử import 01 | Dùng cho import hợp lệ. |
| `IMP_DUP` | Loại chứng từ điện tử import duplicate | Dùng test duplicate trong file. |
| `CTT50` | Seed có sẵn | Dùng test duplicate DB. |

## Verification commands

> Chạy ở môi trường cho phép, không ghi secrets/connection string ra terminal/log docs.

| Lệnh/bước | Kỳ vọng |
|---|---|
| `dotnet build "D:\BILL\invoicemanagement\aspnet-core\VS.Web.sln"` | Backend build pass. |
| Generate NSwag proxy theo quy trình repo | Proxy `DM_NCC_LoaiCTDTServiceProxy` được sinh. |
| `tsc -p src/tsconfig.json --noEmit` trong `D:\BILL\invoicemanagement\angular` hoặc command build phù hợp | Frontend type-check/build pass. |
| Manual testcase TC-001 → TC-044 | Pass hoặc ghi rõ lỗi/blocker. |

## Exit criteria

- [ ] Tất cả AC trong [expect.md](expect.md) có testcase tương ứng pass.
- [ ] Build backend/frontend pass hoặc có lý do blocker rõ ràng.
- [ ] Không có lỗi permission nghiêm trọng.
- [ ] Không có hành vi hard delete khi user chọn ngừng hiệu lực.
- [ ] Export/Import không lộ secrets/dữ liệu nhạy cảm ngoài scope.
- [ ] Cache không stale sau thêm/sửa/ngừng hiệu lực/import.
- [ ] Regression danh mục quốc tịch và loại hóa đơn không lỗi cơ bản.
