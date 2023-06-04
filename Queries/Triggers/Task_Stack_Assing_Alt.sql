USE [Routine View]
GO

DROP TRIGGER IF EXISTS	Task_Stack_Assign 
GO

CREATE TRIGGER Task_Stack_Assign  ON Task
INSTEAD OF INSERT
AS
BEGIN
	 -- Inserir os dados na tabela real
    INSERT INTO [dbo].[Task] (Title, [Description], Importance, Deadline, [Priority], [StackID], [Conclusion], [UserID])
    SELECT Title, [Description], Importance, Deadline, [Priority], [StackID], [Conclusion], [UserID]
    FROM inserted

    DECLARE @RowCount INT = @@ROWCOUNT

    DECLARE @Code INT, @Title VARCHAR(100), @Description VARCHAR(100), @Importance INT, @Deadline DATETIME, @Priority INT, @StackID INT, @Conclusion DATETIME, @UserID INT

    -- Declarar o cursor (Não sei se deveria ser assim)
    DECLARE taskCursor CURSOR FOR
    SELECT Code, Title, [Description], Importance, Deadline, [Priority], [StackID], [Conclusion], [UserID]
    FROM inserted

    -- Abrir o cursor
    OPEN taskCursor

    -- BDa fetch na proxima linha
    FETCH NEXT FROM taskCursor INTO @Code, @Title, @Description, @Importance, @Deadline, @Priority, @StackID, @Conclusion, @UserID

    -- Iteraração
    WHILE @@FETCH_STATUS = 0
    BEGIN
		
        PRINT 'Code: ' + CAST(@Code AS VARCHAR(50))
        PRINT 'Title: ' + @Title
        PRINT 'Description: ' + @Description
        PRINT 'Importance: ' + CAST(@Importance AS VARCHAR(50))
        PRINT 'Deadline: ' + CONVERT(VARCHAR(50), @Deadline, 121)
        PRINT 'Priority: ' + CAST(@Priority AS VARCHAR(50))
        PRINT 'StackID: ' + CAST(@StackID AS VARCHAR(50))
        PRINT 'Conclusion: ' + CONVERT(VARCHAR(50), @Conclusion, 121)
        PRINT 'UserID: ' + CAST(@UserID AS VARCHAR(50))
		

		-- Atualiza a stack
		UPDATE Stack
		SET CurrMaxTasks = CurrMaxTasks + 1
		WHERE StackID = @StackID;

        -- Buscar a próxima linha
        FETCH NEXT FROM taskCursor INTO @Code, @Title, @Description, @Importance, @Deadline, @Priority, @StackID, @Conclusion, @UserID
    END

    -- Da close no cursor
    CLOSE taskCursor
    DEALLOCATE taskCursor
    
END
