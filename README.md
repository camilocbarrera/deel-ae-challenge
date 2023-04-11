# Deel Challenge

<!-- TOC -->
* [Bussines Context](#bussines-context)
* [Assignment](#assignment)
* [Solution](#solution)
  * [Architecture](#architecture)
* [Set up dbt project](#set-up-dbt-project)
<!-- TOC -->

# Bussines Context
>(...) Deel has connectivity into Globepay using their API. Deel clients provide their credit and debit details within the Deel web application, Deel systems pass those credentials along with any relevant transaction details to Globepay for processing.

# Assignment

> For the first part of the challenge, please ingest and model the source data

# Solution

## Architecture

To solve this case, I will try to use best architecture practices and standards to carry out the data extraction, loading and transformation process.

A minimalist architecture is proposed through Snowflake.

Why Snowflake? In my experience, it is the most practical tool, quick to implement and comes with everything we need to focus on what is important, data analysis.
“Snowflake is an analytics data warehouse delivered as software as a service (SaaS). Snowflake’s data warehouse does not rely on an existing database or “big data” software platform like Hadoop. Snowflake’s data warehouse uses a new SQL database engine with a unique architecture designed for the cloud.”
For more information: https://www.snowflake.com/workloads/data-warehouse-modernization/

# Set up dbt project
<img width="545" alt="image" src="https://user-images.githubusercontent.com/85809276/231037852-a1b28851-5c17-4f5d-a171-9fc4a5e64145.png">
