# CBCLOUDV2-8307 Plan

## Status

- Status: plan-review (chờ Gate 1: DEV review + TechLead approve).
- `docs/` đã được kiểm tra trong phiên này; `git pull` không thể hoàn thành do remote yêu cầu xác thực tương tác. Không có thay đổi source nào được thực hiện trong giai đoạn planning.

## Goal

Ngăn mật khẩu và dữ liệu xác thực nhạy cảm bị ghi vào log của `invoicecore`, đồng thời gắn một trace ID cho từng HTTP request vào `VS.Web.Host` để truy vết log theo request.

## Context

- `invoicecore/aspnet-core/` là backend ASP.NET Core 3.1/ASP.NET Zero; host là `src/zero/VS.Web.Host`.
- Host khởi tạo log4net qua `Abp.Castle.Log4Net` tại `Startup.ConfigureServices`; log format hiện tại ở `VS.Web.Host/log4net.config` chưa có trace ID.
- `DashBoard_DNAppService` trong `HDDT.Application` hiện có các log Cyber ID ghi JSON request, raw response hoặc URL query. Các flow đổi/kiểm tra mật khẩu có thể chứa password, password confirmation, access/bearer token, OTP hoặc response nhạy cảm.
- `docs/specs/system.md` yêu cầu secrets, passwords, JWTs và tokens không được ghi log; observability phải đủ để chẩn đoán lỗi mà không lộ dữ liệu nhạy cảm.

## Assumptions / Open Questions / Out Of Scope

- Chấp nhận `X-Trace-Id` do client gửi chỉ khi giá trị hợp lệ theo giới hạn an toàn được định nghĩa trong middleware; giá trị vắng mặt/không hợp lệ sẽ được thay bằng GUID server-generated, không trả 400.
- Trace ID chỉ áp dụng HTTP request của `VS.Web.Host`; không truyền sang RabbitMQ, MassTransit, Hangfire hoặc job background.
- Scope Cyber ID là các flow có khả năng log password hoặc request/URL/response mang credential: `ChangePasswordCyberIdInsideApp`, `ApiCheckPasswordCyberId`, `ApiCreateAccountCyberId`, `ApiChangePassCyberId`, và các biến thể login/password-reset cùng file nếu log của chúng có payload/URL/raw response nhạy cảm.
- Không mã hóa mật khẩu trong log. Giá trị nhạy cảm phải bị loại bỏ hoàn toàn, vì ciphertext vẫn là dữ liệu bí mật có thể bị giải mã hoặc replay.
- Không thay đổi outbound HTTP request, API contract, DB schema, migration, configuration value, frontend, queue payload hoặc auth behavior.

## File Structure

| File | Change | Responsibility |
| --- | --- | --- |
| `invoicecore/aspnet-core/src/zero/VS.Web.Host/Infrastructure/TraceIdMiddleware.cs` | Create | Resolve, expose, set, and clear the request trace ID. |
| `invoicecore/aspnet-core/src/zero/VS.Web.Host/Startup/Startup.cs` | Modify | Register trace middleware early enough to cover request logs. |
| `invoicecore/aspnet-core/src/zero/VS.Web.Host/log4net.config` | Modify | Render `traceId` from log4net logical context. |
| `invoicecore/aspnet-core/src/hddt/HDDT.Application/AppServices/Dashboard/DashBoard_DNAppService.cs` | Modify | Replace unsafe Cyber ID log messages with endpoint/status-only diagnostics. |
| `invoicecore/aspnet-core/test/VS.Tests/VS.Tests.csproj` | Modify only if needed | Upgrade/adapt test target and references to make host middleware testable; do not alter existing tests otherwise. |
| `invoicecore/aspnet-core/test/VS.Tests/Web/TraceIdMiddlewareTests.cs` | Create | Automated checks for received/generated IDs and logical-context cleanup. |
| `docs/features/CBCLOUDV2-8307/{tasks,impact,testcase,report}.md` | Create/update | Track approved work, blast radius, test scenarios, and actual evidence. |

## Impact Assessment

### Backend

| Component | Impact | Reason |
| --- | --- | --- |
| `VS.Web.Host` request pipeline | Medium | Adds one lightweight middleware to every inbound request and response. |
| Host log4net file output | Medium | Adds an always-present `traceId` field to host log lines; parsers/alerts consuming a fixed layout must tolerate the new field. |
| `DashBoard_DNAppService` Cyber ID methods | Medium | Removes sensitive diagnostics while retaining endpoint and status diagnostics. |
| Existing application/ABP log calls | Low | No call-site changes; logs inside an HTTP request inherit context automatically. |

### Unaffected

- `invoicecore/angular/` and `invoicecore/TraCuu/`: no UI or client requirement to send a trace header; server generates one when absent.
- `VS.Web.Public` and `VS.Migrator`: separate hosts/configurations, outside this ticket.
- RabbitMQ/MassTransit/Hangfire and background jobs: no correlation propagation in this scope.
- Cyber ID request contents and responses: unchanged; only local log content changes.
- Database, EF migrations, API DTOs, Swagger contracts, deployment config and other top-level services: unchanged.

## Dependency & Implementation Order

1. Create focused middleware tests before production middleware, adapting the legacy test project only when required to compile against the web host.
2. Implement middleware and register it in `Startup` so it is active before validation, authentication, controllers, and app-service logs.
3. Add the log4net layout property once middleware is available; then a request trace becomes visible in log lines.
4. Replace unsafe Cyber ID logs and add static/log-capture assertions for representative password values.
5. Build and run targeted tests, then manually verify response headers and log correlation in a non-production environment.
6. Finalize feature docs with real evidence. Tasks 1-3 are sequential; documentation depends on completed verification.

## Implementation Approach

### Trace ID middleware

Create a dedicated middleware class under the web host. It uses constants for `X-Trace-Id` and `traceId`, reads the first request-header value, and treats it as valid only when it has 1-128 ASCII characters from `[A-Za-z0-9._-]`. A missing, overlong, or malformed header results in `Guid.NewGuid().ToString("N")`.

Before calling `_next(context)`, set `context.Response.Headers["X-Trace-Id"]` and `LogicalThreadContext.Properties["traceId"]`. Use `try/finally` and `LogicalThreadContext.Properties.Remove("traceId")` in `finally`. Add `app.UseMiddleware<TraceIdMiddleware>()` immediately after `app.UseAbp(...)` and before exception, static-file, routing, authentication, controller, and application-service middleware.

### Host log layout

Extend the rolling file conversion pattern to include `traceId=%property{traceId}` while retaining the current log level, date, thread, logger, message, and newline values. This avoids a logging-provider change and preserves current rolling-file behavior.

### Sensitive logging cleanup

For each in-scope Cyber ID password method, preserve body parsing and user/business result handling. Replace messages that concatenate `data`, `datares`, `apiUrl` when it carries a password query, or authorization value with a constant endpoint path plus `response.StatusCode`. Error paths must not call `response.ToString()` when it could contain request details. Keep `Logger.Error("fixed endpoint message", ex)` exception logging but do not append request/response values.

For account-creation and password-reset flows, use the same safe pattern because serialized bodies can contain `passWord`, OTP, password confirmation, reset token, or personally identifying credentials. A `grep`/review check must cover every modified password-related Cyber ID log in the class, not only the initially identified four calls.

## Verification Plan

- Targeted tests (after adapting the legacy test project only as necessary):
  - `dotnet test "D:\Source\billcloud\invoicecore\aspnet-core\test\VS.Tests\VS.Tests.csproj" --no-restore --filter FullyQualifiedName~TraceIdMiddlewareTests --nologo -v:minimal`
  - Expected: all `TraceIdMiddlewareTests` pass.
- Build backend solution:
  - `dotnet build "D:\Source\billcloud\invoicecore\aspnet-core\VS.Web.sln" --nologo -v:minimal`
  - Expected: `Build succeeded` with 0 errors.
- Static sensitive-log review:
  - `rg -n -i "Logger\.(Info|Warn|Error).*?(password|passWord|passwordOld|passwordNew|CurrentPassword|NewPassword|datares|data:)" "D:\Source\billcloud\invoicecore\aspnet-core\src\hddt\HDDT.Application\AppServices\Dashboard\DashBoard_DNAppService.cs"`
  - Expected: no unsafe log statement remains for the in-scope Cyber ID methods; manual review confirms remaining results do not concatenate sensitive values.
- Manual integration verification in local/dev or staging:
  - Request a safe endpoint with `X-Trace-Id: CBCLOUDV2-8307-test`; response must return the exact same header and emitted log lines must show `traceId=CBCLOUDV2-8307-test`.
  - Request the same endpoint without the header and with an invalid header; each response must return a non-empty generated 32-character GUID trace ID and logs must show the returned value.
  - Execute a Cyber ID password flow with a unique non-production password sentinel; search host logs and verify sentinel, serialized payload, password query, bearer token, and raw response body are absent, while endpoint/status diagnostics remain.

## Risk Matrix

| Risk | Impact | Mitigation | Rollback / Follow-up |
| --- | --- | --- | --- |
| Untrusted client trace ID injects newlines or excessive data into logs | Medium | Strict ASCII allowlist and 128-character limit; invalid values are replaced server-side | Disable client-header reuse and always generate server GUIDs if incidents occur |
| Logical context leaks across requests | High | Remove property in `finally`; unit test a throwing downstream delegate and a subsequent request | Revert middleware if cleanup cannot be proved; retain safe-log cleanup independently |
| Log consumers expect the exact old pattern | Low-Medium | Preserve all existing pattern tokens and append one explicit field; validate in non-production | Restore old conversion pattern while leaving middleware and security cleanup active |
| Incomplete audit leaves another sensitive Cyber ID log | High | Review all Cyber ID password/create/reset log calls in `DashBoard_DNAppService`; test with a unique sentinel | Expand targeted cleanup in a follow-up before release |
| Legacy test project cannot reference the .NET 3.1 host | Medium | Make the smallest compatible test-project adjustment or document the concrete limitation and run manual middleware verification | Do not change host behavior solely to accommodate legacy tests |

## Deployment Notes

- No DB migration, configuration key, secret, queue, or environment change is required.
- Standard deployment of `invoicecore/aspnet-core` is sufficient.
- Operations should update log search/parsing rules to use the appended `traceId=<value>` field if they parse host log lines.
- Rollback is a source rollback of middleware registration, middleware file, log pattern, and safe-log changes. No data rollback is needed.
