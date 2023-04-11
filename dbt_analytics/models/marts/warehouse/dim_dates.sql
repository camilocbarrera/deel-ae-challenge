WITH dates AS (
     SELECT
          DATEADD( DAY, ROW_NUMBER( ) OVER (ORDER BY NULL), '2017-12-31' )::DATE AS _date_day
        , DATE_TRUNC( 'day', _date_day )                                         AS day
        , DATE_TRUNC( 'month', _date_day )                                       AS month
        , DATE_TRUNC( 'week', _date_day )                                        AS week
        , DATE_TRUNC( 'year', _date_day )                                        AS year
        , WEEK( _date_day )                                                      AS week_num
        , DAYNAME( _date_day )                                                   AS dayname
        , DAYOFWEEK( _date_day )                                                 AS day_of_week
     FROM TABLE (GENERATOR( ROWCOUNT => ( 3000 ) ))
)
SELECT *, COUNT( DISTINCT _date_day ) OVER (PARTITION BY month) days_of_month
FROM dates