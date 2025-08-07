USE [CustomerFeedback];
GO

-- Drop indexes if they exist
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'UX_FeedbackID' AND object_id = OBJECT_ID('dbo.Feedbacks'))
    DROP INDEX [UX_FeedbackID] ON [dbo].[Feedbacks];
GO

IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Feedbacks_SearchSupport_Indx2' AND object_id = OBJECT_ID('dbo.Feedbacks'))
    DROP INDEX [IX_Feedbacks_SearchSupport_Indx2] ON [dbo].[Feedbacks];
GO

IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Feedbacks_Rating_indx2' AND object_id = OBJECT_ID('dbo.Feedbacks'))
    DROP INDEX [IX_Feedbacks_Rating_indx2] ON [dbo].[Feedbacks];
GO

IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Feedbacks_Metadata_Product_Rating_Indx2' AND object_id = OBJECT_ID('dbo.Feedbacks'))
    DROP INDEX [IX_Feedbacks_Metadata_Product_Rating_Indx2] ON [dbo].[Feedbacks];
GO

-- Recreate indexes
CREATE NONCLUSTERED INDEX [IX_Feedbacks_Metadata_Product_Rating_Indx2] ON [dbo].[Feedbacks]
(
    [CreatedDate] ASC,
    [Rating] ASC
)
INCLUDE([CustomerID],[FeedbackID],[Metadata],[FeedbackText])
WITH (
    PAD_INDEX = OFF,
    STATISTICS_NORECOMPUTE = OFF,
    SORT_IN_TEMPDB = on,
    DROP_EXISTING = OFF,
    ONLINE = OFF,
    ALLOW_ROW_LOCKS = ON,
    ALLOW_PAGE_LOCKS = ON,
    OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
) ON [PRIMARY];
GO

CREATE NONCLUSTERED INDEX [IX_Feedbacks_Rating_indx2] ON [dbo].[Feedbacks]
(
    [Rating] ASC
)
WITH (
    PAD_INDEX = OFF,
    STATISTICS_NORECOMPUTE = OFF,
    SORT_IN_TEMPDB = ON,
    DROP_EXISTING = OFF,
    ONLINE = OFF,
    ALLOW_ROW_LOCKS = ON,
    ALLOW_PAGE_LOCKS = ON,
    OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
) ON [PRIMARY];
GO

CREATE NONCLUSTERED INDEX [IX_Feedbacks_SearchSupport_Indx2] ON [dbo].[Feedbacks]
(
    [CustomerID] ASC,
    [CreatedDate] ASC
)
INCLUDE([FeedbackID],[Rating],[Metadata])
WITH (
    PAD_INDEX = OFF,
    STATISTICS_NORECOMPUTE = OFF,
    SORT_IN_TEMPDB = OFF,
    DROP_EXISTING = OFF,
    ONLINE = OFF,
    ALLOW_ROW_LOCKS = ON,
    ALLOW_PAGE_LOCKS = ON,
    OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
) ON [PRIMARY];
GO

CREATE UNIQUE NONCLUSTERED INDEX [UX_FeedbackID] ON [dbo].[Feedbacks]
(
    [FeedbackID] ASC
)
WITH (
    PAD_INDEX = OFF,
    STATISTICS_NORECOMPUTE = OFF,
    SORT_IN_TEMPDB = OFF,
    IGNORE_DUP_KEY = OFF,
    DROP_EXISTING = OFF,
    ONLINE = OFF,
    ALLOW_ROW_LOCKS = ON,
    ALLOW_PAGE_LOCKS = ON,
    OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
) ON [PRIMARY];
GO
