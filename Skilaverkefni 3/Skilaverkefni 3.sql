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
DELIMITER $$
CREATE PROCEDURE create_track_course(IN track_id INT, IN course_number CHAR(15), IN semester TINYINT UNSIGNED, IN mandatory TINYINT UNSIGNED)
BEGIN
  INSERT INTO TrackCourses (trackID, courseNumber, semester, mandatory)
  VALUES (track_id, course_number, semester, mandatory);
END $$
DELIMITER ;

-- Read --
DELIMITER $$
CREATE PROCEDURE read_track_course(IN track_id INT, IN course_number CHAR(15))
BEGIN
  SELECT *
  FROM TrackCourses
  WHERE trackID = track_id AND courseNumber = course_number;
END $$
DELIMITER ;
-- Update --
DELIMITER $$
CREATE PROCEDURE update_track_course(IN track_id INT, IN course_number CHAR(15), IN semester TINYINT UNSIGNED, IN mandatory TINYINT UNSIGNED)
BEGIN
  UPDATE TrackCourses
  SET semester = semester, mandatory = mandatory
  WHERE trackID = track_id AND courseNumber = course_number;
END$$
DELIMITER ;
-- Delete --
DELIMITER $$
CREATE PROCEDURE DeleteTrackCourse (
  IN p_trackID INT,
  IN p_courseNumber CHAR(15)
)
BEGIN
  DELETE FROM TrackCourses
  WHERE trackID = p_trackID AND courseNumber = p_courseNumber;
END $$

DELIMITER ;

CALL create_track_course(1, 'CSCI101', 1, 1);
CALL read_track_course(1, 'CSCI101');
CALL update_track_course(1, 'CSCI101', 2, 0);
CALL DeleteTrackCourse(1, 'ABC123');


-- TrackCourses -- -- TrackCourses -- -- TrackCourses -- -- TrackCourses -- -- TrackCourses -- -- TrackCourses -- -- TrackCourses -- 
