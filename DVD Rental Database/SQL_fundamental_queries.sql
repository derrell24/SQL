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

The above code gives same result as the following:

SELECT customer_id, rental_id,return_date
FROM rental
WHERE customer_id = 7
OR customer_id = 13
OR customer_id = 10
ORDER BY return_date DESC;


