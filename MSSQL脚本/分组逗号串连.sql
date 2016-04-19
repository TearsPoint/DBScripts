USE CoreDB

create table t1
(mid int,
uid varchar(1))
insert into t1 values (1,'a')
insert into t1 values (1,'b')
insert into t1 values (1,'b')
insert into t1 values (1,'c')
insert into t1 values (1,'d')
insert into t1 values (2,'a')
insert into t1 values (2,'b')
insert into t1 values (2,'c')
insert into t1 values (2,'c')
insert into t1 values (3,'a')
insert into t1 values (3,'b')
insert into t1 values (3,'c')
insert into t1 values (3,'c')


--方案一
select mid, items=
	stuff(
		(
			select ','+uid from
			(select distinct mid,uid from t1) t
			where mid=s.mid for xml path('')
			)
		, 1, 1, '')
from (select distinct mid,uid from t1) s
group by mid


--方案二
select mid, items=(
			select ISNULL( uid +',' ,'') from
			(select distinct mid,uid from t1) t
			where mid=s.mid for xml path('')
			)
from (select distinct mid,uid from t1) s
group by mid



--方案三
select mid, items=(
			select ISNULL( CASE ROW_NUMBER() OVER(ORDER BY t.mid) WHEN 1 THEN '' ELSE ',' END +uid ,'') from
			(select distinct mid,uid from t1) t
			where mid=s.mid for xml path('')
			)
from (select distinct mid,uid from t1) s
group by mid




 select mid,  items=(CONVERT(NVARCHAR(10), ROW_NUMBER() OVER(ORDER BY s.mid DESC)) + ':' +
			(
				select ISNULL(uid+',' ,'') from
				(select distinct mid,uid from t1) t
				where mid=s.mid for xml path(''))
			)
from (select distinct mid,uid from t1) s
group by mid





--测试
SELECT * FROM t1 FOR XML PATH('')


SELECT * FROM t1

DECLARE @r VARCHAR(1000)
SELECT @r = ISNULL(@r+',', '') + uid
FROM t1
SELECT @r


SELECT STUFF('abcdef', 3, 3, 'ijklmn');
Select CONVERT(varchar(100), GETDATE(), 12) --: 060516
SELECT CONVERT(NVARCHAR(10),GETDATE(),112)
