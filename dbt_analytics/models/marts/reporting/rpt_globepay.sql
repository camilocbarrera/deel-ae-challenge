SELECT
     fct_globepay_report._date_time        AS _date_time
   , fct_globepay_report._hour             AS _hour
   , fct_globepay_report._date_day         AS _date_day
   , dim_dates.month                       AS month
   , dim_dates.week                        AS week
   , dim_dates.year                        AS year
   , dim_dates.week_num                    AS week_num
   , dim_dates.dayname                     AS dayname
   , dim_dates.day_of_week                 AS day_of_week
   , dim_dates.days_of_month               AS days_of_month
   , fct_globepay_report.country_code      AS country_code
   , dim_countries.currency_code           AS currency_code
   , fct_globepay_report.external_ref      AS external_ref
   , fct_globepay_report.status            AS status
   , fct_globepay_report.source            AS source
   , fct_globepay_report.ref               AS ref
   , fct_globepay_report.state             AS state
   , fct_globepay_report.cvv_provided      AS cvv_provided
   , fct_globepay_report.amount_lc         AS amount_lc
   , fct_globepay_report.amount_usd        AS amount_usd
   , fct_globepay_report.chargeback_status AS chargeback_status
   , fct_globepay_report.chargeback_source AS chargeback_source
   , fct_globepay_report.is_chargeback     AS is_chargeback
   , current_timestamp                     AS updated_at

FROM {{ ref('fct_globepay_report') }}
JOIN {{ ref('dim_dates') }} USING ( _date_day )
JOIN {{ ref('dim_countries') }} USING ( country_code )
