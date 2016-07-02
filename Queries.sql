--CMPT 354 ASGN#4
--Amber Qi 

--Query(a)
--examine if there are actors in 0 movie.
select name  
from Actors
except
select name
from ActedIn
--use group by to count the number of movies acted by actors
select distinct res.name, count(res.name) as num_of_acted_movie
from (select distinct A.name, I.title
		from ActedIn I, Actors A where I.name=A.name) as res
group by res.name
order by num_of_acted_movie DESC


--Query(b)
--the having condition ensures that the actor has acted in at least
-- 2 movies.
select A.name, count(A.name) as num_of_acted_movie
from ActedIn A
group by A.name
having count(*)>=2
order by num_of_acted_movie DESC

--Query(c) 
-- actor that have actes in maximum movies
-- find the name, and count the number

select name, count(*) as num_of_most_movies
from ActedIn
group by name
having count(name)=(
	select max(y.num) as num_of_most_movies
	from (select A.name, count(*) as num
			from ActedIn A
			group by A.name )y
)

--Query(d) 
--title of movies with 'action' genre, 'war' in keyword and no 'star' in keyword
select  distinct M.title  , K.keyword 
from Movie M, Keywords K
where( M.genre='action' 
	and (K.keyword like '%war%') 
	and (K.keyword not like '%star%')
	and M.title=K.title)


--Query(e)
select distinct S.songID, S.rank, K.keyword, M.title
from Soundtrack S, Movie M, Keywords K
where M.title=S.title and K.title=M.title
	and (K.keyword ='computer' or K.keyword ='computer-animation')
order by S.rank


--Query(f)
select distinct T.sin, T.fname, T.lname, T.studioID
from TechStaff T, Actors A
where T.fname=A.fname and T.lname=A.lname

---------TEST AREA---------------- 
--select distinct T.lname
--from TechStaff T
--intersect 
--select distinct A.lname
--from Actors A
---------TEST AREA----------------

--Query(g) for each studio, find the studioname, avg(salary) of actors and techstaff
select distinct S.studioName, M.studioID, 
				avg(A.salary) as avg_actors_income, avg(T.salary) as avg_techstaff_income
from Actors A, ActedIn I, Movie M, Studio S, TechStaff T
where A.name=I.name and I.title=M.title and M.studioID=S.studioID and T.studioID=S.studioID
group by M.studioID, S.studioName
order by studioID asc
