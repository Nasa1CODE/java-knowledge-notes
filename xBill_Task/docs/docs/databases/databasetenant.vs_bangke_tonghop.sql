-- Table: vs_bangke_tonghop
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/BaoCao/Bangke_TongHop.cs
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
--   ThoiGian_Loai int NOT NULL -- C# int
--   ThoiGian_Ngay int NULL -- C# int?
--   ThoiGian_Thang int NULL -- C# int?
--   ThoiGian_Quy int NULL -- C# int?
--   ThoiGian_Nam int NULL -- C# int?
--   BangKe_MauSo varchar(255) NULL -- C# string
--   BangKe_So varchar(255) NULL -- C# string
--   BangKe_LoaiHangHoa int NULL -- C# int?
--   BangKe_HinhThuc int NULL -- C# int?
--   BoSung_LanThu int NULL -- C# int?
--   DoanhNghiep_Ten varchar(255) NULL -- C# string
--   DoanhNghiep_DiaChi varchar(255) NULL -- C# string
--   BangKe_NgayLap datetime NULL -- C# DateTime?
--   Bangke_NguoiLap varchar(255) NULL -- C# string
--   BangKe_TrangThai int NULL -- C# int?
--   BangKe_FilePath_Xml varchar(255) NULL -- C# string
--   BangKe_KySo varchar(255) NULL -- C# string
--   DoanhNghiep_MST varchar(255) NULL -- C# string
--   TenantId int NULL -- C# int?
--   KyKeKhai_Id int NOT NULL -- C# int

CREATE TABLE `vs_bangke_tonghop` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `ThoiGian_Loai` int NOT NULL,
    `ThoiGian_Ngay` int NULL,
    `ThoiGian_Thang` int NULL,
    `ThoiGian_Quy` int NULL,
    `ThoiGian_Nam` int NULL,
    `BangKe_MauSo` varchar(255) NULL,
    `BangKe_So` varchar(255) NULL,
    `BangKe_LoaiHangHoa` int NULL,
    `BangKe_HinhThuc` int NULL,
    `BoSung_LanThu` int NULL,
    `DoanhNghiep_Ten` varchar(255) NULL,
    `DoanhNghiep_DiaChi` varchar(255) NULL,
    `BangKe_NgayLap` datetime NULL,
    `Bangke_NguoiLap` varchar(255) NULL,
    `BangKe_TrangThai` int NULL,
    `BangKe_FilePath_Xml` varchar(255) NULL,
    `BangKe_KySo` varchar(255) NULL,
    `DoanhNghiep_MST` varchar(255) NULL,
    `TenantId` int NULL,
    `KyKeKhai_Id` int NOT NULL
);
