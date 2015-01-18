use pm

--�����û�
create user han identified by han default tablespace
users Temporary TABLESPACE Temp;
grant connect,resource,dba to han; //�����û�han������Ա��Ȩ��

 

--------------------�Ա�Ĳ���--------------------------
--������
create table classes(
       id number(9) not null primary key,
       classname varchar2(40) not null
)      
--��ѯ��
select * from classes;

 
begin
  execute immediate 'select 1 from dual';
end;

SET SERVEROUTPUT ON
execute DBMS_OUTPUT.PUT('error');



--ɾ����
drop table students;

--�޸ı������
rename alist_table_copy to alist_table;

--��ʾ��ṹ
describe classes --����û�鵽

-----------------------���ֶεĲ���-----------------------------------
--������
alter table test add address varchar2(40);

--ɾ����
alter table test drop column address;

--�޸��е�����
alter table test modify address addresses varchar(40;
 

create table test1(
       id number(9) primary key not null,
       name varchar2(34)
      )
rename test2 to test;

--��������������
create sequence class_seq increment by 1 start with 1 MAXVALUE 999999 NOCYCLE NOCACHE;

select class_seq.currval from dual

--��������
insert into classes values(class_seq.nextval,'���һ��')
commit;

--��������
update stu_account set username='aaa' where count_id=2;
commit;

--����Ψһ����
create unique index username on stu_account(username);   --Ψһ�������ܲ�����ͬ������

--���� ���´򿪵ĶԻ��в��ܶԴ��н��в���
select * from stu_account t where t.count_id=2 for update; --����


--alter table stuinfo modify sty_id to stu_id;

alter table students drop constraint class_fk;
alter table students add constraint class_fk foreign key (class_id) references classes(id);--���Լ��
alter table stuinfo add constraint stu_fk foreign key (stu_id) references students(id) ON DELETE CASCADE;--���Լ��,����ɾ��

alter table stuinfo drop constant stu_fk;   

insert into students values(stu_seq.nextval,'����',1,sysdate);

insert into stuinfo values(stu_seq.currval,'����');

select * from stuinfo;

create table zhuce(
       zc_id number(9) not null primary key,
       stu_id number(9) not null,
       zhucetime date default sysdate

)

create table feiyong (
       fy_id number(9) not null primary key,
       stu_id number(9) not null,
       mx_id number(9) not null,
       yijiao number(7,2) not null default 0,
       qianfei number(7,2) not null
       
)


create talbe fymingxi(
       mx_id number(9) not null primary key,
       feiyong number(7,2) not null,     //��7λ���֣�С��������λ
       class_id number(9) not null
}

create table card(
       card_id number(9) primary key,
       stu_id number(9) not null,
       money number(7,2) not null default 0,
       status number(1) not null default 0   --0�����,1���ʧ
)

--�����ѯ

select c.classname||'_'||s.stu_name as �༶_����,si.address from classes c,students s , stuinfo si where c.id=s.class_id and s.id=si.stu_id; 
insert into students values(stu_seq.nextval,'����',1,sysdate);
insert into stuinfo values(stu_seq.currval,'�Ͼ�');

--����
select rownum,id,stu_name from students t order by id asc;


--�м��ʵ�ֶ�Զ����
--��1   1�� 1   n��n 1��n n ��


--1 n������   1�ı�������   n�ı���1����ֶ�
--1 1������   ���������
--n n������ �м��ʵ�ֶ�Զ����

create��table course(
         course_id number(9) not null,
         couser_name varchar2(40) not null
)
alter table course to couse;
create table stu_couse(
       stu_couse_id number(9) primary key,
       stu_id number(9) not null,
       couse_id number(9) not null

)

create unique index stu_couse_unq on stu_couse(stu_id,couse_id); --Ψһѧ��
create sequence stu_couse_seq increment by 1 start with 1 MAXVALUE 999999 NOCYCLE NOCACHE;


create sequence couses_seq increment by 1 start with 1 MAXVALUE 999999 NOCYCLE NOCACHE;
insert into course values(couses_seq.nextval,'�����ԭ��');
insert into course values(couses_seq.nextval,'����ԭ��');
insert into course values(couses_seq.nextval,'���ݿ�ԭ��');
insert into course values(couses_seq.nextval,'���ݽṹ');
insert into course values(couses_seq.nextval,'���������');
insert into course values(couses_seq.nextval,'C���Գ���');
commit;

insert into stu_couse values(stu_couse_seq.nextval,1,1);
insert into stu_couse values(stu_couse_seq.nextval,1,3);
insert into stu_couse values(stu_couse_seq.nextval,1,5);
insert into stu_couse values(stu_couse_seq.nextval,1,5);

insert into stu_couse values(stu_couse_seq.nextval,2,1);
commit;
select * from stu_couse;
select * from course;

--select s.stu_name,sc.couse_id, c.couser_name from students s,course c,stu_couse sc where stu_id=1

--select couse_id from stu_couse where stu_id=1

select cl.classname,s.stu_name,c.couser_name from stu_couse sc, students s,course c,classes cl where s.id=sc.stu_id and sc.couse_id=c.course_id and s.class_id=cl.id and s.id=1;

--�༶��������
select c.classname,s.stu_name from students s,classes c where s.class_id=c.id and s.id=2;

select * from students s where s.id=2
--�༶�������������γ�

select cl.classname,s.stu_name,c.couse_name from stu_couse sc,students s,classes cl,couse c where sc.stu_id=s.id and sc.couse_id=c.couse_id and s.id=26;


--sql ����д������д���������ı�Ȼ��д��Ҫ���ҵ��ֶΣ����� д����������   ����ס��д�������ı�ʱ��д���ݶ�ı��������������sql��Ч��

select c.couser_name,s.stu_name from stu_couse sc,students s,course c where c.course_id=1 and c.course_id=sc.couse_id and sc.stu_id=s.id;

select s.stu_name from students s,stu_couse sc where s.id=sc.stu_id group by s.id,s.stu_name;


select c.classname,count(sc.couse_id) from stu_couse sc,students s,classes c where s.class_id=c.id and s.id=sc.stu_id group by c.classname;

select s.stu_name, count(sc.couse_id) from stu_couse sc,students s,classes cl where s.id=sc.stu_id group by s.id,s.stu_name having count(sc.stu_couse_id)>3;
�༶ ѧ�� ѡ������
select cl.classname,count(sc.stu_couse_id) from stu_couse sc,students s,classes cl where s.id=sc.stu_id and s.class_id=cl.id group by cl.classname;


--�༶ ѧ�� ѡ������
select cl.classname,s.stu_name,count(sc.stu_couse_id) from stu_couse sc,students s,classes cl where s.id=sc.stu_id and s.class_id=cl.id group by s.stu_name;

select cl.classname,s.stu_name,count(sc.stu_couse_id) from stu_couse sc ,students s,classes cl where sc.stu_id=s.id and s.class_id=cl.id group by s.id;

select cl.classname,s.stu_name,count(sc.stu_couse_id) from stu_couse sc,students s,classes cl where sc.stu_id=s.id and s.class_id=cl.id group by s.stu_name;
--�༶ ѧ�� ��ѡ�γ�id ��ѡ�γ�����


--������ͼ Ŀ�İѱ��������� Ȼ�󿴳�һ�����������������Ͻ��в�ѯ 
create view xsxk as select cl.classname, s.stu_name,c.couse_id, c.couse_name from stu_couse sc,students s,classes cl,couse c where sc.stu_id=s.id and sc.couse_id=c.couse_id and s.class_id=cl.id;

select * from xsxk


create view classstu as select s.id,c.classname,s.stu_name from students s,classes c where c.id=s.class_id;
drop view classstu; --ɾ����ͼ
select * from classstu;
create view stu_couse_view as select s.id ,c.couse_name from stu_couse sc,students s,couse c where s.id=sc.stu_id and sc.couse_id=c.couse_id;
select * from stu_couse_view;
create view csc as select cs.classname,cs.stu_name,scv.couse_name from classstu cs,stu_couse_view scv where cs.id=scv.id;
select * from csc;


select * from classes cross join students; --ȫ���ӣ��൱��select * from classes,students;

select * from classes cl left join students s on cl.id=s.class_id; --������ ���������û�� ����ʾ����
select * from classes cl right join students s on cl.id=s.class_id; --������
select * from classes cl full join students s on cl.id=s.class_id; --ȫ����


insert into classes values(class_seq.nextval,'����İ�');

create table sales(
       nian varchar2(4),
       yeji number(5)
       
);
insert into sales values('2001',200);
insert into sales values('2002',300);
insert into sales values('2003',400);
insert into sales values('2004',500);
commit;
select * from sales;
drop table sale;


select s1.nian,sum(s2.yeji) from sales s1,sales s2 where s1.nian>=s2.nian group by s1.nian order by s1.nian desc;

select s1.nian,sum(s2.yeji) from sales s1,sales s2 where s1.nian>=s2.nian group by s1.nian;

s
       ��       ��ҵ���ܺ� 
       2001     200
       2002     500
       2003     900
       2004     1400


create table test1(
       t_id number(4)
);

create table org(
       org_id number(9) not null primary key,
       org_name varchar2(40) not null,
       parent_id number(9)
);

create sequence org_seq increment by 1 start with 1 MAXVALUE 999999 NOCYCLE NOCACHE;
drop sequence org_seq;
insert into org values(1,'��������',0);
insert into org values(2,'��������һ�ֹ�˾',1);
insert into org values(3,'�������Ŷ��ֹ�˾',1);
insert into org values(4,'�������Ų���',1);
insert into org values(5,'�������Ź��̲�',1);
insert into org values(6,'��������һ�ֹ�˾����',2);
insert into org values(7,'��������һ�ֹ�˾���̴�',2);

select * from org;
--����ȷ ����ʵ��ѭ��
select b.org_id , b.org_name ,b.parent_id from org a,org b where a.org_id=7 and a.parent_id=b.org_id;
select * from org connect by prior parent_id=org_id start with org_id=7 order by org_id;
select * from org connect by prior org_id=parent_id start with org_id=1 order by org_id;

create table chengji(
       cj_id number(9) not null primary key,
       stu_cou_id number(9) not null,
       fen number(4,1)
       
);
insert into chengji values(1,1,62);
insert into chengji values(2,2,90);
insert into chengji values(3,3,85);
insert into chengji values(4,4,45);
insert into chengji values(5,5,68);
insert into chengji values(6,6,87);
commit;
select * from chengji;
select * from stu_couse;
--��oracle �к������� alter table chengji change stu_cou_id stu_couse_id;alter table shop_jb change price1 price double;

ѧ������   ƽ����
select s.stu_name,avg(cj.fen) from stu_couse sc,chengji cj,students s where s.id=sc.stu_id and sc.stu_couse_id=cj.stu_couse_id group by s.id,s.stu_name;
select s.stu_name from students s,stu_couse sc,chengji cj where s.id=sc.stu_id and sc.stu_couse_id=cj.stu_couse_id group by s.id,s.stu_name;
select s.stu_name,cj.fen from students s,stu_couse sc,chengji cj where s.id=sc.stu_id and sc.stu_couse_id=cj.stu_couse_id and cj.fen>60;

ѧ������   ��Ŀ   �ɼ�
select s.stu_name,c.couse_name,cj.fen from stu_couse sc,students s,couse c,chengji cj where sc.stu_id=s.id and sc.couse_id=c.couse_id and sc.stu_couse_id=cj.stu_couse_id and cj.fen>60 order by=;

select * from stu_couse;

--��������
--ѡ���˿γ�3��ѧ��   union ѡ���˿γ�5��ѧ��   ����
--ѡ���˿γ�3 ���� ѡ���˿γ�5��ѧ��
select s.stu_name from students s,couse c,stu_couse sc where s.id=sc.stu_id and sc.couse_id=c.couse_id and c.couse_id=3
union
select s.stu_name from students s,couse c,stu_couse sc where s.id=sc.stu_id and sc.couse_id=c.couse_id and c.couse_id=5

--ѡ���˿γ�3��5��2 ��ѧ�� intersect ѡ��γ�1��2��4��ѧ��    ����
--��ѡ���˿γ� 2 ���� ѡ���˿γ� 3 ��ѧ��   ����
select s.stu_name from students s,couse c,stu_couse sc where s.id=sc.stu_id and sc.couse_id=c.couse_id and c.couse_id=2
intersect
select s.stu_name from students s,couse c,stu_couse sc where s.id=sc.stu_id and sc.couse_id=c.couse_id and c.couse_id=3;

