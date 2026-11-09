# CBCLOUDV2-8307 Log Security and Trace ID Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Remove credential-bearing Cyber ID logs and add a per-request `X-Trace-Id` that is rendered in `VS.Web.Host` log4net output.

**Architecture:** A host middleware resolves a safe inbound trace ID or server GUID, publishes it to the response and `log4net.LogicalThreadContext`, and clears it in a `finally` block. The existing rolling-file layout renders that property. Cyber ID methods retain behavior but emit only fixed endpoint paths and HTTP status values.

**Tech Stack:** ASP.NET Core 3.1, ASP.NET Zero/ABP, log4net, xUnit, .NET CLI.

---

### Task 1: Test Trace ID Middleware

**Files:**
- Create: `invoicecore/aspnet-core/test/VS.Tests/Web/TraceIdMiddlewareTests.cs`
- Modify if compilation requires it: `invoicecore/aspnet-core/test/VS.Tests/VS.Tests.csproj`
- Create in Task 2: `invoicecore/aspnet-core/src/zero/VS.Web.Host/Infrastructure/TraceIdMiddleware.cs`

- [ ] **Step 1: Write failing middleware tests**

```csharp
[Fact]
public async Task Invoke_UsesValidRequestTraceId_AndClearsContext()
{
    var context = new DefaultHttpContext();
    context.Request.Headers["X-Trace-Id"] = "CBCLOUDV2-8307-test";
    var middleware = new TraceIdMiddleware(next: request =>
    {
        Assert.Equal("CBCLOUDV2-8307-test", request.Response.Headers["X-Trace-Id"].ToString());
        Assert.Equal("CBCLOUDV2-8307-test", LogicalThreadContext.Properties["traceId"]);
        return Task.CompletedTask;
    });

    await middleware.Invoke(context);

    Assert.Null(LogicalThreadContext.Properties["traceId"]);
}

[Theory]
[InlineData(null)]
[InlineData("bad trace id!")]
[InlineData("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")]
public async Task Invoke_GeneratesGuidForMissingOrInvalidTraceId(string headerValue)
{
    var context = new DefaultHttpContext();
    if (headerValue != null) context.Request.Headers["X-Trace-Id"] = headerValue;
    var middleware = new TraceIdMiddleware(_ => Task.CompletedTask);

    await middleware.Invoke(context);

    Assert.True(Guid.TryParseExact(context.Response.Headers["X-Trace-Id"], "N", out _));
    Assert.Null(LogicalThreadContext.Properties["traceId"]);
}

[Fact]
public async Task Invoke_ClearsContextWhenNextDelegateThrows()
{
    var context = new DefaultHttpContext();
    var middleware = new TraceIdMiddleware(_ => throw new InvalidOperationException("test failure"));

    await Assert.ThrowsAsync<InvalidOperationException>(() => middleware.Invoke(context));

    Assert.Null(LogicalThreadContext.Properties["traceId"]);
}
```

- [ ] **Step 2: Run the targeted tests and confirm they fail because middleware does not exist**

Run: `dotnet test "D:\Source\billcloud\invoicecore\aspnet-core\test\VS.Tests\VS.Tests.csproj" --no-restore --filter FullyQualifiedName~TraceIdMiddlewareTests --nologo -v:minimal`

Expected: compilation fails with `TraceIdMiddleware` not found. If the existing test project cannot reference the host due to its `netcoreapp2.1` target, record the exact failure and minimally move the test project to `netcoreapp3.1`, correct only its project references, and add the host reference.

### Task 2: Implement and Register Trace Middleware

**Files:**
- Create: `invoicecore/aspnet-core/src/zero/VS.Web.Host/Infrastructure/TraceIdMiddleware.cs`
- Modify: `invoicecore/aspnet-core/src/zero/VS.Web.Host/Startup/Startup.cs`
- Modify: `invoicecore/aspnet-core/src/zero/VS.Web.Host/log4net.config`

- [ ] **Step 1: Create the middleware with strict validation and cleanup**

```csharp
public sealed class TraceIdMiddleware
{
    private const string HeaderName = "X-Trace-Id";
    private const string ContextPropertyName = "traceId";
    private readonly RequestDelegate _next;

    public TraceIdMiddleware(RequestDelegate next) => _next = next;

    public async Task Invoke(HttpContext context)
    {
        var traceId = ResolveTraceId(context.Request.Headers[HeaderName].FirstOrDefault());
        context.Response.Headers[HeaderName] = traceId;
        LogicalThreadContext.Properties[ContextPropertyName] = traceId;
        try { await _next(context); }
        finally { LogicalThreadContext.Properties.Remove(ContextPropertyName); }
    }

    internal static string ResolveTraceId(string candidate)
    {
        if (!string.IsNullOrWhiteSpace(candidate) && candidate.Length <= 128 && candidate.All(c => char.IsLetterOrDigit(c) || c == '.' || c == '_' || c == '-')) return candidate;
        return Guid.NewGuid().ToString("N");
    }
}
```

- [ ] **Step 2: Register it after ABP initialization**

```csharp
app.UseAbp(options => { options.UseAbpRequestLocalization = false; });
app.UseMiddleware<TraceIdMiddleware>();
```

Place these statements before exception handling, static files, routing, authentication, authorization, and endpoint mapping.

- [ ] **Step 3: Add the log4net field**

```xml
<conversionPattern value="%-5level %date [%-5.5thread] traceId=%property{traceId} %-40.40logger - %message%newline" />
```

- [ ] **Step 4: Run targeted tests and build**

Run: `dotnet test "D:\Source\billcloud\invoicecore\aspnet-core\test\VS.Tests\VS.Tests.csproj" --no-restore --filter FullyQualifiedName~TraceIdMiddlewareTests --nologo -v:minimal`

Expected: all trace middleware tests pass.

Run: `dotnet build "D:\Source\billcloud\invoicecore\aspnet-core\VS.Web.sln" --nologo -v:minimal`

Expected: `Build succeeded` and 0 errors.

### Task 3: Redact Cyber ID Password Diagnostics

**Files:**
- Modify: `invoicecore/aspnet-core/src/hddt/HDDT.Application/AppServices/Dashboard/DashBoard_DNAppService.cs`

- [ ] **Step 1: Locate all candidate Cyber ID logs before editing**

Run: `rg -n -i "Logger\.(Info|Warn|Error).*?(password|passWord|passwordOld|passwordNew|CurrentPassword|NewPassword|datares|data:|apiUrl)" "D:\Source\billcloud\invoicecore\aspnet-core\src\hddt\HDDT.Application\AppServices\Dashboard\DashBoard_DNAppService.cs"`

Expected: identify each password, account-create, password-reset, and credential-bearing Cyber ID log to review.

- [ ] **Step 2: Replace unsafe logs with fixed endpoint/status diagnostics**

```csharp
Logger.Info($"Cyber ID /management/persons/change-pwd completed with statusCode={(int)response.StatusCode}");
Logger.Warn($"Cyber ID /management/persons/change-pwd failed with statusCode={(int)response.StatusCode}");
Logger.Error($"Cyber ID /api/convert/changePassword completed with statusCode={(int)response.StatusCode}");
```

Apply the same pattern to `/api/convert/checkpassword`, `/api/convert/createuser`, the password-reset route, and any in-scope credential flow. Do not concatenate `data`, `datares`, `apiUrl`, `model`, request headers, response content, or `response.ToString()` into changed logs. Keep existing exception overloads only with a fixed endpoint message.

- [ ] **Step 3: Build and statically verify the cleanup**

Run: `dotnet build "D:\Source\billcloud\invoicecore\aspnet-core\VS.Web.sln" --nologo -v:minimal`

Expected: `Build succeeded` and 0 errors.

Run: `rg -n -i "Logger\.(Info|Warn|Error).*?(password|passWord|passwordOld|passwordNew|CurrentPassword|NewPassword|datares|data:)" "D:\Source\billcloud\invoicecore\aspnet-core\src\hddt\HDDT.Application\AppServices\Dashboard\DashBoard_DNAppService.cs"`

Expected: no remaining changed in-scope log concatenates a sensitive password/credential value; manually inspect any remaining matches.

### Task 4: Manually Verify and Document Evidence

**Files:**
- Create: `docs/features/CBCLOUDV2-8307/testcase.md`
- Modify: `docs/features/CBCLOUDV2-8307/impact.md`
- Create: `docs/features/CBCLOUDV2-8307/report.md`

- [ ] **Step 1: Perform non-production trace ID checks**

Send one request with `X-Trace-Id: CBCLOUDV2-8307-test`, one without the header, and one with `bad trace id!`. Confirm each response has `X-Trace-Id`; the first matches exactly, and the latter two are 32-character GUIDs. Confirm matching `traceId=<value>` in host logs.

- [ ] **Step 2: Perform sensitive-log regression check**

Run a representative non-production Cyber ID password operation with a unique sentinel password. Search the host log file for the sentinel, endpoint query string, serialized body, bearer token, and raw response content.

Expected: none are present; a fixed endpoint/status log is present.

- [ ] **Step 3: Write feature evidence from actual output**

Record every executed command, result, and skipped check in `report.md`; mark unrun cases clearly. Create `testcase.md` from `expect.md`, then finalize `impact.md` with actual changed files and remaining risk.

- [ ] **Step 4: Commit completed work**

```bash
git add "aspnet-core/src/zero/VS.Web.Host" "aspnet-core/src/hddt/HDDT.Application/AppServices/Dashboard/DashBoard_DNAppService.cs" "aspnet-core/test/VS.Tests"
git commit -m "fix: secure invoicecore logs with trace ids"
```

Commit documentation separately in the `docs/` repository after its final report and impact review.
