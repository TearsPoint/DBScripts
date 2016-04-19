--修改表名
ALTER TABLE 架构名.表名 RENAME  TO 新表名;

--修改表中的列
ALTER TABLE 表名 MODIFY  列名  数据类型;

--已存在的表中的列修改列名
ALTER TABLE  架构名.表名  rename COLUMN 列名 TO 新列名;

--已存在的表新增列
ALTER TABLE  架构名.表名  ADD  列名  数据类型   DEFAULT(默认值) NOT NULL;