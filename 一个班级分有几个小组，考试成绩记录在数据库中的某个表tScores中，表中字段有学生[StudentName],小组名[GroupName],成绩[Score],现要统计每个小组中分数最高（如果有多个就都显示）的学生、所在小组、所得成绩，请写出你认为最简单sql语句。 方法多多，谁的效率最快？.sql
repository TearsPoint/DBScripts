create table cte(
StudentName varchar(10),GroupName varchar(10),Score int
)
 
insert into cte
select '��һ','һ��','90' union all
select '�Ŷ�','һ��','58' union all
select '����','һ��','90' union all
select '��һ','����','78' union all
select '���','����','97' union all
select '����','����','45' union all
select '��һ','����','78' union all
select '����','����','98' union all
select '����','����','33' 
 
 
select c1.*
from cte c1
inner join
    (
        select GroupName,
               MAX(Score) as score
        from cte 
        group by GroupName
    )c2
    on c2.GroupName = c1.GroupName
       and c2.score = c1.Score
       

 DROP TABLE cte
       
---------------------------
       ;with cte(StudentName,GroupName,Score) as
(
    select '��һ','һ��','90' union all
    select '�Ŷ�','һ��','58' union all
    select '����','һ��','90' union all
    select '��һ','����','78' union all
    select '���','����','97' union all
    select '����','����','45' union all
    select '��һ','����','78' union all
    select '����','����','98' union all
    select '����','����','33' 
)
select StudentName,GroupName,Score from (
select DENSE_RANK() over(partition by GroupName order by Score desc) id,* from cte
)a where id=1 
order by GroupName DESC


SELECT DENSE_RANK() OVER( partition by GroupName order by Score DESC ) id,* from cte 


USE PinMeiCoreDB
 
create table tbccc(
 tid varchar(10),pn varchar(10),no NVARCHAR(10)
)

go

INSERT INTO dbo.tbccc   ( tid, pn, no )
VALUES  ( 't1', 'a', 'b'   )
INSERT INTO dbo.tbccc   ( tid, pn, no )
VALUES  ( 't1', 'b', 'a'   )
INSERT INTO dbo.tbccc   ( tid, pn, no )
VALUES  ( 't1', 'a', 'c'   )
INSERT INTO dbo.tbccc   ( tid, pn, no )
VALUES  ( 't1', 'a', 'b'   )
INSERT INTO dbo.tbccc   ( tid, pn, no )
VALUES  ( 't1', 'b', 'e'   )
INSERT INTO dbo.tbccc   ( tid, pn, no )
VALUES  ( 't1', 'a', 'f'   )


SELECT * FROM dbo.tbccc WHERE no NOT IN ( pn )


go

CREATE TABLE #result(col1 nvarchar(10) NULL, col2 NVARCHAR(10))
SELECT tid INTO #temp FROM dbo.tbccc GROUP BY tid
DECLARE @Id NVARCHAR(10) 
--�����α�  
DECLARE tempCursor CURSOR
FOR SELECT DISTINCT tid FROM #temp 
 
OPEN tempCursor  
WHILE(1=1)
BEGIN 
	FETCH NEXT FROM tempCursor INTO @Id   
	IF(@@FETCH_STATUS!=0)  
		BREAK 
	INSERT INTO #result 
	SELECT @Id col1, no col2 FROM dbo.tbccc WHERE tid = @Id AND no NOT IN (SELECT pn FROM dbo.tbccc WHERE tid=@Id)
END 

CLOSE tempCursor   --�ر��α�
DEALLOCATE tempCursor --�����α�

SELECT * FROM #result
DROP TABLE #result
DROP TABLE #temp




 
 
  
 