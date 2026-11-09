# CBCLOUDV2-8317 Deploy Notes

## Status

- Deployment impact: host configuration may be required
- v2 revision (`status`+`statusCode`+`errorCode` Notification Matrix): frontend-only display-logic change, no new config keys, no schema change. Frontend build was not run for v2 per explicit user request — verify with a local `npm run build` before deploying.

## Database Changes

- No schema change.

## Configuration Changes

- Ensure host table `vs_dm_ncc_cauhinh` contains the following rows:

```text
CauHinh_Ma: LINK_XAC_THUC_SINH_TRAC_HOC
CauHinh_GiaTri: <guide or verification URL>
```

```text
CauHinh_Ma: NGAY_APDUNG_SINH_TRAC_HOC
CauHinh_GiaTri: <cutover date, format dd/MM/yyyy>
```

## Environment Changes

- None expected.

## Rollout Notes

- If `LINK_XAC_THUC_SINH_TRAC_HOC` is missing, the `Link` text still renders but without a usable href (`GetLinkXacThucSinhTracHoc` returns empty data).
- If `NGAY_APDUNG_SINH_TRAC_HOC` is missing or fails to parse as `dd/MM/yyyy`, `GetNgayApDungSinhTracHoc` returns null data. This makes `isXacThucSinhTracHocApplicable` return `false` for every record, so the `Thông báo` column silently stays empty for all `status == 3` / `status == 4` rows regardless of `doanhNghiep_NgayKy`. There is no UI warning or log entry for this case, so this config row must be verified as present and correctly formatted before rollout.
