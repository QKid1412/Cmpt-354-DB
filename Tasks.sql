--CMPT 354 ASGN#4
--Amber Qi 

--Task(a)  add constraint age_constraint & song_constraint
alter table TechStaff
add constraint age_constraint check(age>=10 and age<=125)

-------TEST AREA-------
--insert into TechStaff 
--values(1,'A','Q',9,299,1)
-------TEST AREA-------

alter table Soundtrack
add constraint song_constraint check([duration(sec)]>0)

-------TEST AREA-------
--insert into Soundtrack
--values('ei',0,2,'t')
-------TEST AREA-------

--Task(b)
--add columns fname and lname
alter table Actors
add fname varchar(255)
alter table Actors
add lname varchar(255)

-------TEST AREA-------
--alter table Actors
--drop column fname 
--alter table Actors
--drop column lname 
-------TEST AREA-------

--create function to pick fname from name
create function fx_fname
(@name varchar(255))
returns varchar(255)
begin
   declare @fname varchar(255)
   if @name like '%,%' 
   begin
		set @fname=left(@name,charindex(',',@name)-1)
   end
   else
   begin
		set @fname=@name
   end
   return @fname
end

--implement fx_fname to insert fname into column fname
update Actors
set fname=dbo.fx_fname(name)

--create function to decide lname
create function fx_lname
(@name varchar(255))
returns varchar(255)
begin
   declare @lname varchar(255)
   if @name like '%,%' 
   begin
		set @lname=right(@name,len(@name)-charindex(',',@name))
   end   
   return @lname
end
--implement fx_lname to insert lname into column lname
--if there is no comma in name, lname is set to NULL
update Actors
set lname=dbo.fx_lname(name)


--Task(c)count employees in particular studio (according to studioID) 
--	and insert the result into table Studio(employees)

update Studio
set Studio.employees=c.employee
from (
	select T.studioID, count(*) as employee
	from TechStaff T
	group by T.studioID)c
where ( c.studioID=Studio.studioID)

-------TEST AREA-------
--select* from Studio
-------TEST AREA-------

--Task(d)Create a trigger so that when an insertor deletion of a TechStaff occurs, the ‘employees’ column	
--   of the Studio table gets updated accordingly.


create trigger TR_updateemp
on TechStaff after insert, delete
as
begin
	update Studio
	set Studio.employees=new.num_techstaff
	from (select T.studioID, count(*) as num_techstaff
		  from TechStaff T
		  group by T.studioID) as new
	where Studio.studioID=new.studioID
end


---------TEST AREA----------------
--select* from Studio

--insert into TechStaff values (1,'amber','qi',20,100000,8)

--select* from Studio

--delete from TechStaff where sin=1

--select* from Studio
---------TEST AREA----------------

--Task(e)
create trigger TR_delstudio
on Studio after delete
as
if not exists(SELECT * FROM INFORMATION_SCHEMA.TABLES 
           WHERE TABLE_NAME = 'FoldedStudios')
begin
	create table FoldedStudios(	
			studioName varchar(50),
			fired integer
	)
end
begin
	insert into FoldedStudios
	select studioName, employees from deleted
end

---------TEST AREA----------------
--select* 
--into Studio_
--from Studio 

--insert into Studio
--select* from Studio_ where studioID=9

--delete from Studio
--where studioID=9
---------TEST AREA----------------

--Task(f)

create proc spSearchString
@st varchar(20)
as
begin
	select M.title, M.year,M.genre,M.studioID,K.keyword
	from Keywords K full outer join Movie M
		on M.title=K.title 
	where K.keyword like @st+'%'
end

---------TEST AREA----------------
--select distinct * from Keywords where (keyword like 'ha%')
--execute dbo.spSearchString 'ha'
---------TEST AREA----------------
