use [Routine View]
go

drop trigger if exists createTask
go

create trigger createTask on [Task] 
instead of insert 
as 
begin
	-- Definir variáveis para armazenar os valores durante a iteração
	DECLARE @Title varchar(100), 
			@Description varchar(100), 
			@Importance int, 
			@Deadline datetime, 
			@UserID int;

	-- Definir o cursor
	DECLARE cursorTasks CURSOR FOR
	SELECT Title, [Description], Importance, Deadline, [UserID]
	FROM inserted;

	-- Abrir o cursor
	OPEN cursorTasks;

	-- Inicializar as variáveis com os valores do primeiro registro
	FETCH NEXT FROM cursorTasks INTO @Title, @Description, @Importance, @Deadline, @UserID;

	-- Loop enquanto houver registros no cursor
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- Inserir o registro na tabela [Task]
		INSERT INTO [Task] (Title, [Description], Importance, Deadline, [UserID])
		VALUES (@Title, @Description, @Importance, @Deadline, @UserID);

		-- Atualizar a tabela [Stack]
		UPDATE [Stack]
		SET CurrMaxTasks = CurrMaxTasks + 1
		WHERE StackID = 1;

		-- Obter o próximo registro do cursor
		FETCH NEXT FROM cursorTasks INTO @Title, @Description, @Importance, @Deadline, @UserID;
	END;

	-- Fechar o cursor
	CLOSE cursorTasks;

	-- Liberar os recursos do cursor
	DEALLOCATE cursorTasks;

end;
go
