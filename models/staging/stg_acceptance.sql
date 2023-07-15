with 

source as (

    select * from {{ source('globepay', 'acceptance_report') }}

),

renamed as (

    select
        external_ref as id,
        status,
        ref,
        date_time as created_at,
        state,
        cvv_provided,
        amount,
        country,
        currency,
        JSON_VALUE(rates.CAD)

    from source

)

select * from renamed
