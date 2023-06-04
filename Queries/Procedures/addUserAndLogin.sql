DROP TRIGGER IF EXISTS addUserAndLogin;
GO

CREATE TRIGGER addUserAndLogin
ON [User]
AFTER INSERT
AS
BEGIN
    DECLARE @ID int, @Name varchar(256), @Email varchar(40), @Password char(40), @DoB date;

    -- Declaração do cursor
    DECLARE user_cursor CURSOR LOCAL FAST_FORWARD FOR
    SELECT ID, [Name], [Email], [Password], [DoB]
    FROM inserted;

    -- Declaração das variáveis
    DECLARE @LoginName varchar(256), @UserName varchar(256), @SQL nvarchar(max);

    -- Abertura do cursor
    OPEN user_cursor;

    -- Obtenção do primeiro registro
    FETCH NEXT FROM user_cursor INTO @ID, @Name, @Email, @Password, @DoB;

    -- Iteração sobre os registros
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @LoginName = CAST(@Name AS varchar(30));
        SET @UserName = CAST(@Name AS varchar(30));

        IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = @LoginName)
        BEGIN
            SET @SQL = N'CREATE LOGIN ' + QUOTENAME(@LoginName) + N' WITH PASSWORD = ''password'';';
            EXEC sp_executesql @SQL;
        END

        -- Verifica se o USER já existe
        IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = @UserName)
        BEGIN
            -- Cria o USER associado ao LOGIN
            SET @SQL = N'USE [Routine View]; CREATE USER ' + QUOTENAME(@UserName) + N' FOR LOGIN ' + QUOTENAME(@LoginName) + N';';
            EXEC sp_executesql @SQL;
        END

        -- Obtém o próximo registro
        FETCH NEXT FROM user_cursor INTO @ID, @Name, @Email, @Password, @DoB;
    END

    -- Fechamento e desalocação do cursor
    CLOSE user_cursor;
    DEALLOCATE user_cursor;
END
GO
