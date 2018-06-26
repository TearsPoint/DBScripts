
-- EXEC SP_LOCK 

--sql锁

--查询正阻塞的脚本 
  SELECT wt.blocking_session_id                    AS BlockingSessesionId
        ,sp.program_name                           AS ProgramName
        ,COALESCE(sp.LOGINAME, sp.nt_username)     AS HostName    
        ,ec1.client_net_address                    AS ClientIpAddress
        ,db.name                                   AS DatabaseName        
        ,wt.wait_type                              AS WaitType                    
        ,ec1.connect_time                          AS BlockingStartTime
        ,wt.WAIT_DURATION_MS/1000                  AS WaitDuration
        ,ec1.session_id                            AS BlockedSessionId
        ,h1.TEXT                                   AS BlockedSQLText
        ,h2.TEXT                                   AS BlockingSQLText
  FROM sys.dm_tran_locks AS tl
  INNER JOIN sys.databases db
    ON db.database_id = tl.resource_database_id
  INNER JOIN sys.dm_os_waiting_tasks AS wt
    ON tl.lock_owner_address = wt.resource_address
  INNER JOIN sys.dm_exec_connections ec1
    ON ec1.session_id = tl.request_session_id
  INNER JOIN sys.dm_exec_connections ec2
    ON ec2.session_id = wt.blocking_session_id
  LEFT OUTER JOIN master.dbo.sysprocesses sp
    ON SP.spid = wt.blocking_session_id
  CROSS APPLY sys.dm_exec_sql_text(ec1.most_recent_sql_handle) AS h1
  CROSS APPLY sys.dm_exec_sql_text(ec2.most_recent_sql_handle) AS h2
  
