SELECT *
FROM artist
LIMIT 100;

SELECT *
FROM track
LIMIT 100;

-----------------------------------------------------------
--                       SUM Float                       --
-----------------------------------------------------------
-- How many days of content are there in the library?
-- Adding the . after 1000, this converts the number into a float
SELECT SUM(milliseconds) / 1000. / 60. / 60. / 24. AS days
FROM track;

-----------------------------------------------------------
--                      LINKE / ILIKE                    --
-----------------------------------------------------------
-- What are the longest songs (excluding video)?
-- ILIKE = case insensitive
-- LIKE = case sensitive
SELECT track.name,
       track.milliseconds / 1000. / 60. AS minutes,
       mediatype.name
FROM track
  JOIN mediatype ON track.mediatypeid = mediatype.mediatypeid
WHERE mediatype.name ILIKE '%AUDIO%'
ORDER BY track.milliseconds DESC LIMIT 100;

-- What is the average length of a song grouped by genre (convert time to minutes)?
SELECT genre.name,
       AVG(track.milliseconds) / 1000. / 60. AS minutes
FROM track
  JOIN mediatype ON track.mediatypeid = mediatype.mediatypeid
  JOIN genre ON track.genreid = genre.genreid
WHERE mediatype.name LIKE '%audio%'
GROUP BY genre.name
ORDER BY minutes DESC;

-----------------------------------------------------------
--                         ALIAS                         --
-----------------------------------------------------------
SELECT g.name,
       AVG(t.milliseconds) / 1000. / 60. AS minutes
FROM track t
  JOIN mediatype m ON t.mediatypeid = m.mediatypeid
  JOIN genre g ON t.genreid = g.genreid
WHERE m.name LIKE '%audio%'
GROUP BY g.name
ORDER BY minutes DESC;

-- ORDER BY, pointers to the fields
SELECT g.name,
       AVG(t.milliseconds) / 1000. / 60. AS minutes
FROM track t
  JOIN mediatype m ON t.mediatypeid = m.mediatypeid
  JOIN genre g ON t.genreid = g.genreid
WHERE m.name LIKE '%audio%'
GROUP BY g.name
ORDER BY 2 DESC;

-----------------------------------------------------------
--                       EXTRACT                         --
-----------------------------------------------------------
-- Extract - manipulate date and time components
--
--
-- SELECT EXTRACT(< date_component > FROM< field >)
-- FROM< TABLE>;
SELECT EXTRACT(month FROM invoicedate)
FROM invoice;

-- Having - Filter data (like WHERE) entire groups
-- SELECT <field1>, <agg function>(<field2>)
-- FROM <table>
-- GROUP BY <field1>
-- HAVING <agg function>(<field2>) <operator> <value>;
-- SELECT genreid, 
-- COUNT(trackid)
-- FROM trackGROUP BY genreidHAVING 
-- COUNT(*) > 50;
SELECT genre.name,
       AVG(track.milliseconds) / 1000. / 60. AS minutes
FROM track
  JOIN mediatype ON track.mediatypeid = mediatype.mediatypeid
  JOIN genre ON track.genreid = genre.genreid
WHERE mediatype.name LIKE '%audio%'
GROUP BY genre.name
HAVING AVG(track.milliseconds) / 1000. / 60. >= 3
ORDER BY minutes DESC;

-----------------------------------------------------------
--                     EXERCISE 1                        --
-----------------------------------------------------------
-- Which customers have spent more than $40 (Use Group By and Having for the customer and invoice tables)?
SELECT customer.firstname,
       customer.lastname,
       invoice.customerid,
       SUM(invoice.total)
FROM customer
  JOIN invoice ON invoice.customerid = customer.customerid
GROUP BY customer.firstname,
         customer.lastname,
         invoice.customerid
HAVING SUM(invoice.total) > 40;

-- What are the total sales by month (Use Extract and Group By and the invoice table)?
SELECT EXTRACT(month FROM invoicedate) AS month,
       SUM(invoice.total) AS total
FROM invoice
GROUP BY month
ORDER BY total DESC;

SELECT EXTRACT(month FROM invoicedate) AS month,
       SUM(invoice.total)
FROM invoice
GROUP BY month
ORDER BY SUM(invoice.total) DESC;

-- Create a roster of employees with their bosses (Join the employee table to itself by using table aliases)
SELECT t1.firstname,
       t1.lastname,
       t2.firstname,
       t2.lastname
FROM employee t1
  LEFT JOIN employee t2 ON t1.reportsto = t2.employeeid;

-- Different Solution
SELECT e.firstname || ' ' || e.lastname AS "Employee Name",
       boss.firstname || ' ' || boss.lastname AS "Boss"
FROM employee e
  FULL JOIN employee boss ON e.reportsto = boss.employeeid;

-----------------------------------------------------------
--                    CASE STATEMENTS                    --
-----------------------------------------------------------
-- Just like a switch/case
--
--
-- SELECT CASE
--          WHEN < condition1 > THEN < result1 >
--          WHEN < condition 2 > THEN <result 2 >
--          ELSE <result 3 >
--        END;
-----------------------------------------------------------
--                        UNION                          --
-----------------------------------------------------------
-- Merges data from two queries by stacking results on top of each other
-- Must have same number of columns and corresponding data types
-- Duplicate results are removed by default
-- UNION ALL will include duplicates
--
--
-- SELECT *
-- FROM< table1 >
-- UNION
-- SELECT *
-- FROM< table2 >;
-----------------------------------------------------------
--                      COALESCE                         --
-----------------------------------------------------------
-- Picks first non-null value
--
--
-- COALESCE(online.firstname, catalog.firstname) AS firstname
-----------------------------------------------------------
--                     EXERCISE 2                        --
-----------------------------------------------------------
-- Using the iowa liquor products table, create an alcohol type label for whisky, vodka, tequila, rum, brandy, schnapps and any other liquor types (hint: use CASE STATEMENT and LIKE)
-- SELECT CASE
--          WHEN < condition1 > THEN < result1 >
--          WHEN < condition 2 > THEN <result 2 >
--          ELSE <result 3 >
--        END;
SELECT DISTINCT category_name,
       CASE
         WHEN category_name ILIKE '%schnapps%' THEN 'schnapps'
         WHEN category_name ILIKE '%wisk%' OR category_name ILIKE '%scotch%' THEN 'whiskey'
         WHEN category_name ILIKE '%vodka%' THEN 'vodka'
         WHEN category_name ILIKE '%rum%' THEN 'rum'
         WHEN category_name ILIKE '%brand%' THEN 'brandy'
         WHEN category_name ILIKE '%gin%' THEN 'gin'
         ELSE 'Other'
       END AS liquor_type
FROM iowa_products
ORDER BY liquor_type;

SELECT category_name,
       CASE
         WHEN category_name ILIKE '%schnapps%' THEN 'schnapps'
         WHEN category_name ILIKE '%wisk%' OR category_name ILIKE '%scotch%' THEN 'whiskey'
         WHEN category_name ILIKE '%vodka%' THEN 'vodka'
         WHEN category_name ILIKE '%rum%' THEN 'rum'
         WHEN category_name ILIKE '%brand%' THEN 'brandy'
         WHEN category_name ILIKE '%gin%' THEN 'gin'
         ELSE 'Other'
       END AS liquor_type,
       COUNT(*)
FROM iowa_products
GROUP BY liquor_type,
         category_name
ORDER BY liquor_type,
         category_name;

-- Using the catalog and online tables, create a customer list that combines the names from the catalog and online tables using UNION without creating duplicates.
--
--
SELECT customerid,
       firstname AS "First Name",
       lastname AS "Last Name"
FROM catalog
UNION
SELECT customerid,
       firstname,
       lastname
FROM online
ORDER BY "First Name",
         "Last Name";

-- FULL JOIN the catalog and online tables and inspect the results.  Try adding the catalog sales and online sales totals together.  Why do you get errors?
--
--
-- WRONG ANSWER
SELECT *,
       c.catalogpurchases + o.onlinepurchases
FROM catalog c
  FULL JOIN online o ON c.customerid = o.customerid;

-- RIGHT ANSWER
SELECT *,
       COALESCE(c.catalogpurchases + o.onlinepurchases) AS firstname,
       COALESCE(c.lastname,o.lastname) AS lastname,
       COALESCE(c.catalogpurchases,0) +COALESCE(o.onlinepurchases,0) AS total_sales
FROM catalog c
  FULL JOIN online o ON c.customerid = o.customerid;

-----------------------------------------------------------
--                    WINDOW FUNCTIONS                   --
-----------------------------------------------------------
-- ATTENTION: Not all SQL supports window function
-- Perform  calculation across a set of table rows that are somehow related to the current row + all the previous
-- Applications:
--   - Cumulative sales
--   - Percentile rank
--   - Group level results
--
--
-----------------------------------------------------------
--                           OVER                        --
-----------------------------------------------------------
-- SELECT SUM(< field1 >) OVER (ORDER BY< field2 >)
-- FROM< TABLE>;
--
--
-- Example, In this case the SUM is calculated dynamically
SELECT invoicedate,
       SUM(total) OVER (ORDER BY invoicedate)
FROM invoice;

-----------------------------------------------------------
--                      PERCENTILES                      --
-----------------------------------------------------------
SELECT NTILE(< # OF groups >) OVER (ORDER BY< field >)
FROM< TABLE>;

SELECT name,
       milliseconds,
       NTILE(100) OVER (ORDER BY milliseconds DESC) AS percentile
FROM track;

-----------------------------------------------------------
--                   GROUP LEVEL RESULTS                 --
-----------------------------------------------------------
-- SELECT AVG(< field1 >) OVER (PARTITION BY< field2 >)
-- FROM< TABLE>;
SELECT name,
       genreid,
       milliseconds,
       AVG(milliseconds) OVER (PARTITION BY genreid)
FROM track;

-----------------------------------------------------------
--                       SUBQUERIES                      --
-----------------------------------------------------------
WITH< subquery_name >
AS
(< code_for_subquery >) < code_for_parent_query >;

WITH top_customers AS
(
  SELECT customerid,
         SUM(total) AS sales
  FROM invoice
  GROUP BY customerid
)
SELECT COUNT(*)
FROM top_customers
WHERE sales > 40;

-----------------------------------------------------------
--                          VIEWS                        --
-----------------------------------------------------------
-- CREATE VIEW <view_name > AS <query_code >; COMMIT;
-- When we create a view, this "table" will be permanently saved on the database. This way, anyone that has access to this table, will have access to this view
-- ATTENTION: You can't have duplicate field names in a view
-- IMPORTANT: This table is populated with new data that is coming in
--
--
-- CREATE VIEW top_customers 
-- AS
-- SELECT customerid,
--        SUM(total) AS sales
-- FROM invoice
-- GROUP BY customerid
-- ORDER BY sales DESC;
-----------------------------------------------------------
--                      TEMPORAY TABLE                   --
-----------------------------------------------------------
-- This will permanetly create a copy of my data, but it's deleted after you logged out
-- CREATE TEMP TABLE < table_name > AS < query_code >;
-- ATTENTION: You can't have duplicate field names in a view
-- IMPORTANT: This table is not populated with new data that is coming in, only if we updated the temporary table
--
--
CREATE TEMP TABLE total_sales 
AS
SELECT customerid,
       SUM(total) AS sales
FROM invoice
GROUP BY customerid
ORDER BY sales DESC;

-----------------------------------------------------------
--                     EXERCISE 3                        --
-----------------------------------------------------------
-- How many iowa liquor vendors have more than $1 million in 2014 sales (hint: use subquery to group sales by vendor)?
WITH vendor_sales
AS
(SELECT vendor,
       vendor_no,
       SUM(total)
FROM iowa_sales
WHERE EXTRACT(year FROM DATE) = 2014
GROUP BY vendor,
         vendor_no
HAVING SUM(total) > 1000000) SELECT COUNT(*) FROM vendor_sales;

-- Group sales by month with a subquery and then calculate cumulative sales by month for 2014 (using iowa sales table)
-- WITH < subquery_name > AS (< code_for_subquery >) 
-- < code_for_parent_query >;
-- My Answer
WITH sale_by_month
AS
(SELECT EXTRACT(YEAR FROM iowa_sales.date) AS YEAR,
       EXTRACT(MONTH FROM iowa_sales.date) AS MONTH,
       SUM(total) AS new_total
FROM iowa_sales
GROUP BY YEAR,
         MONTH)
SELECT SUM(new_total) OVER (ORDER BY month)
FROM sale_by_month
WHERE year = 2014;

-- Professor Answer
WITH monthly_sales
AS
(SELECT EXTRACT(month FROM DATE) AS month,
       SUM(total) AS sales
FROM iowa_sales
WHERE EXTRACT(year FROM DATE) = 2014
GROUP BY month)
SELECT month,
       sales / 1000000. AS month_sales,
       TO_CHAR(sales,'999,999,999'),
       SUM(sales) OVER (ORDER BY month) / 1000000. AS cum_sales
FROM monthly_sales
ORDER BY month;

-- ------------------------------------------------------------
WITH monthly_sales
AS
(SELECT EXTRACT(month FROM DATE) AS month,
       EXTRACT(year FROM DATE) AS year,
       SUM(total) AS sales
FROM iowa_sales
GROUP BY month,
         year)
SELECT month,
       year,
       sales / 1000000. AS month_sales,
       SUM(sales) OVER (PARTITION BY year ORDER BY month) / 1000000. AS cum_sales
FROM monthly_sales
ORDER BY year,
         month;

-- Create a View that adds liquor type to the iowa product data.  Don't forget to commit your changes.
IF EXISTS DROP TABLE new_iowa_products;

CREATE VIEW new_iowa_products 
AS

(
  SELECT CASE WHEN i.category_name ILIKE '%whisky%' THEN 'whisky' WHEN i.category_name ILIKE '%vodka%' THEN 'vodka' WHEN i.category_name ILIKE '%tequila%' THEN 'tequila' WHEN i.category_name ILIKE '%rum%' THEN 'rum' WHEN i.category_name ILIKE '%brandy%' THEN 'brandy' WHEN i.category_name ILIKE '%schnapps%' THEN 'schnapps' ELSE 'other' END AS liquor_type,
  * FROM iowa_products AS i
);

COMMIT;

SELECT *
FROM new_iowa_products;

