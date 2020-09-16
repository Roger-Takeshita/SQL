-- Review Exercises
-- How many hours of content are there in the library?
SELECT SUM(milliseconds) / 1000.0 / 60.0 / 60.0 AS hours
FROM track;

-- What are the longest songs (excluding video)?
SELECT track.name,
       track.milliseconds / 1000.0 / 60.0 AS minutes
FROM track
  JOIN mediatype ON track.mediatypeid = mediatype.mediatypeid
WHERE mediatype.name ILIKE '%audio%'
ORDER BY track.milliseconds DESC LIMIT 10;

-- What is the average length of a song by genre in minutes?
SELECT genre.name,
       AVG(track.milliseconds) / 1000.0 / 60.0 AS minutes
FROM track
  JOIN mediatype ON track.mediatypeid = mediatype.mediatypeid
  JOIN genre ON track.genreid = genre.genreid
WHERE mediatype.name LIKE '%audio%'
GROUP BY genre.name
ORDER BY minutes DESC LIMIT 100;

-- Exercise #1
-- Which customers have spent more than $40 (Use Group By and Having)?
SELECT c.firstname,
       c.lastname,
       c.customerid,
       SUM(i.total) AS total_sales
FROM invoice i
  JOIN customer c ON i.customerid = c.customerid
GROUP BY c.customerid,
         c.firstname,
         c.lastname
HAVING SUM(i.total) > 40
ORDER BY total_sales DESC;



-- What are the total sales by month (Use Extract and Group By)?
SELECT EXTRACT(year FROM invoicedate) AS year,
       EXTRACT(month FROM invoicedate) AS month,
       SUM(total) AS monthly_sales
FROM invoice
GROUP BY year,
         month
ORDER BY year,
         month;

-- Double pipe symbol concatenates strings together
SELECT EXTRACT(year FROM invoicedate) || '-' ||EXTRACT(month FROM invoicedate) AS year_month,
       SUM(total) AS monthly_sales
FROM invoice
GROUP BY year_month
ORDER BY year_month;

-- To_Char function converts dates into text (allows zero padding of months)
SELECT TO_CHAR(invoicedate,'YYYY-MM') AS year_month,
       TO_CHAR(invoicedate,'Mon-YY') AS month_text,
       TRIM(TO_CHAR(invoicedate, 'Month'))||TO_CHAR(invoicedate,'-YYYY') AS month_year,
       SUM(total) AS monthly_sales,
       EXTRACT(year FROM invoicedate) AS year,
       EXTRACT(month FROM invoicedate) AS month,
       TO_CHAR(invoicedate, 'Month')||TO_CHAR(invoicedate,'-YYYY') AS month_year2
FROM invoice
GROUP BY year_month,
         month_text,
         month_year,
         5,
         6,
         7
ORDER BY year_month;

SELECT EXTRACT(DOW FROM invoicedate),
       TO_CHAR(invoicedate,'D'),
       TO_CHAR(invoicedate,'Day'),
       LEFT(TO_CHAR(invoicedate,'Day'),3),
       invoicedate
FROM invoice
LIMIT 10;




-- Create a roster of employees with their bosses 
-- (Join Employees to Itself by Using Table Aliases)
SELECT e.firstname|| ' ' ||e.lastname AS "Employee Name",
       boss.firstname|| ' ' ||boss.lastname AS "Boss"
FROM employee e
LEFT JOIN employee boss ON e.reportsto = boss.employeeid;


-- Exercise #2
-- Create a case statement to group categories by liquor type
SELECT DISTINCT category_name,
       CASE
         WHEN category_name ILIKE '%whisk%' OR category_name ILIKE '%scotch%' THEN 'whiskey'
         WHEN category_name ILIKE '%vodka%' THEN 'vodka'
         WHEN category_name ILIKE '%tequila%' THEN 'tequila'
         WHEN category_name ILIKE '%rum%' THEN 'rum'
         WHEN category_name ILIKE '%schnapps%' THEN 'schnapps'
         WHEN category_name ILIKE '%brand%' THEN 'brandy'
         WHEN category_name ILIKE '%gin%' THEN 'gin'
         ELSE 'other'
       END AS liquor_type
FROM iowa_products
ORDER BY liquor_type;

SELECT *,
       CASE
         WHEN category_name ILIKE '%whisk%' OR category_name ILIKE '%scotch%' THEN 'whiskey'
         WHEN category_name ILIKE '%vodka%' THEN 'vodka'
         WHEN category_name ILIKE '%tequila%' THEN 'tequila'
         WHEN category_name ILIKE '%rum%' THEN 'rum'
         WHEN category_name ILIKE '%schnapps%' THEN 'schnapps'
         WHEN category_name ILIKE '%brand%' THEN 'brandy'
         WHEN category_name ILIKE '%gin%' THEN 'gin'
         ELSE 'other'
       END AS liquor_type
FROM iowa_products
ORDER BY liquor_type;


-- Reorder the case statement logic to assign butterscotch schnapps correctly
SELECT category_name,
       CASE
         WHEN category_name ILIKE '%schnapps%' THEN 'schnapps'
         WHEN category_name ILIKE '%whisk%' OR category_name ILIKE '%scotch%' THEN 'whiskey'
         WHEN category_name ILIKE '%vodka%' THEN 'vodka'
         WHEN category_name ILIKE '%tequila%' THEN 'tequila'
         WHEN category_name ILIKE '%rum%' THEN 'rum'
         WHEN category_name ILIKE '%brand%' THEN 'brandy'
         WHEN category_name ILIKE '%gin%' THEN 'gin'
         ELSE 'other'
       END AS liquor_type, COUNT(*)
FROM iowa_products
GROUP BY liquor_type, category_name
ORDER BY liquor_type, category_name;

-- Create a customer list that combines the names from the catalog 
-- and online tables using UNION without creating duplicates.
SELECT customerid,
			 firstname AS "First Name",
       lastname AS "Last Name"
FROM catalog
UNION 
SELECT customerid,
			 firstname,
       lastname
FROM online
ORDER BY "First Name","Last Name";

-- FULL JOIN the catalog and online tables and try adding online and catalog purchases
SELECT *,
       c.catalogpurchases + o.onlinepurchases
FROM catalog c
  FULL JOIN online o ON c.customerid = o.customerid;

-- Replace NULL values with zero and then add the catalog and online sales.
SELECT *,COALESCE(c.firstname,o.firstname) AS firstname,
			 COALESCE(c.lastname,o.lastname) AS lastname,
       COALESCE(c.catalogpurchases,0) + COALESCE(o.onlinepurchases,0) AS total_sales
FROM catalog c
  FULL JOIN online o ON c.customerid = o.customerid;

-- Exercise #3
-- How many Iowa liquor vendors have more than $1MM in sales in 2014 (Using a subquery)?
WITH vendor_sales AS
			(SELECT vendor,vendor_no, SUM(total)
			FROM iowa_sales
			WHERE EXTRACT(year FROM date)=2014
			GROUP BY vendor,vendor_no
			HAVING SUM(total) > 1000000) 
SELECT COUNT(*) 
FROM vendor_sales;


WITH vendor_sales AS
(
  SELECT vendor_no,
         SUM(total) AS total_sales
  FROM iowa_sales
  WHERE EXTRACT(YEAR FROM DATE) = 2014
  GROUP BY vendor_no
)
SELECT COUNT(*)
FROM vendor_sales
WHERE total_sales > 1000000;



-- Subquery inserted inside parent query
SELECT COUNT(*) 
FROM (SELECT vendor_no, SUM(total) as sales
	    FROM iowa_sales
	    WHERE EXTRACT(year FROM date)=2014
	    GROUP BY vendor_no) sales_by_vendor
WHERE sales > 1000000;


-- Calculate cumulative sales by month for 2014

WITH monthly_sales AS (
	SELECT EXTRACT(month from date) as month, SUM(total) as sales
	FROM iowa_sales
	WHERE EXTRACT(year from date) = 2014
	GROUP BY month
)
SELECT month, sales/1000000. as month_sales, TO_CHAR(sales, '999,999,999'), 
       SUM(sales) OVER (ORDER BY month)/1000000. as cum_sales
FROM monthly_sales
ORDER BY month;


WITH monthly_sales AS (
	SELECT EXTRACT(month from date) as month, EXTRACT(year from date) as year, SUM(total) as sales
	FROM iowa_sales
	GROUP BY month, year
)
SELECT month, year, sales/1000000. as month_sales, 
       SUM(sales) OVER (PARTITION BY year ORDER BY month)/1000000. as cum_sales
FROM monthly_sales
ORDER BY year, month;


-- Create a view with liquor type
DROP VIEW IF EXISTS iowa_product_with_type;
CREATE VIEW iowa_product_with_type AS
SELECT *,
       CASE
         WHEN category_name ILIKE '%schnapps%' THEN 'schnapps'
         WHEN category_name ILIKE '%whisk%' OR category_name ILIKE '%scotch%' THEN 'whiskey'
         WHEN category_name ILIKE '%vodka%' THEN 'vodka'
         WHEN category_name ILIKE '%tequila%' THEN 'tequila'
         WHEN category_name ILIKE '%rum%' THEN 'rum'
         WHEN category_name ILIKE '%brand%' THEN 'brandy'
         WHEN category_name ILIKE '%gin%' THEN 'gin'
         ELSE 'other'
       END AS liquor_type
FROM iowa_products;
COMMIT;

SELECT * 
FROM iowa_product_with_type 
WHERE liquor_type='whiskey';

--  Create table for uploading yelp data
-- DROP TABLE IF EXISTS yelp;
-- CREATE TABLE yelp 
-- (
--   business_id   VARCHAR(255),
--   review_date     TIMESTAMP,
--   review_id       VARCHAR(255),
--   stars           VARCHAR(5),
--   review_text     VARCHAR(10000),
--   review_type			Varchar(255),
--   user_id					varchar(255),
--   cool            INT,
--   funny           INT,
--   useful          INT
-- );
-- COMMIT;

-- Upload yelp data from csv
-- WbImport 
-- -file='/Users/Craig_Sakuma/Desktop/Advanced_SQL/yelp.csv'
-- -type=text
-- -table=public.yelp
-- -delimiter=|
-- -timestampFormat='yyyy-MM-dd'
-- -filecolumns=business_id,review_date,review_id,stars,review_text,review_type,
-- user_id,cool,funny,useful
-- -batchsize=1000;
-- COMMIT;



