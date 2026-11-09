# CBCLOUDV2-8517 Test Cases

## Scope

Validate date input handling for API method `DSHoaDonNhapTrucTiepDaKy` in `api-cloud-service/`.

## Test Data Baseline

Use a request with valid required business fields and vary only date values where possible:

```json
{
  "doanhnghiep_mst": "0105232093-999",
  "mauso": "1",
  "kyhieu": "C26TCY",
  "tungay": "2026-07-01",
  "denngay": null
}
```

## TC01 - `denngay = null` is valid

- Type: Positive / regression
- Input: `tungay = "2026-07-01"`, `denngay = null`
- Expected result:
  - Validation passes.
  - API does not return `denngay phải là định dạng yyyy-MM-dd`.
  - Query applies from-date filter only.
- Status: not run manually; source/build verified.

## TC02 - `denngay = ""` returns format validation

- Type: Negative
- Input: `tungay = "2026-07-01"`, `denngay = ""`
- Expected result:
  - `maketqua = "2"`.
  - `motaketqua` contains `denngay phải là định dạng yyyy-MM-dd`.
  - No `System.FormatException` is thrown.
- Status: not run manually; source/build verified.

## TC03 - `denngay = "   "` returns format validation

- Type: Edge / negative
- Input: `tungay = "2026-07-01"`, `denngay = "   "`
- Expected result:
  - `maketqua = "2"`.
  - `motaketqua` contains `denngay phải là định dạng yyyy-MM-dd`.
  - No `System.FormatException` is thrown.
- Status: not run manually; source/build verified.

## TC04 - Invalid `denngay` returns format validation

- Type: Negative
- Input: `tungay = "2026-07-01"`, `denngay = "2026/07/31"`
- Expected result:
  - `maketqua = "2"`.
  - `motaketqua` contains `denngay phải là định dạng yyyy-MM-dd`.
- Status: not run manually; source/build verified.

## TC05 - `tungay = null` returns required validation

- Type: Negative
- Input: `tungay = null`, `denngay = null`
- Expected result:
  - `maketqua = "2"`.
  - `motaketqua` contains `tungay không được để trống`.
- Status: not run manually; source/build verified.

## TC06 - `tungay = ""` returns required validation

- Type: Negative
- Input: `tungay = ""`, `denngay = null`
- Expected result:
  - `maketqua = "2"`.
  - `motaketqua` contains `tungay không được để trống`.
- Status: not run manually; source/build verified.

## TC07 - `tungay = "   "` returns format validation

- Type: Edge / negative
- Input: `tungay = "   "`, `denngay = null`
- Expected result:
  - `maketqua = "2"`.
  - `motaketqua` contains `tungay phải là định dạng yyyy-MM-dd`.
- Status: not run manually; source/build verified.

## TC08 - Both dates valid continue existing query

- Type: Positive / regression
- Input: `tungay = "2026-07-01"`, `denngay = "2026-07-31"`
- Expected result:
  - Validation passes.
  - Query applies both from-date and end-date filters.
  - Existing response shape is unchanged.
- Status: not run manually; source/build verified.

## TC09 - Multiple invalid date fields concatenate existing validation messages

- Type: Edge / regression
- Input: `tungay = "abc"`, `denngay = ""`
- Expected result:
  - `maketqua = "2"`.
  - `motaketqua` contains both `tungay phải là định dạng yyyy-MM-dd` and `denngay phải là định dạng yyyy-MM-dd` using the existing message concatenation behavior.
- Status: not run manually; source/build verified.

## Verification Command

```powershell
dotnet build src\hddt\WS.Application\WS.Application.csproj --no-restore
```

Observed build result: `Build succeeded`, `0 Error(s)`, existing project warnings only.
