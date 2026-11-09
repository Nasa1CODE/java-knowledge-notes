---
feature: CBCLOUDV2-9367
updated_at: 2026-09-10
---

# Deploy — CBCLOUDV2-9367

## Database
Nếu tenant DB chưa có cột, tạo theo độ dài XML mới `TTinh/TXa` tối đa 50 ký tự:
```sql
ALTER TABLE `vs_hd_tonghop_morong`
ADD COLUMN `ten_tinh` varchar(50) NULL,
ADD COLUMN `ten_xa` varchar(50) NULL;
```

## Build
```powershell
dotnet build D:\XBill\Cloud\api-cloud-service\VS.WS.sln --no-restore --verbosity quiet
```

## Rollback
- Code rollback theo commit/revert deployment.
- DB rollback chỉ drop column nếu chắc chắn chưa phát sinh dữ liệu thật cần giữ.


