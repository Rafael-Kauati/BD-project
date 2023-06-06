--use [Routine View]
--go


INSERT INTO [User] ([Name], [Email], [Password], [DoB]) 
VALUES 
	('Daniel', 'daniel@ua.pt', CONVERT(VARBINARY(8000), 'password'), '2011-01-01'),
	('Pedro Ramos', 'PR@ua.pt', CONVERT(VARBINARY(8000), 'anotherpassword'), '2019-01-01');
go

INSERT INTO [Stack] ([Name]) VALUES ('To Do');
INSERT INTO [Stack] ([Name]) VALUES ('Doing');
INSERT INTO [Stack] ([Name]) VALUES ('Done');


INSERT INTO [Task] (Title, [Description], Importance, Deadline, [UserID])
VALUES ('Enviar relat�rio semanal', 'Preparar e enviar relat�rio de desempenho semanal da equipe', 2, '2023-06-19 09:00:00', 10),
('Atualizar planilha de vendas', 'Inserir os dados de vendas atualizados na planilha de acompanhamento', 4, '2023-07-20 14:30:00', 10),
('Realizar reuni�o de equipe', 'Agendar e conduzir uma reuni�o com a equipe para alinhar as metas do m�s', 3, '2023-06-29 11:00:00', 10),
('Task 3', 'Descri��o 3', 3, '2023-06-29 11:00:00', 10),
('Task 4', 'Descri��o 4', 1, '2023-06-29 11:00:00', 10),
('Enviar convites para evento', 'Elaborar e enviar convites para os participantes do evento corporativo', 5, '2023-09-22 16:30:00', 10),
('Task 2', 'Elaborar e enviar convites para os participantes do evento corporativo', 5, '2023-09-22 16:30:00', 15),
('Task 5', 'Elaborar e enviar convites para os participantes do evento corporativo', 5, '2023-09-22 16:30:00', 15),
('Task 6', 'Descri��o 6', 2, '2023-06-12 13:45:00', 15),
('Task 7', 'Descri��o 7', 3, '2023-06-15 10:00:00', 10),
('Task 8', 'Descri��o 8', 4, '2023-06-09 16:00:00', 10);

 

 insert into [Task_Group_Assoc] (CriteriaType) values
('Importance'), ('Deadline'), ('Category');

execute createTaskGroup @title = 'Tarefas Importantes', @description = 'Tarefas Importantes a serem feitas',
@assoc_type = 'Importance', @userid = 10;


EXECUTE addTaskToGroup 
@TaskGroupTitle = 'Tarefas Importantes', @TaskTitle = 'Task 3';

EXECUTE addTaskToGroup 
@TaskGroupTitle =  'Tarefas Importantes', @TaskTitle = 'Task 4';

SELECT * FROM getTaskGroup('Tarefas Importantes', 'ToDo');

EXECUTE startTask @taskname = 'Atualizar planilha de vendas';

select * from [Task]; 
select * from [User]; 
select * from [Stack]; 
select * from [Reward]; 
select * from getAllTaskGroups(10);
