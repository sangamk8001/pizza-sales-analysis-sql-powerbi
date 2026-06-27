use SQL_project_1;

DROP TABLE IF EXISTS Retail_Sales
CREATE TABLE Retail_Sales (
	transactions_id int,
	sale_dateb date,
	sale_time time,
	customer_id int,
	gender varchar(10),
	age int,
	category varchar(50),
	quantiy int,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale FLOAT
);


-- create new table for bulk loading
CREATE TABLE Retail_Sales_Staging (
    transactions_id VARCHAR(50),
    sale_dateb VARCHAR(50),
    sale_time VARCHAR(50),
    customer_id VARCHAR(50),
    gender VARCHAR(50),
    age VARCHAR(50),
    category VARCHAR(50),
    quantity VARCHAR(50),
    price_per_unit VARCHAR(50),
    cogs VARCHAR(50),
    total_sale VARCHAR(50)
);

-- bulk loading from csv file
BULK INSERT Retail_Sales_Staging
FROM 'C:\Users\Asus\Downloads\SQL_Retail Sales Analysis.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);

-- insert data into original table 
INSERT INTO Retail_Sales
SELECT 
    CAST(transactions_id AS INT),
    TRY_CONVERT(DATE, sale_dateb, 101),  -- handles MM/DD/YYYY
    TRY_CONVERT(TIME, sale_time),
    CAST(customer_id AS INT),
    gender,
    CAST(age AS INT),
    category,
    CAST(quantity AS INT),
    CAST(price_per_unit AS FLOAT),
    CAST(cogs AS FLOAT),
    CAST(total_sale AS FLOAT)
FROM Retail_Sales_Staging;

--  Rename the column name
EXEC sp_rename 'Retail_Sales.sale_dateb', 'sale_date', 'COLUMN';
EXEC sp_rename 'Retail_Sales.quantiy', 'quantity', 'COLUMN';

-- Count how many bad rows exist
SELECT * FROM Retail_Sales
where 
transactions_id is null or
    sale_date is null or
    sale_time is null or
    customer_id is null or
    gender is null or
    age is null or
    category is null or
    quantity is null or
    price_per_unit is null or
    cogs is null or
    total_sale is null;



