-- Q1)Write a query that lists every product with its brand name, 



SELECT
    production.products.product_name,
    production.brands.brand_name
FROM production.products
INNER JOIN production.brands
    ON products.brand_id = brands.brand_id;

    --Q2)Using a LEFT JOIN, write a query that finds every store with zero staff currently assigned to it

    SELECT 
    stores.store_id,
    store_name
FROM sales.stores
LEFT JOIN sales.staffs
    ON stores.store_id = staffs.store_id
WHERE staffs.staff_id IS NULL;



--Q3)Explain, in your own words, why the following query returns every product regardless of stock level, and rewrite it so that it only returns products with fewer than 5 units in stock at store 1:


The original query returns every product regardless of stock level because of how a LEFT JOIN operates:

Preserving Left Table Records: A LEFT JOIN retrieves all rows from the left table (production.products), even if there are no matching records in the right table (production.stocks).

Handling Non-Matching Records: If a product has no stock record for store 1 (or has zero stock), the LEFT JOIN still includes the product in the result set, filling the missing quantity column with NULL.

Lack of Proper Filtering: Without an explicit WHERE clause filtering out higher quantities or treating NULL values correctly, the query retains every single product from the products table regardless of its stock level.


SELECT 
    production.products.product_id,
    production.products.product_name,
    ISNULL(production.stocks.quantity, 0) AS stock_quantity
FROM production.products
LEFT JOIN production.stocks
    ON production.products.product_id = production.stocks.product_id
   AND production.stocks.store_id = 1
WHERE ISNULL(production.stocks.quantity, 0) < 5;



--Q4)Write a self join on sales.staffs that lists every manager along with a count placeholder column showing 1 for each employee they manage (you will replace this with a real COUNT in Chapter 3); for now, just produce one row per employee-manager pair



SELECT 
    m.staff_id AS manager_id,
    m.first_name AS manager_first_name,
    m.last_name AS manager_last_name,
    e.staff_id AS employee_id,
    e.first_name AS employee_first_name,
    e.last_name AS employee_last_name,
    1 AS employee_count_placeholder
FROM sales.staffs AS e
INNER JOIN sales.staffs AS m
    ON e.manager_id = m.staff_id;






    --Q5)Write a three-table join across sales.orders, sales.order_items, and production.products that lists every item in order #1, including product name and quantity.



    SELECT 
    sales.orders.order_id,
    production.products.product_name,
    sales.order_items.quantity,
    sales.order_items.list_price
FROM sales.orders
INNER JOIN sales.order_items
    ON sales.orders.order_id = sales.order_items.order_id
INNER JOIN production.products
    ON sales.order_items.product_id = production.products.product_id
WHERE sales.orders.order_id = 1; 




--Q6)A colleague joins orders to order_items and reports "we received 4,658 orders last year." Explain what actually went wrong with that number and how you would find the true order count instead


Explain, in your own words, why the following query returns every product regardless of stock level, and rewrite it so that it only returns products with fewer than 5 units in stock at store 1.

Explanation:
The original query returns every product regardless of stock level because of how a LEFT JOIN operates:

Preserving Left Table Records: A LEFT JOIN retrieves all rows from the left table (production.products), even if there are no matching records in the right table (production.stocks).

Handling Non-Matching Records: If a product has no stock record for store 1 (or has zero stock), the LEFT JOIN still includes the product in the result set, filling the missing quantity column with NULL.

Lack of Proper Filtering: Without an explicit WHERE clause filtering out higher quantities or treating NULL values correctly, the query retains every single product from the products table regardless of its stock level.


SELECT 
    production.products.product_id,
    production.products.product_name,
    ISNULL(production.stocks.quantity, 0) AS stock_quantity
FROM production.products
LEFT JOIN production.stocks
    ON production.products.product_id = production.stocks.product_id
   AND production.stocks.store_id = 1
WHERE ISNULL(production.stocks.quantity, 0) < 5;




Write a self join on sales.staffs that lists every manager along with a count placeholder column showing 1 for each employee they manage (you will replace this with a real COUNT in Chapter 3); for now, just produce one row per employee-manager pair

SELECT 
    m.staff_id AS manager_id,
    m.first_name AS manager_first_name,
    m.last_name AS manager_last_name,
    e.staff_id AS employee_id,
    e.first_name AS employee_first_name,
    e.last_name AS employee_last_name,
    1 AS employee_count_placeholder
FROM sales.staffs AS e
INNER JOIN sales.staffs AS m
    ON e.manager_id = m.staff_id;


    --Q7)Think About It: CROSS JOIN is often considered dangerous because it can accidentally produce millions of rows from two innocent-looking tables. Under what real circumstances would you deliberately want a CROSS JOIN, and how would you guard against using one by accident, for example, by forgetting an ON clause that was meant to be there?



    A CROSS JOIN produces a Cartesian product (combining every row of the first table with every row of the second table). While often avoided, it is deliberately used in specific scenarios:

Generating All Possible Combinations (Product/Option Matrices):

Example: Generating a master catalog of all possible product variations (e.g., combining 5 clothing items with 4 sizes and 3 colors to create 60 unique SKUs).

Date or Time Dimension Tables for Reporting:

Example: Combining a list of all active stores with a list of all 365 calendar dates to build a complete daily inventory report framework, ensuring days with zero sales still show up in final summaries.

Pre-aggregating Benchmarks or Threshold Values:

Example: Joining a table containing a single calculated value (like an overall company KPI or target parameter) across all individual employee or store rows to measure performance against that single threshold.



Accidental Cartesian products usually happen when an ON clause is omitted or misplaced during old-style implicit joins (FROM TableA, TableB). To guard against this:

Enforce Modern ANSI-92 Join Syntax:

Always write explicit join syntax (INNER JOIN ... ON ...). If you forget the ON clause using modern syntax, the SQL engine returns a syntax error instead of executing an accidental Cartesian product.

Enforce Code Reviews & Static Analysis Tools:

Use linters or database tools that flag implicit joins (comma-separated tables in FROM) or CROSS JOIN keywords during code submission or CI/CD pipelines.

Set Execution Limits or Row Guards in Safe Environments:

In development and staging environments, set a maximum row limit or query execution timeout (e.g., SET ROWCOUNT or MAXQUERYTIME) to prevent runaway queries from locking up database memory and disk space.




