# CBCLOUDV2-8430 Testcase

| ID | Scenario | Expected Result | Status |
| --- | --- | --- | --- |
| TC-01 | Small buyer revenue export | Excel downloads directly as before. | verified by source/build |
| TC-02 | Large buyer revenue export | API creates export job, sends queue, returns status 2 message. | verified by source/build |
| TC-03 | Worker report route new discriminator | Worker handles `BaoCaoDoanhThuTheoBenMua` with buyer report export service. | pending |
| TC-04 | Worker report route backward compatibility | Worker still handles old queued `TinhHinhSuDungHoaDonTheoBenMua` jobs. | pending |
| TC-05 | Existing exports regression | Invoice exports still build; product report route remains pending in current worker checkout. | pending - current worker checkout has no report route source |
| TC-06 | Config fallback | Missing/invalid `CLOUD_ACTIVE_MAX_REPORT` falls back to `50000`. | verified by source/build |
| TC-07 | Frontend popup | frontend_angular shows clickable Quản lý tải file popup for status 2. | verified by source |
| TC-08 | Buyer report file type saved | Create buyer report background job. | `vs_service_exportbill.filetype = 2`. | verified by source/build |
| TC-09 | Buyer report file type display | Open Quản lý xuất file for buyer report job. | Loại file shows `Báo cáo doanh thu theo bên mua`. | verified by source |
| TC-10 | Old/null file type display | Open Quản lý xuất file for invoice/old rows where `filetype` is null/0. | Loại file shows `Hóa đơn`. | verified by source |
| TC-11 | Shared config key | Source verify report limit lookup. | Buyer report uses `CLOUD_ACTIVE_MAX_REPORT`, not `ACTIVE_MAX_BUYER_REVENUE_REPORT`. | verified by source/build |

## Manual Runtime

- Runtime testing is pending after implementation. FE publish build failed once with Node heap out of memory and timed out once with 8192 MB heap; source verification passed.
