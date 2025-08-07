
/*
Both procedures need to be retrieved from Git and loaded.

Provide Index details of the table, missing indexes, Usage Stats, Operation stats, Size of the index, Patch latch wait,
EXEC dbo.sp_BlitzIndex @DatabaseName = 'CustomerFeedback', @SchemaName = 'dbo', @TableName = 'Customers';

Provide warnings, queryplan, missing indexes, Implicit conversion, cached execution plan, Used memory, Used cpu
  EXEC sp_BlitzCache @QueryFilter = '[dbo].[sp_AggregateFeedbacks_By_MetadataAndSentiment]';
  EXEC sp_BlitzCache @QueryFilter = '[dbo].[sp_SearchFeedbacks_ByKeyword]'
  EXEC sp_BlitzCache @QueryFilter = '[dbo].[usp_AggregateFeedbackByField]'
*/