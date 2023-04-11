select  * from
    {{
metrics.calculate(
metric('revenue'),
grain='day',
dimensions=['country_code']

)
    }}