# Customer Feedback Analysis Project (SQL-Based)
Analyze customer feedback using T-SQL with fast queries, smart JSON parsing, and sentiment tagging all in a performance-tuned SQL Server setup.

## 📂 Project Structure 

```
sql-database-project/
│
├── ddl/
│ └── Customers.sql
│ └── Feedbacks.sql
│ └── Staging_Feedbacks.sql
├── dml/demo_data
│ └── feedback_data.csv
│ └── Generate_Feedback_Data_Powershell_Script.ps1
│ └── Insert_customers.sql
│ └── Insert_feedbacks.sql
├── fulltext/
│ └── Create_fulltext_catalog.sql
│ └── Create_Index_Feedbacks.sql
├── indexes/
│ └── Create_Index_Feedbacks.sql
├── procedures/
│ └── dbo.sp_AggregateFeedbacks_By_MetadataAndSentiment.sql
│ └── dbo.sp_SearchFeedbacks_ByKeyword.sql
│ └── dbo.usp_AggregateFeedbackByField.sql
├── queries/
│ └── sp_BlitzIndex_setup.sql
└── README.md

```
## 📊 Features

- Load and analyze customer feedback records
- Extract sentiment from feedback text (positive/negative classification)
- Parse and aggregate JSON fields (e.g., `device`, `location`)
- Use dynamic SQL for flexible analysis
- Optimize queries with smart indexing strategies
- Integrate with [Brent Ozar’s](https://www.brentozar.com/) tools like `sp_BlitzIndex` and `sp_BlitzCache` for performance tuning.

## Sample Analysis

### Sentiment Classification

```sql
CASE
    WHEN FeedbackText LIKE '%good%' 
      OR FeedbackText LIKE '%excellent%' 
      ...
    THEN 'Positive'
    ELSE 'Negative'
END AS Sentiment

```
### Group by Product and Sentiment
```sql
SELECT 
    JSON_VALUE(Metadata, '$.device') AS Product,
    Sentiment,
    COUNT(*) AS FeedbackCount,
    ROUND(AVG(CAST(Rating AS FLOAT)), 2) AS AvgRating
FROM #FeedbackTemp
GROUP BY Product, Sentiment;

```
### Group by Dynamic JSON Field
```sql
EXEC AggregateByField @Field = 'location';

```

## Indexing Strategy
To optimize frequent filtering, aggregation, and search operations:
- Clustered Index: FeedbackID
- Non-Clustered Indexes:
- Rating
- CreatedDate + Rating + Metadata
- CustomerID + CreatedDate (with includes)

Indexes are created only if they don't already exist using IF NOT EXISTS logic