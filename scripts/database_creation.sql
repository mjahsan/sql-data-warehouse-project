/*
=======================================================================================
  OBJECTIVE:
  The main scope of this script is to create a database for datawarehouse along with the 
  schemas for the layers through which the data will be modified:
  - Bronze
  - Silver
  - Gold
========================================================================================
WARNING: 
  Running this script will delete the existing database named "DataWarehouse" which in 
  turn deletes the existing fles. Please ensure proper backups before proceeding.
========================================================================================
*/


-- Datawarehouse Project --

use master;
go

-- Check and drop if database exists
drop database if exists DataWarehouse;
go

-- Creating a new database after drop
create database DataWarehouse;
go

-- Switching to the newly created database
use DataWarehouse;
go

-- Cretaing Schemas
create schema bronze;
go
create schema silver;
go
create schema gold;
