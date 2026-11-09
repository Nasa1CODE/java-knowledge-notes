# Conventions — <SERVICE_OR_GROUP>

## Nhận dạng

- **Service/group:** `<service-key>`
- **Vai trò:**
- **Stack:**

## Layer map

| Việc cần làm | Đặt ở đâu |
|---|---|
| API/entry point | |
| Business logic | |
| Data access | |
| DTO/model | |
| Config | |
| UI/route (nếu có) | |

## Kiểm chứng

```text
<build/test command>
```

## Pitfall và vùng cấm thay đổi

- <generated files, build outputs, contracts, legacy modules>
