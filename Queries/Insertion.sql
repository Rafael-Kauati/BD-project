use [Routine View]
go

/*
delete from [Reward] where 1=1;
delete from [Task_Group_Assoc] where 1=1;
delete from [Task_Group] where 1=1;
delete from [TaskAchievement] where 1=1;
delete from [Achieviement] where 1=1;
delete from [Task] where 1=1;
delete from [Stack]where 1=1;
delete from [User] where 1=1;*/
--delete from where 1=1;

INSERT INTO [User] ([Name], [Email], [Password], [DoB]) 
VALUES 
	('Danilo', 'danilo@ua.pt', CONVERT(VARBINARY(8000), 'password'), '2011-01-01'),
	('Pedro Branches', 'PB@ua.pt', CONVERT(VARBINARY(8000), 'ManjaroTrash'), '2019-01-01'),
	('Jane Smith', 'janesmith@example.com', CONVERT(VARBINARY(8000), 'anotherpassword'), '1995-05-05'),
	('Bob Johnson', 'bobjohnson@example.com', CONVERT(VARBINARY(8000), 'supersecurepassword'), '1985-12-31');
go

-- Excluir usuário Danilo


EXECUTE addUserAndLogin;


--SELECT 'username', host FROM mysql.user WHERE db = 'Routine View';


insert into
	[Stack]
	( [Name]) values
	( 'To Do'), ( 'Doing'),( 'Done');
go

INSERT INTO [Task] (Title, [Description], Importance, Deadline,   [UserID])
VALUES ('Enviar relatório semanal', 'Preparar e enviar relatório de desempenho semanal da equipe', 2, '2023-06-19 09:00:00',   10),

('Atualizar planilha de vendas', 'Inserir os dados de vendas atualizados na planilha de acompanhamento', 4, '2023-07-20 14:30:00',   10),
 ('Realizar reunião de equipe', 'Agendar e conduzir uma reunião com a equipe para alinhar as metas do mês', 3, '2023-06-29 11:00:00',  10),
 ('Task 3', 'Descrição 3', 3, '2023-06-29 11:00:00',  10),
 ('Task 4', 'Descrição 4', 1, '2023-06-29 11:00:00',  10),

 ('Enviar convites para evento', 'Elaborar e enviar convites para os participantes do evento corporativo', 5, '2023-09-22 16:30:00',   10),
 ('Task 2', 'Elaborar e enviar convites para os participantes do evento corporativo', 5, '2023-09-22 16:30:00',   15),
 ('Task 5', 'Elaborar e enviar convites para os participantes do evento corporativo', 5, '2023-09-22 16:30:00',   15);

 

 insert into [Task_Group_Assoc] (CriteriaType) values
('Importance'), ('Deadline'), ('Category');

insert into [Task_Group]  ([Assoc_code],[StackID], [Title], [DateOfCreation] ) values
(1, 1, 'Tarefas importantes', GETDATE()),(2, 1, 'Emitir folha de pagamento', GETDATE());


EXECUTE addTaskToGroup 
@TaskGroupTitle = 'Tarefas importantes', @TaskTitle = 'Enviar relatório semanal';

EXECUTE addTaskToGroup 
@TaskGroupTitle =  'Tarefas importantes', @TaskTitle = 'Atualizar planilha de vendas';



EXECUTE addTaskToGroup 
@TaskGroupTitle =  'Emitir folha de pagamento', @TaskTitle = 'Realizar reunião de equipe';




select * from [Task]; 
select * from [User]; 
select * from [Stack]; 
select * from [Task_Group]; 
select * from [Reward]; 

SELECT * FROM getTaskGroup('Tarefas importantes', 'ToDo');
--select * from getTaskGroup('Tarefas importantes');

 /*
exec startTask 'Realizar reunião de equipe';
 exec concludeTask 'Realizar reunião de equipe';

insert into [Task_Group]  ([Assoc_code],[StackID], [Title], [DateOfCreation] ) values
(1, 1, 'Tarefas importantes', GETDATE()),(2, 1, 'Emitir folha de pagamento', GETDATE());

--EXECUTE addTaskToGroup @taskGroupTitle = 'Tarefas importantes', @taskCode = 4;

EXECUTE addTaskToGroup 
@TaskGroupTitle = 'Tarefas importantes', @TaskTitle = 'Enviar relatório semanal';

EXECUTE addTaskToGroup 
@TaskGroupTitle =  'Tarefas importantes', @TaskTitle = 'Atualizar planilha de vendas';

*/


--select * from [Task_Group]; 
