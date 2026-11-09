# Rule 00 — Khởi tạo / Refresh tài liệu gốc

**Mục tiêu:** đọc source của các service và sinh/cập nhật tài liệu nền: `architecture.md`, `specs/*.md`, `databases/README.md`, `design.md`.

**Khi chạy:** lần đầu setup, hoặc khi docs đã lệch nhiều so với code (refresh định kỳ).

**Đầu vào:** source của các service khai trong **Service registry** (`AGENTS.md`).

**Đầu ra:** diff đề xuất cho `architecture.md`, `specs/<domain>.md`, `databases/README.md`, `design.md` — **phải qua Gate 2 mới merge**.

> **Project facts** (stack, quy ước code/DB, tích hợp, glossary, tiền tố đặt tên, service registry) sống ở `project.md` + `AGENTS.md` + `conventions/`. Rule này KHÔNG lặp lại chúng. Port sang dự án khác = sửa các file kia, **không sửa rule**.

---

## Nguyên tắc

1. **Không bịa.** Chỉ ghi cái đọc được từ code/config. Không suy diễn tích hợp không có trong source. Chỗ không chắc → mục **"Câu hỏi mở"** cuối file, KHÔNG đoán.
2. **Bám thực thể thật.** Mỗi luồng nghiệp vụ phải trỏ tới class/method/entity **CÓ THẬT**. Dùng đúng quy ước đặt tên khai ở `project.md` / `conventions/<service>.md`.
3. **Tách theo domain.** 1 domain = 1 file trong `specs/`. Không gộp tất cả vào một file.
4. **Ghi rõ service.** Khi nhiều repo có class trùng tên, luôn nói rõ luồng thuộc service nào (tra Service registry).
5. **Không copy secret.** Cấu hình chỉ ghi **tên khóa**, không ghi giá trị.
6. **Đề xuất, không tự merge.** Output là diff để TechLead review (Gate 2).

## Các bước

1. Chạy `scripts/check-layout.sh` → PASS. `git pull` trong `docs/`.
2. Đọc `AGENTS.md` (registry, ràng buộc service), `project.md`, `conventions/<service>.md`.
3. Quét cấu trúc từng service theo layer map ở `conventions/<service>.md`: nơi đặt entity / app service / DTO / repository / cấu hình / màn hình.
4. Với mỗi module nghiệp vụ: xác định service/handler chính, method public, entity liên quan, tích hợp ngoài (đối chiếu bảng tích hợp ở `project.md`).
5. Gom module theo domain → viết `specs/<domain>.md` theo cấu trúc chuẩn bên dưới.
6. Quét tầng data-access + cấu hình: liệt kê entity/bảng theo nhóm → cập nhật `databases/README.md`.
7. Tổng hợp tích hợp ngoài + sơ đồ luồng → `architecture.md`.
8. Ghi quy ước UI/UX quan sát được từ source frontend → `design.md`.
9. Liệt kê **"Câu hỏi mở"** cho mọi phần chưa chắc.

## Cấu trúc chuẩn của `specs/<domain>.md`

```markdown
# Domain: <Tên domain>

## Phạm vi
<Domain gồm module/nghiệp vụ nào; ranh giới với domain khác>

## Actors
<Ai dùng — theo vai trò khai ở project.md>

## Entities chính
| Entity | Mô tả |

## Luồng nghiệp vụ
### <Tên luồng>
- Service / method (ghi rõ thuộc service-key nào)
- Các bước
- Tích hợp ngoài (nếu có)

## Ràng buộc & rule nghiệp vụ
<Validate, trạng thái, điều kiện, rule bảo mật>

## Câu hỏi mở
```

## Checklist hoàn thành

- [ ] Mọi domain đều có file spec riêng và được liệt kê ở `specs/README.md`.
- [ ] Mọi luồng trỏ tới class/method/entity **có thật** trong code.
- [ ] Luồng nào cũng ghi rõ thuộc service-key nào.
- [ ] `databases/README.md` liệt kê đủ nhóm bảng và quy tắc DB.
- [ ] `architecture.md` khớp cấu hình thật (tên khóa, tên queue/topic) — **không ghi giá trị secret**.
- [ ] Không có phần bịa; phần chưa chắc nằm ở "Câu hỏi mở".
- [ ] Output ở dạng diff để review (Gate 2).
