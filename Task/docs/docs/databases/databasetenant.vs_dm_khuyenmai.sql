-- Table: vs_dm_khuyenmai
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/DanhMuc/DMKhuyenMai/DMKhuyenMai.cs
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
--   Ma_KhuyenMai varchar(255) NULL -- C# string
--   Ten_KhuyenMai varchar(255) NULL -- C# string
--   Noi_Dung varchar(255) NULL -- C# string
--   Ghi_Chu varchar(255) NULL -- C# string
--   Ngay_BatDau datetime NOT NULL -- C# DateTime
--   Ngay_KetThuc datetime NOT NULL -- C# DateTime

CREATE TABLE `vs_dm_khuyenmai` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `Ma_KhuyenMai` varchar(255) NULL,
    `Ten_KhuyenMai` varchar(255) NULL,
    `Noi_Dung` varchar(255) NULL,
    `Ghi_Chu` varchar(255) NULL,
    `Ngay_BatDau` datetime NOT NULL,
    `Ngay_KetThuc` datetime NOT NULL
);
