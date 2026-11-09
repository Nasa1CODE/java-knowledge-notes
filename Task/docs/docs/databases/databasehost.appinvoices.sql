-- Table: appinvoices
-- Database scope: host
-- Source: BE/aspnet-core/src/zero/VS.Core/MultiTenancy/Accounting/Invoice.cs
--
-- Fields inferred from C# entity properties. Verify exact SQL types, lengths, indexes, and constraints against real migrations/schema before deployment.
-- Fields:
--   Id int NOT NULL -- inherited Entity key
--   InvoiceNo varchar(255) NULL -- C# string
--   InvoiceDate datetime NOT NULL -- C# DateTime
--   TenantLegalName varchar(255) NULL -- C# string
--   TenantAddress varchar(255) NULL -- C# string
--   TenantTaxNo varchar(255) NULL -- C# string

CREATE TABLE `appinvoices` (
    `Id` int NOT NULL,
    `InvoiceNo` varchar(255) NULL,
    `InvoiceDate` datetime NOT NULL,
    `TenantLegalName` varchar(255) NULL,
    `TenantAddress` varchar(255) NULL,
    `TenantTaxNo` varchar(255) NULL
);
