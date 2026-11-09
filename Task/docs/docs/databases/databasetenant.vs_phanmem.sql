-- Table: vs_phanmem
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/HoTro/PhanMem.cs
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
--   PhanMem_Loai int NOT NULL -- C# int
--   PhanMem_Ten varchar(255) NULL -- C# string
--   PhanMem_PhienBan varchar(255) NULL -- C# string
--   PhanMem_MoTa varchar(255) NULL -- C# string
--   PhatHanh_DonVi varchar(255) NULL -- C# string
--   PhatHanh_Ngay datetime NULL -- C# DateTime?
--   PhanMem_DuongDan varchar(255) NULL -- C# string
--   DaiLy_Id int NULL -- C# int?

CREATE TABLE `vs_phanmem` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `PhanMem_Loai` int NOT NULL,
    `PhanMem_Ten` varchar(255) NULL,
    `PhanMem_PhienBan` varchar(255) NULL,
    `PhanMem_MoTa` varchar(255) NULL,
    `PhatHanh_DonVi` varchar(255) NULL,
    `PhatHanh_Ngay` datetime NULL,
    `PhanMem_DuongDan` varchar(255) NULL,
    `DaiLy_Id` int NULL
);
