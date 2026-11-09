-- Table: vs_dm_ncc_loaictdt
-- Database scope: host (theo plan CBCLOUDV2-9129; DBA/TechLead cần xác nhận trước deploy)
-- Source: invoicemanagement/aspnet-core/src/hddt/HDDT.Core/Domains/DanhMuc/DMNhaCungCap/DM_NCC_LoaiCTDT.cs
-- Không chứa secrets/connection string thật. Không dùng EF migration cho bảng vs_*.

CREATE TABLE IF NOT EXISTS `vs_dm_ncc_loaictdt` (
    `Id` int NOT NULL AUTO_INCREMENT,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL DEFAULT b'0',
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `LoaiCTDT_Ma` varchar(200) NOT NULL,
    `LoaiCTDT_MoTa` varchar(1500) NOT NULL,
    `LoaiCTDT_BatDau` datetime NULL,
    `LoaiCTDT_KetThuc` datetime NULL,
    `LoaiCTDT_HieuLuc` int NULL DEFAULT 1,
    PRIMARY KEY (`Id`),
    KEY `IX_vs_dm_ncc_loaictdt_IsDeleted` (`IsDeleted`),
    KEY `IX_vs_dm_ncc_loaictdt_Ma` (`LoaiCTDT_Ma`)
);

INSERT INTO `vs_dm_ncc_loaictdt`
    (`CreationTime`, `IsDeleted`, `LoaiCTDT_Ma`, `LoaiCTDT_MoTa`, `LoaiCTDT_HieuLuc`)
SELECT NOW(), b'0', '1', 'Chứng từ điện tử khấu trừ thuế TNCN theo Nghị định 70/2025/NĐ-CP', 1
WHERE NOT EXISTS (SELECT 1 FROM `vs_dm_ncc_loaictdt` WHERE `LoaiCTDT_Ma` = '1' AND `IsDeleted` = b'0');

INSERT INTO `vs_dm_ncc_loaictdt`
    (`CreationTime`, `IsDeleted`, `LoaiCTDT_Ma`, `LoaiCTDT_MoTa`, `LoaiCTDT_HieuLuc`)
SELECT NOW(), b'0', '2', 'Biên lai thu thuế, phí, lệ phí theo Nghị định 254/2026/NĐ-CP, Nghị định 347/2025/NĐ-CP', 1
WHERE NOT EXISTS (SELECT 1 FROM `vs_dm_ncc_loaictdt` WHERE `LoaiCTDT_Ma` = '2' AND `IsDeleted` = b'0');

INSERT INTO `vs_dm_ncc_loaictdt`
    (`CreationTime`, `IsDeleted`, `LoaiCTDT_Ma`, `LoaiCTDT_MoTa`, `LoaiCTDT_HieuLuc`)
SELECT NOW(), b'0', '3', 'Biên lai thu thuế, phí, lệ phí không in sẵn mệnh giá theo Nghị định 70/2025/NĐ-CP', 1
WHERE NOT EXISTS (SELECT 1 FROM `vs_dm_ncc_loaictdt` WHERE `LoaiCTDT_Ma` = '3' AND `IsDeleted` = b'0');

INSERT INTO `vs_dm_ncc_loaictdt`
    (`CreationTime`, `IsDeleted`, `LoaiCTDT_Ma`, `LoaiCTDT_MoTa`, `LoaiCTDT_HieuLuc`)
SELECT NOW(), b'0', '4', 'Biên lai thu thuế, phí, lệ phí in sẵn mệnh giá theo Nghị định 70/2025/NĐ-CP', 1
WHERE NOT EXISTS (SELECT 1 FROM `vs_dm_ncc_loaictdt` WHERE `LoaiCTDT_Ma` = '4' AND `IsDeleted` = b'0');

INSERT INTO `vs_dm_ncc_loaictdt`
    (`CreationTime`, `IsDeleted`, `LoaiCTDT_Ma`, `LoaiCTDT_MoTa`, `LoaiCTDT_HieuLuc`)
SELECT NOW(), b'0', 'CTT50', 'Biên lai thu thuế, phí, lệ phí của cơ quan thuế sử dụng khi thu thuế, phí, lệ phí của cá nhân', 1
WHERE NOT EXISTS (SELECT 1 FROM `vs_dm_ncc_loaictdt` WHERE `LoaiCTDT_Ma` = 'CTT50' AND `IsDeleted` = b'0');

INSERT INTO `vs_dm_ncc_loaictdt`
    (`CreationTime`, `IsDeleted`, `LoaiCTDT_Ma`, `LoaiCTDT_MoTa`, `LoaiCTDT_HieuLuc`)
SELECT NOW(), b'0', '6', 'Biên lai thu thuế, phí, lệ phí đặt in, tự in, điện tử theo Thông tư 303/2016/TT-BTC, Nghị định 51/2010/NĐ- CP', 1
WHERE NOT EXISTS (SELECT 1 FROM `vs_dm_ncc_loaictdt` WHERE `LoaiCTDT_Ma` = '6' AND `IsDeleted` = b'0');

INSERT INTO `vs_dm_ncc_loaictdt`
    (`CreationTime`, `IsDeleted`, `LoaiCTDT_Ma`, `LoaiCTDT_MoTa`, `LoaiCTDT_HieuLuc`)
SELECT NOW(), b'0', '7', 'Chứng từ khấu trừ thuế TNCN theo Nghị định 123/2020/NĐ-CP', 1
WHERE NOT EXISTS (SELECT 1 FROM `vs_dm_ncc_loaictdt` WHERE `LoaiCTDT_Ma` = '7' AND `IsDeleted` = b'0');

INSERT INTO `vs_dm_ncc_loaictdt`
    (`CreationTime`, `IsDeleted`, `LoaiCTDT_Ma`, `LoaiCTDT_MoTa`, `LoaiCTDT_HieuLuc`)
SELECT NOW(), b'0', '8', 'Chứng từ khấu trừ thuế TNCN theo Nghị định 254/2026/NĐ-CP', 1
WHERE NOT EXISTS (SELECT 1 FROM `vs_dm_ncc_loaictdt` WHERE `LoaiCTDT_Ma` = '8' AND `IsDeleted` = b'0');

-- Rollback seed (chỉ chạy khi xác nhận chưa có dữ liệu thật phụ thuộc seed):
-- DELETE FROM `vs_dm_ncc_loaictdt`
-- WHERE `LoaiCTDT_Ma` IN ('1', '2', '3', '4', 'CTT50', '6', '7', '8')
--   AND `IsDeleted` = b'0';

-- Rollback schema (chỉ drop khi bảng do ticket tạo mới và chưa phát sinh dữ liệu thật):
-- DROP TABLE IF EXISTS `vs_dm_ncc_loaictdt`;
