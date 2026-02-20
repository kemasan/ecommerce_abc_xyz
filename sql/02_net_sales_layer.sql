-- 02_net_sales_layer.sql
-- Purpose:
--   Create a business-valid layer for analysis:
--   - Keep returns/cancellations as negative values (net view)
--   - Add month grain for time-series aggregation

DROP TABLE IF EXISTS retail_net;
CREATE TABLE retail_net AS
SELECT
  InvoiceNo,
  StockCode,
  Description,
  CustomerID,
  Country,
  InvoiceTS,
  DATE_TRUNC('month', InvoiceTS)::DATE AS month,
  Quantity,
  UnitPrice,

  -- Net revenue keeps sign (returns stay negative)
  (Quantity * UnitPrice) AS net_revenue,

  CASE
    WHEN is_cancellation OR Quantity < 0 THEN TRUE
    ELSE FALSE
  END AS is_return
FROM retail_clean
WHERE
  StockCode IS NOT NULL
  AND StockCode <> ''
  AND Quantity <> 0
  AND UnitPrice >= 0;

DROP TABLE IF EXISTS product_monthly;
CREATE TABLE product_monthly AS
SELECT
  StockCode,
  MIN(Description) AS Description,
  month,
  SUM(Quantity) AS net_units,
  SUM(net_revenue) AS net_revenue
FROM retail_net
GROUP BY 1,3;
