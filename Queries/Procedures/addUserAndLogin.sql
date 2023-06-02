USE [Routine View]
GO

DROP PROCEDURE IF EXISTS addUserAndLogin
GO

CREATE PROCEDURE addUserAndLogin
AS
BEGIN
    -- Variáveis para armazenar os valores dos registros
    DECLARE @ID int, @Name varchar(256), @Email varchar(40), @Password char(40), @DoB date;

    -- Cursor para percorrer os registros da tabela [User]
    DECLARE user_cursor CURSOR FOR
    SELECT ID, [Name], [Email], [Password], [DoB]
    FROM [User];

    -- Variáveis para armazenar os nomes do login e do usuário
    DECLARE @LoginName varchar(256), @UserName varchar(256), @SQL nvarchar(max);

    -- Abre o cursor
    OPEN user_cursor;

    -- Busca o primeiro registro
    FETCH NEXT FROM user_cursor INTO @ID, @Name, @Email, @Password, @DoB;

    -- Loop para criar o LOGIN e o USER para cada membro
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Gera os nomes do LOGIN e do USER baseado no ID do usuário
        SET @LoginName = CAST(@Name AS varchar(10));
        SET @UserName = CAST(@Name AS varchar(10));

        -- Verifica se o LOGIN já existe
        IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = @LoginName)
        BEGIN
            -- Cria o LOGIN
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

        -- Busca o próximo registro
        FETCH NEXT FROM user_cursor INTO @ID, @Name, @Email, @Password, @DoB;
    END

    -- Fecha o cursor
    CLOSE user_cursor;
    DEALLOCATE user_cursor;
END
GO
