USE [Routine View]
GO

DROP PROCEDURE IF EXISTS checkLogIn;
GO

CREATE PROCEDURE checkLogIn
   ( @email varchar(40),
	@password varchar(40),
	 @confirmation int OUTPUT)
AS
BEGIN
	DECLARE @matches int;
	SELECT @matches = COUNT(*) FROM [User] WHERE [User].Email = @email;

	IF @matches = 1
	BEGIN
		DECLARE @name varchar(50);
		SELECT @name = [User].[Name] FROM [User] WHERE [User].Email = @email;

		-- Verificar se o login já existe
		IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = @name)
		BEGIN
			-- Criar login e usuário
			DECLARE @sql varchar(MAX);
			SET @sql = 'CREATE LOGIN ' + QUOTENAME(@name) + ' WITH PASSWORD = ''' + @password + ''';';
			SET @sql += 'CREATE USER ' + QUOTENAME(@name) + ' FOR LOGIN ' + QUOTENAME(@name) + ';';

			EXEC (@sql);
		END

		SET @confirmation = 1;
	END
	ELSE
	BEGIN
		SET @confirmation = 0;
	END

	RETURN @confirmation;
END
GO
