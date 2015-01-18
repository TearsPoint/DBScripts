--------------------------------------------------------
--  文件已创建 - 星期三-五月-29-2013   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Trigger NURSINGACADEMICEFFECTID_TRG
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "REPC"."NURSINGACADEMICEFFECTID_TRG" BEFORE
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
ALTER TRIGGER "REPC"."NURSINGACADEMICEFFECTID_TRG" ENABLE;
