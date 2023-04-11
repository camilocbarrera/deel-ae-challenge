{{-
    config(
         materialized='incremental',
         unique_key='surrogate_key',
         on_schema_change='fail',
         incremental_strategy='merge'
    )
-}}

WITH chargeback_report     AS (
     SELECT *
     FROM {{ source('RAW_GLOBEPAY','globepay_chargeback_report_globepay_chargeback_report') }}

)

SELECT
   {{ dbt_utils.generate_surrogate_key( ['external_ref']) }} AS surrogate_key
   , external_ref                                            AS external_ref
   , status                                                  AS chargeback_status
   , source                                                  AS chargeback_source
   , chargeback                                              AS is_chargeback
   ,_fivetran_synced                                         AS _fivetran_synced
FROM chargeback_report