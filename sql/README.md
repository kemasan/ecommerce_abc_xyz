# E‑Commerce ABC‑XYZ Inventory Segmentation (DuckDB + Tableau)

Dataset: **Online Retail** (commonly shared on Kaggle / UCI).  
Goal: build a reproducible pipeline from raw transactions → clean net sales → ABC revenue classes → XYZ demand stability → ABC‑XYZ segments for inventory decisions and portfolio storytelling.

## Business Question
**Which products drive most revenue, and how stable is their demand over time?**  
So we can prioritize:
- **A items** (high revenue) for tight availability + monitoring
- **X items** (stable demand) for predictable replenishment
- **Z items** (volatile/irregular) for cautious stocking and review

## What you built (outputs)
### Core tables
- `retail_raw` — raw import from Excel (all columns as VARCHAR)
- `retail_clean` — typed fields + timestamp normalization + cancellation flag
- `retail_net` — “business layer”: net revenue (returns kept negative), month column
- `product_monthly` — product × month net units + net revenue
- `product_revenue_abc` — per‑SKU total **positive** revenue (sales only) for ABC
- `abc_class` — ABC class + Pareto cumulative share
- `xyz_stats` — per‑SKU demand stats (avg, stddev, months observed)
- `xyz_class` — XYZ class based on coefficient of variation (CV)
- `abc_xyz` — joined ABC + XYZ with final segment label

### Files exported for Tableau
- `abc_xyz_final.csv` — main dataset for dashboards
- `abc_curve.csv` — simplified dataset for Pareto curve
- `abc_xyz_summary.csv` — segment totals (nice KPI / table)

## Key Metrics
### Activity
- **Net Units (monthly)**: `net_units` in `product_monthly`
- **Months Observed**: how much history a SKU has (helps trust XYZ)

### Profitability
- **Revenue Total (sales-only)**: `revenue_total` in `product_revenue_abc`
- **Pareto cumulative share**: `revenue_cum_pct` in `abc_class`

### Risk / Stability
- **CV (Coefficient of Variation)**: `cv_units = sd / avg` (higher = less stable)
- **XYZ**:
  - X: CV ≤ 0.50 (stable)
  - Y: 0.50 < CV ≤ 1.00 (medium)
  - Z: CV > 1.00 or insufficient history / no demand

## Important assumptions (and why)
1) **Returns / cancellations exist**  
They are real in retail. We keep them in `retail_net` as negative revenue to reflect net performance.

2) **ABC uses sales-only revenue**  
ABC is about “what makes money”. Using sales-only (positive revenue) avoids returns dominating the ranking.

3) **XYZ uses absolute net units**  
We measure demand variability in **magnitude**, not sign. Returns don’t define demand stability.

4) **Service / fee SKUs are excluded from segmentation**  
Examples: `DOT`, `POST`, `AMAZONFEE`, `BANK CHARGES`, etc.

## Tableau views (storytelling dashboard)
Recommended for Tableau Public:
1) **Pareto chart (ABC)**  
Bars: revenue by SKU rank. Line: cumulative revenue share. Reference line at 80% and 95%.

2) **ABC distribution bar**  
Count of SKUs by A/B/C + revenue share by class.

3) **XYZ stability scatter-style**  
X-axis: `avg_monthly_units`, Y-axis: `cv_units`, color by `xyz`, filter `include_in_xyz`.

4) **ABC‑XYZ matrix**  
Rows: ABC, Columns: XYZ, color by revenue (or count), label counts.

## SQL files
- [`sql/01_import_and_clean.sql`](sql/01_import_and_clean.sql)
- [`sql/02_net_sales_layer.sql`](sql/02_net_sales_layer.sql)
- [`sql/03_abc_analysis.sql`](sql/03_abc_analysis.sql)
- [`sql/04_xyz_analysis.sql`](sql/04_xyz_analysis.sql)
- [`sql/05_abc_xyz_join_and_exports.sql`](sql/05_abc_xyz_join_and_exports.sql)
- [`sql/QA_checks.sql`](sql/QA_checks.sql)

---

## Notes on “negative revenue” you saw in Tableau
- It’s expected in **net** layers (returns/cancellations).
- Your **ABC ranking table** filters to `revenue_total > 0`, so Pareto/ABC are not broken.
- If you want a “returns‑risk” view later, add a second metric: `revenue_total_net` (sales + returns).
