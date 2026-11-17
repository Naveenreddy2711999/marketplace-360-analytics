CREATE OR REPLACE VIEW analytics.vw_payment_kpis AS
SELECT
    payment_type,
    COUNT(*) AS payment_record_count,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(payment_value)::numeric(14,2) AS total_payment_value,
    ROUND(AVG(payment_value), 2) AS average_payment_value,
    ROUND(AVG(payment_installments), 2) AS average_installments,
    MAX(payment_installments) AS maximum_installments
FROM analytics.vw_order_payments
GROUP BY payment_type;
