-- create database
CREATE DATABASE Store;

-- select database
use Store;

select * from superstore s ;

-- Date time format
		-- Add column with correct date format
		ALTER TABLE superstore
		ADD COLUMN new_Order_Date DATE,
		ADD COLUMN new_Shipping_Date DATE;
		
		-- Update data for new column
		UPDATE superstore
		SET new_Order_Date = STR_TO_DATE(`Order Date`, '%m/%d/%Y'),
		    new_Shipping_Date = STR_TO_DATE(`Ship Date`, '%m/%d/%Y');
		
		-- Delete old Order Date and Ship Date
		ALTER TABLE superstore
		DROP COLUMN `Order Date`,
		DROP COLUMN `Ship Date`;
		
		-- Rename the new column 
		ALTER TABLE superstore
		CHANGE COLUMN new_Order_Date `Order Date` DATE,
		CHANGE COLUMN new_Shipping_Date `Ship Date` DATE;

-- Create customer information table 
DROP TABLE IF EXISTS customer;


create table customer as 
	(
	select 
		MAX(`Customer ID`) as Customer_ID,
		`Customer Name`,
		`Segment`
	from superstore
	group by `Customer ID`
	);

select * from customer;


-- create Product information table 
DROP TABLE IF EXISTS product;

create table product as
	(
	select 
			MAX(`Product ID`) as `Product ID`,
			`Category`,
			`Sub-Category`,
			`Product Name`
	from superstore
	group by `Product ID`
	);


select * from product;
	


-- create orders_shipping inforamtion table
DROP TABLE IF EXISTS orders_shipping;


create table orders_shipping as
	(
	SELECT 
	    `Order ID` AS `Order ID`,
	    `Customer ID`,
	    `Order Date`,
	    `Ship Date`,
	    `Ship Mode`,
	    `Order Priority`,
	    CASE 
	        WHEN Market <> Region THEN CONCAT(Region, ' ', Market)
	        ELSE Market
	    END AS Market,
	    Country,
	    State,
	    `City`,
	    sum(`Shipping Cost`) as Total_Shipping_Cost
	FROM superstore
	GROUP BY `Order ID`
	);

select * from orders_shipping;


-- create orders information table
DROP TABLE IF EXISTS orders;


create table orders as
	(
	select
		`Order ID`,
		`Customer ID`,
		`Product ID`,
		`Order Date`,
		Sales,
		Quantity,
		Discount,
		Profit,
		`Shipping Cost`
	from superstore s
	);

select * from orders;


-- create RFM information table
DROP TABLE IF EXISTS RFM;

create table RFM as
	(
	SELECT 
	    `Customer ID`,
	    DATEDIFF(NOW(), MAX(`Order Date`)) AS Recency,
	    COUNT(`Customer ID`) AS Frequency,
	    SUM(Sales) AS Monetary
	FROM superstore
	GROUP BY `Customer ID`
	);

select * from RFM;





