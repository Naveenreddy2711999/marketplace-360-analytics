CREATE OR REPLACE VIEW analytics.vw_category_kpis AS
SELECT
    COALESCE(
        product_category_english,
        'Unknown'
    ) AS product_category,
    COUNT(DISTINCT product_id) AS total_products,
    SUM(units_sold) AS units_sold,
    SUM(total_orders) AS product_order_count,
    SUM(merchandise_value)::numeric(14,2) AS merchandise_value,
    SUM(freight_value)::numeric(14,2) AS freight_value,
    ROUND(
        SUM(merchandise_value)
        / NULLIF(SUM(units_sold), 0),
        2
    ) AS average_selling_price
FROM analytics.vw_product_kpis
GROUP BY
    COALESCE(
        product_category_english,
        'Unknown'
    );
