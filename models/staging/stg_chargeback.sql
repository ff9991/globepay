with 

source as (

    select * from {{ source('deel', 'chargeback_report') }}

),

renamed as (

    select
        external_ref,
        status,
        source,
        chargeback

    from source

)

select * from renamed
