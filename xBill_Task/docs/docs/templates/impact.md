# Impact — <TICKET-ID>

> Theo [rules/04-create-impact.md](../rules/04-create-impact.md). Dựng nháp khi lập plan; **finalize sau khi code xong** theo ảnh hưởng thật.

## 1. Mục đích

<Thay đổi gì, thuộc ticket nào, service nào — một đoạn ngắn.>

## 2. Phạm vi thay đổi

- Chỉ logic: <có/không>
- Đụng dữ liệu: <có/không>
- Đổi schema / migration: <có/không — **nói thẳng nếu KHÔNG**>
- Đổi hợp đồng (API / message hàng đợi): <có/không>

## 3. Thành phần bị ảnh hưởng

### Backend

| Service | File / method | Mức | Lý do |
|---|---|---|---|
| | | Thấp/TB/Cao | |

### Frontend

| Màn hình / route | File | Mức | Lý do |
|---|---|---|---|
| | | | |

### Database

| Bảng / cột | Thay đổi | Mức | Migration |
|---|---|---|---|
| | | | |

### Hàng đợi / tích hợp / cấu hình

| Thành phần | Thay đổi | Mức | Ghi chú |
|---|---|---|---|
| | | | |

> Cấu hình chỉ ghi **tên khóa**, không ghi giá trị.

## 4. Xác nhận KHÔNG bị ảnh hưởng

> Liệt kê cụ thể. "Mọi thứ còn lại không ảnh hưởng" là **không chấp nhận được**.

| Vùng | Vì sao không bị ảnh hưởng |
|---|---|
| | |

## 5. Rủi ro & hạn chế đã biết

| Rủi ro / hạn chế | Mức | Xử lý |
|---|---|---|
| | | |

> Chạm luồng công khai, phân quyền, đa tenant, hoặc dữ liệu thuế → **bắt buộc** có dòng về rủi ro lộ dữ liệu.

## 6. Chưa được kiểm chứng

| Việc chưa làm | Vì sao |
|---|---|
| | |

## 7. Kết luận

<Một câu về mức rủi ro tổng thể + khuyến nghị trước khi phát hành.>
