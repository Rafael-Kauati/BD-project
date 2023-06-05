USE [Routine View]
GO

DROP PROCEDURE IF EXISTS startTask
GO

CREATE PROCEDURE startTask(@taskname varchar(100))
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION; -- Iniciar a transação
        -- Update [Stack].CurrMaxTasks para StackID = 2
        UPDATE [Stack]
        SET CurrMaxTasks = CurrMaxTasks + 1
        WHERE StackID = 2;

      
        -- Update [Stack].CurrMaxTasks para StackID = 1
        UPDATE [Stack]
        SET CurrMaxTasks = CurrMaxTasks - 1
        WHERE StackID = 1;

        -- Update T.StackID
        UPDATE T
        SET T.StackID = T.StackID + 1
        FROM [Task] T
        WHERE T.Title = @taskname;

        COMMIT TRANSACTION; -- Commit a transação
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
			PRINT 'Error on starting task : '+@taskname;
			ROLLBACK; -- Rollback a transação em caso de erro
    END CATCH
END
GO
