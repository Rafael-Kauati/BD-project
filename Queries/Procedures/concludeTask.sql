USE [Routine View]
GO

DROP PROCEDURE IF EXISTS concludeTask
GO

CREATE PROCEDURE concludeTask (@taskname VARCHAR(30))
AS
BEGIN

        DECLARE @taskcode INT;
        DECLARE @taskdeadline DATETIME;
        DECLARE @taskpriority INT;

        SELECT @taskcode = Code, @taskdeadline = Deadline, @taskpriority = [Priority]
        FROM [Task]
        WHERE Title = @taskname;

        UPDATE [Task]
        SET StackID = 3, Task.Conclusion = GETDATE()
        WHERE Title = @taskname;

		update [Stack]
		set CurrMaxTasks = CurrMaxTasks + 1
		where [Stack].StackID = 3;

		update [Stack]
		set CurrMaxTasks = CurrMaxTasks - 1
		where [Stack].StackID = 2;

        INSERT INTO [Reward] ([Task_code], [Task_Deadline], [Date_Time], [Reward_Value])
        VALUES (@taskcode, 
		ISNULL(@taskdeadline, 
		GETDATE()), 
		GETDATE(), @taskpriority * 2);


END
GO


