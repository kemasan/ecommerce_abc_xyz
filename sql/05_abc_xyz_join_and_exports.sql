-- 05_abc_xyz_join_and_exports.sql
-- Purpose:
--   Join ABC + XYZ into a single table for BI.
--   Add segment label (AX/AY/...) and export CSVs for Tableau.

DROP TABLE IF EXISTS abc_xyz;
CREATE TABLE abc_xyz AS
SELECT
  a.StockCode,
  a.Description,
  a.revenue_total,
  a.revenue_cum_pct,
  a.abc,
  x.avg_monthly_units,
  x.months_observed,
  x.cv_units,
  x.xyz,
  a.abc || COALESCE(x.xyz, 'Z') AS abc_xyz_segment,
  TRUE AS include_in_pareto,
  CASE WHEN x.StockCode IS NOT NULL THEN TRUE ELSE FALSE END AS include_in_xyz
FROM abc_class a
LEFT JOIN xyz_class x
  ON a.StockCode = x.StockCode;

COPY abc_xyz TO 'abc_xyz_final.csv' (HEADER, DELIMITER ',');
COPY abc_curve TO 'abc_curve.csv' (HEADER, DELIMITER ',');
COPY (
  SELECT
    abc_xyz_segment,
    COUNT(*) AS skus,
    SUM(revenue_total) AS revenue
  FROM abc_xyz
  GROUP BY 1
) TO 'abc_xyz_summary.csv' WITH (HEADER, DELIMITER ',');
