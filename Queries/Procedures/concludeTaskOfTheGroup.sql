USE [Routine View]
GO

DROP PROCEDURE IF EXISTS concludeTaskOfTheGroup
GO

CREATE PROCEDURE concludeTaskOfTheGroup
    @TaskTitle varchar(100)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @TaskGroupCode int;

        SELECT @TaskGroupCode = [TaskGroupCode]
        FROM Task
        WHERE Task.Title = @TaskTitle;

        UPDATE Task_Group
        SET Curr_undone_task_num = Curr_undone_task_num - 1
        WHERE Code = @TaskGroupCode;

        UPDATE Task
        SET Task.[State] = 'Done', Task.Conclusion = GETDATE()
        WHERE Title = @TaskTitle;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
			PRINT 'Error on concluding task '+@TaskTitle+' from task group : '+str(@TaskGroupCode);
            ROLLBACK TRANSACTION;

    END CATCH;
END
