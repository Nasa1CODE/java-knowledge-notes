-- Table: vs_doanhnghiep_nhatkyhoadon
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/QuanLy/DoanhNghiep_NhatKyHoaDon.cs
--
-- Fields inferred from C# entity properties. Verify exact SQL types, lengths, indexes, and constraints against real migrations/schema before deployment.
-- Fields:
--   Id int NOT NULL -- inherited Entity key
--   DoanhNghiep_MST varchar(255) NULL -- C# string
--   NhatKy_NguoiThucHien varchar(255) NULL -- C# string
--   NhatKy_ThoiGian datetime NOT NULL -- C# DateTime
--   NhatKy_HanhDong varchar(255) NULL -- C# string
--   NhatKy_MoTa varchar(255) NULL -- C# string
--   TenantId int NULL -- C# int?
--   TongHop_Id int NOT NULL -- C# int

CREATE TABLE `vs_doanhnghiep_nhatkyhoadon` (
    `Id` int NOT NULL,
    `DoanhNghiep_MST` varchar(255) NULL,
    `NhatKy_NguoiThucHien` varchar(255) NULL,
    `NhatKy_ThoiGian` datetime NOT NULL,
    `NhatKy_HanhDong` varchar(255) NULL,
    `NhatKy_MoTa` varchar(255) NULL,
    `TenantId` int NULL,
    `TongHop_Id` int NOT NULL
);
