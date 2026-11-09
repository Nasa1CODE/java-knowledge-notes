# Invoicecore Vehicle Asset Detail Design

## Scope

Extend `invoicecore/aspnet-core` invoice-detail extension data in `vs_hd_chitiet_morong`. The change is limited to the domain entity, API DTO, Dapper persistence SQL, and a deployable database script. It does not change UI, Excel import/export, or XML generation.

## Data Model

Add these nullable properties using the exact SQL column names in both `HD_ChiTiet_MoRong` and `HD_ChiTiet_MoRongDto`:

| Column / Property | Type |
| --- | --- |
| `ltsan` | `int?` |
| `tttsan` | `int?` |
| `xxu` | `int?` |
| `sgcnatkthuat` | `string` |
| `sspktcclxxuong` | `string` |
| `mnsxuat` | `string` |
| `tltsdky` | `string` |
| `nsxuat` | `int?` |
| `ttmai` | `string` |
| `tnhieu` | `string` |
| `klxe` | `string` |
| `ttlvhcs` | `string` |
| `ttai` | `decimal?` |
| `scngoi` | `int?` |
| `cltsan` | `int?` |
| `sbksoat` | `string` |

`ttai` is nullable, as confirmed, to support existing rows without a backfill. Entity Framework maps the exact property names to the same column names by convention. The existing AutoMapper reverse mapping carries these properties between the entity and DTO.

## Persistence

Update Dapper `Add`, `AddRange`, and `Update` statements in `HD_ChiTiet_MoRongRepository` so all new values are persisted in Dapper-based invoice flows.

Provide an idempotence-neutral deployment SQL script using `ALTER TABLE vs_hd_chitiet_morong ADD COLUMN ...`, with the requested comments and `ttai decimal(10,2) NULL`.

## Verification

Build `VS.Web.sln` to catch entity, DTO, mapper, and Dapper parameter compile errors. Review the generated SQL lists to verify every added entity property is included in all three Dapper write paths.
