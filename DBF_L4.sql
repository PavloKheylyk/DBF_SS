--L4 Subquery, Practice:
SELECT customerid, shipcountry
FROM orders
WHERE shipcountry IN (SELECT country FROM employees);

--TASK1
--Show first and last names of the employees who have the biggest freight.
SELECT CONCAT(firstname,' ', lastname), freight
FROM employees e
JOIN orders o ON o.employeeid = e.employeeid
--WHERE o.freight > (SELECT AVG(freight) FROM orders)
GROUP BY CONCAT(firstname,' ', lastname), freight
ORDER BY 2 DESC;

--Show first, last names of the employees, their freight who have the freight bigger then avarage.
SELECT CONCAT(firstname,' ', lastname), freight
FROM employees e
JOIN orders o ON o.employeeid = e.employeeid
WHERE o.freight > (SELECT AVG(freight) FROM orders)
GROUP BY CONCAT(firstname,' ', lastname), freight;

--Show the names of products, that have the biggest price.
SELECT DISTINCT p.productname, od.unitprice
FROM products p
JOIN order_details od ON od.productid = p.productid
ORDER BY 2 DESC;

update products set unitprice=263.5 where productid=9;

--Show the name of customers with the freight bigger then avarage.
SELECT c.companyname, freight
FROM customers c
JOIN orders o ON o.customerid = c.customerid
WHERE o.freight > (SELECT AVG(freight) FROM orders)
GROUP BY companyname, freight;

--Show the name of supplier  who delivered the cheapest product.
SELECT s.companyname, p.unitprice
FROM suppliers s
JOIN products p ON p.supplierid = s.supplierid
WHERE unitprice = (SELECT MIN(unitprice) FROM products);

--TASK2
--Show the name of the category in which the average price of 
--a certain product is greater than the grand average in the whole stock
SELECT categoryname, ROUND(AVG(unitprice))
FROM products p
JOIN categories c ON c.categoryid = p.categoryid
GROUP BY categoryname
HAVING AVG(p.unitprice) > (SELECT AVG(unitprice) FROM products);

--Show the name of the supplier whose delivery  is lower then the grand average(quantity, 23.8) in the whole stock.
SELECT DISTINCT s.companyname, od.quantity
FROM suppliers s
JOIN products p ON p.supplierid = s.supplierid
JOIN order_details od ON od.productid = p.productid
GROUP BY companyname, od.quantity
HAVING od.quantity < (SELECT quantity FROM order_details)
ORDER BY 1;

--Show the regions where employees work, the average age of which is higher than over the whole company.
SELECT CONCAT(firstname,' ', lastname), region
FROM employees;
--WHERE o.freight > (SELECT AVG(freight) FROM orders)

SELECT *
FROM suppliers;

--Show customers whose maximum freight level is less than the average for all customers.
SELECT c.contactname, freight
FROM customers c
JOIN orders o ON o.customerid = c.customerid
GROUP BY c.contactname, freight
HAVING MAX(o.freight) > (SELECT AVG(freight) FROM orders);

--Show the categories of products for which the average discount is
--higher than the average discount for all products

--TASK3  PRACTICE
--Calculate the average freight of all employees who work not with Western region.
SELECT CONCAT(firstname,' ', lastname), region.regiondescription, ROUND(AVG(freight))
FROM employees e
JOIN orders o ON o.employeeid = e.employeeid
JOIN employeeterritories et ON et.employeeid = e.employeeid
NATURAL JOIN territories
JOIN region ON region.regionid = territories.regionid
WHERE regiondescription NOT LIKE 'Western'
GROUP BY CONCAT(firstname,' ', lastname), region.regiondescription;


--Show first and last names of employees who shipped orders in cities of USA.
SELECT CONCAT(firstname,' ', lastname)
FROM employees
NATURAL JOIN orders
WHERE orderid IN (SELECT orderid FROM orders WHERE shipcountry like 'USA');

SELECT CONCAT(firstname,' ', lastname)
FROM employees
JOIN orders ON orders.employeeid = employees.employeeid
WHERE orderid IN (SELECT orderid FROM orders WHERE shipcountry like 'USA');

--Show the names of products and their total cost, which were delivered by German suppliers
SELECT productname, ROUND(od.quantity*od.unitprice) total_cost, s.country
FROM products p
JOIN order_details od ON od.productid = p.productid
JOIN suppliers s ON s.supplierid = p.supplierid
WHERE s.country LIKE 'Germany'
GROUP BY productname, s.country, ROUND(od.quantity*od.unitprice);


--Show first and last names of employees that don’t work with Eastern region.
SELECT CONCAT(firstname,' ', lastname), region.regiondescription
FROM employees e
JOIN orders o ON o.employeeid = e.employeeid
JOIN employeeterritories et ON et.employeeid = e.employeeid
NATURAL JOIN territories
JOIN region ON region.regionid = territories.regionid
WHERE regiondescription NOT LIKE 'Eastern'
GROUP BY CONCAT(firstname,' ', lastname), region.regiondescription;

--Show the name of customers that prefer to order non-domestic products.
SELECT companyname
FROM customers
WHERE (SELECT COUNT(products.productid) non_domestic
FROM customers c
NATURAL JOIN orders
NATURAL JOIN order_details
NATURAL JOIN products
JOIN suppliers s ON s.supplierid = products.supplierid
WHERE c.country != s.country AND c.customerid = customers.customerid)
>
(SELECT COUNT(products.productid) domestic
FROM customers c
NATURAL JOIN orders
NATURAL JOIN order_details
NATURAL JOIN products
JOIN suppliers s ON s.supplierid = products.supplierid
WHERE c.country = s.country AND c.customerid = customers.customerid);

--TASK4
--Show employees (first and last name) working with orders from the United States.
SELECT CONCAT(firstname,' ', lastname)
FROM employees
JOIN orders ON orders.employeeid = employees.employeeid
WHERE orderid IN (SELECT orderid FROM orders WHERE shipcountry like 'USA');

--Show the info about orders, that contain the cheapest products from USA.
SELECT o.orderid, o.customerid, s.country, MIN(od.unitprice)
FROM orders o
JOIN order_details od ON od.orderid = o.orderid
JOIN products p ON p.productid = od.productid
JOIN suppliers s ON s.supplierid = p.supplierid
WHERE s.country LIKE 'USA'
GROUP BY o.orderid, o.customerid, s.country;

--Show the info about customers that !!!NOT!!!!prefer to order meat products and never order drinks.
SELECT cs.companyname, c.description
FROM customers cs
JOIN orders o ON o.customerid = cs.customerid
JOIN order_details od ON od.orderid = o.orderid 
JOIN products p ON p.productid = od.productid
JOIN categories c ON c.categoryid = p.categoryid
WHERE c.description LIKE '%meat%' AND c.description NOT LIKE '%drinks%' AND 
(SELECT COUNT(categoryname) FROM categories WHERE description LIKE '%meat%')
< 
(SELECT COUNT(categoryname) FROM categories WHERE description NOT LIKE '%meat%');

--Show the list of cities where employees and customers are from and where orders have been made to. Duplicates should be eliminated
SELECT DISTINCT e.city, o.shipcity
FROM employees E 
JOIN orders o ON o.employeeid = E.employeeid
JOIN customers c ON c.customerid = o.customerid
WHERE e.city = c.city AND e.city = o.shipcity;

--Show the lists the product names that order quantity equals to 100.
SELECT productname, od.quantity
FROM products p 
JOIN order_details od ON od.productid = p.productid
WHERE od.quantity = 100;

--TASK5------
--Show the lists the suppliers with a product price equal to 10$.
SELECT s.companyname, p.unitprice
FROM suppliers s
JOIN products p ON p.supplierid = s.supplierid  
WHERE p.unitprice = 10;

--Show the list of employee that perform orders with freight 1000.
SELECT CONCAT(e.firstname,' ', e.lastname), o.freight
FROM employees e
JOIN orders o ON o.employeeid = e.employeeid
WHERE o.freight > 100
GROUP BY CONCAT(e.firstname,' ', e.lastname), o.freight;

--Find the Companies that placed orders in 1997
SELECT DISTINCT c.companyname, o.orderdate
FROM customers c
JOIN orders o ON o.customerid = c.customerid 
WHERE date_part('YEAR', o.orderdate) = 1997;

--Create a report that shows all products by name that are in the Seafood category.
SELECT p.productname, c.description
FROM  products p
JOIN categories c ON c.categoryid = p.categoryid
WHERE c.description LIKE '%Seafood%'


--Create a report that shows all companies by name that sell products in the Dairy Products category.
SELECT DISTINCT s.companyname, c.categoryname
FROM suppliers s
JOIN products p ON p.supplierid = s.supplierid  
JOIN categories c ON c.categoryid = p.categoryid
WHERE c.categoryname LIKE '%Dairy%';

--HOME_WORK---------------------------
--Create a report that shows the product name and supplier id 
--for all products supplied by Exotic Liquids, Grandma Kelly's Homestead, and Tokyo Traders.
SELECT p.productname, s.supplierid, s.companyname
FROM suppliers s
JOIN products p ON p.supplierid = s.supplierid
WHERE s.companyname IN ('Exotic Liquids','Grandma Kelly''s Homestead', 'Tokyo Traders');

--Create a report that shows all the products which are supplied by a company called ‘Pavlova, Ltd.’.
SELECT p.productname, s.companyname
FROM suppliers s
JOIN products p ON p.supplierid = s.supplierid
WHERE s.companyname LIKE 'Pavlova, Ltd.';

--Create a report that shows the orders placed by all the customers excluding the customers who belongs to London city.
SELECT o.orderid, o.orderdate, c.companyname, c.city customer_city
FROM customers c
JOIN orders o ON o.customerid = c.customerid
WHERE c.city NOT LIKE 'London';

--Create a report that shows all the customers if there are more than 30??????? orders shipped in London city.
SELECT c.companyname, o.shipcity
FROM customers c
JOIN orders o ON o.customerid = c.customerid
WHERE (SELECT COUNT(customerid) FROM orders) > 30 AND o.shipcity LIKE 'London'
GROUP BY c.companyname, o.shipcity;

--Create a report that shows all the orders where the employee’s city and order’s ship city are same.
SELECT o.orderid, e.city customer_city, o.shipcity
FROM employees e
JOIN orders o ON o.employeeid = e.employeeid
WHERE e.city = o.shipcity
GROUP BY o.orderid, e.city;



