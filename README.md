<h1 id='summary'>Summary</h1>

- [LINKS](#links)
- [RELATIONAL DATABASE AND SQL](#relational-database-and-sql)
  - [Anatomy of a Relational Database](#anatomy-of-a-relational-database)
    - [Tables](#tables)
    - [Columns](#columns)
  - [Creating Database and a Table](#creating-database-and-a-table)
  - [Creating a Table for a Related Data Entry](#creating-a-table-for-a-related-data-entry)
- [PostgreSQL Commands](#postgresql-commands)
  - [Terminal](#terminal)
  - [Managing Databases](#managing-databases)
    - [Create a Database](#create-a-database)
    - [Delete a Database](#delete-a-database)
  - [Managing Tables](#managing-tables)
    - [Add a New Column to a Table](#add-a-new-column-to-a-table)
    - [Delete a Column from a Table](#delete-a-column-from-a-table)
    - [Rename a Column](#rename-a-column)
    - [Rename a Table](#rename-a-table)
  - [Managing Indexes](#managing-indexes)
    - [Removing a Specified Index from a Table](#removing-a-specified-index-from-a-table)
  - [Querying Data from Tables](#querying-data-from-tables)
    - [Query All Data from a Table](#query-all-data-from-a-table)
    - [Query Data from Specified Columns](#query-data-from-specified-columns)
    - [Query Data Using a Filter - WHERE Operator](#query-data-using-a-filter---where-operator)
    - [Query Data - LIKE Operator](#query-data---like-operator)
    - [Query Data - IN Operator](#query-data---in-operator)
    - [Query Data - Constrain the Returned Rows - LIMIT Operator](#query-data---constrain-the-returned-rows---limit-operator)
    - [Query Data - JOIN](#query-data---join)
    - [Return the Number of Rows of a Table](#return-the-number-of-rows-of-a-table)
    - [Sort Rows in Ascending or Descending Order - ORDER BY](#sort-rows-in-ascending-or-descending-order---order-by)
    - [Filter Groups - HAVING Clause](#filter-groups---having-clause)
  - [Set Operations](#set-operations)
    - [Combine the Result - Two or More Queries - UNION Operator](#combine-the-result---two-or-more-queries---union-operator)
    - [Minus a Result - EXCEPT Operator](#minus-a-result---except-operator)
    - [Get Intersection of the Result Sets of Two Queries](#get-intersection-of-the-result-sets-of-two-queries)
  - [Modifying Data](#modifying-data)
    - [Insert a New Row Into a Table](#insert-a-new-row-into-a-table)
    - [Insert Multiple Rows Into a Table](#insert-multiple-rows-into-a-table)
    - [Update Data for All Rows](#update-data-for-all-rows)
    - [Update Data from a Set of Rows Specified by a Condition - WHERE clause](#update-data-from-a-set-of-rows-specified-by-a-condition---where-clause)
    - [Delete All Rows of a Table](#delete-all-rows-of-a-table)
    - [Delete a Specific Row Based on a Condition](#delete-a-specific-row-based-on-a-condition)
- [ADVANCED](#advanced)
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

# RELATIONAL DATABASE AND SQL

## Anatomy of a Relational Database

[Go Back to Summary](#summary)

-   The structure of a a particular database is known as its **schema**.
-   Schemas include the definition of such things as the database's:
    -   Tables, including the number and data type of each column
    -   Indexes for efficient access of data.
    -   Constrains (rules, such as whether a field can e null or not)

### Tables

[Go Back to Summary](#summary)

-   Database tables look like a spreadsheet since they consist of columns and rows.
-   Tables are also known as **relations**.
-   A single table in a relational database holds data for a particular data entry.
-   Since only one type of data can be held in a single table, related data, we will have different tables storing different contents and tye are **linked** via what is known as a **foreign key (FK)**.

-   **Foreign key** fields hold the value of its parent's **primary key (PK)**.
-   The naming convention is typically snake_cased and always plural.

### Columns

[Go Back to Summary](#summary)

-   The columns of a table have a:
    -   Name
    -   Data type
    -   Optional contrains
-   The typical naming convention is usually snake_cased and singular.

-   PostgreSQL has [many data types](https://www.postgresql.org/docs/11/datatype.html) for columns, but common ones include:

    -   Integer
    -   Decimal
    -   Varchar (variable-length strings)
    -   Text (unlimited length strings)
    -   Date (**does not** include time)
    -   Timestamps (both date and time)
    -   Boolean

-   Common constrains for a column include:
    -   `PRIMARY KEY`: column, or group of columns, uniquely identify a row.
    -   `REFERENCES` (Foreign Key): value in column must match the primary key in another table.
    -   `NOT NULL`: column must have a value, it cannot be empty (null).
    -   `UNIQUE`: data in this column must be unique among all rous in the table.

## Creating Database and a Table

[Go Back to Summary](#summary)

-   On terminal:

    ```Bash
       CREATE DATABASE music;

       CREATE TABLE bands (
          id serial PRIMARY KEY,  # serial is auto-incrementing integer
          name varchar NOT NULL,
          genre varchar
       );
    ```

## Creating a Table for a Related Data Entry

[Go Back to Summary](#summary)

-   Let's say we have the following data relationship: `Band ----< Musician`
    -   A Band has many Musicians and a Musician belongs to a Band
-   Whenever you have a `one:many` relationship, the rows in the table for the many-side must include a column that references which row in the table on the on-side it belongs to.
-   This column is known as a **foreign key (FK)**
-   The FK must be the same data type is the primary key in the parent table (usually an integer).

    ```Bash
       CREATE TABLE musicians (
          id serial PRIMARY KEY,
          name varchar NOT NULL,
          quote text,
          band_id integer NOT NULL REFERENCES bands (id)
       );
    ```

# PostgreSQL Commands

## Terminal

[Go Back to Summary](#summary)

-   Run PostgreSQL on Terminal:

    ```Bash
       pqsl
    ```

-   Connect to a specific database:

    ```Bash
       \c <database_name>
    ```

-   To quit the psql

    ```Bash
       \q
    ```

-   To List all databases in the PostgreSQL database server

    ```Bash
       \l
    ```

-   To list all tables inside the databa_base that you are currentt using.

    ```Bash
       \d
    ```

## Managing Databases

[Go Back to Summary](#summary)

### Create a Database

```Bash
   CREATE DATABASE <database_name>;
```

### Delete a Database

```Bash
   DROP DATABASE <database_name>;
```

## Managing Tables

[Go Back to Summary](#summary)

### Add a New Column to a Table

```Bash
   ALTER TABLE <table_name> ADD COLUMN <column_name> <DATA_TYPE>;
```

### Delete a Column from a Table

```Bash
   ALTER TABLE <table_name> DROP COLUMN <column_name>;
```

### Rename a Column

```Bash
   ALTER TABLE <table_name> RENAME <column_name> TO <new_column_name>;
```

### Rename a Table

```Bash
   ALTER TABLE <table_name> RENAME TO <new_table_name>;
```

## Managing Indexes

[Go Back to Summary](#summary)

### Removing a Specified Index from a Table

```Bash
   DROP INDEX <index_name>;
```

## Querying Data from Tables

[Go Back to Summary](#summary)

### Query All Data from a Table

```Bash
   SELECT * FROM <table_name>;
```

### Query Data from Specified Columns

```Bash
   SELECT <column_name_1>, <column_name_2>, ... FROM <table_name>;
```

### Query Data Using a Filter - WHERE Operator

```Bash
   SELECT * FROM <table_name> WHERE <condition>;
```

### Query Data - LIKE Operator

```Bash
   SELECT * FROM <table_name> WHERE <column_name> LIKE '%value%';
```

### Query Data - IN Operator

```Bash
   SELECT * FROM <table_name> WHERE <column_name> IN (value_1, value2, ...);
```

### Query Data - Constrain the Returned Rows - LIMIT Operator

```Bash
   SELECT * FROM <table_name> LIMIT <limit> OFFSET <offset> ORDER BY <column_name>;
```

### Query Data - JOIN

-   INNER JOIN, LEFT JOIN, FULL OUTER JOIN, CROSS JOIN and NATURAL JOIN

    ```Bash
      SELECT * FROM <table_name_1> INNER JOIN <table_name_2> ON <conditions>;
    ```

    ```Bash
      SELECT * FROM <table_name_1> LEFT JOIN <table_name_2> ON <conditions>;
    ```

    ```Bash
      SELECT * FROM <table_name_1> FULL OUTER JOIN <table_name_2> ON <conditions>;
    ```

    ```Bash
      SELECT * FROM <table_name_1> CROSS JOIN <table_name_2> ON <conditions>;
    ```

    ```Bash
      SELECT * FROM <table_name_1> NATURAL JOIN <table_name_2> ON <conditions>;
    ```

### Return the Number of Rows of a Table

```Bash
   SELECT COUNT (*) FROM <table_name>;
```

### Sort Rows in Ascending or Descending Order - ORDER BY

```Bash
   SELECT * FROM <table_name> ORDER BY <column_name_1>, <column_name_2>, ...;
```

### Filter Groups - HAVING Clause

```Bash
   SELECT * FROM <table_name> GROUP BY <column_name> HAVING <condition>;
```

## Set Operations

[Go Back to Summary](#summary)

### Combine the Result - Two or More Queries - UNION Operator

```Bash
   SELECT * FROM <table_name_1> UNION SELECT * FROM <table_name_2>;
```

### Minus a Result - EXCEPT Operator

```Bash
   SELECT * FROM <table_name_1> EXCEPT SELECT * FROM <table_name_2>;
```

### Get Intersection of the Result Sets of Two Queries

```Bash
   SELECT * FROM <table_name_1> INTERSECT SELECT * FROM <tabble_name_2>;
```

## Modifying Data

[Go Back to Summary](#summary)

### Insert a New Row Into a Table

```Bash
   INSERT INTO <table_name> (<column_name_1>, <column_name_2, ...) VALUES (<value_1>, <value_2>, ...);
```

### Insert Multiple Rows Into a Table

```Bash
   INSERT INTO <table_name> (<column_name_1>, <column_name_2>, ...) VALUES (<value_1>, <value_2>, ...), (<value_1>, <value_2>, ...), (<value_1>, <value_2>, ...) ...;
```

### Update Data for All Rows

```Bash
   UPDATE <table_name> SET <column_name_1> = <value_1>, ...;
```

### Update Data from a Set of Rows Specified by a Condition - WHERE clause

```Bash
   UPDATE <table_name> SET <column_name_1> = <value_1>, ... WHERE <conditions>;
```

### Delete All Rows of a Table

```Bash
   DELETE FROM <table_name>;
```

### Delete a Specific Row Based on a Condition

```Bash
   DELETE FROM <table_name> WHERE <condition>;
```

# ADVANCED

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
