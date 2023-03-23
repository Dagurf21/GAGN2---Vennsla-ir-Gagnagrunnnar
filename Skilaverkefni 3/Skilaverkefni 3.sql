use ProgressTracker;


-- Courses -- -- Courses -- -- Courses -- -- Courses -- -- Courses -- -- Courses -- -- Courses --

-- CREATE procedure for adding a new course
DELIMITER $$
CREATE PROCEDURE addCourse (
  IN p_courseNumber CHAR(15),
  IN p_courseName VARCHAR(75),
  IN p_courseCredits TINYINT(4)
)
BEGIN
  INSERT INTO Courses (courseNumber, courseName, courseCredits)
  VALUES (p_courseNumber, p_courseName, p_courseCredits);
END$$
DELIMITER ;

-- CREATE procedure for retrieving a course by its courseNumber
DELIMITER $$
CREATE PROCEDURE getCourseByNumber (
  IN p_courseNumber CHAR(15)
)
BEGIN
  SELECT *
  FROM Courses
  WHERE courseNumber = p_courseNumber;
END$$
DELIMITER ;

-- CREATE procedure for updating a course
DELIMITER $$
CREATE PROCEDURE updateCourse (
  IN p_courseNumber CHAR(15),
  IN p_courseName VARCHAR(75),
  IN p_courseCredits TINYINT(4)
)
BEGIN
  UPDATE Courses
  SET courseName = p_courseName, courseCredits = p_courseCredits
  WHERE courseNumber = p_courseNumber;
END$$
DELIMITER ;

-- CREATE procedure for deleting a course by its courseNumber
DELIMITER $$
CREATE PROCEDURE deleteCourse (
  IN p_courseNumber CHAR(15)
)
BEGIN
  DELETE FROM Courses
  WHERE courseNumber = p_courseNumber;
END$$
DELIMITER ;

CALL addCourse('TEST101', 'Testing Testing Testing', 3);
CALL getCourseByNumber('TEST101');
CALL updateCourse('TEST101', 'Testing', 4);
CALL deleteCourse('TEST101');

-- Courses -- -- Courses -- -- Courses -- -- Courses -- -- Courses -- -- Courses -- -- Courses --
-- TrackCourses -- -- TrackCourses -- -- TrackCourses -- -- TrackCourses -- -- TrackCourses -- -- TrackCourses -- -- TrackCourses -- 
-- create --
drop procedure if exists CreateTrackCourse;
DELIMITER $$
CREATE PROCEDURE createTrackCourse(
  IN track_id INT,
  IN course_number CHAR(15),
  IN semester TINYINT UNSIGNED,
  IN mandatory TINYINT UNSIGNED
)
BEGIN
  INSERT INTO TrackCourses (trackID, courseNumber, semester, mandatory)
  VALUES (track_id, course_number, semester, mandatory);
END $$
DELIMITER ;
SELECT * FROM TrackCourses;


-- Read --
DELIMITER $$
CREATE PROCEDURE readTrackCourse(IN track_id INT, IN course_number CHAR(15))
BEGIN
  SELECT *
  FROM TrackCourses
  WHERE trackID = track_id AND courseNumber = course_number;
END $$
DELIMITER ;
-- Update --
DELIMITER $$
CREATE PROCEDURE updateTrackCourse(IN track_id INT, IN course_number CHAR(15), IN semester TINYINT UNSIGNED, IN mandatory TINYINT UNSIGNED)
BEGIN
  UPDATE TrackCourses
  SET semester = semester, mandatory = mandatory
  WHERE trackID = track_id AND courseNumber = course_number;
END$$
DELIMITER ;
-- Delete --
DELIMITER $$
CREATE PROCEDURE deleteTrackCourse (
  IN p_trackID INT,
  IN p_courseNumber CHAR(15)
)
BEGIN
  DELETE FROM TrackCourses
  WHERE trackID = p_trackID AND courseNumber = p_courseNumber;
END $$
DELIMITER ;

CALL createTrackCourse(9, 'TEST201', 1, 1);
CALL readTrackCourse(1, 'TEST201');
CALL updateTrackCourse(1, 'TEST201', 2, 0);
CALL DeleteTrackCourse(1, 'BLA123');
-- TrackCourses -- -- TrackCourses -- -- TrackCourses -- -- TrackCourses -- -- TrackCourses -- -- TrackCourses -- -- TrackCourses -- 
-- Semesters -- -- Semesters -- -- Semesters -- -- Semesters -- -- Semesters -- -- Semesters -- -- Semesters -- -- Semesters -- 

-- Create
DELIMITER $$
CREATE PROCEDURE createSemester (
  IN semesterName CHAR(10),
  IN semesterStarts DATE,
  IN semesterEnds DATE,
  IN academicYear CHAR(10)
)
BEGIN
  INSERT INTO Semesters (semesterName, semesterStarts, semesterEnds, academicYear)
  VALUES (semesterName, semesterStarts, semesterEnds, academicYear);
END$$
DELIMITER ;

-- Read --
DELIMITER $$
CREATE PROCEDURE read_semester (
  IN semesterID INT
)
BEGIN
  SELECT *
  FROM Semesters
  WHERE semesterID = semesterID;
END;
DELIMITER ;

-- Update --
DELIMITER $$
CREATE PROCEDURE updateSemester (
  IN semesterID INT,
  IN semesterName CHAR(10),
  IN semesterStarts DATE,
  IN semesterEnds DATE,
  IN academicYear CHAR(10)
)
BEGIN
  UPDATE Semesters
  SET semesterName = semesterName,
      semesterStarts = semesterStarts,
      semesterEnds = semesterEnds,
      academicYear = academicYear
  WHERE semesterID = semesterID;
END;
DELIMITER ;

-- Delete --
DELIMITER $$
CREATE PROCEDURE deleteSemester (
  IN semesterID INT
)
BEGIN
  DELETE FROM Semesters
  WHERE semesterID = semesterID;
END;
DELIMITER ;

CALL createSemester('Spring', '2023-01-10', '2023-05-10', '2022-2023');
CALL readSemester(1);
CALL updateSemester(1, 'Summer', '2023-06-01', '2023-08-31', '2022-2023');
CALL deleteSemester(1);
-- Semesters -- -- Semesters -- -- Semesters -- -- Semesters -- -- Semesters -- -- Semesters -- -- Semesters -- -- Semesters -- 
