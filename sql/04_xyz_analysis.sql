-- 04_xyz_analysis.sql
-- Purpose:
--   XYZ = demand stability (variability of monthly demand).
--   We use ABS(net_units) so returns don't invert the demand signal.
--   CV = sd / avg; higher CV = less stable.

DROP TABLE IF EXISTS xyz_stats;
CREATE TABLE xyz_stats AS
SELECT
  StockCode,
  AVG(ABS(net_units)) AS avg_monthly_units,
  STDDEV_SAMP(ABS(net_units)) AS sd_monthly_units,
  COUNT(*) AS months_observed
FROM product_monthly
WHERE StockCode NOT IN ('DOT','POST','M','D','BANK CHARGES','AMAZONFEE','CRUK','S')
GROUP BY 1;

DROP TABLE IF EXISTS xyz_class;
CREATE TABLE xyz_class AS
SELECT
  StockCode,
  avg_monthly_units,
  sd_monthly_units,
  sd_monthly_units / NULLIF(avg_monthly_units,0) AS cv_units,
  months_observed,
  CASE
    WHEN avg_monthly_units IS NULL OR avg_monthly_units = 0 THEN 'Z'
    WHEN (sd_monthly_units / NULLIF(avg_monthly_units,0)) <= 0.50 THEN 'X'
    WHEN (sd_monthly_units / NULLIF(avg_monthly_units,0)) <= 1.00 THEN 'Y'
    ELSE 'Z'
  END AS xyz
FROM xyz_stats;
