# CBCLOUDV2-8317 Impact

## Purpose

Đánh giá phạm vi ảnh hưởng của việc thêm cột `Thông báo` (ma trận thông báo sinh trắc học/OTP, hủy tờ khai, quá hạn OTP) vào màn hình `/app/hddt/cauhinh/doanhnghieptongcucthue` — CBCLOUDV2-8317. Tài liệu này phản ánh **code thực tế đã được người dùng tự sửa** (không phải bản kế hoạch v3 trước đó), khác với kế hoạch ban đầu ở cách lấy dữ liệu và ở phạm vi điều kiện cutover-date.

## Phạm vi thay đổi / Change scope

- Logic-only cho phần hiển thị (`getThongBaoType`) + một truy vấn backend mới (không phải logic ghi/insert). Không thay đổi schema database, không có migration.
- Không thay đổi contract API công khai của `GetData` (cùng input/output shape `PagedResultDto<DoanhNghiep_TongCucThueDto>`), chỉ **thêm 2 field mới** (`TransFormCode`, `ResponseCode`) vào `DoanhNghiep_TongCucThueDto` — additive, không phá vỡ consumer hiện tại.
- Thêm 2 dependency mới vào constructor của `DoanhNghiep_TongCucThueAppService` (`IRepository<ServiceTax>`, `IRepository<Transaction_Log>`) — được ABP DI tự động resolve, không cần đăng ký thủ công.
- Không đổi cấu trúc queue/message, không đổi config mới ngoài 2 khóa `vs_dm_ncc_cauhinh` đã có từ v1 (`LINK_XAC_THUC_SINH_TRAC_HOC`, `NGAY_APDUNG_SINH_TRAC_HOC`).

## Thành phần bị ảnh hưởng / Affected components

| Layer | File / Method | Impact level | Ghi chú |
| --- | --- | --- | --- |
| Backend (invoicecore) | `HDDT.Application/AppServices/CauHinh/DoanhNghiep_TongCucThueAppService.cs` → `GetData` | Trung bình | Thêm vòng lặp per-row tra `ServiceTax` rồi `Transaction_Log` cho mỗi dòng trên trang hiện tại (N+1 query, không batch) |
| Backend (invoicecore) | Cùng file → constructor | Thấp | Thêm 2 tham số DI mới (`iServiceTaxRepository`, `iTransLogRepository`); không ảnh hưởng các method khác trong file |
| Backend (invoicecore) | `HDDT.Application/DataTransferObjects/CauHinh/ThongTinDoanhNghiep/DoanhNghiep_TongCucThueDto.cs` | Thấp | Thêm 2 field mới `TransFormCode`, `ResponseCode` (cả hai `string`, nullable, additive) |
| Frontend (frontend_angular) | `src/shared/service-proxies/service-proxies.ts` → `DoanhNghiep_TongCucThueDto`/`IDoanhNghiep_TongCucThueDto` | Thấp | Patch tay thêm `transFormCode`/`responseCode` (field, `init()`, `toJSON()`); không regen NSwag |
| Frontend (frontend_angular) | `src/app/hddt/cauhinh/thongtindoanhnghiep/doanhnghiep-tongcucthue-tab.component.ts` → `getThongBaoType` | **Cao** | Logic hiển thị cột `Thông báo` thay đổi hành vi so với đặc tả gốc — xem "Rủi ro / Hạn chế đã biết" |
| Frontend (frontend_angular) | Cùng thư mục → `.component.html` | Không đổi | Template vẫn gọi `getThongBaoType(record) == 1/3/5`, không cần sửa |
| Database | Không | N/A | Không có bảng/cột nào bị đổi; `vs_transaction_log.TransFormCode`/`ResponseCode`, `vs_service_tax.Reference_ID`/`Type` đều đã tồn tại từ trước |
| Config | Không | N/A | Không thêm khóa cấu hình mới so với v1 |

## Không thuộc phạm vi / Confirmed unaffected

- `GetDangKy`, `GetDangKyOrThayDoi`, `GetRegisterFinal` và các API khác trả về `DoanhNghiep_TongCucThueDto` — không được sửa để populate `TransFormCode`/`ResponseCode`; hai field này chỉ được gán bên trong `GetData`. Các API khác sẽ trả `null` cho 2 field này, không gây lỗi vì chúng là nullable và không được các màn hình khác sử dụng.
- `TransactionLogAppService.GetDsTransaction`/`GetDsTransactionChungTu` (dùng cho modal "Lịch sử giao dịch") — không bị sửa, vẫn dùng field riêng của nó, không ảnh hưởng bởi 2 field mới trên DTO khác.
- Các trường `StatusCode`/`ErrorCode` cũ trên `DoanhNghiep_TongCucThueDto` (từ v2, đã bị bỏ dùng cho cột Thông báo) — vẫn còn tồn tại trên DTO (không bị xóa), không dùng ở đâu khác trong ticket này nên không có rủi ro.
- Cột "Trạng thái đăng ký" (label theo `status`) trong cùng bảng — không đổi, chỉ cột "Thông báo" mới bị ảnh hưởng.
- `ServiceTaxRepository`/`TransactionLogRepository` (các field đã có sẵn `_serviceTaxRepository`/`_transactionLogRepository`) — không bị đổi cách dùng ở các method khác (`SaveAndSignDangKy`, `UploadFileDaKy`); 2 dependency mới (`_iServiceTaxRepository`, `_iTransLogRepository`) là các field riêng biệt, không tái sử dụng field cũ.

## Rủi ro / Hạn chế đã biết / Known risks and limitations

- **Chưa xác nhận với BA/TechLead — thay đổi hành vi so với đặc tả gốc (`expect.md` "Known Gaps")**:
  1. Điều kiện cutover-date (`isXacThucSinhTracHocApplicable`) hiện bọc **cả 3 dòng nội dung** (1/3/5) thay vì chỉ dòng 1 như đặc tả gốc yêu cầu. Nghĩa là dòng 3 (thông báo hủy tờ khai) và dòng 5 (quá hạn OTP) sẽ **không hiển thị** cho các đăng ký ký trước ngày cutover, dù `TransFormCode`/`ResponseCode` khớp đúng.
  2. Dòng 1 và dòng 3 không còn kiểm tra `ResponseCode` phải trống — nghĩa là một dòng `status==3`/`TransFormCode=="102"` có `ResponseCode` (mã lỗi) vẫn hiển thị thông báo sinh trắc học/OTP (đặc tả gốc dòng 2 yêu cầu phải trống trong trường hợp này).
  3. Biến `responseStatus` (đọc từ `record.responseCode`) không được `.trim()` trước khi so sánh `=== '20013'`, khác với `transFormCode` đã được trim — có thể gây lệch nếu backend trả về giá trị có khoảng trắng thừa.
- **Rủi ro hiệu năng N+1**: `GetData` giờ thực hiện 1-2 query bổ sung **cho mỗi dòng** trên trang hiện tại (không batch/group như kế hoạch v3 ban đầu). Với page size nhỏ (10-50 dòng) đây là chi phí giới hạn và có thể chấp nhận được, nhưng không scale tốt nếu page size lớn hơn nhiều.
- **Rủi ro chưa build/test**: chưa chạy `dotnet build` (backend) và `npm run build` (frontend) cho lần sửa này. Cụ thể chưa xác nhận:
  - 2 tham số DI mới (`IRepository<ServiceTax>`, `IRepository<Transaction_Log>`) resolve đúng, không đụng constructor overload nào khác.
  - Vòng lặp `foreach` + `await` bên trong (gọi `FirstOrDefaultAsync`/`ToListAsync` nhiều lần) chạy đúng với EF Core provider thực tế, không có vấn đề về DbContext concurrency khi lặp tuần tự (đây là pattern tuần tự `await` trong `foreach`, không phải `Task.WhenAll` song song, nên về lý thuyết an toàn với EF Core, nhưng chưa xác nhận bằng chạy thực tế).
  - `service-proxies.ts` sau khi patch tay compile đúng với phần còn lại của ứng dụng Angular.
- Diagnostics tĩnh của editor (TypeScript/C# compiler service) không báo lỗi trên các file đã sửa, nhưng đây không phải là build thực tế.

## Chưa được kiểm chứng / Not verified

- Chưa chạy `dotnet build` cho `HDDT.Application.csproj` (invoicecore).
- Chưa chạy `npm run build` cho `frontend_angular` (từng thử nhiều lần trong phiên trước, không hoàn thành do môi trường build gặp vấn đề `node-sass`/Node version không tương thích — xem lịch sử phiên làm việc; chưa retry sau khi code được sửa lại lần này).
- Chưa test thủ công trên dữ liệu thực để xác nhận ma trận 6 dòng hiển thị đúng theo hành vi mới (đặc biệt là 3 Known Gaps ở trên).
- Chưa xác nhận với BA/TechLead liệu 3 điểm khác biệt hành vi (Known Gaps 1-3) là chủ đích hay cần sửa lại cho khớp đặc tả gốc.

## Kết luận / Conclusion

Rủi ro tổng thể: **Trung bình**. Thay đổi không đụng schema/contract, phạm vi giới hạn trong 1 API (`GetData`) và 1 component frontend, nhưng có **3 khác biệt hành vi chưa xác nhận** so với ma trận thông báo đã được duyệt ban đầu (điều kiện cutover-date mở rộng ra dòng 3/5; thiếu kiểm tra `ResponseCode` trống ở dòng 1/3), cộng với rủi ro hiệu năng N+1 và chưa có build thực tế nào xác nhận code chạy được. Khuyến nghị: (1) xác nhận với BA/TechLead 3 Known Gaps trước khi coi ticket là hoàn tất; (2) chạy `dotnet build`/`npm run build` trước khi merge/deploy; (3) nếu N+1 gây vấn đề hiệu năng thực tế, xem xét quay lại hướng batch-query đã lên kế hoạch ở v3.
