use [Routine View]
go

--DDL : 

DROP TABLE IF EXISTS [Reward],[Task_Group_Assoc],[Task_Group],[TaskAchievement],[Achieviement], [Task],[Stack],[User]
GO

create table [User] (	
	 ID	int  identity(10,5),
	[Name]	varchar(256) NOT NULL,
	[Email] varchar(40) NOT NULL,
	[Password] char(40) NOT NULL,
	[Score] int default 0,
	[DoB] date NOT NULL
)
go

create unique clustered index user_ID_index on [User](ID);

alter index user_ID_index on [User] rebuild with (fillfactor = 100) ;

create table [Stack] (
	StackID int  identity(1,1),
	[Name] varchar(40) unique not null,
	NumMaxTasks int not null default 20,
	CurrMaxTasks int not null default 0
); 
go

create unique clustered index stackID_index on [Stack](StackID);

alter index stackID_index on [Stack] rebuild with (fillfactor = 70) ;

--Vamos mudar o domínio do projetos
--Não vamos mais trabalhar com especialização
CREATE TABLE Task_Group_Assoc (
    Assoc_Code INT IDENTITY (1,5) primary key,
    CriteriaType VARCHAR(20) CHECK (CriteriaType IN ('Importance', 'Deadline', 'Category'))
);


create table Task_Group(
    Code int identity (1,1) primary key,
	Assoc_code int foreign key references [Task_Group_Assoc] (Assoc_Code),
	[StackID] int foreign key references [Stack] (StackID),
    [Title] varchar(50) not null,
    [Description] varchar(100) ,
    [Num_max_task] int default 10, 
    [Curr_undone_task_num] int not null default 10,
    --[Curr_toDo_task_num] substituir esta coluna por um procedure
    [OveralPriority] int not null default  5,
    [DateOfCreation] datetime NOT NULL
    --[StackPos] int default null

);

create table [Task] (
	Code int primary key  identity(1,5),
	Title varchar(100) NOT NULL UNIQUE,
	[Description] varchar(100) NOT NULL,
	Importance int NOT NULL,
	Deadline datetime NOT NULL, 
	--HoursLeft int TIMEDIFF(Deadline,  NOW),
	--Por hora vamos tentar operar a prioridade no "backend do serviço"
	--[Priority] int NOT NULL ,
	[State] varchar(10) ,
	--[StackPos] int default null,
	[Priority] int,
	[StackID] int foreign key references [Stack] (StackID),
	[Conclusion] datetime default null,
	[UserID] int foreign key references [User] (ID),
	[TaskGroupCode] int foreign key references [Task_Group] (Code) default null
)
go


create table Reward(
    Reward_id int identity(1,5),
    [Priority] int not null,
    [Group_Name] varchar(50)  not null,
    [Task_code] int  foreign key references [Task] (Code),
    [Task_Deadline] datetime NOT NULL,
    [Reward_Value] int not null default 10,
    [Date_Time] datetime NOT NULL,
);

--create unique clustered index taskCode_index on [Task](Code);
--alter index taskCode_index on [Task] rebuild with (fillfactor = 70) ;


create table Achieviement (
	Ach_code int identity(1,2),
	[Description] varchar(1000) default '',
	[WasAchieved] varchar(4) default 'no',
	Category varchar(20) default null,
	[UserID] int foreign key references [User] (ID)
 
);

create unique clustered index Ach_code_index on Achieviement(Ach_code);

alter index Ach_code_index on [Achieviement] rebuild with (fillfactor = 70) ;


create table TaskAchievement (
	TaskAchievement int identity(1,5),
	Ach_code int foreign key references [Achieviement] (Ach_code),
	TaskID int foreign key references [Task] (Code),
);


--DML



insert into 
	[User] 
	( [Name], [Email], [Password],[DoB]) 
	values ( 'JSP', 'JSP@ua.pt', 'jayjay' ,'2011-01-01'),
	( 'Pedro Branches', 'PB@ua.pt', 'ManjaroTrash', '2019-01-01'),
	('Jane Smith', 'janesmith@example.com', 'anotherpassword', '1995-05-05'),
	('Bob Johnson', 'bobjohnson@example.com', 'supersecurepassword', '1985-12-31');;
go

insert into
	[Stack]
	( [Name]) values
	( 'To Do'), ( 'Doing'),( 'Done');
go

INSERT INTO [Task] (Title, [Description], Importance, Deadline, [Priority], [StackID], [UserID])
VALUES ('Enviar relatório semanal', 'Preparar e enviar relatório de desempenho semanal da equipe', 2, '2023-06-19 09:00:00', 3, 1, 10),

('Atualizar planilha de vendas', 'Inserir os dados de vendas atualizados na planilha de acompanhamento', 4, '2023-07-20 14:30:00', 2, 2, 10),
 ('Realizar reunião de equipe', 'Agendar e conduzir uma reunião com a equipe para alinhar as metas do mês', 3, '2023-05-21 11:00:00', 1, 1, 10),

 ('Enviar convites para evento', 'Elaborar e enviar convites para os participantes do evento corporativo', 5, '2023-09-22 16:30:00', 2, 2, 10)/*,
 
 ('Preparar apresentação de vendas', 'Criar uma apresentação persuasiva para a reunião com potenciais clientes', 1, '2023-05-23 13:00:00', 1, 1, 10),

 ('Realizar análise de dados', 'Analisar os dados de vendas do último trimestre e identificar padrões', 3, '2023-05-24 10:30:00', 2, 2, 10),

 ('Enviar proposta comercial', 'Elaborar e enviar a proposta comercial para o cliente em potencial', 2, '2023-05-25 15:00:00', 3, 1, 10),

 ('Revisar contrato de fornecedor', 'Analisar e revisar o contrato de fornecimento antes de assinar', 1, '2023-05-26 12:30:00', 2, 2, 10),

 ('Realizar teste de software', 'Executar testes e identificar possíveis bugs no novo software', 3, '2023-05-27 09:00:00', 1, 1, 10),

 ('Organizar treinamento interno', 'Agendar e organizar um treinamento para atualizar os colaboradores', 2, '2023-05-28 14:30:00', 2, 2, 10),

 ('Fazer backup dos arquivos', 'Realizar o backup dos arquivos importantes para evitar perda de dados', 1, '2023-05-29 11:00:00', 1, 1, 10),

 ('Atualizar redes sociais', 'Postar conteúdo atualizado nas redes sociais da empresa', 3, '2023-05-30 16:30:00', 2, 2, 10),

 ('Realizar pesquisa de mercado', 'Conduzir uma pesquisa de mercado para identificar novas oportunidades', 2, '2023-05-31 13:00:00', 1, 1, 10),

 ('Preparar relatório financeiro', 'Analisar as finanças da empresa e preparar um relatório detalhado', 1, '2023-06-01 10:30:00', 2, 2, 10),

 ('Enviar lembrete de pagamento', 'Enviar lembretes de pagamento aos clientes com faturas em atraso', 3, '2023-06-02 15:00:00', 3, 1, 10),

 ('Desenvolver novo produto', 'Iniciar o desenvolvimento de um novo produto inovador para o mercado', 2, '2023-06-03 12:30:00', 2, 2, 10),

 ('Realizar auditoria interna', 'Conduzir uma auditoria interna para garantir conformidade com os padrões', 1, '2023-06-04 09:00:00', 1, 1, 10),

 ('Atualizar sistema de gestão', 'Implementar atualizações no sistema de gestão da empresa', 3, '2023-06-05 14:30:00', 2, 2, 10),

 ('Realizar pesquisa de satisfação', 'Enviar pesquisa de satisfação aos clientes e analisar os resultados', 2, '2023-06-06 11:00:00', 1, 1, 10),

 ('Preparar material de treinamento', 'Desenvolver materiais de treinamento para a equipe de vendas', 1, '2023-06-07 16:30:00', 2, 2, 10),

 ('Analisar concorrência', 'Realizar uma análise detalhada dos principais concorrentes no mercado', 3, '2023-06-08 13:00:00', 1, 1, 10),

 ('Enviar relatório trimestral', 'Preparar e enviar o relatório de desempenho trimestral da empresa', 2, '2023-06-09 10:30:00', 2, 2, 10)*/;


insert into [Task_Group_Assoc] (CriteriaType) values
('Importance'), ('Deadline'), ('Category');

insert into [Task_Group]  ([Assoc_code],[StackID], [Title], [DateOfCreation] ) values
(1, 1, 'Tarefas importantes', GETDATE() );

EXECUTE addTaskToGroup @taskGroupTitle = 'Tarefas importantes', @taskCode = 4;


/*
select * from [User]; 
select * from [Stack]; 
select * from [Task]; 
select * from [Task_Group]; 
*/