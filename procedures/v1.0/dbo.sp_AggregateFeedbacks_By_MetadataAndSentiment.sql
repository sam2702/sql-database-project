
/*
            ********Business Request*******  
    Filter/aggregate feedbacks by JSON metadata (e.g., product, sentiment).
            *******************************

EXEC dbo.sp_AggregateFeedbacks_By_MetadataAndSentiment;
EXEC dbo.sp_AggregateFeedbacks_By_MetadataAndSentiment @Product = 'mobile';
EXEC dbo.sp_AggregateFeedbacks_By_MetadataAndSentiment @Sentiment = 'Positive';
EXEC dbo.sp_AggregateFeedbacks_By_MetadataAndSentiment @Product = 'mobile', @Sentiment = 'Negative';

*/


CREATE OR ALTER PROCEDURE sp_AggregateFeedbacks_By_MetadataAndSentiment
    @Product NVARCHAR(100) = NULL,     -- Optional filter for product (device)
    @Sentiment NVARCHAR(20) = NULL     -- Optional filter for sentiment (Positive/Negative)
AS
BEGIN
    SET NOCOUNT ON;

    -- Step 1: Create temp table with derived fields
    SELECT 
        FeedbackID,
        CustomerID,
        FeedbackText,
        Rating,
        CreatedDate,
        JSON_VALUE(Metadata, '$.device') AS [Product],  -- Extract 'device' as Product

        -- Sentiment classification based on keywords
        CASE
            WHEN FeedbackText LIKE '%good%' 
              OR FeedbackText LIKE '%excellent%' 
              OR FeedbackText LIKE '%happy%' 
              OR FeedbackText LIKE '%satisfied%' 
              OR FeedbackText LIKE '%great%' 
              OR FeedbackText LIKE '%support%' 
            THEN 'Positive'
            ELSE 'Negative'
        END AS Sentiment
    INTO #FeedbackTemp
    FROM Feedbacks;

    -- Step 2: Apply filters and aggregate
    SELECT 
        Product,
        Sentiment,
        COUNT(*) AS FeedbackCount,
        ROUND(AVG(CAST(Rating AS FLOAT)), 2) AS AvgRating
    FROM #FeedbackTemp
    WHERE (@Product IS NULL OR [Product] = @Product)
      AND (@Sentiment IS NULL OR Sentiment = @Sentiment)
    GROUP BY [Product], Sentiment;

    DROP TABLE #FeedbackTemp;
END;
GO

