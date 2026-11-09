# CBCLOUDV2-8307 Tasks

> Cập nhật trạng thái ngày 2026-09-03 trong khuôn khổ `CBCLOUDV2-9335` Task A.2. Trạng thái trước đó ghi toàn bộ 4 task là `pending`, không khớp mã nguồn thực tế: Task 2 và Task 3 đã được thực hiện. Task 1 và Task 4 vẫn chưa xong. Nội dung mô tả và tiêu chí nghiệm thu của các task giữ nguyên, chỉ sửa trạng thái và bổ sung ghi chú đối chiếu.

## Task 1 - Add request trace-ID tests

- Status: pending
- Note (2026-09-03): Chưa thực hiện. Thư mục `invoicecore/aspnet-core/test/TraceIdMiddleware.Tests/` chỉ còn `bin/` và `obj/` cũ, không có tệp `.csproj` và không có tệp `.cs` nào; cũng không tìm thấy tệp kiểm thử trace ID ở vị trí nào khác trong repo. Tham chiếu mồ côi này làm lệnh build toàn solution thất bại và sẽ được gỡ ở `CBCLOUDV2-9335` Task B0.1. Nếu muốn bổ sung kiểm thử về sau thì phải tạo lại project.
- Area/service: `invoicecore/`
- Description: Add focused automated coverage for trace-ID resolution and cleanup before adding request middleware. Adapt the existing `VS.Tests` project only if its current target/reference layout prevents a test from instantiating the ASP.NET Core 3.1 host middleware.
- Acceptance criteria:
  - [ ] A valid inbound `X-Trace-Id` is returned unchanged and is available through `LogicalThreadContext.Properties["traceId"]` while the downstream delegate executes.
  - [ ] Missing and invalid headers return a newly generated 32-character GUID trace ID.
  - [ ] The trace context is absent after normal completion and after a downstream exception.
- Verification:
  - [ ] `dotnet test "D:\Source\billcloud\invoicecore\aspnet-core\test\VS.Tests\VS.Tests.csproj" --no-restore --filter FullyQualifiedName~TraceIdMiddlewareTests --nologo -v:minimal` passes.
- Dependencies: None
- Likely touched files:
  - `invoicecore/aspnet-core/test/VS.Tests/VS.Tests.csproj`
  - `invoicecore/aspnet-core/test/VS.Tests/Web/TraceIdMiddlewareTests.cs`
- Estimated scope: S

## Task 2 - Implement request trace-ID logging

- Status: done
- Note (2026-09-03): Đã thực hiện. Middleware nằm ở `invoicecore/aspnet-core/src/zero/VS.Web.Host/Middleware/TraceIdMiddleware.cs`, **khác đường dẫn `Infrastructure/` ghi trong mục Likely touched files bên dưới**. Đăng ký tại `Startup.cs:227`, trước `app.UseAbp()` ở dòng 231, đúng yêu cầu. Mẫu định dạng log đã có `[traceId=%property{traceId}]` tại `log4net.config:11`. Hạn chế còn lại: appender `VPBankFileAppender` trong cùng tệp cấu hình (dòng 22) chưa có trường này; việc bổ sung được xử lý ở `CBCLOUDV2-9335` Task C3.4.
- Area/service: `invoicecore/`
- Description: Implement middleware that accepts a valid `X-Trace-Id` or creates a server GUID, adds it to the response and log4net logical context, removes it reliably, and registers it before normal routing/authentication/controller processing. Add the property to the host rolling-file pattern.
- Acceptance criteria:
  - [ ] Every HTTP response has `X-Trace-Id`.
  - [ ] Valid inbound trace IDs are reused; absent/invalid values are replaced with a generated GUID.
  - [ ] Host log lines include `traceId=<value>` while retaining existing layout fields.
  - [ ] A thrown downstream request cannot leak trace context into a later request.
- Verification:
  - [ ] Task 1 tests pass after implementation.
  - [ ] `dotnet build "D:\Source\billcloud\invoicecore\aspnet-core\VS.Web.sln" --nologo -v:minimal` completes with 0 errors.
  - [ ] Manual request checks with valid, missing, and invalid headers match the acceptance criteria.
- Dependencies: Task 1
- Likely touched files:
  - `invoicecore/aspnet-core/src/zero/VS.Web.Host/Infrastructure/TraceIdMiddleware.cs`
  - `invoicecore/aspnet-core/src/zero/VS.Web.Host/Startup/Startup.cs`
  - `invoicecore/aspnet-core/src/zero/VS.Web.Host/log4net.config`
- Estimated scope: M

## Task 3 - Remove sensitive Cyber ID diagnostics

- Status: done
- Note (2026-09-03): Đã thực hiện trong `DashBoard_DNAppService.cs`. Các log Cyber ID hiện chỉ ghi đường dẫn endpoint cố định và mã trạng thái HTTP, ví dụ dòng 904, 910, 948, 956; dòng ghi URL ở 495 đã được chú thích lại. Phạm vi Task 3 chỉ gồm tệp này. Các lời gọi Cyber ID trong `invoice-management` (`QuanLyUserAppService.cs`, 11 điểm) vẫn còn ghi payload và phản hồi thô; đó là tệp khác repo, nằm ngoài phạm vi 8307 và được xử lý ở `CBCLOUDV2-9335` Task C1.3c.
- Area/service: `invoicecore/`
- Description: Replace sensitive logging in password, credential, account-creation, and password-reset Cyber ID calls with endpoint-path and HTTP-status-only messages. Preserve requests, response parsing, results, and exception behavior.
- Acceptance criteria:
  - [ ] No in-scope Cyber ID log emits a plaintext password, password confirmation, password-bearing URL/query, bearer/access token, OTP, serialized request body, or raw response body.
  - [ ] Every changed success/failure log identifies the fixed endpoint path and available HTTP status code.
  - [ ] Cyber ID outbound request method, URL construction, JSON payload, headers, response parsing, and result DTO behavior are unchanged.
- Verification:
  - [ ] `rg -n -i "Logger\.(Info|Warn|Error).*?(password|passWord|passwordOld|passwordNew|CurrentPassword|NewPassword|datares|data:)" "D:\Source\billcloud\invoicecore\aspnet-core\src\hddt\HDDT.Application\AppServices\Dashboard\DashBoard_DNAppService.cs"` is reviewed and finds no unsafe in-scope log.
  - [ ] `dotnet build "D:\Source\billcloud\invoicecore\aspnet-core\VS.Web.sln" --nologo -v:minimal` completes with 0 errors.
  - [ ] A non-production password sentinel is absent from log output after a representative Cyber ID password flow.
- Dependencies: Task 2
- Likely touched files:
  - `invoicecore/aspnet-core/src/hddt/HDDT.Application/AppServices/Dashboard/DashBoard_DNAppService.cs`
- Estimated scope: S

## Task 4 - Verify and finalize feature evidence

- Status: pending
- Note (2026-09-03): Chưa thực hiện. Thư mục `docs/features/CBCLOUDV2-8307/` hiện chỉ có `expect.md`, `plan.md`, `tasks.md`, `impact.md`; chưa có `testcase.md` và `report.md`. Task này phụ thuộc Task 1, mà Task 1 chưa xong.
- Area/service: `docs/`
- Description: Create test cases from the approved expectation and record real implementation, build, automated-test, static-review, and manual-verification evidence. Finalize impact with actual files and any remaining limitations.
- Acceptance criteria:
  - [ ] `testcase.md` maps positive, invalid-header, cleanup, and sensitive-log regression scenarios to `expect.md` acceptance criteria.
  - [ ] `report.md` contains only actual command output/results and lists any checks not run.
  - [ ] `impact.md` matches the real changed files and explicitly records confirmed-unaffected areas.
- Verification:
  - [ ] Cross-review `expect.md`, `plan.md`, `tasks.md`, `testcase.md`, `impact.md`, and `report.md` finds no contradiction.
- Dependencies: Task 1, Task 2, Task 3
- Likely touched files:
  - `docs/features/CBCLOUDV2-8307/testcase.md`
  - `docs/features/CBCLOUDV2-8307/impact.md`
  - `docs/features/CBCLOUDV2-8307/report.md`
- Estimated scope: S
