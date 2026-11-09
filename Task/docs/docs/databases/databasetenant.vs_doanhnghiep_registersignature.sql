-- Table: vs_doanhnghiep_registersignature
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/CauHinh/DoanhNghiep_ChungThuDangKy.cs
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
--   RegisterID int NULL -- C# int?
--   SignatureSerial varchar(255) NULL -- C# string
--   SignatureProvider varchar(255) NULL -- C# string
--   RegisterSignType int NULL -- C# int?
--   StartDate datetime NULL -- C# DateTime?
--   EndDate datetime NULL -- C# DateTime?
--   DoanhNghiep_MST varchar(255) NULL -- C# string
--   TenantId int NULL -- C# int?
--   Type_Send_Register int NULL -- C# int?
--   isOtherProvider bit NULL -- C# bool?

CREATE TABLE `vs_doanhnghiep_registersignature` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `RegisterID` int NULL,
    `SignatureSerial` varchar(255) NULL,
    `SignatureProvider` varchar(255) NULL,
    `RegisterSignType` int NULL,
    `StartDate` datetime NULL,
    `EndDate` datetime NULL,
    `DoanhNghiep_MST` varchar(255) NULL,
    `TenantId` int NULL,
    `Type_Send_Register` int NULL,
    `isOtherProvider` bit NULL
);
