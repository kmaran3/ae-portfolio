with source as (
    select * from {{ source('raw', 'raw_products') }}
),

renamed as (
    select
        sku             as product_id,
        name            as product_name,
        type            as product_type,
        price           as price_cents,
        round(price / 100.0, 2) as price_dollars,
        description
    from source
)

select * from renamed