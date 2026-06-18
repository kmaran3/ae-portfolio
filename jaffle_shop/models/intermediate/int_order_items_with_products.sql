with order_items as (
    select * from {{ ref('stg_order_items') }}
),

products as (
    select * from {{ ref('stg_products') }}
),

joined as (
    select
        order_items.order_item_id,
        order_items.order_id,
        products.product_id,
        products.product_name,
        products.product_type,
        products.price_dollars
    from order_items
    left join products using (product_id)
)

select * from joined