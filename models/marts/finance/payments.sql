with 

payments as (

   select * from {{ ref('int_payments') }}

)

select * from payments