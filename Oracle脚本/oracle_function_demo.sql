
DROP FUNCTION Get_Test_Main;

/
 
CREATE OR REPLACE FUNCTION Get_Test_Main (p_id  INT ) 
RETURN SYS_REFCURSOR
IS return_cursor SYS_REFCURSOR; 
BEGIN 
  OPEN return_cursor FOR SELECT * FROM ENTITY.nurse;
  RETURN return_cursor; 
END Get_Test_Main;

COMMIT;

SELECT  Get_Test_Main(2) FROM DUAL;

 
