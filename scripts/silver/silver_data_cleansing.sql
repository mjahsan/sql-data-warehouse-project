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
  
truncate table silver.crm_cust_info --- truncating the table to avoid data duplications
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
where flag_last = 1 -- filtering only the latest data;

print' >>>>>>>>>>>>>>>>>>>>>>>>>>>>> prd_info <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<'

truncate table silver.crm_prd_info --- truncating the table to avoid data duplications
insert into silver.crm_prd_info (
    prd_id,
    cat_id,
    prd_key,
    prd_nm,
    prd_cost,
    prd_line,
    prd_start_dt,
    prd_end_dt
)
select
prd_id,
replace(substring(prd_key, 1, 5), '-', '_') as cat_id, -- replaced the dash with underscore to match the foriegn key in another table
substring(prd_key, 7, len(prd_key)) as prd_key, -- seperated another column to reference it to another table
prd_nm,
isnull(prd_cost, 0) as prd_cost, -- handled null values
case upper(trim(prd_line)) -- upper to handled consistency across the column
	 when 'M' then 'Mountain'
	 when 'S' then 'Sport'
	 when 'R' then 'Road'
	 when 'T' then 'Touring'
	 else 'N/A'
end as prd_line,
cast(prd_start_dt as date) prd_start_dt, -- Removed datetime as there are no seconds/minutes/hours in the source table
cast(lead(prd_start_dt) over(partition by prd_key order by prd_start_dt asc)-1 as date) as prd_end_dt -- had added a new column to bring consistency among the start and end date
from bronze.crm_prd_info
