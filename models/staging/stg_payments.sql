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
        JSON_EXTRACT_SCALAR(rates,'$.CAD') as cad,
        JSON_EXTRACT_SCALAR(rates,'$.EUR') as eur,
        JSON_EXTRACT_SCALAR(rates,'$.MXN') as mxn,
        JSON_EXTRACT_SCALAR(rates,'$.USD') as usd,
        JSON_EXTRACT_SCALAR(rates,'$.SGD') as sgd,
        JSON_EXTRACT_SCALAR(rates,'$.AUD') as aud,
        JSON_EXTRACT_SCALAR(rates,'$.GBP') as gbp

    from source

)

select * from renamed