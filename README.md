# Customer Feedback Analysis Project (SQL-Based)
Analyze customer feedback using T-SQL with fast queries, smart JSON parsing, and sentiment tagging all in a performance-tuned SQL Server setup.

## Project Structure 

```
sql-database-project/
│
├── ddl/
│ ├── Customers.sql
│ ├── Feedbacks.sql
│ └── Staging_Feedbacks.sql
├── dml/demo_data
│ ├── feedback_data.csv
│ ├── Generate_Feedback_Data_Powershell_Script.ps1
│ ├── Insert_customers.sql
│ └── Insert_feedbacks.sql
├── fulltext/
│ ├── Create_fulltext_catalog.sql
│ └── Create_Index_Feedbacks.sql
├── indexes/
│ └── Create_Index_Feedbacks.sql
├── procedures/
│ ├── dbo.sp_AggregateFeedbacks_By_MetadataAndSentiment.sql
│ ├── dbo.sp_SearchFeedbacks_ByKeyword.sql
│ └── dbo.usp_AggregateFeedbackByField.sql
├── queries/
│ └── External_Source_Performance_Tuning_queries.sql
├── README.md

```
## Features

- Load and analyze customer feedback records
- Extract sentiment from feedback text (positive/negative classification)
- Parse and aggregate JSON fields (e.g., `device`, `location`)
- Use dynamic SQL for flexible analysis
- Optimize queries with smart indexing strategies
- Integrate with [Brent Ozar’s](https://www.brentozar.com/) tools like `sp_BlitzIndex` and `sp_BlitzCache` for performance tuning.

## Querying - Reporting

### Search feedbacks for keywords/phrases (Full-Text Search)
```sql
    SELECT 
        FeedbackID,
        CustomerID,
        FeedbackText,
        Rating,
        JSON_VALUE(Metadata, '$.device') AS Product,
        CreatedDate
    FROM dbo.Feedbacks
    WHERE CONTAINS(FeedbackText, @SearchPhrase);

```
### Stored Procedure Logic: sp_SearchFeedbacks_ByKeyword
```mermaid
flowchart TD
    A[Start: Execute sp_SearchFeedbacks_ByKeyword] --> B[Input: @SearchPhrase]
    B --> C[Perform Full-Text Search on FeedbackText using CONTAINS]
    C --> D[Extract JSON field 'device' as Product]
    D --> E[Return FeedbackID, CustomerID, FeedbackText, Rating, Product, CreatedDate]
    E --> F[End]

```
### Aggregate feedback by rating, product, or other JSON fields
```sql
EXEC dbo.usp_AggregateFeedbackByField @Field = 'rating';
EXEC dbo.usp_AggregateFeedbackByField @Field = 'device';
EXEC dbo.usp_AggregateFeedbackByField @Field = 'location';
EXEC dbo.usp_AggregateFeedbackByField @Field = 'browser';

```
### Stored Procedure Logic: usp_AggregateFeedbackByField
```mermaid
flowchart TD
    A[Start: Execute usp_AggregateFeedbackByField] --> B{Is @Field = 'rating'?}
    B -- Yes --> C[Aggregate by Rating]
    C --> D[Return status message for Rating]
    B -- No --> E[Build JSON path from @Field]
    E --> F[Build dynamic SQL using JSON_VALUE]
    F --> G[Execute dynamic SQL]
    G --> H[Return status message for JSON field]
    D --> I[End]
    H --> I 

```
### Filter/aggregate feedbacks by JSON metadata (e.g., product, sentiment)
```sql
SELECT 
    JSON_VALUE(Metadata, '$.device') AS Product,
    Sentiment,
    COUNT(*) AS FeedbackCount,
    ROUND(AVG(CAST(Rating AS FLOAT)), 2) AS AvgRating
FROM #FeedbackTemp
GROUP BY Product, Sentiment;

```
### Stored Procedure Logic: sp_AggregateFeedbacks_By_MetadataAndSentiment
```mermaid
flowchart TD
    A[Start: Execute sp_AggregateFeedbacks_By_MetadataAndSentiment] --> B[Extract device from JSON: Product]
    B --> C[Classify Sentiment from FeedbackText]
    C --> D[Store data in #FeedbackTemp]
    D --> E{Apply Filters}
    E -- Product/Sentiment Filter --> F[Group By Product, Sentiment]
    F --> G[Calculate FeedbackCount and AvgRating]
    G --> H[Return Result Set]
    H --> I[Drop Temp Table]
    I --> J[End]
```
### Import feedback data from CSV/JSON into the database
```mermaid
erDiagram
    Staging_Feedbacks {
        int CustomerID
        string FeedbackText
        int Rating
        datetime CreatedDate
        string Metadata
    }

    Feedbacks {
        int FeedbackID PK
        int CustomerID
        string FeedbackText
        int Rating
        datetime CreatedDate
        string Metadata
    }

    Staging_Feedbacks ||--o{ Feedbacks : deduplicated_merge
```
### PowerShell ETL Flowchart
```mermaid
flowchart TD
    A[Start ETL Script] --> B[Set Configuration Variables]
    B --> C[Load CSV file]
    C --> D{Is data loaded?}
    D -- No --> X[Log: No data found, Exit]
    D -- Yes --> E[Open SQL DB Connection]
    E --> F[Loop over each row]
    F --> G[Insert into Staging_Feedbacks]
    G --> H[Log total rows inserted]
    H --> I[Merge Staging_Feedbacks into Feedbacks -deduplication]
    I --> J[Log inserted count]
    J --> K[Truncate Staging_Feedbacks]
    K --> Z[Close DB Connection, End]

```
### Indexing Strategy
To optimize frequent filtering, aggregation, and search operations:
#### Clustered Index: 
- FeedbackID
#### Non-Clustered Indexes:
- Rating
- CreatedDate + Rating 
- CustomerID + CreatedDate (with includes)
Indexes are created only if they don't already exist using IF NOT EXISTS logic

### Performance Tools
Included:
- sp_BlitzIndex – Identify missing or unused indexes
- sp_BlitzCache – Detect slow-running queries
These scripts are available in the queries/ThirdParty_performancetuning.sql file.

### How to Run 
1. Open SSMS and connect to your SQL Server instance
2. Create the database:

```sql
CREATE DATABASE CustomerFeedback;
USE CustomerFeedback;
```
3. Run create_tables.sql and insert_sample_data.sql
4. Execute analysis and Group by scripts
5. Review performance using sp_BlitzIndex and sp_BlitzCache

---

## Use Cases (Based on Project Requirements)
This project is designed to demonstrate practical and advanced SQL Server capabilities aligned with real-world enterprise needs:

### 1. Search Feedbacks for Keywords/Phrases
- Utilize **Full-Text Search** for efficient retrieval of customer feedbacks containing specific keywords or phrases.
- Enables quick identification of positive or negative sentiment based on text content.

### 2. Filter and Aggregate Using JSON Metadata
- Leverage `JSON_VALUE()` to extract fields (like `device`, `location`, etc.) from JSON metadata.
- Enable dynamic filtering and grouping based on flexible metadata fields without schema changes.

### 3. Aggregate Feedback by Rating, Product, or JSON Fields
- Perform grouping and aggregation based on both traditional columns (like `Rating`) and JSON properties.
- Useful for deriving high-level insights (e.g., average rating by product or location).

### 4. Database Normalization and Indexing
- Ensure normalized schema design with appropriate use of **clustered** and **non-clustered indexes**.
- Avoid performance bottlenecks by indexing search and filter fields, including JSON-based access paths.

### 5. Script Quality and Idempotency
- Scripts follow **best practices** in terms of safety:
  - `IF NOT EXISTS` conditions to avoid re-creation errors.
  - Consistent naming and modular approach.
  - Reusable stored procedures for dynamic analysis.

### 6. Error Handling & Defensive SQL
- Dynamic SQL is properly sanitized to avoid injection and syntax issues.
- Error messages and execution statuses are returned clearly.

### 7. Automation & DevOps Mindset
- Ready for integration into DevOps pipelines:
  - Organized folder structure
  - Versioned scripts
  - Reproducible from source control

### 8. Query Performance and Clarity
- Queries are written with:
  - Clear structure and indentation
  - Execution plans tested with `sp_BlitzCache`
  - Index usage reviewed with `sp_BlitzIndex`

### 9. Documentation & Code Readability
- Code is clean, commented, and readable.
- Documentation includes clear explanations of logic and transformation steps.
- Easy for new developers or reviewers to understand and extend.
---
## Tools Used
- SQL Server 2022
- Git / GitHub
- SQL Server Management Studio (SSMS)
---
## Author
Abdul Samath
