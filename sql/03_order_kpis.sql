CREATE OR REPLACE VIEW analytics.vw_order_kpis AS
WITH item_metrics AS (
    SELECT
        order_id,
        COUNT(*) AS item_count,
        COUNT(DISTINCT product_id) AS distinct_products,
        COUNT(DISTINCT seller_id) AS distinct_sellers,
        SUM(item_price) AS merchandise_value,
        SUM(freight_value) AS freight_value
    FROM analytics.vw_order_items
    GROUP BY order_id
),
payment_metrics AS (
    SELECT
        order_id,
        COUNT(*) AS payment_record_count,
        SUM(payment_value) AS total_payment_value,
        COUNT(DISTINCT payment_type) AS payment_type_count
    FROM analytics.vw_order_payments
    GROUP BY order_id
)
SELECT
    o.order_id,
    o.customer_id,
    o.order_status,
    o.purchase_timestamp,
    o.approved_timestamp,
    o.carrier_timestamp,
    o.delivered_timestamp,
    o.estimated_delivery_timestamp,
    o.carrier_before_purchase_flag,
    o.delivery_before_carrier_flag,
    COALESCE(i.item_count, 0) AS item_count,
    COALESCE(i.distinct_products, 0) AS distinct_products,
    COALESCE(i.distinct_sellers, 0) AS distinct_sellers,
    COALESCE(i.merchandise_value, 0) AS merchandise_value,
    COALESCE(i.freight_value, 0) AS freight_value,
    COALESCE(p.payment_record_count, 0) AS payment_record_count,
    COALESCE(p.total_payment_value, 0) AS total_payment_value,
    COALESCE(p.payment_type_count, 0) AS payment_type_count,
    CASE
        WHEN o.order_status = 'delivered'
         AND o.delivered_timestamp IS NOT NULL
         AND o.estimated_delivery_timestamp IS NOT NULL
        THEN o.delivered_timestamp > o.estimated_delivery_timestamp
        ELSE NULL
    END AS delivered_late_flag,
    CASE
        WHEN o.order_status = 'delivered'
         AND o.delivered_timestamp IS NOT NULL
         AND o.estimated_delivery_timestamp IS NOT NULL
         AND NOT o.delivery_before_carrier_flag
        THEN EXTRACT(
            EPOCH FROM (
                o.delivered_timestamp - o.purchase_timestamp
            )
        ) / 86400.0
        ELSE NULL
    END AS purchase_to_delivery_days
FROM analytics.vw_orders_clean o
LEFT JOIN item_metrics i
    ON o.order_id = i.order_id
LEFT JOIN payment_metrics p
    ON o.order_id = p.order_id;
