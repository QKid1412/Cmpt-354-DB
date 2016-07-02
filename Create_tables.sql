--CMPT 354 ASGN#3
--Amber Qi
CREATE TABLE Studio(
	studioID integer,
	studioName char(50) NOT NULL,
	employees integer,
	budget money,
	est integer,
	PRIMARY KEY (studioID)
)

CREATE TABLE Movie(
	title char(255),
	year integer,
	genre char(50),
	studioID integer,
	PRIMARY KEY (title),
	CONSTRAINT fk_MovieStudio
		FOREIGN KEY (studioID) 
		REFERENCES Studio(studioID) 
		ON DELETE SET NULL
		ON UPDATE CASCADE
)

CREATE TABLE Actors(
	name char(255),
	salary money,
	PRIMARY KEY (name)
)

CREATE TABLE TechStaff(
	sin integer,
	fname char(255),
	lname char(255) NOT NULL,
	age integer,
	salary money,
	studioID integer,
	PRIMARY KEY (sin),
	CONSTRAINT fk_StaffStudio
		FOREIGN KEY (studioID) 
		REFERENCES Studio(studioID) 
		ON DELETE SET NULL
		ON UPDATE CASCADE
)

CREATE TABLE ActedIn(
	name char(255),
	title char(255),
	PRIMARY KEY (name, title),
	CONSTRAINT fk_InActors
		FOREIGN KEY (name) 
		REFERENCES Actors(name) 
		ON DELETE CASCADE
		ON UPDATE NO ACTION,
	CONSTRAINT fk_InMovie
		FOREIGN KEY (title) 
		REFERENCES Movie(title) 
		ON DELETE CASCADE
		ON UPDATE CASCADE
)

CREATE TABLE Soundtrack(
	songID char(10),
	[duration(sec)] integer,
	rank real,
	title char(255),
	PRIMARY KEY (songID),
	CONSTRAINT fk_SoundMovie
		FOREIGN KEY (title) 
		REFERENCES Movie(title) 
		ON DELETE CASCADE
		ON UPDATE CASCADE
)
CREATE TABLE Keywords(
	keyword char(50),
	title char(255),
	CONSTRAINT fk_KeyMovie
		FOREIGN KEY (title) 
		REFERENCES Movie(title) 
		ON DELETE CASCADE
		ON UPDATE CASCADE
)