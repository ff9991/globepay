with 

source as (

    select * from {{ source('globepay', 'chargeback_report') }}

),

renamed as (

    select
        external_ref as id,
        status,
        source,
        chargeback

    from source

)

select * from renamed
