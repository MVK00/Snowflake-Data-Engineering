//Set the Roles, Warehouses and Databases

USE ROLE ACCOUNTADMIN;

USE WAREHOUSE COMPUTE_WH;

USE SCHEMA MYDB.MYSCHEMA;

//===== Zero copy cloning=========

//Create a test db from actual db
create or replace DATABASE test_mydb
CLONE mydb;

//drop the clone db
drop database test_mydb;