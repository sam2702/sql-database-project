USE [CustomerFeedback]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*
            ********Business Request*******  
   Aggregate feedback by rating, product, or other JSON fields
            *******************************

EXEC dbo.usp_AggregateFeedbackByField @Field = 'rating';
EXEC dbo.usp_AggregateFeedbackByField @Field = 'device';
EXEC dbo.usp_AggregateFeedbackByField @Field = 'location';
EXEC dbo.usp_AggregateFeedbackByField @Field = 'browser';
*/


CREATE OR ALTER   PROCEDURE [dbo].[usp_AggregateFeedbackByField]
    @Field NVARCHAR(25) = 'rating' -- Default aggregation by rating
AS
BEGIN
    SET NOCOUNT ON;

    IF @Field = 'rating'
    BEGIN
        SELECT 
            Rating AS AggregationField,
            COUNT(*) AS FeedbackCount
        FROM dbo.Feedbacks
        GROUP BY Rating;

        SELECT 'Aggregation by Rating executed successfully.' AS [Status];
    END
    ELSE
    BEGIN
        -- Sanitize JSON key
        DECLARE @JsonPath NVARCHAR(200) = '$.' + @Field;

        -- Dynamic SQL to aggregate by JSON field (like product, device, location)
        DECLARE @sql NVARCHAR(4000) = '
            SELECT 
                JSON_VALUE(Metadata, ''' + @JsonPath + ''') AS AggregationField,
                COUNT(*) AS FeedbackCount
            FROM Feedbacks
            GROUP BY JSON_VALUE(Metadata, ''' + @JsonPath + ''');
            
            SELECT ''Aggregation by JSON field [' + @Field + '] executed successfully.'' AS [Status];
        ';

          EXEC sp_executesql @sql, N'@JsonPath NVARCHAR(200)', @JsonPath = @JsonPath;
    END
END;

GO


