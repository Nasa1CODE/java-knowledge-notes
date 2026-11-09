# CBCLOUDV2-9021 Test Cases

## TC01 - Adjustment invoice, uncheck bang ke

- Open adjustment invoice created from an original invoice with attached bang ke.
- Uncheck "Dinh kem bang ke".
- Save.
- Expected request: `file_BangKe_Sua = true`, bang ke fields are cleared.
- Reopen edit.
- Expected: "Dinh kem bang ke" remains unchecked.

## TC02 - Replacement invoice, uncheck bang ke

- Open replacement invoice created from an original invoice with attached bang ke.
- Uncheck "Dinh kem bang ke".
- Save.
- Reopen edit.
- Expected: bang ke is not copied back from the original invoice.

## TC03 - Keep bang ke checked

- Open invoice with attached bang ke and keep checkbox checked.
- Save.
- Expected: existing bang ke values remain.
