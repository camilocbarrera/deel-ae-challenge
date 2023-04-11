select  * from
    {{
metrics.calculate(
metric('amount_usd'),
grain='day',
dimensions=['country_code']

)
    }}