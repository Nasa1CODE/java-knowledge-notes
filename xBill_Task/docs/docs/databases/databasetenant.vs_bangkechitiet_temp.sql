-- Table: vs_bangkechitiet_temp
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/BaoCao/Bangke_ChiTiet_Temp.cs
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
--   HoaDon_TongHopId int NOT NULL -- C# int
--   HoaDon_Stt int NULL -- C# int?
--   HoaDon_TrangThai int NULL -- C# int?
--   BangKe_KyKeKhaiId int NOT NULL -- C# int
--   HoaDon_GhiChu varchar(255) NULL -- C# string
--   HDLienQuan_Loai int NULL -- C# int?
--   HDLienQuan_MauSo varchar(255) NULL -- C# string
--   HDLienQuan_KyHieu varchar(255) NULL -- C# string
--   HDLienQuan_So varchar(255) NULL -- C# string
--   TCT_ThongBao_So varchar(255) NULL -- C# string
--   TCT_ThongBaoNgay datetime NULL -- C# DateTime?
--   TenantId int NULL -- C# int?
--   DoanhNghiep_MST varchar(255) NULL -- C# string
--   BKChiTiet_TrangThai int NULL -- C# int?
--   HoaDon_MauSo varchar(255) NULL -- C# string
--   HoaDon_KyHieu varchar(255) NULL -- C# string
--   HoaDon_So varchar(255) NULL -- C# string
--   BangKeTongHop_Id int NULL -- C# int?

CREATE TABLE `vs_bangkechitiet_temp` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `HoaDon_TongHopId` int NOT NULL,
    `HoaDon_Stt` int NULL,
    `HoaDon_TrangThai` int NULL,
    `BangKe_KyKeKhaiId` int NOT NULL,
    `HoaDon_GhiChu` varchar(255) NULL,
    `HDLienQuan_Loai` int NULL,
    `HDLienQuan_MauSo` varchar(255) NULL,
    `HDLienQuan_KyHieu` varchar(255) NULL,
    `HDLienQuan_So` varchar(255) NULL,
    `TCT_ThongBao_So` varchar(255) NULL,
    `TCT_ThongBaoNgay` datetime NULL,
    `TenantId` int NULL,
    `DoanhNghiep_MST` varchar(255) NULL,
    `BKChiTiet_TrangThai` int NULL,
    `HoaDon_MauSo` varchar(255) NULL,
    `HoaDon_KyHieu` varchar(255) NULL,
    `HoaDon_So` varchar(255) NULL,
    `BangKeTongHop_Id` int NULL
);
