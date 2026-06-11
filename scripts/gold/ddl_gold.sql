/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse. 
    The Gold layer represents the final dimension and fact tables (Star Schema)

    Each view performs transformations and combines data from the Silver layer 
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
===============================================================================
*/

-- =============================================================================
-- Create Dimension: gold.dim_customers
-- =============================================================================

IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
    DROP VIEW gold.dim_customers;
GO

CREATE VIEW gold.dim_customers AS

SELECT 
	row_number() over(order by cst_id) AS customer_key
	,ci.cst_id AS customer_id
	,ci.cst_key AS customer_number
	,ci.cst_firstname AS first_name
	,ci.cst_lastname AS last_name
	,cl.cntry  AS country
	,ci.cst_marital_status AS marital_status
	,CASE 
		WHEN ci.cst_gndr ='n/a' or ci.cst_gndr is null THEN isnull(cdi.gen,'n/a') 
		ELSE ci.cst_gndr
     END AS gender ---crm table is the master for gender information
	,cdi.bdate AS birthdate
	,ci.cst_create_date AS create_date
	
FROM silver.crm_cust_info AS ci
LEFT JOIN silver.erp_CUST_AZ12 cdi
	ON ci.cst_key = cdi.cid
LEFT JOIN silver.erp_LOC_A101 cl
	ON ci.cst_key = cl.cid


GO

-- =============================================================================
-- Create Dimension: gold.dim_products
-- =============================================================================
IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
    DROP VIEW gold.dim_products;
GO

CREATE VIEW gold.dim_products AS

SELECT 
	ROW_NUMBER() OVER(order by prd_start_dt,prd_key ) AS product_key
   ,pi.prd_id AS product_id
   ,pi.prd_key AS product_number
   ,pi.prd_nm AS product_name
   ,pi.cat_id AS category_id
   ,pc.cat AS category
   ,pc.subcat AS subcategory
   ,pc.maintenance
   ,pi.prd_cost AS product_cost
   ,pi.prd_line AS product_line
   ,pi.prd_start_dt AS start_date
   
   
FROM silver.crm_prd_info AS pi
LEFT JOIN silver.erp_px_cat_g1v2 AS pc
	ON pi.cat_id = pc.id
WHERE prd_end_dt IS NULL --- Filter Out all historical data

GO
-- =============================================================================
-- Create Fact Table: gold.fact_sales
-- =============================================================================
IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
    DROP VIEW gold.fact_sales;
GO
CREATE VIEW gold.fact_sales AS

SELECT  
	 sa.sls_ord_num AS order_number
	,pr.product_key
	,cr.customer_key
	,sa.sls_order_dt AS order_date
	,sa.sls_ship_dt AS shipping_date
	,sa.sls_due_dt AS due_date
	,sa.sls_sales AS sales_amount
	,sa.sls_quantity AS quantity
	,sa.sls_price AS price
FROM silver.crm_sales_details sa
LEFT JOIN gold.dim_products pr
	ON pr.product_number = sa.sls_prd_key
LEFT JOIN gold.dim_customers cr
	ON cr.customer_id = sa.sls_cust_id

GO





