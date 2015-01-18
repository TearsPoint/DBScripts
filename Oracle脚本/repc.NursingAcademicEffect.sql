grant all privileges to  repc;
grant execute on utils to repc;
 
--------------------------------------------------------
--  DDL for Synonymn DUAL
--------------------------------------------------------
  CREATE OR REPLACE PUBLIC SYNONYM "DUAL" FOR "SYS"."DUAL";
--------------------------------------------------------
--  DDL for Synonymn UTILS
--------------------------------------------------------
  CREATE OR REPLACE PUBLIC SYNONYM "UTILS" FOR "EMULATION"."UTILS";
  
  
--创建自增序列
CREATE SEQUENCE repc.NursingAcademicEffectId_SEQ
   START WITH 1 
   INCREMENT BY 1;
commit;

--drop table repc.NursingAcademicEffect
--创建表
CREATE TABLE REPC.NursingAcademicEffect
(
  NursingAcademicEffectId NUMBER(10,0)  NOT NULL,
  OwnerOrganizationId NUMBER(10,0) DEFAULT (-1) NOT NULL  ,
  AwardDatetime DATE DEFAULT (to_date( '1900-01-01','yyyy-mm-dd hh24:mi:ss')) NOT NULL ,
  NurseID NUMBER(10,0) DEFAULT (-1) NOT NULL,
  SocietyPost NUMBER(10,0) DEFAULT (0) NOT NULL,
  AwardContent NVARCHAR2(2000)  ,
  IsDeleted NUMBER(1,0) DEFAULT (0) NOT NULL,
  ROWVERSION DATE DEFAULT (SYSDATE) NOT NULL 
);
--设置表主键
ALTER TABLE repc.NursingAcademicEffect 
   ADD 
CONSTRAINT cpk_NursingAcademicEffect PRIMARY KEY( NursingAcademicEffectId );
 
--设置列说明
COMMENT ON COLUMN repc.NursingAcademicEffect.NursingAcademicEffectId
IS '政治成分';
COMMENT ON COLUMN repc.NursingAcademicEffect.OwnerOrganizationId
IS '所属科室ID'; 
COMMENT ON COLUMN repc.NursingAcademicEffect.AwardDatetime
IS '获奖时间';  
COMMENT ON COLUMN repc.NursingAcademicEffect.NurseID
IS '护士ID';  
COMMENT ON COLUMN repc.NursingAcademicEffect.SocietyPost
IS '学会任职';  
COMMENT ON COLUMN repc.NursingAcademicEffect.AwardContent
IS '获奖内容';   
commit;

--创建自增列的触发器
CREATE OR REPLACE TRIGGER repc.NursingAcademicEffectId_TRG BEFORE
  INSERT ON repc.NursingAcademicEffect FOR EACH ROW DECLARE v_newVal NUMBER(12) := 0;
  v_incval NUMBER(12) := 0;
BEGIN
  IF INSERTING AND :new.NursingAcademicEffectId IS NULL THEN
    SELECT NursingAcademicEffectId_SEQ.NEXTVAL INTO v_newVal FROM DUAL;
    -- If this is the first time this table have been inserted into (sequence == 1)
    IF v_newVal = 1 THEN
      --get the max indentity value from the table
      SELECT NVL(MAX(NursingAcademicEffectId),0)
      INTO v_newVal
      FROM NursingAcademicEffect;
      v_newVal := v_newVal + 1;
      --set the sequence to that value
      LOOP
        EXIT
      WHEN v_incval>=v_newVal;
        SELECT NursingAcademicEffectId_SEQ.nextval INTO v_incval FROM dual;
      END LOOP;
    END IF;
    -- save this to emulate @@identity
    utils.identity := v_newVal;
    -- assign the value from the sequence to emulate the identity column
    :new.NursingAcademicEffectId := v_newVal;
  END IF;
END;
/
ALTER TRIGGER repc.NursingAcademicEffectId_TRG ENABLE
select * from repc.NursingAcademicEffect