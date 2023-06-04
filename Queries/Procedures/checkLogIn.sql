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

    -- Decrypt the password based on the provided email
    SELECT @DecryptedPassword = DecryptByPassPhrase('ThePassphrase', [Password])
    FROM [User]
    WHERE [Email] = @email;

    IF CONVERT(varchar(40), @DecryptedPassword) = @password
    BEGIN
        SELECT @userid = [User].ID
        FROM [User]
        WHERE [Email] = @email;

        SET @confirmation = @userid;
    END
    ELSE
    BEGIN
        SET @confirmation = 0;
    END
END;
GO

