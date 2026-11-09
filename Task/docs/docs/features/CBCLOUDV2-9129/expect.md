# Expect — CBCLOUDV2-9129: [DEV] [CLOUD] [ND254] Bổ sung DANH MỤC LOẠI CHỨNG TỪ ĐIỆN TỬ

> BA sở hữu file này. Viết mong muốn ĐÃ clear với người dùng. Không viết cách làm (đó là việc của plan).

status: approved   # NGUỒN DUY NHẤT của status vòng đời: draft → plan-review → approved → in-progress → testing → done
                # Chỉ người (BA/TechLead) đổi. AI không tự đổi sang approved.
jira: CBCLOUDV2-9129
  - System: Cloud
  - Service: invoicemanagement
  - BE: invoicemanagement/aspnet-core → `D:\BILL\invoicemanagement\aspnet-core`
  - FE: invoicemanagement/angular → `D:\BILL\invoicemanagement\angular`
  - Git base: `origin/develop_cloud`
  - Git branch đề xuất: `hungtq_dev_cloud_CBCLOUDV2-9129`

## Bối cảnh / Vấn đề

CBCLOUDV2-9129 là task phát triển cho hệ thống **Cloud**. Bổ sung danh mục loại chứng từ điện tử theo ND254 trên admin service.

Dữ liệu tham chiếu mẫu:

| STT | Mã | Mô tả |
|---:|---|---|
| 1 | 1 | Chứng từ điện tử khấu trừ thuế TNCN theo Nghị định 70/2025/NĐ-CP |
| 2 | 2 | Biên lai thu thuế, phí, lệ phí theo Nghị định 254/2026/NĐ-CP, Nghị định 347/2025/NĐ-CP |
| 3 | 3 | Biên lai thu thuế, phí, lệ phí không in sẵn mệnh giá theo Nghị định 70/2025/NĐ-CP |
| 4 | 4 | Biên lai thu thuế, phí, lệ phí in sẵn mệnh giá theo Nghị định 70/2025/NĐ-CP |
| 5 | CTT50 | Biên lai thu thuế, phí, lệ phí của cơ quan thuế sử dụng khi thu thuế, phí, lệ phí của cá nhân |
| 6 | 6 | Biên lai thu thuế, phí, lệ phí đặt in, tự in, điện tử theo Thông tư 303/2016/TT-BTC, Nghị định 51/2010/NĐ- CP |
| 7 | 7 | Chứng từ khấu trừ thuế TNCN theo Nghị định 123/2020/NĐ-CP |
| 8 | 8 | Chứng từ khấu trừ thuế TNCN theo Nghị định 254/2026/NĐ-CP |

## Mong muốn

- Tại service admin Cloud tạo màn hình đầy đủ thêm, sửa, ngừng hiệu lực, tìm kiếm, xuất Excel cho danh mục loại chứng từ điện tử.
- Bổ sung Import Excel theo pattern danh mục quốc tịch, kèm kiểm soát an toàn thông tin cho file import.
- Tạo thêm bảng `vs_dm_ncc_loaictdt` cho hệ thống Cloud, theo scope dữ liệu giống danh mục quốc tịch.
- Cache danh mục lên Redis và có cơ chế cập nhật/xóa cache khi dữ liệu thay đổi.
- Phát triển từ nhánh git Cloud `develop_cloud`, sinh nhánh `hungtq_dev_cloud_CBCLOUDV2-9129`.

## Acceptance Criteria

### AC1 — Menu, phân quyền và truy cập màn hình

- Có màn hình admin Cloud cho **Danh mục loại chứng từ điện tử** trong service `invoicemanagement`, theo nhóm menu danh mục tương tự màn hình **Quốc tịch**.
- Actor/permission áp dụng giống danh mục quốc tịch, nhưng dùng permission riêng cho loại chứng từ điện tử:
  - quyền xem danh sách/màn hình;
  - quyền thêm mới;
  - quyền chỉnh sửa;
  - quyền ngừng hiệu lực;
  - quyền import Excel nếu có nút Import.
- Người dùng không có quyền tương ứng không nhìn thấy hoặc không thao tác được nút chức năng tương ứng.

### AC2 — Danh sách, tìm kiếm, phân trang và sắp xếp

- Màn hình hiển thị danh sách loại chứng từ điện tử từ bảng `vs_dm_ncc_loaictdt` theo format danh mục hiện hữu.
- Danh sách có tối thiểu các thông tin: STT, mã, mô tả, ngày bắt đầu, ngày kết thúc, hiệu lực, thao tác.
- Có ô tìm kiếm theo từ khóa; từ khóa áp dụng cho mã và mô tả.
- Danh sách hỗ trợ phân trang và sắp xếp theo pattern PrimeNG hiện hữu.
- Kết quả xuất Excel phải áp dụng filter/sorting hiện tại trên màn hình.

### AC3 — Thêm mới loại chứng từ điện tử

- Người dùng có quyền thêm mới tạo được bản ghi với các trường:
  - `Mã` — bắt buộc, tối đa 200 ký tự;
  - `Mô tả` — bắt buộc, tối đa 1500 ký tự;
  - `Ngày bắt đầu` — không bắt buộc;
  - `Ngày kết thúc` — không bắt buộc;
  - `Hiệu lực` — mặc định bật.
- Hệ thống trim/normalize dữ liệu đầu vào theo pattern danh mục quốc tịch.
- Không cho tạo mới nếu mã đã tồn tại trong bản ghi chưa bị xóa logic/đang quản lý.
- Không cho lưu nếu ngày bắt đầu lớn hơn ngày kết thúc.
- Sau khi thêm mới thành công, danh sách refresh và Redis cache của danh mục được xóa/cập nhật để lần đọc sau trả dữ liệu mới.

### AC4 — Chỉnh sửa loại chứng từ điện tử

- Người dùng có quyền chỉnh sửa cập nhật được mô tả, ngày bắt đầu, ngày kết thúc và hiệu lực.
- Mã không được chỉnh sửa sau khi bản ghi đã tồn tại, theo pattern danh mục quốc tịch.
- Validate bắt buộc/độ dài/trùng mã/date range giống luồng thêm mới.
- Sau khi chỉnh sửa thành công, danh sách refresh và Redis cache của danh mục được xóa/cập nhật.

### AC5 — Ngừng hiệu lực thay cho xóa vật lý

- Chức năng xóa trên UI được xử lý nghiệp vụ là **ngừng hiệu lực**.
- Khi người dùng xác nhận ngừng hiệu lực, hệ thống cập nhật trạng thái hiệu lực của bản ghi về không hiệu lực; không hard delete bản ghi khỏi DB.
- Bản ghi ngừng hiệu lực vẫn có thể được hiển thị trong danh sách để tra cứu/quản trị, với trạng thái hiệu lực tương ứng.
- Sau khi ngừng hiệu lực thành công, danh sách refresh và Redis cache của danh mục được xóa/cập nhật.

### AC6 — Seed dữ liệu mẫu

- Bảng `vs_dm_ncc_loaictdt` được seed 8 dòng dữ liệu tham chiếu trong mục **Bối cảnh / Vấn đề**.
- Dòng STT 7 sử dụng mô tả đã sửa: `Chứng từ khấu trừ thuế TNCN theo Nghị định 123/2020/NĐ-CP`.
- Seed có cơ chế chống insert trùng mã khi deploy lại.

### AC7 — Export Excel

- Người dùng xuất được danh sách loại chứng từ điện tử ra Excel theo filter/sorting hiện tại.
- File/sheet/header dùng tên nghiệp vụ loại chứng từ điện tử, không còn copy-paste từ quốc tịch.
- File export chỉ chứa dữ liệu danh mục cần thiết: STT, mã, mô tả, ngày bắt đầu, ngày kết thúc, hiệu lực.
- Không export secrets, config values, token/JWT, dữ liệu nhạy cảm không thuộc danh mục, audit nội bộ hoặc thông tin nhận diện người dùng nếu không có yêu cầu riêng.

### AC8 — Import Excel và an toàn thông tin

- Người dùng có quyền Import tải được file mẫu và import Excel theo template danh mục loại chứng từ điện tử.
- Import chỉ chấp nhận định dạng `.xlsx` theo template; validate header trước khi xử lý dữ liệu.
- Import validate các điều kiện: mã bắt buộc, mô tả bắt buộc, độ dài trường, trùng mã trong file, trùng mã trong DB, ngày bắt đầu không lớn hơn ngày kết thúc, định dạng ngày theo template.
- Import không ghi log raw Excel/base64/file content; log lỗi chỉ ghi thông tin đã rút gọn/an toàn như tên file đã kiểm soát, số dòng, thông báo validate, không ghi secrets/token/dữ liệu khách hàng ngoài phạm vi danh mục.
- Nếu import có lỗi dữ liệu, hệ thống trả thông báo hoặc file lỗi theo pattern hiện hữu để người dùng biết dòng lỗi; không tạo dữ liệu không hợp lệ.
- Sau import thành công, Redis cache của danh mục được xóa/cập nhật.

### AC9 — Redis cache

- Backend cache danh mục bằng ABP `ICacheManager` trên Redis theo scope giống danh mục quốc tịch.
- Cache name/key được đặt riêng cho loại chứng từ điện tử, không dùng chung key với quốc tịch hoặc danh mục khác.
- Cache được invalidate sau thêm mới, chỉnh sửa, ngừng hiệu lực và import.
- Không đưa secrets hoặc connection string Redis vào docs/code/logs; chỉ ghi tên config key nếu cần.

### AC10 — Kiểm chứng tối thiểu trước bàn giao

- Backend build thành công sau khi bổ sung entity/DTO/AppService/permission/helper.
- Frontend type-check/build tối thiểu thành công sau khi bổ sung route/component/modal/proxy/provider.
- Manual test pass cho các luồng: mở màn hình, tìm kiếm, thêm, sửa, ngừng hiệu lực, export, import file mẫu, import lỗi validate, kiểm tra cache refresh sau thay đổi.

## Out-of-scope

- Không thay đổi luồng phát hành/lập/gửi chứng từ điện tử hoặc hóa đơn thực tế.
- Không thay đổi XML/PDF/template chứng từ/hóa đơn, ký số, HSM, gửi cơ quan thuế hoặc message contract với hệ thống thuế.
- Không thay đổi public lookup/searchBill, customer portal, worker xử lý nền, RabbitMQ/Kafka topic hoặc Java service.
- Không bổ sung phân quyền nâng cao ngoài permission riêng tương tự danh mục quốc tịch.
- Không migrate dữ liệu lịch sử từ bảng/nguồn khác nếu ngoài 8 dòng seed đã nêu.
- Không dùng EF migration cho bảng nghiệp vụ `vs_*`; schema/seed/rollback đi theo SQL script/deploy docs.
- Không chỉnh sửa thủ công file NSwag generated proxy ngoài trường hợp quy trình dự án bắt buộc; proxy frontend cần được generate từ backend contract.
- Không ghi secrets, token/JWT, password, connection string thật hoặc dữ liệu nhạy cảm vào docs/code/logs/export ngoài phạm vi danh mục.

## Câu hỏi mở

Không còn câu hỏi blocking cho Rule 01. Các giả định kỹ thuật chi tiết được ghi trong `plan.md` để DEV/TechLead review tại Gate 1.
