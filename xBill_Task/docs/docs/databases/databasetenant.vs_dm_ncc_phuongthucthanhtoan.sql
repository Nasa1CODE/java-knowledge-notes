-- Table: vs_dm_ncc_phuongthucthanhtoan
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/DanhMuc/DMNhaCungCap/DM_NCC_PhuongThucThanhToan.cs
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
--   PhuongThuc_Ma int NOT NULL -- C# int
--   PhuongThuc_Ten varchar(255) NULL -- C# string
--   PhuongThuc_Ma_Hddt varchar(255) NULL -- C# string
--   PhuongThuc_MoTa varchar(255) NULL -- C# string
--   PhuongThuc_HieuLuc bit NULL -- C# bool?

CREATE TABLE `vs_dm_ncc_phuongthucthanhtoan` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `PhuongThuc_Ma` int NOT NULL,
    `PhuongThuc_Ten` varchar(255) NULL,
    `PhuongThuc_Ma_Hddt` varchar(255) NULL,
    `PhuongThuc_MoTa` varchar(255) NULL,
    `PhuongThuc_HieuLuc` bit NULL
);
