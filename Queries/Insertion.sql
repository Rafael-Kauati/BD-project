use [Routine View]
go

insert into 
	[User] 
	( [Name], [Email], [Password],[DoB]) 
	values ( 'Danilo', 'danilo@ua.pt', 'password' ,'2011-01-01'),
	( 'Pedro Branches', 'PB@ua.pt', 'ManjaroTrash', '2019-01-01'),
	('Jane Smith', 'janesmith@example.com', 'anotherpassword', '1995-05-05'),
	('Bob Johnson', 'bobjohnson@example.com', 'supersecurepassword', '1985-12-31');;
go

insert into
	[Stack]
	( [Name]) values
	( 'To Do'), ( 'Doing'),( 'Done');
go

INSERT INTO [Task] (Title, [Description], Importance, Deadline,   [UserID])
VALUES ('Enviar relat�rio semanal', 'Preparar e enviar relat�rio de desempenho semanal da equipe', 2, '2023-06-19 09:00:00',   10),

('Atualizar planilha de vendas', 'Inserir os dados de vendas atualizados na planilha de acompanhamento', 4, '2023-07-20 14:30:00',   10),
 ('Realizar reuni�o de equipe', 'Agendar e conduzir uma reuni�o com a equipe para alinhar as metas do m�s', 3, '2023-06-29 11:00:00',  10),
 ('Task 3', 'Descri��o 3', 3, '2023-06-29 11:00:00',  10),
 ('Task 4', 'Descri��o 4', 1, '2023-06-29 11:00:00',  10),

 ('Enviar convites para evento', 'Elaborar e enviar convites para os participantes do evento corporativo', 5, '2023-09-22 16:30:00',   10),
 ('Task 2', 'Elaborar e enviar convites para os participantes do evento corporativo', 5, '2023-09-22 16:30:00',   15),
 ('Task 5', 'Elaborar e enviar convites para os participantes do evento corporativo', 5, '2023-09-22 16:30:00',   15);

 

 insert into [Task_Group_Assoc] (CriteriaType) values
('Importance'), ('Deadline'), ('Category');

insert into [Task_Group]  ([Assoc_code],[StackID], [Title], [DateOfCreation] ) values
(1, 1, 'Tarefas importantes', GETDATE()),(2, 1, 'Emitir folha de pagamento', GETDATE());


EXECUTE addTaskToGroup 
@TaskGroupTitle = 'Tarefas importantes', @TaskTitle = 'Enviar relat�rio semanal';

EXECUTE addTaskToGroup 
@TaskGroupTitle =  'Tarefas importantes', @TaskTitle = 'Atualizar planilha de vendas';



EXECUTE addTaskToGroup 
@TaskGroupTitle =  'Emitir folha de pagamento', @TaskTitle = 'Realizar reuni�o de equipe';

select * from [Task]; 
select * from [User]; 
select * from [Stack]; 
select * from [Task_Group]; 

SELECT * FROM getTaskGroup('Tarefas importantes', 'ToDo');
--select * from getTaskGroup('Tarefas importantes');

 /*
exec startTask 'Realizar reuni�o de equipe';
 exec concludeTask 'Realizar reuni�o de equipe';

insert into [Task_Group]  ([Assoc_code],[StackID], [Title], [DateOfCreation] ) values
(1, 1, 'Tarefas importantes', GETDATE()),(2, 1, 'Emitir folha de pagamento', GETDATE());

--EXECUTE addTaskToGroup @taskGroupTitle = 'Tarefas importantes', @taskCode = 4;

EXECUTE addTaskToGroup 
@TaskGroupTitle = 'Tarefas importantes', @TaskTitle = 'Enviar relat�rio semanal';

EXECUTE addTaskToGroup 
@TaskGroupTitle =  'Tarefas importantes', @TaskTitle = 'Atualizar planilha de vendas';

*/


--select * from [Task_Group]; 
