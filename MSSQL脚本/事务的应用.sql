
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

SELECT * FROM cte
--事务的应用
BEGIN TRAN
DELETE cte WHERE groupname = '一组';
RAISERROR ('aaa',16, 1)
IF @@ERROR <> 0
	ROLLBACK TRAN
ELSE
	COMMIT TRAN


BEGIN TRY
-- RAISERROR with severity 11-19 will cause execution to
-- jump to the CATCH block.
RAISERROR ('Error raised in TRY block.', -- Message text.
           16, -- Severity.
           1 -- State.
           );
END TRY
BEGIN CATCH
    DECLARE @ErrorMessage NVARCHAR(4000);
    DECLARE @ErrorSeverity INT;
    DECLARE @ErrorState INT;

    SELECT
        @ErrorMessage = ERROR_MESSAGE(),
        @ErrorSeverity = ERROR_SEVERITY(),
        @ErrorState = ERROR_STATE();

    -- Use RAISERROR inside the CATCH block to return error
    -- information about the original error that caused
    -- execution to jump to the CATCH block.
    RAISERROR (@ErrorMessage, -- Message text.
               @ErrorSeverity, -- Severity.
               @ErrorState -- State.
               );
END CATCH;


 
 
--
DECLARE @SQL VARCHAR(8000)
SELECT @SQL=COALESCE(@SQL,'')+'Kill '+CAST(spid AS VARCHAR(10))+ '; ' 
FROM sys.sysprocesses 
WHERE DBID=DB_ID('demo')
PRINT @SQL --EXEC(@SQL)  


