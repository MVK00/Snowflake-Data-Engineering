use role accountadmin;

use warehouse compute_wh;

use schema MYDB.MYSCHEMA;

create or replace database MYDB;
create or replace schema MYSCHEMA;

//Create a permanent table
CREATE OR REPLACE TABLE PERMANENT_TABLE
(
ID INT,
NAME STRING
);

ALTER TABLE PERMANENT_TABLE SET DATA_RETENTION_TIME_IN_DAYS = 98;


// Create a transient table
CREATE OR REPLACE TRANSIENT TABLE TRANSIENT_TABLE
(
ID INT,
NAME STRING
);

ALTER TABLE TRANSIENT_TABLE SET DATA_RETENTION_TIME_IN_DAYS = 2;


// Create a temporary table
CREATE OR REPLACE TEMPORARY TABLE TEMPORARY_TABLE
(
ID INT,
NAME STRING
);

ALTER TABLE TEMPORARY_TABLE SET DATA_RETENTION_TIME_IN_DAYS = 2;

show tables;


//Create an Employee table
CREATE OR REPLACE TABLE employees (
    id INTEGER,
    name VARCHAR(50),
    department VARCHAR(50),
    salary INTEGER
);

//Insert data into the table
INSERT INTO employees (id, name, department, salary)
VALUES
    (1, 'Pat Fay', 'HR', 50000),
    (2, 'Donald Oconnel', 'IT', 75000),
    (3, 'Steven King', 'Sales', 60000),
    (4, 'Susan Mavris', 'IT', 80000),
    (5, 'Jennifer Whalen', 'Marketing', 55000);

// Select data from the table
SELECT * FROM employees;


// Let's create a view called "it_employees" that only includes the employees from the IT department:
//If nothing is mentioned then it a standard view by default
CREATE OR REPLACE VIEW it_employees AS
SELECT id, name, salary
FROM employees
WHERE department = 'IT';

// Select data from the it_employees view
SELECT * FROM it_employees;

// Let's create a view called "it_employees" that only includes the employees from the IT department:
CREATE OR REPLACE secure VIEW hr_employees AS
SELECT id, name, salary
FROM employees
WHERE department = 'HR';

// Select data from the it_employees view
SELECT * FROM hr_employees;


//Create a view that aggregates the salaries by department.
CREATE OR REPLACE VIEW employee_salaries AS
SELECT
    department,
    SUM(salary) AS total_salary
FROM employees
GROUP BY department;

// Select data from the employee_salaries view
SELECT * FROM employee_salaries;


//Create a materialized view that aggregates the salaries by department.
CREATE OR REPLACE MATERIALIZED VIEW materialized_employee_salaries 
AS SELECT
    department,
    SUM(salary) AS total_salary
FROM employees
GROUP BY department;

// Select data from the materialized_employee_salaries view
SELECT * FROM materialized_employee_salaries;

show views;
------------------------------------------------------------------
--Stages:

//create customer table
CREATE OR REPLACE TABLE customer (
    id INTEGER,
    name VARCHAR(50),
    age INTEGER,
    state VARCHAR(50)
);

//Access the table stage
list @%customer;

//Access the user stage
list @~;

//Create a named stage
CREATE OR REPLACE STAGE CUSTOMER_STAGE;

//Access the names internal stage
list @CUSTOMER_STAGE;

//Truncate the table
TRUNCATE TABLE CUSTOMER;

select * from customer;

//Load data to customer table
copy into customer
from @CUSTOMER_STAGE
file_format = (TYPE = 'CSV' SKIP_HEADER = 1);

//Select data from the table
SELECT * FROM CUSTOMER;

undrop schema myschema;

---------------------------------------------------------------------------------
-- File Formats


//Create an Employee table
CREATE OR REPLACE TABLE STUDENT (
    id INTEGER,
    name VARCHAR(50),
    age INTEGER,
    marks INTEGER
);

//Create a internal named stage
CREATE OR REPLACE STAGE STUDENT_STAGE;

//Access the names internal stage
list @STUDENT_STAGE;

//Create a CSV File format
CREATE or replace FILE FORMAT CSV_FORMAT
TYPE = 'CSV'
FIELD_DELIMITER = ','
RECORD_DELIMITER = '\n'
SKIP_HEADER = 1;


//Load data to customer table with file format
copy into STUDENT
from @STUDENT_STAGE
FILE_FORMAT = (FORMAT_NAME = CSV_FORMAT);

//Select data from the table
SELECT * FROM STUDENT;

