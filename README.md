# Deel Challenge

<!-- TOC -->
* [Bussines Context](#bussines-context)
* [Assignment](#assignment)
* [Solution](#solution)
  * [Architecture](#architecture)
  * [Data Engineering](#data-engineering)
  * [Data Modeling](#data-modeling)
    * [DBT Structure](#dbt-structure)
    * [DAG Lineage](#dag-lineage)
    * [OLAP Modeling](#olap-modeling)
    * [Model Deployment in Snowflake](#model-deployment-in-snowflake)
* [Reporting](#reporting)
  * [Report  📊](#report-)
* [Part 2: Query implementation](#part-2-query-implementation)
<!-- TOC -->

# Bussines Context
>(...) Deel has connectivity into Globepay using their API. Deel clients provide their credit and debit details within the Deel web application, Deel systems pass those credentials along with any relevant transaction details to Globepay for processing.

# Assignment

> For the first part of the challenge, please ingest and model the source data

# Solution

## Architecture
![image](https://user-images.githubusercontent.com/85809276/231124679-2c78ea08-80fc-4b25-b62f-457d85375104.png)

To solve this case, I will try to use best architecture practices and standards to carry out the data extraction, loading and transformation process. With a Modern Data Stack.

A minimalist architecture is proposed through Snowflake, Fivetran, PowerBI.

Why Snowflake? In my experience, it is the most practical tool, quick to implement and comes with everything we need to focus on what is important, data analysis.
> Snowflake is an analytics data warehouse delivered as software as a service (SaaS). Snowflake’s data warehouse does not rely on an existing database or “big data” software platform like Hadoop. Snowflake’s data warehouse uses a new SQL database engine with a unique architecture designed for the cloud.

For more information: https://www.snowflake.com/workloads/data-warehouse-modernization/

## Data Engineering
This process was carried out through Fivetran, to invest more time in modeling instead ETL.
Fivetran is a valuable tool in data engineering due to its data source agnosticism, automated data pipelines, real-time data syncing, easy data transformation, scalability and reliability, and monitoring/alerting capabilities. It simplifies data integration, saves time and effort, ensures data accuracy and timeliness, and provides efficient and robust data pipelines for data engineers. For more information: https://www.fivetran.com/teams/data-engineering
![image](https://user-images.githubusercontent.com/85809276/231126711-eb0ab020-6a33-4a07-9917-dbdc4d5640ae.png)

## Data Modeling
The data modeling process will be done with [DBT](https://www.getdbt.com/product/what-is-dbt/) (Data build tool)

> dbt is an open source command line tool that helps analysts and engineers transform the data in their warehouse more effectively. It started at RJMetrics in 2016 as a solution to add basic transformation capabilities to Stitch.

For modeling, it is proposed to have a decoupled distribution, which allows scalability in any direction, low coupling and high cohesion of the models. It will be done as shown below.

![image](https://user-images.githubusercontent.com/85809276/231127215-d8db4c69-749e-4da0-a235-10c00068d203.png)

In each stage, models were built with their respective tests, snapshots, metrics. separating each layer. For more detail check the models/marts directory
### DBT Structure
As presented in the initial image, the architecture is completely modular. In order to be able to reuse the components and maintain low cohesion and high coupling.
![image](https://user-images.githubusercontent.com/85809276/231128373-8331fb6f-4a95-4121-b093-1ed229c691e1.png)

### DAG Lineage
The data flow, as shown below in each stage, from the data sources, Stage, Warehouse and Reports. A metric was also created to adapt the values of the usd amount and to be able to group them in different dimensions as a semantic layer.
![dbt_dag](https://user-images.githubusercontent.com/85809276/231129424-6fb9cca9-7f71-46b6-b120-ecb837595aef.gif)

### OLAP Modeling
> OLAP (online analytical processing) is a computing method that enables users to easily and selectively extract  and query data in order to analyze it from different points of view. OLAP business intelligence queries often aid in trends analysis, financial reporting, sales forecasting, budgeting and other planning purposes.
In order to optimize the use of the Warehouse Layer and avoid data redundancy, an OLAP model is proposed, in order to obtain data between different tables, in a FN1 and FN2.

![olap_modeling_deel](https://user-images.githubusercontent.com/85809276/231130717-c39b4241-3eb9-42da-be0b-61037df09c2c.png)

### Model Deployment in Snowflake
Deployed in a dev and prod environment.
5 table models, 4 incremental models, 1 snapshot, 43 tests in 0 hours 1 minutes and 44.75 seconds (104.75s) 
![image](https://user-images.githubusercontent.com/85809276/231131795-7945cf1f-7719-44c4-92a7-245f082c9780.png)

Prefix used to differentiate the physical environments
![image](https://user-images.githubusercontent.com/85809276/231132694-9ca0c1c0-5138-48d3-93d8-c1dc34e391d5.png)

# Reporting
The reporting layer will be done through Power BI

One of the advantages of using an analytical database is the ease of connecting through reporting tools such as Power BI.

Power bi has a native connector that allows us to do this.


## Report  📊

In this URL, you can find the report Online
The main idea of this report is to be able to answer questions about the business context.
Due to the semantic layer in dbt, it is possible to create and document metrics so that they are physically materialized in the warehouse. The advantage of this is that we can control the way certain measures are added and calculated.

<iframe title="deel-report - Page 1" width="600" height="373.5" src="https://app.powerbi.com/view?r=eyJrIjoiYmQ3MGM0OTEtOGQyZi00ZDdjLTk1ZjEtNDg3OTc2Mjc1N2RiIiwidCI6Ijc0YzBjMjUwLTFjNzctNDA1ZC05YjFlLTlhYzFmNTA4YWJlMyIsImMiOjR9" frameborder="0" allowFullScreen="true"></iframe>

# Part 2: Query implementation

- [x]  What is the acceptance rate over time?

```sql
WITH rate_acceptance AS (

     SELECT
          _date_day                                                            AS _date_day
        , COUNT( DISTINCT CASE WHEN state = 'ACCEPTED' THEN external_ref END ) AS accepted
        , COUNT( DISTINCT CASE WHEN state = 'DECLINED' THEN external_ref END ) AS declined
        , COUNT( external_ref )                                                AS total

     FROM deel_analytics.prod_reporting.rpt_globepay
     GROUP BY 1
)
SELECT
     _date_day               AS _date_day
   , div0( accepted, total ) AS acceptance_rate
FROM rate_acceptance
```
**Result**

| \_DATE\_DAY | ACCEPTANCE\_RATE |
| :--- | :--- |
| 2019-01-01 | 0.800000 |
| 2019-01-02 | 0.800000 |
| 2019-01-03 | 0.666666 |
| 2019-01-04 | 0.700000 |
| 2019-01-06 | 0.733333 |
| 2019-01-07 | 0.700000 |
| 2019-01-09 | 0.633333 |
| 2019-01-12 | 0.666666 |
| 2019-01-11 | 0.666666 |
| 2019-01-13 | 0.666666 |


- [x]  List the countries where the amount of declined transactions went over $25M
```SQL

SELECT
     country_code      AS country_code
   , SUM( amount_usd ) AS amount_usd_
FROM deel_analytics.prod_reporting.rpt_globepay
WHERE TRUE
  AND state = 'DECLINED'
GROUP BY 1
HAVING amount_usd_ >= 25000000
ORDER BY 2 DESC

```
**Result**

| COUNTRY\_CODE | AMOUNT\_USD\_ |
| :--- | :--- |
| FR | 32628785.93464652 |
| UK | 27489496.68577282 |
| AE | 26335152.43 |
| US | 25125669.78 |

- [x]  Which transactions are missing chargeback data?
```SQL
SELECT count( 1 )
FROM deel_analytics.prod_reporting.rpt_globepay
WHERE TRUE
  AND chargeback_source IS NULL
```
**Result**
The two data sources have a 1:1 correspondence.

| COUNT\( 1 \) |
| :--- |
| 0 |


[//]: # (# Set up dbt project)
[//]: # (<img width="545" alt="image" src="https://user-images.githubusercontent.com/85809276/231037852-a1b28851-5c17-4f5d-a171-9fc4a5e64145.png">)
