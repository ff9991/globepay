{%- set currencies = ['CAD','EUR','MXN','USD', 'SGD', 'AUD', 'GBP'] -%}
 
with 

payments as (

   select * from {{ ref('stg_payments') }}

),
 
payments_to_usd_currency as (
   
   select
      ref_id,
      cad,     
      {% for currency in currencies -%}
 
         sum(
            case
               when currency = '{{ currency }}' 
               then amount 
               else 0 
            end
         ) as {{ currency }}_amount,

      {%- endfor %}
      sum(amount) as total_amount

   from payments
    where ref_id = 'evt_1ELyHogAOzmoB9IvCTZ1Mb0'
   group by 1,2

)
 
select * from payments_to_usd_currency