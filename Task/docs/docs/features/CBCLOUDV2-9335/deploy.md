# CBCLOUDV2-9335 Deploy

## Cảnh báo vận hành bắt buộc

**Sửa mã nguồn không làm sạch dữ liệu đã ghi.** Các giá trị bí mật đã nằm sẵn trong tệp log và bảng audit ở môi trường đang chạy. Việc ngừng ghi từ nay chỉ chặn rò rỉ mới, không thu hồi được cái đã lộ.

Sau khi phát hành Phase C1, cần thực hiện các việc sau. Đây là việc của đội vận hành và bảo mật, không nằm trong phạm vi mã nguồn của ticket.

1. **Xoay vòng các giá trị bí mật đã bị ghi ra log**, gồm mật khẩu FTP của cả hai service Java, mật khẩu Kafka, HSM secret và API key của tích hợp VPBank. Các giá trị này đã tồn tại dạng nguyên văn trong tệp log nên phải coi là đã lộ.
2. **Cân nhắc dọn dữ liệu trong bảng `AbpAuditLogs`**. Trường tham số đầu vào của các lời gọi xác thực và đổi mật khẩu có chứa mật khẩu người dùng. Cần xác định phạm vi thời gian và cách xử lý phù hợp với quy định lưu trữ, có thể là xóa hoặc làm rỗng riêng trường tham số của các action liên quan.
3. **Cân nhắc thu hồi hoặc luân chuyển tệp log cũ** ở `App_Data/Logs/` của các service .NET và `/u01/logs/` của các service Java, đặc biệt các bản sao đã được đưa ra ngoài môi trường sản xuất để phân tích sự cố.
4. **Rà soát người từng có quyền đọc log** trong khoảng thời gian các giá trị này bị ghi, để đánh giá mức độ phơi nhiễm.

Trách nhiệm và thời điểm thực hiện các việc trên là câu hỏi mở số 2 trong `plan.md`, cần chốt trước khi phát hành.

## Thứ tự phát hành

Chia làm ba đợt. Không gộp chung.

### Đợt 1 — Phase B và Phase C1

Nội dung: gỡ tham chiếu project mồ côi, tạo lớp che dữ liệu, xóa các điểm ghi thông tin xác thực, chặn rò rỉ qua bảng audit.

Lý do đi trước: đây là nhóm chặn rò rỉ ngay và có rủi ro hồi quy thấp nhất trong ba nhóm. Toàn bộ thay đổi chỉ là bỏ tham số khỏi lời gọi log hoặc bọc qua hàm che; không đổi luồng điều khiển, không thêm ngoại lệ được ném ra.

Service cần phát hành: `invoicecore`, `api-cloud-service`, `invoice-management`, `bangke-dctt-java-service`, `etran-teanant-service`. Nếu gộp phần mở rộng `invoice-sendmail-service` vào cùng đợt, cần phát hành thêm project `Common.Logging`, `ConsumerApplication`, `ProducerApplication` của service này vì có thêm lớp che dữ liệu và đổi ngưỡng log.

Sau đợt này mới bắt đầu thực hiện các việc trong phần cảnh báo vận hành ở trên.

### Đợt 2 — Phase C2

Nội dung: thêm log và ném lại ngoại lệ tại 8 điểm nuốt lỗi, sửa hai consumer, sửa thứ tự gán kết quả ở luồng xuất file hàng loạt.

**Đây là đợt có rủi ro cao nhất.** Việc ném lại ngoại lệ ở những chỗ trước đây nuốt lỗi sẽ làm các lỗi vốn bị giấu trở nên hiển thị. Số lỗi ghi nhận sẽ tăng sau khi phát hành. Cần báo trước cho đội vận hành và đội trực sự cố: **đây không phải lỗi mới phát sinh, mà là lỗi đã tồn tại và trước đây bị che đi**. Không nên phản ứng bằng cách hoàn tác đợt phát hành này.

Nên phát hành vào thời điểm có người trực để quan sát, và theo dõi số lượng lỗi trong ít nhất 24 giờ đầu.

Luồng xuất file hàng loạt đổi hành vi người dùng thấy được, cần TechLead/QA review riêng và cần rà mã Angular trên môi trường runtime trước deploy. Chi tiết trong `impact.md`.

Service cần phát hành: `invoicecore`, `export-zip-pdf-service`. Phần `invoice-sendmail-service` có thay đổi cùng loại ở consumer gửi mail và các utility XML/email/FTP; nếu phát hành chung cần theo dõi lỗi nổi lên do các lỗi trước đây bị thiếu log hoặc bị nuốt.

### Đợt 3 — Phase C3

Nội dung: handler log lời gọi ra ngoài, cắm vào factory, bổ sung log thủ công cho các điểm nóng, vá hạ tầng trace ID.

Đợt này làm tăng lượng log ghi ra vì mỗi lời gọi ra ngoài sinh thêm một cặp dòng log. Cần kiểm tra dung lượng đĩa trước khi phát hành. Cấu hình luân chuyển tệp log hiện tại giữ 10 bản sao, mỗi bản tối đa khoảng 10 MB cho mỗi appender; nếu lượng log tăng đáng kể thì thời gian lưu trữ thực tế sẽ ngắn lại tương ứng.

Thay đổi middleware trace của `api-cloud-service` chuyển đăng ký lên trước phần khởi tạo nền tảng. Cần kiểm tra lại luồng xác thực và phân quyền của service này sau khi phát hành, vì thứ tự middleware có đổi.

Service cần phát hành: `invoicecore`, `api-cloud-service`, `export-zip-pdf-service`, `invoice-sendmail-service`. Với `invoice-sendmail-service`, thay đổi đáng chú ý là `ConsumerApplication` và `ProducerApplication` chuyển min-level xuống `Info`; cần kiểm tra dung lượng log mail sau phát hành.

## Kiểm tra sau phát hành

Mỗi đợt, sau khi phát hành:

- Chạy các case tương ứng trong `testcase.md` trên môi trường vừa phát hành, dùng chuỗi sentinel `ZZ-sentinel-9335`, không dùng giá trị bí mật thật.
- Xác nhận service khởi động được và ghi log bình thường.
- Với đợt 2, theo dõi số lượng lỗi trong 24 giờ đầu và đối chiếu với mức trước phát hành.
- Với đợt 3, kiểm tra tốc độ tăng dung lượng tệp log, đặc biệt log của `invoice-sendmail-service` vì trước đây `Info` bị lọc ở cả Consumer và Producer.

## Hoàn tác

Cả ba đợt đều hoàn tác được bằng cách phát hành lại bản trước, vì không có thay đổi schema và không có migration.

Riêng đợt 1, việc hoàn tác sẽ khôi phục lại hành vi ghi thông tin xác thực ra log. Chỉ hoàn tác khi thực sự cần và phải xử lý dữ liệu log sinh ra trong khoảng thời gian đó.

## Cấu hình

Không có biến môi trường mới, không có khóa cấu hình mới, không có thay đổi manifest triển khai.

Có một thay đổi tệp cấu hình log: appender ghi log tích hợp VPBank của `invoicecore` được bổ sung trường trace ID trong mẫu định dạng. Thay đổi này nằm trong `log4net.config` đi kèm bản phát hành, không cần thao tác thủ công.
