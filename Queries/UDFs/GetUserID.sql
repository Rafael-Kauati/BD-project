use [Routine View]
go

IF OBJECT_ID('GetUserID', 'FN') IS NOT NULL
    DROP FUNCTION GetUserID;
GO

CREATE FUNCTION GetUserID
(
    @Email varchar(40),
    @Password varchar(40)
)
RETURNS int
AS
BEGIN
    DECLARE @UserID int

    -- Descriptografar a senha com base no e-mail fornecido
    DECLARE @DecryptedPassword varchar(40)
    SELECT @DecryptedPassword = CONVERT(VARCHAR(40), DecryptByPassPhrase('ThePassphrase', [Password]))
    FROM [User]
    WHERE [Email] = @Email

    -- Obter o ID do usuário com base no e-mail e senha descriptografados
    SELECT @UserID = ID
    FROM [User]
    WHERE [Email] = @Email AND [Password] = CONVERT(VARBINARY(8000), @DecryptedPassword)

    RETURN @UserID
END;
GO


SELECT  * FROM GetUserID('danilo@ua.pt', 'password')
go