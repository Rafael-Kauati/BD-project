USE [Routine View]
GO

DROP PROCEDURE IF EXISTS concludeTask
GO

CREATE PROCEDURE concludeTask (@taskname VARCHAR(30))
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION; -- Inicia a transação

        DECLARE @taskcode INT;
        DECLARE @taskdeadline DATETIME;
        DECLARE @taskpriority INT;

        SELECT @taskcode = Code, @taskdeadline = Deadline, @taskpriority = [Priority]
        FROM [Task]
        WHERE Title = @taskname;

        UPDATE [Task]
        SET StackID = 3
        WHERE Title = @taskname;

        INSERT INTO [Reward] ([Task_code], [Task_Deadline], [Date_Time], [Reward_Value])
        VALUES (@taskcode, ISNULL(@taskdeadline, GETDATE()), GETDATE(), @taskpriority * 2);

        COMMIT; 

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK; 
    END CATCH
END
GO

EXEC concludeTask 'Conferir estoque';

