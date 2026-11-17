
CREATE OR REPLACE VIEW analytics.vw_orders_clean AS
SELECT
    order_id,
    customer_id,
    order_status,

    NULLIF(order_purchase_timestamp, '')::timestamp
        AS purchase_timestamp,

    NULLIF(order_approved_at, '')::timestamp
        AS approved_timestamp,

    NULLIF(order_delivered_carrier_date, '')::timestamp
        AS carrier_timestamp,

    NULLIF(order_delivered_customer_date, '')::timestamp
        AS delivered_timestamp,

    NULLIF(order_estimated_delivery_date, '')::timestamp
        AS estimated_delivery_timestamp,

    CASE
        WHEN NULLIF(order_delivered_carrier_date, '') IS NOT NULL
         AND NULLIF(order_purchase_timestamp, '') IS NOT NULL
         AND order_delivered_carrier_date < order_purchase_timestamp
        THEN TRUE
        ELSE FALSE
    END AS carrier_before_purchase_flag,

    CASE
        WHEN NULLIF(order_delivered_customer_date, '') IS NOT NULL
         AND NULLIF(order_delivered_carrier_date, '') IS NOT NULL
         AND order_delivered_customer_date < order_delivered_carrier_date
        THEN TRUE
        ELSE FALSE
    END AS delivery_before_carrier_flag

FROM raw.orders;


CREATE OR REPLACE VIEW analytics.vw_order_items AS
SELECT
    order_id,
    order_item_id,
    product_id,
    seller_id,
    NULLIF(shipping_limit_date, '')::timestamp AS shipping_limit_timestamp,
    price::numeric(12,2) AS item_price,
    freight_value::numeric(12,2) AS freight_value
FROM raw.order_items;


CREATE OR REPLACE VIEW analytics.vw_order_payments AS
SELECT
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value::numeric(12,2) AS payment_value
FROM raw.order_payments;

