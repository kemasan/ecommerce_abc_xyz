-- 01_import_and_clean.sql
-- Purpose:
--   1) Load the Excel file safely (all_varchar=true to avoid type parse failures)
--   2) Cast fields + convert Excel serial date to a timestamp
--   3) Flag cancellations + compute line revenue

INSTALL excel;
LOAD excel;

DROP TABLE IF EXISTS retail_raw;
CREATE TABLE retail_raw AS
SELECT *
FROM read_xlsx('Online Retail.xlsx', all_varchar = true);

DROP TABLE IF EXISTS retail_clean;
CREATE TABLE retail_clean AS
SELECT
  InvoiceNo,
  StockCode,
  NULLIF(TRIM(Description), '') AS Description,
  TRY_CAST(Quantity AS INTEGER) AS Quantity,

  -- Excel serial date -> timestamp (Windows Excel base: 1899-12-30)
  CASE
    WHEN TRY_CAST(InvoiceDate AS DOUBLE) IS NULL THEN NULL
    ELSE TIMESTAMP '1899-12-30'
      + (TRY_CAST(InvoiceDate AS DOUBLE) * INTERVAL '1' DAY)
  END AS InvoiceTS,

  TRY_CAST(UnitPrice AS DOUBLE) AS UnitPrice,
  TRY_CAST(CustomerID AS BIGINT) AS CustomerID,
  NULLIF(TRIM(Country), '') AS Country,

  (LEFT(InvoiceNo, 1) = 'C') AS is_cancellation,

  -- raw transaction value (will be negative for returns)
  TRY_CAST(Quantity AS INTEGER) * TRY_CAST(UnitPrice AS DOUBLE) AS line_revenue
FROM retail_raw
WHERE
  TRY_CAST(Quantity AS INTEGER) IS NOT NULL
  AND TRY_CAST(UnitPrice AS DOUBLE) IS NOT NULL
  AND TRY_CAST(InvoiceDate AS DOUBLE) IS NOT NULL;
