CREATE OR REPLACE VIEW analytics.vw_review_kpis AS
SELECT
    review_score,
    COUNT(*) AS review_record_count,
    COUNT(DISTINCT order_id) AS reviewed_orders,
    ROUND(AVG(review_score), 2) AS average_review_score
FROM raw.order_reviews
WHERE review_score BETWEEN 1 AND 5
GROUP BY review_score;
