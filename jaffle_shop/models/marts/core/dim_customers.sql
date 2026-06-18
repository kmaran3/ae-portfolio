with orders as (
    select * from {{ ref('fct_orders') }}
),

customers as (
    select * from {{ ref('stg_customers') }}
),

customer_orders as (
    select
        customer_id,
        count(order_id)                                     as total_orders,
        sum(order_total_dollars)                                  as lifetime_value_dollars,
        min(ordered_at)                                     as first_order_at,
        max(ordered_at)                                     as most_recent_order_at
    from orders
    group by customer_id
),

final as (
    select
        customers.customer_id,
        customers.customer_name,
        coalesce(customer_orders.total_orders, 0)           as total_orders,
        coalesce(customer_orders.lifetime_value_dollars, 0) as lifetime_value_dollars,
        customer_orders.first_order_at,
        customer_orders.most_recent_order_at,
        -- Segmentation
        case
            when customer_orders.total_orders >= 5 then 'loyal'
            when customer_orders.total_orders >= 2 then 'repeat'
            when customer_orders.total_orders = 1 then 'one_time'
            else 'no_orders'
        end                                                 as customer_segment
    from customers
    left join customer_orders using (customer_id)
)

select * from final