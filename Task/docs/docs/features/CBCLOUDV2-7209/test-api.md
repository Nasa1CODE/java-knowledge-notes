# CBCLOUDV2-7209 - Hướng dẫn kiểm thử hai API ký MTT

## Mục đích

Tài liệu hướng dẫn kiểm thử tuần tự hai API MTT trong `api-cloud-service/`:

1. `TaiXmlMTTChuaKy`: tạo XML chưa ký và mã phiên giao dịch.
2. `GuiXmlMTTDaKy`: nhận XML đã ký, kiểm tra chữ ký, lưu hóa đơn và có thể gửi TCT.

Chỉ dùng tenant và hóa đơn kiểm thử. Không đưa XML đã ký, chứng thư số, access token, thông tin khách hàng hoặc cấu hình nội bộ vào ticket, log chia sẻ hoặc tài liệu này.

## Xác nhận endpoint trước khi test

Hai phương thức nằm trong `XuLyHoaDonAppService`. Theo convention ABP đang dùng, endpoint dự kiến là:

```text
POST {{baseUrl}}/api/services/hddtws/XuLyHoaDon/TaiXmlMTTChuaKy
POST {{baseUrl}}/api/services/hddtws/XuLyHoaDon/GuiXmlMTTDaKy
```

Trước khi gửi request, mở Swagger của đúng môi trường (thường là `{{baseUrl}}/swagger`) và xác nhận đường dẫn controller/service thực tế. Nếu Swagger sinh đường dẫn khác, dùng đường dẫn Swagger thay vì tự sửa source hoặc proxy.

## Chuẩn bị môi trường

Tạo Postman Environment hoặc biến shell sau:

| Biến | Mô tả |
| --- | --- |
| `baseUrl` | Base URL của `api-cloud-service/` tại môi trường test. |
| `accessToken` | Bearer token của user thuộc tenant được phép thao tác hóa đơn. |
| `enterpriseTaxId` | MST hoặc CCCD của doanh nghiệp test, phải khớp doanh nghiệp trong session. |
| `transactionCode` | `magiaodich` của hóa đơn test. |
| `invoiceCode` | `ma_hoadon` của hóa đơn test. |
| `sessionCode` | Giá trị `maphiengiaodich` lấy từ API 1. |
| `signedBase64Xml` | XML đã ký hợp lệ, mã hóa Base64, tạo từ XML API 1 trả về. |

Headers dùng cho cả hai API:

```http
Authorization: Bearer {{accessToken}}
Content-Type: application/json
Accept: application/json
```

Điều kiện dữ liệu khuyến nghị:

- Hóa đơn thuộc tenant/doanh nghiệp của `accessToken`.
- Hóa đơn là TT78 và ở trạng thái có thể ký; dùng hóa đơn test chưa ký/chưa gửi TCT.
- Nếu kiểm tra gửi TCT tự động: doanh nghiệp được TCT phê duyệt, cấu hình gửi từng lần, chứng thư có hình thức Token và hóa đơn là gốc/điều chỉnh/thay thế.
- API host truy cập được dịch vụ `validateservice.xml`, file storage và Kafka cấu hình cho môi trường test.

## Bước 1 - Gọi `TaiXmlMTTChuaKy`

### Request Postman

- Method: `POST`
- URL: `{{baseUrl}}/api/services/hddtws/XuLyHoaDon/TaiXmlMTTChuaKy`
- Body: `raw` / `JSON`

```json
{
  "doanhnghiep_mst": "{{enterpriseTaxId}}",
  "magiaodich": "{{transactionCode}}",
  "ma_hoadon": "{{invoiceCode}}"
}
```

### Request cURL

```bash
curl --request POST "{{baseUrl}}/api/services/hddtws/XuLyHoaDon/TaiXmlMTTChuaKy" \
  --header "Authorization: Bearer {{accessToken}}" \
  --header "Content-Type: application/json" \
  --data '{
    "doanhnghiep_mst": "{{enterpriseTaxId}}",
    "magiaodich": "{{transactionCode}}",
    "ma_hoadon": "{{invoiceCode}}"
  }'
```

### Kết quả thành công

Response mong đợi:

```json
{
  "maketqua": "01",
  "motaketqua": "Tải hóa đơn thành công",
  "maphiengiaodich": "<mã phiên do API trả về>",
  "base64xml": "<XML chưa ký dạng Base64>"
}
```

## Bước trung gian - Ký XML bằng `invoice-signing-tester`

Sau khi API 1 trả `maketqua = "01"`, ký XML bằng công cụ cục bộ tại:

```text
D:\Source\repo\frontend_angular\invoice-signing-tester\index.html
```

Thao tác:

1. Lưu `maphiengiaodich` từ API 1 vào biến `sessionCode`.
2. Giải mã `base64xml` từ API 1 thành chuỗi XML UTF-8 chưa ký. Điền chuỗi XML này vào `xmlData`; không điền nguyên chuỗi Base64 chưa ký.
3. Mở `index.html` bằng trình duyệt tại máy đã cài ứng dụng ký số cục bộ, chọn chế độ `Ký MTT`.
4. Giữ endpoint ký MTT do công cụ tự điền hoặc thay bằng endpoint ký cục bộ đã được cấp. Không chọn chế độ ký hóa đơn thường TT78.
5. Nhấn `Khôi phục mẫu`, rồi cập nhật JSON tại ô `Request`:
   - `xmlData`: XML chưa ký từ bước 2.
   - `certSerial`: serial chứng thư Token kiểm thử đang cắm trên máy.
   - `signDate`: thời điểm ký theo `dd-MM-yyyy HH:mm:ss`.
   - `transactionCode`: mã thông điệp trong XML chưa ký, nếu dịch vụ ký yêu cầu.
   - Giữ `isPos: true` và các trường MTT còn lại theo mẫu công cụ tạo. Không đổi `tagSign`, `tagSigner` hoặc cấu trúc XML khi chưa có hướng dẫn kỹ thuật riêng.
6. Nhấn `Gửi yêu cầu ký` và chờ `Response` từ dịch vụ ký cục bộ.
7. Lấy chuỗi Base64 XML đã ký từ response, lưu nguyên vẹn vào `signedBase64Xml`. Nếu response không chỉ rõ trường Base64 XML đã ký, dừng test và xác nhận hợp đồng response; không Base64 toàn bộ JSON response.
8. Không dùng lại mã phiên cho hóa đơn khác và không để mã phiên hết hạn trước khi gọi API 2.

Mẫu JSON tối thiểu cho công cụ ký MTT:

```json
{
  "xmlData": "<TDiep>...</TDiep>",
  "certSerial": "{{tokenCertificateSerial}}",
  "signDate": "{{signDate}}",
  "isPos": true,
  "transactionCode": "{{messageCode}}"
}
```

Không lưu `certSerial`, XML chưa ký/đã ký hoặc response nguyên vẹn từ công cụ ký vào bằng chứng chia sẻ.

### Kết quả lỗi cần kiểm tra

| Tình huống | Kết quả dự kiến |
| --- | --- |
| MST/CCCD không thuộc doanh nghiệp hiện tại hoặc không tồn tại | Không trả XML; có thể trả `Không tìm thấy doanh nghiệp` hoặc kết quả lỗi mặc định. |
| Hóa đơn đã ký hoặc đã gửi TCT theo quy tắc TT78 | `maketqua = "03"`; không có mã phiên mới. |
| Ngày lập hóa đơn không hợp lệ | `maketqua = "04"`. |
| Hóa đơn/mã giao dịch không tồn tại | Kết quả lỗi hiện hữu, thường mặc định `maketqua = "02"`. |

## Bước 2 - Gọi `GuiXmlMTTDaKy`

Chỉ gọi API này sau khi API 1 trả về `maketqua = "01"` và XML đã được ký bằng Token hợp lệ.

### Request Postman

- Method: `POST`
- URL: `{{baseUrl}}/api/services/hddtws/XuLyHoaDon/GuiXmlMTTDaKy`
- Body: `raw` / `JSON`

```json
{
  "doanhnghiep_mst": "{{enterpriseTaxId}}",
  "magiaodich": "{{transactionCode}}",
  "ma_hoadon": "{{invoiceCode}}",
  "maphiengiaodich": "{{sessionCode}}",
  "base64xml": "{{signedBase64Xml}}"
}
```

### Request cURL

```bash
curl --request POST "{{baseUrl}}/api/services/hddtws/XuLyHoaDon/GuiXmlMTTDaKy" \
  --header "Authorization: Bearer {{accessToken}}" \
  --header "Content-Type: application/json" \
  --data '{
    "doanhnghiep_mst": "{{enterpriseTaxId}}",
    "magiaodich": "{{transactionCode}}",
    "ma_hoadon": "{{invoiceCode}}",
    "maphiengiaodich": "{{sessionCode}}",
    "base64xml": "{{signedBase64Xml}}"
  }'
```

### Kết quả thành công

Response ký thành công tối thiểu có dạng:

```json
{
  "maketqua": "01",
  "motaketqua": "Gửi hóa đơn đã ký thành công",
  "mahoadon": "<mã hóa đơn>",
  "magiaodich": "<mã giao dịch>",
  "mauso": "<mẫu số>",
  "kyhieu": "<ký hiệu>",
  "sohoadon": "<số hóa đơn>",
  "ngaylap": "<ngày lập>",
  "trangthai": "DaKy hoặc DangGuiTCT",
  "motatrangthai": "<mô tả trạng thái>"
}
```

Kiểm tra sau request:

1. XML đã ký được lưu tại file storage theo đường dẫn hóa đơn hiện hữu.
2. Hóa đơn được cập nhật người ký, ngày ký và trạng thái ký.
3. Nếu đủ điều kiện gửi từng lần lên TCT, trạng thái response/hóa đơn là `DangGuiTCT`.
4. Với trường hợp gửi TCT, kiểm tra có `ServiceTax`, `Transaction_Log`, XML thông điệp và log Kafka producer tương ứng; producer thành công chưa khẳng định TCT đã chấp nhận.
5. Nếu cấu hình `GuiEmail_TuDong` bật, kiểm tra luồng email hiện hữu bằng dữ liệu test.

### Kết quả lỗi cần kiểm tra

| Tình huống | `maketqua` dự kiến | Kết quả cần xác nhận |
| --- | --- | --- |
| Không có `maphiengiaodich` hoặc MST không khớp session | Kết quả lỗi mặc định | Không cập nhật hóa đơn, không lưu XML. |
| Mã phiên hết hạn, không còn cache | `07` | Thông báo phiên làm việc không hợp lệ; yêu cầu lại XML chưa ký. |
| Mã phiên sai định dạng | `11` | Thông báo mã phiên giao dịch không hợp lệ. |
| XML không có chữ ký hợp lệ | `08` | Thông báo `Chữ ký không hợp lệ!`; không ký/gửi TCT. |
| XML thiếu `TTChung.MTDiep` nhưng thỏa điều kiện gửi TCT | `10` | Không tạo bản ghi gửi TCT mới. |
| Đã tồn tại gửi TCT và không phải luồng gửi lại | Lỗi từ `GuiTCTMTT` | Không tạo `ServiceTax` trùng. |

## Postman Tests gợi ý

Thêm script vào tab `Tests` của request API 1:

```javascript
const body = pm.response.json();

pm.test("HTTP status là 200", () => {
    pm.response.to.have.status(200);
});

pm.test("Tạo XML MTT thành công", () => {
    pm.expect(body.maketqua).to.eql("01");
    pm.expect(body.base64xml).to.be.a("string").and.not.empty;
    pm.expect(body.maphiengiaodich).to.be.a("string").and.not.empty;
});

pm.environment.set("sessionCode", body.maphiengiaodich);
pm.environment.set("unsignedBase64Xml", body.base64xml);
```

Thêm script vào tab `Tests` của request API 2:

```javascript
const body = pm.response.json();

pm.test("HTTP status là 200", () => {
    pm.response.to.have.status(200);
});

pm.test("Ký XML MTT thành công", () => {
    pm.expect(body.maketqua).to.eql("01");
    pm.expect(body.sohoadon).to.be.a("string").and.not.empty;
});
```

## Bằng chứng cần lưu

- Thời gian test, tên môi trường và user/tenant test đã được che thông tin nhạy cảm.
- Request ID/correlation ID nếu hệ thống trả về hoặc log có hỗ trợ.
- `maketqua`, `motaketqua`, trạng thái hóa đơn trước/sau test.
- Với gửi TCT: ID của `ServiceTax`/`Transaction_Log`, trạng thái Kafka producer và trạng thái xử lý phía sau nếu có.
- Không lưu `accessToken`, XML đầy đủ, `base64xml`, chứng thư hoặc dữ liệu khách hàng trong bằng chứng.
