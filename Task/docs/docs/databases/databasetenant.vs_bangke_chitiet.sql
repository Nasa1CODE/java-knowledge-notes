-- Table: vs_bangke_chitiet
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/BaoCao/Bangke_ChiTiet.cs
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
--   BangKe_TongHopId int NOT NULL -- C# int
--   HoaDon_TongHopId int NOT NULL -- C# int
--   HoaDon_Stt varchar(255) NULL -- C# string
--   LoaiHoaDon_Ten varchar(255) NULL -- C# string
--   HoaDon_MauSo varchar(255) NULL -- C# string
--   HoaDon_KyHieu varchar(255) NULL -- C# string
--   HoaDon_So varchar(255) NULL -- C# string
--   HoaDon_NgayLap datetime NULL -- C# DateTime?
--   HDLienQuan_NgayLap datetime NULL -- C# DateTime?
--   HoaDon_TgTienThanhToan decimal(18,2) NULL -- C# decimal?
--   HoaDon_TrangThai int NULL -- C# int?
--   HoaDon_GhiChu varchar(255) NULL -- C# string
--   DnMua_Ma varchar(255) NULL -- C# string
--   DnMua_Ten varchar(255) NULL -- C# string
--   DnMua_Mst varchar(255) NULL -- C# string
--   HangHoa_Ma varchar(255) NULL -- C# string
--   HangHoa_Ten varchar(255) NULL -- C# string
--   HangHoa_TenDonViTinh varchar(255) NULL -- C# string
--   HangHoa_SoLuong decimal(18,2) NULL -- C# decimal?
--   HoaDon_TongTienChuaThue decimal(18,2) NULL -- C# decimal?
--   HoaDon_TgTienCoThue decimal(18,2) NULL -- C# decimal?
--   HoaDon_TgTienThue decimal(18,2) NULL -- C# decimal?
--   HoaDon_ThueSuat int NULL -- C# int?
--   HDLienQuan_Loai int NULL -- C# int?
--   HDLienQuan_MauSo varchar(255) NULL -- C# string
--   HDLienQuan_KyHieu varchar(255) NULL -- C# string
--   HDLienQuan_So varchar(255) NULL -- C# string
--   TCT_ThongBao_So varchar(255) NULL -- C# string
--   TCT_ThongBaoNgay datetime NULL -- C# DateTime?
--   DoanhNghiep_MST varchar(255) NULL -- C# string
--   TenantId int NULL -- C# int?

CREATE TABLE `vs_bangke_chitiet` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `BangKe_TongHopId` int NOT NULL,
    `HoaDon_TongHopId` int NOT NULL,
    `HoaDon_Stt` varchar(255) NULL,
    `LoaiHoaDon_Ten` varchar(255) NULL,
    `HoaDon_MauSo` varchar(255) NULL,
    `HoaDon_KyHieu` varchar(255) NULL,
    `HoaDon_So` varchar(255) NULL,
    `HoaDon_NgayLap` datetime NULL,
    `HDLienQuan_NgayLap` datetime NULL,
    `HoaDon_TgTienThanhToan` decimal(18,2) NULL,
    `HoaDon_TrangThai` int NULL,
    `HoaDon_GhiChu` varchar(255) NULL,
    `DnMua_Ma` varchar(255) NULL,
    `DnMua_Ten` varchar(255) NULL,
    `DnMua_Mst` varchar(255) NULL,
    `HangHoa_Ma` varchar(255) NULL,
    `HangHoa_Ten` varchar(255) NULL,
    `HangHoa_TenDonViTinh` varchar(255) NULL,
    `HangHoa_SoLuong` decimal(18,2) NULL,
    `HoaDon_TongTienChuaThue` decimal(18,2) NULL,
    `HoaDon_TgTienCoThue` decimal(18,2) NULL,
    `HoaDon_TgTienThue` decimal(18,2) NULL,
    `HoaDon_ThueSuat` int NULL,
    `HDLienQuan_Loai` int NULL,
    `HDLienQuan_MauSo` varchar(255) NULL,
    `HDLienQuan_KyHieu` varchar(255) NULL,
    `HDLienQuan_So` varchar(255) NULL,
    `TCT_ThongBao_So` varchar(255) NULL,
    `TCT_ThongBaoNgay` datetime NULL,
    `DoanhNghiep_MST` varchar(255) NULL,
    `TenantId` int NULL
);
