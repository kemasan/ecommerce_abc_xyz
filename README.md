# 📦 E-Commerce Inventory Optimization: ABC–XYZ Analysis

## 🎯 Business Question
**"How can we identify which products deserve the most operational attention based on revenue impact and demand stability?"**

In large e-commerce catalogs, most revenue is driven by a small subset of products, while many SKUs exhibit irregular demand and high return rates.

This project builds an end-to-end analytical pipeline to:

- Identify high-impact products (ABC analysis)
- Measure demand stability (XYZ analysis)
- Combine both dimensions into actionable inventory segments
- Support data-driven stocking and procurement decisions

Dataset source: Kaggle – Online Retail Dataset.

---

## 📊 Methodology

### 1️⃣ Data Engineering & Cleaning
Raw transactional data was imported into DuckDB and cleaned by:

- Converting Excel serial dates to timestamps
- Handling cancellations and returns
- Normalizing quantities and prices
- Removing invalid and service SKUs

Output: `retail_clean`, `retail_net`

---

### 2️⃣ Revenue Modeling (ABC Analysis)

Products were ranked by total net revenue.

Cumulative revenue share was calculated using window functions:

- A-class: Top ~80% of revenue
- B-class: Next ~15%
- C-class: Remaining ~5%

This isolates financially critical SKUs.

Output: `abc_class`

<img width="1029" height="254" alt="Screenshot 2026-02-20 at 18 08 00" src="https://github.com/user-attachments/assets/32c65aa0-d979-438a-b8ca-9fe5840a2760" />

---

### 3️⃣ Demand Stability Modeling (XYZ Analysis)

Monthly demand variability was measured using:

- Average monthly units
- Standard deviation
- Coefficient of variation (CV)

Classification:

| Segment | Interpretation        |
|---------|------------------------|
| X       | Stable demand          |
| Y       | Moderate variability   |
| Z       | Highly irregular       |

Products with insufficient history were handled separately.

Output: `xyz_class`

<img width="685" height="288" alt="Screenshot 2026-02-20 at 18 08 42" src="https://github.com/user-attachments/assets/49e8108d-f8a7-4d94-852e-8bdd2de78723" />

---

### 4️⃣ ABC–XYZ Segmentation

ABC and XYZ results were joined into a unified analytical layer:

| Segment | Meaning                          |
|---------|----------------------------------|
| AX      | High revenue, stable demand      |
| AY      | High revenue, variable demand    |
| CZ      | Low revenue, unstable demand     |

This creates an operational prioritization matrix.

Output: `abc_xyz_final`

<img width="1018" height="164" alt="Screenshot 2026-02-20 at 18 10 05" src="https://github.com/user-attachments/assets/aa34952c-4ac1-4484-b494-77af53cf6a0b" />

---

## 🧠 Strategic Assumptions

- **Pareto Principle (80/20 Rule):** Revenue concentration follows power-law dynamics
- **Demand Stability:** Historical variability reflects future uncertainty
- **Returns as Signals:** Negative revenue highlights structural product issues
- **Minimum History Requirement:** Reliable XYZ requires ≥3 months of data

These assumptions were validated through QA checks at each pipeline stage.

---

## ⚖️ Trade-offs & Risk Analysis

### Sensitivity vs. Coverage

- Including short-history products increases coverage
- Excluding them improves classification reliability

### Revenue vs. Stability

- Some A-class products exhibit Z-level volatility
- These require special replenishment policies

### Returns Impact

- Certain SKUs are revenue-negative (CX segment)
- Indicates candidates for delisting or supplier renegotiation

<img width="332" height="269" alt="Screenshot 2026-02-20 at 18 11 24" src="https://github.com/user-attachments/assets/9060bfc1-a397-4ead-8536-0057449a4038" />

---

## 📈 Interactive Dashboard

The full analysis is available in an interactive Tableau dashboard:

👉 **Tableau Public Dashboard:**  
[https://public.tableau.com/your-dashboard-link](https://public.tableau.com/authoring/ABC_17712246527350/ABCXYZInventorySegmentationRevenueConcentrationDemandStabilityAnalysis#1)

Features:

- Pareto curve exploration
- ABC distribution
- XYZ stability view
- Segment filtering
- Top SKU drill-down

---

## 🛠️ Tech Stack

- Database: DuckDB
- Query Language: SQL
- Visualization: Tableau Public
- Environment: VS Code / Terminal
- Version Control: Git / GitHub

---

## 📁 Repository Structure
