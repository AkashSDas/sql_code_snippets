/* ****** Employee Database ****** */

/* ================================= */
/* Creating the Tables */

/* Employee Table */
CREATE TABLE employee(
    emp_id INT PRIMARY KEY,
    first_name VARCHAR(20),
    last_name VARCHAR(20),
    birth_day DATE,
    sex VARCHAR(1),
    salary INT,
    super_id INT,
    branch_id INT
);

/* Branch Table */
CREATE TABLE branch(
    branch_id INT PRIMARY KEY,
    branch_name VARCHAR(40),
    mrg_id INT,
    mrg_start_date DATE,
    FOREIGN KEY(mrg_id) REFERENCES employee(emp_id) ON DELETE SET NULL
);

/* Adding the FOREIGN KEY in employee table after creating both the employee and branch tables */
ALTER TABLE employee
ADD FOREIGN KEY(branch_id) 
REFERENCES branch(branch_id)
ON DELETE SET NULL;

/* Adding the FOREIGN KEY in employee table after creating both the employee and branch tables */
ALTER TABLE employee
ADD FOREIGN KEY(super_id) 
REFERENCES employee(emp_id) 
ON DELETE SET NULL;

/* Client Table */
CREATE TABLE client(
    client_id INT PRIMARY KEY,
    client_name VARCHAR(20),
    branch_id INT,
    FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE SET NULL
);

/* Work_With Table */
CREATE TABLE work_with(
    emp_id INT,
    client_id INT,
    total_sales INT,
    PRIMARY KEY(emp_id,client_id),
    FOREIGN KEY(emp_id) REFERENCES employee(emp_id) ON DELETE CASCADE,
    FOREIGN KEY(client_id) REFERENCES client(client_id) ON DELETE CASCADE
);

/* Branch_Supplier Table */
CREATE TABLE branch_supplier(
    branch_id INT,
    supplier_name VARCHAR(20),
    supply_type VARCHAR(40),
    FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE CASCADE
);
/* ================================= */
/* *** Inserting and Altering the data in all tables *** */

INSERT INTO employee VALUES(100,'Dave','Wallace','1975-08-03','M',250000,NULL,NULL);
INSERT INTO branch VALUES(1,'Coporate',100,'2006-02-09');

UPDATE employee
SET branch_id = 1
WHERE emp_id = 100;

INSERT INTO employee VALUES(101,'John','Cena','1995-08-03','M',350000,100,1);
INSERT INTO employee VALUES(102,'Randy','Ortan','1963-11-03','M',200000,NULL,NULL);
INSERT INTO branch VALUES(2,'Scranton',102,'2012-12-09');

UPDATE employee
SET branch_id = 2
WHERE emp_id = 102;

INSERT INTO employee VALUES(103,'James','Charles','1999-03-18','M',100000,100,2);
INSERT INTO employee VALUES(104,'Maria','Hills','2001-01-08','F',400000,102,1);
INSERT INTO employee VALUES(105,'Shreya','Lane','1991-12-29','F',200000,101,2);

INSERT INTO employee VALUES(106,'Elon','Musk','1983-05-03','M',400000,NULL,NULL);
INSERT INTO branch VALUES(3,'Stamford',106,'2001-02-09');

UPDATE employee
SET branch_id = 3
WHERE emp_id = 106;

INSERT INTO employee VALUES(107,'Bill','Gates','1972-03-19','M',100000,102,3);
INSERT INTO employee VALUES(108,'Steve','Jobs','1981-01-23','M',500000,103,3);

INSERT INTO branch_supplier VALUES(2,'Hammer Hills','Paper');
INSERT INTO branch_supplier VALUES(2,'Uni-Ball','Writing Utnesils');
INSERT INTO branch_supplier VALUES(3,'Patriot Paper','Paper');
INSERT INTO branch_supplier VALUES(2,'Uni-Ball','Writing Utnesils');
INSERT INTO branch_supplier VALUES(3,'Hammer Hills','Paper');
INSERT INTO branch_supplier VALUES(3,'Stamford Lables','Custom FormS');

INSERT INTO client VALUES(400,'Dunmore Highschool',2);
INSERT INTO client VALUES(401,'Lackawana Country',2);
INSERT INTO client VALUES(402,'FedEx',3);
INSERT INTO client VALUES(403,'John Daly Law LLC',3);
INSERT INTO client VALUES(404,'Scranton Whitepages',2);
INSERT INTO client VALUES(405,'FedEx',2);

INSERT INTO work_with VALUES(105,400,55000);
INSERT INTO work_with VALUES(102,401,70900);
INSERT INTO work_with VALUES(106,402,225000);
INSERT INTO work_with VALUES(108,403,170000);
INSERT INTO work_with VALUES(107,403,300000);
INSERT INTO work_with VALUES(102,405,270000);
INSERT INTO work_with VALUES(105,406,130000);
/* ================================= */
/* *** SQL Functions *** */

/* COUNT */
SELECT COUNT(emp_id)
FROM employee
WHERE sex = 'F' AND birth_day > '1971-04-12';

/* AVG */
SELECT AVG(salary)
FROM employee;

/* SUM */
SELECT SUM(salary)
FROM employee;

SELECT COUNT(sex), sex
FROM employee;

/* GROUP BY */
SELECT COUNT(sex), sex
FROM employee
GROUP BY sex; 
/* This is aggregation */

SELECT SUM(total_sales), emp_id
FROM work_with
GROUP BY emp_id;

SELECT SUM(total_sales), client_id
FROM work_with
GROUP BY client_id;
/* ================================= */
/* *** Wildcards and LIKE key word *** */

/* '%' this represents any number of character */
/* '_' this represents one character */

SELECT *
FROM client
WHERE client_name LIKE '%LLC';

SELECT *
FROM branch_supplier
WHERE supplier_name LIKE '% Lables%';

SELECT *
FROM employee
WHERE birth_day LIKE '____-08%';

SELECT *
FROM client
WHERE client_name LIKE '%school%';
/* ================================= */
/* *** UNION *** */

/* RULES OF USING UNION:  
    1. We have to have same number of columns 
    2. They must have similar datatype 
*/

SELECT first_name AS Company_Name
FROM employee
UNION
SELECT branch_name
FROM branch;

SELECT client_name,client.branch_id
FROM client
UNION
SELECT supplier_name,branch_supplier.branch_id
FROM branch_supplier;

SELECT salary 
FROM employee
UNION
SELECT total_sales
FROM work_with;
/* ================================= */
/* *** JOINTS *** */

INSERT INTO branch VALUES(4,'Buffalo',NULL,NULL);

SELECT employee.emp_id,employee.first_name,branch.branch_name
FROM employee
JOIN branch
ON employee.emp_id = branch.mrg_id;

SELECT employee.emp_id,employee.first_name,branch.branch_name
FROM employee
LEFT JOIN branch
ON employee.emp_id = branch.mrg_id;

/* Other two types of joint are RIGHT and FULL */
/* ================================= */
/* *** NESTED QUERIES *** */

/* Inner query is first evaluated */

SELECT employee.first_name,employee.last_name
FROM employee
WHERE employee.emp_id IN (
    SELECT work_with.emp_id
    FROM work_with
    WHERE work_with.total_sales > 30000
);

SELECT client.client_name
FROM client
WHERE client.branch_id = (
    SELECT branch.branch_id
    FROM branch
    WHERE branch.mrg_id = 102
    LIMIT 1 
);
/* ================================= */
/* *** Delete *** */

/* ON DELETE SET NYLL --> sets NULL when foreign key is deleted */

/* ON DELETE CASCADE --> delete's the entire row when foreign key is deleted */
/* ================================= */
/* *** Triggers *** */

/* Triggers : Performs some action when some other action is performed */

/* --------------------------------- */
DELIMITER $$
CREATE 
    TRIGGER my_trigger BEFORE INSERT
    ON employee
    FOR EACH ROW BEGIN 
        INSERT INTO trigger_test VALUES('added new employee');
    END $$
DELIMITER ; 
/* --------------------------------- */
INSERT INTO employee VALUES(109,'Martina','Blunt','1999-07-02','F',69000,3);
/* --------------------------------- */
SELECT * FROM trigger_test;

/* OUTPUT: added new employee  */
/* --------------------------------- */
DELIMITER $$
CREATE 
    TRIGGER my_trigger1 BEFORE INSERT
    ON employee
    FOR EACH ROW BEGIN 
        INSERT INTO trigger_test VALUES(NEW.first_name);
    END $$
DELIMITER ; 
/* --------------------------------- */
INSERT INTO employee VALUES(110,'Kevin','Blunt','1999-07-02','F',69000,3);
/* --------------------------------- */
SELECT * FROM trigger_test;

/* OUTPUT: added new employee
           Kevin    
*/
/* --------------------------------- */           
DELIMITER $$
CREATE 
    TRIGGER my_trigger2 BEFORE INSERT
    ON employee
    FOR EACH ROW BEGIN 
        IF NEW.sex = 'M' THEN 
            INSERT INTO trigger_test VALUES('added male employee');
        ELSE IF NEW.sex = 'F' THEN
            INSERT INTO trigger_test VALUES('added female employee');
        ELSE 
            INSERT INTO trigger_test VALUES('added other employee');
        END IF;
    END $$
DELIMITER ;   
/* --------------------------------- */
INSERT INTO employee VALUES(111,'Gamora','Blunt','1999-07-02','F',69000,3);
/* --------------------------------- */
SELECT * FROM trigger_test;

/* OUTPUT: added new employee
           Gamora
           added female employee  
*/
/* --------------------------------- */           
DELIMITER $$
CREATE 
    TRIGGER my_trigger BEFORE UPDATE
    ON employee
    FOR EACH ROW BEGIN 
        INSERT INTO trigger_test VALUES('added new employee');
    END $$
DELIMITER ; 
/* --------------------------------- */
DELIMITER $$
CREATE 
    TRIGGER my_trigger BEFORE DELETE
    ON employee
    FOR EACH ROW BEGIN 
        INSERT INTO trigger_test VALUES('added new employee');
    END $$
DELIMITER ; 
/* --------------------------------- */
DELIMITER $$
CREATE 
    TRIGGER my_trigger AFTER INSERT
    ON employee
    FOR EACH ROW BEGIN 
        INSERT INTO trigger_test VALUES('added new employee');
    END $$
DELIMITER ; 
/* --------------------------------- */
DROP TRIGGRT my_trigger;
