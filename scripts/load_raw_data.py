from pathlib import Path
import pandas as pd
from sqlalchemy import create_engine, text

# Project paths
BASE_DIR = Path(__file__).resolve().parents[1]
RAW_DIR = BASE_DIR / "data" / "raw"

# PostgreSQL connection
DATABASE_URL = "postgresql+psycopg:///ecommerce_intelligence"
engine = create_engine(DATABASE_URL)

# CSV filename -> PostgreSQL table name
FILES = {
    "olist_customers_dataset.csv": "customers",
    "olist_geolocation_dataset.csv": "geolocation",
    "olist_order_items_dataset.csv": "order_items",
    "olist_order_payments_dataset.csv": "order_payments",
    "olist_order_reviews_dataset.csv": "order_reviews",
    "olist_orders_dataset.csv": "orders",
    "olist_products_dataset.csv": "products",
    "olist_sellers_dataset.csv": "sellers",
    "product_category_name_translation.csv": "category_translation",
}

CHUNK_SIZE = 50000

def load_csv(filename, table_name):
    file_path = RAW_DIR / filename

    if not file_path.exists():
        raise FileNotFoundError(f"Missing source file: {file_path}")

    print(f"\nLoading {filename} -> raw.{table_name}")

    total_rows = 0
    first_chunk = True

    for chunk in pd.read_csv(file_path, chunksize=CHUNK_SIZE):
        chunk.to_sql(
            name=table_name,
            con=engine,
            schema="raw",
            if_exists="replace" if first_chunk else "append",
            index=False,
            method="multi",
            chunksize=1000
        )

        total_rows += len(chunk)
        first_chunk = False

    print(f"Loaded rows: {total_rows:,}")
    return total_rows


def main():
    results = {}

    with engine.connect() as connection:
        schema_check = connection.execute(
            text("""
                SELECT schema_name
                FROM information_schema.schemata
                WHERE schema_name = 'raw'
            """)
        ).fetchone()

    if schema_check is None:
        raise RuntimeError("The PostgreSQL raw schema does not exist.")

    for filename, table_name in FILES.items():
        results[table_name] = load_csv(filename, table_name)

    print("\n" + "=" * 55)
    print("RAW DATA LOAD SUMMARY")
    print("=" * 55)

    with engine.connect() as connection:
        for table_name, source_count in results.items():
            database_count = connection.execute(
                text(f'SELECT COUNT(*) FROM raw."{table_name}"')
            ).scalar_one()

            print(
                f"{table_name:25} "
                f"Source: {source_count:>10,} | "
                f"Database: {database_count:>10,}"
            )

            if source_count != database_count:
                raise RuntimeError(
                    f"Row count mismatch in raw.{table_name}"
                )

    print("\nSUCCESS: All source and database row counts match.")


if __name__ == "__main__":
    main()
