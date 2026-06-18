with orders as (
    select * from {{ ref('fct_orders') }}
),

daily as (
    select
        order_date,
        order_month,
        store_id,
        count(order_id)             as orders_placed,
        sum(order_total_dollars)          as gross_revenue_dollars,
        sum(subtotal_dollars)       as net_revenue_dollars,
        sum(tax_paid_dollars)       as tax_collected_dollars,
        avg(order_total_dollars)          as avg_order_value_dollars
    from orders
    group by order_date, order_month, store_id
),

final as (
    select
        {{ dbt_utils.generate_surrogate_key(['order_date', 'store_id']) }} as revenue_daily_id,
        order_date,
        order_month,
        store_id,
        orders_placed,
        gross_revenue_dollars,
        net_revenue_dollars,
        tax_collected_dollars,
        avg_order_value_dollars
    from daily
)

select * from final