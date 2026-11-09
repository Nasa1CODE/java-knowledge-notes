-- Table: vs_tailieu
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/HoTro/TaiLieu.cs
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
--   TaiLieu_Loai int NOT NULL -- C# int
--   TaiLieu_So varchar(255) NULL -- C# string
--   TaiLieu_Ten varchar(255) NULL -- C# string
--   TaiLieu_MoTa varchar(255) NULL -- C# string
--   DuongDan varchar(255) NULL -- C# string
--   PhatHanh_DonVi varchar(255) NULL -- C# string
--   PhatHanh_Ngay datetime NULL -- C# DateTime?
--   HieuLuc_Ngay datetime NULL -- C# DateTime?
--   DaiLy_Id int NULL -- C# int?

CREATE TABLE `vs_tailieu` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `TaiLieu_Loai` int NOT NULL,
    `TaiLieu_So` varchar(255) NULL,
    `TaiLieu_Ten` varchar(255) NULL,
    `TaiLieu_MoTa` varchar(255) NULL,
    `DuongDan` varchar(255) NULL,
    `PhatHanh_DonVi` varchar(255) NULL,
    `PhatHanh_Ngay` datetime NULL,
    `HieuLuc_Ngay` datetime NULL,
    `DaiLy_Id` int NULL
);
