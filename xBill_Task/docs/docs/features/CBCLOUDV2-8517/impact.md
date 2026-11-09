# CBCLOUDV2-8517 Impact

## Purpose

`CBCLOUDV2-8517` fixes date validation in `api-cloud-service/` method `DSHoaDonNhapTrucTiepDaKy` so optional `denngay` handles `null`, empty string, whitespace, and invalid format consistently without runtime `FormatException`.

## Phạm vi thay đổi / Change scope

- Type: backend logic-only validation fix.
- Contract impact: no DTO or response structure change.
- Data impact: no database writes, migrations, or schema changes.
- Query impact: existing date filter semantics are preserved; `denngay = null` still means no end-date filter.
- Deployment impact: normal application deployment only.

## Thành phần bị ảnh hưởng / Affected components

| Layer | Component | Impact level | Reason |
| --- | --- | --- | --- |
| Backend service | `api-cloud-service/` | Low | One application service method validation path is affected. |
| Backend file | `api-cloud-service/src/hddt/WS.Application/AppServices/HoaDon/GuiHoaDonAppService.cs` | Low | Date validation and parse guard for `DSHoaDonNhapTrucTiepDaKy`. |
| API method | `DSHoaDonNhapTrucTiepDaKy` | Low | Invalid `denngay` now returns `maketqua = "2"`; valid/null behavior remains. |
| Database | None | None | No schema or data change. |
| Queue/background jobs | None | None | No email/export/TCT queue behavior touched. |
| Config/environment | None | None | No config key or environment setting added. |
| Frontend | None | None | No UI behavior changed. |

## Không thuộc phạm vi / Confirmed unaffected

- `GuiMailHoaDon`: not changed; email sending/enqueue behavior remains unchanged.
- `GuiHoaDonGoc`, `GuiHoaDonThayThe`, `GuiHoaDonDieuChinh`: not changed by this ticket.
- Invoice signing and TCT sending flows: not changed.
- DTO classes: unchanged.
- Response model `ResultDSHoaDonParam`: unchanged.
- Tenant/database schema: unchanged.
- Date formats outside `DSHoaDonNhapTrucTiepDaKy`: unchanged.

## Rủi ro / Hạn chế đã biết / Known risks and limitations

- Clients sending `denngay = ""` will now receive validation error instead of being treated as omitted. This is intended by requirement; clients that want no end-date filter must send `null`.
- Existing validation message concatenation does not always insert separators between messages. This is preserved to avoid unrelated response-format changes.
- Manual API execution was not performed in this documentation pass; source and build verification were completed.

## Chưa được kiểm chứng / Not verified

- No Postman/manual API call evidence is attached.
- No automated unit/integration test was added for this legacy service method.
- No production/staging smoke test was performed in this local session.

## Kết luận / Conclusion

Overall risk is low. The change is isolated to one backend validation path, preserves existing valid behavior, and prevents a known `FormatException` for empty `denngay`. Recommended release with focused QA on date validation cases listed in `testcase.md`.
