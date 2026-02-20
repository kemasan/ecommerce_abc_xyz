-- 03_abc_analysis.sql
-- Purpose:
--   ABC = revenue concentration (Pareto).
--   We compute total *positive* revenue per SKU for ABC ranking (sales-only).

CREATE OR REPLACE TABLE product_revenue_abc AS
SELECT
  StockCode,
  MIN(Description) AS Description,
  SUM(CASE WHEN net_revenue > 0 THEN net_revenue ELSE 0 END) AS revenue_total
FROM retail_net
WHERE StockCode NOT IN ('DOT','POST','M','D','BANK CHARGES','AMAZONFEE','CRUK','S')
GROUP BY 1;

CREATE OR REPLACE TABLE abc_class AS
SELECT
  StockCode,
  Description,
  revenue_total,
  SUM(revenue_total) OVER (ORDER BY revenue_total DESC)
    / NULLIF(SUM(revenue_total) OVER (), 0) AS revenue_cum_pct,
  CASE
    WHEN SUM(revenue_total) OVER (ORDER BY revenue_total DESC)
         / NULLIF(SUM(revenue_total) OVER (),0) <= 0.80 THEN 'A'
    WHEN SUM(revenue_total) OVER (ORDER BY revenue_total DESC)
         / NULLIF(SUM(revenue_total) OVER (),0) <= 0.95 THEN 'B'
    ELSE 'C'
  END AS abc
FROM product_revenue_abc
WHERE revenue_total > 0
ORDER BY revenue_total DESC;

DROP TABLE IF EXISTS abc_curve;
CREATE TABLE abc_curve AS
SELECT
  StockCode,
  revenue_total,
  SUM(revenue_total) OVER (ORDER BY revenue_total DESC)
      / SUM(revenue_total) OVER () AS cumulative_share,
  ROW_NUMBER() OVER (ORDER BY revenue_total DESC) AS sku_rank
FROM abc_class
ORDER BY revenue_total DESC;
