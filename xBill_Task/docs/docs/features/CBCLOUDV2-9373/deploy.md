---
feature: CBCLOUDV2-9373
updated_at: 2026-09-10
---

# Deploy — CBCLOUDV2-9373

## Database
Nếu tenant DB chưa có cột:
```sql
ALTER TABLE `vs_hd_tonghop_morong`
ADD COLUMN `quoc_tich_nguoi_mua` varchar(255) NULL,
ADD COLUMN `ma_quoc_tich_nguoi_mua` varchar(255) NULL;
```

## Build
```powershell
dotnet build D:\XBill\Cloud\api-cloud-service\VS.WS.sln --no-restore --verbosity quiet
```

## Rollback
- Code rollback theo commit/revert deployment.
- DB rollback chỉ drop column nếu chắc chắn chưa phát sinh dữ liệu thật cần giữ.
