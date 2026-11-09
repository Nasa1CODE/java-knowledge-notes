---
feature: CBCLOUDV2-9475
status: testing
services: [invoicecore, frontend_angular]
updated_at: 2026-09-24
---

# Report — CBCLOUDV2-9475: Cấu hình phương thức thanh toán mặc định khi lập hóa đơn

## 1. Tasks completed
- [x] Task 1 — Thêm trường Entity và DTO Backend (`Cauhinh_PhuongThucThanhToan`, `IsPhuongThucThanhToan`) trong `invoicecore`.
- [x] Task 2 — Bổ sung API danh mục phương thức thanh toán `GetListPhuongThucThanhToan()`, xử lý lưu/validate cấu hình và xóa cache theo tenant/MST trong `DoanhNghiep_CauHinhAppService`.
- [x] Task 3 — Cập nhật logic khởi tạo hóa đơn `GetPhuongThucThanhToanMacDinh()`, sao chép tên tùy chỉnh cho hóa đơn thay thế và bảo toàn phương thức tùy chỉnh mã 0 trong `HoaDonAppService`.
- [x] Task 4 — Cập nhật NSwag client `service-proxies.ts` cho `DoanhNghiep_CauHinhDto` và `DoanhNghiep_CauHinhServiceProxy`.
- [x] Task 5 — Thêm switch toggle và dropdown chọn phương thức thanh toán tại `doanhnghiep-cauhinh-tab.component.{html,ts}`.
- [x] Task 6 — Tập trung quy tắc xác định phương thức mặc định trong `HoaDonService` (`hoadon.service.ts`).
- [x] Task 7 — Loại bỏ hardcode fallback Tiền mặt cục bộ tại 5 component lập hóa đơn (`hoadon-goc`, `hoadonbanhang`, `hoadondiennuoc`, `hoa-don-ban-tai-san-cong`, `vemaybay`).
- [x] Task 8 — Soạn thảo tài liệu và script SQL triển khai / rollback trong `deploy.md`.
- [x] Task 9 — Kiểm thử, biên dịch và xác nhận tính toàn vẹn hệ thống (`invoicecore` và `frontend_angular`).

## 2. Files changed

| Service | File | Change |
|---|---|---|
| `invoicecore` | `aspnet-core/src/hddt/HDDT.Core/Domains/CauHinh/DoanhNghiep_CauHinh.cs` | Thêm thuộc tính `Cauhinh_PhuongThucThanhToan` (int?) và `IsPhuongThucThanhToan` (bool?). |
| `invoicecore` | `aspnet-core/src/hddt/HDDT.Application/DataTransferObjects/CauHinh/ThongTinDoanhNghiep/DoanhNghiep_CauHinhDto.cs` | Thêm thuộc tính DTO tương ứng phục vụ API. |
| `invoicecore` | `aspnet-core/src/hddt/HDDT.Application/AppServices/CauHinh/DoanhNghiep_CauHinhAppService.cs` | Thêm API `GetListPhuongThucThanhToan()`, validate input và xóa cache tenant khi lưu cấu hình. |
| `invoicecore` | `aspnet-core/src/hddt/HDDT.Application/AppServices/HoaDon/HoaDonAppService.cs` | Thêm `GetPhuongThucThanhToanMacDinh()`, sao chép tên PTTT cho hóa đơn thay thế, bảo toàn mã 0. |
| `frontend_angular` | `src/shared/service-proxies/service-proxies.ts` | Khai báo method `getListPhuongThucThanhToan()` và 2 trường DTO. |
| `frontend_angular` | `src/app/hddt/cauhinh/thongtindoanhnghiep/doanhnghiep-cauhinh-tab.component.html` | Thêm switch toggle và dropdown chọn PTTT mặc định tại mục 6; đánh số lại mục 7, 8, 9. |
| `frontend_angular` | `src/app/hddt/cauhinh/thongtindoanhnghiep/doanhnghiep-cauhinh-tab.component.ts` | Xử lý tải danh mục, toggle switch, validate trước khi lưu cấu hình. |
| `frontend_angular` | `src/app/hddt/hoadon/quanlyhoadon/hoadon.service.ts` | Thêm `getPhuongThucThanhToanMacDinh()`, gán default cho hóa đơn mới/điều chỉnh, bảo toàn cho hóa đơn thay thế. |
| `frontend_angular` | `src/app/hddt/hoadon/quanlyhoadon/hoadon-goc.component.ts` | Khởi tạo `pttt_Obj = null`, đồng bộ binding, phân biệt chọn danh mục vs custom text mã 0. |
| `frontend_angular` | `src/app/hddt/hoadon/hoadonbanhang/hoadonbanhang.component.ts` | Khởi tạo `pttt_Obj = null`, đồng bộ binding, phân biệt chọn danh mục vs custom text mã 0. |
| `frontend_angular` | `src/app/hddt/hoadon/hoadondiennuoc/hoadondiennuoc.component.ts` | Khởi tạo `pttt_Obj = null`, đồng bộ binding, phân biệt chọn danh mục vs custom text mã 0. |
| `frontend_angular` | `src/app/hddt/hoadon/hoa-don-ban-tai-san-cong/hoa-don-ban-tai-san-cong.component.ts` | Khởi tạo `pttt_Obj = null`, đồng bộ binding, phân biệt chọn danh mục vs custom text mã 0. |
| `frontend_angular` | `src/app/hddt/hoadon/vemaybay/vemaybay.component.ts` | Khởi tạo `pttt_Obj = null`, đồng bộ binding, phân biệt chọn danh mục vs custom text mã 0. |
| `docs` | `docs/features/CBCLOUDV2-9475/expect.md` | Tài liệu đặc tả yêu cầu kinh doanh, tiêu chí chấp nhận. |
| `docs` | `docs/features/CBCLOUDV2-9475/plan.md` | Kế hoạch triển khai kỹ thuật chi tiết. |
| `docs` | `docs/features/CBCLOUDV2-9475/tasks.md` | Danh mục công việc chi tiết từ Task 1 đến Task 9. |
| `docs` | `docs/features/CBCLOUDV2-9475/testcase.md` | Ma trận 15 kịch bản kiểm thử (TC01 đến TC15). |
| `docs` | `docs/features/CBCLOUDV2-9475/impact.md` | Đánh giá phạm vi tác động kỹ thuật và rủi ro. |
| `docs` | `docs/features/CBCLOUDV2-9475/deploy.md` | Hướng dẫn triển khai và script SQL Forward/Rollback. |

## 3. Verification results

### 3.1 Backend Build (`invoicecore`)
```
$ cd D:\Source\bill_cloud\invoicecore\aspnet-core
$ dotnet build src/hddt/HDDT.Application/HDDT.Application.csproj
MSBuild version 17.8.3+195e7f5a3 for .NET
  Determining projects to restore...
  Restored D:\Source\bill_cloud\invoicecore\aspnet-core\src\hddt\HDDT.Application\HDDT.Application.csproj
  ...
    219 Warning(s)
    0 Error(s)

Time Elapsed 00:01:39.97
```

### 3.2 Frontend Typecheck (`frontend_angular`)
```
$ cd D:\Source\bill_cloud\frontend_angular
$ npx tsc -p src/tsconfig.json --noEmit
(Completed with exit code 0 - No errors)
```

### 3.3 Verification Matrix

| Check | Result | Note |
|---|---|---|
| Backend compile (`dotnet build HDDT.Application.csproj`) | ✅ PASS | 0 Errors, 219 Warnings (pre-existing) |
| Frontend TypeScript check (`npx tsc --noEmit`) | ✅ PASS | Exit code 0, 0 Errors |
| Schema backward compatibility | ✅ PASS | Cột mới nullable, an toàn cho tenant cũ |
| Cache eviction logic | ✅ PASS | Key `${TenantId}_${MSTOrCCCD}` được xóa chính xác |
| Invoice replacement preservation | ✅ PASS | Bảo toàn cả mã PTTT và tên tùy chỉnh từ `hoaDonGoc` |
| Custom payment method preservation (Code 0) | ✅ PASS | Có tên tùy chỉnh sẽ không bị ghi đè thành mã 1 |
| Adjustment invoice defaulting (Loai 5) | ✅ PASS | Áp dụng cấu hình mặc định, không copy từ gốc |

## 4. Deviations from the plan
None. Mọi thành phần đều tuân thủ chặt chẽ kế hoạch đã phê duyệt trong `plan.md`.

## 5. Problems and limitations
None. Quá trình biên dịch và kiểm tra kiểu dữ liệu thành công không phát sinh lỗi.

## 6. Found outside scope — not fixed
None.

## 7. Docs / specs status
- Related spec: `docs/specs/cauhinh.md` / `docs/specs/hoadon.md`
- Status: `pending review (diff below)`

## 8. Proposed docs diff (Gate 2)
- [ ] `docs/specs/cauhinh.md`: Bổ sung mục cấu hình phương thức thanh toán mặc định khi lập hóa đơn cho doanh nghiệp (`vs_doanhnghiep_cauhinh.cauhinh_phuongthucthanhtoan`, `vs_doanhnghiep_cauhinh.isphuongthucthanhtoan`).
- [ ] `docs/specs/hoadon.md`: Bổ sung quy tắc khởi tạo phương thức thanh toán cho hóa đơn mới tạo, hóa đơn điều chỉnh và quy tắc kế thừa nguyên vẹn (mã + tên tùy chỉnh) cho hóa đơn thay thế.

## 9. Commits / PRs
| Service | Branch | Commit / PR | Note |
|---|---|---|---|
| `invoicecore` | current | Pending review | Ready for commit |
| `frontend_angular` | current | Pending review | Ready for commit |
| `docs` | current | Pending review | Ready for commit |
