USE [Routine View]
GO

DROP PROCEDURE IF EXISTS checkLogIn;
GO

CREATE PROCEDURE checkLogIn
(
    @email varchar(40),
    @password varchar(40),
    @confirmation int OUTPUT
)
AS
BEGIN
    DECLARE @DecryptedPassword varbinary(8000);
    DECLARE @userid int;

    SELECT @DecryptedPassword = DecryptByPassPhrase('ThePassphrase', [Password])
    FROM [User]
    WHERE [Email] = @email;

    IF CONVERT(varchar(40), @DecryptedPassword) = @password
    BEGIN
		--DECLARE @username varchar(50);
        SELECT @userid = [User].ID--, @username = [User].[Name]
        FROM [User]
        WHERE [Email] = @email;
		--EXEC sp_addlogin @username, @DecryptedPassword, [Routine View];

        SET @confirmation = @userid;
    END
    ELSE
    BEGIN
        SET @confirmation = 0;
    END
END;
GO
