{{-
    config(
         materialized='incremental',
         unique_key='date_day',
         on_schema_change='fail',
    )
-}}

WITH rate_acceptance AS (

     SELECT
          _date_day                                                            AS _date_day
        , COUNT( DISTINCT CASE WHEN state = 'ACCEPTED' THEN external_ref END ) AS accepted
        , COUNT( DISTINCT CASE WHEN state = 'DECLINED' THEN external_ref END ) AS declined
        , COUNT( external_ref )                                                AS total

     FROM {{ ref('rpt_globepay') }}
     WHERE TRUE

{% if is_incremental() %}

  AND _date_day > (select max(_date_time) from {{ this }})

{% endif %}

     GROUP BY 1
)

SELECT
     _date_day               AS date_day
   , div0( accepted, total ) AS acceptance_rate

FROM rate_acceptance