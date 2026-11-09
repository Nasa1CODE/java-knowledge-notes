-- Table: vs_hd_quyetdinh_mauhd
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/HoaDon/QuyetDinhPhatHanh/HD_QuyetDinh_MauHD.cs
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
--   LoaiHoaDon_MauSo varchar(255) NULL -- C# string
--   LoaiHoaDon_Ten varchar(255) NULL -- C# string
--   MucDichSuDung varchar(255) NULL -- C# string
--   QuyetDinhPhatHanh_Id int NOT NULL -- C# int
--   DoanhNghiep_MST varchar(255) NULL -- C# string
--   TenantId int NULL -- C# int?
--   KyHieu varchar(255) NULL -- C# string
--   TuSo varchar(255) NULL -- C# string
--   DenSo varchar(255) NULL -- C# string
--   LastMauSo varchar(255) NULL -- C# string
--   MauSo varchar(255) NULL -- C# string
--   HD_QuyetDinhPhatHanh text NOT NULL -- C# HD_QuyetDinhPhatHanh

CREATE TABLE `vs_hd_quyetdinh_mauhd` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `LoaiHoaDon_MauSo` varchar(255) NULL,
    `LoaiHoaDon_Ten` varchar(255) NULL,
    `MucDichSuDung` varchar(255) NULL,
    `QuyetDinhPhatHanh_Id` int NOT NULL,
    `DoanhNghiep_MST` varchar(255) NULL,
    `TenantId` int NULL,
    `KyHieu` varchar(255) NULL,
    `TuSo` varchar(255) NULL,
    `DenSo` varchar(255) NULL,
    `LastMauSo` varchar(255) NULL,
    `MauSo` varchar(255) NULL,
    `HD_QuyetDinhPhatHanh` text NOT NULL
);
