-- Table: vs_nguoidung_thongtin
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/ThongTinNguoiDung/NguoiDung_ThongTin.cs
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
--   UserId int NOT NULL -- C# int
--   TenantId int NULL -- C# int?
--   DoanhNghiep_MST varchar(255) NULL -- C# string
--   NguoiDung_Ten varchar(255) NULL -- C# string
--   NguoiDung_ChucVu varchar(255) NULL -- C# string
--   NguoiDung_DiaChi varchar(255) NULL -- C# string
--   NguoiDung_AnhDaiDien varchar(255) NULL -- C# string
--   NguoiDung_SDT varchar(255) NULL -- C# string
--   NguoiDung_Email varchar(255) NULL -- C# string
--   NguoiDung_GioiTinh int NOT NULL -- C# int
--   NguoiDung_NgaySinh datetime NULL -- C# DateTime?
--   NguoiDung_Loai int NULL -- C# int?
--   NguoiDung_Tenant varchar(255) NULL -- C# string
--   DaiLy_Ma varchar(255) NULL -- C# string
--   DaiLy_Id int NULL -- C# int?
--   IsCustomer bit NULL -- C# bool?

CREATE TABLE `vs_nguoidung_thongtin` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `UserId` int NOT NULL,
    `TenantId` int NULL,
    `DoanhNghiep_MST` varchar(255) NULL,
    `NguoiDung_Ten` varchar(255) NULL,
    `NguoiDung_ChucVu` varchar(255) NULL,
    `NguoiDung_DiaChi` varchar(255) NULL,
    `NguoiDung_AnhDaiDien` varchar(255) NULL,
    `NguoiDung_SDT` varchar(255) NULL,
    `NguoiDung_Email` varchar(255) NULL,
    `NguoiDung_GioiTinh` int NOT NULL,
    `NguoiDung_NgaySinh` datetime NULL,
    `NguoiDung_Loai` int NULL,
    `NguoiDung_Tenant` varchar(255) NULL,
    `DaiLy_Ma` varchar(255) NULL,
    `DaiLy_Id` int NULL,
    `IsCustomer` bit NULL
);
