CREATE OR REPLACE VIEW analytics.vw_monthly_kpis AS
SELECT
    DATE_TRUNC('month', purchase_timestamp)::date
        AS purchase_month,
    COUNT(*) AS total_orders,
    COUNT(*) FILTER (
        WHERE order_status = 'delivered'
    ) AS delivered_orders,
    SUM(merchandise_value)::numeric(14,2)
        AS merchandise_value,
    SUM(freight_value)::numeric(14,2)
        AS freight_value,
    ROUND(
        AVG(merchandise_value), 2
    ) AS average_merchandise_value_per_order
FROM analytics.vw_order_kpis
GROUP BY DATE_TRUNC('month', purchase_timestamp)::date;
