-- Table: vs_hd_bienbanthoathuan
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/HoaDon/QuanLyHoaDon/HD_BienBanThoaThuan.cs
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
--   LoaiBienBan int NOT NULL -- C# int
--   SoBienBan varchar(255) NULL -- C# string
--   TongHop_Id int NULL -- C# int?
--   NgayLap datetime NOT NULL -- C# DateTime
--   DNBan_Ten varchar(255) NULL -- C# string
--   DNBan_DiaChi varchar(255) NULL -- C# string
--   DNBan_SDT varchar(255) NULL -- C# string
--   DNBan_DaiDien varchar(255) NULL -- C# string
--   DNBan_ChucVu_DaiDien varchar(255) NULL -- C# string
--   DNMua_Ten varchar(255) NULL -- C# string
--   DNMua_MST varchar(255) NULL -- C# string
--   DNMua_DiaChi varchar(255) NULL -- C# string
--   DNMua_DaiDien varchar(255) NULL -- C# string
--   DNMua_ChucVu_DaiDien varchar(255) NULL -- C# string
--   DNMua_SDT varchar(255) NULL -- C# string
--   LyDo varchar(255) NULL -- C# string
--   NoiDung_TruocDieuChinh varchar(255) NULL -- C# string
--   NoiDung_SauDieuChinh varchar(255) NULL -- C# string
--   DNMua_KySo int NULL -- C# int?
--   DNBan_KySo int NULL -- C# int?
--   DNMua_NgayKy varchar(255) NULL -- C# string
--   DNBan_NgayKy varchar(255) NULL -- C# string
--   DoanhNghiep_MST varchar(255) NULL -- C# string
--   TenantId int NULL -- C# int?
--   HopDong_So varchar(255) NULL -- C# string
--   HopDong_NgayKy datetime NULL -- C# DateTime?
--   KieuBienBan int NULL -- C# int?
--   ChungTu_Id int NULL -- C# int?
--   FilePath_Vbtt varchar(255) NULL -- C# string
--   BangKeDCTTSo varchar(255) NULL -- C# string
--   BangKeDCTTNgayLap datetime NULL -- C# DateTime?

CREATE TABLE `vs_hd_bienbanthoathuan` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `LoaiBienBan` int NOT NULL,
    `SoBienBan` varchar(255) NULL,
    `TongHop_Id` int NULL,
    `NgayLap` datetime NOT NULL,
    `DNBan_Ten` varchar(255) NULL,
    `DNBan_DiaChi` varchar(255) NULL,
    `DNBan_SDT` varchar(255) NULL,
    `DNBan_DaiDien` varchar(255) NULL,
    `DNBan_ChucVu_DaiDien` varchar(255) NULL,
    `DNMua_Ten` varchar(255) NULL,
    `DNMua_MST` varchar(255) NULL,
    `DNMua_DiaChi` varchar(255) NULL,
    `DNMua_DaiDien` varchar(255) NULL,
    `DNMua_ChucVu_DaiDien` varchar(255) NULL,
    `DNMua_SDT` varchar(255) NULL,
    `LyDo` varchar(255) NULL,
    `NoiDung_TruocDieuChinh` varchar(255) NULL,
    `NoiDung_SauDieuChinh` varchar(255) NULL,
    `DNMua_KySo` int NULL,
    `DNBan_KySo` int NULL,
    `DNMua_NgayKy` varchar(255) NULL,
    `DNBan_NgayKy` varchar(255) NULL,
    `DoanhNghiep_MST` varchar(255) NULL,
    `TenantId` int NULL,
    `HopDong_So` varchar(255) NULL,
    `HopDong_NgayKy` datetime NULL,
    `KieuBienBan` int NULL,
    `ChungTu_Id` int NULL,
    `FilePath_Vbtt` varchar(255) NULL,
    `BangKeDCTTSo` varchar(255) NULL,
    `BangKeDCTTNgayLap` datetime NULL
);
