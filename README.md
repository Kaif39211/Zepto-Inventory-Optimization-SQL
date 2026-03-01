# Zepto Dark Store Optimization: Inventory & Pricing Intelligence

## 📌 Project Overview
This project analyzes dark store inventory data for a quick-commerce platform to identify **margin leakage**, **stagnant capital**, and **physical storage bottlenecks**. 

By engineering custom metrics (Price-Per-Gram) and building risk profiles in PostgreSQL, I transformed raw SKU-level data into actionable supply chain strategies to optimize shelf space and protect gross margins.

---

## 🛠️ Tech Stack & SQL Proficiency
- **Database:** PostgreSQL
- **Advanced SQL Techniques:** - **Window Functions:** `DENSE_RANK()`, `SUM() OVER(PARTITION BY)` for category-level benchmarking.
    - **CTEs & Subqueries:** To modularize complex logic for multi-stage risk modeling.
    - **Conditional Aggregation:** `CASE WHEN` within `SUM()` to build a dynamic KPI Dashboard.
    - **Data Integrity:** `NULLIF()` to handle zero-weight records in Price-Per-Gram calculations.
    - **Statistical Analysis:** `CORR()` to identify the relationship between discount depth and stock velocity.

---

## 📊 Dataset Schema
The analysis is performed on a simulated `PRODUCT_LEVEL_INVENTORY` table, modeled after quick-commerce SKU structures.

| Column | Description |
|---|---|
| `CATEGORY` | Product category (Dairy, Snacks, Electronics, etc.) |
| `MRP` | Maximum Retail Price |
| `AVAILABLE_QUANTITY` | Units in stock (Max capacity = 6 units per SKU) |
| `DISCOUNT_PERCENT` | Current promotional discount |
| `WEIGHT_IN_GMS` | Unit weight for price-per-gram density analysis |
| `OUT_OF_STOCK` | Boolean flag for inventory availability |

---

## 🚀 Strategic Business Recommendations

### 1. Curb Margin Leakage (Premium Tier)
**Insight:** Premium products (MRP > ₹5,000) show disproportionately high stock levels but carry an average discount of **8.36%**, leading to unnecessary margin bleed on high-ticket items.
- **Action:** Cap premium-tier discounts at **4%**.
- **Strategy:** Reallocate the saved promotional budget to the Mid-Range tier to drive higher volume without eroding luxury brand perception.

### 2. Liquidate Stagnant "Shelf-Hoggers"
**Insight:** Identified a bottleneck of SKUs at maximum storage capacity (6 units) with 0% discounts. These items occupy prime dark store real estate without generating velocity.
- **Action:** Implement an immediate **20–25% flash clearance** on these specific SKUs.
- **Result:** Frees up physical shelving for fast-moving consumer goods (FMCG) and improves inventory turnover ratios.

### 3. High-Value Shrinkage Mitigation
**Insight:** Used Price-Per-Gram analysis to isolate "High-Density Value" assets—lightweight items with high MRPs (e.g., premium saffron, electronics).
- **Action:** Relocate the **Top 10 High-Price-Per-Gram SKUs** to a "Secure Zone" or monitored shelving.
- **Result:** Reduces capital loss from inventory shrinkage and operational mishandling.

---

## 🔍 Key Analytical Queries & Logic

| Analysis Focus | SQL Technique | Business Logic |
|---|---|---|
| **Category Performance** | `SUM() OVER(PARTITION BY)` | Calculated % contribution of each product to total category revenue. |
| **Inventory Risk Model** | `CASE WHEN` Logic | Segmented stock into 'Healthy', 'Stagnant', and 'Critical' based on velocity vs. quantity. |
| **Top Performers** | `DENSE_RANK()` | Filtered Top 3 revenue-generating SKUs per category to prioritize restock alerts. |
| **Price Density** | `MRP / NULLIF(GMS, 0)` | Identified the most expensive items by weight to flag for security protocols. |
| **KPI Dashboard** | `GROUP BY 1` | Combined Revenue, Avg Discount, and Stock-Out rates into a single executive view. |

---

## 📐 Assumptions & Constraints
- **COGS:** Assumed at 70% of MRP (30% Gross Margin baseline).
- **Shelf Capacity:** `AVAILABLE_QUANTITY = 6` represents a full bin/shelf slot in the dark store.
- **Price Segmentation:** - **Budget:** < ₹2,000
    - **Mid
