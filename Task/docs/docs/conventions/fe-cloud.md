# Conventions — Frontend Angular (BillCloud)

> Quy ước chung mọi service ở [../project.md](../project.md) §4–8. File này ghi phần riêng của **các frontend Angular** trên Cloud.
> Áp dụng cho: `frontend_angular/`, `invoice-management/angular/`, `searchBill/`, `invoicecore/angular/` (tra repo path ở [../AGENTS.md](../AGENTS.md)).

## Nhận dạng

- **Vai trò:** portal nghiệp vụ (`frontend_angular`), admin portal (`invoice-management/angular`), tra cứu công khai (`searchBill`).
- **Stack:** Angular · TypeScript · ABP zero template · Metronic · PrimeNG · Bootstrap · NSwag proxy.

## Layer map

| Việc cần làm | Đặt ở |
|---|---|
| Module nghiệp vụ | `src/app/hddt/<nhóm>/` |
| Màn admin ABP | `src/app/admin/` |
| Route | `*-routing.module.ts` của module tương ứng |
| Khai báo component/module | `*.module.ts` |
| Menu | service điều hướng (`app-navigation.service.ts` hoặc tương đương) |
| Gọi API (sinh tự động) | `src/shared/service-proxies/service-proxies.ts` (NSwag) |
| Đăng ký provider proxy | `src/shared/service-proxies/service-proxy.module.ts` |
| Wrapper API tuỳ biến (HDDV/GDDT) | `src/services/…` với base URL riêng |

## Quy ước

- **Không sửa tay `service-proxies.ts`** — đổi contract ở backend rồi chạy `nswag/refresh.bat` để regenerate; sau đó **đăng ký provider** `<...>ServiceProxy` trong `service-proxy.module.ts` để tránh `NullInjector: No provider`.
- **Không hardcode URL backend** — lấy từ runtime config (`AppConsts` / `AppPreBootstrap`); HDDV/GDDT dùng base URL riêng cấu hình được.
- Route có metadata permission → thêm/sửa màn hình phải kiểm cả **route guard** lẫn **menu** (đúng permission, vd `Admin.DanhMuc.<...>`).
- UI theo pattern PrimeNG/ABP của màn danh mục hiện có; ô search và nút tìm kiếm đặt gần nhau (đừng tách bằng layout `col-11`/`col-1`).

## Kiểm chứng tối thiểu

```bash
# TypeScript check (gate tối thiểu)
<repo>/angular/node_modules/.bin/tsc.cmd -p <repo>/angular/src/tsconfig.json --noEmit

# regenerate proxy sau khi BE có endpoint mới
cd <repo>/angular/nswag && refresh.bat
```

> `npm run build` production có thể bị Node/Angular đời cũ chặn — chỉ báo pass khi chạy thật thành công.

## Pitfall

- Thiếu provider proxy sau regenerate → lỗi runtime `No provider` dù compile qua. Luôn thêm provider trong `service-proxy.module.ts`.
- `searchBill/` là FE công khai, luồng captcha/Redis — không lộ dữ liệu tenant ngoài context tài liệu công khai được yêu cầu.
- Nhiều app Angular cùng pattern → đừng nhầm repo; bám local folder name.

## Không được đụng

`node_modules/`, `dist/`, `build/`, file proxy `service-proxies.ts` (chỉ đổi qua NSwag regenerate).
