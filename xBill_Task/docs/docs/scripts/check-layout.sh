#!/usr/bin/env bash
# check-layout.sh — fail-fast kiểm tra layout trước mỗi phiên làm việc với AI (bản BillCloud).
#
# Cách chạy (từ folder cha chứa docs/ và các service):
#   bash docs/scripts/check-layout.sh
# Hoặc từ trong một service repo:
#   bash ../docs/scripts/check-layout.sh
#
# Mục đích: dừng ngay với thông báo rõ ràng nếu thiếu repo, thay vì lỗi mơ hồ giữa chừng.

set -uo pipefail

# Xác định folder cha = thư mục chứa docs/
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOCS_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
ROOT_DIR="$(cd "$DOCS_DIR/.." && pwd)"

FAIL=0
ok()   { printf '  [OK]   %s\n' "$1"; }
bad()  { printf '  [MISS] %s\n' "$1"; FAIL=1; }
warn() { printf '  [WARN] %s\n' "$1"; }

printf '\n== Kiểm tra layout BillCloud (root: %s) ==\n\n' "$ROOT_DIR"

# 1. Thư mục docs phải tên đúng là "docs"
if [ "$(basename "$DOCS_DIR")" = "docs" ]; then
  ok "docs/ đúng tên"
else
  bad "Thư mục tài liệu đang tên '$(basename "$DOCS_DIR")', phải là 'docs'."
  printf '         Sửa: tạo symlink/junction tên docs trỏ vào nó.\n'
  printf '         Linux/macOS : ln -s %s docs\n' "$(basename "$DOCS_DIR")"
  printf '         Windows cmd : mklink /J docs %s\n' "$(basename "$DOCS_DIR")"
fi

# 2. Các repo/project service bắt buộc — dùng LOCAL FOLDER NAME (canonical) trong docs/AGENTS.md.
#    Không dùng tên git repo. Sửa danh sách này khi Service registry đổi.
declare -a REPOS=(
  "frontend_angular"
  "invoicecore"
  "api-cloud-service"
  "api-qldv-service"
  "bangke-dctt-java-service"
  "etran-teanant-service"
  "export-zip-pdf-service"
  "svinvoicesendemail"
  "invoice-management"
  "invoice-sendmail-service"
  "invoice-senddata2tct-service"
  "searchBill"
)

printf '\n-- Service repo (local folder name) --\n'
for r in "${REPOS[@]}"; do
  if [ -d "$ROOT_DIR/$r" ]; then
    ok "$r"
  else
    warn "$r  (không tìm thấy dưới $ROOT_DIR — clone khi cần đụng tới service này)"
  fi
done

# 3. File tài liệu nền
printf '\n-- Tài liệu nền --\n'
for f in README.md AGENTS.md project.md architecture.md specs/README.md databases/README.md; do
  if [ -f "$DOCS_DIR/$f" ]; then ok "docs/$f"; else bad "docs/$f"; fi
done

# 4. Nhắc git pull + cảnh báo nhánh
printf '\n-- Git --\n'
if [ -d "$DOCS_DIR/.git" ]; then
  BRANCH="$(git -C "$DOCS_DIR" rev-parse --abbrev-ref HEAD 2>/dev/null || echo '?')"
  ok "docs/ là git repo (nhánh: $BRANCH)"
  case "$BRANCH" in
    docs/hungtq_dev_cloud|docs/xbill-cloud) : ;;
    *) warn "Nhánh docs không phải 'docs/hungtq_dev_cloud' hay 'docs/xbill-cloud'. Kiểm tra lại trước khi làm." ;;
  esac
  printf '         Nhớ chạy: cd %s && git pull\n' "$DOCS_DIR"
else
  warn "docs/ không phải git repo."
fi

printf '\n'
if [ "$FAIL" -ne 0 ]; then
  printf '== FAIL — sửa các mục [MISS] ở trên rồi chạy lại. DỪNG, chưa làm tiếp. ==\n\n'
  exit 1
fi
printf '== PASS — có thể bắt đầu phiên làm việc. ==\n\n'
exit 0
