-- Table: vs_service_sendmail
-- Database scope: tenant
-- Source: BE/aspnet-core/src/hddt/HDDT.Core/Domains/Services/Service_SendMail.cs
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
--   NguoiGui_TaiKhoan varchar(255) NULL -- C# string
--   NguoiGui_MatKhau varchar(255) NULL -- C# string
--   NguoiGui_Port varchar(255) NULL -- C# string
--   NguoiGui_SSL bit NOT NULL -- C# bool
--   NguoiNhan_Email varchar(255) NULL -- C# string
--   NguoiGui_Smtp varchar(255) NULL -- C# string
--   NguoiGui_From varchar(255) NULL -- C# string
--   NguoiGui_Name varchar(255) NULL -- C# string
--   Email_TieuDe varchar(255) NULL -- C# string
--   Email_NoiDung varchar(255) NULL -- C# string
--   Email_MauId int NOT NULL -- C# int
--   File_DinhKem varchar(255) NULL -- C# string
--   File_TheHien varchar(255) NULL -- C# string
--   TrangThaiGui int NOT NULL -- C# int
--   NgayGui datetime NULL -- C# DateTime?
--   HoaDon_Id int NULL -- C# int?
--   ChungTu_Id int NULL -- C# int?
--   DoanhNghiep_MST varchar(255) NULL -- C# string
--   TenantId int NULL -- C# int?
--   HoaDon text NOT NULL -- C# HD_HoaDon
--   Type int NULL -- C# int?

CREATE TABLE `vs_service_sendmail` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `NguoiGui_TaiKhoan` varchar(255) NULL,
    `NguoiGui_MatKhau` varchar(255) NULL,
    `NguoiGui_Port` varchar(255) NULL,
    `NguoiGui_SSL` bit NOT NULL,
    `NguoiNhan_Email` varchar(255) NULL,
    `NguoiGui_Smtp` varchar(255) NULL,
    `NguoiGui_From` varchar(255) NULL,
    `NguoiGui_Name` varchar(255) NULL,
    `Email_TieuDe` varchar(255) NULL,
    `Email_NoiDung` varchar(255) NULL,
    `Email_MauId` int NOT NULL,
    `File_DinhKem` varchar(255) NULL,
    `File_TheHien` varchar(255) NULL,
    `TrangThaiGui` int NOT NULL,
    `NgayGui` datetime NULL,
    `HoaDon_Id` int NULL,
    `ChungTu_Id` int NULL,
    `DoanhNghiep_MST` varchar(255) NULL,
    `TenantId` int NULL,
    `HoaDon` text NOT NULL,
    `Type` int NULL
);
