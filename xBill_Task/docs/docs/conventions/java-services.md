# Conventions — Java Spring Boot service (BillCloud)

> Quy ước chung mọi service ở [../project.md](../project.md) §4–8. File này ghi phần riêng của **các Java Spring Boot service** trên Cloud.
> Áp dụng cho: `etran-teanant-service/` (xử lý message thuế/e-transaction), `hotfixlogin/`, `invoice-java-service/`, `createxml-service/`, `validate-signature-service/`, `cyberidapiextenal/`. Tra repo path ở [../AGENTS.md](../AGENTS.md).

## Nhận dạng

- **Vai trò:** xử lý nghiệp vụ bảng kê/DCTT và message thuế/e-transaction; tiêu thụ Kafka, sinh XML/PDF, gọi tích hợp ngoài.
- **Stack:** Java · Spring Boot · Maven.

## Quy ước kiến trúc

- Giữ pattern **controller/listener → service → repository**; tách rõ tầng.
- **Định tuyến master/tenant DB:** thao tác tenant phải resolve tenant DB đúng; **clear tenant context sau khi xong** (tránh rò context sang message kế tiếp).
- **Kafka:** topic/group/bootstrap servers/SASL lấy từ **config**, không hardcode. Xử lý các loại message thuế (`102`, `103`, `104`, `110`, `111`, `202`, `204`, `213`, `301`, `302`, `999` …) theo đúng code hiện có — chỉ mở rộng loại đã hỗ trợ.
- **Parse XML an toàn:** không tin payload; giữ nguyên vẹn XML đầu vào khi ký/chuyển tiếp.
- Gọi callback/QLDV/FTP/email khi nghiệp vụ yêu cầu — đều qua config.

## Kiểm chứng

```bash
mvn -q -DskipTests package        # build
# test/tích hợp Kafka/tenant DB thường là manual, cần môi trường thật
```

## Pitfall

- **Rò tenant context** giữa các message bất đồng bộ là lỗi nặng — luôn clear sau xử lý.
- Tích hợp Kafka/CQT/HSM **không chạy được ở local** → testcase đánh dấu `manual`.
- Idempotent khi có retry: cùng một message xử lý lại không được nhân đôi hiệu ứng.

## Không được đụng

`target/`, artifact build, file cấu hình chứa secret (không copy giá trị đi đâu).
