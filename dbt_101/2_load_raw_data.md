# Instructions for loading raw data into Snowflake

Before you can define sources, you need to have the raw data they point to loaded in your data warehouse. For the purposes of this Lab, we will load some static shop data in Snowflake. You can find the files containing the data that needs to be imported in the **FILES** dropdown menu in the upper right corner of this screen.

- [Instructions for loading raw data into Snowflake](#instructions-for-loading-raw-data-into-snowflake)
  - [Overview](#overview)
  - [Loading the data](#loading-the-data)

## Overview

You can see an Entity Relationship Diagram (ERD) of the data you are about to load below:

![ERD](../images/ERD.png)

## Loading the data

1. Execute the script below in Snowflake (don't worry if you don't understand the script, just execute it to set your environment up):

**NOTE:** Make sure to replace `<YOUR NAME>` with your name.

```
SET NAME = '<YOUR NAME>'; // <--- replace this value
SET DB_NAME = 'DBT_' || $NAME;
SET SCHEMA_NAME = '"' || $DB_NAME || '"."RAW"';
SET ROLE_NAME = 'ROLE_DBT_' || $NAME;

USE ROLE SYSADMIN;

-- create schema and tables for raw data
CREATE SCHEMA IF NOT EXISTS IDENTIFIER($SCHEMA_NAME);
USE SCHEMA IDENTIFIER($SCHEMA_NAME);

CREATE TABLE IF NOT EXISTS CUSTOMERS(ID VARCHAR, FIRST_NAME VARCHAR, LAST_NAME VARCHAR, EMAIL VARCHAR, GENDER VARCHAR, DATE_OF_BIRTH VARCHAR);
CREATE TABLE IF NOT EXISTS ORDERS(ID VARCHAR, DATE VARCHAR, CUSTOMER_ID VARCHAR, STATUS VARCHAR);
CREATE TABLE IF NOT EXISTS ORDER_ITEMS(ORDER_ID VARCHAR, ORDER_ITEM_ID VARCHAR, PRODUCT_ID VARCHAR, QUANTITY VARCHAR);
CREATE TABLE IF NOT EXISTS PRODUCTS(ID VARCHAR, NAME VARCHAR, PRICE VARCHAR, CATEGORY VARCHAR);

-- create file format to load data into tables
CREATE FILE FORMAT IF NOT EXISTS CSV_FILE_FORMAT
TYPE = CSV
SKIP_HEADER = 1
FIELD_OPTIONALLY_ENCLOSED_BY = '"'; 

-- ensure dbt can access raw data
USE ROLE SECURITYADMIN;
GRANT USAGE ON SCHEMA IDENTIFIER($SCHEMA_NAME) TO ROLE IDENTIFIER($ROLE_NAME);
GRANT SELECT ON ALL TABLES IN SCHEMA IDENTIFIER($SCHEMA_NAME) TO ROLE IDENTIFIER($ROLE_NAME);
```

2. Navigate to the folder containing the .csv files you downloaded - their names correspond to the tables you just created in Snowflake. You will use the data from these files to populate your Snowflake tables.

3. Make sure you're using the `SYSADMIN` role. Navigate to Snowflake's home and go to `Data` > `Databases` > `DBT_<YOUR NAME>` > `RAW` > `Tables` > `CUSTOMERS` and click `Load Data` in the upper right corner:

![Snowflake UI](../images/loading_1.png)

4. Select the `WH_DBT_<YOUR NAME>` warehouse, upload the `customers.csv` file and click `Next`:

![Snowflake UI](../images/loading_2.png)

5. Select the file format you create earlier (`DBT_<YOUR NAME>.RAW.CSV_FILE_FORMAT`) and click `Next`:

![Snowflake UI](../images/loading_3.png)

6. You should see a message that confirms that your data has been loaded into the `CUSTOMERS` table successfully:

![Snowflake UI](../images/loading_4.png)

Click `Done` and repeat steps 3, 4 and 5 for the rest of the tables - `ORDERS`, `ORDER_ITEMS` and `PRODUCTS`.

Once you have loaded all 4 tables with data, you can proceed with the next steps in the [Lab](lab/lab-m2w3-part1.md).