create trigger encryptPassword on [User]
after insert, update
as
begin
	DECLARE @UserID INT
    DECLARE @Password CHAR(40)

    DECLARE UserCursor CURSOR FOR
    SELECT ID, [Password] FROM inserted

    OPEN UserCursor
    FETCH NEXT FROM UserCursor INTO @UserID, @Password

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Atualiza a coluna Password com o valor criptografado
        UPDATE [User]
        SET [Password] =  CONVERT(VARBINARY(8000), EncryptByPassPhrase('ThePassphrase', @Password))
        WHERE ID = @UserID

        FETCH NEXT FROM UserCursor INTO @UserID, @Password
    END

    CLOSE UserCursor
    DEALLOCATE UserCursor
end
go