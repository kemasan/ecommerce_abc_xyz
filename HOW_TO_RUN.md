# How to run (DuckDB CLI)

From your project folder:

```bash
duckdb retail.duckdb
```

Then run files in order:

```sql
.read sql/01_import_and_clean.sql
.read sql/02_net_sales_layer.sql
.read sql/03_abc_analysis.sql
.read sql/04_xyz_analysis.sql
.read sql/05_abc_xyz_join_and_exports.sql
-- optional
.read sql/QA_checks.sql
```

After exports, connect Tableau Public to:
- `abc_xyz_final.csv` (main)
- `abc_curve.csv` (Pareto curve helper)
- `abc_xyz_summary.csv` (segment KPIs)
