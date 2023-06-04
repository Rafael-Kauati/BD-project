USE [Routine View]
GO
DROP TRIGGER IF EXISTS	Task_Stack_Assign_Update 
GO
CREATE TRIGGER Task_Stack_Assign_Update ON Task
INSTEAD OF UPDATE
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION; -- Inicia a transação

        DECLARE @OldStackID INT;
        DECLARE @NewStackID INT;

		DECLARE @Code INT, @Title VARCHAR(100), @Description VARCHAR(100), @Importance INT, @Deadline DATETIME, @Priority INT, @StackID INT, @Conclusion DATETIME, @UserID INT


        -- Obtém a antiga StackID da tabela Task antes da atualização
        SELECT @OldStackID = t.[StackID]
        FROM [Task] t
        INNER JOIN deleted d ON t.Code = d.Code;

        -- Reduz por 1 o valor da coluna CurrMaxTasks na antiga Stack
        UPDATE Stack
        SET CurrMaxTasks = CurrMaxTasks - 1
        WHERE StackID = @OldStackID;

        -- Atualiza a coluna StackID na tabela Task
        UPDATE t
        SET t.[StackID] = i.[StackID]
        FROM [Task] t
        INNER JOIN inserted i ON t.Code = i.Code;

        -- Obtém a nova StackID da tabela Task após a atualização
        SELECT @NewStackID = t.[StackID]
        FROM [Task] t
        INNER JOIN inserted i ON t.Code = i.Code;

        -- Insere os dados atualizados na tabela real
        INSERT INTO [dbo].[Task] (Title, [Description], Importance, Deadline, [Priority], [StackID], [Conclusion], [UserID])
        SELECT i.Title, i.[Description], i.Importance, i.Deadline, i.[Priority], i.[StackID], i.[Conclusion], i.[UserID]
        FROM inserted i
        LEFT JOIN [Task] t ON t.Code = i.Code
        WHERE t.Code IS NULL;

        -- Incrementa por 1 o valor da coluna CurrMaxTasks na nova Stack
        UPDATE Stack
        SET CurrMaxTasks = CurrMaxTasks + 1
        WHERE StackID = @NewStackID;

        COMMIT; -- Confirma a transação

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK; -- Desfaz a transação em caso de erro
    END CATCH
END
