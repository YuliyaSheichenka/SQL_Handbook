
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


