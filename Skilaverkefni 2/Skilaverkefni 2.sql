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

DELIMITER $$
CREATE TRIGGER CheckStudentStatusUpdate
BEFORE UPDATE ON Registration
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

-- Liður 3 / Samtals einingar nemanda fundnar með Stored Procedure --
drop procedure if exists GetStudentCredits;

DELIMITER $$
CREATE PROCEDURE GetStudentCredits(IN student_id INT, OUT credits INT)
BEGIN
    DECLARE done BOOLEAN DEFAULT FALSE;
    DECLARE total_credits INT DEFAULT 0;
    DECLARE course_credits INT;
    DECLARE grade FLOAT;

    DECLARE cur CURSOR FOR 
        SELECT c.courseCredits, r.grade 
        FROM Registration r 
        JOIN TrackCourses tc ON r.courseNumber = tc.courseNumber 
        JOIN Courses c ON r.courseNumber = c.courseNumber 
        WHERE r.studentID = student_id AND r.grade IS NOT NULL;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;
    credits_loop: LOOP
        FETCH cur INTO course_credits, grade;
        IF done THEN
            LEAVE credits_loop;
        END IF;

        IF grade >= 5 THEN
            SET total_credits = total_credits + course_credits;
        END IF;
    END LOOP;

    CLOSE cur;

    SET credits = total_credits;
END$$
DELIMITER ;

-- Testing --
CALL GetStudentCredits(15, @credits);
SELECT @credits;

-- Liður 4 / Nýskráning nemenda gerð meira sjálfvirk með Stored Procedures --
DELIMITER $$
CREATE PROCEDURE AddNewStudent(
    IN studentName VARCHAR(255),
    IN studentEmail VARCHAR(255),
    IN trackID INT
)
BEGIN
    INSERT INTO Students (studentName, studentEmail, trackID, studentStatus)
    VALUES (studentName, studentEmail, trackID, 1);

    SET @studentID = LAST_INSERT_ID();

    CALL AddMandatoryCourses(@studentID, trackID);
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE AddMandatoryCourses(
    IN studentID INT,
    IN trackID INT
)
BEGIN
    INSERT INTO Registration (studentID, courseID, semesterID)
    SELECT studentID, courseID, semesterID
    FROM TrackCourses
    WHERE mandatory = 1 AND trackID = trackID;

    SELECT CONCAT('Mandatory courses added for student ', studentID) AS Message;
END$$
DELIMITER ;
