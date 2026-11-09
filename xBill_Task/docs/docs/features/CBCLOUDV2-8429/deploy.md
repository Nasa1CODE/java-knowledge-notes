# CBCLOUDV2-8429 Deploy Notes

## Status

- Deployment impact: tenant DB change, config/runtime awareness required.

## Database Changes

- Add nullable file type column to each tenant database that uses Quản lý xuất file:

```sql
ALTER TABLE vs_service_exportbill
ADD COLUMN filetype int NULL AFTER xuatfile_mota;
```

- Column was manually added on tenant `invoicesysv2tenant01`.
- No data migration is required; old/null rows display as `Hóa đơn`.

## Configuration Changes

- Product revenue report export limit must use shared key: `CLOUD_ACTIVE_MAX_REPORT`.
- The actual limit value is read from Redis first, then DB config repository, with fallback value `50000`.
- Remove/ignore old product-specific key usage: `ACTIVE_MAX_PRODUCT_REVENUE_REPORT`.

## Queue Changes

- No new queue.
- Reuses existing export queue `ExportData`.
- Product report jobs keep `XuatFile_MoTa = "BaoCaoDoanhThuTheoSanPham"` and set `filetype = 1`.

## Frontend Changes

- Deploy `frontend_angular` so Quản lý xuất file displays Loại file.
- `filetype = 1` displays `Báo cáo doanh thu theo sản phẩm`.
- `filetype` null/0/unknown displays `Hóa đơn`.

## Rollout Notes

- Deploy invoicecore API, AppServiceExportBillHost worker, and frontend together.
- Ensure worker is consuming `ExportData`.
- Run the `ALTER TABLE` on all relevant tenant DBs before API/worker code relying on `filetype` is used.
