Create database Tracker;
Use Tracker;

Drop table Sett;
Drop table Exercise;
Drop table Exercise_type;
Drop table Workout;
Drop table Person;


Create table Person(
SSN int,
Fname varchar(255),
Lname varchar(255),
Age int,
Weight varchar(255),
Height varchar(255),
Gender varchar(255),
PRIMARY KEY (SSN)
);

Create table Workout(
Duration time,
Date date,
Person int,
Quality varchar(255),
PRIMARY KEY (Date,Person),
Foreign key (Person) REFERENCES Person(SSN)
);

Create table Exercise_type(
Name varchar(255),
Description varchar(255),
Primary key (Name)
);

Create table Exercise(
ID int,
Type varchar(255),
Date date,
Person int,
primary key (ID),
Foreign key (Type) REFERENCES Exercise_type(Name),
Foreign key (Date,Person) REFERENCES Workout(Date,Person)
);

Create table Sett(
SetID int,
Weight int,
Reps int,
Exercise int,
Primary key (SetID),
Foreign key (Exercise) REFERENCES Exercise(ID)
);