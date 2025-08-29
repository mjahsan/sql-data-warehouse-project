/*
=======================================================================================
  OBJECTIVE:
  The main scope of this script is to create a ddl for the table that is to be extracted
  from the source to the bronze layer
========================================================================================
WARNING: 
  Running this script will delete the existing tables with the mentioned names which in 
  turn deletes all the existing mapped data.
  Please ensure proper backups before proceeding.
  Table names:
  _1_ bronze.crm_cust_info
  _2_ bronze.crm_prd_info
  _3_ bronze.crm_sales_details
  _4_ bronze.erp_loc_a101
  _5_ bronze.erp_cust_az12
  _6_ bronze.erp_px_cat_g1v2
========================================================================================
*/

-- Creating tables(DDL) for raw data extraction

drop table if exists bronze.crm_cust_info

create table bronze.crm_cust_info (
    cust_id             INT,
    cst_key             NVARCHAR (50),
    cst_firstname       NVARCHAR(50),
    cst_lastname        NVARCHAR(50),
    cst_marital_status  NVARCHAR(50),
    cst_gndr            NVARCHAR(50),
    cst_create_date     DATE
   );

go

drop table if exists bronze.crm_prd_info

create table bronze.crm_prd_info (
    prd_id       INT,
    prd_key      NVARCHAR(50),
    prd_nm       NVARCHAR(50),
    prd_cost     INT,
    prd_line     NVARCHAR(50),
    prd_start_dt DATETIME,
    prd_end_dt   DATETIME
);
go

drop table if exists bronze.crm_sales_details

create table bronze.crm_sales_details (
    sls_ord_num  NVARCHAR(50),
    sls_prd_key  NVARCHAR(50),
    sls_cust_id  INT,
    sls_order_dt INT,
    sls_ship_dt  INT,
    sls_due_dt   INT,
    sls_sales    INT,
    sls_quantity INT,
    sls_price    INT
);
go

drop table if exists bronze.erp_loc_a101

create table bronze.erp_loc_a101 (
    cid    NVARCHAR(50),
    cntry  NVARCHAR(50)
);
go

drop table if exists bronze.erp_cust_az12

create table bronze.erp_cust_az12 (
    cid    NVARCHAR(50),
    bdate  DATE,
    gen    NVARCHAR(50)
);
go

drop table if exists bronze.erp_px_cat_g1v2

create table bronze.erp_px_cat_g1v2 (
    id           NVARCHAR(50),
    cat          NVARCHAR(50),
    subcat       NVARCHAR(50),
    maintenance  NVARCHAR(50)
);

