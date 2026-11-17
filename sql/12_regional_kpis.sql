CREATE OR REPLACE VIEW analytics.vw_regional_kpis AS
SELECT
    customer_state,
    COUNT(*) AS unique_customers,
    SUM(total_orders) AS total_orders,
    SUM(lifetime_merchandise_value)::numeric(14,2)
        AS merchandise_value,
    SUM(lifetime_freight_value)::numeric(14,2)
        AS freight_value,
    ROUND(
        AVG(lifetime_merchandise_value), 2
    ) AS average_customer_merchandise_value
FROM analytics.vw_customer_kpis
GROUP BY customer_state;
