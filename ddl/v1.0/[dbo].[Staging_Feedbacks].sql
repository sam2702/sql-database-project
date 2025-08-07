USE [CustomerFeedback]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Staging_Feedbacks]') AND type in (N'U'))
DROP TABLE [dbo].[Staging_Feedbacks]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Staging_Feedbacks](
	[CustomerID] [int] NULL,
	[FeedbackText] [varchar](8000) NULL,
	[Rating] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[Metadata] [nvarchar](max) NULL
) ON [PRIMARY]
GO


