-- Table: vs_dashboard_dn_gannhat
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/Dashboard/Dashboard_DN_GanNhat.cs
--
-- Fields inferred from C# entity properties. Verify exact SQL types, lengths, indexes, and constraints against real migrations/schema before deployment.
-- Fields:
--   Id int NOT NULL -- inherited Entity key
--   DoanhNghiep_Mst varchar(255) NULL -- C# string
--   Loai int NOT NULL -- C# int
--   HoaDonGoc int NOT NULL -- C# int
--   TongHoaDon int NOT NULL -- C# int
--   ThayThe int NOT NULL -- C# int
--   DieuChinh int NOT NULL -- C# int
--   HetHieuLuc int NOT NULL -- C# int
--   NgayKy varchar(255) NULL -- C# string
--   CreationTime datetime NOT NULL -- C# DateTime

CREATE TABLE `vs_dashboard_dn_gannhat` (
    `Id` int NOT NULL,
    `DoanhNghiep_Mst` varchar(255) NULL,
    `Loai` int NOT NULL,
    `HoaDonGoc` int NOT NULL,
    `TongHoaDon` int NOT NULL,
    `ThayThe` int NOT NULL,
    `DieuChinh` int NOT NULL,
    `HetHieuLuc` int NOT NULL,
    `NgayKy` varchar(255) NULL,
    `CreationTime` datetime NOT NULL
);
