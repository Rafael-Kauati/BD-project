--use [Routine View]
--go

DROP PROCEDURE IF EXISTS startTask
GO

CREATE PROCEDURE startTask(@taskname varchar(100))
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION; 
        UPDATE [Stack]
        SET CurrMaxTasks = CurrMaxTasks + 1
        WHERE StackID = 2;

      
        UPDATE [Stack]
        SET CurrMaxTasks = CurrMaxTasks - 1
        WHERE StackID = 1;

        UPDATE T
        SET T.StackID = T.StackID + 1
        FROM [Task] T
        WHERE T.Title = @taskname;

        COMMIT TRANSACTION; 
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
			PRINT 'Error on starting task : '+@taskname;
			ROLLBACK; 
    END CATCH
END
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

DROP PROCEDURE IF EXISTS finishGroupTask
GO

CREATE PROCEDURE finishGroupTask (@taskGroup varchar(50))
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @unfinishedTasks int;

        SELECT @unfinishedTasks = [Curr_undone_task_num]
        FROM Task_Group
        WHERE Task_Group.Title = @taskGroup;

        IF @unfinishedTasks = 0
        BEGIN
            UPDATE Task_Group
            SET Task_Group.isFinished = 'yes'
            WHERE Task_Group.Title = @taskGroup;

            DECLARE @sumPriority int;

            DECLARE @lastTaskCode int;
            DECLARE @lastTaskDeadline datetime;

            SELECT @sumPriority = sum(TaskPriority)
            FROM getTaskGroup(@taskGroup, 'Done');

            SELECT @lastTaskCode = t.TaskCode, @lastTaskDeadline = t.TaskDeadline
            FROM dbo.getTaskGroup(@taskGroup, 'Done') t
            WHERE t.TaskConclusion = (SELECT max(TaskConclusion) FROM dbo.getTaskGroup(@taskGroup, 'Done'));

            INSERT INTO [Reward] ([Task_code], [Task_Deadline], [Date_Time], [Reward_Value])
            VALUES (@lastTaskCode, ISNULL(@lastTaskDeadline, GETDATE()), GETDATE(), @sumPriority * 2);
        END
        ELSE
        BEGIN
            UPDATE Task_Group
            SET Task_Group.isFinished = 'no'
            WHERE Task_Group.Title = @taskGroup;
        END

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
        BEGIN
			PRINT 'Error on finishing task group : '+@taskGroup;
            ROLLBACK TRANSACTION;
        END
    END CATCH;
END
GO

DROP PROCEDURE IF EXISTS checkLogIn;
GO

CREATE PROCEDURE checkLogIn
(
    @email varchar(40),
    @password varchar(40),
    @confirmation int OUTPUT
)
AS
BEGIN
    DECLARE @DecryptedPassword varbinary(8000);
    DECLARE @userid int;

    SELECT @DecryptedPassword = DecryptByPassPhrase('ThePassphrase', [Password])
    FROM [User]
    WHERE [Email] = @email;

    IF CONVERT(varchar(40), @DecryptedPassword) = @password
    BEGIN
		--DECLARE @username varchar(50);
        SELECT @userid = [User].ID--, @username = [User].[Name]
        FROM [User]
        WHERE [Email] = @email;
		--EXEC sp_addlogin @username, @DecryptedPassword, [Routine View];

        SET @confirmation = @userid;
    END
    ELSE
    BEGIN
        SET @confirmation = 0;
    END
END;
GO



DROP PROCEDURE IF EXISTS addTaskToGroup
GO

CREATE PROCEDURE addTaskToGroup
    @TaskGroupTitle varchar(50),
    @TaskTitle varchar(100)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        DECLARE @ErrorUpdates TABLE (
            TaskTitle varchar(100),
            TaskGroupTitle varchar(50)
        );

        BEGIN TRANSACTION;

        -- Update the task with the group code
        DECLARE @TaskGroupCode int;

        SELECT @TaskGroupCode = Code
        FROM Task_Group
        WHERE Title = @TaskGroupTitle;

        UPDATE Task_Group
        SET Curr_undone_task_num = Curr_undone_task_num + 1
        WHERE Title = @TaskGroupTitle;

        IF @@ROWCOUNT = 0
        BEGIN
            INSERT INTO @ErrorUpdates (TaskTitle, TaskGroupTitle)
            VALUES (@TaskTitle, @TaskGroupTitle);
        END

        UPDATE Task
        SET TaskGroupCode = @TaskGroupCode, Task.[State] = 'ToDo'
        WHERE Title = @TaskTitle;

        IF @@ROWCOUNT = 0
        BEGIN
            INSERT INTO @ErrorUpdates (TaskTitle, TaskGroupTitle)
            VALUES (@TaskTitle, @TaskGroupTitle);
        END

        -- Update the overall priority of the group task
        DECLARE @overallPrior int;

        SELECT @overallPrior = AVG([Priority])
        FROM [Task_Group] g
        JOIN [Task] t ON g.Code = t.TaskGroupCode
        WHERE g.Title = @TaskGroupTitle;

        UPDATE Task_Group
        SET Task_Group.OveralPriority = @overallPrior
        WHERE Task_Group.Title = @TaskGroupTitle;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
        BEGIN
            PRINT 'Error on adding task ' + @TaskTitle + ' to group ' + @TaskGroupTitle;
            ROLLBACK TRANSACTION;
        END
    END CATCH;
END
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
GO


DROP PROCEDURE IF EXISTS createTaskGroup
GO

CREATE PROCEDURE createTaskGroup
    @title varchar(50),
	@description varchar(100),
	@assoc_type varchar(20),
	@userid int
AS
BEGIN
    declare @assoc_code int;

	select @assoc_code = tg.Assoc_Code
	from [Task_Group_Assoc] tg
	where tg.CriteriaType = @assoc_type;

	insert into Task_Group ([Title],[Description],[Assoc_code], [DateOfCreation] , [userID])
	values (@title,@description,@assoc_code, GETDATE(),@userid  );

END