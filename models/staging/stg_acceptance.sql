with 

source as (

    select * from {{ source('globepay', 'acceptance_report') }}

),

renamed as (

    select
        external_ref as id,
        status,
        source,
        ref,
        date_time,
        state,
        cvv_provided,
        amount,
        country,
        currency,
        rates

    from source

)

select * from renamed
