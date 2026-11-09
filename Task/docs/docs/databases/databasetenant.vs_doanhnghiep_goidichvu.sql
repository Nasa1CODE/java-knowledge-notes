-- Table: vs_doanhnghiep_goidichvu
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/QuanLy/DoanhNghiep_GoiDichVu.cs
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
--   KhuyenMai_Id int NULL -- C# int?
--   DichVu_Loai int NULL -- C# int?
--   DichVu_Ma varchar(255) NULL -- C# string
--   DichVu_Ten varchar(255) NULL -- C# string
--   DichVu_SoLuong int NULL -- C# int?
--   DichVu_Gia int NULL -- C# int?
--   DichVu_ThoiGian_SuDung int NULL -- C# int?
--   DichVu_ThoiGian_LuuTru int NULL -- C# int?
--   DichVu_NgayMua datetime NULL -- C# DateTime?
--   DichVu_SoLuongDaDung int NULL -- C# int?
--   DichVu_SoLuongConLai int NULL -- C# int?
--   DichVu_Hddv_SoLuongDaDung int NULL -- C# int?
--   DoanhNghiep_Mst varchar(255) NULL -- C# string
--   DichVu_ThoiGian_HetHan datetime NULL -- C# DateTime?
--   TenantId int NULL -- C# int?
--   MaThueBao varchar(255) NULL -- C# string
--   MaThueBaoCu varchar(255) NULL -- C# string
--   SubId_CyberId varchar(255) NULL -- C# string

CREATE TABLE `vs_doanhnghiep_goidichvu` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `KhuyenMai_Id` int NULL,
    `DichVu_Loai` int NULL,
    `DichVu_Ma` varchar(255) NULL,
    `DichVu_Ten` varchar(255) NULL,
    `DichVu_SoLuong` int NULL,
    `DichVu_Gia` int NULL,
    `DichVu_ThoiGian_SuDung` int NULL,
    `DichVu_ThoiGian_LuuTru` int NULL,
    `DichVu_NgayMua` datetime NULL,
    `DichVu_SoLuongDaDung` int NULL,
    `DichVu_SoLuongConLai` int NULL,
    `DichVu_Hddv_SoLuongDaDung` int NULL,
    `DoanhNghiep_Mst` varchar(255) NULL,
    `DichVu_ThoiGian_HetHan` datetime NULL,
    `TenantId` int NULL,
    `MaThueBao` varchar(255) NULL,
    `MaThueBaoCu` varchar(255) NULL,
    `SubId_CyberId` varchar(255) NULL
);
