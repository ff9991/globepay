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
        rates,
        cast(JSON_EXTRACT_SCALAR(rates,'$.CAD')as FLOAT64) as cad,
        cast(JSON_EXTRACT_SCALAR(rates,'$.EUR')as FLOAT64) as eur,
        cast(JSON_EXTRACT_SCALAR(rates,'$.MXN')as FLOAT64) as mxn,
        cast(JSON_EXTRACT_SCALAR(rates,'$.USD')as FLOAT64) as usd,
        cast(JSON_EXTRACT_SCALAR(rates,'$.SGD')as FLOAT64) as sgd,
        cast(JSON_EXTRACT_SCALAR(rates,'$.AUD')as FLOAT64) as aud,
        cast(JSON_EXTRACT_SCALAR(rates,'$.GBP')as FLOAT64) as gbp

    from source
)

select * from renamed