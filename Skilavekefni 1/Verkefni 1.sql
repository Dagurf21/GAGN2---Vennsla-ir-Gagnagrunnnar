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
