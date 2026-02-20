-- QA_checks.sql
-- Run after each stage.

-- retail_raw coverage
SELECT
  COUNT(*) AS rows,
  SUM(CASE WHEN InvoiceNo IS NULL OR TRIM(InvoiceNo)='' THEN 1 ELSE 0 END) AS null_invoiceno,
  SUM(CASE WHEN StockCode IS NULL OR TRIM(StockCode)='' THEN 1 ELSE 0 END) AS null_stockcode,
  SUM(CASE WHEN InvoiceDate IS NULL OR TRIM(InvoiceDate)='' THEN 1 ELSE 0 END) AS null_invoicedate
FROM retail_raw;

-- retail_clean sanity
SELECT COUNT(*) AS rows FROM retail_clean;

SELECT MIN(InvoiceTS) AS min_ts, MAX(InvoiceTS) AS max_ts
FROM retail_clean;

SELECT
  SUM(CASE WHEN is_cancellation THEN 1 ELSE 0 END) AS cancel_rows,
  SUM(CASE WHEN Quantity < 0 THEN 1 ELSE 0 END) AS negative_qty_rows,
  SUM(CASE WHEN Quantity = 0 THEN 1 ELSE 0 END) AS zero_qty_rows
FROM retail_clean;

SELECT
  SUM(line_revenue) AS total_line_revenue,
  MIN(line_revenue) AS min_line_rev,
  MAX(line_revenue) AS max_line_rev
FROM retail_clean;

-- retail_net sanity
SELECT COUNT(*) AS rows FROM retail_net;

SELECT
  SUM(net_revenue) AS net_revenue_total,
  SUM(CASE WHEN is_return THEN 1 ELSE 0 END) AS return_rows,
  SUM(CASE WHEN net_revenue < 0 THEN 1 ELSE 0 END) AS negative_revenue_rows
FROM retail_net;

-- service SKUs totals (proof for exclusion)
SELECT StockCode,
       COUNT(*) AS rows,
       SUM(net_revenue) AS revenue
FROM retail_net
WHERE StockCode IN ('DOT','POST','M','D','BANK CHARGES','AMAZONFEE','CRUK','S')
GROUP BY 1
ORDER BY revenue DESC;

-- product_monthly sanity
SELECT MIN(month) AS min_month, MAX(month) AS max_month, COUNT(DISTINCT month) AS months
FROM product_monthly;

SELECT StockCode, month, COUNT(*) AS n
FROM product_monthly
GROUP BY 1,2
HAVING COUNT(*) > 1
ORDER BY n DESC
LIMIT 20;

-- product_revenue_abc sanity
SELECT
  COUNT(*) AS rows,
  COUNT(DISTINCT StockCode) AS distinct_skus
FROM product_revenue_abc;

SELECT
  SUM(CASE WHEN revenue_total <= 0 THEN 1 ELSE 0 END) AS non_positive_skus,
  MIN(revenue_total) AS min_rev,
  MAX(revenue_total) AS max_rev
FROM product_revenue_abc;

-- abc_class monotonicity
SELECT COUNT(*) AS bad_rows
FROM (
  SELECT
    revenue_cum_pct,
    LAG(revenue_cum_pct) OVER (ORDER BY revenue_total DESC) AS prev
  FROM abc_class
)
WHERE prev IS NOT NULL AND revenue_cum_pct < prev;

-- A-share should be ~80%
SELECT
  SUM(revenue_total) FILTER (WHERE abc='A') / SUM(revenue_total) AS a_share
FROM abc_class;

-- xyz_stats missing stddev (often months_observed=1)
SELECT
  COUNT(*) AS skus,
  SUM(CASE WHEN avg_monthly_units IS NULL THEN 1 ELSE 0 END) AS null_avg,
  SUM(CASE WHEN sd_monthly_units IS NULL THEN 1 ELSE 0 END) AS null_sd
FROM xyz_stats;

-- final segment distribution
SELECT
  abc_xyz_segment,
  COUNT(*) AS skus,
  SUM(revenue_total) AS revenue
FROM abc_xyz
GROUP BY 1
ORDER BY revenue DESC;
