CREATE OR REPLACE VIEW analytics.vw_product_kpis AS
WITH product_sales AS (
    SELECT
        product_id,
        COUNT(*) AS units_sold,
        COUNT(DISTINCT order_id) AS total_orders,
        COUNT(DISTINCT seller_id) AS total_sellers,
        SUM(item_price) AS merchandise_value,
        SUM(freight_value) AS freight_value,
        ROUND(AVG(item_price), 2) AS average_selling_price
    FROM analytics.vw_order_items
    GROUP BY product_id
)
SELECT
    p.product_id,
    p.product_category_name,
    p.product_category_english,
    p.product_name_length,
    p.product_description_length,
    p.product_photos_qty,
    p.product_weight_g,
    p.product_length_cm,
    p.product_height_cm,
    p.product_width_cm,
    COALESCE(s.units_sold, 0) AS units_sold,
    COALESCE(s.total_orders, 0) AS total_orders,
    COALESCE(s.total_sellers, 0) AS total_sellers,
    COALESCE(s.merchandise_value, 0)::numeric(14,2) AS merchandise_value,
    COALESCE(s.freight_value, 0)::numeric(14,2) AS freight_value,
    s.average_selling_price
FROM analytics.vw_products p
LEFT JOIN product_sales s
    ON p.product_id = s.product_id;
