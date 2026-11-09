# Specs — Nghiệp vụ BillCloud

Spec là lớp **CONTENT** — sinh/cập nhật từ source thật bằng [rule 00](../rules/00-init-docs.md) và qua Gate 2. Không bịa; luồng phải trỏ tới service + entity **CÓ THẬT** trong source.

## Canonical hiện có

- **[system.md](system.md)** — **spec cấp hệ thống BillCloud** (canonical): actors, domain 5.1–5.9, functional/non-functional requirement, ma trận trách nhiệm service, data/integration requirement, acceptance criteria. Đọc file này trước khi tách domain.

## Lộ trình tách theo domain (Spec-Driven)

`system.md` đã liệt kê đủ domain ở §5. Để đạt độ chi tiết như bản Liên Sơn, tách dần **mỗi domain = 1 file**, sinh bằng rule 00 từ source Cloud rồi trình Gate 2. Bảng dưới ánh xạ domain hệ thống Cloud ↔ file domain đề xuất ↔ source chính:

| Domain (theo system.md) | File đề xuất | Source chính (Cloud) | Trạng thái |
|---|---|---|---|
| Portal & trải nghiệm người dùng | `portal-nguoi-dung.md` | `frontend_angular/` | ⏳ chưa tách — cần rule 00 |
| Tra cứu & xác thực công khai | `tra-cuu-xac-thuc.md` | `searchBill/` | ⏳ chưa tách — cần rule 00 |
| Quản lý hóa đơn (core) | `hoa-don.md` | `frontend_angular/src/app/hddt/`, `api-cloud-service/`, `api-qldv-service/`, `invoicecore/aspnet-core/` | ⏳ chưa tách — cần rule 00 |
| Hóa đơn đầu vào / HDDV | `hddv-dau-vao.md` | `frontend_angular/src/app/hddt/hddv/`, `src/services/hddv/` | ⏳ chưa tách — cần rule 00 |
| Bảng kê & DCTT | `bao-cao-bang-ke.md` | `export-zip-pdf-service/` | ⏳ chưa tách — cần rule 00 |
| Thuế & message e-transaction | `sai-sot-va-cqt.md` | `etran-teanant-service/` (Kafka) | ⏳ chưa tách — cần rule 00 |
| PDF/ZIP/XML/Excel output | `xuat-file.md` | `export-zip-pdf-service/`, `svinvoicesendemail/` | ⏳ chưa tách — cần rule 00 |
| Gửi mail | `gui-mail.md` | `invoice-sendmail-service/` (RabbitMQ) | ⏳ chưa tách — cần rule 00 |
| Import/export/print/XML jobs | `import-export-print.md` | `svinvoicesendemail/` | ⏳ chưa tách — cần rule 00 |
| Danh mục & cấu hình | `danh-muc-cau-hinh.md` | admin ABP (`invoice-management/aspnet-core/`) + danh mục NCC/DN | ⏳ chưa tách — cần rule 00 |
| Quản trị & người dùng | `quan-tri-nguoi-dung.md` | admin ABP `zero/` + `src/app/admin/` | ⏳ chưa tách — cần rule 00 |

> Danh sách domain-file lấy cảm hứng từ cách phân rã đã kiểm chứng ở nhánh Liên Sơn, nhưng **nội dung phải sinh từ source Cloud** — kiến trúc Cloud (13 repo, Java service + worker) khác Liên Sơn (4 repo). Đừng bê nội dung spec Liên Sơn sang mà chưa đối chiếu source.

## Quy ước viết spec

Theo cấu trúc chuẩn ở [../rules/00-init-docs.md](../rules/00-init-docs.md):

```
## Phạm vi   ## Actors   ## Entities chính   ## Luồng nghiệp vụ
## Ràng buộc & rule nghiệp vụ   ## Câu hỏi mở
```

- **Không bịa.** Chỉ ghi cái đọc được từ code/config. Chưa chắc → đưa xuống "Câu hỏi mở".
- Ghi rõ luồng thuộc **local folder name** nào (nhiều backend ABP trùng tên class — xem [../AGENTS.md](../AGENTS.md)). Khi tên repo/README lệch source → tin source.
- Thuật ngữ nghiệp vụ giải nghĩa ở Glossary trong [../project.md](../project.md) §9.
