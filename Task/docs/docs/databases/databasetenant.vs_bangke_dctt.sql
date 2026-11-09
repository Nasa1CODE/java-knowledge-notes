-- Table: vs_bangke_dctt
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/BangKeDCTT/BangKe_DCTT.cs
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
--   SoBangKe varchar(255) NULL -- C# string
--   NgayLap datetime NULL -- C# DateTime?
--   NgayKy datetime NULL -- C# DateTime?
--   Mst_NguoiMua varchar(255) NULL -- C# string
--   Ten_NguoiMua varchar(255) NULL -- C# string
--   Mau_KyHieu varchar(255) NULL -- C# string
--   Mau_MauSo varchar(255) NULL -- C# string
--   TinhChat int NULL -- C# int?
--   TrangThai int NULL -- C# int?
--   TongHop_Id int NULL -- C# int?
--   FilePath_XML varchar(255) NULL -- C# string
--   DoanhNghiep_MST varchar(255) NULL -- C# string
--   TenantId int NULL -- C# int?
--   DiaChi_NguoiMua varchar(255) NULL -- C# string
--   Sdt_NguoiMua varchar(255) NULL -- C# string
--   Email_NguoiMua varchar(255) NULL -- C# string
--   SoHoChieu_NguoiMua varchar(255) NULL -- C# string
--   CCCD_NguoiMua varchar(255) NULL -- C# string
--   Mdvqhns_NguoiMua varchar(255) NULL -- C# string
--   Ten_NguoiBan varchar(255) NULL -- C# string
--   MST_NguoiBan varchar(255) NULL -- C# string
--   DiaChi_NguoiBan varchar(255) NULL -- C# string
--   LyDo varchar(255) NULL -- C# string
--   FilePath_HDBK_XML varchar(255) NULL -- C# string
--   FilePath_Thue_XML varchar(255) NULL -- C# string
--   FilePath_ThongDiep_XML varchar(255) NULL -- C# string
--   QuanLy_GuiEmail int NULL -- C# int?
--   MaTraCuu varchar(255) NULL -- C# string

CREATE TABLE `vs_bangke_dctt` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `SoBangKe` varchar(255) NULL,
    `NgayLap` datetime NULL,
    `NgayKy` datetime NULL,
    `Mst_NguoiMua` varchar(255) NULL,
    `Ten_NguoiMua` varchar(255) NULL,
    `Mau_KyHieu` varchar(255) NULL,
    `Mau_MauSo` varchar(255) NULL,
    `TinhChat` int NULL,
    `TrangThai` int NULL,
    `TongHop_Id` int NULL,
    `FilePath_XML` varchar(255) NULL,
    `DoanhNghiep_MST` varchar(255) NULL,
    `TenantId` int NULL,
    `DiaChi_NguoiMua` varchar(255) NULL,
    `Sdt_NguoiMua` varchar(255) NULL,
    `Email_NguoiMua` varchar(255) NULL,
    `SoHoChieu_NguoiMua` varchar(255) NULL,
    `CCCD_NguoiMua` varchar(255) NULL,
    `Mdvqhns_NguoiMua` varchar(255) NULL,
    `Ten_NguoiBan` varchar(255) NULL,
    `MST_NguoiBan` varchar(255) NULL,
    `DiaChi_NguoiBan` varchar(255) NULL,
    `LyDo` varchar(255) NULL,
    `FilePath_HDBK_XML` varchar(255) NULL,
    `FilePath_Thue_XML` varchar(255) NULL,
    `FilePath_ThongDiep_XML` varchar(255) NULL,
    `QuanLy_GuiEmail` int NULL,
    `MaTraCuu` varchar(255) NULL
);
