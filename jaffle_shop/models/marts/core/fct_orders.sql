with orders as (
    select * from {{ ref('int_orders_with_customers') }}
),

final as (
    select
        order_id,
        customer_id,
        customer_name,
        store_id,
        subtotal_dollars,
        tax_paid_dollars,
        order_total_dollars,
        ordered_at,
        date(ordered_at)                                    as order_date,
        format_date('%Y-%m', date(ordered_at))              as order_month
    from orders
)

select * from final