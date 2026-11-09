-- Table: vs_kh_khuyenmai
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/KhuyenMai/KhachHang_KhuyenMai.cs
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
--   Ten_KhachHang varchar(255) NULL -- C# string
--   Email_KhachHang varchar(255) NULL -- C# string
--   Sdt_KhachHang varchar(255) NULL -- C# string
--   GoiDichVu_Id int NOT NULL -- C# int
--   Ma_DichVu varchar(255) NULL -- C# string
--   KhuyenMai_Id int NOT NULL -- C# int
--   Ma_KhuyenMai varchar(255) NULL -- C# string
--   TrangThaiGui_Crm int NOT NULL -- C# int
--   DaiLy_Id int NULL -- C# int?
--   RequestGui_Crm varchar(255) NULL -- C# string
--   GhiChuLoiGui_Crm varchar(255) NULL -- C# string
--   DoanhNghiep_MST varchar(255) NULL -- C# string
--   TenantId int NULL -- C# int?

CREATE TABLE `vs_kh_khuyenmai` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `Ten_KhachHang` varchar(255) NULL,
    `Email_KhachHang` varchar(255) NULL,
    `Sdt_KhachHang` varchar(255) NULL,
    `GoiDichVu_Id` int NOT NULL,
    `Ma_DichVu` varchar(255) NULL,
    `KhuyenMai_Id` int NOT NULL,
    `Ma_KhuyenMai` varchar(255) NULL,
    `TrangThaiGui_Crm` int NOT NULL,
    `DaiLy_Id` int NULL,
    `RequestGui_Crm` varchar(255) NULL,
    `GhiChuLoiGui_Crm` varchar(255) NULL,
    `DoanhNghiep_MST` varchar(255) NULL,
    `TenantId` int NULL
);
