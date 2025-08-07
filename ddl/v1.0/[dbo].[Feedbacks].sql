USE [CustomerFeedback]
GO

--ALTER TABLE [dbo].[Feedbacks] DROP CONSTRAINT [CK__Feedbacks__Ratin__619B8048]
--GO

--ALTER TABLE [dbo].[Feedbacks] DROP CONSTRAINT [FK__Feedbacks__Custo__60A75C0F]
--GO

--ALTER TABLE [dbo].[Feedbacks] DROP CONSTRAINT [DF__Feedbacks__Creat__628FA481]
--GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Feedbacks]') AND type in (N'U'))
DROP TABLE [dbo].[Feedbacks]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Feedbacks](
	[FeedbackID] [int] IDENTITY(1,1) NOT NULL,
	[CustomerID] [int] NULL,
	[FeedbackText] [varchar](8000) NULL,
	[Rating] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[Metadata] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[FeedbackID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

-- Default constraint for CreatedDate
ALTER TABLE [dbo].[Feedbacks]
ADD CONSTRAINT DF_Feedbacks_CreatedDate DEFAULT (GETDATE()) FOR [CreatedDate];

-- Foreign key constraint on CustomerID
ALTER TABLE [dbo].[Feedbacks] WITH CHECK
ADD CONSTRAINT FK_Feedbacks_Customers FOREIGN KEY ([CustomerID])
REFERENCES [dbo].[Customers] ([CustomerID]);

-- Check constraint for Rating between 1 and 5
ALTER TABLE [dbo].[Feedbacks] WITH CHECK
ADD CONSTRAINT CK_Feedbacks_RatingRange CHECK ([Rating] >= 1 AND [Rating] <= 5);
