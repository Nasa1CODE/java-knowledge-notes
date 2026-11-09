-- Table: appsubscriptionpayments
-- Database scope: host
-- Source: BE/aspnet-core/src/zero/VS.Core/MultiTenancy/Payments/SubscriptionPayment.cs
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
--   Gateway text NOT NULL -- C# SubscriptionPaymentGatewayType
--   Amount decimal(18,2) NOT NULL -- C# decimal
--   Status text NOT NULL -- C# SubscriptionPaymentStatus
--   EditionId int NOT NULL -- C# int
--   TenantId int NOT NULL -- C# int
--   DayCount int NOT NULL -- C# int
--   PaymentPeriodType text NULL -- C# PaymentPeriodType?
--   PaymentId varchar(255) NULL -- C# string
--   Edition text NOT NULL -- C# Edition
--   InvoiceNo varchar(255) NULL -- C# string

CREATE TABLE `appsubscriptionpayments` (
    `Id` int NOT NULL,
    `CreationTime` datetime NOT NULL,
    `CreatorUserId` bigint NULL,
    `LastModificationTime` datetime NULL,
    `LastModifierUserId` bigint NULL,
    `IsDeleted` bit NOT NULL,
    `DeleterUserId` bigint NULL,
    `DeletionTime` datetime NULL,
    `Gateway` text NOT NULL,
    `Amount` decimal(18,2) NOT NULL,
    `Status` text NOT NULL,
    `EditionId` int NOT NULL,
    `TenantId` int NOT NULL,
    `DayCount` int NOT NULL,
    `PaymentPeriodType` text NULL,
    `PaymentId` varchar(255) NULL,
    `Edition` text NOT NULL,
    `InvoiceNo` varchar(255) NULL
);
