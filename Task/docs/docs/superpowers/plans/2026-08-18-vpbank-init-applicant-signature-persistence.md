# VPBank Init Applicant Signature Persistence Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Persist the successful VPBank InitApplicant signature to the latest enterprise lending application so later iframe requests retain authentication context.

**Architecture:** Keep `VPBankLendingAppService` as the orchestration boundary. After building the iframe URL from a successful InitApplicant response, query the latest application for the current tax code and persist the response-derived properties before writing the integration log and returning the result.

**Tech Stack:** C#, ASP.NET Core 3.1, ASP.NET Zero/ABP repositories, Entity Framework Core, xUnit.

---

## File Structure

- Modify: `invoicecore/aspnet-core/src/hddt/HDDT.Application/AppServices/VPBank/VPBankLendingAppService.cs` - persist InitApplicant response data onto the latest lending application.
- Modify: `invoicecore/aspnet-core/test/VS.Tests/VPBank/VPBankLendingAppService_Source_Tests.cs` - add source-level regression coverage for persisted signature fields.

### Task 1: Cover and Persist the InitApplicant Response

**Files:**
- Modify: `invoicecore/aspnet-core/test/VS.Tests/VPBank/VPBankLendingAppService_Source_Tests.cs`
- Modify: `invoicecore/aspnet-core/src/hddt/HDDT.Application/AppServices/VPBank/VPBankLendingAppService.cs:348-358`

- [ ] **Step 1: Write the failing regression test**

Add a test that reads the application-service source and asserts it selects the most recently created enterprise lending application and assigns the `Signature`, `IframeUrl`, `AppraisalOdAmount`, and `LastRequestId` fields before updating it:

```csharp
[Fact]
public void AcceptTermsAndAnalyzeInvoices_Persists_InitApplicant_Response_To_Latest_Application()
{
    var source = File.ReadAllText(GetLendingAppServicePath());

    Assert.Contains(".Where(x => x.DoanhNghiep_MST == mst)", source);
    Assert.Contains(".OrderByDescending(x => x.CreationTime)", source);
    Assert.Contains("application.Signature = response.Data?.Signature;", source);
    Assert.Contains("application.IframeUrl = iframeUrl;", source);
    Assert.Contains("application.AppraisalOdAmount = response.Data?.AppraisalOdAmount;", source);
    Assert.Contains("application.LastRequestId = requestId;", source);
    Assert.Contains("await _applicationRepository.UpdateAsync(application);", source);
}
```

- [ ] **Step 2: Run the targeted test to verify it fails**

Run: `dotnet test "aspnet-core/test/VS.Tests/VS.Tests.csproj" --filter "FullyQualifiedName~VPBankLendingAppService_Source_Tests.AcceptTermsAndAnalyzeInvoices_Persists_InitApplicant_Response_To_Latest_Application"`

Expected: FAIL because the persistence statements are absent.

- [ ] **Step 3: Add minimal persistence logic**

Immediately after `BuildLoanIframeUrl(...)` in the successful response branch, insert:

```csharp
var application = await _applicationRepository.GetAll()
    .Where(x => x.DoanhNghiep_MST == mst)
    .OrderByDescending(x => x.CreationTime)
    .FirstOrDefaultAsync();
if (application != null)
{
    application.Signature = response.Data?.Signature;
    application.IframeUrl = iframeUrl;
    application.AppraisalOdAmount = response.Data?.AppraisalOdAmount;
    application.LastRequestId = requestId;
    await _applicationRepository.UpdateAsync(application);
}
```

- [ ] **Step 4: Run the targeted test to verify it passes**

Run: `dotnet test "aspnet-core/test/VS.Tests/VS.Tests.csproj" --filter "FullyQualifiedName~VPBankLendingAppService_Source_Tests.AcceptTermsAndAnalyzeInvoices_Persists_InitApplicant_Response_To_Latest_Application"`

Expected: PASS.

- [ ] **Step 5: Run the VPBank test suite**

Run: `dotnet test "aspnet-core/test/VS.Tests/VS.Tests.csproj" --filter "FullyQualifiedName~VPBank"`

Expected: all VPBank tests pass.

- [ ] **Step 6: Leave changes uncommitted for review**

Run: `git diff --check && git status --short`

Expected: only the application-service and VPBank source-test changes are listed; do not commit.
