# Customer Feedback Analysis Project (SQL-Based)
This project is designed to analyze customer feedback data using T-SQL in a structured, index-optimized SQL Server environment. 
It demonstrates expertise in query performance, JSON data parsing, sentiment classification, and aggregation techniques for business insights.

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

