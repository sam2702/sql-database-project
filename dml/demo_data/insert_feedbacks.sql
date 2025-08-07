-- ===================================================================
-- Script: insert_feedbacks.sql
-- Description: Generates 100+ sample feedback entries for testing
-- Author: Abdul Samath
-- Created: 2025-08-07
-- ===================================================================

-- Feedbacks table has columns:
-- FeedbackID (IDENTITY), CustomerID (FK), FeedbackText, Rating, Metadata (JSON)

DECLARE @i INT = 1;

WHILE @i <= 100
BEGIN
    INSERT INTO Feedbacks (CustomerID, FeedbackText, Rating, Metadata)
    VALUES (
        -- Random CustomerID between 1 and 10 (assuming 10 sample customers)
        FLOOR(RAND(CHECKSUM(NEWID())) * 10) + 1,  

        -- Feedback text with dynamic content
        CONCAT('Feedback entry number ', @i, ' is good but can be improved.'),

        -- Random Rating between 1 and 5
        FLOOR(RAND(CHECKSUM(NEWID())) * 5) + 1,

        -- JSON metadata
        JSON_QUERY('{
            "device": "mobile",
            "location": "India",
            "browser": "Chrome"
        }')
    );

    SET @i += 1;
END;







