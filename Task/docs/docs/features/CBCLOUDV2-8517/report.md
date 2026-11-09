# CBCLOUDV2-8517 Report

## Summary

Implemented a focused validation fix for `DSHoaDonNhapTrucTiepDaKy` in `api-cloud-service/` so `denngay = ""` or whitespace returns clear validation error with `maketqua = "2"` instead of throwing `System.FormatException: String '' was not recognized as a valid DateTime.`

## Changed Source

| File | Change |
| --- | --- |
| `api-cloud-service/src/hddt/WS.Application/AppServices/HoaDon/GuiHoaDonAppService.cs` | Updated `denngay` validation to validate every non-null value with `DateTime.TryParseExact`; removed unconditional `DateTime.ParseExact(input.denngay, ...)`; kept parse guarded by `!string.IsNullOrEmpty(input.denngay)`. |

## Behavior After Fix

- `tungay = null` or `""`: returns `maketqua = "2"`, `tungay không được để trống`.
- `tungay = "   "` or invalid format: returns `maketqua = "2"`, `tungay phải là định dạng yyyy-MM-dd`.
- `denngay = null`: valid; no end-date filter is applied.
- `denngay = ""`: returns `maketqua = "2"`, `denngay phải là định dạng yyyy-MM-dd`.
- `denngay = "   "` or invalid format: returns `maketqua = "2"`, `denngay phải là định dạng yyyy-MM-dd`.
- Valid `tungay` and `denngay` continue the existing query flow.

## Verification Evidence

### Source check

Confirmed in `GuiHoaDonAppService.cs`:

```csharp
if (input.denngay != null && !DateTime.TryParseExact(input.denngay, formatNgay, null, DateTimeStyles.None, out DateTime dn))
{
    msgValidate += "denngay phải là định dạng yyyy-MM-dd";
}
```

Confirmed parse guard:

```csharp
if (!string.IsNullOrEmpty(input.denngay))
{
    denngay = DateTime.ParseExact(input.denngay, "yyyy-MM-dd", null, DateTimeStyles.None);
}
```

### Build

Command executed:

```powershell
dotnet build src\hddt\WS.Application\WS.Application.csproj --no-restore
```

Observed result:

```text
Build succeeded.
34 Warning(s)
0 Error(s)
```

Warnings were existing project warnings, including .NET Core 2.2 package vulnerability warnings, duplicate package reference warning, async-without-await warnings, and unreachable-code warnings.

## Manual Test Status

Manual API calls were not executed in this local session. QA should run the scenarios in `testcase.md`, especially:

- `denngay = null`
- `denngay = ""`
- `denngay = "   "`
- `tungay = null`
- `tungay = ""`
- valid `tungay` and valid `denngay`

## Deployment Notes

No DB, config, queue, migration, or worker changes are required. Deploy the updated `api-cloud-service/` application normally.

## Follow-up Items

- Optional: add automated validation tests around `DSHoaDonNhapTrucTiepDaKy` if this service gets a suitable test harness.
- Optional: standardize validation message separators in a separate ticket if BA wants cleaner multi-error responses.
