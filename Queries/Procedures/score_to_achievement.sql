USE [Routine View]
GO

-- Verifica se o procedimento 'concludeTask' já existe
IF OBJECT_ID('concludeTask') IS NOT NULL
    DROP PROCEDURE concludeTask
GO

-- Cria o procedimento 'concludeTask'
CREATE PROCEDURE concludeTask (@taskname VARCHAR(30))
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION; -- Inicia a transação

        DECLARE @taskcode INT;
        DECLARE @taskdeadline DATETIME;
        DECLARE @taskpriority INT;

        SELECT @taskcode = Code, @taskdeadline = Deadline, @taskpriority = [Priority]
        FROM [Task]
        WHERE Title = @taskname;

        UPDATE [Task]
        SET StackID = 3
        WHERE Title = @taskname;

        INSERT INTO [Reward] ([Task_code], [Task_Deadline], [Date_Time], [Reward_Value])
        VALUES (@taskcode, ISNULL(@taskdeadline, GETDATE()), GETDATE(), @taskpriority * 2);

        -- Verifica o número de tarefas concluídas
        DECLARE @completedTasksCount INT;
        SELECT @completedTasksCount = COUNT(*) FROM [Task] WHERE StackID = 3;

        -- Verifica se o número de tarefas concluídas atingiu um determinado limite
        IF @completedTasksCount >= 10 -- Defina o número desejado de tarefas concluídas para ganhar o achievement
        BEGIN
            -- Lógica para ganhar o achievement
            INSERT INTO [Achievement] ([Title], [Date_Time])
            VALUES ('Concluir 10 tarefas', GETDATE());
        END

        COMMIT; 

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK; 
    END CATCH
END
GO

-- Exemplo de chamada da procedure
EXEC concludeTask 'Conferir estoque';