CREATE OR REPLACE VIEW analytics.vw_seller_kpis AS
SELECT
    seller_id,
    COUNT(*) AS units_sold,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT product_id) AS distinct_products_sold,
    SUM(item_price)::numeric(14,2) AS merchandise_value,
    SUM(freight_value)::numeric(14,2) AS freight_value,
    ROUND(AVG(item_price), 2) AS average_selling_price
FROM analytics.vw_order_items
GROUP BY seller_id;
