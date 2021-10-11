-- ************************************ SELECT STATEMENT *****************************************
SELECT * FROM actor; --selecting all columns, ; to notify the end of the query
SELECT last_name, first_name FROM actor; --selecting specific coloumns
 
--Use a SELECT statement to grab first and last names of every customer and their email address
SELECT first_name,last_name,email FROM customer;

-- ************************************ SELECT DISTINCT STATEMENT ********************************
--How many different release years in the film database?
SELECT * FROM film;
SELECT DISTINCT(release_year) FROM film; --parenthesis optional for DISTINCT

--What are the different rental rates for dvds?
SELECT DISTINCT(rental_rate) FROM film;

--What different MPAA movie ratings are present in the database?
SELECT DISTINCT(rating) FROM film;

-- ************************************ COUNT STATEMENT ******************************************
SELECT * FROM film;
SELECT COUNT(*) FROM payment; --parenthesis required for COUNT
--How many unique amounts are present in the payment table?
SELECT COUNT(DISTINCT(amount)) FROM payment;

-- ************************************ WHERE STATEMENT ******************************************
SELECT * FROM customer
WHERE first_name = 'Jared';

SELECT * FROM film
WHERE rental_rate > 4 AND replacement_cost>=19.99 AND rating = 'R';

SELECT COUNT(*) FROM film --u can put * or any column
WHERE rental_rate > 4 AND replacement_cost>=19.99 AND rating = 'R';

SELECT * FROM film
WHERE rating !='R';

-- A customer forgot their wallet at our store! We need to track down their email to inform them.
-- What's the name for the customer with the name Nancy Thomas?

SELECT email FROM customer
WHERE first_name = 'Nancy' 
AND last_name = 'Thomas';

-- A customer wants to know what the movie "Outlaw Hanky" is about.
-- Could you give them the description for the movie "Outlaw Hanky"?

SELECT description FROM film
WHERE title = 'Outlaw Hanky';

-- A customer is late on their movie return. I know their address is '259 Ipoh Drive'. I want to call them to let them know!
-- Can you get me the phone number for the person who lives at '259 Ipoh Drive'?

SELECT phone FROM address
WHERE address = '259 Ipoh Drive';

-- ************************************ ORDER BY STATEMENT ******************************************
SELECT * FROM customer
ORDER BY first_name DESC;

SELECT store_id,first_name,last_name FROM customer
ORDER BY store_id,first_name;

-- ************************************ LIMIT STATEMENT *********************************************
--What are the five most recent payments that are not zero?
SELECT * FROM payment
WHERE amount !=0.00
ORDER BY payment_date DESC
LIMIT 5;

--Get the customer ID numbers for the top 10 highest payment amounts

SELECT customer_id, amount FROM payment
ORDER BY amount DESC
LIMIT 10;

-- Get the titles of the movies with film ids 1-5.

SELECT title, film_id FROM film
ORDER BY film_id   --sorts ASC by default
LIMIT 5;

--Get titles of 5 shortest movies.

SELECT title,length FROM film
ORDER BY length 
LIMIT 5; --there might be more movies with the same length changing limit might help to see them

--If the previous customer can watch any movie <= 50 min how many options does she have?

SELECT COUNT(*) FROM film
WHERE length <=50 
LIMIT 5; 

-- ************************************ BETWEEN STATEMENT *****************************************

SELECT customer_id, amount FROM payment
WHERE amount BETWEEN 8 and 9;

SELECT customer_id, amount FROM payment
WHERE amount NOT BETWEEN 8 and 9;

SELECT AMOUNT, PAYMENT_DATE FROM PAYMENT
WHERE PAYMENT_DATE BETWEEN '2007-02-07' AND '2007-02-15';

-- ************************************ IN STATEMENT *****************************************/*
SELECT COUNT(*) FROM payment
WHERE amount NOT IN (0.99,1.98,1.99);

SELECT * FROM customer
WHERE first_name IN ('John','Jake','Julie');

SELECT customer_id, rental_id,return_date
FROM rental
WHERE customer_id IN (1,2)
ORDER BY return_date DESC;


SELECT customer_id, rental_id,return_date
FROM rental
WHERE customer_id IN (7,13,10)
ORDER BY return_date DESC;

--The above code gives same result as the following:

SELECT customer_id, rental_id,return_date
FROM rental
WHERE customer_id = 7
OR customer_id = 13
OR customer_id = 10
ORDER BY return_date DESC;

-- ************************************ LIKE Statement *****************************************

SELECT first_name,last_name
FROM customer
WHERE first_name LIKE 'Jen%';  --First name that starts with Jen

SELECT first_name, last_name
FROM customer
WHERE first_name LIKE 'Jen%';


SELECT first_name, last_name
FROM customer
WHERE first_name LIKE '%y'; -- for first names that end in 'y'

SELECT first_name, last_name
FROM customer
WHERE first_name LIKE '%er%'; -- for first names that have 'er' between the first and last letter.

SELECT first_name, last_name
FROM customer
WHERE first_name LIKE '_her%'; -- returns first names that have only a single character followed by "her"

-- ILIKE operator removes case-sensitivity!!

SELECT first_name, last_name
FROM customer
WHERE first_name ILIKE 'BaR%'; 

SELECT * FROM customer
WHERE first_name LIKE 'A%' AND last_name NOT LIKE 'B%'
ORDER BY last_name;

----CHALLENGE----

-- How many payment transactions were greater than $5.00?

SELECT COUNT (amount) FROM payment
WHERE amount > 5.00;

-- How many actors have a first name that starts with the letter P?

SELECT first_name FROM actor
WHERE first_name LIKE 'P%';

SELECT COUNT(*) FROM actor --difference: returning the count number, not the first names
WHERE first_name LIKE 'P%';

--How many unique districts are our customers from?

SELECT COUNT (DISTINCT(district)) --SELECTing the COUNT of each DISTINCT district
FROM address;

-- Retrieve the list of names for those distinct districts from the previous question

SELECT DISTINCT(district) --removing COUNT from the query
FROM address;

-- How many films have a rating of R and a replacement cost between $5 and $15?
     
SELECT COUNT(*) FROM film --count the rows returned
WHERE rating = 'R'
AND replacement_cost BETWEEN 5 AND 15;

  
-- How many films have the word Truman somewhere in the title?

SELECT COUNT(*) FROM film
WHERE title LIKE '%Truman%';

-- ************************************ AGGREGATE Statement *****************************************
SELECT MIN(replacement_cost) FROM film;
SELECT MAX(Amount),ROUND(AVG(Amount),2),COUNT(Amount),SUM(Amount) FROM payment;


-- ************************************ GROUP BY Statement *****************************************
SELECT customer_id
FROM payment
GROUP BY customer_id
ORDER BY customer_id ASC; --Simple group by 


--What customer is spending the most money?
SELECT customer_id, SUM(amount)
FROM payment
GROUP BY customer_id;

--Amount processed each day
SELECT customer_id,staff_id, SUM(amount)
FROM payment
GROUP BY staff_id, customer_id
ORDER BY customer_id;


SELECT DATE(payment_date),SUM(amount) 
FROM payment -- removes time stamp information
GROUP BY DATE(payment_date)
ORDER BY SUM(amount) DESC;

-- We have two staff members with Staff IDs 1 and 2. We want to give a bonus to the staff member that handled the most payments.
-- How many payments did each staff member handle? And how much was the total amount processed by each staff member?

SELECT staff_id,COUNT(AMOUNT) AS Transaction_number,SUM(AMOUNT) AS total_amount 
FROM payment
GROUP BY staff_id
ORDER BY COUNT(AMOUNT);

-- Corporate headquarters is auditing our store! They want to know the average replacement cost of movies by rating.
--For example, R rated movies have an average replacement cost of $20.23

SELECT rating, ROUND(AVG(replacement_cost),2)
FROM film
GROUP BY rating;


-- We want to send coupons to the top 5 customers who have spent the most amount of money. Get the customer IDs of the top 5 spenders.

SELECT customer_id, SUM(amount) 
FROM payment 
GROUP BY customer_id
ORDER BY SUM(amount) DESC 
LIMIT 5; 

-- ************************************ HAVING Statement *****************************************
--having allows us to use aggregrate result as a filter along with a GROUP BY
SELECT customer_id, SUM(amount) 
FROM payment
GROUP BY customer_id;

SELECT customer_id, SUM(amount) 
FROM payment
GROUP BY customer_id
HAVING SUM(amount)>100;

SELECT store_id, COUNT(customer_id)
FROM customer
GROUP BY store_id
HAVING COUNT (customer_id) > 300;

/* We want to know what customers are eligible for our platinum credit card.  The requirements are
	that the customer has at least a total of 40 transaction payments.
	What customers (by customer_id) are eligible for the credit card? */

SELECT customer_id, COUNT(amount)
FROM payment
GROUP BY customer_id
HAVING COUNT(amount) >= 40;

   
-- When grouped by rating, what movie ratings have an average rental duration of more than 5 days?

SELECT rating, AVG(rental_duration)
FROM film
GROUP BY rating
HAVING AVG(rental_duration) > 5;
--*****************************************		ASSESSMENT TEST 1 	*************************************
/* Return the customer IDs of customers who have spent at least $110 with the staff member who has an ID of 2 */
SELECT staff_id,customer_id, SUM(amount) 
FROM payment
GROUP BY staff_id,customer_id
HAVING staff_id = 2 AND SUM(amount)>=110;

--OR
SELECT customer_id, SUM(amount)
FROM payment
WHERE staff_id = 2
GROUP BY customer_id
HAVING SUM(amount)>=110;

/*How many films begin with the letter J?*/
SELECT COUNT(title) 
FROM film
WHERE title LIKE 'J%';

/*What customer has the highest customer ID number whose name starts with an 'E' and has an address ID lower than 500?*/
SELECT first_name,last_name 
FROM customer
WHERE first_name LIKE 'E%' AND address_id <500
ORDER BY customer_id DESC
LIMIT 1	;

/*Concatenate names*/
SELECT 
    RTRIM(LTRIM(
        CONCAT(
            COALESCE(first_name, ''),' '
            , COALESCE(last_name, '')
        )
    )) AS Name
FROM customer

--*****************************************		AS  statement 	*************************************
SELECT payment_id 
AS my_payment_column  
FROM payment;

SELECT customer_id, SUM (amount) 
AS total_spent  
FROM payment
GROUP BY customer_id;


-- ************************************ INNER JOIN Statement *****************************************
--Get customer email associated with a specific payment
SELECT payment.customer_id,email,amount 
FROM payment
INNER JOIN customer 
ON payment.customer_id = customer.customer_id;

SELECT customer.customer_id, first_name, last_name, email, amount, payment_date
FROM customer
INNER JOIN payment 
ON payment.customer_id = customer.customer_id
WHERE customer.customer_id = 2;  -- gives all of customer 2's payments

--  staff/payment join on staff_id to see employee names with payments
SELECT payment_id, amount, first_name, last_name 
FROM payment
JOIN staff ON payment.staff_id = staff.staff_id; -- in most SQL engines, you dont have to specify INNER JOIN, just JOIN is fine.
 
SELECT store_id,title
FROM inventory
JOIN film ON inventory.film_id = film.film_id;
-- This returned all the instances of a particular title... i.e, number of copies of each dvd by title. Find how many copies of each movie are at store_id # 1"

SELECT title, COUNT (title) AS "Stock"  
FROM inventory
JOIN film ON inventory.film_id = film.film_id  
WHERE store_id = 1
GROUP BY title
ORDER BY title;

SELECT film.title, lang.name AS Movie_Language 
FROM film
JOIN language AS lang ON film.language_id = lang.language_id
ORDER BY title;

-- ************************************ FULL OUTER JOIN Statement *****************************************
SELECT * FROM customer
FULL OUTER JOIN payment
ON customer.customer_id = payment.customer_id;

SELECT * FROM customer
FULL OUTER JOIN payment
ON customer.customer_id = payment.customer_id
WHERE customer.customer_id IS null
OR payment.payment_id IS null;  --each customer_id has a payment_id


-- ************************************ LEFT OUTER JOIN Statement *****************************************
SELECT film.film_id, film.title, inventory_id,store_id
FROM film
LEFT OUTER JOIN inventory ON inventory.film_id = film.film_id
WHERE inventory.film_id IS null;-- movies we have info but not in inventory or store


-- ************************************ RIGHT OUTER JOIN Statement *****************************************

SELECT film.film_id, film.title, inventory_id,store_id
FROM film
RIGHT OUTER JOIN inventory ON inventory.film_id = film.film_id;

-- ************************************ UNION Statement *****************************************

/*California sales tax laws have changed and we need to alert our customers to this through gmail. What are the emails of customers who live 
in california*/
SELECT district,email FROM address
INNER JOIN customer ON address.address_id = customer.address_id
WHERE district ILIKE 'cali%';

/*A customer walks in and is a huge fan of the actor "Nick Wahlberg" and wants to know which movie he is in . Get a list of moviees Nick Walhberg has been in */
SELECT title,first_name,last_name FROM film
INNER JOIN film_actor ON film.film_id = film_actor.film_id
INNER JOIN actor ON actor.actor_id = film_actor.actor_id
WHERE first_name = 'Nick' AND last_name = 'Wahlberg'
