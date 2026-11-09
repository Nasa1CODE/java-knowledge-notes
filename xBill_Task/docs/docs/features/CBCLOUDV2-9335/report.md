# CBCLOUDV2-9335 Report

> Kết quả dưới đây chỉ ghi những kiểm tra đã chạy thật trong phiên làm việc. Các kiểm thử phụ thuộc môi trường runtime, RabbitMQ/Kafka/FTP/Cyber ID/VPBank/HSM hoặc truy vấn DB audit được liệt kê riêng là chưa chạy.

## Trạng thái

- Ngày chạy: 2026-09-03
- Người chạy: Claude Code
- Môi trường: Windows 10 Pro 10.0.19045, PowerShell, .NET SDK 8.0.100, Maven Wrapper của từng service Java
- Nhánh và revision:

| Repo/service | Branch | Revision |
| --- | --- | --- |
| `invoicecore` | `deploy/dev_v2` | `eb5a64f88` |
| `api-cloud-service` | `deploy/pre_v2` | `081d02b` |
| `invoice-management` | `develop_ls` | `da9f9062` |
| `export-zip-pdf-service` | `deploy/cloud` | `3a927f4` |
| `bangke-dctt-java-service` | `manh/dev` | `0b3ec38` |
| `etran-teanant-service` | `deploy/futa` | `bf8e8b8` |
| `invoice-sendmail-service` | `deploy/cloud/dev` | `1beda6e` |
| `docs` | `docs/xbill-cloud` | `11c2abb` |

## Kết quả build

### .NET

| Solution | Lệnh | Kết quả | Bằng chứng | Ghi chú |
| --- | --- | --- | --- | --- |
| `invoicecore` | `dotnet build "d:\Source\bill_cloud\invoicecore\aspnet-core\VS.Web.sln" --nologo -v:minimal` | Passed | `Build succeeded`; `230 Warning(s)`, `0 Error(s)`, `[exited with code 0]` | Warnings hiện hữu: target `netcoreapp3.1` hết hỗ trợ, package vulnerabilities, warning compile cũ. |
| `api-cloud-service` | `dotnet build "d:\Source\bill_cloud\api-cloud-service\VS.WS.sln" --nologo -v:minimal` | Passed | `Build succeeded`; `0 Error(s)`, `[exited with code 0]` | Lần đầu fail do `ResultDto` ambiguous sau khi thêm `using WS.Core.Commons`; đã sửa bằng fully-qualified `WS.Core.Commons.LogSanitizer`. |
| `invoice-management` | `dotnet build "d:\Source\bill_cloud\invoice-management\aspnet-core\VS.Web.sln" --nologo -v:minimal` | Passed | `Build succeeded`; `0 Error(s)`, `[exited with code 0]` | Lần đầu fail do `ServiceTaxType` ambiguous; đã sửa bằng fully-qualified enum ở `HoaDonAppService.cs`. |
| `export-zip-pdf-service` | `dotnet build "d:\Source\bill_cloud\export-zip-pdf-service\bill-worker-service.sln" --nologo -v:minimal` | Passed | `Build succeeded`; `0 Error(s)`, `[exited with code 0]` | Warnings hiện hữu: target/package cũ và warning compile không thuộc scope. |
| `invoice-sendmail-service` | `dotnet build "d:\Source\bill_cloud\invoice-sendmail-service\bill-sendmail-service.sln" --nologo -v:minimal` | Passed | `Build succeeded`; `9 Warning(s)`, `0 Error(s)`, `Time Elapsed 00:00:10.40` | Warnings hiện hữu/ngoài scope: `netcoreapp3.1` hết hỗ trợ, `Newtonsoft.Json` advisory, unreachable code, biến `base64Pdf` không dùng. |

Output đã đọc/lưu trong phiên:

```text
invoicecore: Build succeeded; 230 Warning(s); 0 Error(s); Time Elapsed 00:00:54.16; [exited with code 0]
api-cloud-service: Build succeeded; 0 Error(s); [exited with code 0]
invoice-management: Build succeeded; 0 Error(s); [exited with code 0]
export-zip-pdf-service: Build succeeded; 0 Error(s); [exited with code 0]
invoice-sendmail-service: Build succeeded; 9 Warning(s); 0 Error(s); Time Elapsed 00:00:10.40
```

### Java

| Service | Lệnh | Kết quả | Bằng chứng | Ghi chú |
| --- | --- | --- | --- | --- |
| `bangke-dctt-java-service` | `Push-Location "d:\Source\bill_cloud\bangke-dctt-java-service"; .\mvnw.cmd -q -DskipTests compile` | Passed | `[exited with code 0]` | Trước đó fail vì `mvn` không có trong PATH; chạy wrapper sai thư mục; sau đó fail compile vì illegal escape `"\?"`. Đã sửa thành `"\\?"`. |
| `etran-teanant-service` | `Push-Location "d:\Source\bill_cloud\etran-teanant-service"; .\mvnw.cmd -q -DskipTests compile` | Passed | `[exited with code 0]` | Cùng nguyên nhân và cách sửa như trên. |

Output đã đọc/lưu trong phiên:

```text
bangke-dctt-java-service: [exited with code 0]
etran-teanant-service: [exited with code 0]
```

Các lỗi Java đã gặp và đã xử lý:

```text
mvn : The term 'mvn' is not recognized...
The system cannot find the file D:\Source\bill_cloud\.mvn\wrapper\maven-wrapper.properties.
Error: Could not find or load main class org.apache.maven.wrapper.MavenWrapperMain
StringHelper.java:[108,37] illegal escape character
StringHelper.java:[104,37] illegal escape character
```

## Kết quả rà soát tĩnh

### Lệnh 1 — không còn log ghép giá trị nhạy cảm trong scope

Đã chạy tách theo từng repo/thư mục để tránh timeout khi quét toàn workspace:

```text
invoicecore/aspnet-core/src: No matches found
api-cloud-service/src: No matches found
invoice-management/aspnet-core/src: No matches found
bangke-dctt-java-service/src/main/java: No matches found
etran-teanant-service/src/main/java: No matches found
```

Ghi chú: lệnh broad trên toàn `d:\Source\bill_cloud` bị timeout sau 20 giây, nên kết quả chốt là 5 lệnh con theo đúng scope service.

### Lệnh 2 — không còn ghi thẳng stdout trong đường ký số

```text
rg -n 'Console\.(Out\.)?Write(Line)?' invoicecore/aspnet-core/src/hddt/HDDT.Application/Commons/ChuKySo/
No matches found
```

### Lệnh 3 — không còn dump thân request/response ở các tệp đã sửa

Kết quả rà `invoice-management/.../QuanLyUserAppService.cs` và `invoicecore/.../SignFile.cs` còn các tên biến `datares`, `stringPayload`, `base64xmlSigned`, nhưng đã rà mắt xác nhận là:

- đọc response để parse JSON hoặc deserialize nghiệp vụ;
- truyền payload vào request/HMAC property để xử lý ký;
- log chỉ ghi `responseLength`, `payloadLength`, `signedXmlLength` hoặc URL đã qua `LogSanitizer.MaskUrl`;
- không còn dòng log/comment dump raw `datares`, `stringPayload`, `base64xmlSigned`.

Các dòng bằng chứng tiêu biểu:

```text
QuanLyUserAppService.cs: Logger... MaskUrl(apiUrl) ... responseLength:{datares?.Length ?? 0}
SignFile.cs: Logger... payloadLength:{stringPayload?.Length ?? 0} signedXmlLength:{dataResult.base64xmlSigned?.Length ?? 0}
```

### Lệnh 4 — không còn khối catch rỗng ở các tệp đã sửa

```text
SendQueueMessage.cs: No matches found
HoaDonAppService.cs: No matches found
```

### Lệnh 5 — solution không còn project mồ côi

```text
rg -n "TraceIdMiddleware.Tests" invoicecore/aspnet-core/VS.Web.sln
No matches found
```

### Lệnh 6 — kiểm tra riêng FTPUtils không còn log PASSWORD

```text
bangke-dctt-java-service/.../FTPUtils.java: còn biến cấu hình/biến đăng nhập ftpPassword để kết nối FTP, không còn log PASSWORD.
etran-teanant-service/.../FTPUtils.java: còn biến cấu hình/biến đăng nhập ftpPassword để kết nối FTP, không còn log PASSWORD.
```

### Lệnh 7 — kiểm tra riêng invoice-sendmail-service

Chạy trong `d:\Source\bill_cloud\invoice-sendmail-service`, loại trừ `bin/` và `obj/` khi áp dụng:

```text
rg -n 'throw ex;' ...
No matches found

rg -n 'Console\.(Out\.)?Write(Line)?' ...
No matches found

rg -n -i '(_logger|Logger)\.(LogInformation|LogWarning|LogError|LogDebug|LogCritical|Info|Warn|Error|Debug)[^;]*\b(password|matkhau|MatKhau|secret|token|authorization|apikey|api_key)\b' ConsumerApplication ProducerApplication Common.Logging EntityFramework EventBus.Messages
No matches found

rg -n -U 'catch\s*\([^)]*\)\s*\{\s*\}' ConsumerApplication ProducerApplication Common.Logging EntityFramework EventBus.Messages
No matches found
```

Ghi chú: scan rộng ngoài scope còn thấy `DongBoNldApplication/Features/ExcecutionSynchronized.cs` có mẫu log yếu, nhưng `DongBoNldApplication/` không nằm trong `bill-sendmail-service.sln` và phụ thuộc type không có trong repo nên không xử lý trong đợt này.

## Kết quả kiểm thử

| TC | Tên | Kết quả | Bằng chứng | Ghi chú |
| --- | --- | --- | --- | --- |
| TC01 | Build các solution .NET | Passed | 5 solution đều `Build succeeded`, `0 Error(s)` | Có warnings hiện hữu ngoài scope. |
| TC02 | Build 2 service Java | Passed | 2 service `[exited with code 0]` bằng Maven Wrapper | Đã sửa lỗi escape trong `StringHelper.java`. |
| TC03 | Không còn log ghép giá trị nhạy cảm | Passed | 5 lệnh scan theo repo đều `No matches found` | Scan toàn workspace timeout nên đã tách theo scope. |
| TC04 | Không còn ghi thẳng stdout | Passed | `No matches found` trong `ChuKySo/` | |
| TC05 | Không còn dump thân request/response | Passed with review | Chỉ còn tên biến phục vụ parse/truyền request; log chỉ ghi length/masked URL | Không chạy runtime. |
| TC06 | Không còn catch rỗng | Passed | `No matches found` ở `SendQueueMessage.cs` và `HoaDonAppService.cs` | |
| TC07 | Solution không còn tham chiếu mồ côi | Passed | `TraceIdMiddleware.Tests`: `No matches found`; `invoicecore` build passed | |
| TC07a | `invoice-sendmail-service` build thành công | Passed | `Build succeeded`; `9 Warning(s)`, `0 Error(s)`, `Time Elapsed 00:00:10.40` | Runtime chưa chạy. |
| TC07b | `invoice-sendmail-service` scan tĩnh sạch | Passed | `throw ex;`, stdout, sensitive-keyword log, catch rỗng đều `No matches found` trong in-scope project | `DongBoNldApplication/` ngoài scope. |
| TC08 | Đăng nhập sai không để mật khẩu trong log | Not run | Chưa có môi trường runtime/service đang chạy | Cần chạy trên môi trường DEV/SIT với sentinel. |
| TC09 | Đăng nhập sai không để mật khẩu trong audit | Not run | Chưa có kết nối DB audit runtime | Cần truy vấn `AbpAuditLogs`. |
| TC10 | Đặt lại mật khẩu Cyber ID không ghi payload | Not run | Chưa có môi trường Cyber ID/runtime | |
| TC11 | Ký số không lộ thông tin xác thực ra stdout | Not run | Chưa chạy flow ký thật | Static stdout scan đã passed. |
| TC12 | Log ký số không chứa XML thô | Not run | Chưa chạy flow ký thật | Static review đã passed cho raw log/comment. |
| TC13 | Đẩy tệp FTP không ghi mật khẩu | Not run | Chưa có FTP runtime/log runtime | Static scan không còn log PASSWORD. |
| TC14 | Kafka gửi TCT không ghi mật khẩu | Not run | Chưa có Kafka/runtime | Static scan passed. |
| TC15 | VPBank không lộ token ở nhánh thất bại | Not run | Chưa có môi trường VPBank/runtime | Static code đã dùng mask/truncate. |
| TC16 | Lệnh tái hiện không chứa header xác thực | Not run | Chưa chạy tích hợp VPBank | Static code đã mask header/body nhạy cảm. |
| TC16a | Gửi mail không ghi password/body/recipient/attachment/XML | Not run | Chưa chạy `invoice-sendmail-service` với SMTP runtime và sentinel | Static scan sensitive-keyword log đã passed. |
| TC17 | Đẩy message VAN thất bại có log | Not run | Chưa tắt RabbitMQ/chạy flow runtime | |
| TC18 | Xuất file thất bại báo đúng | Not run | Chưa tắt RabbitMQ/chạy UI/runtime | Có thay đổi hành vi cần QA/TechLead review trước deploy. |
| TC19 | Xuất file thành công không đổi | Not run | Chưa chạy UI/runtime | |
| TC20 | Consumer Fault không ném lỗi null | Not run | Chưa đẩy message Fault runtime | Build passed. |
| TC21 | Job cron lỗi vẫn sống và có log | Not run | Chưa chạy cron với cấu hình lỗi | Build passed. |
| TC22 | Tra cứu công khai ghi lý do | Not run | Chưa chạy API runtime | Build passed. |
| TC22a | SendMailConsumer lỗi có log trước khi MassTransit xử lý | Not run | Chưa chạy RabbitMQ/runtime của `invoice-sendmail-service` | Static code đã có catch log rồi `throw;`. |
| TC22b | QueryProducer timer lỗi vẫn sống và có log | Not run | Chưa chạy producer với cấu hình lỗi runtime | Build passed; catch chỉ log, không rethrow. |
| TC22c | Lỗi XML mail/VAN không bị nuốt im lặng | Not run | Chưa chạy case runtime sinh XML lỗi | Static scan catch rỗng đã passed. |
| TC23 | Lời gọi qua factory sinh log đầy đủ | Not run | Chưa chạy ký hóa đơn runtime | Build passed. |
| TC24 | Lời gọi qua factory thất bại vẫn sinh log | Not run | Chưa trỏ lỗi service ký/runtime | Build passed. |
| TC25 | Handler không ghi thân và header | Not run | Chưa kiểm log runtime | Static implementation không log body/header. |
| TC26 | Gửi TCT có log kết quả | Not run | Chưa có Kafka/runtime | Build passed. |
| TC27 | Gọi API BHXH lỗi có log | Not run | Chưa có runtime | Build passed. |
| TC28 | Trace ID giữ qua một hop | Not run | Chưa chạy `api-cloud-service` runtime | Build passed. |
| TC29 | Trace ID sinh mới khi thiếu hoặc sai | Not run | Chưa chạy `api-cloud-service` runtime | Build passed. |
| TC30 | Log VPBank có trường trace ID | Not run | Chưa chạy tích hợp VPBank runtime | Static config đã thêm `%property{traceId}`. |
| TC31 | Request đi ra mang header trace | Not run | Chưa quan sát request runtime | Static code đã thêm header `X-Trace-Id`. |
| TC31a | SMTP của `invoice-sendmail-service` có log bắt đầu/kết thúc | Not run | Chưa chạy gửi mail thật | Build passed; cần SMTP runtime để xác nhận log file. |
| TC31b | FTP download của `invoice-sendmail-service` có log bắt đầu/kết thúc/lỗi | Not run | Chưa chạy FTP runtime | Build passed; static code không log FTP password. |
| TC31c | HTTP handler của `invoice-sendmail-service` không log query nhạy cảm | Not run | Handler chưa có call site runtime trong solution | Static code dùng `LogSanitizer.MaskUrl` và không log body/header. |
| TC32 | Phản hồi API không đổi | Not run | Chưa chạy regression API runtime | |
| TC33 | Lời gọi Cyber ID không đổi | Not run | Chưa đối chiếu runtime Cyber ID | Code chỉ đổi log/audit attribute theo scope. |
| TC34 | Ký số cho kết quả không đổi | Not run | Chưa chạy ký thật | |
| TC35 | Audit vẫn ghi cho action khác | Not run | Chưa truy vấn DB audit runtime | |

## Kiểm tra chưa thực hiện được

Các case runtime từ TC08 trở đi chưa chạy vì cần môi trường ứng dụng đang chạy và/hoặc phụ thuộc ngoài: DB audit, RabbitMQ, Kafka, FTP, SMTP, Cyber ID, VPBank, HSM/signing-service, log runtime/container và thao tác UI. Không đánh dấu đạt cho các case này trong tài liệu.

## Sai lệch so với kế hoạch

- Lệnh Java trong `plan.md` dùng `mvn`, nhưng máy hiện tại không có `mvn` trong PATH. Đã dùng Maven Wrapper `.\mvnw.cmd` trong thư mục từng service.
- Chạy wrapper bằng đường dẫn tuyệt đối từ workspace root làm wrapper tìm sai `.mvn/wrapper/maven-wrapper.properties` ở `d:\Source\bill_cloud\.mvn`. Đã chạy lại bằng `Push-Location` vào thư mục service trước.
- Lỗi compile Java phát sinh do chuỗi regex `"\?"` trong Java là illegal escape. Đã sửa thành `"\\?"` trong cả hai `StringHelper.java`.
- `api-cloud-service` build từng fail do thêm `using WS.Core.Commons` gây ambiguous `ResultDto`. Đã bỏ using và gọi `WS.Core.Commons.LogSanitizer.MaskUrl` bằng fully-qualified name.
- `invoice-management` build từng fail do ambiguous `ServiceTaxType`. Đã fully qualify `HDDT.Application.Commons.Commons.ServiceTaxType` tại các điểm lỗi.
- `OutboundLoggingHandler` theo kế hoạch đặt cạnh `LogSanitizer` trong Core, nhưng implementation đặt tại `invoicecore/aspnet-core/src/hddt/HDDT.Application/Commons/ChuKySo/Lib/OutboundLoggingHandler.cs` cạnh `HttpClientFactory`/`HMACDelegatingHandler` để dùng trực tiếp trong chuỗi handler ký số.
- `Task C2.2` có ghi cần TechLead xác nhận riêng trước thay đổi hành vi. Code đã được sửa theo yêu cầu thực hiện; trước deploy vẫn cần TechLead/QA review riêng cho luồng xuất file.
- `Task C2.3` không tự bật lại xử lý resend đang bị comment. Chỉ sửa log cho đúng sự thật và để TODO theo ticket.
- `invoice-sendmail-service/DongBoNldApplication/` không được sửa vì không nằm trong `bill-sendmail-service.sln` và phụ thuộc type không có trong repo; một mẫu log yếu còn lại ở đây được ghi là ngoài phạm vi.

## Tệp thực tế đã thay đổi

### `invoicecore/`

- `aspnet-core/VS.Web.sln`
- `aspnet-core/src/hddt/HDDT.Application/AppServices/Dashboard/DashBoard_DNAppService.cs`
- `aspnet-core/src/hddt/HDDT.Application/AppServices/HoaDon/HoaDonAppService.cs`
- `aspnet-core/src/hddt/HDDT.Application/AppServices/HoaDon/TraCuuHoaDonAppService.cs`
- `aspnet-core/src/hddt/HDDT.Application/AppServices/VPBank/VPBankLendingAppService.cs`
- `aspnet-core/src/hddt/HDDT.Application/Commons/ChuKySo/Lib/HMACDelegatingHandler.cs`
- `aspnet-core/src/hddt/HDDT.Application/Commons/ChuKySo/Lib/HttpClientFactory.cs`
- `aspnet-core/src/hddt/HDDT.Application/Commons/ChuKySo/Lib/OutboundLoggingHandler.cs`
- `aspnet-core/src/hddt/HDDT.Application/Commons/ChuKySo/SignFile.cs`
- `aspnet-core/src/hddt/HDDT.Application/Commons/Commons/SendQueueMessage.cs`
- `aspnet-core/src/hddt/HDDT.Core/Commons/LogSanitizer.cs`
- `aspnet-core/src/zero/VS.Web.Core/Controllers/TokenAuthController.cs`
- `aspnet-core/src/zero/VS.Web.Host/log4net.config`

### `api-cloud-service/`

- `src/hddt/WS.Application/AppServices/HoaDon/GuiHoaDonAppService.cs`
- `src/hddt/WS.Application/Commons/Kafka/Producer/TCTProducer.cs`
- `src/hddt/WS.Core/Commons/LogSanitizer.cs`
- `src/zero/VS.Web.Core/Controllers/TokenAuthController.cs`
- `src/zero/VS.Web.Host/Middleware/TraceIdMiddleware.cs`
- `src/zero/VS.Web.Host/Startup/Startup.cs`

### `invoice-management/`

- `aspnet-core/src/hddt/HDDT.Application/AppServices/DoanhNghiep/HoaDonAppService.cs`
- `aspnet-core/src/hddt/HDDT.Application/AppServices/QuanLy/QuanLyUserAppService.cs`
- `aspnet-core/src/hddt/HDDT.Core/Commons/LogSanitizer.cs`

### `export-zip-pdf-service/`

- `ConsumerApplication/EventBusComsumer/SendDataBKFaultConsumer.cs`
- `EntityFramework/Ef.Core/ApiHelper/CallApiHelper.cs`
- `EntityFramework/Ef.Core/Ef.Core.csproj`
- `MixPosInvProducer/Producers/CronJobService.cs`
- `MixPosInvProducer/Producers/QueryPosProducer.cs`
- `ResendInvConsumer/EventBusComsumer/ResendConsumer.cs`

### `bangke-dctt-java-service/`

- `src/main/java/vn/sample/multitenancy/utils/FTPUtils.java`
- `src/main/java/vn/sample/multitenancy/utils/SignFile.java`
- `src/main/java/vn/sample/multitenancy/utils/StringHelper.java`

### `etran-teanant-service/`

- `src/main/java/vn/sample/multitenancy/utils/FTPUtils.java`
- `src/main/java/vn/sample/multitenancy/utils/StringHelper.java`

### `invoice-sendmail-service/`

- `Common.Logging/LoggingDelegatingHandler.cs`
- `Common.Logging/LogSanitizer.cs`
- `ConsumerApplication/Common/CommonSendmail.cs`
- `ConsumerApplication/Common/EmailManager.cs`
- `ConsumerApplication/Common/FileManager.cs`
- `ConsumerApplication/EventBusComsumer/SendMailConsumer.cs`
- `ConsumerApplication/Features/Commands/SendMailHandler.cs`
- `ConsumerApplication/Program.cs`
- `ConsumerApplication/nlog.config`
- `ConsumerApplication/QuanLyHoaDon/HoaDonUtil/HoaDonTT3268Utility.cs`
- `ConsumerApplication/QuanLyHoaDon/HoaDonUtil/HoaDonUtility.cs`
- `ConsumerApplication/QuanLyHoaDon/HoaDonUtil/HoaDonUtilityBase.cs`
- `EntityFramework/Ef.Core/Helper/FilePathHelper.cs`
- `ProducerApplication/Program.cs`
- `ProducerApplication/nlog.config`
- `ProducerApplication/Services/QueryProducer.cs`

### `docs/`

- `features/CBCLOUDV2-8307/tasks.md`
- `features/CBCLOUDV2-9335/deploy.md`
- `features/CBCLOUDV2-9335/expect.md`
- `features/CBCLOUDV2-9335/impact.md`
- `features/CBCLOUDV2-9335/plan.md`
- `features/CBCLOUDV2-9335/report.md`
- `features/CBCLOUDV2-9335/tasks.md`
- `features/CBCLOUDV2-9335/testcase.md`
