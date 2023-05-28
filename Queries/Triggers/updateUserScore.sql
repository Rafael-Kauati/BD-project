use [Routine View]
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
