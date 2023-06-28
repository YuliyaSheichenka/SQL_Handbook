
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
ORDER BY o.occurred_at DESC;