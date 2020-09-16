<h1 id='summary'>Summary</h1>

- [LINKS](#links)
- [BASICS](#basics)
  - [Aliases](#aliases)
  - [Extract](#extract)
  - [Having](#having)
  - [Concatenate Results](#concatenate-results)
  - [SUM](#sum)
  - [LIKE vs. ILIKE](#like-vs-ilike)
  - [Case Statements](#case-statements)
  - [Union](#union)
  - [Coalesce](#coalesce)
  - [Window Functions](#window-functions)
    - [Cumulative Sales](#cumulative-sales)
    - [Percentiles](#percentiles)
    - [Group Level Results](#group-level-results)
    - [Subqueries](#subqueries)
    - [Views](#views)
    - [Temporary Tables](#temporary-tables)
- [EXERCISES](#exercises)
  - [Exercise 1](#exercise-1)
  - [Exercise 2](#exercise-2)
  - [Exercise 3](#exercise-3)
  - [Exercise 4](#exercise-4)

# LINKS

-   [SQLWorkbenchJ](https://sql-workbench.eu/)
-   [Java](https://www.java.com/)
-   [PostgreSQL JDBC Driver](https://jdbc.postgresql.org/download.html)

# BASICS

[Go Back to Summary](#summary)

-   **SELECT**: choose the fields for query
-   **FROM**: pick table(s) fro data source
-   **WHERE**: filter data based upon conditions
-   **GROUP BY**: segment data into groups
-   **ORDER BY**: sort results
-   **LIMIT**: limit the number of records returned
-   **JOIN Types**:
    -   INNER vs. OUTER
    -   LEFT vs. RIGHT

## Aliases

[Go Back to Summary](#summary)

-   Rename fields in your queries:

    ```SQL
      SELECT <field> AS <alias>
    ```

    ```SQL
      SELECT milliseconds/1000. AS seconds
    ```

-   Reference tables as abbreviations:

    ```SQL
      FROM <table> <alias>
    ```

    ```SQL
      FROM track t
      JOIN genre g ON t.genreid = g.genreid;
    ```

    ```SQL
      SELECT g.name,
             AVG(t.milliseconds) / 1000. / 60. AS minutes
      FROM track t
        JOIN mediatype m ON t.mediatypeid = m.mediatypeid
        JOIN genre g ON t.genreid = g.genreid
      WHERE m.name LIKE '%audio%'
      GROUP BY g.name
      ORDER BY minutes DESC;
    ```

-   Reference fields by position:

    ```SQL
      SELECT <field1>, <field2>
      FROM <table>
      ORDER BY 1, 2
    ```

    ```SQL
      SELECT name, milliseconds
      FROM track
      ORDER BY 2 DESC
    ```

    ```SQL
      SELECT g.name,
             AVG(t.milliseconds) / 1000. / 60. AS minutes
      FROM track t
        JOIN mediatype m ON t.mediatypeid = m.mediatypeid
        JOIN genre g ON t.genreid = g.genreid
      WHERE m.name LIKE '%audio%'
      GROUP BY g.name
      ORDER BY 2 DESC;
    ```

## Extract

[Go Back to Summary](#summary)

```SQL
  SELECT EXTRACT ( <date_component> FROM <field> )
```

```SQL
  SELECT EXTRACT ( month FROM invoicedate ) AS month
  FROM invoice;
```

-   Date/Time components
    -   Day, Month, Year
    -   Week, Month
    -   Hour, Minute, Second
    -   DOW, DOY, Quarter, Timezone

## Having

[Go Back to Summary](#summary)

```SQL
  SELECT <field1>, <agg function>(<field2>)
  FROM <table>
  GROUP BY <field1>
  HAVING <agg function>(<field2>) <operator> <value>;
```

```SQL
  SELECT genreid, COUNT(trackid)
  FROM track
  GROUP BY genreid
  HAVING COUNT(*) > 50
  ORDER BY genreid ASC;
```

| genreid | count |
| ------- | ----- |
| 1       | 1297  |
| 2       | 130   |
| 3       | 374   |
| 4       | 332   |

```SQL
  SELECT genre.name,
         AVG(track.milliseconds) / 1000. / 60. AS minutes
  FROM track
    JOIN mediatype ON track.mediatypeid = mediatype.mediatypeid
    JOIN genre ON track.genreid = genre.genreid
  WHERE mediatype.name LIKE '%audio%'
  GROUP BY genre.name
  HAVING AVG(track.milliseconds) / 1000. / 60. >= 3
  ORDER BY minutes DESC;
```

## Concatenate Results

-   Just like **&** in Excel, we can use `||` to concatenate results in SQL

    ```SQL
      SELECT e.firstname || ' ' || e.lastname AS "Employee Name",
             boss.firstname || ' ' || boss.lastname AS "Boss"
      FROM employee e
      FULL JOIN employee boss ON e.reportsto = boss.employeeid;
    ```

## SUM

[Go Back to Summary](#summary)

```SQL
  SELECT SUM(milliseconds) / 1000. / 60. / 60. / 24. AS days
  FROM track;
  --  15.958079
```

## LIKE vs. ILIKE

[Go Back to Summary](#summary)

-   `ILIKE` = case insensitive

    ```SQL
      SELECT g.name,
            AVG(t.milliseconds) / 1000. / 60. AS minutes
      FROM track t
        JOIN mediatype m ON t.mediatypeid = m.mediatypeid
        JOIN genre g ON t.genreid = g.genreid
      WHERE m.name LIKE '%audio%'
      GROUP BY g.name
      ORDER BY 2 DESC;
    ```

-   `LIKE` = case sensitive

    ```SQL
      SELECT genre.name,
            AVG(track.milliseconds) / 1000. / 60. AS minutes
      FROM track
        JOIN mediatype ON track.mediatypeid = mediatype.mediatypeid
        JOIN genre ON track.genreid = genre.genreid
      WHERE mediatype.name LIKE '%audio%'
      GROUP BY genre.name
      HAVING AVG(track.milliseconds) / 1000. / 60. >= 3
      ORDER BY minutes DESC;
    ```

## Case Statements

[Go Back to Summary](#summary)

-   Just like a `switch/case` in JavaScript

    ```SQL
      SELECT CASE
        WHEN < condition_1 > THEN < result_1 >
        WHEN < condition_2 > THEN < result_2 >
        ELSE <result_3 >
      END;
    ```

    ```SQL
      SELECT CASE
        WHEN AGE < 18 THEN 'child'
        WHEN AGE >= 60 THEN 'senior'
        ELSE 'adult'
      END AS age_market_segment;
    ```

## Union

[Go Back to Summary](#summary)

-   Merges data from two queries by stacking results on top of each other
-   Must have same number of columns and corresponding data types
-   Duplicate results are removed by default
-   `UNION ALL` will **include duplicates**

    ```SQL
      SELECT *
      FROM< table1 >
      UNION
      SELECT *
      FROM< table2 >;
    ```

## Coalesce

[Go Back to Summary](#summary)

-   Picks first non-null value

    ```SQL
      COALESCE ([field1], [field2], [field3])
    ```

    ```SQL
      COALESCE(online.firstname, catalog.firstname) AS firstname
    ```

## Window Functions

[Go Back to Summary](#summary)

-   **ATTENTION:** Not all SQL supports window function
-   Perform calculation across a set of table rows that are somehow related to the current row + all the previous
-   Applications:
    -   Cumulative sales
    -   Percentile rank
    -   Group level results

### Cumulative Sales

[Go Back to Summary](#summary)

```SQL
  SELECT SUM(< field1 >) OVER (ORDER BY< field2 >)
  FROM< TABLE>;
```

-   Example, In this case the SUM is calculated dynamically

    ```SQL
      SELECT invoicedate,
            SUM(total) OVER (ORDER BY invoicedate)
      FROM invoice;
    ```

### Percentiles

[Go Back to Summary](#summary)

```SQL
  SELECT NTILE(< # OF groups >) OVER (ORDER BY< field >)
  FROM< TABLE>;
```

```SQL
  SELECT name,
         milliseconds,
         NTILE(100) OVER (ORDER BY milliseconds DESC) AS percentile
  FROM track;
```

### Group Level Results

[Go Back to Summary](#summary)

```SQL
  SELECT AVG(< field1 >) OVER (PARTITION BY< field2 >)
  FROM< TABLE>;
```

```SQL
  SELECT name,
         genreid,
         milliseconds,
         AVG(milliseconds) OVER (PARTITION BY genreid)
  FROM track;
```

### Subqueries

[Go Back to Summary](#summary)

```SQL
  WITH < subquery_name > AS (
      < code_for_subquery >
  )
  < code_for_parent_query >;
```

```SQL
  WITH top_customers AS (
    SELECT customerid,
         SUM(total) AS sales
    FROM invoice
    GROUP BY customerid
  )
  SELECT COUNT(*)
  FROM top_customers
  WHERE sales > 40;
```

### Views

[Go Back to Summary](#summary)

-   When we create a view, this "table" will be permanently saved on the database. This way, anyone that has access to this table, will have access to this view
-   **ATTENTION:** You can't have duplicate field names in a view
-   **IMPORTANT:** This table is populated with new data

    ```SQL
      CREATE VIEW <view_name > AS <query_code >; COMMIT;
    ```

    ```SQL
      CREATE VIEW top_customers AS
          SELECT customerid,
                SUM(total) AS sales
          FROM invoice
          GROUP BY customerid
          ORDER BY sales DESC;
    ```

### Temporary Tables

[Go Back to Summary](#summary)

-   This will permanently create a copy of my data, but it's **deleted after you logged out**
-   **ATTENTION:** You can't have duplicate field names in a view
-   **IMPORTANT:** This table is not populated with new data that is coming in, only if we updated the temporary table

    ```SQL
      CREATE TEMP TABLE < view_name > AS < query_code >;
    ```

    ```SQL
      CREATE TEMP TABLE total_sales AS
          SELECT customerid,
                SUM(total) AS sales
          FROM invoice
          GROUP BY customerid
          ORDER BY sales DESC;
    ```

# EXERCISES

[Go Back to Summary](#summary)

## Exercise 1

[Go Back to Summary](#summary)

-   How many days of content are there in the library?

    ```SQL
      SELECT SUM(milliseconds) / 1000. / 60. / 60. / 24. AS days
      FROM track;
      --  15.958079
    ```

-   What are the longest songs (excluding video)?

    ```SQL
      SELECT track.name,
            track.milliseconds / 1000. / 60. AS minutes,
            mediatype.name
      FROM track
        JOIN mediatype ON track.mediatypeid = mediatype.mediatypeid
      WHERE mediatype.name ILIKE '%AUDIO%'
      ORDER BY track.milliseconds DESC LIMIT 100;
    ```

-   What is the average length of a song grouped by genre (convert time to minutes)?

    ```SQL
      SELECT genre.name,
             AVG(track.milliseconds) / 1000. / 60. AS minutes
      FROM track
        JOIN mediatype ON track.mediatypeid = mediatype.mediatypeid
        JOIN genre ON track.genreid = genre.genreid
      WHERE mediatype.name LIKE '%audio%'
      GROUP BY genre.name
      ORDER BY minutes DESC;
    ```

## Exercise 2

[Go Back to Summary](#summary)

-   Which customers have spent more than \$40 (Use Group By and Having for the customer and invoice tables)?

    ```SQL
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
    ```

-   What are the total sales by month (Use Extract and Group By and the invoice table)?

    ```SQL
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
    ```

-   Create a roster of employees with their bosses (Join the employee table to itself by using table aliases)

    ```SQL
      SELECT t1.firstname,
            t1.lastname,
            t2.firstname,
            t2.lastname
      FROM employee t1
        LEFT JOIN employee t2 ON t1.reportsto = t2.employeeid;
    ```

    -   Different solution

    ```SQL
      SELECT e.firstname || ' ' || e.lastname AS "Employee Name",
            boss.firstname || ' ' || boss.lastname AS "Boss"
      FROM employee e
        FULL JOIN employee boss ON e.reportsto = boss.employeeid;
    ```

## Exercise 3

[Go Back to Summary](#summary)

-   Using the iowa liquor products table, create an alcohol type label for whisky, vodka, tequila, rum, brandy, schnapps and any other liquor types (hint: use `CASE STATEMENT` and `LIKE`)

    ```SQL
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
    ```

-   Adding a counter

    ```SQL
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
    ```

-   Using the catalog and online tables, create a customer list that combines the names from the catalog and online tables using UNION without creating duplicates.

```SQL
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
```

-   `FULL JOIN` the catalog and online tables and inspect the results. Try adding the catalog sales and online sales totals together. Why do you get errors?
-   Wrong answer:

    ```SQL
      SELECT *,
            c.catalogpurchases + o.onlinepurchases
      FROM catalog c
        FULL JOIN online o ON c.customerid = o.customerid;
    ```

-   Right answer

    ```SQL
      SELECT *,
            COALESCE(c.catalogpurchases + o.onlinepurchases) AS firstname,
            COALESCE(c.lastname,o.lastname) AS lastname,
            COALESCE(c.catalogpurchases,0) +COALESCE(o.onlinepurchases,0) AS total_sales
      FROM catalog c
        FULL JOIN online o ON c.customerid = o.customerid;
    ```

## Exercise 4

[Go Back to Summary](#summary)

-   How many iowa liquor vendors have more than \$1 million in 2014 sales (hint: use subquery to group sales by vendor)?

```SQL
  WITH vendor_sales AS (
      SELECT vendor,
          vendor_no,
          SUM(total)
      FROM iowa_sales
      WHERE EXTRACT(year FROM DATE) = 2014
      GROUP BY vendor,
              vendor_no
      HAVING SUM(total) > 1000000
  )
  SELECT COUNT(*) FROM vendor_sales;
```

-   Group sales by month with a subquery and then calculate cumulative sales by month for 2014 (using iowa sales table)

    ```SQL
      WITH sale_by_month AS (
          SELECT EXTRACT(YEAR FROM iowa_sales.date) AS YEAR,
                EXTRACT(MONTH FROM iowa_sales.date) AS MONTH,
                SUM(total) AS new_total
          FROM iowa_sales
          GROUP BY YEAR,
                  MONTH
      )
      SELECT SUM(new_total) OVER (ORDER BY month)
      FROM sale_by_month
      WHERE year = 2014;
    ```

-   Alternative

    ```SQL
      WITH monthly_sales AS (
          SELECT EXTRACT(month FROM DATE) AS month,
              SUM(total) AS sales
          FROM iowa_sales
          WHERE EXTRACT(year FROM DATE) = 2014
          GROUP BY month
      )
      SELECT month,
            sales / 1000000. AS month_sales,
            TO_CHAR(sales,'999,999,999'),
            SUM(sales) OVER (ORDER BY month) / 1000000. AS cum_sales
      FROM monthly_sales
      ORDER BY month;
    ```

-   Alternative with monthly sales

    ```SQL
      WITH monthly_sales AS (
          SELECT EXTRACT(month FROM DATE) AS month,
                EXTRACT(year FROM DATE) AS year,
                SUM(total) AS sales
          FROM iowa_sales
          GROUP BY month,
                  year
      )
      SELECT month,
            year,
            sales / 1000000. AS month_sales,
            SUM(sales) OVER (PARTITION BY year ORDER BY month) / 1000000. AS cum_sales
      FROM monthly_sales
      ORDER BY year,
              month;
    ```

-   Create a View that adds liquor type to the iowa product data. Don't forget to commit your changes.

    ```SQL
      IF EXISTS DROP TABLE new_iowa_products;

      CREATE VIEW new_iowa_products AS (
          SELECT CASE
              WHEN i.category_name ILIKE '%whisky%' THEN 'whisky'
              WHEN i.category_name ILIKE '%vodka%' THEN 'vodka'
              WHEN i.category_name ILIKE '%tequila%' THEN 'tequila'
              WHEN i.category_name ILIKE '%rum%' THEN 'rum'
              WHEN i.category_name ILIKE '%brandy%' THEN 'brandy'
              WHEN i.category_name ILIKE '%schnapps%' THEN 'schnapps' ELSE 'other'
            END AS liquor_type,
          * FROM iowa_products AS i
      );

      COMMIT;

      SELECT *
      FROM new_iowa_products;
    ```
