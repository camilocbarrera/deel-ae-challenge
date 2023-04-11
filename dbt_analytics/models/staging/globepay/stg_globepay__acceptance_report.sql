{{-
    config(
         materialized='incremental',
         unique_key='surrogate_key',
         on_schema_change='fail',
         incremental_strategy='merge'
    )
-}}


WITH acceptance_report AS (
     SELECT *
     FROM {{ source('RAW_GLOBEPAY','globepay_acceptance_report_globepay_acceptance_report') }}
)
SELECT
    {{ dbt_utils.generate_surrogate_key( ['external_ref','date_time']) }} as surrogate_key
   , external_ref                   AS external_ref
   , status                         AS status
   , source                         AS source
   , ref                            AS ref
   , date_time::DATETIME            AS _date_time
   , state                          AS state
   , cvv_provided                   AS cvv_provided
   , amount                         AS amount
   , country                        AS country
   , currency                       AS currency
   , rates                          AS rates
   ,_fivetran_synced                AS _fivetran_synced
   -- extract all keys in rates structure
   {{-
    flatten_json(
    model_name=source('RAW_GLOBEPAY','globepay_acceptance_report_globepay_acceptance_report'),
    json_column='rates'
    )
   }}

FROM acceptance_report
WHERE TRUE

{% if is_incremental() %}

  AND _date_time > (select max(_date_time) from {{ this }})

{% endif %}
