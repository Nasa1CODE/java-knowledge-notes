# Báo Cáo Phân Tích & Phương Án Xử Lý: Log `api-cloud-service` Bị Rời Rạc Trên Splunk

## 1. Hiện Tượng & So Sánh Thực Tế (Visual Comparison)

### Hiện tượng trên `api-cloud-service` (Theo ảnh đính kèm):
* **Host:** `inv1_webservicebill_214`, `inv1_webservicebill_215` (chạy service tại `/opt/cyberbillws/App_Data/Logs/Logs.txt`).
* **Sourcetype:** **`access_combined`**
* **Timestamp:** **`timestamp = none`**
* **Vấn đề hiển thị:**
  * Toàn bộ Exception và Stack Trace bị **xé vụn thành từng dòng riêng lẻ (single-line events)**:
    - Event 1: `at Pomelo.EntityFrameworkCore.MySql...`
    - Event 2: `at MySql.Data.MySqlClient.MySqlDataReader.CreateAsync...`
    - Event 3: `at MySql.Data.MySqlClient.MySqlDataReader.ReadFirstResultSetAsync...`
    - Event 4: `at MySql.Data.MySqlClient.MySqlDataReader.ActivateResultSet...`
    - Event 5: `Microsoft.EntityFrameworkCore.DbUpdateException: An error occurred while updating the entries...`
  * Thứ tự các dòng bị đảo lộn hoặc phân tán giữa các host `214` và `215`, không thể nhìn ra ngữ cảnh lỗi ban đầu.

---

### So sánh với service `invoicecore`:
* **Host:** `inv1_cyberbill_202`, `inv1_cyberbill4_207` (chạy service tại `/opt/cyberbillapp/App_Data/Logs/Logs.txt`).
* **Sourcetype:** **`Logs-24`** (hoặc `Logs-too_small`).
* **Timestamp:** Nhận diện chính xác đến từng mili-giây: `9/10/26 5:23:49.902 PM`.
* **Hiển thị:** Cả khối log lỗi (gồm dòng mở đầu `ERROR 2026-09-10 ... [traceId=...]` kèm toàn bộ các dòng `at ...` bên dưới) được gom trọn vẹn thành **1 Event duy nhất (Multiline Event)**.

---

## 2. Nguyên Nhân Gốc Rễ (Root Cause)

Nguyên nhân **100% nằm ở cấu hình Sourcetype trên Splunk**, không phải do code C# bị sai:

### 1. Splunk bị gán sai Sourcetype `access_combined`:
* `access_combined` là sourcetype mặc định có sẵn của Splunk dành riêng cho **Web Access Log (Apache / Nginx Access Log)**.
* Khi cấu hình Splunk Universal Forwarder trên các máy `inv1_webservicebill_214/215` để đọc file `/opt/cyberbillws/App_Data/Logs/Logs.txt`:
  * Người cấu hình đã chọn nhầm `sourcetype = access_combined`, HOẶC
  * Không cấu hình sourcetype cụ thể mà để Splunk tự động nhận diện (auto-detect). Do có các đường dẫn URL API trong log, Splunk đã đoán nhầm thành Apache access log.

### 2. Đặc tính của sourcetype `access_combined`:
* **Ép ngắt từng dòng (`SHOULD_LINEMERGE = false`):** Vì access log của web server mỗi dòng là 1 request riêng biệt, `access_combined` mặc định coi **mỗi ký tự xuống dòng (`\n`) là một Event mới**. Khi gặp Exception có 30 dòng stack trace, Splunk sẽ cắt thành 30 events rời rạc.
* **Không đọc được Timestamp (`timestamp = none`):** `access_combined` chỉ tìm định dạng ngày giờ của Apache (dạng `[10/Oct/2026:13:55:36 +0700]`). Nó hoàn toàn không nhận diện được ngày giờ của `log4net` (`2026-09-10 16:39:48,000`), dẫn đến việc Splunk báo `timestamp = none` và hiển thị mốc thời gian index tùy tiện.

---

## 3. So Sánh File Cấu Hình Log4Net Giữa 2 Service

Cả 2 service đều dùng **log4net** và ghi ra file `App_Data/Logs/Logs.txt`:

* **`api-cloud-service`** ([`log4net.config`](file:///Users/vuvantien/Work/CyberLotus/xBill/cloud/api-cloud-service/src/zero/VS.Web.Host/log4net.config#L19)):
  ```xml
  <conversionPattern value="%-5level %date [%-5.5thread] [traceId=%property{traceId}] %-40.40logger - %message%newline" />
  ```
* **`invoicecore`** ([`log4net.config`](file:///Users/vuvantien/Work/CyberLotus/xBill/cloud/invoicecore/aspnet-core/src/zero/VS.Web.Host/log4net.config#L11)):
  ```xml
  <conversionPattern value="%-5level %date [%-5.5thread] %-40.40logger - %message%newline" />
  ```

> **Nhận xét:** Cả 2 service đều mở đầu dòng log bằng: `LEVEL YYYY-MM-DD HH:mm:ss,fff [thread]`. Định dạng này chuẩn 100% cho việc gộp multiline log. Lý do duy nhất `invoicecore` hiển thị đẹp là vì nó đang dùng đúng sourcetype **`Logs-24`**.

---

## 4. Phương Án Xử Lý Triệt Để

Để log của `api-cloud-service` gom nhóm thành 1 khối và parse được timestamp chuẩn xác như `invoicecore`, DevOps / Quản trị viên Splunk cần cấu hình lại theo 1 trong 2 cách sau:

### Cách 1: Đổi Sourcetype sang `Logs-24` trên Splunk Forwarder (Nhanh nhất & Khuyến nghị)

Trên 2 server `inv1_webservicebill_214` và `inv1_webservicebill_215`:

1. Mở file cấu hình Splunk Forwarder:
   ```bash
   sudo vi /opt/splunkforwarder/etc/apps/search/local/inputs.conf
   # (hoặc /opt/splunkforwarder/etc/system/local/inputs.conf)
   ```
2. Tìm đến mục monitor của thư mục `/opt/cyberbillws/App_Data/Logs/Logs.txt`:
   ```ini
   # CẤU HÌNH CŨ (GÂY LỖI):
   [monitor:///opt/cyberbillws/App_Data/Logs/Logs.txt]
   sourcetype = access_combined

   # SỬA LẠI THÀNH:
   [monitor:///opt/cyberbillws/App_Data/Logs/Logs.txt]
   disabled = 0
   index = bill-ht02-app
   sourcetype = Logs-24
   ```
3. Khởi động lại Splunk Forwarder:
   ```bash
   sudo /opt/splunkforwarder/bin/splunk restart
   ```

---

### Cách 2: Định Nghĩa Rule Multiline Cho Sourcetype Trong `props.conf` (Chuẩn chuyên gia Splunk)

Trên **Splunk Indexer / Heavy Forwarder** (nơi xử lý parsing dữ liệu):

Thêm cấu hình vào file `props.conf` (ví dụ gán cho `sourcetype = Logs-24` hoặc tạo mới `sourcetype = cyberbillws_log`):

```ini
[Logs-24]
# Không dùng linemerge kiểu cũ, dùng LINE_BREAKER regex để tối ưu hiệu năng
SHOULD_LINEMERGE = false

# Chỉ ngắt Event mới khi gặp dòng bắt đầu bằng LEVEL (FATAL|ERROR|WARN|INFO|DEBUG) và Ngày Tháng
LINE_BREAKER = ([\r\n]+)(?=(?:DEBUG|INFO|WARN|ERROR|FATAL)\s+\d{4}-\d{2}-\d{2})

# Nhận diện vị trí và định dạng ngày giờ của log4net
TIME_PREFIX = ^(?:DEBUG|INFO|WARN|ERROR|FATAL)\s+
TIME_FORMAT = %Y-%m-%d %H:%M:%S,%3N
MAX_TIMESTAMP_LOOKAHEAD = 35

# Tối đa số ký tự trong 1 event (tránh bị cắt cụt stack trace dài)
TRUNCATE = 50000
```

---

## 5. Kết Quả Sau Khi Khắc Phục

Ngay sau khi áp dụng cấu hình trên:
1. Mỗi lỗi Exception (kèm toàn bộ stack trace `at Pomelo...`, `at MySql...`) sẽ được **gộp trọn vẹn vào 1 Event duy nhất**.
2. Cột **Time** trên Splunk sẽ hiển thị đúng thời gian thực tế của log thay vì `timestamp = none`.
3. Bạn có thể tìm kiếm theo `traceId`, `UserId` hoặc `Exception` một cách dễ dàng và đồng nhất giữa `api-cloud-service` và `invoicecore`.
