# CBCLOUDV2-8430 Expect

## Goal

Move large `TinhHinhSuDungHoaDon/TaiExcelTheoBenMua` Excel exports to the existing background export flow while keeping small exports direct.

## Expected Behavior

- Small data exports download Excel immediately as before.
- Large data exports create a `vs_service_exportbill` job and return background export status/message.
- Worker creates the same Excel layout as current direct export.
- User downloads the generated file from Quản lý tải file.