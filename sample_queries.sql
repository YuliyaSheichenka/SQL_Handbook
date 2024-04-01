
/* example of using LIMIT key word.
It is always used at the very end of the query*/

SELECT occurred_at, account_id, channel
FROM web_events
LIMIT 20;
-- This is a single_line comment

SELECT id, occurred_at, total_amt_usd
FROM orders
ORDER BY occurred_at
LIMIT 10;


SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd DESC
LIMIT 5;


SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd
LIMIT 20;



SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY account_id, total_amt_usd DESC;

SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd DESC, account_id;


SELECT *
FROM orders
WHERE gloss_amt_usd >= 1000
LIMIT 5;

SELECT *
FROM orders
WHERE total_amt_usd < 500
LIMIT 10;


SELECT name, website, primary_poc
FROM accounts
WHERE name = 'Exxon Mobil';


SELECT name
FROM accounts
WHERE name LIKE 'C%'; 


SELECT name
FROM accounts
WHERE name LIKE '%one%';


SELECT name
FROM accounts
WHERE name LIKE '%s';

SELECT name, primary_poc, sales_rep_id
FROM accounts
WHERE name IN ('Walmart', 'Target', 'Nordstrom');


SELECT *
FROM web_events
WHERE channel in ('organic','adwords');


SELECT name, primary_poc, sales_rep_id
FROM accounts
WHERE name NOT IN ('Walmart', 'Target', 'Nordstrom');


SELECT *
FROM web_events
WHERE channel NOT IN ('organic', 'adwords');


SELECT name
FROM accounts
WHERE name NOT LIKE 'C%';


SELECT name
FROM accounts
WHERE name NOT LIKE '%one%';



SELECT name
FROM accounts
WHERE name NOT LIKE '%s';

SELECT id, account_id, standard_qty, poster_qty, gloss_qty
FROM orders
WHERE standard_qty > 100 AND poster_qty=0 AND gloss_qty=0;


SELECT id, account_id, gloss_qty
FROM orders
WHERE gloss_qty BETWEEN 24 AND 29
SORT gloss_qty

SELECT id, account_id, gloss_qty
FROM orders
WHERE gloss_qty BETWEEN 24 AND 29
SORT gloss_qty DESC


SELECT *
FROM orders
WHERE standard_qty > 1000 AND poster_qty = 0 AND gloss_qty = 0;

SELECT name
FROM accounts
WHERE name NOT LIKE 'C%' AND name LIKE '%s';

SELECT id, account_id, occurred_at, gloss_qty
FROM orders
WHERE gloss_qty BETWEEN 24 AND 29
ORDER BY gloss_qty;

SELECT id
FROM orders
WHERE gloss_qty > 4000 OR poster_qty > 4000;

SELECT *
FROM orders
WHERE standard_qty = 0 
AND (gloss_qty > 1000 OR poster_qty > 1000);

SELECT name
FROM accounts
WHERE (name LIKE 'C%' OR name LIKE 'W%')
AND ((primary_poc LIKE '%ana%' OR primary_poc LIKE'%Ana%')
AND  primary_poc NOT LIKE '%eana%');

SELECT accounts.*, orders.*
FROM accounts
JOIN orders
ON orders.account_id = accounts.id;

SELECT orders.*, accounts.*
FROM accounts
JOIN orders
ON orders.account_id = accounts.id;

SELECT accounts.*, orders.*
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;

SELECT orders.standard_qty, orders.gloss_qty, orders.poster_qty,
        accounts.website, accounts.primary_poc
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;


---Provide a table for all web_events associated with account name of Walmart. 
---There should be three columns. Be sure to include the primary_poc, time of the event, and the channel for each event. 
---Additionally, you might choose to add a fourth column to assure only Walmart events were chosen.
SELECT a.primary_poc, w.occurred_at, w.channel, a.name
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
WHERE a.name = 'Walmart';

---Provide a table that provides the region for each sales_rep along with their associated accounts. 
---Your final table should include three columns: the region name, the sales rep name, and the account name. 
---Sort the accounts alphabetically (A-Z) according to account name.
SELECT r.name region, s.name rep, a.name account
FROM sales_reps s
JOIN region r
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
ORDER BY a.name;

---Provide the name for each region for every order, as well as the account name 
---and the unit price they paid (total_amt_usd/total) for the order. 
---Your final table should have 3 columns: region name, account name, and unit price. 
---A few accounts have 0 for total, so I divided by (total + 0.01) to assure not dividing by zero.
SELECT r.name region, a.name account, 
           o.total_amt_usd/(o.total + 0.01) unit_price
FROM region r
JOIN sales_reps s
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id;

---Provide a table that provides the region for each sales_rep 
---along with their associated accounts. This time only for the Midwest region. 
---Your final table should include three columns: the region name, the sales rep name, 
---and the account name. Sort the accounts alphabetically (A-Z) according to account name.
SELECT r.name region, s.name rep, a.name account
FROM sales_reps s
JOIN region r
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
WHERE r.name = 'Midwest'
ORDER BY a.name;

---Provide a table that provides the region for each sales_rep along with 
---their associated accounts. This time only for accounts where the sales rep 
---has a first name starting with S and in the Midwest region. Your final table should include 
---three columns: the region name, the sales rep name, and the account name. 
---Sort the accounts alphabetically (A-Z) according to account name.
SELECT r.name region, s.name rep, a.name account
FROM sales_reps s
JOIN region r
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
WHERE r.name = 'Midwest' AND s.name LIKE 'S%'
ORDER BY a.name;

---Provide a table that provides the region for each sales_rep along with 
---their associated accounts. This time only for accounts where the sales rep 
---has a last name starting with K and in the Midwest region. 
---Your final table should include three columns: the region name, the sales rep name, 
---and the account name. Sort the accounts alphabetically (A-Z) according to account name.
SELECT r.name region_name, s.name sales_rep_name,
        a.name account_name
FROM region r
JOIN sales_reps s
ON s.region_id = r.id
AND s.name LIKE '% K%'
JOIN accounts a
ON a.sales_rep_id = s.id
WHERE r.name = 'Midwest'
ORDER BY account_name;

---variant:
SELECT r.name region, s.name rep, a.name account
FROM sales_reps s
JOIN region r
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
WHERE r.name = 'Midwest' AND s.name LIKE '% K%'
ORDER BY a.name;

---Provide the name for each region for every order, as well as the account name 
---and the unit price they paid (total_amt_usd/total) for the order. 
---However, you should only provide the results if the standard order quantity exceeds 100. 
---Your final table should have 3 columns: region name, account name, and unit price. 
---In order to avoid a division by zero error, adding .01 to the denominator 
---here is helpful total_amt_usd/(total+0.01).
SELECT r.name region, a.name account, o.total_amt_usd/(o.total + 0.01) unit_price
FROM region r
JOIN sales_reps s
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
WHERE o.standard_qty > 100;


---Provide the name for each region for every order, as well as the account name 
---and the unit price they paid (total_amt_usd/total) for the order. 
---However, you should only provide the results if the standard order quantity exceeds 100 
---and the poster order quantity exceeds 50. 
---Your final table should have 3 columns: region name, account name, and unit price. 
---Sort for the smallest unit price first. In order to avoid a division by zero error, 
---adding .01 to the denominator here is helpful (total_amt_usd/(total+0.01).
SELECT r.name region, a.name account, o.total_amt_usd/(o.total + 0.01) unit_price
FROM region r
JOIN sales_reps s
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
WHERE o.standard_qty > 100 AND o.poster_qty > 50
ORDER BY unit_price;

---Provide the name for each region for every order, as well as the account name 
---and the unit price they paid (total_amt_usd/total) for the order. 
---However, you should only provide the results if the standard order quantity exceeds 100 
---and the poster order quantity exceeds 50. Your final table should have 3 columns: 
---region name, account name, and unit price. Sort for the largest unit price first. 
---In order to avoid a division by zero error, adding .01 to the denominator here is helpful 
---(total_amt_usd/(total+0.01)
SELECT r.name region, a.name account, o.total_amt_usd/(o.total + 0.01) unit_price
FROM region r
JOIN sales_reps s
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
WHERE o.standard_qty > 100 AND o.poster_qty > 50
ORDER BY unit_price DESC;

---What are the different channels used by account id 1001? 
---Your final table should have only 2 columns: account name and the different channels. 
---You can try SELECT DISTINCT to narrow down the results to only the unique values.
SELECT DISTINCT a.name account_name, w.channel
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
WHERE account_id = '1001';

---Find all the orders that occurred in 2015. Your final table should have 4 columns: 
---occurred_at, account name, order total, and order total_amt_usd.
SELECT o.occurred_at occ_at, a.name account_name, 
        o.total, o.total_amt_usd
FROM orders o 
JOIN accounts a
ON o.account_id = a.id
WHERE o.occurred_at >= '2015-01-01' AND o.occurred_at < '2016-01-01'
ORDER BY o.occurred_at DESC;

--variant with BETWEEN:
SELECT o.occurred_at, a.name, o.total, o.total_amt_usd
FROM accounts a
JOIN orders o
ON o.account_id = a.id
WHERE o.occurred_at BETWEEN '01-01-2015' AND '01-01-2016'
ORDER BY o.occurred_at DESC;*

--When was the earliest order ever placed? You only need to return the date.
SELECT MIN(o.occurred_at)
FROM orders o;

--Try performing the same query as in question 1 without using an aggregation function.
SELECT o.occurred_at
FROM orders o
ORDER BY o.occurred_at
LIMIT 1;

-- When did the most recent (latest) web_event occur?
SELECT MAX(w.occurred_at)
FROM web_events w;

--Try to perform the result of the previous query without using an aggregation function.
SELECT w.occurred_at
FROM web_events w
ORDER BY  w.occurred_at DESC
LIMIT 1;


--Find the mean (AVERAGE) amount spent per order on each paper type, 
--as well as the mean amount of each paper type purchased per order. 
--Your final answer should have 6 values - one for each paper type for the average number of sales, as well as the average amount.
SELECT AVG(standard_qty) AS std_avg_num_sales, 
        AVG(standard_amt_usd) AS std_avg_amt_usd, 
        AVG(poster_qty) AS poster_avg_num_sales, 
        AVG(poster_amt_usd) AS poster_avg_amt_usd,
        AVG(gloss_qty) AS gloss_avg_num_sales, 
        AVG(gloss_amt_usd) AS gloss_avg_amt_usd
FROM orders;

--Via the video, you might be interested in how to calculate the MEDIAN. 
--Though this is more advanced than what we have covered so far try finding - what is the MEDIAN total_usd spent on all orders?
SELECT *
FROM (SELECT total_amt_usd
         FROM orders
         ORDER BY total_amt_usd
         LIMIT 3457) AS Table1
ORDER BY total_amt_usd DESC
LIMIT 2;

--Which account (by name) placed the earliest order? 
--Your solution should have the account name and the date of the order.
SELECT a.name AS account_name,
o.occurred_at AS occurred_at
FROM accounts a
JOIN orders o
ON a.id = o.account_id
ORDER BY o.occurred_at
LIMIT 1;

--Find the total sales in usd for each account. You should include two columns - the total sales 
--for each company's orders in usd and the company name.
SELECT a.name as company_name,
SUM(o.total_amt_usd) AS total_amt_usd
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name
ORDER BY a.name;


--Via what channel did the most recent (latest) web_event occur,
--which account was associated with this web_event? 
--Your query should return only three values - the date, channel, and account name.
SELECT w.occurred_at AS event_date,
w.channel AS channel, a.name
FROM web_events w
JOIN accounts a
ON a.id = w.account_id
ORDER BY w.occurred_at DESC
LIMIT 1;


--Find the total number of times each type of channel from the web_events was used. 
--Your final table should have two columns - the channel and the number of times the channel was used.
SELECT w.channel, COUNT(*)
FROM web_events w
GROUP BY w.channel;


--Who was the primary contact associated with the earliest web_event?
SELECT a.primary_poc
FROM web_events w
JOIN accounts a
ON a.id = w.account_id
ORDER BY w.occurred_at
LIMIT 1;


--What was the smallest order placed by each account in terms of total usd. 
--Provide only two columns - the account name and the total usd. Order from smallest dollar amounts to largest.
SELECT a.name, MIN(total_amt_usd) AS smallest_order
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name
ORDER BY smallest_order;


--Find the number of sales reps in each region. 
--Your final table should have two columns - the region and the number of sales_reps. 
--Order from fewest reps to most reps.
SELECT r.name, COUNT(*) num_reps
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
GROUP BY r.name
ORDER BY num_reps;

--For each account, determine the average amount of each type of paper they purchased across their orders. 
--Your result should have four columns - one for the account name and one 
--for the average quantity purchased for each of the paper types for each account.
SELECT a.name, 
AVG(o.standard_qty) AS avg_standard_qty, 
AVG(o.gloss_qty) AS avg_gloss_qty, 
AVG(o.poster_qty) AS avg_poster_qty
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name;


--For each account, determine the average amount spent per order on each paper type. 
--Your result should have four columns - one for the account name and one for the average amount spent on each paper type.
SELECT a.name, 
AVG(o.standard_amt_usd) AS avg_stardard_amt_usd, 
AVG(o.gloss_amt_usd) AS avg_gloss_amt_usd, 
AVG(o.poster_amt_usd) AS avg_poster_amt_usd
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name;


--Determine the number of times a particular channel was used in the web_events table for each sales rep. 
--Your final table should have three columns - the name of the sales rep, the channel, 
--and the number of occurrences. Order your table with the highest number of occurrences first.
SELECT s.name, w.channel, COUNT(*) num_events
FROM sales_reps s
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN web_events w
ON w.account_id = a.id
GROUP BY s.name, w.channel
ORDER BY num_events DESC;
-- (you can use the alias chosen for a column in an ORDER BY clause)


--Determine the number of times a particular channel was used 
--in the web_events table for each region. Your final table should have three columns - 
--the region name, the channel, and the number of occurrences. Order your table with the highest number of occurrences first.
SELECT r.name, w.channel, COUNT(*) num_events
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN web_events w
ON a.id = w.account_id
GROUP BY r.name, w.channel
ORDER BY num_events DESC;

--Use DISTINCT to test if there are any accounts associated with more than one region.

-- The below two queries have the same number of resulting rows, so we know that each account
-- is associated with only one region. 
-- If each account was associated with more than one region, the first query 
-- should have returned more rows than the second query.
SELECT a.id AS "account id", r.id AS "region id",
a.name as "account name", r.name AS "region name"
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
JOIN region r
ON r.id = s.region_id;
-- This query returns all account ids and names with the associated region id and name.

--and
SELECT DISTINCT id, name
FROM accounts;
-- This query returns the number of distinct accounts


--Have any sales reps worked on more than one account?
-- Both queries below retun equal number of rows (one row per each sales rep).
-- The first query contains the number of accounts associated with each sales rep 
-- in the column num_accounts
SELECT s.id, s.name, COUNT(*) num_accounts
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.id, s.name
ORDER BY num_accounts;

--and
SELECT DISTINCT id, name
FROM sales_reps;

--How many of the sales reps have more than 5 accounts that they manage? (34)
SELECT a.sales_rep_id, COUNT(*) num_accounts
FROM accounts a
GROUP BY a.sales_rep_id
HAVING COUNT(*) > 5
ORDER BY COUNT(*) DESC;

-- a) Variant from solution using JOIN to get sales rep name from sales_reps table :
SELECT s.id, s.name, COUNT(*) num_accounts
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.id, s.name
HAVING COUNT(*) > 5
ORDER BY num_accounts;

-- b) Variant using subquery
SELECT COUNT(*) num_reps_above5
FROM(SELECT s.id, s.name, COUNT(*) num_accounts
        FROM accounts a
        JOIN sales_reps s
        ON s.id = a.sales_rep_id
        GROUP BY s.id, s.name
        HAVING COUNT(*) > 5
        ORDER BY num_accounts) AS Table1;
-- The previous query is used as suquery that is treated as a table Table1;
-- The part of code not included in the subquery is used to count the number
-- of rows in table one. The result is one column named 'num_reps_above5' 
-- that contains one value (34).



--How many accounts have more than 20 orders? (120)
SELECT o.account_id, COUNT(*) num_orders
FROM orders o
GROUP BY o.account_id
HAVING COUNT(*) > 20
ORDER BY o.account_id;

-- Variant with JOIN and account name:
SELECT a.id, a.name, COUNT(*) num_orders
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
HAVING COUNT(*) > 20
ORDER BY num_orders;


--Which account has the most orders?
SELECT o.account_id, a.name, COUNT(*) num_orders
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY o.account_id, a.name
ORDER BY num_orders DESC
LIMIT 1;


--Which accounts spent more than 30,000 usd total across all orders?
SELECT o.account_id, a.name, SUM(total_amt_usd) AS total_amt_spent
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY o.account_id, a.name
HAVING SUM(total_amt_usd) > 30000
ORDER BY total_amt_spent DESC;


--Which accounts spent less than 1,000 usd total across all orders?
SELECT o.account_id, a.name, SUM(total_amt_usd) AS total_amt_spent
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY o.account_id, a.name
HAVING SUM(total_amt_usd) < 1000 -- variant: HAVING SUM(o.total_amt_usd) < 1000
ORDER BY SUM(total_amt_usd) DESC;


--Which account has spent the most with us?
SELECT o.account_id, a.name, SUM(total_amt_usd) AS total_amt_spent
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY o.account_id, a.name
ORDER BY total_amt_spent DESC
LIMIT 1;


--Which account has spent the least with us?
SELECT o.account_id, a.name, SUM(total_amt_usd) AS total_amt_spent
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY o.account_id, a.name
ORDER BY total_amt_spent
LIMIT 1;


--Which accounts used facebook as a channel to contact customers more than 6 times?
SELECT a.id, a.name, w.channel, COUNT(*) use_of_channel
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
GROUP BY a.id, a.name, w.channel
HAVING COUNT(*) > 6 AND w.channel = 'facebook'
ORDER BY use_of_channel;


--Which account used facebook most as a channel? (Gilead Sciences)
SELECT a.id, a.name, w.channel, COUNT(*) use_of_channel
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
WHERE w.channel = 'facebook'
GROUP BY a.id, a.name, w.channel
ORDER BY use_of_channel DESC
LIMIT 1;
-- This query does not work if there are several accounts with the same maximum number of times when the channel was used.
-- It is a best practice to use a larger limit number first such as 3 or 5 to see 
-- if there are several accounts associated with the same number before using LIMIT 1.


--Which channel was most frequently used by most accounts?
SELECT a.id, a.name, w.channel, COUNT(*) use_of_channel
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
GROUP BY a.id, a.name, w.channel
ORDER BY COUNT(*) DESC
LIMIT 10;
-- We are looking at channels with maximum number of uses and looking at ten maximum numbers of uses
-- to see what channels where most frequently used.


--Find the sales in terms of total dollars for all orders in each year, 
--ordered from greatest to least. Do you notice any trends in the yearly sales totals?
SELECT SUM(total_amt_usd), DATE_TRUNC('year', occurred_at) AS year
FROM orders
GROUP BY year
ORDER BY SUM(total_amt_usd) DESC;

-- Variant
SELECT DATE_PART('year', occurred_at) ord_year, SUM(total_amt_usd) total_spent
FROM orders
GROUP BY 1
ORDER BY 2 DESC;

-- To look in more detail at the monthly totals:
SELECT DATE_TRUNC('month', occurred_at) ord_year,  SUM(total_amt_usd) total_spent
FROM orders
GROUP BY 1
ORDER BY 1;
-- The totals for 2013 and 2017 are the smallest, but only one month for both of the years is included in the database.
-- As the total has been growing from 2014 to 2016 included, it may be expected that the greatest sales 
-- in terms of total dollars will be in 2017.


--Which month did Parch & Posey have the greatest sales in terms of total dollars?
--Are all months evenly represented by the dataset?
SELECT DATE_PART('month', occurred_at) ord_month, SUM(total_amt_usd) total_spent
FROM orders
WHERE occurred_at BETWEEN '2014-01-01' AND '2017-01-01'
GROUP BY 1
ORDER BY 2 DESC;
-- As for 2013 and 2017 there is only one month in the database, only years 2014, 2015 and 2016 were included in the query.

--Which year did Parch & Posey have the greatest sales in terms of total number of orders? 
--Are all years evenly represented by the dataset?
SELECT DATE_PART('year', occurred_at) ord_year, COUNT(*) total_sales
FROM orders
GROUP BY 1
ORDER BY 2 DESC;
-- The greatest number of orders was in 2016; the years are quite different in termos of the number 
-- of orders: from the minimum of 25 orders in 2017 to the maximum of 3757 orders in 2016


--Which month did Parch & Posey have the greatest sales in terms of total number of orders?
--Are all months evenly represented by the dataset? 
SELECT DATE_PART('month', occurred_at) ord_month, COUNT(*) total_sales
FROM orders
WHERE occurred_at BETWEEN '2014-01-01' AND '2017-01-01'
GROUP BY 1
ORDER BY 2 DESC;
-- No, the smallest number of orders is in February, the greatest number of orders is in December.


--In which month of which year did Walmart spend the most on gloss paper in terms of dollars?
SELECT DATE_TRUNC('month', o.occurred_at) ord_date, SUM(o.gloss_amt_usd) AS total_spent
FROM orders o
JOIN accounts a
ON a.id = o.account_id
WHERE a.name = 'Walmart'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;
-- In May 2016

-- Write a query to display for each order, the account ID, total amount of the order, 
-- and the level of the order - ‘Large’ or ’Small’ - 
--depending on if the order is $3000 or more, or smaller than $3000.
SELECT account_id, total_amt_usd,
        CASE WHEN total_amt_usd > 3000 THEN 'Large' 
        ELSE 'Small' END AS order_level
FROM orders;


-- Write a query to display the number of orders in each of three categories, 
-- based on the total number of items in each order. The three categories are: 
--'At Least 2000', 'Between 1000 and 2000' and 'Less than 1000'.
SELECT CASE WHEN total >=2000 THEN 'At least 2000'
WHEN total < 2000 AND total >= 1000 THEN 'Between 1000 and 2000'
ELSE 'Less than 1000' END AS order_category,
COUNT(*) AS order_count
FROM orders
GROUP BY 1
ORDER BY 2 DESC;


-- We would like to understand 3 different levels of customers based on the amount associated with their purchases.
-- The top level includes anyone with a Lifetime Value (total sales of all orders) greater than 200,000 usd. 
--The second level is between 200,000 and 100,000 usd. The lowest level is anyone under 100,000 usd. 
--Provide a table that includes the level associated with each account. 
--You should provide the account name, the total sales of all orders for the customer, and the level. 
--Order with the top spending customers listed first.
SELECT a.name, SUM(total_amt_usd) total_spent, 
        CASE WHEN SUM(total_amt_usd) > 200000 THEN 'top'
        WHEN SUM(total_amt_usd) > 100000 THEN 'middle'
        ELSE 'low' END AS customer_level
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY 1 -- variant: GROUP BY a.name
ORDER BY 2 DESC;

--We would now like to perform a similar calculation to the first, but we want to obtain the total amount spent by customers 
--only in 2016 and 2017. Keep the same levels as in the previous question. 
--Order with the top spending customers listed first.
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
-- The database contained only orders up to year 2017, 
--that's why it was okay to select all orders with timestamps greater than December 31, 2015

--We would like to identify top performing sales reps, which are sales reps associated with more than 200 orders. 
--Create a table with the sales rep name, the total number of orders, and a column with top or not 
--depending on if they have more than 200 orders. Place the top sales people first in your final table.
SELECT s.name, COUNT(*) num_orders, 
        CASE WHEN COUNT(*) > 200 THEN 'top'
        ELSE 'not' END AS sales_rep_level
FROM sales_reps s
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
GROUP BY 1
ORDER BY 2 DESC;
-- This assumes that each name is unique; otherwise you should group by the name and the id of the table.
-- to make top sales people appear first, we sorted the rows containg the words 'top' or 'not' in descending 
-- (reverse alphabetical) order. As 't' appears later in the alphabet than 'n', rows containing 'top' in sales_rep_level column
-- will appear first when we use reverse alphabetical order on this column.


--The previous didn't account for the middle, nor the dollar amount associated with the sales. 
--Management decides they want to see these characteristics represented as well. 
--We would like to identify top performing sales reps, which are sales reps associated with more than 200 orders 
--or more than 750000 in total sales. The middle group has any rep with more than 150 orders or 500000 in sales. 
--Create a table with the sales rep name, the total number of orders, total sales across all orders,
-- and a column with top, middle, or low depending on this criteria. 
--Place the top sales people based on dollar amount of sales first in your final table. 
--You might see a few upset sales people by this criteria!
SELECT s.name, COUNT(*), SUM(o.total_amt_usd) AS total_spent,
        CASE WHEN COUNT(*) > 200 OR SUM(total_amt_usd) > 750000 THEN 'top'
        WHEN COUNT(*) > 150 OR  SUM(total_amt_usd) > 500000 THEN 'middle'
        ELSE 'low' END AS sales_rep_level
FROM sales_reps s
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
GROUP BY 1 --variant: GROUP BY s.name
ORDER BY 3 DESC;


--Use DATE_TRUNC to pull month level information about the first order ever placed in the orders table
SELECT DATE_TRUNC('month', MIN(occurred_at)) 
FROM orders;

-- Use the result of the previous query to find only the orders that took place in the same month and year
-- as the first order, and then pull the average for each type of paper qty in this month.
SELECT AVG(standard_qty) avg_std, AVG(gloss_qty) avg_gls, AVG(poster_qty) AS avg_pst
FROM orders
WHERE DATE_TRUNC('month', occurred_at) = 
	(SELECT DATE_TRUNC('month', MIN(occurred_at)) FROM orders); 


--Getting total amount spend on all ordes on the same month that the first order was placed 
SELECT SUM(total_amt_usd) 
FROM orders
WHERE DATE_TRUNC('month', occurred_at) = 
		(SELECT DATE_TRUNC('month', MIN(occurred_at)) FROM orders);


-- Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.


-- For the region with the largest (sum) of sales total_amt_usd, how many total (count) orders were placed?

SELECT *
FROM
	(SELECT r.name AS region_name, s.id AS sales_rep_id, s.name AS sales_rep_name, 
		SUM(o.total_amt_usd) AS total_spent
		FROM sales_reps s
		JOIN region r
		ON s.region_id = r.id
		JOIN accounts a
		ON s.id = a.sales_rep_id
		JOIN orders o
		ON a.id = o.account_id
		GROUP BY 1, 2, 3
                ORDER BY 1) total_by_sales_rep;



SELECT region_name, MAX(total_spent)
FROM
	(SELECT r.name AS region_name, s.id AS sales_rep_id, s.name AS sales_rep_name, 
		SUM(o.total_amt_usd) AS total_spent
		FROM sales_reps s
		JOIN region r
		ON s.region_id = r.id
		JOIN accounts a
		ON s.id = a.sales_rep_id
		JOIN orders o
		ON a.id = o.account_id
		GROUP BY 1, 2, 3
                ORDER BY 1) total_by_sales_rep
GROUP BY 1, 3, 4;


-- Getting max amount of sales by one sales rep per region
SELECT region_name, MAX(total_spent)
FROM
	(SELECT r.name AS region_name, s.id AS sales_rep_id, s.name AS sales_rep_name, 
		SUM(o.total_amt_usd) AS total_spent
		FROM sales_reps s
		JOIN region r
		ON s.region_id = r.id
		JOIN accounts a
		ON s.id = a.sales_rep_id
		JOIN orders o
		ON a.id = o.account_id
		GROUP BY 1, 2, 3
        ORDER BY 1) total_by_sales_rep
GROUP BY region_name;




--How many accounts had more total purchases than the account name 
--which has bought the most standard_qty paper throughout their lifetime as a customer?


--For the customer that spent the most (in total over their lifetime as a customer) total_amt_usd, 
--how many web_events did they have for each channel?


--What is the lifetime average amount spent in terms of total_amt_usd for the top 10 total spending accounts?


--What is the lifetime average amount spent in terms of total_amt_usd, 
--including only the companies that spent more per order, on average, than the average of all orders.