/* ****** Student Database ****** */

/* ================================= */
/* *** Creating a Table *** */

CREATE TABLE student(
    student_id INT PRIMARY KEY,
    name VARCHAR(20),
    major VARCHAR(20)  DEFAULT 'undecided'    
);

/* PRIMARY KEY(student_id) (another way of defining primary key) */
/* AUTO_INCREMENT increases the number automatically, it can be used with primary keys */
/* Along with DEFAULT, UNIQUE and NOT NULL are also constrains */
/* ================================= */
/* *** Describing the Table *** */

DESCRIBE student;
/* DESCRIBE statement describes the table */
/* ================================= */
/* *** Altering the Table *** */

/* Adding a new column using the ADD statement */
ALTER TABLE student ADD gpa DECIMAL(3,2);

/* Droping an existing column using the DROP statement */
ALTER TABLE student DROP COLUMN gpa; 
/* It drops the columns specified */
/* ================================= */
/* *** Inserting values in the Table *** */

INSERT INTO student VALUES(1,'Jack','CompSci');
INSERT INTO student VALUES(2,'Ramo','CompSci'); 
INSERT INTO student(student_id,name) VALUES(3,'Jane'); /* If we don't specify any colum data it will give NULL in the remaining places if those places accept NULL value */
INSERT INTO student VALUES(4,'Rock','CompSci');
INSERT INTO student VALUES(5,'Ron','Maths');
/* ================================= */
/* *** Updating values of the Table *** */


UPDATE student
SET major = 'Bio'
WHERE major = 'Maths';

UPDATE student
SET major = 'Physics'
WHERE student_id = 2;

UPDATE student
SET major = 'SoftSkills'
WHERE major = 'CompSci' OR major = 'Physics';

UPDATE student
SET name = 'Tom',major = 'Math'
WHERE student_id = 1 ;

DELETE FROM student
WHERE name = 'Ron';
/* ================================= */
/* *** Retrieving data from Table *** */

SELECT * 
FROM student
WHERE major = 'SoftSkills' AND student_id > 3;

SELECT * 
FROM student
WHERE major <> 'SoftSkills';

/* '=' this symbol represents equality and '<>' this symbol represents inequality */

SELECT * 
FROM student
WHERE name IN ('Tom','Jane'); 
/* KON is not in the table */

SELECT student.name, student.major
FROM student
WHERE major = 'SoftSkills' AND name = 'Rock';
/* ================================= */
/* *** Ordering the Table *** */

ORDER BY major, student_id ASC
LIMIT 2;

/* 'ASC' is for ascending and 'DESC' is for descending */

SELECT * FROM student;
/* ================================= */
/* *** Droping the Table *** */


DROP TABLE student;  

/* DROP statement delete's the table */
