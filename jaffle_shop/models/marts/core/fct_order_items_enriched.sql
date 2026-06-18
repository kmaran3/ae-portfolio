with order_items as (
    select * from {{ ref('int_order_items_with_products') }}
),

orders as (
    select
        order_id,
        customer_id,
        store_id,
        order_date,
        order_month
    from {{ ref('fct_orders') }}
),

final as (
    select
        order_items.order_item_id,
        order_items.order_id,
        order_items.product_id,
        order_items.product_name,
        order_items.product_type,
        order_items.price_dollars,
        orders.customer_id,
        orders.store_id,
        orders.order_date,
        orders.order_month
    from order_items
    left join orders using (order_id)
)

select * from final