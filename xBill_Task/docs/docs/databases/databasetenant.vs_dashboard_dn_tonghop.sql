-- Table: vs_dashboard_dn_tonghop
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/Dashboard/Dashboard_DN_TongHop.cs
--
-- Fields inferred from C# entity properties. Verify exact SQL types, lengths, indexes, and constraints against real migrations/schema before deployment.
-- Fields:
--   Id int NOT NULL -- inherited Entity key
--   DoanhNghiep_Mst varchar(255) NULL -- C# string
--   HoaDonGoc int NOT NULL -- C# int
--   HoaDonGoc_Tien decimal(18,2) NOT NULL -- C# decimal
--   HoaDonThayThe int NOT NULL -- C# int
--   HoaDonThayThe_Tien decimal(18,2) NOT NULL -- C# decimal
--   HoaDonDieuChinh int NOT NULL -- C# int
--   HoaDonDieuChinh_Tien decimal(18,2) NOT NULL -- C# decimal
--   HoaDonHetHieuLuc int NOT NULL -- C# int
--   HoaDonHetHieuLuc_Tien decimal(18,2) NOT NULL -- C# decimal
--   ThangKy varchar(255) NULL -- C# string
--   CreationTime datetime NOT NULL -- C# DateTime

CREATE TABLE `vs_dashboard_dn_tonghop` (
    `Id` int NOT NULL,
    `DoanhNghiep_Mst` varchar(255) NULL,
    `HoaDonGoc` int NOT NULL,
    `HoaDonGoc_Tien` decimal(18,2) NOT NULL,
    `HoaDonThayThe` int NOT NULL,
    `HoaDonThayThe_Tien` decimal(18,2) NOT NULL,
    `HoaDonDieuChinh` int NOT NULL,
    `HoaDonDieuChinh_Tien` decimal(18,2) NOT NULL,
    `HoaDonHetHieuLuc` int NOT NULL,
    `HoaDonHetHieuLuc_Tien` decimal(18,2) NOT NULL,
    `ThangKy` varchar(255) NULL,
    `CreationTime` datetime NOT NULL
);
