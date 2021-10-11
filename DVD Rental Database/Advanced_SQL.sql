--**********************	Timestamps and Extract 		***********************

SHOW ALL; --Shows values of run time parameter
SELECT NOW(); --current Timestamp information 
SELECT TIMEOFDAY(); --timestamp information as string
SELECT CURRENT_TIME;
SELECT CURRENT_DATE;

--*********	EXTRACT function 	*********
SELECT EXTRACT(day FROM payment_date) 
FROM payment;

SELECT customer_id, EXTRACT(day FROM payment_date) AS day
FROM payment;

/*Calculate the total expenditure by month*/
SELECT EXTRACT(month FROM payment_date) AS month,SUM(amount) 
FROM payment
GROUP BY month
ORDER BY month; 

/*Find the highest grossing month*/
SELECT SUM(amount) AS total, EXTRACT(month FROM payment_date) AS month
FROM payment
GROUP BY month  -- Need to use GROUP BY, since we used aggregate function SUM (amount)
ORDER BY SUM(amount) DESC  -- or you can use ORDER BY total
LIMIT 1;

--*********	AGE function 	*********
SELECT AGE(payment_date),payment_date
FROM payment;

--********* TO_CHAR ***********
SELECT TO_CHAR(payment_date,'mm-dd-YYYY')
FROM payment;

--During which months did the payments occur?
SELECT DISTINCT(TO_CHAR(payment_date,'MONTH'))
FROM payment;

--How many payments occured on monday?
SELECT COUNT(amount)
FROM payment
WHERE EXTRACT(dow FROM payment_date) =1; --day of week

--************************* 	Mathematical Functions 		****************************
-- Make a new ID for a specific event, and that ID was 
--		going to be defined by the customer_id, and the rental_id.

SELECT customer_id + rental_id AS new_id -- adding customer_id to rental_id to make new_id
FROM payment;

-- What percentage of replacement cost is the rental rate?
SELECT ROUND(rental_rate/replacement_cost * 100,2) as percent_cost
FROM film;

--**********************		String Functions and Operators		********************************
SELECT LENGTH(first_name) 
FROM customer;

SELECT UPPER(first_name) || ' ' || UPPER(last_name)  as full_name
FROM customer;

--creating an email
SELECT LOWER(LEFT(first_name,1)) || LOWER(last_name) || '@gmail.com' as new_email
FROM customer;

--***********************			SubQuery		***********************************
--  Films who's rental rate is higher than average? 
SELECT film_id,title,rental_rate
FROM film
WHERE rental_rate > (SELECT AVG(rental_rate) 
					 FROM film);
					 

--  film title for movies returned May 29-30
SELECT film_id,title 
FROM film 
WHERE film_id IN
(SELECT inventory.film_id
FROM rental
INNER JOIN inventory ON inventory.inventory_id = rental.inventory_id
WHERE return_date BETWEEN '2005-05-29' AND '2005-05-30')
ORDER BY film_id;


--Customers having at least one payment greater than 11
SELECT first_name,last_name
FROM customer as c
WHERE EXISTS
(SELECT * FROM payment as p
where p.customer_id = c.customer_id 
AND amount > 11)

SELECT first_name,last_name
FROM customer as c
WHERE NOT EXISTS
(SELECT * FROM payment as p
where p.customer_id = c.customer_id 
AND amount > 11)

--********************************	Self Join	****************************************************

-- Use a self join to retrieve all customers whose last name matched the first name of another customer

SELECT a.first_name, a.last_name,b.first_name,b.last_name
FROM customer AS a, customer AS b
WHERE a.first_name = b.last_name;  

-- using a JOIN statement

SELECT a.customer_id, a.first_name, a.last_name, b.customer_id, b.first_name, b.last_name
FROM customer AS a
JOIN customer AS b		-- INNER JOIN after first alias in FROM statement, instead of 2 aliases with comma.
ON a.first_name = b.last_name  -- have to use ON clause with the JOIN, and not the WHERE statement in the self join.
ORDER BY a.customer_id;



--Find all the pair of films that have same length
SELECT f1.title,f2.title, f1.length
FROM film f1
INNER JOIN film AS f2 ON f1.film_id != f2.film_id AND 
f1.length = f2.length;



