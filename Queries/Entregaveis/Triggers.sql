use [Routine View]
go

DROP TRIGGER IF EXISTS updateTask;
GO

CREATE TRIGGER updateTask ON [Task]
INSTEAD OF UPDATE
AS
BEGIN
    DECLARE @Title VARCHAR(100),
            @Description VARCHAR(100),
            @Importance INT,
            @Priority INT,
            @StackID INT,
            @State varchar(10),
			@TaskGroupCode int,
            @Deadline DATETIME;

    DECLARE cursorTasks CURSOR FOR
        SELECT Title, [Description], Importance,[Priority], StackID ,State, TaskGroupCode,Deadline
        FROM inserted;

    OPEN cursorTasks;

    FETCH NEXT FROM cursorTasks INTO @Title, @Description, @Importance, @Priority,@StackID, @State,@TaskGroupCode ,@Deadline;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        UPDATE t
        SET t.Title = ISNULL(i.Title, t.Title),
            t.[Description] = ISNULL(i.[Description], t.[Description]),
            t.Importance = ISNULL(i.Importance, t.Importance),
            t.Priority = ISNULL(i.Priority, t.Priority),
            t.StackID = ISNULL(i.StackID, t.StackID),
            t.State = ISNULL(i.State, t.State),
            t.[TaskGroupCode] = ISNULL(i.[TaskGroupCode], t.[TaskGroupCode]),
            t.Deadline = ISNULL(i.Deadline, t.Deadline)
        FROM [Task] t
        INNER JOIN inserted i ON t.[Code] = i.[Code];

	    FETCH NEXT FROM cursorTasks INTO @Title, @Description, @Importance, @Priority,@StackID, @State,@TaskGroupCode ,@Deadline;
    END;

    CLOSE cursorTasks;
    DEALLOCATE cursorTasks;
END;
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
GO

drop trigger if exists encryptPassword
go

create trigger encryptPassword on [User]
after insert
as
begin
	DECLARE @UserID INT
    DECLARE @Password CHAR(40)

    DECLARE UserCursor CURSOR FOR
    SELECT ID, [Password] FROM inserted

    OPEN UserCursor
    FETCH NEXT FROM UserCursor INTO @UserID, @Password

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Atualiza a coluna Password com o valor criptografado
        UPDATE [User]
        SET [Password] =  CONVERT(VARBINARY(8000), EncryptByPassPhrase('ThePassphrase', @Password))
        WHERE ID = @UserID

        FETCH NEXT FROM UserCursor INTO @UserID, @Password
    END

    CLOSE UserCursor
    DEALLOCATE UserCursor
end
go

drop trigger if exists createTask
go

create trigger createTask on [Task] 
instead of insert 
as 
begin
	DECLARE @Title varchar(100), 
			@Description varchar(100), 
			@Importance int, 
			@Deadline datetime, 
			@UserID int;

	-- Definir o cursor
	DECLARE cursorTasks CURSOR FOR
	SELECT Title, [Description], Importance, Deadline, [UserID]
	FROM inserted;

	OPEN cursorTasks;

	FETCH NEXT FROM cursorTasks INTO @Title, @Description, @Importance, @Deadline, @UserID;

	WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO [Task] (Title, [Description], Importance, Deadline, StackID ,[UserID])
		VALUES (@Title, @Description, @Importance, @Deadline,1 ,@UserID);

		UPDATE [Stack]
		SET CurrMaxTasks = CurrMaxTasks + 1
		WHERE StackID = 1;

		FETCH NEXT FROM cursorTasks INTO @Title, @Description, @Importance, @Deadline, @UserID;
	END;

	CLOSE cursorTasks;

	DEALLOCATE cursorTasks;

end;
go


DROP TRIGGER IF EXISTS updateUserScore;
GO

CREATE TRIGGER updateUserScore
ON [Reward]
AFTER INSERT
AS
BEGIN
    DECLARE @newReward INT;
    DECLARE @userid INT;

    SELECT @newReward = [Reward_Value],
           @userid = Task.UserID
    FROM inserted
    INNER JOIN Task ON inserted.Task_code = Task.Code;

    UPDATE [User]
    SET [Score] = [Score] + @newReward
    WHERE [User].ID = @userid;
    
END;
GO

