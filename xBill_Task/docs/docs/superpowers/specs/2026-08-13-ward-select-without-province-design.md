# Ward Selection Without Province Design

## Scope

Allow the invoice-header Xã/Phường combobox to remain enabled before a Tỉnh/Thành phố is selected.

## Behavior

On initialization, the ward combobox uses the existing all-wards request (`GetXaPhuongTheoTinh(undefined)`). It remains enabled while no province is selected. Selecting a province clears the selected ward and replaces the option list with wards filtered by that province. The existing header-level validation still requires both `ma_Tinh` and `ma_Xa` for a special vehicle invoice before Save, Submit for signature, or Sign.

## Implementation

Remove only the ward select's `[disabled]` binding based on `ma_Tinh`. No backend, proxy, cascade, data-model, or validation change is required.
