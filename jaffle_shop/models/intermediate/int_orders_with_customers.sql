with orders as (
    select * from {{ ref('stg_orders') }}
),

customers as (
    select * from {{ ref('stg_customers') }}
),

joined as (
    select
        orders.order_id,
        orders.store_id,
        orders.subtotal_dollars,
        orders.tax_paid_dollars,
        orders.order_total_dollars,
        orders.ordered_at,
        customers.customer_id,
        customers.customer_name
    from orders
    left join customers using (customer_id)
)

select * from joined