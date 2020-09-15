SELECT *
FROM artist
LIMIT 100;

SELECT *
FROM track
LIMIT 100;

-- How many days of content are there in the library?
-- Adding the . after 1000, this converts the number into a float
SELECT SUM(milliseconds) / 1000. / 60. / 60. / 24. AS days
FROM track;

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

-- ALIAS
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

-- Extract - manipulate date and time components
-- SELECT EXTRACT (<date_component> FROM  <field>) FROM <table>;
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

-- SELECT EXTRACT (<date_component> FROM  <field>) FROM <table>;
SELECT EXTRACT(month FROM invoicedate)
FROM invoice;

-- Exercise 1
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

