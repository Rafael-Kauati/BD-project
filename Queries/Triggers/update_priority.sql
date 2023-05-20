USE [Routine View]
GO

DROP TRIGGER IF EXISTS update_priority
GO

CREATE TRIGGER update_priority ON Task
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Verifica se h� uma transa��o em andamento
    IF @@TRANCOUNT > 0
    BEGIN
        -- Verifica se a transa��o � uma transa��o expl�cita
        IF XACT_STATE() = 1
        BEGIN
            -- Transa��o expl�cita em andamento, realizar as atualiza��es
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

            -- Verifica se ocorreram erros
            IF @@ERROR <> 0
            BEGIN
                -- Ocorreu um erro, desfazer a transa��o
                ROLLBACK;
                RETURN;
            END
        END
        ELSE
        BEGIN
            -- Transa��o impl�cita em andamento, n�o � poss�vel realizar atualiza��es
            RAISERROR('A transa��o em andamento � impl�cita. O trigger "update_priority" requer uma transa��o expl�cita.', 16, 1);
            RETURN;
        END
    END
    ELSE
    BEGIN
        -- Nenhuma transa��o em andamento, realizar as atualiza��es sem transa��o
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
            -- Ocorreu um erro, desfazer a transa��o
            ROLLBACK;
            THROW;
        END CATCH
    END
END
