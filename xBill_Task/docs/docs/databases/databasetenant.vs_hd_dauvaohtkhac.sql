-- Table: vs_hd_dauvaohtkhac
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/HoaDon/HoaDonTuHeThongKhac/HD_TuHeThongKhac.cs
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
--   Mau_NgayKy datetime NULL -- C# DateTime?
--   Mau_MauSo varchar(255) NULL -- C# string
--   Mau_KyHieu varchar(255) NULL -- C# string
--   Mau_So varchar(255) NULL -- C# string
--   TrangThai int NULL -- C# int?
--   DNMua_MST varchar(255) NULL -- C# string
--   DNMua_Ten varchar(255) NULL -- C# string
--   DNMua_TenNguoiMua varchar(255) NULL -- C# string
--   DNMua_DiaChi varchar(255) NULL -- C# string
--   Mau_TienTe_Ma varchar(255) NULL -- C# string
--   Mau_TyGiaNgoaiTe decimal(18,2) NULL -- C# decimal?
--   TongHop_TongTien_Covat decimal(18,2) NULL -- C# decimal?
--   Mau_GhiChu varchar(255) NULL -- C# string
--   Loai_HDon_File int NULL -- C# int?
--   HDon_File varchar(255) NULL -- C# string
--   Mau_HoaDon_Loai int NULL -- C# int?
--   DNMua_SDT varchar(255) NULL -- C# string
--   ThanhToan_TongTien int NULL -- C# int?
--   TongHop_TongTien_Covat_TangGiam int NULL -- C# int?
--   TongHop_NgoaiTe_Covat decimal(18,2) NULL -- C# decimal?
--   ThanhToan_GhiChu varchar(255) NULL -- C# string
--   DoanhNghiep_MST varchar(255) NULL -- C# string
--   TenantId int NULL -- C# int?

CREATE TABLE `vs_hd_dauvaohtkhac` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `Mau_NgayKy` datetime NULL,
    `Mau_MauSo` varchar(255) NULL,
    `Mau_KyHieu` varchar(255) NULL,
    `Mau_So` varchar(255) NULL,
    `TrangThai` int NULL,
    `DNMua_MST` varchar(255) NULL,
    `DNMua_Ten` varchar(255) NULL,
    `DNMua_TenNguoiMua` varchar(255) NULL,
    `DNMua_DiaChi` varchar(255) NULL,
    `Mau_TienTe_Ma` varchar(255) NULL,
    `Mau_TyGiaNgoaiTe` decimal(18,2) NULL,
    `TongHop_TongTien_Covat` decimal(18,2) NULL,
    `Mau_GhiChu` varchar(255) NULL,
    `Loai_HDon_File` int NULL,
    `HDon_File` varchar(255) NULL,
    `Mau_HoaDon_Loai` int NULL,
    `DNMua_SDT` varchar(255) NULL,
    `ThanhToan_TongTien` int NULL,
    `TongHop_TongTien_Covat_TangGiam` int NULL,
    `TongHop_NgoaiTe_Covat` decimal(18,2) NULL,
    `ThanhToan_GhiChu` varchar(255) NULL,
    `DoanhNghiep_MST` varchar(255) NULL,
    `TenantId` int NULL
);
