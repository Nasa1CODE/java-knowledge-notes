-- Table: vs_hd_thongbaophathanh
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/HoaDon/ThongBaoPhatHanh/HD_ThongBaoPhatHanh.cs
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
--   DoanhNghiep_DiaChi varchar(255) NULL -- C# string
--   DoanhNghiep_GiamDoc varchar(255) NULL -- C# string
--   DoanhNghiep_SDT varchar(255) NULL -- C# string
--   TinhThanh_Ma varchar(255) NULL -- C# string
--   TinhThanh_Ten varchar(255) NULL -- C# string
--   QuanHuyen_Ma varchar(255) NULL -- C# string
--   QuanHuyen_Ten varchar(255) NULL -- C# string
--   CoQuanThue_Ma varchar(255) NULL -- C# string
--   CoQuanThue_Ten varchar(255) NULL -- C# string
--   DauPhanCach varchar(255) NULL -- C# string
--   ThongBao_NgayLap datetime NULL -- C# DateTime?
--   ThongBao_TrangThai int NOT NULL -- C# int
--   TenantId int NULL -- C# int?
--   Quyetdinh_Id int NULL -- C# int?
--   MieuTa varchar(255) NULL -- C# string
--   TrangThai_Chot int NULL -- C# int?
--   LyDoTuChoi varchar(255) NULL -- C# string

CREATE TABLE `vs_hd_thongbaophathanh` (
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
    `DoanhNghiep_DiaChi` varchar(255) NULL,
    `DoanhNghiep_GiamDoc` varchar(255) NULL,
    `DoanhNghiep_SDT` varchar(255) NULL,
    `TinhThanh_Ma` varchar(255) NULL,
    `TinhThanh_Ten` varchar(255) NULL,
    `QuanHuyen_Ma` varchar(255) NULL,
    `QuanHuyen_Ten` varchar(255) NULL,
    `CoQuanThue_Ma` varchar(255) NULL,
    `CoQuanThue_Ten` varchar(255) NULL,
    `DauPhanCach` varchar(255) NULL,
    `ThongBao_NgayLap` datetime NULL,
    `ThongBao_TrangThai` int NOT NULL,
    `TenantId` int NULL,
    `Quyetdinh_Id` int NULL,
    `MieuTa` varchar(255) NULL,
    `TrangThai_Chot` int NULL,
    `LyDoTuChoi` varchar(255) NULL
);
