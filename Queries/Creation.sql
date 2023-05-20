use [Routine View]
go

DROP PROCEDURE IF EXISTS selectTasksByStack;

DROP TABLE IF EXISTS [Reward],[Task_Group],[TaskAchievement],[Achieviement], [Task],[Stack],[User]
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

create table [Task] (
	Code int primary key  identity(1,5),
	Title varchar(100) NOT NULL UNIQUE,
	[Description] varchar(100) NOT NULL,
	Importance int NOT NULL,
	Deadline datetime NOT NULL, 
	--HoursLeft int TIMEDIFF(Deadline,  NOW),
	--Por hora vamos tentar operar a prioridade no "backend do servi�o"
	--[Priority] int NOT NULL ,
	[State] varchar(10) ,
	--[StackPos] int default null,
	[Priority] int,
	[StackID] int foreign key references [Stack] (StackID),
	[Conclusion] datetime default null,
	[UserID] int foreign key references [User] (ID)
)
go

create table Task_Group(
    Code int identity (1,5),
    [Title] varchar(50) not null,
    [Description] varchar(100) ,
    Deadline  datetime NOT NULL,
    [Num_max_task] int default 10, 
    [Curr_undone_task_num] int not null default 10,
    --[Curr_toDo_task_num] substituir esta coluna por um procedure
    [OveralPriority] int not null,
    [DateOfCreation] datetime NOT NULL
    --[StackPos] int default null

);


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


