# Marketplace 360
### E-Commerce Business Performance & Operations Analytics

An end-to-end business intelligence project analyzing e-commerce marketplace performance, customer behaviour, product categories, seller performance, payment preferences, and delivery operations.

## Project Overview

Marketplace 360 transforms the Brazilian Olist e-commerce dataset into actionable business insights using Python, PostgreSQL, SQL, and Tableau.

The project covers data quality assessment, relational data modelling, SQL analytics, KPI development, and interactive dashboard development.

## Business Questions

- How is marketplace order performance evolving over time?
- Which product categories contribute the most merchandise value?
- Which regions generate the highest merchandise value?
- What are the customer purchasing and repeat-order patterns?
- Which payment methods are most commonly used?
- How are customers rating their shopping experience?
- What proportion of delivered orders arrive later than estimated?
- How do sellers compare in terms of merchandise value and order activity?

## Technology Stack

- Python
- Pandas and NumPy
- PostgreSQL
- SQL
- Tableau Public
- Git and GitHub

## Project Structure

```text
marketplace-360-analytics/
├── dashboards/
├── data/
│   ├── cleaned/
│   ├── dashboard_exports/
│   └── raw/
├── documentation/
├── notebooks/
├── reports/
├── scripts/
└── sql/
Key Business Metrics
Metric	Result
Total Orders	99,441
Delivered Orders	96,478
Unique Customers	96,096
Merchandise Value	R$13,591,643.70
Payment Value	R$16,008,872.12
Late Delivery Rate	8.11%
Average Review Score	4.09 / 5
Average Delivery Time	12.56 days
Repeat Customer Rate	3.12%

Note: Merchandise value is not profit. The dataset does not provide cost of goods sold.
Tableau Dashboards
1. Executive Business Performance
Marketplace-wide order trends, merchandise value, customer metrics, category performance, regional performance, and seller insights.
2. Customer & Operations Intelligence
Customer review scores, order fulfilment status, payment method analysis, and regional marketplace performance.

Packaged Tableau workbooks are available in the dashboards/ directory.
Data Quality & Validation
- Audited all nine source CSV files.
- Validated primary keys and dataset relationships.
- Identified duplicate review identifiers and multiple reviews per order.
- Flagged timestamp inconsistencies.
- Built 17 PostgreSQL analytics views.
- Validated dashboard exports against SQL totals.
- Aggregated order items and payments separately to avoid join fan-out.
Dataset
Source: Brazilian E-Commerce Public Dataset by Olist — Kaggle

The original raw CSV files are not included in this repository. Download the dataset from Kaggle and place the extracted files in data/raw/ before running the data-loading scripts.
Important Analytical Notes
- Monetary values are in Brazilian reais (BRL).
- September and October 2018 contain partial-month data.
- Delivery duration calculations exclude records with delivery-before-carrier timestamp inconsistencies.
- Repeat customer rate is calculated using unique customer identity.
- No profit or margin claims are made because cost data is unavailable.
Author
Tiyyagura Naveen Reddy

Data Analytics | SQL | Python | PostgreSQL | Tableau
