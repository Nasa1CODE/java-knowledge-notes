---
feature: CBCLOUDV2-9571
status: implemented-awaiting-manual-test
updated_at: 2026-09-14
---

# Report - CBCLOUDV2-9571

## Da thuc hien

- Tao bo tai lieu yeu cau, plan, impact va testcase cho task.
- Ra soat source `api-cloud-service`: Ten va MST hien da duoc required trong shared validator hang hoa dac trung 1.
- Xac nhan CCCD khong nam trong shared validator nen source API hien khong bat buoc CCCD tai diem nay.
- Doi message required thanh `Ten don vi khong duoc de trong.` va `MST/CCCD chu ho khong duoc de trong.`.
- Doi message maxlength tuong ung, giu gioi han Ten 400 byte va MST/CCCD chu ho 14 byte.
- Bo sung 12 unit test cho `GuiHDGoc`, `GuiHoaDonTT`, `GuiHoaDonDC`, gom CCCD optional va gate false.
- Giu nguyen `ACTIVE_ND_254`; khong sua checker, Redis/DB fallback hoac utility XML.
- Bo sung `api-response.md` ghi message, DTO va ma ket qua cua API truc tiep cung cac wrapper XML/HSM/Token/MTT.

## Ket qua kiem chung

- `dotnet test test/WS.Application.Tests/WS.Application.Tests.csproj --no-restore --verbosity quiet -m:1 -nr:false -p:BuildInParallel=false`: pass 12/12, fail 0, skip 0.
- `WS.Core`, `WS.Application`, `WS.EntityFrameworkCore`: build pass, 0 error.
- Warning con lai la warning nen ve .NET Core 2.2, package vulnerability va duplicate package reference.

## Chua thuc hien

- Chua kiem thu API/XML va wrapper ky tren moi truong QA.

## Ket luan

Task da hoan thanh phan source va unit test. Khong thay DTO, DB, XML schema hoac `ACTIVE_ND_254`; con cho kiem thu thu cong tren QA.
