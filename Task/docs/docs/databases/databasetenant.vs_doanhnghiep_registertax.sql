-- Table: vs_doanhnghiep_registertax
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/CauHinh/DoanhNghiep_TongCucThue.cs
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/DoanhNghiep/DoanhNghiepRegisterTax.cs
--
-- Fields inferred from C# entity properties. Verify exact SQL types, lengths, indexes, and constraints against real migrations/schema before deployment.
-- Fields:
--   Id int NOT NULL -- inherited Entity key
--   CreationTime datetime NOT NULL -- inherited audit field
--   CreatorUserId bigint NULL -- inherited audit field
--   LastModificationTime datetime NULL -- inherited audit field
--   LastModifierUserId bigint NULL -- inherited audit field
--   IsDeleted bit NOT NULL -- inherited soft-delete field
--   DeleterUserId bigint NULL -- inherited soft-delete field
--   DeletionTime datetime NULL -- inherited soft-delete field
--   RegisterType int NULL -- C# int?
--   TaxDepartCode varchar(255) NULL -- C# string
--   TaxDepartName varchar(255) NULL -- C# string
--   BusinessName varchar(255) NULL -- C# string
--   TaxCode varchar(255) NULL -- C# string
--   RePresentative varchar(255) NULL -- C# string
--   Email varchar(255) NULL -- C# string
--   PhoneNumber varchar(255) NULL -- C# string
--   Address varchar(255) NULL -- C# string
--   IstaxDepartCode bit NULL -- C# bool?
--   SendInvoice int NULL -- C# int?
--   SendBangTongHop int NULL -- C# int?
--   IsVatInvoice bit NULL -- C# bool?
--   IssaleBill bit NULL -- C# bool?
--   IsOther bit NULL -- C# bool?
--   IsHalfResource bit NULL -- C# bool?
--   IsHalfResourceInternal bit NULL -- C# bool?
--   IsDocumentPrint bit NULL -- C# bool?
--   FilepathXml varchar(255) NULL -- C# string
--   TransactionCode varchar(255) NULL -- C# string
--   StatusCode varchar(255) NULL -- C# string
--   ErrorCode varchar(255) NULL -- C# string
--   ErrorDescription varchar(255) NULL -- C# string
--   ReleaseDate datetime NULL -- C# DateTime?
--   Status int NULL -- C# int?
--   DoanhNghiep_MST varchar(255) NULL -- C# string
--   TenantId int NULL -- C# int?
--   IsDBKKhan bit NULL -- C# bool?
--   IsKTDNUBND bit NULL -- C# bool?
--   IsTTDCQT bit NULL -- C# bool?
--   IsQTCTN bit NULL -- C# bool?
--   DoanhNghiep_NgayKy datetime NULL -- C# DateTime?
--   IsPos bit NULL -- C# bool?
--   MaCqt varchar(255) NULL -- C# string
--   RePresentative_CCCD varchar(255) NULL -- C# string
--   Nationality varchar(255) NULL -- C# string
--   RePresentative_Birthday datetime NULL -- C# DateTime?
--   RePresentative_Passport varchar(255) NULL -- C# string
--   RePresentative_Gender int NULL -- C# int?
--   IsTaxNotCode int NULL -- C# int?
--   NNTDBKKhan bit NULL -- C# bool?
--   NNTKTDNUBND bit NULL -- C# bool?
--   CQXLTSCong bit NULL -- C# bool?
--   CDLTTDCQT bit NULL -- C# bool?
--   CDLQTCTN bit NULL -- C# bool?
--   NCCNN bit NULL -- C# bool?
--   IsVatInvoiceAndReceipt bit NULL -- C# bool?
--   IsSalesInvoiceAndReceipt bit NULL -- C# bool?
--   IsCommercialInvoice bit NULL -- C# bool?
--   IsInvoiceOfForeignSuppliers bit NULL -- C# bool?

CREATE TABLE `vs_doanhnghiep_registertax` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `RegisterType` int NULL,
    `TaxDepartCode` varchar(255) NULL,
    `TaxDepartName` varchar(255) NULL,
    `BusinessName` varchar(255) NULL,
    `TaxCode` varchar(255) NULL,
    `RePresentative` varchar(255) NULL,
    `Email` varchar(255) NULL,
    `PhoneNumber` varchar(255) NULL,
    `Address` varchar(255) NULL,
    `IstaxDepartCode` bit NULL,
    `SendInvoice` int NULL,
    `SendBangTongHop` int NULL,
    `IsVatInvoice` bit NULL,
    `IssaleBill` bit NULL,
    `IsOther` bit NULL,
    `IsHalfResource` bit NULL,
    `IsHalfResourceInternal` bit NULL,
    `IsDocumentPrint` bit NULL,
    `FilepathXml` varchar(255) NULL,
    `TransactionCode` varchar(255) NULL,
    `StatusCode` varchar(255) NULL,
    `ErrorCode` varchar(255) NULL,
    `ErrorDescription` varchar(255) NULL,
    `ReleaseDate` datetime NULL,
    `Status` int NULL,
    `DoanhNghiep_MST` varchar(255) NULL,
    `TenantId` int NULL,
    `IsDBKKhan` bit NULL,
    `IsKTDNUBND` bit NULL,
    `IsTTDCQT` bit NULL,
    `IsQTCTN` bit NULL,
    `DoanhNghiep_NgayKy` datetime NULL,
    `IsPos` bit NULL,
    `MaCqt` varchar(255) NULL,
    `RePresentative_CCCD` varchar(255) NULL,
    `Nationality` varchar(255) NULL,
    `RePresentative_Birthday` datetime NULL,
    `RePresentative_Passport` varchar(255) NULL,
    `RePresentative_Gender` int NULL,
    `IsTaxNotCode` int NULL,
    `NNTDBKKhan` bit NULL,
    `NNTKTDNUBND` bit NULL,
    `CQXLTSCong` bit NULL,
    `CDLTTDCQT` bit NULL,
    `CDLQTCTN` bit NULL,
    `NCCNN` bit NULL,
    `IsVatInvoiceAndReceipt` bit NULL,
    `IsSalesInvoiceAndReceipt` bit NULL,
    `IsCommercialInvoice` bit NULL,
    `IsInvoiceOfForeignSuppliers` bit NULL
);
