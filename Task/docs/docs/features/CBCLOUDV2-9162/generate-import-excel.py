# -*- coding: utf-8 -*-
"""Generate CBCLOUDV2-9162 import Excel files from attachment.md.

The project import helper expects real .xlsx files with exact Vietnamese headers.
This script intentionally uses only Python stdlib so it does not depend on openpyxl.
"""

from __future__ import annotations

import html
import re
import zipfile
from collections import Counter, defaultdict
from pathlib import Path

BASE = Path(__file__).resolve().parent
ATTACHMENT = BASE / "attachment.md"
DATA_DIR = BASE / "data"
PROVINCE_XLSX = DATA_DIR / "CBCLOUDV2-9162-tinh-thanh-import.xlsx"
WARD_XLSX = DATA_DIR / "CBCLOUDV2-9162-xa-phuong-import.xlsx"
VALIDATE_MD = DATA_DIR / "CBCLOUDV2-9162-import-validate.md"

PROVINCE_HEADERS = ["STT", "Mã", "Tên", "Tên tắt", "Bắt đầu", "Kết thúc", "Hiệu lực"]
WARD_HEADERS = ["STT", "Mã", "Tên", "Tên tắt", "Bắt đầu", "Kết thúc", "Hiệu lực", "Mã tỉnh thành"]

EXPECTED_PROVINCES = [
    ("01", "Thành phố Hà Nội"),
    ("04", "Tỉnh Cao Bằng"),
    ("08", "Tỉnh Tuyên Quang"),
    ("11", "Tỉnh Điện Biên"),
    ("12", "Tỉnh Lai Châu"),
    ("14", "Tỉnh Sơn La"),
    ("15", "Tỉnh Lào Cai"),
    ("19", "Tỉnh Thái Nguyên"),
    ("20", "Tỉnh Lạng Sơn"),
    ("22", "Tỉnh Quảng Ninh"),
    ("24", "Tỉnh Bắc Ninh"),
    ("25", "Tỉnh Phú Thọ"),
    ("31", "Thành phố Hải Phòng"),
    ("33", "Tỉnh Hưng Yên"),
    ("37", "Tỉnh Ninh Bình"),
    ("38", "Tỉnh Thanh Hóa"),
    ("40", "Tỉnh Nghệ An"),
    ("42", "Tỉnh Hà Tĩnh"),
    ("44", "Tỉnh Quảng Trị"),
    ("46", "Thành phố Huế"),
    ("48", "Thành phố Đà Nẵng"),
    ("51", "Tỉnh Quảng Ngãi"),
    ("52", "Tỉnh Gia Lai"),
    ("56", "Tỉnh Khánh Hòa"),
    ("66", "Tỉnh Đắk Lắk"),
    ("68", "Tỉnh Lâm Đồng"),
    ("75", "Tỉnh Đồng Nai"),
    ("79", "Thành phố Hồ Chí Minh"),
    ("80", "Tỉnh Tây Ninh"),
    ("82", "Tỉnh Đồng Tháp"),
    ("86", "Tỉnh Vĩnh Long"),
    ("91", "Tỉnh An Giang"),
    ("92", "Thành phố Cần Thơ"),
    ("96", "Tỉnh Cà Mau"),
]


def strip_md(text: str) -> str:
    text = text.replace("\\*", "*").replace("\\)", ")")
    text = re.sub(r"<[^>]+>", " ", text)
    text = text.replace("&nbsp;", " ").replace(" ", " ")
    return " ".join(text.strip().split())


def normalize_code(code: str) -> str:
    return "".join(ch for ch in code if ch.isdigit())


def parse_attachment(text: str):
    lines = text.splitlines()
    provinces = []
    wards = []
    expected_counts = {}
    corrections = []

    in_province_appendix = False
    in_ward_appendix = False
    current_province = None
    seen_appendix_i_title = False

    province_row_re = re.compile(r"^\|\s*(\d+)\s*\|\s*(\d{2})\s*\|\s*([^|]+?)\s*\|")
    heading_re = re.compile(r"^\s*\*\*(\d{2})\.\s+(.+?)\*\*\s*$")
    total_re = re.compile(r"Tổng số đơn vị hành chính cấp xã:\s*(\d+)", re.IGNORECASE)
    ward_row_re = re.compile(r"^\|\s*([0-9.]{5,7})\s*\|\s*([^|]+?)\s*\|")

    for idx, raw in enumerate(lines, start=1):
        line = raw.rstrip("\n")

        if "**PHỤ LỤC I**" in line:
            seen_appendix_i_title = True
            in_province_appendix = True
            in_ward_appendix = False
            continue
        if "**PHỤ LỤC II**" in line:
            in_province_appendix = False
            in_ward_appendix = True
            current_province = None
            continue

        if in_province_appendix:
            m = province_row_re.match(line)
            if m:
                stt, code, name = m.groups()
                provinces.append({
                    "stt": int(stt),
                    "code": code,
                    "name": strip_md(name),
                    "line": idx,
                })
            continue

        if in_ward_appendix:
            hm = heading_re.match(line)
            if hm:
                code, heading_name = hm.groups()
                current_province = code
                continue

            tm = total_re.search(strip_md(line))
            if tm and current_province:
                expected_counts[current_province] = int(tm.group(1))
                continue

            wm = ward_row_re.match(line)
            if wm and current_province:
                raw_code, raw_name = wm.groups()
                code = normalize_code(raw_code)
                name = strip_md(raw_name)
                if raw_code != code:
                    corrections.append(f"Dòng {idx}: mã `{raw_code}` được chuẩn hóa thành `{code}`.")
                if code == "07147" and name == "Phượng Hiệp Hòa":
                    corrections.append("Dòng 1024: sửa OCR `Phượng Hiệp Hòa` thành `Phường Hiệp Hòa` cho mã `07147`.")
                    name = "Phường Hiệp Hòa"
                wards.append({
                    "code": code,
                    "name": name,
                    "province_code": current_province,
                    "line": idx,
                })

    if not seen_appendix_i_title:
        raise RuntimeError("Không tìm thấy PHỤ LỤC I")
    return provinces, wards, expected_counts, corrections


def col_name(index: int) -> str:
    result = ""
    while index:
        index, rem = divmod(index - 1, 26)
        result = chr(65 + rem) + result
    return result


def sheet_xml(rows):
    xml_rows = []
    for r_idx, row in enumerate(rows, start=1):
        cells = []
        for c_idx, value in enumerate(row, start=1):
            ref = f"{col_name(c_idx)}{r_idx}"
            text = "" if value is None else str(value)
            cells.append(
                f'<c r="{ref}" t="inlineStr"><is><t>{html.escape(text)}</t></is></c>'
            )
        xml_rows.append(f'<row r="{r_idx}">{"".join(cells)}</row>')
    dimension = f"A1:{col_name(max(len(row) for row in rows))}{len(rows)}"
    return f'''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">
  <dimension ref="{dimension}"/>
  <sheetViews><sheetView workbookViewId="0"/></sheetViews>
  <sheetFormatPr defaultRowHeight="15"/>
  <sheetData>{"".join(xml_rows)}</sheetData>
</worksheet>'''


def write_xlsx(path: Path, rows, sheet_name: str):
    content_types = '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
  <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
  <Default Extension="xml" ContentType="application/xml"/>
  <Override PartName="/xl/workbook.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml"/>
  <Override PartName="/xl/worksheets/sheet1.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/>
  <Override PartName="/xl/styles.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.styles+xml"/>
  <Override PartName="/docProps/core.xml" ContentType="application/vnd.openxmlformats-package.core-properties+xml"/>
  <Override PartName="/docProps/app.xml" ContentType="application/vnd.openxmlformats-officedocument.extended-properties+xml"/>
</Types>'''
    rels = '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="xl/workbook.xml"/>
  <Relationship Id="rId2" Type="http://schemas.openxmlformats.org/package/2006/relationships/metadata/core-properties" Target="docProps/core.xml"/>
  <Relationship Id="rId3" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/extended-properties" Target="docProps/app.xml"/>
</Relationships>'''
    workbook = f'''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<workbook xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">
  <sheets><sheet name="{html.escape(sheet_name)}" sheetId="1" r:id="rId1"/></sheets>
</workbook>'''
    workbook_rels = '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet" Target="worksheets/sheet1.xml"/>
  <Relationship Id="rId2" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles" Target="styles.xml"/>
</Relationships>'''
    styles = '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<styleSheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">
  <fonts count="1"><font><sz val="11"/><name val="Calibri"/></font></fonts>
  <fills count="1"><fill><patternFill patternType="none"/></fill></fills>
  <borders count="1"><border><left/><right/><top/><bottom/><diagonal/></border></borders>
  <cellStyleXfs count="1"><xf numFmtId="0" fontId="0" fillId="0" borderId="0"/></cellStyleXfs>
  <cellXfs count="1"><xf numFmtId="0" fontId="0" fillId="0" borderId="0" xfId="0"/></cellXfs>
</styleSheet>'''
    core = '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<cp:coreProperties xmlns:cp="http://schemas.openxmlformats.org/package/2006/metadata/core-properties" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:dcmitype="http://purl.org/dc/dcmitype/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><dc:creator>Claude Code</dc:creator><cp:lastModifiedBy>Claude Code</cp:lastModifiedBy></cp:coreProperties>'''
    app = '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Properties xmlns="http://schemas.openxmlformats.org/officeDocument/2006/extended-properties" xmlns:vt="http://schemas.openxmlformats.org/officeDocument/2006/docPropsVTypes"><Application>Claude Code</Application></Properties>'''
    with zipfile.ZipFile(path, "w", compression=zipfile.ZIP_DEFLATED) as zf:
        zf.writestr("[Content_Types].xml", content_types)
        zf.writestr("_rels/.rels", rels)
        zf.writestr("xl/workbook.xml", workbook)
        zf.writestr("xl/_rels/workbook.xml.rels", workbook_rels)
        zf.writestr("xl/worksheets/sheet1.xml", sheet_xml(rows))
        zf.writestr("xl/styles.xml", styles)
        zf.writestr("docProps/core.xml", core)
        zf.writestr("docProps/app.xml", app)


def main():
    DATA_DIR.mkdir(parents=True, exist_ok=True)
    text = ATTACHMENT.read_text(encoding="utf-8-sig")
    provinces, wards, expected_counts, corrections = parse_attachment(text)

    province_rows = [PROVINCE_HEADERS]
    for i, p in enumerate(provinces, start=1):
        province_rows.append([i, p["code"], p["name"], "", "", "", 1])

    ward_rows = [WARD_HEADERS]
    for i, w in enumerate(wards, start=1):
        ward_rows.append([i, w["code"], w["name"], "", "", "", 1, w["province_code"]])

    write_xlsx(PROVINCE_XLSX, province_rows, "TinhThanh")
    write_xlsx(WARD_XLSX, ward_rows, "XaPhuong")

    province_codes = [p["code"] for p in provinces]
    ward_codes = [w["code"] for w in wards]
    province_code_set = set(province_codes)
    expected_province_codes = [code for code, _ in EXPECTED_PROVINCES]

    province_duplicates = sorted([code for code, count in Counter(province_codes).items() if count > 1])
    ward_duplicates = sorted([code for code, count in Counter(ward_codes).items() if count > 1])
    invalid_province_codes = sorted([code for code in province_codes if not re.fullmatch(r"\d{2}", code)])
    invalid_ward_codes = sorted([code for code in ward_codes if not re.fullmatch(r"\d{5}", code)])
    missing_province_mapping = sorted([w["code"] for w in wards if w["province_code"] not in province_code_set])
    missing_expected_provinces = sorted(set(expected_province_codes) - province_code_set)
    extra_provinces = sorted(province_code_set - set(expected_province_codes))

    actual_by_province = Counter(w["province_code"] for w in wards)
    count_mismatches = []
    for code in sorted(expected_counts.keys()):
        actual = actual_by_province[code]
        expected = expected_counts[code]
        if actual != expected:
            name = next((p["name"] for p in provinces if p["code"] == code), code)
            count_mismatches.append((code, name, expected, actual))

    expected_total = sum(expected_counts.values())

    lines = []
    lines.append("# Validate dữ liệu import — CBCLOUDV2-9162")
    lines.append("")
    lines.append("Nguồn: `docs/features/CBCLOUDV2-9162/attachment.md` — Quyết định 19/2025/QĐ-TTg.")
    lines.append("")
    lines.append("## File đã sinh")
    lines.append("")
    lines.append(f"- `data/{PROVINCE_XLSX.name}`")
    lines.append(f"- `data/{WARD_XLSX.name}`")
    lines.append("")
    lines.append("## Kết quả kiểm tra")
    lines.append("")
    lines.append(f"- Số tỉnh/thành parse được: **{len(provinces)}** / kỳ vọng **34**.")
    lines.append(f"- Số xã/phường/đặc khu parse được: **{len(wards)}** / tổng theo heading **{expected_total}**.")
    lines.append(f"- Header tỉnh: `{', '.join(PROVINCE_HEADERS)}`.")
    lines.append(f"- Header xã/phường: `{', '.join(WARD_HEADERS)}`.")
    lines.append(f"- Mã tỉnh không đúng format `\\d{{2}}`: **{len(invalid_province_codes)}**.")
    lines.append(f"- Mã xã/phường không đúng format `\\d{{5}}`: **{len(invalid_ward_codes)}**.")
    lines.append(f"- Duplicate mã tỉnh: **{len(province_duplicates)}**.")
    lines.append(f"- Duplicate mã xã/phường: **{len(ward_duplicates)}**.")
    lines.append(f"- Xã/phường map tới mã tỉnh không tồn tại: **{len(missing_province_mapping)}**.")
    lines.append(f"- Tỉnh thiếu so với Appendix I chốt: **{len(missing_expected_provinces)}**.")
    lines.append(f"- Tỉnh ngoài Appendix I chốt: **{len(extra_provinces)}**.")
    lines.append(f"- Tỉnh có số dòng xã/phường lệch so với heading: **{len(count_mismatches)}**.")
    lines.append("")
    lines.append("## Đối soát số lượng theo tỉnh")
    lines.append("")
    lines.append("| Mã tỉnh | Tên tỉnh/thành | Theo tài liệu | Parse được | Kết quả |")
    lines.append("|---|---|---:|---:|---|")
    for code, name in EXPECTED_PROVINCES:
        expected = expected_counts.get(code, 0)
        actual = actual_by_province.get(code, 0)
        status = "OK" if expected == actual else "LỆCH"
        lines.append(f"| {code} | {name} | {expected} | {actual} | {status} |")
    lines.append("")
    lines.append("## Dòng đã chuẩn hóa/sửa OCR")
    lines.append("")
    if corrections:
        for item in corrections:
            lines.append(f"- {item}")
    else:
        lines.append("- Không có.")
    lines.append("")
    lines.append("## Lưu ý import")
    lines.append("")
    lines.append("1. Import `CBCLOUDV2-9162-tinh-thanh-import.xlsx` trước.")
    lines.append("2. Sau khi tỉnh import thành công, import `CBCLOUDV2-9162-xa-phuong-import.xlsx` vì file xã/phường validate `Mã tỉnh thành` phải tồn tại và đang hiệu lực.")
    lines.append("3. Sau import, kiểm tra Redis keys `VS_LIST_PROVINCE` và `VS_LIST_WARD_[province_code]` trên đúng Redis DB cấu hình của môi trường.")

    VALIDATE_MD.write_text("\n".join(lines) + "\n", encoding="utf-8")

    print(f"province_file={PROVINCE_XLSX}")
    print(f"ward_file={WARD_XLSX}")
    print(f"validate_file={VALIDATE_MD}")
    print(f"province_count={len(provinces)}")
    print(f"ward_count={len(wards)}")
    print(f"expected_ward_total={expected_total}")
    print(f"invalid_province_codes={len(invalid_province_codes)}")
    print(f"invalid_ward_codes={len(invalid_ward_codes)}")
    print(f"province_duplicates={len(province_duplicates)}")
    print(f"ward_duplicates={len(ward_duplicates)}")
    print(f"missing_province_mapping={len(missing_province_mapping)}")
    print(f"count_mismatches={len(count_mismatches)}")


if __name__ == "__main__":
    main()
