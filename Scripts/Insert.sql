USE [ExcelData]
GO

INSERT INTO [dbo].[Data]
           ([rank]
           ,[company]
           ,[losses]
           ,[profits]
           ,[balance])
     VALUES
           (<rank, int,>
           ,<company, nvarchar(50),>
           ,<losses, nvarchar(50),>
           ,<profits, nvarchar(50),>
           ,<balance, nvarchar(50),>)
GO


