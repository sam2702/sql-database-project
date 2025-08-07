-- ===================================================================
-- Script: create_fulltext_catalog.sql
-- Description: Creates full-text catalog and index on Feedbacks table
-- Author: Abdul Samath
-- Created: 2025-08-07
-- ===================================================================

-- Create Full-Text Catalog if it doesn't exist
IF NOT EXISTS (
    SELECT 1 
    FROM sys.fulltext_catalogs 
    WHERE name = 'FeedbacksFTCatalog'
)
BEGIN
    PRINT 'Creating Full-Text Catalog: FeedbacksFTCatalog'
    CREATE FULLTEXT CATALOG FeedbacksFTCatalog AS DEFAULT;
END
ELSE
BEGIN
    PRINT 'Full-Text Catalog already exists: FeedbacksFTCatalog'
END;

-- Create Full-Text Index on Feedbacks.FeedbackText if it doesn't exist
IF NOT EXISTS (
    SELECT 1 
    FROM sys.fulltext_indexes fti
    INNER JOIN sys.objects o ON fti.object_id = o.object_id
    WHERE o.name = 'Feedbacks'
)
BEGIN
    PRINT 'Creating Full-Text Index on Feedbacks(FeedbackText)'
    CREATE FULLTEXT INDEX ON Feedbacks(FeedbackText)
    KEY INDEX UX_FeedbackID
    ON FeedbacksFTCatalog;
END
ELSE
BEGIN
    PRINT 'Full-Text Index already exists on Feedbacks'
END;
