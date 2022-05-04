CREATE DATABASE UNIVERSITY;

CREATE TABLE DEPARTMENT(
	DEPT_ID INT NOT NULL,
    DEPT_NAME VARCHAR(255),
    
    PRIMARY KEY (DEPT_ID)
);

CREATE TABLE STUDENT(
	student_id INT NOT NULL,
    student_name VARCHAR(1024),
    major VARCHAR(255),
    `level` ENUM('FR','SO','JR','SR'),
    age INT,
    
    PRIMARY KEY (student_id)
);

CREATE TABLE professor(
	prof_id int not null,
    prof_name varchar(1024),
    dept_id int,
    
    PRIMARY KEY (prof_id),
    FOREIGN KEY (dept_id) REFERENCES department (DEPT_ID)
);

CREATE TABLE course(
	course_code varchar(16) not null,
    name varchar(1024),
    
    PRIMARY KEY (course_code)
);

CREATE TABLE semester_course(
	course_code varchar(16) not null,
    quarter ENUM('Spring','Summer','Fall') not null,
    `year` YEAR not null,
    prof_id int,
    
    PRIMARY KEY (course_code, quarter, year),
    FOREIGN KEY (course_code) REFERENCES course (course_code),
    FOREIGN KEY (prof_id) REFERENCES professor (prof_id)
);

CREATE TABLE enrolled(
	student_id int not null,
    course_code varchar(16) not null,
    quarter ENUM('Spring','Summer','Fall') not null,
    `year` YEAR not null,
    enrolled_at DATE,
    
    PRIMARY KEY (student_id, course_code, quarter, `year`),
    FOREIGN KEY (student_id) REFERENCES student (student_id),
    FOREIGN KEY (course_code, quarter, year) REFERENCES semester_course (course_code, quarter, year)
);