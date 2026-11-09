-- Table: vs_transaction_log
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/CauHinh/Transaction_Log.cs
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
--   TransType int NULL -- C# int?
--   TransFormCode varchar(255) NULL -- C# string
--   TransactionCode varchar(255) NULL -- C# string
--   SourceTrans int NULL -- C# int?
--   ResponseStatus int NULL -- C# int?
--   ResponseCode varchar(255) NULL -- C# string
--   ResponseDescription varchar(255) NULL -- C# string
--   TransName varchar(255) NULL -- C# string
--   Xmlpath varchar(255) NULL -- C# string
--   RegisterTax_ID int NULL -- C# int?
--   ServiceTax_ID int NULL -- C# int?
--   TenantId int NULL -- C# int?
--   DoanhNghiep_Mst varchar(255) NULL -- C# string

CREATE TABLE `vs_transaction_log` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `TransType` int NULL,
    `TransFormCode` varchar(255) NULL,
    `TransactionCode` varchar(255) NULL,
    `SourceTrans` int NULL,
    `ResponseStatus` int NULL,
    `ResponseCode` varchar(255) NULL,
    `ResponseDescription` varchar(255) NULL,
    `TransName` varchar(255) NULL,
    `Xmlpath` varchar(255) NULL,
    `RegisterTax_ID` int NULL,
    `ServiceTax_ID` int NULL,
    `TenantId` int NULL,
    `DoanhNghiep_Mst` varchar(255) NULL
);
