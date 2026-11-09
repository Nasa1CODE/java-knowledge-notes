# CBCLOUDV2-8826 Test Cases

| Case | Expected | Status |
| --- | --- | --- |
| Màn KH `/app/hddt/cauhinh/thongtindoanhnghiep/thongtinchung`, mở ô chọn Chi cục thuế, chi cục CÓ Tên tắt | Option hiển thị dòng chính `{ccT_Ten} - Mã: {ccT_Ma}` và dòng phụ `Tên viết tắt: {ccT_TenTat}` | not run |
| Màn KH, chi cục KHÔNG có Tên tắt | Chỉ hiển thị dòng chính; không có dòng phụ, không hiển thị `undefined`/`null` | not run |
| Màn Admin `/app/hddt/quanly/capnhapthongtin-doanhnghiep?tenantid={tenantId}&mstdoanhnghiep={mst}`, chi cục CÓ Tên tắt | Option hiển thị `{ccT_Ten} - Mã: {ccT_Ma}` + `Tên viết tắt: {ccT_TenTat}` | not run |
| Màn Admin, chi cục KHÔNG có Tên tắt | Không hiển thị dòng phụ rỗng/`undefined` | not run |
| Tên tắt hiển thị đúng dữ liệu | Giá trị dòng phụ khớp cột Tên tắt của từng chi cục trong danh mục | not run |
| Chọn một Chi cục thuế và Lưu Thông tin doanh nghiệp | Giá trị lưu là `ccT_Ma`, lưu thành công, không lỗi | not run |
| Tìm kiếm trong ô chọn (data-live-search) | Vẫn lọc được theo tên/mã; hiển thị đúng dòng chính + dòng phụ | not run |
| Đổi Chi cục thuế rồi mở lại danh sách | Danh sách render lại đúng, subtext hiển thị (selectpicker refresh) | not run |
| Gõ tìm kiếm trong ô chọn → option match được active | Nền option đổi sang xám nhạt (không còn nền tím), giữ nguyên màu chữ (chính đen, phụ xám) → đọc rõ cả dòng chính lẫn "Tên viết tắt" | not run |
