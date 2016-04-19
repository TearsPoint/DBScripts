
select 
SYS_CONTEXT('USERENV','TERMINAL') terminal, 
SYS_CONTEXT('USERENV','LANGUAGE') language, 
SYS_CONTEXT('USERENV','SESSIONID') sessionid, 
SYS_CONTEXT('USERENV','INSTANCE') instance, 
SYS_CONTEXT('USERENV','ENTRYID') entryid, 
SYS_CONTEXT('USERENV','ISDBA') isdba, 
SYS_CONTEXT('USERENV','NLS_TERRITORY') nls_territory, 
SYS_CONTEXT('USERENV','NLS_CURRENCY') nls_currency, 
SYS_CONTEXT('USERENV','NLS_CALENDAR') nls_calendar, 
SYS_CONTEXT('USERENV','NLS_DATE_FORMAT') nls_date_format, 
SYS_CONTEXT('USERENV','NLS_DATE_LANGUAGE') nls_date_language, 
SYS_CONTEXT('USERENV','NLS_SORT') nls_sort, 
SYS_CONTEXT('USERENV','CURRENT_USER') current_user, 
SYS_CONTEXT('USERENV','CURRENT_USERID') current_userid, 
SYS_CONTEXT('USERENV','SESSION_USER') session_user, 
SYS_CONTEXT('USERENV','SESSION_USERID') session_userid, 
SYS_CONTEXT('USERENV','PROXY_USER') proxy_user, 
SYS_CONTEXT('USERENV','PROXY_USERID') proxy_userid, 
SYS_CONTEXT('USERENV','DB_DOMAIN') db_domain, 
SYS_CONTEXT('USERENV','DB_NAME') db_name, 
SYS_CONTEXT('USERENV','HOST') host, 
SYS_CONTEXT('USERENV','OS_USER') os_user, 
SYS_CONTEXT('USERENV','EXTERNAL_NAME') external_name, 
SYS_CONTEXT('USERENV','IP_ADDRESS') ip_address, 
SYS_CONTEXT('USERENV','NETWORK_PROTOCOL') network_protocol, 
SYS_CONTEXT('USERENV','BG_JOB_ID') bg_job_id, 
SYS_CONTEXT('USERENV','FG_JOB_ID') fg_job_id, 
SYS_CONTEXT('USERENV','AUTHENTICATION_TYPE') authentication_type, 
SYS_CONTEXT('USERENV','AUTHENTICATION_DATA') authentication_data 
from dual; 

select * from all_tables;
select   *   from   all_triggers ;

select username,default_tablespace from dba_users;
select * from dba_users;

--查看当前用户的缺省表空间
select username,default_tablespace from user_users;
--查看当前用户的角色
select * from user_role_privs;

--查看当前用户的系统权限和表级权限
select * from user_sys_privs;
select * from user_tab_privs;

--查看用户下所有的表
select * from user_tables;

 --查看用户下所有的表的列属性
    select * from USER_TAB_COLUMNS where table_name=:table_Name;

--显示用户信息(所属表空间)
select default_tablespace,temporary_tablespace 
from dba_users where username='GAME';

--1、用户

--查看当前用户的缺省表空间
select username,default_tablespace from user_users;

--查看当前用户的角色
select * from user_role_privs;

--查看当前用户的系统权限和表级权限
select * from user_sys_privs;
select * from user_tab_privs;

--显示当前会话所具有的权限
select * from session_privs;

--显示指定用户所具有的系统权限
select * from dba_sys_privs where grantee='GAME';

--显示特权用户
select * from v$pwfile_users;

--显示用户信息(所属表空间)
select default_tablespace,temporary_tablespace 
from dba_users where username='GAME';

--显示用户的PROFILE
select profile from dba_users where username='GAME';


--2、表

--查看用户下所有的表
select * from user_tables;

--查看名称包含log字符的表
select object_name,object_id from user_objects
where instr(object_name,'LOG')>0;

--查看某表的创建时间
select object_name,created from user_objects where object_name=upper('&table_name');

--查看某表的大小
select sum(bytes)/(1024*1024) as "size(M)" from user_segments
where segment_name=upper('&table_name');

--查看放在Oracle的内存区里的表
select table_name,cache from user_tables where instr(cache,'Y')>0;

--3、索引

--查看索引个数和类别
select index_name,index_type,table_name from user_indexes order by table_name;

--查看索引被索引的字段
select * from user_ind_columns where index_name=upper('&index_name');

--查看索引的大小
select sum(bytes)/(1024*1024) as "size(M)" from user_segments
where segment_name=upper('&index_name');

--4、序列号

--查看序列号，last_number是当前值
select * from user_sequences;

--5、视图

--查看视图的名称
select view_name from user_views;

--查看创建视图的select语句
set view_name,text_length from user_views;
set long 2000; 说明：可以根据视图的text_length值设定set long 的大小
select text from user_views where view_name=upper('&view_name');

--6、同义词

--查看同义词的名称
select * from user_synonyms;

--7、约束条件

--查看某表的约束条件
select constraint_name, constraint_type,search_condition, r_constraint_name
from user_constraints where table_name = upper('&table_name');

select c.constraint_name,c.constraint_type,cc.column_name
from user_constraints c,user_cons_columns cc
where c.owner = upper('&table_owner') and c.table_name = upper('&table_name')
and c.owner = cc.owner and c.constraint_name = cc.constraint_name
order by cc.position;

--8、存储函数和过程

--查看函数和过程的状态
select object_name,status from user_objects where object_type='FUNCTION';
select object_name,status from user_objects where object_type='PROCEDURE';

--查看函数和过程的源代码
select text from all_source where owner=user and name=upper('&plsql_name');