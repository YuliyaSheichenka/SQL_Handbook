# SQL Query Examples
This file contains examples of SQL code explanations of what they do.

### Comments in SQL

````sql
-- single_line comment

/* multiple line
commment */
````

### Limiting number of results in SQL query

````sql

SELECT occurred_at, account_id, channel
FROM web_events
LIMIT 20;

-- LIMIT keyword is always the last one in the query.
````


### Ordering results of SQL query

Ex. If you are asked to find what are the 5 largest orders (in terms of sum of money) in the database.

````sql

SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd DESC 
LIMIT 5;

-- ORDER BY clause is inserted after FROM and before LIMIT
-- By default, you will get results in ascending order (from smallest sum to the largest),
-- so using DESC keyword allows getting the reverse order (from the largest to the smallest sum).

````

### Ordering results using multiple columns
When you list several columns in an ORDER BY clause, the sorting uses the leftmost column in the list, then the next one and so on. For each column, we can use DESC to get results sorted in descending order.

````sql

SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY account_id, total_amt_usd DESC;
-- For each account, starting from account with the smallest number, we get the amounts of all orders passed by this account, beginning with the largest amount.

SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd DESC, account_id;
-- For each amount, starting from the largest sum, we get the accounts that passed orders for this amount. For example, if there are multiple accounts that passed orders for 100 euros, the first account wil be the one with the smallest account_id.
````

### Filtering using WHERE clause

````sql

SELECT *
FROM orders
WHERE total_amt_usd >= 1000
LIMIT 5;
-- Selects the first 5 rows in the database where the amount of the order is greater than 1000.



SELECT name, website
FROM accounts
WHERE name = 'Exxon Mobil';
-- WHERE clause can be used to filter data using a text string as a condition for filtering.
-- In this case, there should be single quotes (') around the string (not double quotes (")).
````

### Derived columns
Derived columns can be used to display the result of mathematical operations on other columns (ex. calculating percentages or totals).
You can give an ad hoc name to a derived column by using the AS keyword.

````sql

SELECT id, account_id, 
   poster_amt_usd/(standard_amt_usd + gloss_amt_usd + poster_amt_usd)*100 AS post_per
FROM orders
LIMIT 10;
--Here, we create a column post_per that displays, for each of the 10 rows, the result of the calculation.
-- (an order may include several types of paper, and we want to know, for each order, what percentage of the revenue 
-- is attributable to poster paper).

````

### Looking for text results with inexact search term
You can use LIKE keyword with wildcards to search e.g. for a name of a company, a website address or other text information where you don't want the output be limited to the exact search term.

````sql

SELECT name
FROM accounts
WHERE name LIKE '%one%';
-- Looking for all company names that contain "one" and any number of any characters before or after the search term "one".

````

### Looking for all of several search terms
You can use IN to search for results that use each of the terms specified in the paretheses. 
The terms may be in the form of text (you need to use quotes around them: 'searchterm') or numbers (you can enter them as is: 34.5)
Most SQL environments allow using either double or single quotes to accomodate for the fact that you may need to look for a text string that has quotes or an apostrophe inside it.
The search terms within parentheses need to be separated with a comma.

````sql

SELECT name, primary_poc, sales_rep_id
FROM accounts
WHERE name IN ('Walmart', 'Target', 'Nordstrom');
--Looking for information about each of the three companies.
````


### Using NOT with IN or with LIKE

````sql 

SELECT *
FROM web_events
WHERE channel NOT IN ('organic', 'adwords');
-- Looking for clients that were contacted by channels other than 'organic' or 'adwords'


SELECT name
FROM accounts
WHERE name NOT LIKE 'C%';
-- Looking for clients whose name does not begin with 'C'.

````

### BETWEEN

````sql
SELECT id, account_id, occurred_at, gloss_qty
FROM orders
WHERE gloss_qty BETWEEN 24 AND 29
ORDER BY gloss_qty;
-- BETWEEN operator is inclusive of endpoints: the statement in the query above
-- is equivalent to 
-- WHERE gloss_qty >= 24 AND gloss_qty <= 29
````

### Using BETWEEN to select a time period

Also see discussion at stackoverflow:
https://stackoverflow.com/questions/5125076/sql-query-to-select-dates-between-two-dates

````sql
SELECT *
FROM web_events
WHERE channel IN ('organic', 'adwords') 
AND occurred_at BETWEEN '2016-01-01' AND '2017-01-01'
ORDER BY occurred_at DESC;
-- Selecting dates in 2016.

-- BETWEEN considers that the new date begins at 00:00:00 (i.e. midnight). So if you use '2016-12-31' as the endpoint, 
-- your time period will actually end at 2016-12-31 00:00:00 and won't include events that occured after 00:00:00 on December, 31. 
-- This is the reason why we set the right-side endpoint of the period at '2017-01-01' 
-- but it will also include events that happened on 2017-01-01 00:00:00.


-- Variant of the query above without the complications of BETWEEN:
SELECT *
FROM web_events
WHERE channel IN ('organic', 'adwords') 
AND occurred_at >= '2016-01-01' AND occurred_at < '2017-01-01'
ORDER BY occurred_at DESC;
````

### How to select all columns from both tables you are joining

````sql

SELECT *
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;
-- * selects all columns from both tables being joined, "orders" and "accounts", i.e. all these columns
-- will be shown as the result of the query.

-- Compare with the query below that executes the join but only the columns from the "orders" table will be shown:
SELECT orders.*
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;
-- orders.* means that all columns of the orders table are selected (but none of the columns of the "accounts" table
-- with which it is being joined)

````

### Order of columns selected during JOIN
Generally, columns in the view that you get as a result of a query are be shown in the same order as in the SELECT clause. The same is true for the view that results from JOIN.

````sql
SELECT accounts.*, orders.*
FROM accounts
JOIN orders
ON orders.account_id = accounts.id;
-- Here, we select all columns from the "accounts" table and all columns from the "orders" table.
-- The columns from the "accounts" table will be the first (leftmost) to appear in the resulting view.

SELECT orders.*, accounts.*
FROM accounts
JOIN orders
ON orders.account_id = accounts.id;
-- The columns from the "orders" table will be leftmost in the resulting view
````

### Left or right join?
It is easy to change a right join into a left join by switching the table names in FROM and JOIN clauses. For this reason, the convention is to use left join to make the code more consistent and easy to read.

### Inner join
INNER JOIN = JOIN

### Outer joins
LEFT OUTER JOIN = LEFT JOIN (inner join + unmatchend rows from the left table)
RIGHT OUTER JOIN = RIGHT JOIN (inner join + unmatched rows from the right table)
FULL OUTER JOIN = OUTER JOIN (inner join + any unmatched rows from both the left and the right table)

### Filtering tables before or after join (place of WHERE)
````sql
SELECT orders.*, accounts.*
FROM orders
LEFT JOIN accounts
ON orders.account_id = accounts.id
WHERE accounts.sales_rep_id = 321500
-- In this query, the tables are joined and the resulting table is filtered based on the sales_rep_id of interest.

SELECT orders.*, accounts.*
FROM orders
LEFT JOIN accounts
ON oders.account_id = accounts.id
AND accounts.sales_rep_id = 321500
-- In this query, the table accounts is pre-filtered on the sales_rep_id of interest before the join; 
-- So the accounts table being used for the join has fewer rows than the initial unfiltered one.
````

### NULLs
NULL are not values but are property of the data.
COUNT aggregate function used on a column with NULL values returns the number of rows with non-null values.
AVG aggregate function ignores the NULL values both in the numerator and the denominator


### Return a table with a column where the last and the first lettres for each string in the original column have been removed

````sql
SELECT original_column, SUBSTRING(original_column, 2, LENGTH(original_column) - 2) AS result 
FROM table_name;

-- SUBSTRING: This is the function name in PostgreSQL that extracts a substring from a string.
-- original_column: This is the name of the column containing the strings from which you want to extract the substring.
-- 2: This is the starting position of the substring. In this case, we start from the second character, as the index in PostgreSQL starts from 1.
-- LENGTH(original_column) - 2: This is the length of the substring. We subtract 2 from the length of the original string to exclude the first and last characters. By using LENGTH(original_column), we dynamically calculate the length of each string in the column.
--So, the substring(original_column, 2, length(original_column) - 2) expression will extract a substring from the original_column starting from the second character and having a length equal to the length of the original string minus 2 (excluding the first and last characters).
````

### Select minimum and maximum value from a table
````sql
SELECT 
 MIN(age) AS age_min, 
 MAX(age) AS age_max
FROM 
   people;
-- here, whe have selected maximum and minimum values from column 'age' from the table 'people'.
````

### Convert string to uppercase
````sql
SELECT col_with_strings, UPPER(col_with_strings) AS col_with_uppercase_strings
FROM makeuppercase_table;
-- Here we work with the table named "makeuppercase_table".
-- We have converted strings contained in the column "col_with_strings"
-- to upper case and returned the result in the column "col_with_uppercase_strings".
-- We return the table with two columns, "col_with_strings" and "col_with_uppercase_strings" for comparison.
````

### Select the latest date from a column
````sql
--Using an aggregation function:
SELECT MAX(occurred_at)
FROM web_events;
-- MAX returns the most recent date or time from a column with timestamps
-- MIN the oldest date or time.

-- Using LIMIT clause:
SELECT occurred_at
FROM web_events
ORDER BY occurred_at DESC
LIMIT 1;
-- Here, we sort timestaps in descending order and limit the result to 1 row.
-- It is possible that there are several rows with the same maximum or minimum value (ties). In order not to miss them,
-- it is useful to set LIMIT to a larger number ex. 3 or 5. (this is a general remark on using LIMIT, not only for dates).
````

### How to find the median of a column
````sql
--Using subquery
SELECT *
FROM (SELECT total_amt_usd
         FROM orders
         ORDER BY total_amt_usd
         LIMIT 3457) AS Table1
ORDER BY total_amt_usd DESC
LIMIT 2;
````

### GROUP BY and aggregations
GROUP BY allows creating segments that will aggregate independent from one another.
Any column in the SELECT statement that in not used with an aggregation function must be in the GROUP BY clause.
GROUP BY is always placed between WHERE and ORDER BY.


### LIMIT and aggregations
SQL first calculates the aggregations, than displays the number of rows indicated in the LIMIT clause. 
(And not the reverse where SQL would first cut the table to the number of rows indicated in the LIMIT clause, then calculate aggregations).



### Order of columns in GROUP BY and ORDER BY clauses
The order of column names in GROUP BY clause does not matter (the order of columns in the result will be the same)
The order of column names in ORDER BY clause matters as columns are ordered from left to right according 
to their order in the ORDER BY clause.

### SELECT DISTINCT
DISTINCT provides the unique rows across the columns written in the SELECT statement.
Using DISTINCT in aggregations can slow queries.

````sql
SELECT DISTINCT a.name AS account_name, r.name AS region_name
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
JOIN region r
ON r.id = s.region_id
ORDER BY account_name;
-- The query allows retrieving unique combinations or region name and account name
-- (ex. if you want to see if there is an account that is associated with more than one regions)
-- Note that the if you don't give differing aliases to columns a.name (from accounts table) and r.name (from region table),
-- the resulting view will only contain one column "name". 
````

### Difference between HAVING and WHERE
HAVING can be used on a column created using an aggregating function, WHERE cannot.
WHERE is placed before GROUP BY, HAVING after GROUP BY and before ORDER BY.


### HAVING not working with alias of column
````sql 
-- The following query will not work as it uses the alias of the column in the HAVING clause
-- (error "column "total_across_orders" does not exist")
SELECT a.id account_id, a.name account_name, SUM(o.total_amt_usd) total_across_orders
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
HAVING total_across_orders < 1000;


-- You must use the aggregator and the non-aliased name of the column in the HAVING clause for the query to work:
SELECT a.id account_id, a.name account_name, SUM(o.total_amt_usd) total_across_orders
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
HAVING SUM(o.total_amt_usd) < 1000;
````

### LIMIT and big databases
When working with a big database it is useful to use the LIMIT clause when you are trying to have a look at the general constitution of a database for reasons of speed and cost.

### Referring to columns in SELECT by numbers
````sql 
SELECT DATE_TRUNC('year', occurred_at) AS year, SUM(total_amt_usd)
FROM orders
GROUP BY year
ORDER BY SUM(total_amt_usd) DESC;

-- is equivalent to
SELECT DATE_TRUNC('year', occurred_at) AS year, SUM(total_amt_usd)
FROM orders
GROUP BY 1
ORDER BY 2 DESC;

````

### Grouping data by day of week using DATE_PART
````sql 
SELECT DATE_PART('dow', occurred_at) AS day_of_week, 
account_id, occurred_at, total
FROM orders;
-- The parameter 'dow' (day of week) allows grouping data by day of the week 
-- (ex. data for all Mondays, across all months and years present in the table).
-- The resulting column day_of_week will contain numbers from 0 (Sunday) to 6 (Saturday).

````



### CASE Clause
CASE clause in always used within SELECT clause.
There is a comma before a CASE clause.
CASE statement includes WHEN, THEN, (optionnaly ELSE) and END keywords.
(There are no commas at the end of each condition beginning with WHEN)
````sql
SELECT account_id, CASE WHEN standard_qty = 0 OR standard_qty IS NULL THEN 0
                        ELSE standard_amt_usd/standard_qty END AS unit_price
FROM orders
LIMIT 10;
-- in this case, we create the column unit_price that contains either the result of division of 
-- standard_amt_usd by standard_qty or 0 if standard_qty is equal to 0 or is null.
-- Inclusion of CASE statement allows avoiding the error caused by division by zero if 
-- standard_qty is eqal to 0 or is null.

-- Example of using two WHEN statements within CASE clause
-- Note that there are commas between parts of the SELECT clause that correspond to columns.
-- There are no commas inside CASE statement between WHEN or ELSE statements
SELECT a.name, SUM(total_amt_usd) total_spent, 
        CASE WHEN SUM(total_amt_usd) > 200000 THEN 'top'
        WHEN SUM(total_amt_usd) > 100000 THEN 'middle'
        ELSE 'low' END AS customer_level
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY 1 -- variant: GROUP BY a.name
ORDER BY 2 DESC;


-- Note that in the example above the categories 'SUM(total_amt_usd)' > 200000 and 'SUM(total_amt_usd) > 100000' overlap 
-- because every sum that is greater than 200000 is also greater than 100000. 
-- The example above works because code is executed line after  line, 
-- so if after the first WHEN statement 'SUM(total_amt_usd)' > 200000' the value assigned to the customer_level is 'top', 
-- this value is not replaced by 'middle' when executing the second WHEN statement 'SUM(total_amt_usd) > 100000'.

-- However, to avoid confusion, it is better to create non-overlapping categories as shown below:
SELECT a.name, SUM(total_amt_usd) total_spent, 
        CASE WHEN SUM(total_amt_usd) > 200000 THEN 'top'
        WHEN SUM(total_amt_usd) > 100000 AND SUM(total_amt_usd) <= 200000 THEN 'middle'
        ELSE 'low' END AS customer_level
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY 1 -- variant: GROUP BY a.name
ORDER BY 2 DESC;

````

### Order of dates

````sql
SELECT a.name, SUM(total_amt_usd) AS total_spent, 
CASE WHEN SUM(total_amt_usd) > 200000 THEN 'top'
WHEN SUM(total_amt_usd) > 100000 THEN 'middle'
ELSE 'low' END AS customer_level
FROM accounts a
JOIN orders o
ON a.id = o.account_id
WHERE occurred_at > '2015-12-31'
GROUP BY 1
ORDER BY 2 DESC;
-- Here, we needed to select only orders that occurred in 2016 and 2017. As the database only contained orders up to year 2017 
-- included, we were able to simply select all orders with dates greater than December 31, 2015.
-- Note that YYYY-MM-DD format allows ordering dates as strings in alphabetical order without converting them to date format
-- and this order will correspond to the real order of the dates.
-- I.e '2015-31-12' string goes before '2016-01-01' string in the same way as 2015-31-12 date goes before 2016-01-01 date.
````

### How to write subqueries
A subquery (nested query) is a query that returns an intermediary table that you can interrogate like any other table. 
To make nested queries more readable, indentation is used to distinguis subqueries from outer queries.
(Outer query is also called main query.)

````sql
-- STEP 1
-- The initial query that will be the basis of the subquery when it is placed within another query.
-- As the subquery will be executed before the surrounding query, first make sure 
-- that the part of the code that will later play the role of the subquery is running correctly.
SELECT DATE_TRUNC('day', occurred_at) AS day, 
        channel, COUNT(*) AS nb_events
FROM web_events
GROUP BY 1, 2
ORDER BY 3 DESC

-- STEP 2
-- Here we format the initially written code as subquery. 
-- The result is going to be the same as the previous piece of code.
-- In order to treat the subquery as as table, an alias should be assigned to is.
SELECT *
FROM (SELECT DATE_TRUNC('day', occurred_at) AS day, 
        channel, COUNT(*) AS events
        FROM web_events
        GROUP BY 1, 2
        ORDER BY 3 DESC) subquery_alias ;


-- STEP 3
-- Now we can adujst the outer query to get the necessary information from the subquery table.
-- Here we get average number of events per day per channel.
-- Numbers in outer GROUP BY and ORDER BY clauses refer to names of columns in outer SELECT clause.
-- Note that as outer query contains and ORDER BY clause (placing channels with the biggest number of events first),
-- ORDER BY clause in subquery is redundant as the outerquery will reorder the results anyway.
SELECT channel, AVG(events) AS average_events
FROM (SELECT DATE_TRUNC('day', occurred_at) AS day, 
                channel, COUNT(*) AS events
        FROM web_events
        GROUP BY 1, 2) subquery_alias
GROUP BY 1
ORDER BY 2 DESC;

````
### Using subqueries in conditional statements
If a subquery returns a single value it can be used in a conditional statement like WHERE or HAVING,
or in SELECT where the value in the form of the subquery can be nested with in a CASE statement.

If a subqery returns several values or a column, IN should be used as a conditional statement.

There is no need to use an alias when you write a subquery that returns a single value or a column in a canditional statement,
because the subquery is treated as an individual value (or a set of values) rather than as a table.

````sql
-- Here we obtain the average quantity of three kinds of paper that was sold during the same month of the same year
-- as the year and month when the first order was placed.
SELECT AVG(standard_qty) avg_std, AVG(gloss_qty) avg_gls, AVG(poster_qty) avg_pst
FROM orders
WHERE DATE_TRUNC('month', occurred_at) = 
     (SELECT DATE_TRUNC('month', MIN(occurred_at)) FROM orders);



-- Here we obtain the total amount of sales for all kinds of paper sold the same month of the same year
-- as the year and mont when the first ofder was placed
SELECT SUM(total_amt_usd)
FROM orders
WHERE DATE_TRUNC('month', occurred_at) = 
      (SELECT DATE_TRUNC('month', MIN(occurred_at)) FROM orders);

````


### Syntax of WITH statements

The WITH statement can be used what a subquery takes a long time to run so it is unreasonabe to 
launch it with every query. WITH statement allows running such a subquery once. The results of the query are saved as a table
that can be queries using subsequent queries.

````sql
-- Here we see a query using a subquery used to find the average number of events for each channel per day.
-- The table resulting from the subquery is aliased 'sub'
SELECT channel, AVG(events) AS average_events 
FROM 
        (SELECT DATE_TRUNC('day',occurred_at) AS day, channel, COUNT(*) as events 
        FROM web_events GROUP BY 1,2) sub 
GROUP BY channel 
ORDER BY 2 DESC;


-- The subquery can be used separately:
SELECT DATE_TRUNC('day',occurred_at) AS day, 
       channel, COUNT(*) as events
FROM web_events 
GROUP BY 1,2


-- This subquery is the part that can be put in a with statement.
-- 'events' is the alias of the table resulting from suquery
WITH events AS (
          SELECT DATE_TRUNC('day',occurred_at) AS day, 
                        channel, COUNT(*) as events
          FROM web_events 
          GROUP BY 1,2)



-- The query where the initial subquery had been replaces with WITH statement:
WITH events AS (
          SELECT DATE_TRUNC('day',occurred_at) AS day, 
                        channel, COUNT(*) as events
          FROM web_events 
          GROUP BY 1,2)

SELECT channel, AVG(events) AS average_events
FROM events
GROUP BY channel
ORDER BY 2 DESC;
````

### Using WITH statement to create several tables

If the WITH statement contains several tables, they should be separated by commas.
(A comma after each table except for the last table leading to the final query)

The statements with WITH are called CTE (Common Table Expressions / expression de table commune). 
They make it possible time by creating the table in WITH statement once and then reusing it for queries. They also can be more readable than subqueries.

````sql
WITH table1 AS (
          SELECT *
          FROM web_events),

     table2 AS (
          SELECT *
          FROM accounts)


SELECT *
FROM table1
JOIN table2
ON table1.account_id = table2.id;
````

### RIGHT and LEFT statement syntax

````sql
SELECT RIGHT(website, 3) AS domain, COUNT(*) num_companies
FROM accounts
GROUP BY 1
ORDER BY 2 DESC;
-- The query serves to count the number of sites belonging to a certain domain (.com, .org, .net).
-- The table 'accounts' contains column 'website 'that has website address in text format. 
-- The expression 'RIGHT(website, 3) AS domain' pulls three rightmost characters of the website address and 
-- puts them into a new column called 'domain'. Groupinb by this column and counting the rows for each domain
-- category allows knowing how many websites belong to this or that domain.
````

### Split a string by delimiter using STRPOS

```sql
SELECT name, LEFT(name, (STRPOS(name, ' ') - 1)) AS first_name, RIGHT(name, (LENGTH(name) - STRPOS(name, ' '))) AS last_name
FROM sales_reps;

-- This query allows creating columns 'first_name' and 'last_name' based on the column 'name' that contains full names like 'Samuel Racine'
-- expression STRPOS(name, ' ') get the position of the space in a string, counting from the left and with indexing beginning at 1.
-- exrpession LEFT(name, (STRPOS(name, ' ') - 1)) allows getting the leftmost part of the string up until the space
-- but not including the space (hence '-1'). 
-- expressoin LENGTH(name) allows getting the length of a string as a number.

-- in order to get the last name, the rightmost part of the string should be included in the column last_name.
-- To determine the position of the split, we subtract the position of the space from the length of the string 
-- (LENGTH(name) - STRPOS(name, ' ')) 
-- The resulting number means the number of characters, counting from the right, that we must take to get the last name:
-- RIGHT(name, (LENGTH(name) - STRPOS(name, ' ')))

```

### Concatenate strings

```sql
-- Syntax with CONCAT
WITH t1 AS (
    SELECT LEFT(primary_poc,     STRPOS(primary_poc, ' ') -1 ) first_name,  RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name, name
    FROM accounts)
SELECT first_name, last_name, CONCAT(first_name, '.', last_name, '@', name, '.com')
FROM t1;

-- Syntax with piping ||
WITH t1 AS (
    SELECT LEFT(primary_poc,     STRPOS(primary_poc, ' ') -1 ) first_name,  RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name, name
    FROM accounts)
SELECT first_name, last_name, first_name || '.'  || last_name ||'@' || name || '.com' email
FROM t1;
-- In both cases, there can be several strings used in concatenation. 
-- The elements used in concatenation can either be strings in table columns (first_name, last_name, name in the example above)
-- or hard-coded strings ('.'  or '@' or '.com' in the example above)
```

### Calculate running total (window function)

````sql
-- Running total over the whole range of dates present in the table:
SELECT standard_amt_usd,
SUM(standard_amt_usd) OVER (ORDER BY occurred_at) AS running_total
FROM orders;
-- This query returns two columns, one for dollar amount, the other for running total of dollar amounts 
-- (total of all rows up to and including the present row). 
-- ORDER BY clause is used to order rows of the table by date so that the running total is in chronological order.


-- Running total over periods (month, year) or partitions
SELECT standard_amt_usd,
DATE_TRUNC('year', occurred_at) AS year,
SUM(standard_amt_usd) OVER (PARTITION BY DATE_TRUNC('year', occurred_at) ORDER BY occurred_at) AS running_total
FROM orders;
-- This query returns three columns: one for dollar amount, the second for date truncated at year, 
-- the third one for running total for each year period: as soon as year in occurred_at column changes from 2013 to 2014, 
-- the running total begins anew for 2014 without adding new amounts to the total in the last row for year 2013.
-- For this to funciton, ORDER BY clause is used to sort table rows in chronological order.
````

### Aliases for window functions

```sql
SELECT id,
       account_id,
       DATE_TRUNC('year',occurred_at) AS year,
       DENSE_RANK() OVER account_year_window AS dense_rank,
       total_amt_usd,
       SUM(total_amt_usd) OVER account_year_window AS sum_total_amt_usd,
       COUNT(total_amt_usd) OVER account_year_window AS count_total_amt_usd,
       AVG(total_amt_usd) OVER account_year_window AS avg_total_amt_usd,
       MIN(total_amt_usd) OVER account_year_window AS min_total_amt_usd,
       MAX(total_amt_usd) OVER account_year_window AS max_total_amt_usd
FROM orders
WINDOW account_year_window AS (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at))
```

### LAG and LEAD functions (calculating differences between rows)

````sql
SELECT account_id,
       standard_sum,
       LAG(standard_sum) OVER (ORDER BY standard_sum) AS lag,
       LEAD(standard_sum) OVER (ORDER BY standard_sum) AS lead,
       standard_sum - LAG(standard_sum) OVER (ORDER BY standard_sum) AS lag_difference,
       LEAD(standard_sum) OVER (ORDER BY standard_sum) - standard_sum AS lead_difference
FROM (
SELECT account_id,
       SUM(standard_qty) AS standard_sum
  FROM orders 
 GROUP BY 1
 ) sub
 -- For any given row, LAG(standard_sum) retrieves standard_sum of the preceding row. 
 -- In this query, this value is then shown in the column named "lag". 
 -- If the preceding row does not exist, the value returned in the lag column is NULL.
 -- Similarly, for a given row, LEAD(standard_sum) retrieves standard_sum of the following row.
 -- The value is then shown in the column named "lead".
 -- If the following row does not exist, the value returned in the lead column is NULL.
 -- It is important to order rows in a way that makes sense. Here, the rows were ordered based on the 
 -- total sum of all orders made by the same account_id, so that the first row has the smallest amount. 
 -- This makes it possible to calculate the differences between accounts (columns lag_difference, lead_difference)
````

### NTILE (Percentile function / quartile / quantile)
````sql
--  NTILE can be used with window functions to identify what percentile (or quartile, or any other subdivision) 
-- a given row falls into.

-- Particularity of functioning as explained on Udacity:
-- "In cases with relatively few rows in a window, the NTILE function doesn’t calculate exactly as you might expect. For example, If you only had two records and you were measuring percentiles, you’d expect one record to define the 1st percentile, and the other record to define the 100th percentile. Using the NTILE function, what you’d actually see is one record in the 1st percentile, and one in the 2nd percentile.

--In other words, when you use a NTILE function but the number of rows in the partition is less than the NTILE(number of groups), then NTILE will divide the rows into as many groups as there are members (rows) in the set but then stop short of the requested number of groups. If you’re working with very small windows, keep this in mind and consider using quartiles or similarly small bands".

SELECT account_id, occurred_at, total_amt_usd,
NTILE(4) OVER (PARTITION BY account_id ORDER BY total_amt_usd) AS total_percentile
FROM orders
ORDER BY account_id;

-- Here, for each account_id the values in the column total_amt_usd are ordered in ascending order.
-- For each account_id, these sorted values are divided into 4 parts (quartiles).
-- An additional column called total_percentile contains value indicating the quartile to which
-- an order was assigned (1, 2, 3 or 4)

````