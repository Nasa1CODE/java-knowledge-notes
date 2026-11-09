# CBCLOUDV2-8307 Impact (Draft)

## Purpose

Đánh giá phạm vi thay đổi cho `CBCLOUDV2-8307`: loại bỏ credential khỏi log Cyber ID và bổ sung trace ID cho HTTP request của `invoicecore` host.

## Phạm vi thay đổi / Change Scope

- Logic-only và observability-only trong `invoicecore/aspnet-core`.
- Không có database/schema/migration, API DTO/contract, queue/message, frontend hoặc cấu hình runtime mới.
- Layout file log thay đổi có chủ đích: thêm trường `traceId` vào mỗi dòng log của `VS.Web.Host`.

## Thành phần bị ảnh hưởng / Affected Components

| Layer | File / Component | Impact level | Ghi chú |
| --- | --- | --- | --- |
| Backend host | `VS.Web.Host/Infrastructure/TraceIdMiddleware.cs` | Medium | Middleware mới áp dụng toàn bộ inbound HTTP requests. |
| Backend host | `VS.Web.Host/Startup/Startup.cs` | Medium | Thêm middleware sớm trong request pipeline. |
| Logging | `VS.Web.Host/log4net.config` | Medium | Thêm `%property{traceId}` vào conversion pattern của rolling-file appender. |
| Backend application | `HDDT.Application/AppServices/Dashboard/DashBoard_DNAppService.cs` | Medium | Thay log request/response nhạy cảm của Cyber ID bằng endpoint/status an toàn. |
| Automated tests | `test/VS.Tests/*` | Low-Medium | Có thể cần điều chỉnh TFM/reference cũ để test được host middleware .NET Core 3.1. |
| Database | None | N/A | Không đổi bảng/cột/migration. |
| Queue/config | None | N/A | Không đổi RabbitMQ, MassTransit, Hangfire hay appsettings. |

## Không thuộc phạm vi / Confirmed Unaffected

- `invoicecore/angular/` và `invoicecore/TraCuu/`: server tự sinh trace ID khi client không gửi header nên không cần đổi client.
- `VS.Web.Public` và `VS.Migrator`: các host/log4net config riêng, không thuộc ticket.
- MassTransit, RabbitMQ, Hangfire và jobs nền: không truyền trace/correlation ID theo message trong scope này.
- Request/response contract với Cyber ID: payload, header, URL, parse response, và kết quả business giữ nguyên.
- Database, migration, Swagger/API contract, và các service top-level khác: không bị thay đổi.

## Rủi ro / Hạn chế đã biết / Known Risks and Limitations

- Nếu nhận trace ID không kiểm soát từ client, giá trị có thể gây log injection hoặc log bloat. Middleware phải dùng allowlist ASCII và giới hạn 128 ký tự.
- `LogicalThreadContext` phải được clear trong `finally`; nếu không, trace ID có thể bị leak giữa các requests chạy trên thread pool.
- Công cụ parse log dùng format cố định cần được kiểm tra vì mỗi dòng host log sẽ có thêm `traceId=<value>`.
- Chỉ xử lý logs Cyber ID trong `DashBoard_DNAppService` thuộc scope password/credential; audit rộng toàn bộ source hoặc các service khác là ngoài phạm vi ticket.
- Project test hiện target .NET Core 2.1 trong khi host target .NET Core 3.1; khả năng test middleware tự động cần được xác nhận lúc implementation.

## Chưa được kiểm chứng / Not Verified

- Chưa có code implementation hoặc build/test result tại thời điểm draft này.
- `git pull` trong `docs/` chưa hoàn thành trong phiên do remote yêu cầu credential tương tác; trạng thái tài liệu hiện tại đã được kiểm tra trước khi lập plan.
- Chưa xác nhận hành vi log layout trên log collector/alert production.

## Kết luận / Conclusion

Rủi ro tổng thể: Trung bình. Phạm vi code nhỏ và không đụng dữ liệu/contract, nhưng thay đổi áp dụng toàn bộ request host và có mục tiêu bảo mật nên cần test cleanup nghiêm ngặt, audit log Cyber ID theo sentinel, cùng kiểm tra log parser trước release.
