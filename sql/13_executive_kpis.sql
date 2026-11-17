CREATE OR REPLACE VIEW analytics.vw_executive_kpis AS
WITH order_metrics AS (
    SELECT
        COUNT(*) AS total_orders,
        COUNT(*) FILTER (
            WHERE order_status = 'delivered'
        ) AS delivered_orders,
        COUNT(*) FILTER (
            WHERE delivered_late_flag IS TRUE
        ) AS late_orders,
        COUNT(*) FILTER (
            WHERE delivered_late_flag IS NOT NULL
        ) AS eligible_delivery_orders,
        SUM(merchandise_value) AS total_merchandise_value,
        SUM(freight_value) AS total_freight_value,
        SUM(total_payment_value) AS total_payment_value,
        ROUND(AVG(merchandise_value), 2)
            AS average_merchandise_value_per_order,
        ROUND(AVG(purchase_to_delivery_days), 2)
            AS average_delivery_days
    FROM analytics.vw_order_kpis
),
customer_metrics AS (
    SELECT
        COUNT(*) AS unique_customers,
        COUNT(*) FILTER (
            WHERE is_repeat_customer IS TRUE
        ) AS repeat_customers
    FROM analytics.vw_customer_kpis
),
review_metrics AS (
    SELECT
        ROUND(
            SUM(review_score * review_record_count)::numeric
            / NULLIF(SUM(review_record_count), 0),
            2
        ) AS average_review_score
    FROM analytics.vw_review_kpis
)
SELECT
    o.total_orders,
    o.delivered_orders,
    c.unique_customers,
    o.total_merchandise_value::numeric(14,2)
        AS total_merchandise_value,
    o.total_freight_value::numeric(14,2)
        AS total_freight_value,
    o.total_payment_value::numeric(14,2)
        AS total_payment_value,
    o.average_merchandise_value_per_order,
    o.late_orders,
    o.eligible_delivery_orders,
    ROUND(
        100.0 * o.late_orders /
        NULLIF(o.eligible_delivery_orders, 0), 2
    ) AS late_delivery_rate_pct,
    o.average_delivery_days,
    c.repeat_customers,
    ROUND(
        100.0 * c.repeat_customers /
        NULLIF(c.unique_customers, 0), 2
    ) AS repeat_customer_rate_pct,
    r.average_review_score
FROM order_metrics o
CROSS JOIN customer_metrics c
CROSS JOIN review_metrics r;
