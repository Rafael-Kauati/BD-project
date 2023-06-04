use [Routine View]
go

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
    DECLARE @UserName varchar(256), @UserPassword varchar(40), @SQL nvarchar(max);

    -- Abertura do cursor
    OPEN user_cursor;

    -- Obtenção do primeiro registro
    FETCH NEXT FROM user_cursor INTO @ID, @Name, @Email, @Password, @DoB;

    -- Iteração sobre os registros
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @UserName = CAST(@Name AS varchar(30));
        SET @UserPassword = CAST(@Password AS varchar(40));

		SET @SQL = N'CREATE LOGIN ' + QUOTENAME(@UserName) + N' WITH PASSWORD = ''' + @UserPassword + N''';';
        EXEC sp_executesql @SQL;

        SET @SQL = N'CREATE USER ' + QUOTENAME(@UserName) + N' FOR LOGIN ' + QUOTENAME(@UserName) + N';';
        EXEC sp_executesql @SQL;

        FETCH NEXT FROM user_cursor INTO @ID, @Name, @Email, @Password, @DoB;
    END

    -- Fechamento e desalocação do cursor
    CLOSE user_cursor;
    DEALLOCATE user_cursor;
END
GO
