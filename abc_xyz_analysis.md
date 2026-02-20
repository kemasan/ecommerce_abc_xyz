
# ABC–XYZ Inventory Segmentation Analysis (Online Retail)

## 1. Project Overview

This project applies **ABC and XYZ inventory classification** to an e-commerce dataset in order to identify high-value products and understand demand stability. The goal is to support better inventory prioritization, replenishment planning, and portfolio optimization.

The analysis combines revenue concentration (ABC) with demand variability (XYZ) to create a practical decision framework for stock management.

---

## 2. Business Context

E-commerce retailers typically manage thousands of SKUs with uneven revenue contribution and unstable demand patterns. Treating all products equally leads to:

* Excess inventory of slow movers
* Stock-outs of high-impact products
* Inefficient capital allocation

ABC–XYZ analysis provides a structured way to segment products based on financial importance and demand predictability.

---

## 3. Business Question

**How can we identify priority SKUs and align inventory strategy with revenue impact and demand stability?**

Specifically:

* Which products generate most revenue?
* Which products have stable vs volatile demand?
* Which segments require close monitoring?
* Which segments are candidates for rationalization?

---

## 4. Project Objectives

1. Classify SKUs using ABC analysis (revenue concentration)
2. Classify SKUs using XYZ analysis (demand variability)
3. Build an ABC × XYZ matrix
4. Validate segmentation
5. Design an interactive dashboard
6. Generate actionable insights

---

## 5. Dataset

**Source:** Kaggle – E-commerce Transaction Dataset

The dataset contains transactional data including:

* Invoice number
* Stock code (SKU)
* Product description
* Quantity
* Invoice date
* Unit price
* Customer ID
* Country

The data represents historical online retail transactions.

---

## 6. Data Preparation

### 6.1 Cleaning

The following steps were applied:

* Removed cancelled transactions
* Removed records with negative quantities
* Filtered invalid prices
* Removed missing Stock Codes
* Excluded non-product records

### 6.2 Feature Engineering

Created derived metrics:

* `Revenue = Quantity × Unit Price`
* Monthly sales aggregation
* Average monthly units
* Standard deviation of monthly units
* Coefficient of variation (CV)

---

## 7. ABC Analysis (Revenue Concentration)

### 7.1 Method

1. Aggregate total revenue by SKU
2. Sort SKUs by revenue (descending)
3. Compute cumulative revenue share
4. Assign categories:

| Class | Revenue Share |
| ----- | ------------- |
| A     | Top ~80%      |
| B     | Next ~15%     |
| C     | Remaining ~5% |

### 7.2 Validation

A sanity check ensured:

```
Count(A) + Count(B) + Count(C) = Total SKUs
```

Result:

```
3916 SKUs
```

---

## 8. XYZ Analysis (Demand Stability)

### 8.1 Method

Demand variability was measured using the coefficient of variation:

```
CV = Standard Deviation / Mean
```

Categories:

| Class | CV Range | Interpretation       |
| ----- | -------- | -------------------- |
| X     | Low      | Stable demand        |
| Y     | Medium   | Moderate variability |
| Z     | High     | Volatile demand      |

### 8.2 Interpretation

* X: Predictable products
* Y: Seasonal or trending products
* Z: Irregular products

---

## 9. ABC × XYZ Matrix

The two classifications were combined to form a 3×3 matrix:

|   | X  | Y  | Z  |
| - | -- | -- | -- |
| A | AX | AY | AZ |
| B | BX | BY | BZ |
| C | CX | CY | CZ |

Each SKU belongs to one segment.

---

## 10. Key Segments

### 10.1 AX (Core Products)

* High revenue
* Stable demand
* Priority for forecasting and replenishment

### 10.2 AY (Growth / Risk Products)

* High revenue
* Medium volatility
* Require monitoring

### 10.3 AZ (Critical Risk)

* High revenue
* Unstable demand
* High safety stock required

### 10.4 CZ (Low Value / Volatile)

* Low revenue
* High volatility
* Candidates for rationalization

---

## 11. Tooling and Stack

* Data processing: SQL / DuckDB
* Visualization: Tableau Public (Web Authoring)
* Dataset source: Kaggle
* Documentation: Markdown

---

## 12. Dashboard Design

### 12.1 Components

1. KPI Tiles

   * Total Revenue
   * Active SKUs
   * Revenue from A (%)
   * AX Revenue Share

2. Pareto Chart

   * Revenue distribution
   * Cumulative share line

3. ABC Distribution Bar Chart

   * SKU count by class

4. XYZ Scatter Plot

   * Avg Monthly Units vs CV
   * Bubble size: Revenue

5. ABC × XYZ Matrix

   * Segment overview

6. Filters Panel

   * ABC class
   * XYZ class

### Dashboard

The final dashboard is published on Tableau Public:

https://public.tableau.com/your_link_here

---

## 13. Validation and Quality Checks

Several checks were performed:

* ABC class totals validation
* Revenue aggregation verification
* Duplicate SKU detection
* CV outlier review
* Filter consistency testing

These ensured segmentation accuracy.

---

## 14. Key Findings

### 14.1 Revenue Concentration

* ~80% of revenue comes from A-class products
* A-class represents a small fraction of SKUs

### 14.2 Demand Stability

* Majority of A products fall into X and Y
* Z segment contains high operational risk

### 14.3 Portfolio Structure

* AX is the strategic core
* CZ is overrepresented in SKU count
* Long tail contributes limited revenue

---

## 15. Business Implications

### Inventory Management

* Prioritize AX for availability
* Increase buffers for AZ
* Reduce exposure to CZ

### Forecasting

* Use statistical models for X
* Hybrid approaches for Y
* Scenario planning for Z

### Portfolio Optimization

* Rationalize low-performing CZ SKUs
* Promote high-potential BX/BY

---

## 16. Limitations

* Historical data only
* No supplier lead-time data
* No promotion information
* No seasonality modeling
* Single-channel focus

---

## 17. Future Improvements

* Integrate lead times
* Add seasonal decomposition
* Apply machine learning forecasting
* Include margin analysis
* Build automated refresh pipelines
  n

---

## 18. Conclusion

This project demonstrates how ABC–XYZ segmentation can transform raw transaction data into actionable inventory intelligence.

By combining financial impact and demand stability, the framework enables:

* Smarter stocking decisions
* Reduced operational risk
* Better capital allocation
* Clear portfolio prioritization

The final dashboard provides an interactive decision-support tool suitable for inventory planners, analysts, and managers.
