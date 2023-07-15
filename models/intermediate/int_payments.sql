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
    cad,
    eur,
    mxn,    
    usd,
    sgd,
    aud,
    gbp,
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
   group by 1,2,3,4,5,6,7,8,9,10,11

),

unified_data as (
SELECT ref_id, created_at, state, country, currency, usd_amount
FROM (
    SELECT ref_id, created_at, state, country, 'CAD' AS currency, cad * CAD_amount AS usd_amount
    FROM payments_to_usd_currency
    UNION ALL
    SELECT ref_id, created_at, state, country, 'EUR' AS currency, eur * EUR_amount AS usd_amount
    FROM payments_to_usd_currency
    UNION ALL
    SELECT ref_id, created_at, state, country, 'MXN' AS currency, mxn * MXN_amount AS usd_amount
    FROM payments_to_usd_currency
    UNION ALL
    SELECT ref_id, created_at, state, country, 'USD' AS currency, usd * USD_amount AS usd_amount
    FROM payments_to_usd_currency
    UNION ALL
    SELECT ref_id, created_at, state, country, 'SGD' AS currency, sgd * SGD_amount AS usd_amount
    FROM payments_to_usd_currency
    UNION ALL
    SELECT ref_id, created_at, state, country, 'AUD' AS currency, aud * AUD_amount AS usd_amount
    FROM payments_to_usd_currency
    UNION ALL
    SELECT ref_id, created_at, state, country, 'GBP' AS currency, gbp * GBP_amount AS usd_amount
    FROM payments_to_usd_currency
))

 
select * from unified_data