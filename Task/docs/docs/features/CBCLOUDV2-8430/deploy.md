# CBCLOUDV2-8430 Deploy Notes

## Database Changes

- Add nullable file type column to each tenant database that uses Quản lý xuất file:

```sql
ALTER TABLE vs_service_exportbill
ADD COLUMN filetype int NULL AFTER xuatfile_mota;
```

- Column was manually added on tenant `invoicesysv2tenant01`.
- No data migration is required; old/null rows display as `Hóa đơn`.

## Configuration Changes

- Buyer report export limit must use shared key: `CLOUD_ACTIVE_MAX_REPORT`.
- The actual limit value is read from Redis first, then DB config repository, with fallback value `50000`.
- Remove/ignore old buyer-specific key usage: `ACTIVE_MAX_BUYER_REVENUE_REPORT`.

## Queue Changes

- No new queue; reuse `ExportData`.
- New buyer report jobs are identified by `XuatFile_MoTa = "BaoCaoDoanhThuTheoBenMua"` and `filetype = 2`.
- Worker must keep fallback support for old queued jobs identified by `XuatFile_MoTa = "TinhHinhSuDungHoaDonTheoBenMua"`.

## Frontend Changes

- Deploy `frontend_angular` so Quản lý xuất file displays Loại file.
- `filetype = 2` displays `Báo cáo doanh thu theo bên mua`.
- `filetype` null/0/unknown displays `Hóa đơn`.

## Rollout Notes

- Deploy invoicecore API, AppServiceExportBillHost worker, and frontend together.
- Ensure worker is consuming `ExportData`.
- Run the `ALTER TABLE` on all relevant tenant DBs before API/worker code relying on `filetype` is used.
