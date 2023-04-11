{% snapshot transactions_snapshot %}

{{
    config(
      target_schema='snapshots',
      unique_key='external_ref',

      strategy='timestamp',
      updated_at='_fivetran_synced'
    )
}}

SELECT * FROM {{ source('RAW_GLOBEPAY','globepay_acceptance_report_globepay_acceptance_report') }}

{% endsnapshot %}