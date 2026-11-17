from pathlib import Path
import pandas as pd
from sqlalchemy import create_engine, text

PROJECT_DIR = Path(__file__).resolve().parents[1]
EXPORT_DIR = PROJECT_DIR / "data" / "dashboard_exports"
EXPORT_DIR.mkdir(parents=True, exist_ok=True)

DATABASE_URL = "postgresql+psycopg:///ecommerce_intelligence"
engine = create_engine(DATABASE_URL)

EXPORTS = {
    "executive_kpis.csv": "SELECT * FROM analytics.vw_executive_kpis",
    "monthly_kpis.csv": "SELECT * FROM analytics.vw_monthly_kpis ORDER BY purchase_month",
    "category_kpis.csv": "SELECT * FROM analytics.vw_category_kpis ORDER BY merchandise_value DESC",
    "product_kpis.csv": "SELECT * FROM analytics.vw_product_kpis",
    "regional_kpis.csv": "SELECT * FROM analytics.vw_regional_kpis ORDER BY merchandise_value DESC",
    "customer_kpis.csv": "SELECT * FROM analytics.vw_customer_kpis",
    "delivery_kpis.csv": "SELECT * FROM analytics.vw_delivery_kpis",
    "seller_kpis.csv": "SELECT * FROM analytics.vw_seller_kpis ORDER BY merchandise_value DESC",
    "payment_kpis.csv": "SELECT * FROM analytics.vw_payment_kpis ORDER BY total_payment_value DESC",
    "review_kpis.csv": "SELECT * FROM analytics.vw_review_kpis ORDER BY review_score",
}

with engine.connect() as connection:
    for filename, query in EXPORTS.items():
        dataframe = pd.read_sql_query(text(query), connection)
        output_path = EXPORT_DIR / filename
        dataframe.to_csv(output_path, index=False)

        print(
            f"Exported {filename}: "
            f"{len(dataframe):,} rows, "
            f"{len(dataframe.columns)} columns"
        )

print(f"\nAll exports saved to: {EXPORT_DIR}")
engine.dispose()
