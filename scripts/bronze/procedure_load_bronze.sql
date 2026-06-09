/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
===============================================================================
*/
 
 
 
 
 
 
 --- Insert data from csv files into the database and truncate the table if any exists so it avoids duplicacy

 CREATE OR ALTER PROCEDURE bronze.load_bronze AS 
 BEGIN
     DECLARE @start_time Datetime, @end_time Datetime,@batch_start_time datetime, @batch_end_time datetime;
     BEGIN TRY
         set @batch_start_time=getdate();

         PRINT'==============================================================================================';
         PRINT'Loading Broze layer';
         PRINT'==============================================================================================';

         PRINT'----------------------------------------------------------------------------------------------';
         PRINT'LOADING CRM files';
         PRINT'----------------------------------------------------------------------------------------------';
        
         set @start_time= getdate();
         PRINT' Truncating Table: bronze.crm_cust_info';
         TRUNCATE TABLE bronze.crm_cust_info;

         PRINT'Inserting Data into:  bronze.crm_cust_info';
         BULK INSERT bronze.crm_cust_info
         FROM 'C:\Data analytics\SQL\DataWithBara\Project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
         WITH(
            FIRSTROW=2,
            FIELDTERMINATOR=',',
            TABLOCK
            );
        set @end_time= getdate();
        PRINT ('Duration' + cast ( DATEDIFF(second,@start_time, @end_time) as NVARCHAR) +'seconds');
        PRINT('--------------');


  
        SET @start_time = GETDATE();
        PRINT' Truncating Table: bronze.crm_prd_info';
        TRUNCATE TABLE bronze.crm_prd_info;

        PRINT'Inserting Data into:  bronze.crm_prd_info';
        BULK INSERT bronze.crm_prd_info
        FROM 'C:\Data analytics\SQL\DataWithBara\Project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
        WITH
        (
         FIRSTROW = 2,
         FIELDTERMINATOR= ',',
         TABLOCK
         );
         SET @end_time=GETDATE();
         PRINT ('Duration' + cast ( DATEDIFF(Second,@start_time, @end_time) as NVARCHAR) +'seconds')
         PRINT('--------------')

        SET @start_time=GETDATE();

        PRINT' Truncating Table: bronze.crm_sales_details';
        TRUNCATE TABLE bronze.crm_sales_details;

        PRINT'Inserting Data into:  bronze.crm_sales_details';
        BULK INSERT bronze.crm_sales_details
        FROM 'C:\Data analytics\SQL\DataWithBara\Project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
        WITH 
        (
         FIRSTROW=2,
         FIELDTERMINATOR=',',
         TABLOCK
         );
         SET @end_time=GETDATE();

        PRINT ('Duration' + cast ( DATEDIFF(Second,@start_time, @end_time) as NVARCHAR) +'seconds')
        PRINT('--------------')

         PRINT'----------------------------------------------------------------------------------------------';
         PRINT'LOADING CRM files';
         PRINT'----------------------------------------------------------------------------------------------';

        SET @start_time=GETDATE()
        PRINT' Truncating Table: bronze.erp_CUST_AZ12';
        TRUNCATE TABLE bronze.erp_CUST_AZ12;

        PRINT'Inserting Data into:  bronze.erp_CUST_AZ12';
        BULK INSERT bronze.erp_CUST_AZ12
        FROM 'C:\Data analytics\SQL\DataWithBara\Project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
        WITH 
        (
         FIRSTROW=2,
         FIELDTERMINATOR=',',
         TABLOCK
         );
         SET @end_time=GETDATE()
         PRINT ('Duration' + cast ( DATEDIFF(Second,@start_time, @end_time) as NVARCHAR) +'seconds')
         PRINT('--------------')

        SET @start_time=GETDATE();
        PRINT' Truncating Table: bronze.erp_LOC_A101';
        TRUNCATE TABLE bronze.erp_LOC_A101;

        PRINT'Inserting Data into:  bronze.erp_LOC_A101';
        BULK INSERT bronze.erp_LOC_A101
        FROM 'C:\Data analytics\SQL\DataWithBara\Project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
        WITH 
        ( FIRSTROW=2,
          FIELDTERMINATOR =',',
          TABLOCK
          );
        SET @end_time= GETDATE();
        PRINT ('Duration' + cast ( DATEDIFF(Second,@start_time, @end_time) as NVARCHAR) +'seconds')
        PRINT('--------------')

        SET @start_time=GETDATE();
        PRINT' Truncating Table: bronze.erp_PX_CAT_G1V2';
        TRUNCATE TABLE bronze.erp_PX_CAT_G1V2;

        PRINT'Inserting Data into:  bronze.erp_PX_CAT_G1V2';
        BULK INSERT bronze.erp_PX_CAT_G1V2
        FROM 'C:\Data analytics\SQL\DataWithBara\Project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
        WITH 
        ( FIRSTROW=2,
          FIELDTERMINATOR =',',
          TABLOCK
          );
        SET @end_time = getdate();
     
        PRINT ('Duration' + cast ( DATEDIFF(Second,@start_time, @end_time) as NVARCHAR) +'seconds')
        PRINT('--------------');
        
        SET @batch_end_time=getdate();
        PRINT('-------------------------------------');
        PRINT ('Bronze layer Loading completed');
        PRINT (' Loading Duration' + cast ( DATEDIFF(Second,@batch_start_time, @batch_end_time) as NVARCHAR) +'seconds')
        PRINT('--------------------------- ----------');

    END TRY
    BEGIN CATCH 
        PRINT 'ERROR Occured during Loading data into Bronze layer';
        PRINT 'Error Message' + Error_message();
        PRINT 'Error Message' + cast ( Error_Number() as NVARCHAR);
        PRINT 'Error Message' + cast ( Error_STATE() as NVARCHAR);
    END CATCH

end
