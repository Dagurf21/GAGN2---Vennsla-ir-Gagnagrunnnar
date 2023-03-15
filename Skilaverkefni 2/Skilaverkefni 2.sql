use ProgressTracker;

-- Liður 1 Function -- 
drop function if exists StudentStatus;
DELIMITER $$
CREATE FUNCTION StudentStatus(studentID INT)
RETURNS INT
DETERMINISTIC
BEGIN
DECLARE status INT;
SELECT ID INTO status FROM StudentStatus WHERE StudentID = studentID LIMIT 1;
RETURN status;
END $$
DELIMITER ;

-- Liður 1 Trigger --
DELIMITER $$
CREATE TRIGGER CheckStudentStatus
BEFORE INSERT ON Registration
FOR EACH ROW 	
BEGIN
DECLARE student_status INT;
SET student_status = StudentStatus(NEW.studentID);
IF student_status NOT IN (1, 7, 8) THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Nemandi hefur ekki réttan stöðu til að skrá sig í áfanga';
END IF;
END $$
DELIMITER ; 



-- Liður 1 Testing --
insert into Registration(studentID,courseNumber,processDate,semesterID,grade)values(1,'DANS2BM05AT','2018-01-01',11,7);
insert into Registration(studentID,courseNumber,processDate,semesterID,grade)values(1,'BLABLA2MB05AA','2023-01-01',20,9);

-- Liður 2 / trigger fyrir update Registration skipunina --

