# CBCLOUDV2-8517 Expect

## Feature Status

- Status: done
- Class: XS

## Business Goal

API `DSHoaDonNhapTrucTiepDaKy` must return clear validation errors for date input instead of throwing a runtime `System.FormatException` when optional date fields are sent as empty strings.

## Scope

- Service: `api-cloud-service/`.
- Application service: `src/hddt/WS.Application/AppServices/HoaDon/GuiHoaDonAppService.cs`.
- Method: `DSHoaDonNhapTrucTiepDaKy`.
- Input fields: `tungay`, `denngay`.
- Response field: existing validation response with `maketqua = "2"` and `motaketqua` message.

## Expected Behavior

- `tungay` is required.
- `tungay = null` or `tungay = ""` returns `maketqua = "2"` and message `tungay không được để trống`.
- `tungay` containing whitespace or invalid date format returns `maketqua = "2"` and message `tungay phải là định dạng yyyy-MM-dd`.
- `denngay` is optional.
- `denngay = null` is valid and the query does not apply an end-date filter.
- `denngay = ""`, whitespace, or invalid date format returns `maketqua = "2"` and message `denngay phải là định dạng yyyy-MM-dd`.
- Valid `tungay` and valid `denngay` continue the existing invoice query flow.

## Out Of Scope

- Do not change DTOs.
- Do not change response structure.
- Do not change query business filters except preserving the existing optional `denngay` end-date filter behavior.
- Do not update system specs or architecture docs.
- Do not change frontend behavior.

## Acceptance Criteria

- `denngay = null` passes validation and keeps `denngay` as nullable for `.WhereIf(denngay.HasValue, ...)`.
- `denngay = ""` returns `maketqua = "2"` with `denngay phải là định dạng yyyy-MM-dd`.
- `denngay = "   "` returns `maketqua = "2"` with `denngay phải là định dạng yyyy-MM-dd`.
- `tungay = null` or `tungay = ""` returns `maketqua = "2"` with `tungay không được để trống`.
- No `System.FormatException: String '' was not recognized as a valid DateTime.` occurs for empty `denngay`.
- `WS.Application.csproj` builds successfully.
