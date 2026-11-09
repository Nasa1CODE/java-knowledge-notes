# CBCLOUDV2-8320 Expect

## Feature Status

- Status: approved
- Class: Small

## Business Goal

In the enterprise information screen, users need to distinguish tax departments that have similar names by seeing both the tax department name and code in the Chi cục thuế selectbox.

## Scope

- Page: `/app/hddt/cauhinh/thongtindoanhnghiep/thongtinchung`
- Tab: Thông tin chung
- Field: Chi cục thuế selectbox
- Change display text from `ccT_Ten` to `ccT_Ten - Mã: ccT_Ma`.
- Keep the selected value and saved value as `ccT_Ma`.

## Out Of Scope

- Do not change API contracts.
- Do not change database schema or data.
- Do not change other tax department selectors unless separately requested.

## Acceptance Criteria

- Each Chi cục thuế option displays tax department name and code in the format `ccT_Ten - Mã: ccT_Ma`.
- The option value remains `ccT_Ma` so save behavior is unchanged.
- Empty option behavior remains unchanged.
