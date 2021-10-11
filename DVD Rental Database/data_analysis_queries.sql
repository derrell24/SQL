--What are the top and least in-demand genres and what are their total sales?

WITH 
t1 as (SELECT c.name as Genre,count(cu.customer_id) as total_rental_demand
			FROM category as c
			JOIN film_category fc
			USING(category_id)
			JOIN film as f
			USING(film_id)
			JOIN inventory as i 
			USING(film_id)
			JOIN rental as r 
			USING(inventory_id)
			JOIN customer as cu
			USING(customer_id)
			GROUP by 1
			ORDER by 2 DESC),



t2 AS (SELECT c.name AS Genre, SUM(p.amount) AS total_sales
            FROM category as c
            JOIN film_category as fc
            USING(category_id)
            JOIN film as f
            USING(film_id)
            JOIN inventory as i
            USING(film_id)
            JOIN rental as r
            USING(inventory_id)
            JOIN payment as p
            USING(rental_id)
            GROUP BY 1
            ORDER BY 2 DESC)
SELECT t1.genre, t1.total_rental_demand, t2.total_sales
FROM t1
JOIN t2
ON t1.genre = t2.genre;


--Can we know how many distinct users have rented each genre?

SELECT c.name as genre, COUNT(DISTINCT cu.customer_id) 
FROM category as c
JOIN film_category fc
USING(category_id)
JOIN film as f
USING(film_id)
JOIN inventory as i 
USING(film_id)
JOIN rental as r 
USING(inventory_id)
JOIN customer as cu
USING(customer_id)
GROUP by 1
ORDER BY 2 DESC;
	
--What is the Average rental rate for each genre?
SELECT c.name as genre, ROUND(AVG(f.rental_rate),2) as average_rental_rate 
FROM category as c
JOIN film_category fc
USING(category_id)
JOIN film as f
USING(film_id)
GROUP by 1
ORDER BY 2 DESC;

--How many rented films were returned late, early and on time?

WITH 
t1 as (SELECT *, DATE_PART('day', return_date - rental_date) AS duration
	   FROM rental),
t2 AS (SELECT rental_duration, duration,
              CASE
                WHEN rental_duration > duration THEN 'Early'
                WHEN rental_duration = duration THEN 'On Time'
                ELSE 'Late'
              END AS Return_Status
          FROM film f
          JOIN inventory i
          USING(film_id)
          JOIN t1
          USING (inventory_id)),
t3 as (SELECT COUNT(*) as total
	   FROM t2),

t4 as (SELECT Return_Status, COUNT(*) as number_of_rented_films
	FROM t2
	GROUP by 1)

SELECT 
  Return_Status, number_of_rented_films, ROUND(CAST(CAST(number_of_rented_films as float) / CAST(total as float) as numeric),2)*100 AS percentage
  FROM t3, t4;

--In which countries do Rent A Film have a presence in and what is the customer base in each country? What are the total sales in each country?
SELECT country, count(DISTINCT customer_id) AS customer_base, SUM(amount) AS total_sales
FROM country
JOIN city
USING(country_id)
JOIN address
USING(city_id)
JOIN customer
USING (address_id)
JOIN payment
USING(customer_id)
GROUP BY 1
ORDER BY 2 DESC;

--Who are the top 5 customers per total sales and can we get their detail just in case Rent A Film want to reward them?*/
SELECT first_name || '  ' || last_name as full_name,address,city,country,phone,email,SUM(amount) as total_sales
FROM customer 
JOIN address
USING(address_id)
JOIN city
USING(city_id)
JOIN country
USING(country_id)
JOIN payment
USING(customer_id)
GROUP BY 1,2,3,4,5,6
ORDER BY total_sales DESC
LIMIT 5;

--Do we have actors in the actor table that share the full name and if yes display those shared names?
SELECT DISTINCT a1.first_name || ' ' || a1.last_name as full_name
FROM actor a1
JOIN actor a2 ON
a1.actor_id != a2.actor_id AND a1.first_name = a2.first_name AND a1.last_name = a2.last_name;

--Display the customer names that share the same address (e.g. husband and wife).

SELECT c1.first_name || c1.last_name as full_name_c1,c2.first_name || c2.last_name as full_name_c2
FROM customer c1
JOIN customer c2 ON
c1.customer_id != c2.customer_id AND c1.address_id = c2.address_id;
--OR 

WITH 
joined as (SELECT first_name || last_name as full_name, address
FROM customer 
JOIN address
USING(address_id))

SELECT t1.full_name,t2.full_name,t1.address
FROM joined as t1
JOIN joined as t2
ON t1.full_name !=t2.full_name AND t1.address = t2.address;

--What is the name of the customer who made the highest total payments?
SELECT first_name || ' ' || last_name as full_name 
FROM customer 
WHERE customer_id IN
(SELECT customer_id 
 FROM
	( SELECT customer_id, SUM(amount)
	 FROM payment 
	 GROUP BY customer_id
	 ORDER BY SUM(amount) DESC
	 LIMIT 1
	) T1
 );
 
 --What is the movie(s) that was rented the most.
 SELECT title,COUNT(film_id)
 FROM film
 JOIN inventory i 
 USING(film_id)
 JOIN rental r
 USING(inventory_id)
 GROUP BY title
 ORDER BY COUNT(film_id) DESC
 LIMIT 1;
 
 --Display the customer_id’s for those customers that rented a movie DVD more than once.
 WITH T as (SELECT rental_id,rental_date,customer_id,film_id 
 FROM rental
 JOIN inventory 
 USING(inventory_id))
 
 SELECT T1.customer_id,count(T1.film_id) as count_of_movie
 FROM T as T1
 JOIN T as T2 ON
 T1.customer_id = T2.customer_id AND T1.film_id = T2.film_id AND T1.rental_id != T2.rental_id
 GROUP BY T1.customer_id
 HAVING count(T1.film_id)>1
 ORDER by count_of_movie DESC;
 
 
 --Which movies in film have been rented so far?
 SELECT title
 FROM film
 WHERE film_id IN
 	(SELECT DISTINCT film_id
	FROM inventory 
	JOIN rental 
	USING(inventory_id));
--only 958 out of 1000 movies have beeen rented

--Find list of movies that have not been rented

 SELECT title
 FROM film
 WHERE film_id NOT IN
 	(SELECT DISTINCT film_id
	FROM inventory 
	JOIN rental 
	USING(inventory_id));
 
--Which customers have registered but not rented
SELECT customer_id,first_name || ' ' || last_name as full_name 
FROM customer C
WHERE NOT EXISTS
    (SELECT DISTINCT customer_id
	FROM rental R
	WHERE C.customer_id = R.customer_id);
--Show number of movies each actor acted in 
SELECT actor_id,first_name || ' ' || last_name as full_name, COUNT(film_id)
FROM film_actor 
JOIN actor 
USING(actor_id)
GROUP BY 1
ORDER BY 3 DESC;

--Display the names of the actors that acted in more than 20 movies.
SELECT actor_id,first_name || ' ' || last_name as full_name, COUNT(film_id)
FROM film_actor 
JOIN actor 
USING(actor_id)
GROUP BY 1
HAVING COUNT(film_id)>20
ORDER BY 3 DESC;


-- How many actors have 8 letters only in their first_names.
SELECT count(first_name)
FROM actor
WHERE LENGTH(first_name) = 8;

--For all the movies rated “PG” show me the movie and the number of times it got rented.
SELECT film_id,title,count(film_id)
FROM rental 
JOIN inventory
USING(inventory_id)
JOIN film
USING(film_id)
WHERE rating = 'PG'
GROUP BY film_id
ORDER BY film_id;

--Display the movies offered for rent in store_id 1 and not offered in store_id 2.
SELECT DISTINCT film_id, title 
FROM film
JOIN inventory
USING(film_id)
WHERE store_id = 1 AND film_id NOT IN (SELECT film_id 
									  FROM inventory
									  WHERE store_id =2)
ORDER BY film_id;

--DISPLAY movie offer for rent in any of the two store
(SELECT film_id
FROM inventory
WHERE store_id = 1)
UNION
(SELECT film_id
FROM inventory
WHERE store_id = 2);


(SELECT DISTINCT film_id
FROM inventory
WHERE store_id = 1 OR store_id = 2);


--Display the movie titles of those movies offered in both stores at the same time.
SELECT DISTINCT film_id, title 
FROM film
JOIN inventory
USING(film_id)
WHERE store_id = 1 AND film_id IN (SELECT film_id 
									  FROM inventory
									  WHERE store_id =2)
ORDER BY film_id;

SELECT DISTINCT film_id, title 
FROM film
WHERE film_id IN
      (( SELECT film_id
		 FROM inventory
		WHERE store_id = 1)
	   INTERSECT
	   ( SELECT film_id
		 FROM inventory
		WHERE store_id = 2))
ORDER BY film_id;

--Display the movie title for the most rented movie in the store with store_id 1.
SELECT title 
FROM film
WHERE film_id IN
(SELECT film_id 
FROM rental
JOIN inventory
USING(inventory_id)
WHERE store_id = 1
GROUP BY film_id
HAVING COUNT(film_id) = (SELECT count(film_id)
						FROM rental
						JOIN inventory
						USING(inventory_id)
						WHERE store_id = 1
						GROUP by film_id
						ORDER by count(film_id) DESC LIMIT 1)
)


--Show the number of rented movies under each rating
SELECT rating,COUNT(rating)
FROM film
JOIN inventory
USING(film_id)
JOIN rental
USING (inventory_id)
GROUP BY rating
ORDER BY COUNT(rating) DESC;

--Show profit of each of the stores 1 and 2 and total profit
SELECT store_id, SUM(amount) as profit
FROM inventory
JOIN rental
USING(inventory_id)
JOIN payment
USING(rental_id)
GROUP BY ROLLUP (store_id);

--Find actor’s first_name that starts with ‘P’ followed by (an e or an a) then any other letter.
SELECT first_name
FROM actor
WHERE first_name SIMILAR TO 'P(e|a)%'

--P followed by any five letters
SELECT first_name 
FROM customer 
WHERE first_name SIMILAR TO 'P_____';



