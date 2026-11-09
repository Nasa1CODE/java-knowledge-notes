-- Table: vs_service_print
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/HoaDon/PrintPDF/ServicePrintPDF.cs
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
--   FileName varchar(255) NULL -- C# string
--   XuatFile_TrangThai int NOT NULL -- C# int
--   XuatFile_DuongDan varchar(255) NULL -- C# string
--   HoaDon_TongHop varchar(255) NULL -- C# string
--   ExecutionTime datetime NULL -- C# DateTime?
--   DoanhNghiep_MST varchar(255) NULL -- C# string
--   TenantId int NULL -- C# int?
--   ChungThuKhauTru varchar(255) NULL -- C# string
--   LinkTraCuu varchar(255) NULL -- C# string

CREATE TABLE `vs_service_print` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `FileName` varchar(255) NULL,
    `XuatFile_TrangThai` int NOT NULL,
    `XuatFile_DuongDan` varchar(255) NULL,
    `HoaDon_TongHop` varchar(255) NULL,
    `ExecutionTime` datetime NULL,
    `DoanhNghiep_MST` varchar(255) NULL,
    `TenantId` int NULL,
    `ChungThuKhauTru` varchar(255) NULL,
    `LinkTraCuu` varchar(255) NULL
);
