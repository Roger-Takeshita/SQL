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
-- ILIKE = case insensitve
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

