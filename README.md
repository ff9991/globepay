# Globepay

## Preliminary Data Exploration
As a first step in our task, it is necessary to clarify what business questions we'd like to answer and how we can better prepare out data for a later stage of actual data modelling and subsequent enabled data analysis capabilities.

The few steps I would undertake are the following:

1. Check the table structures: Examine the columns in each table to understand the available data and their corresponding data types. Ensure that the columns are correctly aligned with the expected data and add aliases or better naming conventions where relevant.

2. Explore data quality: Validate the data quality by checking for missing values, data types, and potential data inconsistencies. Ensure that the data is complete and accurate to avoid issues during analysis.

3. Understand the meaning of each column: Review the column names and their descriptions to understand the information they represent. This will help in interpreting the data and formulating meaningful queries. For example, in our source tables it is clear that we might need to be aware of the fact that the _state_ column is going to affect the real amount of money that is flowing through the system and being paid by the customers for our final metrics and insights to be valuable.

4. Perform basic statistical analysis: Compute basic statistics such as counts, minimum and maximum values, averages, and standard deviations for numeric columns. This analysis can provide insights into the distribution and range of values in the dataset at a glance.

5. Identify unique values: Identify unique values in categorical columns to understand the diversity and variety of data in each column. This can help in identifying potential patterns or anomalies.

6. Analyze temporal data: We have columns representing dates or timestamps, so we want to analyze them to understand the temporal patterns and trends. This can involve examining the distribution of dates, identifying trends over time, and detecting any seasonality or cyclic patterns.

7. Visualize the data: Create visualizations such as histograms, bar charts, line charts, or scatter plots to gain a visual understanding of the data distribution, relationships between variables, and any potential outliers or trends that can be already spotted without any further data modelling and to orient the decisions about what to focus on in the next stages of data modelling and analysis.

8. Identify potential relationships: Look for relationships between variables by exploring correlations, cross-tabulations, or aggregations. This can provide insights into the data and help in formulating further analysis questions based on some occurrences seeming to be more than just random at a first analysis.
   
10. One other minor thing to be aware of is we have rates for the SGD currency, but we don't have any payment actually happening in that currency.

## Summary of your model architecture

To accomplish this step I have followed the typical dbt best practices and organised into three different steps to process to transform the data and make it useful for further data analysis and unlocking useful insights and recommendations for the business itself.

**Staging Layer**

Firstly, we reproduce a staging layer where we apply the initial cleaning stage for further data modelling in downstream tables and remove unnecessary data that is not adding much value to the project nor enriching the data with more information than what we have like the source field.
We materialise this layer as views, since we don't need to waste data warehouse storage space on components which are only necessary to update downstream models with the freshest data available.
As per dbt best practices, every staging model will only have a single source of data.

**Intermediate Layer**

This is where we should be narrowing down the amount of datasets we are pulling data from, finish cleaning up the naming conventions and apply all of the necessary aggregations and functions to obtain the numbers and metrics we'd like to query from at the BI layer in the next step. In our case I believe one Intermediate layer is sufficient to obtain a clean and straighforward final data model immediately after that.

**Marts Layer**

Here is the layer that is going to be surfaced to business stakeholders and it is about showing a clear table (materialised as such for better performance) and making it as simple as possible for less technical stakeholders to be able to derive the insights they have asked for at the beginning of the project.

## Lineage Graphs

<img width="1304" alt="image" src="https://github.com/ff9991/globepay/assets/73344026/c2e721e9-7ec0-4462-b90d-d4b1e0ef3f60">


## Tips around macros, data validation, and documentation
Based on the data we have, it is very useful to leverage a macro to convert our amount in different currencies to one currency of reference (usually the primary currency is the one where a company is listed or has its primary market).

Macros are very useful in this context, as we have seen to simplify the conversion of the currency values to the usd value in order to have a uniform benchmark in our final layer. However, there would be more options to also simplify further another step when unifying the different subqueries to obtain a unified CTE to have all of the values in the usd currency. 

Another important aspect would be to implement data source freshness tests through implementing a timestamp to record when the new records are being loaded into our data warehouse. In our solution this is not necessary, as we don't have a constant stream of data coming in. Instead, we have csv files that can be loaded as seeds and then used as sources in our dbt environment. 
It is crucial to set up the tests to check that the values we are ingesting are in line with what we'd expect.

We have also added some basic tests for our source data, but more could be done if we were given more inputs about other business processes and nuances to take into account.

For what concerns documentation we'd need firstly to clarify our technical and business stakeholders to understand the format in which we can explain the work done through this data modelling project.
Dbt is great when it comes to describing databases, schemas, tables / sources / models and fields for other technical users to get up to speed quickly and leverage the previous work of other analytics engineers.
However, we should also bear in mind the necessity to explain the business questions we are trying to answer through certain data transformation processes and aggregations that we are implementing in downstream models.

## Next potential steps
Finally, if I had had more time I would have probably gone into more detail for what concerns the documentation of downstream models and we could have started thinking about some ways of automating the data ingestion and downstream models' refreshes through implementing dbt Jobs or architecting other data orchestration solutions such as Airflow or Prefect.

## Part 2

1. The Acceptance Rate is based on the following SQL query and it could be further aggregated based on the time granularity the business is interested in looking into more closely:

![image](https://github.com/ff9991/globepay/assets/73344026/334c543d-9226-4254-8a65-961e392ef54e)

These are the results in terms of Acceptance Rate at a Monthly-level aggregation:

<img width="673" alt="image" src="https://github.com/ff9991/globepay/assets/73344026/bf3d7c08-cb8b-4036-a9c9-012ac8441927">


2. The following query obtains the list of the countries that had over time declined transactions for over USD 25M:

<img width="582" alt="image" src="https://github.com/ff9991/globepay/assets/73344026/fb1c9024-2b0e-4d5d-86f4-813324fa9f98">

The following chart shows the countries and the amount of their declined transactions in USD value:

<img width="408" alt="image" src="https://github.com/ff9991/globepay/assets/73344026/10d11e07-2ac4-4827-b770-cfbfefc459f6">

3. The following can give a list of all of the payments that have no chargeback, which I assume to be corresponding to the 'chargeback' column being 'FALSE'.
Through the same approach and final table we can count distinct these payments and add a date dimension in order to give more insights about percentages between how many payments have chargebacks or not over time and if there are seasonal patterns or outliers in specific circumstances of the year:

<img width="846" alt="image" src="https://github.com/ff9991/globepay/assets/73344026/0c62c781-c75d-400f-ab2b-2befbce9d91a">

<img width="682" alt="image" src="https://github.com/ff9991/globepay/assets/73344026/155ad7a3-aa2a-455a-bc87-bda7c95343e1">

An additional consideration could have been to check the percentage of transactions that have no chargeback and base more of the business decisions on this metric, in case there are thresholds considered not healthy for the business itself for example.
