with customers as (
    select
        customer_id,
        format_date('%Y-%m', min(date(ordered_at)))  as cohort_month
    from {{ ref('fct_orders') }}
    group by customer_id
),

orders as (
    select
        customer_id,
        format_date('%Y-%m', order_date)                 as order_month,
        order_date
    from {{ ref('fct_orders') }}
),

cohort_orders as (
    select
        customers.customer_id,
        customers.cohort_month,
        orders.order_month,
        cast(date_diff(
            parse_date('%Y-%m', orders.order_month),
            parse_date('%Y-%m', customers.cohort_month),
            month
        ) as int64)                                                as months_since_signup
    from customers
    left join orders using (customer_id)
),

cohort_sizes as (
    select
        cohort_month,
        count(distinct customer_id) as cohort_size
    from customers
    group by cohort_month
),

retention as (
    select
        cohort_orders.cohort_month,
        cohort_orders.months_since_signup,
        count(distinct cohort_orders.customer_id)        as active_customers
    from cohort_orders
    where months_since_signup is not null
      and months_since_signup >= 0
    group by cohort_month, months_since_signup
),

final as (
    select
        retention.cohort_month,
        retention.months_since_signup,
        retention.active_customers,
        cohort_sizes.cohort_size,
        round(
            100.0 * retention.active_customers / cohort_sizes.cohort_size,
            1
        )                                                as retention_rate_pct
    from retention
    left join cohort_sizes using (cohort_month)
)

select * from final
order by cohort_month, months_since_signup