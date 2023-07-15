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

## Summary of your model architecture

To accomplish this step I have followed the typical dbt best practices and organised into three different steps to process to transform the data and make it useful for further data analysis and unlocking useful insights and recommendations for the business itself.



## Lineage Graphs



## Tips around macros, data validation, and documentation
Based on the data we have, it is very useful to leverage a macro to convert our amount in different currencies to one currency of reference (usually the primary currency is the one where a company is listed or has its primary market).

Another important aspect would be to implement data source freshness through implementing a timestamp to record when the new records are being loaded into our data warehouse. In our solution this is not necessary, as we don't have a constant stream of data coming in. Instead, we have csv files that can be loaded as seeds and then used as sources 

