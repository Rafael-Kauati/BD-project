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
		INSERT INTO [Task] (Title, [Description], Importance, Deadline, [UserID])
		VALUES (@Title, @Description, @Importance, @Deadline, @UserID);

		UPDATE [Stack]
		SET CurrMaxTasks = CurrMaxTasks + 1
		WHERE StackID = 1;

		FETCH NEXT FROM cursorTasks INTO @Title, @Description, @Importance, @Deadline, @UserID;
	END;

	CLOSE cursorTasks;

	DEALLOCATE cursorTasks;

end;
go

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