use [Routine View]
go


drop function if exists GetAllTasksInStack
go

CREATE FUNCTION GetAllTasksInStack
    (@stackName VARCHAR(40))
RETURNS TABLE
AS
RETURN
(
    SELECT
        t.Code AS TaskCode,
        t.Title AS TaskTitle,
        t.TaskGroupCode AS TaskGroup,
        t.Description AS TaskDescription,
        t.Importance AS TaskImportance,
        t.Deadline AS TaskDeadline,
        t.State AS TaskState,
        t.Priority AS TaskPriority,
        t.StackID,
        t.Conclusion AS TaskConclusion,
        t.UserID
    FROM
        [Stack] s
        JOIN [Task] t ON s.StackID = t.StackID
    WHERE
        s.[Name] = @stackName 
        AND t.TaskGroupCode IS NULL
);
GO



drop procedure if exists startTask
go

create procedure startTask(@taskname varchar(30))
as
begin

	
	update [Task]
	set StackID = 2
	where Task.Title = @taskname;

	update [Stack]
	set CurrMaxTasks = CurrMaxTasks + 1
	where [Stack].StackID = 2;



	update [Stack]
	set CurrMaxTasks = CurrMaxTasks - 1
	where [Stack].StackID = 1;

	
end
go


drop trigger if exists createTask
go

create trigger createTask on [Task] 
instead of insert 
as 
begin
	-- Definir variáveis para armazenar os valores durante a iteração
	DECLARE @Title varchar(100), 
			@Description varchar(100), 
			@Importance int, 
			@Deadline datetime, 
			@UserID int;

	-- Definir o cursor
	DECLARE cursorTasks CURSOR FOR
	SELECT Title, [Description], Importance, Deadline, [UserID]
	FROM inserted;

	-- Abrir o cursor
	OPEN cursorTasks;

	-- Inicializar as variáveis com os valores do primeiro registro
	FETCH NEXT FROM cursorTasks INTO @Title, @Description, @Importance, @Deadline, @UserID;

	-- Loop enquanto houver registros no cursor
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- Inserir o registro na tabela [Task]
		INSERT INTO [Task] (Title, [Description], Importance, Deadline, [UserID])
		VALUES (@Title, @Description, @Importance, @Deadline, @UserID);

		-- Atualizar a tabela [Stack]
		UPDATE [Stack]
		SET CurrMaxTasks = CurrMaxTasks + 1
		WHERE StackID = 1;

		-- Obter o próximo registro do cursor
		FETCH NEXT FROM cursorTasks INTO @Title, @Description, @Importance, @Deadline, @UserID;
	END;

	-- Fechar o cursor
	CLOSE cursorTasks;

	-- Liberar os recursos do cursor
	DEALLOCATE cursorTasks;

end;
go



DROP PROCEDURE IF EXISTS concludeTask;
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
    SET StackID = 3
    WHERE Title = @taskname;

    UPDATE [Stack]
    SET CurrMaxTasks = CurrMaxTasks + 1
    WHERE [Stack].StackID = 3;

    UPDATE [Stack]
    SET CurrMaxTasks = CurrMaxTasks - 1
    WHERE [Stack].StackID = 2;

    INSERT INTO [Reward] ([Task_code], [Task_Deadline], [Date_Time], [Reward_Value])
    VALUES (@taskcode, ISNULL(@taskdeadline, GETDATE()), GETDATE(), @taskpriority * 2);

    -- Dispare o trigger updateUserScore manualmente

    -- Outras instruções, se necessário
    -- ...

END;
GO


DROP PROCEDURE IF EXISTS checkLogIn;
GO

CREATE PROCEDURE checkLogIn
   ( @email varchar(40),
	@password varchar(40),
	 @confirmation int OUTPUT)
AS
BEGIN
	declare @matches  int ;
	select @matches =  count(*) from [User] 
	where [User].Email = @email and [User].[Password] = @password;
	
	IF @matches = 1
		set @confirmation = 1;
	ELSE
		set @confirmation = 0;

	return @confirmation;
		
END
GO


DROP TRIGGER IF EXISTS update_priority
GO

CREATE TRIGGER update_priority ON Task
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    IF @@TRANCOUNT > 0
    BEGIN
        IF XACT_STATE() = 1
        BEGIN
            UPDATE t
            SET t.[Priority] = CASE
                                  WHEN DATEDIFF(MINUTE, GETDATE(), i.[Deadline]) / 60 BETWEEN 0 AND 24 THEN
                                      CASE
                                          WHEN i.[Importance] >= 1 AND i.[Importance] < 3 THEN 3
                                          WHEN i.[Importance] >= 3 AND i.[Importance] <= 5 THEN 5
                                      END
                                  WHEN DATEDIFF(MINUTE, GETDATE(), i.[Deadline]) / 60 BETWEEN 24 AND 48 THEN
                                      CASE
                                          WHEN i.[Importance] >= 1 AND i.[Importance] < 3 THEN 2
                                          WHEN i.[Importance] >= 3 AND i.[Importance] <= 5 THEN 4
                                      END
                                  WHEN DATEDIFF(MINUTE, GETDATE(), i.[Deadline]) / 60 >= 48 THEN
                                      CASE
                                          WHEN i.[Importance] >= 1 AND i.[Importance] < 3 THEN 1
                                          WHEN i.[Importance] >= 3 AND i.[Importance] <= 5 THEN 3
                                      END
                              END
            FROM Task t
            INNER JOIN inserted i ON t.Code = i.Code;

            IF @@ERROR <> 0
            BEGIN
                ROLLBACK;
                RETURN;
            END
        END
        ELSE
        BEGIN
            RAISERROR('A transação em andamento é implícita. O trigger "update_priority" requer uma transação explícita.', 16, 1);
            RETURN;
        END
    END
    ELSE
    BEGIN
        BEGIN TRANSACTION;

        BEGIN TRY
            UPDATE t
            SET t.[Priority] = CASE
                                  WHEN DATEDIFF(MINUTE, GETDATE(), i.[Deadline]) / 60 BETWEEN 0 AND 24 THEN
                                      CASE
                                          WHEN i.[Importance] >= 1 AND i.[Importance] < 3 THEN 3
                                          WHEN i.[Importance] >= 3 AND i.[Importance] <= 5 THEN 5
                                      END
                                  WHEN DATEDIFF(MINUTE, GETDATE(), i.[Deadline]) / 60 BETWEEN 24 AND 48 THEN
                                      CASE
                                          WHEN i.[Importance] >= 1 AND i.[Importance] < 3 THEN 2
                                          WHEN i.[Importance] >= 3 AND i.[Importance] <= 5 THEN 4
                                      END
                                  WHEN DATEDIFF(MINUTE, GETDATE(), i.[Deadline]) / 60 >= 48 THEN
                                      CASE
                                          WHEN i.[Importance] >= 1 AND i.[Importance] < 3 THEN 1
                                          WHEN i.[Importance] >= 3 AND i.[Importance] <= 5 THEN 3
                                      END
                              END
            FROM Task t
            INNER JOIN inserted i ON t.Code = i.Code;

            COMMIT;
        END TRY
        BEGIN CATCH
            ROLLBACK;
            THROW;
        END CATCH
    END
END

drop trigger if exists updateUserScore
go

