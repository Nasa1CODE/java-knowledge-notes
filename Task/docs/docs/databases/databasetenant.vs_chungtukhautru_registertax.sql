-- Table: vs_chungtukhautru_registertax
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/CauHinh/ChungTuKhauTru_Registertax.cs
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
--   FilepathXml varchar(255) NULL -- C# string
--   TransactionCode varchar(255) NULL -- C# string
--   StatusCode varchar(255) NULL -- C# string
--   ErrorCode varchar(255) NULL -- C# string
--   ErrorDescription varchar(255) NULL -- C# string
--   Status int NULL -- C# int?
--   DoanhNghiep_MST varchar(255) NULL -- C# string
--   TenantId int NULL -- C# int?
--   RePresentative varchar(255) NULL -- C# string
--   RePresentative_Email varchar(255) NULL -- C# string
--   RePresentative_PhoneNumber varchar(255) NULL -- C# string
--   RePresentative_Address varchar(255) NULL -- C# string
--   DoanhNghiep_NgayKy datetime NULL -- C# DateTime?
--   Organization_Release bit NULL -- C# bool?
--   Tax_Release bit NULL -- C# bool?
--   Personal_Certificate bit NULL -- C# bool?
--   Commerce_Certificate bit NULL -- C# bool?
--   BLTPLPKIn bit NULL -- C# bool?
--   BLTPLPIn bit NULL -- C# bool?
--   BLTTPLPhi bit NULL -- C# bool?
--   Tax_Portal bit NULL -- C# bool?
--   Organization_Provide_Portal bit NULL -- C# bool?
--   Organization_Entrust_Portal bit NULL -- C# bool?

CREATE TABLE `vs_chungtukhautru_registertax` (
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
    `FilepathXml` varchar(255) NULL,
    `TransactionCode` varchar(255) NULL,
    `StatusCode` varchar(255) NULL,
    `ErrorCode` varchar(255) NULL,
    `ErrorDescription` varchar(255) NULL,
    `Status` int NULL,
    `DoanhNghiep_MST` varchar(255) NULL,
    `TenantId` int NULL,
    `RePresentative` varchar(255) NULL,
    `RePresentative_Email` varchar(255) NULL,
    `RePresentative_PhoneNumber` varchar(255) NULL,
    `RePresentative_Address` varchar(255) NULL,
    `DoanhNghiep_NgayKy` datetime NULL,
    `Organization_Release` bit NULL,
    `Tax_Release` bit NULL,
    `Personal_Certificate` bit NULL,
    `Commerce_Certificate` bit NULL,
    `BLTPLPKIn` bit NULL,
    `BLTPLPIn` bit NULL,
    `BLTTPLPhi` bit NULL,
    `Tax_Portal` bit NULL,
    `Organization_Provide_Portal` bit NULL,
    `Organization_Entrust_Portal` bit NULL
);
