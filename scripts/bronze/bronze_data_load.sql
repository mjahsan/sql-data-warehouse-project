/*
=======================================================================================
  OBJECTIVE:
  The main scope of this script is to bulk insert data from the source into the table
  created in the previous step. Additional optimization techniques such as setting up
  the elapsed time to check for bottlenecks, try & catch to keep the script running and 
  catch any error along with additional print statements to keep track of the execution.
  The whole script has been made as stored procedure to ensure reusability and avoid
  re-iteration of the code.
========================================================================================
WARNING: 
  Running this script will delete all the existing  data in the tables with the new data
  mentioned in the path.
  Please ensure proper backups before proceeding.
========================================================================================
*/
create or alter procedure bronze.store_procedure_load_bronze as
begin
	declare @start_time datetime, @end_time datetime, @batch_start_time datetime, @batch_end_time datetime 
	begin try
		set @batch_start_time = getdate()
		print '>>>>>>>>>>>> BRONZE LAYER LOADING INITIATED <<<<<<<<<<<<<<<<'
		print '===================== CRM =================================='
		set @start_time = GETDATE()

		set @start_time = GETDATE()
		print 'Truncating the table: bronze.crm_cust_info'
		truncate table bronze.crm_cust_info
		print '>>> Truncating completed'

		print 'Inserting data into: bronze.crm_cust_info'
		bulk insert bronze.crm_cust_info
		from 'http//: github.com/mjahsan/sql-data-warehouse-project/datasets/crm/cust_info'
		with(
			firstrow = 2,
			fieldterminator = ',',
			tablock
		);
		print '>>> Insertion completed'
		set @end_time = GETDATE()
		print 'Time elapsed:' + cast(datediff(second, @start_time, @end_time) as varchar) + 'seconds'
		print '-------------------------------------------------------------'

		set @start_time = GETDATE()
		print 'Truncating the table: bronze.crm_prd_info'
		truncate table bronze.crm_prd_info
		print '>>> Truncating completed'

		print 'Inserting data into: bronze.crm_prd_info'
		bulk insert bronze.crm_prd_info
		from 'http//: github.com/mjahsan/sql-data-warehouse-project/datasets/crm/prd_info.csv'
		with(
			firstrow = 2,
			fieldterminator = ',',
			tablock
		);
		print '>>> Insertion completed'
		set @end_time = GETDATE()
		print 'Time elapsed:' + cast(datediff(second, @start_time, @end_time) as varchar) + 'seconds'
		print '-------------------------------------------------------------'

		set @start_time = GETDATE()
		print 'Truncating the table: bronze.crm_sales_details'
		truncate table bronze.crm_sales_details
		print '>>> Truncating completed'

		print 'Inserting data into: bronze.crm_sales_details'
		bulk insert bronze.crm_sales_details
		from 'http//: github.com/mjahsan/sql-data-warehouse-project/datasets/crm/sales_details.csv'
		with(
			firstrow = 2,
			fieldterminator = ',',
			tablock
		);
		print '>>> Insertion completed'
		set @end_time = GETDATE()
		print 'Time elapsed:' + cast(datediff(second, @start_time, @end_time) as varchar) + 'seconds'
		print '-------------------------------------------------------------'

		print'========================= ERP ================================='

		set @start_time = GETDATE()
		print 'Truncating the table: bronze.erp_cust_az12'
		truncate table bronze.erp_cust_az12
		print '>>> Truncating completed'

		print 'Inserting data into: bronze.erp_cust_az12'
		bulk insert bronze.erp_cust_az12
		from 'http//: github.com/mjahsan/sql-data-warehouse-project/datasets/erp/CUST_AZ12.csv'
		with(
			firstrow = 2,
			fieldterminator = ',',
			tablock
		);
		print '>>> Insertion completed'
		set @end_time = GETDATE()
		print 'Time elapsed:' + cast(datediff(second, @start_time, @end_time) as varchar) + 'seconds'
		print '-------------------------------------------------------------'

		set @start_time = GETDATE()
		print 'Truncating the table: bronze.erp_loc_a101'
		truncate table bronze.erp_loc_a101
		print '>>> Truncating completed'

		print 'Inserting data into: bronze.erp_loc_a101'
		bulk insert bronze.erp_loc_a101
		from 'http//: github.com/mjahsan/sql-data-warehouse-project/datasets/erp/LOC_A101.csv'
		with(
			firstrow = 2,
			fieldterminator = ',',
			tablock
		);
		print '>>> Insertion completed'
		set @end_time = GETDATE()
		print 'Time elapsed:' + cast(datediff(second, @start_time, @end_time) as varchar) + 'seconds'
		print '-------------------------------------------------------------'

		set @start_time = GETDATE()
		print 'Truncating the table: bronze.erp_px_cat_g1v2'
		truncate table bronze.erp_px_cat_g1v2
		print '>>> Truncating completed'

		print 'Inserting data into: bronze.erp_px_cat_g1v2'
		bulk insert bronze.erp_px_cat_g1v2
		from 'http//: github.com/mjahsan/sql-data-warehouse-project/datasets/erp/PX_CAT_G1V2.csv'
		with(
			firstrow = 2,
			fieldterminator = ',',
			tablock
		);
		print '>>> Insertion completed'
		set @end_time = GETDATE()
		print 'Time elapsed:' + cast(datediff(second, @start_time, @end_time) as varchar) + 'seconds'
		print '-------------------------------------------------------------'
		
		print '>>>>>>>>>>>>>> BRONZE LAYER LOADING COMPLETED <<<<<<<<<<<<<<<'
		set @batch_end_time = GETDATE()
		print 'Total batch time:' + cast(datediff (second, @batch_start_time, @batch_end_time)as varchar) + 'seconds'
	end try
	begin catch
		print '======================================================'
		print 'Error occured during loading bronze layer'
		print 'Error message:' + error_message()
		print 'Error line:' + error_line()
		print 'Error number:' + cast(error_number() as varchar)
		print 'Error line:' + cast(error_line() as varchar);
		print '======================================================'
	end catch
end
