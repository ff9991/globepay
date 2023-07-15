{%- set currencies = ['CAD','EUR','MXN','USD', 'SGD', 'AUD', 'GBP'] -%}
 
with 

payments as (

   select * from {{ ref('stg_payments') }}

),
 
payments_to_usd_currency as (
   
   select
    ref_id,
    created_at,
    state,
    country,
    currency,
    cad,
    eur,
    mxn,    
    usd,
    sgd,
    aud,
    gbp,
      {% for currency in currencies -%}
 
        cast(
            sum(
            case
               when currency = '{{ currency }}' 
               then amount 
               else 0 
            end
         ) as FLOAT64) as {{ currency }}_amount,

      {%- endfor %}

   from payments
   group by 1,2,3,4,5,6,7,8,9,10,11,12

),

unified_data as (
    SELECT ref_id, created_at, state, country, currency, round(usd_amount, 2) as usd_amount
    FROM (
        SELECT ref_id, created_at, state, country, currency, CAD_amount / cad AS usd_amount
        FROM payments_to_usd_currency
        WHERE currency = 'CAD'
        UNION ALL
        SELECT ref_id, created_at, state, country, currency, EUR_amount / eur AS usd_amount
        FROM payments_to_usd_currency
        WHERE currency = 'EUR'
        UNION ALL
        SELECT ref_id, created_at, state, country, currency, MXN_amount / mxn AS usd_amount
        FROM payments_to_usd_currency
        WHERE currency = 'MXN'
        UNION ALL
        SELECT ref_id, created_at, state, country, currency, USD_amount / usd AS usd_amount
        FROM payments_to_usd_currency
        WHERE currency = 'USD'
        UNION ALL
        SELECT ref_id, created_at, state, country, currency, SGD_amount / sgd AS usd_amount
        FROM payments_to_usd_currency
        WHERE currency = 'SGD'
        UNION ALL
        SELECT ref_id, created_at, state, country, currency, AUD_amount / aud AS usd_amount
        FROM payments_to_usd_currency
        WHERE currency = 'AUD'
        UNION ALL
        SELECT ref_id, created_at, state, country, currency, GBP_amount / gbp AS usd_amount
        FROM payments_to_usd_currency
        WHERE currency = 'GBP'
))
 
select * from unified_data