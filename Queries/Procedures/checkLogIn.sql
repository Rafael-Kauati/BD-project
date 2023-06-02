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
    DECLARE @DecryptedPassword varchar(40);
    DECLARE @userid int;

    -- Decrypt the password based on the provided email
    SELECT @DecryptedPassword = CONVERT(VARCHAR(40), DecryptByPassPhrase('ThePassphrase', [Password]))
    FROM [User]
    WHERE [Email] = @email

    PRINT 'password decrypt ' + @DecryptedPassword

    IF @DecryptedPassword = @password
    BEGIN
        SELECT @userid = [User].ID
        FROM [User]
        WHERE [Email] = @email

        SET @confirmation = @userid
    END
    ELSE
    BEGIN
        SET @confirmation = 0
    END
END;
GO
