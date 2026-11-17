CREATE OR REPLACE VIEW analytics.vw_customer_kpis AS
WITH customer_location_counts AS (
    SELECT
        customer_unique_id,
        customer_city,
        customer_state,
        COUNT(*) AS location_record_count
    FROM analytics.vw_customers
    GROUP BY
        customer_unique_id,
        customer_city,
        customer_state
),
ranked_locations AS (
    SELECT
        customer_unique_id,
        customer_city,
        customer_state,
        ROW_NUMBER() OVER (
            PARTITION BY customer_unique_id
            ORDER BY
                location_record_count DESC,
                customer_state,
                customer_city
        ) AS location_rank
    FROM customer_location_counts
),
location_quality AS (
    SELECT
        customer_unique_id,
        (
            COUNT(DISTINCT customer_city) > 1
            OR COUNT(DISTINCT customer_state) > 1
        ) AS has_multiple_locations
    FROM analytics.vw_customers
    GROUP BY customer_unique_id
),
customer_metrics AS (
    SELECT
        c.customer_unique_id,
        COUNT(*) AS total_orders,
        COUNT(*) FILTER (
            WHERE o.order_status = 'delivered'
        ) AS delivered_orders,
        SUM(o.merchandise_value) AS lifetime_merchandise_value,
        SUM(o.freight_value) AS lifetime_freight_value,
        ROUND(
            (
                SUM(o.merchandise_value)
                / NULLIF(COUNT(*), 0)
            )::numeric,
            2
        ) AS average_order_value,
        MIN(o.purchase_timestamp) AS first_purchase_date,
        MAX(o.purchase_timestamp) AS most_recent_purchase_date
    FROM analytics.vw_customers c
    JOIN analytics.vw_order_kpis o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
)
SELECT
    m.*,
    (m.total_orders > 1) AS is_repeat_customer,
    l.customer_city,
    l.customer_state,
    q.has_multiple_locations
FROM customer_metrics m
LEFT JOIN ranked_locations l
    ON m.customer_unique_id = l.customer_unique_id
   AND l.location_rank = 1
LEFT JOIN location_quality q
    ON m.customer_unique_id = q.customer_unique_id;
