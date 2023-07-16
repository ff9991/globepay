{%- set currencies = ['CAD','EUR','MXN','USD', 'SGD', 'AUD', 'GBP'] -%}
 
with 

payments as (

   select * from {{ ref('stg_payments') }}

),
 
payments_to_usd_currency as (
   
   select
    ref_id,
    created_at,
    external_ref_id,
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
   group by 1,2,3,4,5,6,7,8,9,10,11,12,13

),

unified_data as (
    select ref_id, created_at, external_ref_id, state, country, currency, round(usd_amount, 2) as usd_amount
    from (
        select ref_id, created_at, external_ref_id, state, country, currency, CAD_amount / cad AS usd_amount
        from payments_to_usd_currency
        where currency = 'CAD'
        union all
        select ref_id, created_at, external_ref_id, state, country, currency, EUR_amount / eur AS usd_amount
        from payments_to_usd_currency
        where currency = 'EUR'
        union all
        select ref_id, created_at, external_ref_id, state, country, currency, MXN_amount / mxn AS usd_amount
        from payments_to_usd_currency
        where currency = 'MXN'
        union all
        select ref_id, created_at, external_ref_id, state, country, currency, USD_amount / usd AS usd_amount
        from payments_to_usd_currency
        where currency = 'USD'
        union all
        select ref_id, created_at, external_ref_id, state, country, currency, SGD_amount / sgd AS usd_amount
        from payments_to_usd_currency
        where currency = 'SGD'
        union all
        select ref_id, created_at, external_ref_id, state, country, currency, AUD_amount / aud AS usd_amount
        from payments_to_usd_currency
        where currency = 'AUD'
        union all
        select ref_id, created_at, external_ref_id, state, country, currency, GBP_amount / gbp AS usd_amount
        from payments_to_usd_currency
        where currency = 'GBP'
)),

final_with_chargeback as (
    select 
    u.*,
    c.chargeback 
    from unified_data u
    full outer join {{ ref('stg_chargeback') }} c
    on c.external_ref_id = u.external_ref_id 
)

select * from final_with_chargeback