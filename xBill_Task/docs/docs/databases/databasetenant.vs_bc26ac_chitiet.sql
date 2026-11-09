-- Table: vs_bc26ac_chitiet
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/BaoCao/Bc26ac_ChiTiet.cs
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
--   Bc26ac_TongHopId int NULL -- C# int?
--   HienThi_Stt int NULL -- C# int?
--   LoaiHoaDon_Ma varchar(255) NULL -- C# string
--   LoaiHoaDon_Ten varchar(255) NULL -- C# string
--   HoaDon_MauSo varchar(255) NULL -- C# string
--   HoaDon_KyHieu varchar(255) NULL -- C# string
--   DauKy_TongSo int NOT NULL -- C# int
--   DauKy_Ton_TuSo int NOT NULL -- C# int
--   DauKy_Ton_DenSo int NOT NULL -- C# int
--   TrongKy_ThongBao_TuSo int NOT NULL -- C# int
--   TrongKy_ThongBao_DenSo int NOT NULL -- C# int
--   TrongKy_SuDung_TuSo int NOT NULL -- C# int
--   TrongKy_SuDung_DenSo int NOT NULL -- C# int
--   TrongKy_SuDung_TongSo int NOT NULL -- C# int
--   TrongKy_PhatHanh_So int NOT NULL -- C# int
--   TrongKy_XoaBo_SoLuong int NOT NULL -- C# int
--   TrongKy_XoaBo_So varchar(255) NULL -- C# string
--   TrongKy_Mat_SoLuong int NOT NULL -- C# int
--   TrongKy_Mat_So varchar(255) NULL -- C# string
--   TrongKy_Huy_SoLuong int NOT NULL -- C# int
--   TrongKy_Huy_So varchar(255) NULL -- C# string
--   CuoiKy_Ton_TuSo int NOT NULL -- C# int
--   CuoiKy_Ton_DenSo int NOT NULL -- C# int
--   CuoiKy_Ton_SoLuong int NOT NULL -- C# int
--   DoanhNghiep_MST varchar(255) NULL -- C# string
--   TenantId int NULL -- C# int?

CREATE TABLE `vs_bc26ac_chitiet` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `Bc26ac_TongHopId` int NULL,
    `HienThi_Stt` int NULL,
    `LoaiHoaDon_Ma` varchar(255) NULL,
    `LoaiHoaDon_Ten` varchar(255) NULL,
    `HoaDon_MauSo` varchar(255) NULL,
    `HoaDon_KyHieu` varchar(255) NULL,
    `DauKy_TongSo` int NOT NULL,
    `DauKy_Ton_TuSo` int NOT NULL,
    `DauKy_Ton_DenSo` int NOT NULL,
    `TrongKy_ThongBao_TuSo` int NOT NULL,
    `TrongKy_ThongBao_DenSo` int NOT NULL,
    `TrongKy_SuDung_TuSo` int NOT NULL,
    `TrongKy_SuDung_DenSo` int NOT NULL,
    `TrongKy_SuDung_TongSo` int NOT NULL,
    `TrongKy_PhatHanh_So` int NOT NULL,
    `TrongKy_XoaBo_SoLuong` int NOT NULL,
    `TrongKy_XoaBo_So` varchar(255) NULL,
    `TrongKy_Mat_SoLuong` int NOT NULL,
    `TrongKy_Mat_So` varchar(255) NULL,
    `TrongKy_Huy_SoLuong` int NOT NULL,
    `TrongKy_Huy_So` varchar(255) NULL,
    `CuoiKy_Ton_TuSo` int NOT NULL,
    `CuoiKy_Ton_DenSo` int NOT NULL,
    `CuoiKy_Ton_SoLuong` int NOT NULL,
    `DoanhNghiep_MST` varchar(255) NULL,
    `TenantId` int NULL
);
