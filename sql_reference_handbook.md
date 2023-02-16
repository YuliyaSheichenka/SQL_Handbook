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


