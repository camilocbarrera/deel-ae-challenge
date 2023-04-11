
SELECT DISTINCT
     country           AS country_code
   , currency          AS currency_code
   , current_timestamp AS updated_at
FROM {{ ref('stg_globepay__acceptance_report') }}
