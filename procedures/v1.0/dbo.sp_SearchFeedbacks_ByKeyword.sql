/*
            ********Business Request*******  
        Search feedbacks for keywords/phrases (Full-Text Search).
            *******************************
EXEC dbo.sp_SearchFeedbacks_ByKeyword @SearchPhrase = 'excellent';
EXEC dbo.sp_SearchFeedbacks_ByKeyword @SearchPhrase = '"average"';
EXEC dbo.sp_SearchFeedbacks_ByKeyword @SearchPhrase = '("could be improved")';


*/

CREATE OR ALTER PROCEDURE dbo.sp_SearchFeedbacks_ByKeyword
    @SearchPhrase NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        FeedbackID,
        CustomerID,
        FeedbackText,
        Rating,
        JSON_VALUE(Metadata, '$.device') AS [Product],
        CreatedDate
    FROM dbo.Feedbacks
    WHERE CONTAINS(FeedbackText, @SearchPhrase);
END;
GO

