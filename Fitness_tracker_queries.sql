use tracker;
SET GLOBAL log_bin_trust_function_creators = 1;

SELECT * FROM PERSON;
SELECT * FROM Workout;
SELECT * FROM exercise;
SELECT * FROM exercise_type;
SELECT * FROM Sett;

INSERT INTO Person (SSN, Fname, Lname, Age, Weight, Height, Gender) VALUES
(123456789, 'John', 'Doe', 30, '180 lbs', '5\'11"', 'Male'),
(987654321, 'Jane', 'Smith', 28, '150 lbs', '5\'7"', 'Female'),
(456789123, 'Mike', 'Johnson', 35, '200 lbs', '6\'2"', 'Male'),
(654321987, 'Emily', 'Davis', 22, '130 lbs', '5\'5"', 'Female');


INSERT INTO Workout (Duration, Date, Person, Quality) VALUES
('01:00:00', '2024-05-01', 123456789, 'Good'),
('00:45:00', '2024-05-02', 987654321, 'Excellent'),
('01:30:00', '2024-05-03', 456789123, 'Fair'),
('00:50:00', '2024-05-04', 654321987, 'Good'),
('00:30:00', '2024-05-05', 123456789, 'Poor'),
('01:15:00', '2024-05-05', 987654321, 'Good'),
('01:00:00', '2024-05-06', 456789123, 'Excellent'),
('00:45:00', '2024-05-06', 654321987, 'Fair'),
('01:20:00', '2024-05-07', 123456789, 'Good'),
('00:50:00', '2024-05-07', 987654321, 'Poor'),
('01:10:00', '2024-05-08', 456789123, 'Excellent'),
('00:55:00', '2024-05-08', 654321987, 'Good');


INSERT INTO Exercise_type (Name, Description) VALUES
('Running', 'Cardiovascular exercise focusing on endurance and speed'),
('Weightlifting', 'Strength training exercise using weights'),
('Cycling', 'Cardiovascular exercise using a bicycle'),
('Swimming', 'Full-body exercise performed in water');


INSERT INTO Exercise (ID, Type, Date, Person) VALUES
(1, 'Running', '2024-05-01', 123456789),
(2, 'Weightlifting', '2024-05-02', 987654321),
(3, 'Cycling', '2024-05-03', 456789123),
(4, 'Swimming', '2024-05-04', 654321987),
(5, 'Cycling', '2024-05-05', 123456789),
(6, 'Swimming', '2024-05-05', 987654321),
(7, 'Running', '2024-05-06', 456789123),
(8, 'Weightlifting', '2024-05-06', 654321987),
(9, 'Running', '2024-05-07', 123456789),
(10, 'Cycling', '2024-05-07', 987654321),
(11, 'Swimming', '2024-05-08', 456789123),
(12, 'Weightlifting', '2024-05-08', 654321987);


INSERT INTO Sett (SetID, Weight, Reps, Exercise) VALUES
(1, 0, 0, 1),
(2, 100, 10, 2),
(3, 150, 8, 2),
(4, 0, 0, 3),
(5, 0, 0, 4),
(6, 0, 0, 5),
(7, 0, 0, 6),
(8, 0, 0, 7),
(9, 100, 12, 8),
(10, 0, 0, 9),
(11, 0, 0, 10),
(12, 0, 0, 11),
(13, 150, 8, 12);

CREATE VIEW personalWorkouts AS
    SELECT SSN, Fname,Date,Duration,Quality From Person inner join workout on person.SSN = workout.Person;
    
SELECT * From personalWorkouts;

CREATE VIEW workoutStats AS
    SELECT SSN, sum(Hour(Duration) + Minute(Duration) / 60) as TotalDuration FROM personalWorkouts GROUP BY SSN ORDER BY TotalDuration DESC;
    
select * from workoutStats

DELIMITER //
CREATE FUNCTION GetTotalWorkoutHours(SSN int)
RETURNS float NOT DETERMINISTIC
BEGIN
    DECLARE result float;
    SELECT TotalDuration into result FROM workoutStats WHERE workoutStats.SSN = SSN;

    RETURN(result);
END//
DELIMITER ;

select GetTotalWorkoutHours(123456789);

DELIMITER //
CREATE FUNCTION GetPR(SSN int, Exercise_type varchar(255))
RETURNS int NOT DETERMINISTIC
BEGIN
    DECLARE result int;
    SELECT Max(Sett.Weight) into result FROM personalWorkouts
    INNER JOIN Exercise ON personalWorkouts.Date = Exercise.Date AND personalWorkouts.SSN = Exercise.Person
    INNER JOIN Sett ON Exercise.ID = Sett.Exercise
    WHERE personalWorkouts.SSN = SSN AND Exercise.Type = Exercise_type;

    RETURN(result);
END//
DELIMITER ;

select GetPR(654321987, "weightlifting");

DELIMITER //
CREATE FUNCTION GetMyWorkouts(SSN int)
RETURNS int NOT DETERMINISTIC
BEGIN
    DECLARE result int;
    SELECT Max(Sett.Weight) into result FROM personalWorkouts
    INNER JOIN Exercise ON personalWorkouts.Date = Exercise.Date AND personalWorkouts.SSN = Exercise.Person
    INNER JOIN Sett ON Exercise.ID = Sett.Exercise
    WHERE personalWorkouts.SSN = SSN AND Exercise.Type = Exercise_type;

    RETURN(result);
END//
DELIMITER ;

-- Show all workouts and associated person within the latest week
SELECT * FROM personalWorkouts WHERE Date >= DATE_SUB(now(), INTERVAL 7 DAY);