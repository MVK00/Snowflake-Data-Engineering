use role accountadmin;

use warehouse compute_wh;

use schema MYDB.MYSCHEMA;

//===== Standard Stream ========= 
-- All three are recorded insert, update and delete

//Create a source table table
CREATE OR REPLACE TABLE source_table1 (
    id INT,
    name VARCHAR,
    created_date DATE
);

//Insert some records on the source table 1
INSERT INTO source_table1 VALUES
    (1, 'Chaos', '2023-12-11'),
    (2, 'Genius', '2023-12-11');

//Create a standard stream on the table
CREATE OR REPLACE STREAM standard_stream ON TABLE source_table1;

//Select data from the table
select * from source_table1;

//select data from the standard stream
select * from standard_stream;

INSERT INTO source_table1 VALUES (3, 'Johnny', '2023-12-11');

delete from source_table1 where id=2;

update source_table1 set name='Ram' where id=1;


//======Append Only Stream==========

--Only Insert commands are tracked/captured

//Create a source table table
CREATE OR REPLACE TABLE source_table2 (
    id INT,
    name VARCHAR,
    created_date DATE
);

//Insert some records on the source table 2
INSERT INTO source_table2 VALUES
    (1, 'Chaos', '2023-12-11'),
    (2, 'Genius', '2023-12-11');

//Create a standard stream on the table
CREATE OR REPLACE STREAM append_only_stream ON TABLE source_table2 APPEND_ONLY = TRUE;

//select data from the append only stream
select * from append_only_stream;

INSERT INTO source_table2 VALUES (3, 'Johnny', '2023-12-11');

//Select data from the table
select * from source_table2;

delete from source_table2 where id=2;

update source_table2 set name='Ram' where id=3;


//==How do we use the stream in ETL process ==

CREATE OR REPLACE TABLE TARGET_TABLE2 (
    id INT,
    name VARCHAR,
    created_date DATE
);

//select data from the standard stream
select * from append_only_stream;

//insert into a target table
insert into TARGET_TABLE2
SELECT ID,NAME,CREATED_DATE FROM append_only_stream;

//select data from the standard stream
select * from append_only_stream;

//select data from target table
select * from TARGET_TABLE2;

//Insert into source table
INSERT INTO source_table2 VALUES (4, 'Rock', '2023-12-11');

//Select data from the table
select * from source_table2;

//select data from the standard stream
select * from append_only_stream;

//insert into a target table
insert into TARGET_TABLE2
SELECT ID,NAME,CREATED_DATE FROM append_only_stream;



