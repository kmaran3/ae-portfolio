with source as (
    select * from {{ source('raw', 'raw_orders') }}
),

renamed as (
    select
        id                              as order_id,
        customer                        as customer_id,
        store_id,
        subtotal                        as subtotal_cents,
        round(subtotal / 100.0, 2)      as subtotal_dollars,
        tax_paid                        as tax_paid_cents,
        round(tax_paid / 100.0, 2)      as tax_paid_dollars,
        order_total                     as order_total_cents,
        round(order_total / 100.0, 2)   as order_total_dollars,
        ordered_at
    from source
)

select * from renamed