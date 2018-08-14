USE [ExcelData]
GO

/****** Object:  Table [dbo].[Data]    Script Date: 8/14/2018 3:53:00 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Data](
	[Sno] [int] IDENTITY(1,1) NOT NULL,
	[rank] [int] NULL,
	[company] [nvarchar](50) NULL,
	[losses] [nvarchar](50) NULL,
	[profits] [nvarchar](50) NULL,
	[balance] [nvarchar](50) NULL
) ON [PRIMARY]
GO


