# CBCLOUDV2-9170 NMua XML Required Fields Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Ensure TT32/68 XML for invoices with vehicle-specific fields always includes the buyer address, phone, email, and citizen ID required by CQT.

**Architecture:** The three existing XML generators already use `HasVehicleDacTrungField(hoaDon)` to select XML version `2.1.1`. At the end of each `GetNMuaInfo` method, use that same predicate to overwrite only the four CQT-required `NMua` values from the invoice buyer data. Placing the block after template-specific branches preserves normal-invoice behavior while preventing those branches from replacing the vehicle buyer address with a warehouse address.

**Tech Stack:** C#, .NET, `System.Xml.Serialization`, existing TT32/68 invoice XML utilities.

---

### Task 1: Map CQT-required buyer fields in invoicecore

**Files:**
- Modify: `invoicecore/aspnet-core/src/hddt/HDDT.Application/Commons/HoaDon/HoaDonTT3268Utility.cs:2286-2302`

- [ ] **Step 1: Add the vehicle-only buyer-field mapping after all template-specific `NMua` assignments**

```csharp
if (HasVehicleDacTrungField(hoaDon))
{
    nMua.DChi = hoaDon.DNMua_DiaChi;
    nMua.SDThoai = hoaDon.DNMua_SDT;
    nMua.DCTDTu = hoaDon.DNMua_Email;
    nMua.CCCDan = hoaDon.HD_HoaDon_MoRong?.DNMua_CCCD;
}
```

- [ ] **Step 2: Build invoicecore without restoring packages**

Run: `dotnet build "HDDT.Application/HDDT.Application.csproj" --no-restore`

Expected: build completes with `0 Error(s)`; existing warnings may remain.

### Task 2: Map CQT-required buyer fields in sendmail XML generator

**Files:**
- Modify: `invoice-sendmail-service/ConsumerApplication/QuanLyHoaDon/HoaDonUtil/HoaDonTT3268Utility.cs:2014-2022`

- [ ] **Step 1: Add the vehicle-only buyer-field mapping after extended buyer information is assigned**

```csharp
if (HasVehicleDacTrungField(hoaDon))
{
    nMua.DChi = hoaDon.DNMua_DiaChi;
    nMua.SDThoai = hoaDon.DNMua_SDT;
    nMua.DCTDTu = hoaDon.DNMua_Email;
    nMua.CCCDan = hoaDon.HD_HoaDon_MoRong?.DNMua_CCCD;
}
```

- [ ] **Step 2: Build sendmail consumer without restoring packages**

Run: `dotnet build "ConsumerApplication/SendMailConsumerApp.csproj" --no-restore`

Expected: build completes with `0 Error(s)`; existing warnings may remain.

### Task 3: Map CQT-required buyer fields in ZIP/PDF XML generator

**Files:**
- Modify: `export-zip-pdf-service/Common/Invoices/Utilities/HoaDonTT3268Utility.cs:1894-1902`

- [ ] **Step 1: Add the vehicle-only buyer-field mapping after extended buyer information is assigned**

```csharp
if (HasVehicleDacTrungField(hoaDon))
{
    nMua.DChi = hoaDon.DNMua_DiaChi;
    nMua.SDThoai = hoaDon.DNMua_SDT;
    nMua.DCTDTu = hoaDon.DNMua_Email;
    nMua.CCCDan = hoaDon.HD_HoaDon_MoRong?.DNMua_CCCD;
}
```

- [ ] **Step 2: Build ZIP/PDF consumer without restoring packages**

Run: `dotnet build "ZipPdfInvConsumer/ZipPdfInvConsumer.csproj" --no-restore`

Expected: build completes with `0 Error(s)`; existing warnings may remain.

### Task 4: Update CQT regression documentation

**Files:**
- Modify: `docs/features/CBCLOUDV2-9170/expect.md:36-41`
- Modify: `docs/features/CBCLOUDV2-9170/testcase.md`
- Modify: `docs/features/CBCLOUDV2-9170/report.md`

- [ ] **Step 1: Document the conditional contract**

Add that an invoice selected by `HasVehicleDacTrungField` must serialize `NMua/DChi`, `NMua/SDThoai`, `NMua/DCTDTu`, and `NMua/CCCDan` from the buyer fields, even for templates that ordinarily map the buyer address from `VanChuyen_KhoNhap`.

- [ ] **Step 2: Add a regression testcase**

Record a vehicle invoice with a template `6`, nonempty buyer address, phone, email, and citizen ID. Assert that the serialized `NMua` includes those exact four values and is not rejected by CQT validation `MLoi=20001` for a missing field.

- [ ] **Step 3: Record verification evidence**

Update the report with the three build commands and their observed results, plus the outstanding need to submit an XML fixture to CQT/UAT.

### Task 5: Final static verification

**Files:**
- Verify: the three utility files and `docs/features/CBCLOUDV2-9170/`

- [ ] **Step 1: Check the patch for whitespace errors**

Run: `git diff --check -- invoicecore/aspnet-core/src/hddt/HDDT.Application/Commons/HoaDon/HoaDonTT3268Utility.cs invoice-sendmail-service/ConsumerApplication/QuanLyHoaDon/HoaDonUtil/HoaDonTT3268Utility.cs export-zip-pdf-service/Common/Invoices/Utilities/HoaDonTT3268Utility.cs docs/features/CBCLOUDV2-9170`

Expected: no whitespace errors.

- [ ] **Step 2: Inspect the final diff**

Run: `git diff -- invoicecore/aspnet-core/src/hddt/HDDT.Application/Commons/HoaDon/HoaDonTT3268Utility.cs invoice-sendmail-service/ConsumerApplication/QuanLyHoaDon/HoaDonUtil/HoaDonTT3268Utility.cs export-zip-pdf-service/Common/Invoices/Utilities/HoaDonTT3268Utility.cs docs/features/CBCLOUDV2-9170`

Expected: only vehicle-specific `NMua` mapping and CBCLOUDV2-9170 documentation changes are present.

**Commit:** Do not commit. The user explicitly requested no commits.
