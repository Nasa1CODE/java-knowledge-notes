-- Table: vs_hd_thongbaohuy
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/HoaDon/ThongBaoHuy/HD_ThongBaoHuy.cs
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
--   ToKhai_Ma varchar(255) NULL -- C# string
--   ToKhai_Ten varchar(255) NULL -- C# string
--   ToKhai_Mota varchar(255) NULL -- C# string
--   ChiCucThue_Ma varchar(255) NULL -- C# string
--   ChiCucThue_Ten varchar(255) NULL -- C# string
--   NgayLap datetime NULL -- C# DateTime?
--   TrangThai int NOT NULL -- C# int
--   NgayKy datetime NULL -- C# DateTime?
--   NoiDung_KinhGui varchar(255) NULL -- C# string
--   NoiDung_PhuongPhapHuy varchar(255) NULL -- C# string
--   NoiDung_NguoiLap varchar(255) NULL -- C# string
--   DoanhNghiep_Ten varchar(255) NULL -- C# string
--   DoanhNghiep_DiaChi varchar(255) NULL -- C# string
--   DoanhNghiep_DaiDien varchar(255) NULL -- C# string
--   DoanhNghiep_QuanHuyen_Ma varchar(255) NULL -- C# string
--   DoanhNghiep_QuanHuyen_Ten varchar(255) NULL -- C# string
--   DoanhNghiep_Tinhthanh_Ma varchar(255) NULL -- C# string
--   DoanhNghiep_Tinhthanh_Ten varchar(255) NULL -- C# string
--   DoanhNghiep_Fax varchar(255) NULL -- C# string
--   DoanhNghiep_Email varchar(255) NULL -- C# string
--   DoanhNghiep_MST varchar(255) NULL -- C# string
--   TenantId int NULL -- C# int?

CREATE TABLE `vs_hd_thongbaohuy` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `ToKhai_Ma` varchar(255) NULL,
    `ToKhai_Ten` varchar(255) NULL,
    `ToKhai_Mota` varchar(255) NULL,
    `ChiCucThue_Ma` varchar(255) NULL,
    `ChiCucThue_Ten` varchar(255) NULL,
    `NgayLap` datetime NULL,
    `TrangThai` int NOT NULL,
    `NgayKy` datetime NULL,
    `NoiDung_KinhGui` varchar(255) NULL,
    `NoiDung_PhuongPhapHuy` varchar(255) NULL,
    `NoiDung_NguoiLap` varchar(255) NULL,
    `DoanhNghiep_Ten` varchar(255) NULL,
    `DoanhNghiep_DiaChi` varchar(255) NULL,
    `DoanhNghiep_DaiDien` varchar(255) NULL,
    `DoanhNghiep_QuanHuyen_Ma` varchar(255) NULL,
    `DoanhNghiep_QuanHuyen_Ten` varchar(255) NULL,
    `DoanhNghiep_Tinhthanh_Ma` varchar(255) NULL,
    `DoanhNghiep_Tinhthanh_Ten` varchar(255) NULL,
    `DoanhNghiep_Fax` varchar(255) NULL,
    `DoanhNghiep_Email` varchar(255) NULL,
    `DoanhNghiep_MST` varchar(255) NULL,
    `TenantId` int NULL
);
