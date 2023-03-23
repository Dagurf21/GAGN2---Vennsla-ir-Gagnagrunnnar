use ProgressTracker

-- Liður 2 / Birta upplýsingar um einn ákveðinn áfanga með Stored Procedure. (prenta út uppl. af afanga eftir afanga numeri) --

DELIMITER $$
CREATE PROCEDURE `get_course_info` (IN `course_num` CHAR(15))
BEGIN
    SELECT *
    FROM `courses`
    WHERE `CourseNumber` = `course_num`;
END $$
DELIMITER ;

CALL `get_course_info`('DANS2BM05AT'); 

-- Liður 3 / Nýskráning áfanga með Stored procedure. ()
DELIMITER $$
CREATE PROCEDURE `add_course` (
    IN `course_num` CHAR(15),
    IN `course_name` VARCHAR(75),
    IN `course_credits` TINYINT
)
BEGIN
    IF EXISTS (SELECT 1 FROM `courses` WHERE `CourseNumber` = `course_num`) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Áfanganúmer er nú þegar til';
    ELSE
        INSERT INTO `courses` (`courseNumber`, `courseName`, `courseCredits`)
        VALUES (`course_num`, `course_name`, `course_credits`);
    END IF;
END $$
DELIMITER ;

-- Áfangi nú þegar til
CALL `add_course`('GAGN2VG05CU', 'Venslaðir Gagnagrunnar', 5);
-- Áfangi sem ekki er til
CALL `add_course`('BLOP3BU05CU', 'Smá test á Procedure', 5);
CALL `get_course_info`('BLOP3BU05CU'); 

-- Liður 4 / Uppfæra áfanga með Stored Procedure

DELIMITER $$
CREATE PROCEDURE `update_course` (
    IN `course_num` CHAR(15),
    IN `new_course_name` VARCHAR(75),
    IN `new_course_credits` TINYINT
)
BEGIN
    UPDATE `courses`
    SET `courseName` = `new_course_name`, `courseCredits` = `new_course_credits`
    WHERE `courseNumber` = `course_num`;
END $$
DELIMITER ;
 
-- Testa þetta eins og fagmaður
CALL `get_course_info`('BLOP3BU05CU'); 
CALL `update_course` ('BLOP3BU05CU', 'Núna Update Procedure', 1);
CALL `get_course_info`('BLOP3BU05CU'); 

-- Liður 5 / Eyða áfanga úr grunninum með Stored Procedure. ()
DROP PROCEDURE IF EXISTS delete_course;
DELIMITER $$
CREATE PROCEDURE `delete_course` (
    IN `course_num` CHAR(15)
)
BEGIN
    DECLARE `used_in_trackcourses` INT DEFAULT 0;
    SELECT COUNT(*) INTO `used_in_trackcourses` FROM `trackcourses` WHERE `CourseNumber` = `course_num`;
    IF `used_in_trackcourses` > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Not so fast bucko, TrackCourse er að nota þennnan áfanga';
    ELSE
        DELETE FROM `Restrictors` WHERE `courseNumber` = `course_num`;
        DELETE FROM `courses` WHERE `CourseNumber` = `course_num`;
    END IF;
END $$
DELIMITER ;

-- Áfangi sem er nú þegar til en sem ekki má eyða
CALL `delete_course`('FORR1FG05AU');
-- Áfangi sem er nú þegar til og hægt að eyða
CALL `delete_course`('BLOP3BU05CU');
CALL `get_course_info`('BLOP3BU05CU');

-- Liður 6 / Reikna út(telja) heildarfjölda áfanga með Function 
Drop function if exists count_courses;

DELIMITER $$
CREATE FUNCTION `count_courses` () RETURNS INT
DETERMINISTIC
NO SQL
READS SQL DATA
BEGIN
    DECLARE `course_count` INT DEFAULT 0;
    SELECT COUNT(*) INTO `course_count` FROM `courses`;
    RETURN `course_count`;
END $$
DELIMITER ;

SELECT `count_courses`();
-- Liður 7 --
delimiter $$
create function TrackTotalCredits(track_id int)
returns int deterministic
begin
    declare creditSum int;

    select sum(Courses.courseCredits) into creditSum
    from courses
    inner join TrackCourses on Courses.courseNumber = TrackCourses.courseNumber and trackCourses.trackID = track_id;

    return creditSum;
end $$
delimiter ;

select TrackTotalCredits(9);

-- Liður 8 / Skrifa Function sem kannar hvort að ákv. dagsetning(date) sé á hlaupári
DELIMITER $$
CREATE FUNCTION `is_leap_year` (`year` INT) RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    IF `year` % 4 = 0 AND (`year` % 100 != 0 OR `year` % 400 = 0) THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END $$
DELIMITER ;

SELECT `is_leap_year`(2024);

-- Liður 9 / 
DELIMITER $$
CREATE FUNCTION `calculate_age` (`birth_date` VARCHAR(10)) RETURNS INT
DETERMINISTIC
NO SQL
READS SQL DATA
BEGIN
    DECLARE `dob` DATE;
    SET `dob` = STR_TO_DATE(`birth_date`, '%Y.%m.%d');
    RETURN YEAR(CURDATE()) - YEAR(`dob`) - (DATE_FORMAT(CURDATE(), '%m%d') < DATE_FORMAT(`dob`, '%m%d'));
END $$
DELIMITER ;
SELECT `calculate_age`('1995.03.25');

-- Liður 10 / Stored Procedure sem skilar öllum nemendum á ákveðinni önn(semester)
drop procedure if exists GetStudentsBySemester;
DELIMITER $$
CREATE PROCEDURE GetStudentsBySemester(IN semesterID INT)
BEGIN
	SELECT s.studentID, s.firstName, s.lastName, s.dob, ss.statusName, t.trackName, d.divisionName, sch.schoolName 
	FROM Students s 
	INNER JOIN Registration r ON s.studentID = r.studentID 
	INNER JOIN TrackCourses tc ON r.courseNumber = tc.courseNumber 
	INNER JOIN Tracks t ON tc.trackID = t.trackID 
	INNER JOIN Divisions d ON t.divisionID = d.divisionID 
	INNER JOIN Schools sch ON d.schoolID = sch.schoolID 
	INNER JOIN Semesters sem ON r.semesterID = sem.semesterID 
	INNER JOIN StudentStatus ss ON s.studentStatus = ss.ID
	WHERE sem.semesterID = semesterID;
END $$
DELIMITER ;
CALL GetStudentsBySemester(17);
