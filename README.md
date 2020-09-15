<h1 id='summary'>Summary</h1>

- [Links](#links)
- [Basics](#basics)
  - [Concatenate Results](#concatenate-results)

# Links

-   [SQLWorkbench](https://sql-workbench.eu/)
-   [Java](https://www.java.com/)
-   [SQL Driver](https://jdbc.postgresql.org/download.html)

# Basics

[Go Back to Summary](#summary)

## Concatenate Results

-   Just like **&** in Excel, we can use `||` to concatenate results in SQL

    ```SQL
      SELECT e.firstname || ' ' || e.lastname AS "Employee Name",
            boss.firstname || ' ' || boss.lastname AS "Boss"
      FROM employee e
        FULL JOIN employee boss ON e.reportsto = boss.employeeid;
    ```
