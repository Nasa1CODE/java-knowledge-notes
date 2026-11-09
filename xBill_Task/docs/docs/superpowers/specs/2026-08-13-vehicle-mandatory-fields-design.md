# Vehicle Mandatory Fields Design

## Scope

Apply the supplied mandatory-field rules to each special vehicle detail line where `hangHoa_Loai == 4` and `loai_HangHoa_DacTrung == 1`. The rule changes only frontend behavior and feature documentation. Database type `TTai decimal(10,2)` remains unchanged.

## Validation

Every vehicle line requires: `So_Khung`, `So_May`, `LTSan`, `TTTSan`, `XXu`, `MNSXuat`, `TLTSDKy`, `NSXuat`, `TTMai`, `TNHieu`, `KLXe`, `TTLVHCSuat`, `TTai`, and `SCNgoi`.

`XXu == 1` requires `SGCNATKThuat`; `XXu == 0` requires `SSPKTCLXXuong`. `TTTSan == 1` requires `CLTSan` and `SBKSoat`.

The form warning area shows each missing-field message, and Save, Submit for signature, and Sign stay disabled while any required vehicle detail is invalid. Click-path validation remains as defense in depth.

## Field Rules

The UI enum values match the supplied contract: `TTTSan` is `0` unused and `1` used; `XXu` is `0` assembled and `1` imported. Text inputs use the supplied maximum lengths. `TTai` is validated in the UI as a positive decimal with at most 9 integer digits and 2 fractional digits; persistence stays `decimal(10,2)`.
