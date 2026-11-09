-- Table: vs_hd_thongbaohuy_hdmau
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/HoaDon/ThongBaoHuy/HD_ThongBaoHuy_HDMau.cs
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
--   HDMau_Ma varchar(255) NULL -- C# string
--   HDMau_Ten varchar(255) NULL -- C# string
--   HDMau_KyHieu varchar(255) NULL -- C# string
--   ThongBaoHuy_SoLuong int NOT NULL -- C# int
--   ThongBaoHuy_TuSo int NOT NULL -- C# int
--   ThongBaoHuy_DenSo int NOT NULL -- C# int
--   ThongBaoHuy_Id int NOT NULL -- C# int
--   ThongBaoHuy_TrangThai int NOT NULL -- C# int
--   ThongBao_MauHD_Id int NOT NULL -- C# int
--   ThongBaoPhatHanh_id int NOT NULL -- C# int
--   HDMau_xslt varchar(255) NULL -- C# string
--   HDMau_xml varchar(255) NULL -- C# string
--   DoanhNghiep_MST varchar(255) NULL -- C# string
--   TenantId int NULL -- C# int?

CREATE TABLE `vs_hd_thongbaohuy_hdmau` (
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
    `HDMau_Ma` varchar(255) NULL,
    `HDMau_Ten` varchar(255) NULL,
    `HDMau_KyHieu` varchar(255) NULL,
    `ThongBaoHuy_SoLuong` int NOT NULL,
    `ThongBaoHuy_TuSo` int NOT NULL,
    `ThongBaoHuy_DenSo` int NOT NULL,
    `ThongBaoHuy_Id` int NOT NULL,
    `ThongBaoHuy_TrangThai` int NOT NULL,
    `ThongBao_MauHD_Id` int NOT NULL,
    `ThongBaoPhatHanh_id` int NOT NULL,
    `HDMau_xslt` varchar(255) NULL,
    `HDMau_xml` varchar(255) NULL,
    `DoanhNghiep_MST` varchar(255) NULL,
    `TenantId` int NULL
);
