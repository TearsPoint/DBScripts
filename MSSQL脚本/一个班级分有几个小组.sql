--一个班级分有几个小组，考试成绩记录在数据库中的某个表tScores中，
--表中字段有学生[StudentName],小组名[GroupName],成绩[Score],
--现要统计每个小组中分数最高（如果有多个就都显示）的学生、所在小组、所得成绩，请写出你认为最简单sql语句。
--方法多多，谁的效率最快
 
create table cte(
StudentName varchar(10),GroupName varchar(10),Score int
)
 
insert into cte
select '张一','一组','90' union all
select '张二','一组','58' union all
select '张三','一组','90' union all
select '李一','二组','78' union all
select '李二','二组','97' union all
select '李三','二组','45' union all
select '王一','三组','78' union all
select '王二','三组','98' union all
select '王三','三组','33' 
 
--方法一
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
        
--方法二
;with cte(StudentName,GroupName,Score) as
(
    select '张一','一组','90' union all
    select '张二','一组','58' union all
    select '张三','一组','90' union all
    select '李一','二组','78' union all
    select '李二','二组','97' union all
    select '李三','二组','45' union all
    select '王一','三组','78' union all
    select '王二','三组','98' union all
    select '王三','三组','33' 
)
select StudentName,GroupName,Score from (
select DENSE_RANK() over(partition by GroupName order by Score desc) id,* from cte
)a where id=1 
order by GroupName DESC
 


--每一组 按分数排名
SELECT DENSE_RANK() OVER( partition by GroupName order by Score DESC ) id,* from cte 

 
 
 
----------------
DROP TABLE dbo.course
DROP TABLE dbo.student
CREATE TABLE student
( 
   id NVARCHAR(30) NOT NULL,
   NAME NVARCHAR(30) NOT NULL
)

INSERT INTO student
SELECT '001','张三' UNION ALL
SELECT '002','李四' UNION ALL
SELECT '003','王五' UNION ALL
SELECT '004','朱六'

SELECT * FROM student

CREATE TABLE course
(student_id NVARCHAR(30) NOT NULL,
course NVARCHAR(30) NOT NULL,
score DECIMAL NOT NULL)
go

INSERT INTO course 
SELECT '001','语文',52 UNION ALL
SELECT '001','数学',66 UNION ALL
SELECT '002','语文',59 UNION ALL
SELECT '002','英语',80 UNION ALL
SELECT '002','政治',60 UNION ALL
SELECT '003','数学',88 

SELECT * FROM course

--11  每门课程都在60分以上
SELECT s.NAME FROM
(SELECT student_id, MIN(score) min_score FROM course GROUP BY student_id ) AS t1,student s
WHERE min_score>=60 AND s.id = t1.student_id

--12 一半的课程都在60分以上
select s.name,课程数 = count(c.score),超过60分的课程数 = sum(case when c.score>=60 then 1 else 0 end)
 from student s join course c
  on s.id=c.student_id
  group by s.name
  having sum(case when c.score>=60 then 1 else 0 end)/cast(count(c.score)as numeric)>=0.5

  
  
  
--
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
--声明游标  
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

CLOSE tempCursor   --关闭游标
DEALLOCATE tempCursor --回收游标

SELECT * FROM #result
DROP TABLE #result
DROP TABLE #temp




 
 
  
 
