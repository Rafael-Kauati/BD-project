USE [Routine View]
GO

DROP PROCEDURE IF EXISTS concludeTask
GO

CREATE PROCEDURE concludeTask (@taskname VARCHAR(30))
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @taskcode INT;
        DECLARE @taskdeadline DATETIME;
        DECLARE @taskpriority INT;

        SELECT @taskcode = Code, @taskdeadline = Deadline, @taskpriority = [Priority]
        FROM [Task]
        WHERE Title = @taskname;

        UPDATE [Task]
        SET StackID = 3, Task.Conclusion = GETDATE()
        WHERE Title = @taskname;

        UPDATE [Stack]
        SET CurrMaxTasks = CurrMaxTasks + 1
        WHERE [Stack].StackID = 3;

        UPDATE [Stack]
        SET CurrMaxTasks = CurrMaxTasks - 1
        WHERE [Stack].StackID = 2;

        INSERT INTO [Reward] ([Task_code], [Task_Deadline], [Date_Time], [Reward_Value])
        VALUES (@taskcode, ISNULL(@taskdeadline, GETDATE()), GETDATE(), @taskpriority * 2);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
        BEGIN
			PRINT 'Error on concluding task : '+@taskname;
            ROLLBACK TRANSACTION;
        END
    END CATCH;
END
GO
