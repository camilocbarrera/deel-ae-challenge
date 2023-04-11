{{-
    config(
         materialized='incremental',
         on_schema_change='fail',
         cluster_by=['_date_day','_date_time','external_ref']
    )
-}}

SELECT

     stg_globepay__acceptance_report._date_time        AS _date_time
   , _date_time::date                                  AS _date_day
   , hour( _date_time )                                AS _hour
   , stg_globepay__acceptance_report.country           AS country
   , stg_globepay__acceptance_report.external_ref      AS external_ref
   , stg_globepay__acceptance_report.status            AS status
   , stg_globepay__acceptance_report.source            AS source
   , stg_globepay__acceptance_report.ref               AS ref
   , stg_globepay__acceptance_report.state             AS state
   , stg_globepay__acceptance_report.cvv_provided      AS cvv_provided
   , stg_globepay__acceptance_report.amount            AS amount_lc
   , amount / CASE currency
     WHEN 'AUD' THEN aud
     WHEN 'CAD' THEN cad
     WHEN 'EUR' THEN eur
     WHEN 'GBP' THEN gbp
     WHEN 'MXN' THEN mxn
     WHEN 'SGD' THEN sgd
     WHEN 'USD' THEN usd
     END                                               AS amount_usd
   , stg_globepay__acceptance_report.currency          AS currency

   , stg_globepay__chargeback_report.chargeback_status AS chargeback_status
   , stg_globepay__chargeback_report.chargeback_source AS chargeback_source
   , stg_globepay__chargeback_report.is_chargeback     AS is_chargeback
   , current_timestamp                                 AS updated_at

FROM {{ ref('stg_globepay__acceptance_report' )}}
LEFT JOIN {{ ref('stg_globepay__chargeback_report') }} USING ( external_ref )
WHERE TRUE

{% if is_incremental() %}

  AND _date_time > (select max(_date_time) from {{ this }})

{% endif %}
