/*
=======================================================================================
  OBJECTIVE:
  The main scope of this script is to cleanse the data from bronze layer, handle the
  nulls, drop the duplicates and bring consistency to the table. It is finally loaded
  to the ddl table created in the silver layer earlier. 
========================================================================================
WARNING: 
  Running this script will delete all the existing data in the tables with the new data.
  Please ensure proper backups before proceeding.
========================================================================================
*/
print '==============================================================================='
print '                              CRM                                              '
print '==============================================================================='
print ''
print' >>>>>>>>>>>>>>>>>>>>>>>>>>>>> cust_info <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<'
  
insert into silver.crm_cust_info (
cust_id,
cst_key,
cst_firstname,
cst_lastname,
cst_marital_status,
cst_gndr,
cst_create_date)

select
cust_id,
cst_key,
trim(cst_firstname) cst_firstname, -- removing trailing spaces before and after the name
trim(cst_lastname) cst_lastname, -- removing trailing spaces before and after the name
case when upper(trim(cst_marital_status)) = 'M' then 'Married' -- incase if there are any lower case values and trailing spaces
	 when upper(trim(cst_marital_status)) = 'S' then 'Single' -- incase if there are any lower case values and trailing spaces
	 else 'N/A' -- handles null values
end cst_marital_status,
case when upper(trim(cst_gndr)) = 'F' then 'Female' -- incase if there are any lower case values and trailing spaces
	 when upper(trim(cst_gndr)) = 'M' then 'Male' -- incase if there are any lower case values and trailing spaces
	 else 'N/A' -- handles null values
end cst_gndr,
cst_create_date
from 
(select
*,
row_number() over(partition by cust_id order by cst_create_date desc) flag_last -- flagging duplicates via row_numbers and prioritizing data as per creation date
from bronze.crm_cust_info
where cust_id is not null)t -- filtering out the nulls
where flag_last = 1 -- filtering only the latest data
