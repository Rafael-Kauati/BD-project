USE [Routine View]
GO

CREATE TRIGGER Task_Stack_Assign  ON Task
INSTEAD OF INSERT
AS
BEGIN
	 -- Inserir os dados na tabela real
    INSERT INTO [dbo].[Task] (Title, [Description], Importance, Deadline, [Priority], [StackID], [Conclusion], [UserID])
    SELECT Title, [Description], Importance, Deadline, [Priority], [StackID], [Conclusion], [UserID]
    FROM inserted

    -- Obter o número de linhas inseridas
    DECLARE @RowCount INT = @@ROWCOUNT

    -- Declarar as variáveis para armazenar os valores das colunas
    DECLARE @Code INT, @Title VARCHAR(100), @Description VARCHAR(100), @Importance INT, @Deadline DATETIME, @Priority INT, @StackID INT, @Conclusion DATETIME, @UserID INT

    -- Declarar o cursor
    DECLARE cursorName CURSOR FOR
    SELECT Code, Title, [Description], Importance, Deadline, [Priority], [StackID], [Conclusion], [UserID]
    FROM inserted

    -- Abrir o cursor
    OPEN cursorName

    -- Buscar a primeira linha
    FETCH NEXT FROM cursorName INTO @Code, @Title, @Description, @Importance, @Deadline, @Priority, @StackID, @Conclusion, @UserID

    -- Iterar sobre as linhas
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Acessar os valores das colunas
        -- Faça o que precisar com os valores aqui
		/*
        PRINT 'Code: ' + CAST(@Code AS VARCHAR(50))
        PRINT 'Title: ' + @Title
        PRINT 'Description: ' + @Description
        PRINT 'Importance: ' + CAST(@Importance AS VARCHAR(50))
        PRINT 'Deadline: ' + CONVERT(VARCHAR(50), @Deadline, 121)
        PRINT 'Priority: ' + CAST(@Priority AS VARCHAR(50))
        PRINT 'StackID: ' + CAST(@StackID AS VARCHAR(50))
        PRINT 'Conclusion: ' + CONVERT(VARCHAR(50), @Conclusion, 121)
        PRINT 'UserID: ' + CAST(@UserID AS VARCHAR(50))
		*/

		-- Atualiza a stack
		UPDATE Stack
		SET CurrMaxTasks = CurrMaxTasks + 1
		WHERE StackID = @StackID;

        -- Buscar a próxima linha
        FETCH NEXT FROM cursorName INTO @Code, @Title, @Description, @Importance, @Deadline, @Priority, @StackID, @Conclusion, @UserID
    END

    -- Fechar e desalocar o cursor
    CLOSE cursorName
    DEALLOCATE cursorName
    
END
