CREATE OR REPLACE VIEW analytics.vw_delivery_kpis AS
SELECT
    order_status,
    COUNT(*) AS total_orders,
    COUNT(*) FILTER (
        WHERE delivered_late_flag IS TRUE
    ) AS late_orders,
    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE delivered_late_flag IS TRUE
        ) / NULLIF(COUNT(*) FILTER (
            WHERE order_status = 'delivered'
              AND delivered_late_flag IS NOT NULL
        ), 0),
        2
    ) AS late_delivery_rate_pct,
    ROUND(AVG(purchase_to_delivery_days), 2)
        AS average_purchase_to_delivery_days
FROM analytics.vw_order_kpis
GROUP BY order_status;
