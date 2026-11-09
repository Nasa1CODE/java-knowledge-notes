# CBCLOUDV2-9016 Expect

## Feature Status

- Status: done
- Class: XS

## Business Goal

Fix behavior of `Dinh kem bang ke` on `hoadon-goc` so unchecking it really clears the attached bang ke data and stays unchecked after reopening edit.

## Scope

- Frontend: `frontend_angular/`
- Screen: `/app/hddt/hoadon-hoadon-goc`
- Related data: extended invoice fields for bang ke

## Expected Behavior

- When user unchecks `Dinh kem bang ke`, the invoice clears `soBangKe`, `ngayBangKe`, `file_BangKe`, and `file_BangKe_Data`.
- Save/sign/submit flows keep the unchecked state.
- Reopening edit does not auto-check the box from stale data.

## Out Of Scope

- No DB schema change.
- No BE API change.
- No change to CKTM checkbox logic.

