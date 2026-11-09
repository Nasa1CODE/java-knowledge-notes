# CBCLOUDV2-8517 Deploy Notes

## Status

- Deployment impact: normal `api-cloud-service/` application deployment only.
- No database, configuration, queue, migration, or worker deployment dependency.

## Database Changes

None.

## Configuration Changes

None.

## Queue / Background Job Changes

None.

## Service Changes

Deploy the `api-cloud-service/` build that includes the updated `WS.Application` assembly.

Affected project:

```text
api-cloud-service/src/hddt/WS.Application/WS.Application.csproj
```

Affected source:

```text
api-cloud-service/src/hddt/WS.Application/AppServices/HoaDon/GuiHoaDonAppService.cs
```

## Rollout Notes

- No special rollout ordering is required.
- No data backfill is required.
- No feature flag is required.
- Smoke test `DSHoaDonNhapTrucTiepDaKy` after deployment with `denngay = null`, `denngay = ""`, and valid date range.

## Rollback

Rollback by redeploying the previous `api-cloud-service/` application artifact. No database rollback is required.
