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