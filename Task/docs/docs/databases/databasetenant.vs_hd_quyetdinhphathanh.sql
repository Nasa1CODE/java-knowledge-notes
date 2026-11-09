-- Table: vs_hd_quyetdinhphathanh
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/HoaDon/QuyetDinhPhatHanh/HD_QuyetDinhPhatHanh.cs
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
--   DoanhNghiep_MST varchar(255) NULL -- C# string
--   DoanhNghiep_Ten varchar(255) NULL -- C# string
--   DoanhNghiep_GiamDoc varchar(255) NULL -- C# string
--   QuyetDinh_CanCu varchar(255) NULL -- C# string
--   QuyetDinh_So varchar(255) NULL -- C# string
--   QuyetDinh_NguoiDeNghi varchar(255) NULL -- C# string
--   QuyetDinh_NoiNhan varchar(255) NULL -- C# string
--   QuyetDinh_TinhThanh varchar(255) NULL -- C# string
--   QuyetDinh_TrangThai int NOT NULL -- C# int
--   Dieu5_NgayHieuLuc datetime NULL -- C# DateTime?
--   Dieu1_TieuDe varchar(255) NULL -- C# string
--   Dieu1_NoiDung varchar(255) NULL -- C# string
--   Dieu2_TieuDe varchar(255) NULL -- C# string
--   Dieu3_TieuDe varchar(255) NULL -- C# string
--   Dieu3_NoiDung varchar(255) NULL -- C# string
--   Dieu4_TieuDe varchar(255) NULL -- C# string
--   Dieu4_NoiDung varchar(255) NULL -- C# string
--   Dieu5_TieuDe varchar(255) NULL -- C# string
--   Dieu5_NoiDung varchar(255) NULL -- C# string
--   Ngay_Lap datetime NOT NULL -- C# DateTime
--   TenantId int NULL -- C# int?

CREATE TABLE `vs_hd_quyetdinhphathanh` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `DoanhNghiep_MST` varchar(255) NULL,
    `DoanhNghiep_Ten` varchar(255) NULL,
    `DoanhNghiep_GiamDoc` varchar(255) NULL,
    `QuyetDinh_CanCu` varchar(255) NULL,
    `QuyetDinh_So` varchar(255) NULL,
    `QuyetDinh_NguoiDeNghi` varchar(255) NULL,
    `QuyetDinh_NoiNhan` varchar(255) NULL,
    `QuyetDinh_TinhThanh` varchar(255) NULL,
    `QuyetDinh_TrangThai` int NOT NULL,
    `Dieu5_NgayHieuLuc` datetime NULL,
    `Dieu1_TieuDe` varchar(255) NULL,
    `Dieu1_NoiDung` varchar(255) NULL,
    `Dieu2_TieuDe` varchar(255) NULL,
    `Dieu3_TieuDe` varchar(255) NULL,
    `Dieu3_NoiDung` varchar(255) NULL,
    `Dieu4_TieuDe` varchar(255) NULL,
    `Dieu4_NoiDung` varchar(255) NULL,
    `Dieu5_TieuDe` varchar(255) NULL,
    `Dieu5_NoiDung` varchar(255) NULL,
    `Ngay_Lap` datetime NOT NULL,
    `TenantId` int NULL
);
