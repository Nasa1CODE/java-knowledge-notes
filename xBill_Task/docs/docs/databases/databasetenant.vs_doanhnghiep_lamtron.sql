-- Table: vs_doanhnghiep_lamtron
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/CauHinh/DoanhNghiep_LamTron.cs
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
--   DoanhNghiep_MST varchar(255) NULL -- C# string
--   TenantId int NULL -- C# int?
--   MaTienTe varchar(255) NULL -- C# string
--   SoLuong int NULL -- C# int?
--   DonGia int NULL -- C# int?
--   TiLe_ChietKhau int NULL -- C# int?
--   ChietKhau int NULL -- C# int?
--   ThanhTien int NULL -- C# int?
--   TienThue int NULL -- C# int?
--   TongTienThue int NULL -- C# int?
--   PhiKhac int NULL -- C# int?
--   TongTienHang int NULL -- C# int?
--   TongTienChietKhauThuongMai int NULL -- C# int?
--   TongTienThanhToan int NULL -- C# int?

CREATE TABLE `vs_doanhnghiep_lamtron` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `DoanhNghiep_MST` varchar(255) NULL,
    `TenantId` int NULL,
    `MaTienTe` varchar(255) NULL,
    `SoLuong` int NULL,
    `DonGia` int NULL,
    `TiLe_ChietKhau` int NULL,
    `ChietKhau` int NULL,
    `ThanhTien` int NULL,
    `TienThue` int NULL,
    `TongTienThue` int NULL,
    `PhiKhac` int NULL,
    `TongTienHang` int NULL,
    `TongTienChietKhauThuongMai` int NULL,
    `TongTienThanhToan` int NULL
);
