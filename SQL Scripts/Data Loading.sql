use role accountadmin;

use warehouse compute_wh;

use schema MYDB.MYSCHEMA;


--Bulk load data manually

//Create an User table
CREATE OR REPLACE TABLE USER (
    id INTEGER,
    name VARCHAR(50),
    location VARCHAR(50),
    email VARCHAR(50)
);


//Create an storage integration with s3 and iam role
CREATE OR REPLACE STORAGE INTEGRATION s3_int
TYPE = EXTERNAL_STAGE
STORAGE_PROVIDER = 'S3'
ENABLED = TRUE
STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::039612852560:role/snowflakerole'
STORAGE_ALLOWED_LOCATIONS = ('s3://de-academy-class-bucket/');


//Describe the storage integration
DESC INTEGRATION s3_int;

//Create a file format
CREATE OR REPLACE FILE FORMAT my_csv_format
TYPE = 'CSV'
FIELD_DELIMITER = ','
RECORD_DELIMITER = '\n'


//Create a external s3 stage
CREATE OR REPLACE STAGE my_s3_stage
    STORAGE_INTEGRATION = s3_int
    URL = 's3://de-academy-class-bucket/'
    FILE_FORMAT = my_csv_format;

//Access the external stage
list @my_s3_stage;

//Load data to customer table without file format
copy into USER
from @my_s3_stage
FILE_FORMAT = (FORMAT_NAME = CSV_FORMAT);

//Select data from the table
SELECT * FROM USER;


-- Building Snowpipe: Bulk load data automatically

CREATE OR REPLACE TABLE EVENT (
    EVENT VARIANT
);

//Create an storage integration with s3 and iam role
CREATE OR REPLACE STORAGE INTEGRATION s3_snowpipe_int
TYPE = EXTERNAL_STAGE
STORAGE_PROVIDER = 'S3'
ENABLED = TRUE
STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::039612852560:role/snowpiperole'
STORAGE_ALLOWED_LOCATIONS = ('s3://de-academy-class-bucket/event/');

//Describe the storage integration
DESC INTEGRATION s3_snowpipe_int;

//Create a file format
CREATE OR REPLACE FILE FORMAT my_json_format
TYPE = 'JSON';

//Create a external s3 stage
CREATE OR REPLACE STAGE my_s3_snowpipe_stage
    STORAGE_INTEGRATION = s3_snowpipe_int
    URL = 's3://de-academy-class-bucket/event/'
    FILE_FORMAT = my_json_format;

//Access the external stage
list @my_s3_snowpipe_stage;

//Create a snowpipe to load the evenet data from s3
create or replace pipe s3_pipe
auto_ingest = true AS
copy into event
from @my_s3_snowpipe_stage
FILE_FORMAT = (FORMAT_NAME = my_json_format);

//Select the status of the pipe
SELECT SYSTEM$PIPE_STATUS('s3_pipe');

show pipes;

select * from event;