# docs (nhánh `docs/hungtq_dev_cloud`) — Source of truth bản **BillCloud**

Repo docs dùng chung cho bản triển khai **Cloud (BillCloud)** của hệ thống hóa đơn điện tử (HĐĐT) xBill/CyberBill. Đây là nguồn sự thật duy nhất về kiến trúc, nghiệp vụ, schema DB, quy ước code và rule điều khiển AI agent cho các repo của bản này.

> **Nhánh này base từ `docs/xbill-cloud`.** BillCloud là bản **cloud đa dịch vụ** (18 repo service, có Java Spring Boot service + .NET worker + Kafka/RabbitMQ), KHÁC bản `docs/xbill-lienson` (khách hàng Liên Sơn, phạm vi hẹp, chỉ 4 repo, không Java service, không worker tách rời). Nhánh `docs/hungtq_dev_cloud` kế thừa toàn bộ **nội dung nghiệp vụ Cloud** (`architecture.md`, `specs/`, `databases/`, `design.md`, `features/`) và bổ sung bộ **khung Spec-Driven** (rules/templates/commands/conventions) vốn được kiện toàn ở nhánh Liên Sơn. **Đừng bê tài liệu giữa 2 nhánh mà không đối chiếu source thật.**

Remote: `http://10.30.1.17/xBill/docs.git`

---

## 1. Layout trên máy dev

`docs/` nằm cạnh các service repo (mỗi repo là một git repo độc lập, clone khi cần đụng tới). **Tên folder local (canonical)** là tên dùng khắp nơi trong docs; KHÔNG dùng tên git repo thay cho tên folder.

```
<root>/                             ← folder cha (KHÔNG phải git repo)
├── docs/                           ← REPO NÀY (nhánh docs/hungtq_dev_cloud)
├── frontend_angular/               ← FE portal chính
├── searchBill/                     ← FE tra cứu công khai
├── invoicecore/                    ← BE + FE + TraCuu (aspnet-core/, angular/, TraCuu/)
├── invoice-management/             ← Admin portal (aspnet-core/ + angular/) — git repo: invoicemanagement
├── api-cloud-service/              ← Cloud API service (ASP.NET Zero/ABP)
├── api-qldv-service/               ← QLDV API service (ASP.NET Zero/ABP)
├── etran-teanant-service/          ← Java Spring Boot: xử lý message thuế/e-transaction (Kafka)
├── export-zip-pdf-service/         ← .NET worker: export ZIP/PDF
├── svinvoicesendemail/             ← .NET worker: import/export/print/XML (tên repo/README lệch source)
└── invoice-sendmail-service/       ← .NET worker: gửi mail hóa đơn (RabbitMQ)
```

> **Cảnh báo tên lệch:** với `svinvoicesendemail/`, tên git repo và README **không khớp** source thật. Luôn tin **source code**, không tin tên repo/README. Chi tiết: [architecture.md](architecture.md) §3.1 và [AGENTS.md](AGENTS.md).

Mọi phiên làm việc với AI bắt đầu bằng:

```bash
bash docs/scripts/check-layout.sh    # fail-fast: thiếu docs nền thì dừng ngay
cd docs && git pull
```

## 2. Ba lớp tài liệu

| Lớp | Gồm | Khi port sang dự án/khách hàng khác |
|---|---|---|
| **ENGINE** (generic) | `rules/NN-*.md` (rule đánh số), `templates/`, `commands/`, `scripts/` | **KHÔNG sửa.** Chỉ chứa logic quy trình, không chứa fact dự án. Rule 01/02 đọc mọi fact dự án qua `{{KEY}}` từ file project-config. |
| **PROFILE** (swappable) | `AGENTS.md` (canonical trong docs branch), `README.md`, `project.md`, `conventions/`, **`rules/*.project-config.md`** | **Viết lại theo dự án.** Mọi fact dự án sống ở đây. |
| **CONTENT** (sinh lại) | `architecture.md`, `specs/`, `databases/`, `design.md` | Sinh bằng [rules/00-init-docs.md](rules/00-init-docs.md) từ source thật. |

> Nguyên tắc bất biến: nếu phải sửa file `rules/NN-*.md` cho hợp một dự án → đó là fact dự án lọt vào engine. Đẩy nó xuống `project.md` / `conventions/` / `rules/*.project-config.md`, đừng sửa rule.
>
> **Config contract (rule 01 & 02):** `rules/01-create-plan.md` và `rules/02-implement-task.md` là ENGINE generic — chúng chỉ khai `{{KEY}}` và resolve fact từ `rules/01-create-plan.project-config.md` + `rules/02-implement-task.project-config.md` (điền theo BillCloud) cùng [AGENTS.md](AGENTS.md)/[project.md](project.md)/[conventions/](conventions/). Thiếu file project-config → agent **DỪNG**, đề nghị sinh từ `*.project-config.template.md`. Port sang dự án khác = viết lại project-config, **không đụng rule**.

## 3. Vòng đời một feature

```
BA viết expect.md ──► DEV + AI sinh plan.md, tasks.md, impact.md, testcase.md ──► Gate 1
      │                                                                            │
      ▼                                                                            ▼
status (trong expect.md): draft ─► plan-review ─► approved ─► in-progress ─► testing ─► done
                                              │
                              AI làm task → report.md (từ test THẬT) + deploy.md
                              + đề xuất diff cập nhật docs gốc → Gate 2
```

**2 gate cứng, có dấu vết phê duyệt:**

1. **Gate 1 — review plan.** `plan.md` + `impact.md` phải được DEV tự review và TechLead approve (ghi người + ngày + link commit/PR vào block "Phê duyệt" trong `plan.md`). Chỉ khi đó mới đổi `status: approved` trong `expect.md` rồi code.
2. **Gate 2 — review docs update.** AI chỉ **đề xuất** diff cho `specs/`, `architecture.md`, `databases/`, `design.md`. TechLead approve MR mới merge. Lý do: docs sai → mọi plan sau sai theo.

**Nguồn `status` duy nhất là `expect.md`.** `plan.md` chỉ giữ `plan-status` riêng phục vụ Gate 1. **AI không tự đổi status sang `approved`.**

### Vai trò

| Vai trò | Own | Việc |
|---|---|---|
| BA | `expect.md` (+ status feature) | Viết mong muốn đã rõ: Acceptance Criteria, Out-of-scope, câu hỏi mở. |
| DEV | `plan.md`, `tasks.md`, code | Chạy rule 01 với AI. **Bắt buộc tự review plan trước khi trình.** |
| TechLead | Gate 1 + Gate 2 | Approve plan; approve diff docs. |
| AI Agent | Bản nháp mọi thứ | Theo `rules/`. Thiếu context → **HỎI**, không tự quyết, không tự approve. |

## 4. Cấu trúc một feature

```
features/<TICKET-ID>/        ← tên folder = mã ticket (vd CBCLOUDV2-8963), không thêm hậu tố
├── expect.md       ← BA viết — GIỮ status vòng đời
├── plan.md         ← AI + DEV; có block Phê duyệt (Gate 1)
├── tasks.md        ← task chia theo service; mỗi task ghi link commit/PR
├── impact.md       ← blast-radius: cái gì đổi, cái gì CHẮC CHẮN không đổi, rủi ro
├── testcase.md     ← sinh từ expect.md (KHÔNG từ plan)
├── report.md       ← từ output test THẬT
└── deploy.md       ← chỉ khi có thay đổi DB / config / môi trường
```

**Definition of Done** — feature chỉ được `done` khi: `expect.md` có AC rõ · `plan.md` đủ 2 chữ ký Gate 1 · mọi task trong `tasks.md` `completed`/`cancelled` có lý do · `impact.md` đã finalize theo blast-radius thật · `report.md` có bằng chứng test thật · diff docs đã qua Gate 2 · `deploy.md` tồn tại nếu chạm DB/config.

## 5. Năm rule điều khiển AI

| Rule | Khi chạy | Vào | Ra |
|---|---|---|---|
| [00-init-docs](rules/00-init-docs.md) | Khởi tạo / refresh docs nền | Source các service trong registry | `architecture.md`, `specs/*`, `databases/*`, `design.md` |
| [01-create-plan](rules/01-create-plan.md) | BA đã có `expect.md` | `expect.md` + docs gốc | `plan.md`, `tasks.md`, `impact.md` (nháp) |
| [02-implement-task](rules/02-implement-task.md) | Plan đã approved | `tasks.md` | Code + `report.md` + `deploy.md` + diff docs |
| [03-create-testcase](rules/03-create-testcase.md) | Sau khi có plan, trước khi code | `expect.md` | `testcase.md` |
| [04-create-impact](rules/04-create-impact.md) | Trong lúc plan; finalize sau khi code | `expect.md`, `plan.md`, source | `impact.md` |

> **Rule 01 & 02 là ENGINE generic** — chúng resolve mọi fact BillCloud từ file project-config đi kèm: [rules/01-create-plan.project-config.md](rules/01-create-plan.project-config.md) và [rules/02-implement-task.project-config.md](rules/02-implement-task.project-config.md). Thiếu file project-config → agent DỪNG, đề nghị sinh từ `*.project-config.template.md`. Đây là 2 file **PROFILE** — port dự án khác thì viết lại chúng, không sửa rule.

Với Claude Code: đăng ký slash command trong [commands/](commands/) (`/create-plan CBCLOUDV2-1234`, …).

## 6. Bản đồ tài liệu

- **Agent guide canonical (17 mục theo template) → [AGENTS.md](AGENTS.md) trong docs branch hiện tại.** Không dùng root `d:/BILL/AGENTS.md` vì `d:/BILL/` chứa nhiều hệ thống song song.
- Service registry (18 repo) → [AGENTS.md](AGENTS.md) §4; chi tiết tên lệch → [architecture.md](architecture.md) §3.1
- Profile dự án (stack, quy ước code/DB, tích hợp, glossary) → [project.md](project.md)
- Quy ước code từng nhóm service → [conventions/](conventions/)
- Kiến trúc & tích hợp runtime → [architecture.md](architecture.md); sơ đồ draw.io + tài liệu thiết kế hệ thống (HLD/LLD) → [deploy/](deploy/)
- Nghiệp vụ hệ thống → [specs/system.md](specs/system.md) (index: [specs/README.md](specs/README.md))
- Schema DB (SQL theo bảng) → [databases/README.md](databases/README.md)
- UI/UX & design system → [design.md](design.md)

## 7. Khác biệt so với nhánh Liên Sơn

- BillCloud là **đa dịch vụ**: ngoài 2 backend ASP.NET Zero/ABP còn có **Java Spring Boot** (`invoice-java-service`, `createxml-service`, `etran-teanant-service`, `hotfixlogin`…) và nhiều **.NET worker** (export/zip/pdf, sendmail, import/print/xml). Liên Sơn không có các thành phần này.
- BillCloud định danh service bằng **tên folder local**; một số nhánh cũ từng dùng file registry riêng ở docs root. Pattern hiện tại dùng **[AGENTS.md](AGENTS.md) trong docs branch làm canonical**, không tạo root `d:/BILL/AGENTS.md` và không tạo `AGENTS.md` per-service.
- Schema DB Cloud lưu dạng **1 file SQL / 1 bảng** dưới [databases/](databases/) (không phải `database/AGENTS.md`). **Không dùng EF migration** cho schema nghiệp vụ.
- Feature `CBCLOUDV2-8963` (Danh mục quốc tịch) là bản Cloud của nghiệp vụ đã làm cho Liên Sơn ở `CBCLOUDV2-8988`; port thủ công vào codebase Cloud, không cherry-pick mù.
