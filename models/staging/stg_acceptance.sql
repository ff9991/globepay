with 

source as (

    select * from {{ source('globepay', 'acceptance_report') }}

),

renamed as (

    select
        ref as ref_id,
        external_ref as external_ref_id,
        source.source,
        status,
        date_time as created_at,
        state,
        cvv_provided,
        amount,
        country,
        currency,
        rates

    from source

)

select * from renamed
