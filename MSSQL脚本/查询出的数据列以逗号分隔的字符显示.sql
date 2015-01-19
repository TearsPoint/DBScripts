

USE ReportServer

SELECT * FROM dbo.Users



declare @a varchar(100)
set @a=''
SELECT @a =@a + u.UserName + ',' FROM dbo.Users u 
PRINT SUBSTRING(@a,0,LEN(@a))  



declare @output varchar(8000)
select @output = coalesce(@output + ',' , '') + u.UserName from Users u 
print @output


CREATE SCHEMA [test] AUTHORIZATION [dbo]
 
SELECT AuthType,aaa=(SELECT 1)FROM dbo.Users u GROUP BY u.AuthType 

SELECT * FROM sys.schemas

--






IF OBJECT_ID('dbo.wages') IS NOT NULL
    DROP TABLE wages;
GO
CREATE TABLE dbo.wages
(
    emp_id        tinyint   identity,
    hourly_wage   decimal   NULL,
    salary        decimal   NULL,
    commission    decimal   NULL,
    num_sales     tinyint   NULL
);
GO
INSERT dbo.wages (hourly_wage, salary, commission, num_sales)
VALUES
    (10.00, NULL, NULL, NULL),
    (20.00, NULL, NULL, NULL),
    (30.00, NULL, NULL, NULL),
    (40.00, NULL, NULL, NULL),
    (NULL, 10000.00, NULL, NULL),
    (NULL, 20000.00, NULL, NULL),
    (NULL, 30000.00, NULL, NULL),
    (NULL, 40000.00, NULL, NULL),
    (NULL, NULL, 15000, 3),
    (NULL, NULL, 25000, 2),
    (NULL, NULL, 20000, 6),
    (NULL, NULL, 14000, 4);
GO
SET NOCOUNT OFF;
GO

SELECT * FROM dbo.wages

SELECT CAST(COALESCE(hourly_wage , 
   salary, 
   commission * num_sales) AS money) AS 'Total Salary' 
FROM dbo.wages
ORDER BY 'Total Salary';	
GO





USE PinMeiCoreDB

IF OBJECT_ID('[tb]') IS NOT NULL DROP TABLE [tb]
GO
create table tb(姓名 nvarchar(10) , 课程 nvarchar(10) , 分数 int)
insert into tb(姓名,课程,分数) values('张三' , '语文' , 74)
insert into tb(姓名,课程,分数) values('张三' , '数学' , 83)
insert into tb(姓名,课程,分数) values('张三' , '物理' , 93)
insert into tb(姓名,课程,分数) values('李四' , '语文' , 74)
insert into tb(姓名,课程,分数) values('李四' , '数学' , 84)
insert into tb(姓名,课程,分数) values('李四' , '物理' , 94)
go
 
SELECT * FROM dbo.tb

  


SELECT * FROM sys.sql_modules
SELECT * FROM sys.objects WHERE object_id IN (SELECT object_id FROM sys.sql_modules)


CREATE FUNCTION f_getobjectionveCodeByRESOURCEID
(@RsourceID varchar(20),@index int)
returns int
as
begin
declare @objectiveCode int, @SQL NVARCHAR(200)
set @SQL='select top 1 @objectiveCode=objectiveCode from (select top '+@index+' objectiveCode from sco_e_objectives where ResourceID='+@RsourceID +')a';
EXEC SP_EXECUTESQL @SQL,N'@objectiveCode int', 
        @objectiveCode OUT;
return @objectiveCode
end
GO


--建表 与插入数据  
create table test
(  ids int identity(1,1) primary key,  userID int,  userName varchar(20)  )   
 insert test (userID,userName)values(1,'aaa')  
 insert test (userID,userName)values(1,'bbb')  
 insert test (userID,userName)values(1,'ccc')  
 insert test (userID,userName)values(1,'ddd')    
 --建函数  
 CREATE function f_test  
 (@userID int,@index int)  
 returns int  
 as 
  begin    
 declare @ids int, @sql NVARCHAR(200),@ind nvarchar(10)  set @ind=cast(@index as nvarchar)    
 set @sql='select top 1 @ids=ids from (select top '+@ind+'   ids from test where userID='+cast(@userID as nvarchar)+')a order by ids desc'  
 exec sp_executesql @sql,N'@ids int',@ids out;  
 return @ids  end 
 
  go    
 
 --调用  
 select dbo.f_test(1,1)    
 --封装到存储过程调用  
 create proc sp_test  @userID int,  @index int  as  
 select dbo.f_test(@userID,@index)    
 exec sp_test 1,1  
