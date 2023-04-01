use mavenmovies;

/*
1.	We will need a list of all staff members, including their first and last names, 
email addresses, and the store identification number where they work. 
*/ 

SELECT * FROM staff;

SELECT first_name, last_name, email, store_id 
FROM staff;


/*
2.	We will need separate counts of inventory items held at each of your two stores. 
*/ 

SELECT * FROM inventory;

SELECT store_id "Store ID", COUNT(inventory_id) AS "Inventory Items"
FROM inventory
GROUP BY store_id;


/*
3.	We will need a count of active customers for each of your stores. Separately, please. 
*/

SELECT * FROM customer;

SELECT Store_id, Count(active) AS "Active Status"
FROM customer
WHERE active = 1 
GROUP BY store_id;


/*
4.	In order to assess the liability of a data breach, we will need you to provide a count 
of all customer email addresses stored in the database. 
*/

SELECT COUNT(email) AS "Email ID Count"
FROM customer;


/*
5.	We are interested in how diverse your film offering is as a means of understanding how likely 
you are to keep customers engaged in the future. Please provide a count of unique film titles 
you have in inventory at each store and then provide a count of the unique categories of 
films you provide. 
*/

SELECT * FROM category;

SELECT store_id, COUNT(DISTINCT film_id) AS "Unique Title"
FROM inventory
GROUP BY store_id;

SELECT DISTINCT(name) AS "Unique Category Name"
FROM category;


/*
6.	We would like to understand the replacement cost of your films. 
Please provide the replacement cost for the film that is least expensive to replace, 
the most expensive to replace, and the average of all films you carry. ``	
*/

SELECT * FROM film;

SELECT MIN(replacement_cost), MAX(replacement_cost), AVG(replacement_cost)
FROM film;


/*
7.	We are interested in having you put payment monitoring systems and maximum payment 
processing restrictions in place in order to minimize the future risk of fraud by your staff. 
Please provide the average payment you process, as well as the maximum payment you have processed.
*/

SELECT AVG(amount) AS "Average Payment", MAX(amount) "Maximum Payment"
FROM payment;


/*
8.	We would like to better understand what your customer base looks like. 
Please provide a list of all customer identification values, with a count of rentals 
they have made all-time, with your highest volume customers at the top of the list.
*/

SELECT customer_id, COUNT(rental_id)
FROM rental
GROUP BY customer_id
ORDER BY COUNT(rental_id) DESC;

/* 
9. My partner and I want to come by each of the stores in person and meet the managers. 
Please send over the managers’ names at each store, with the full address 
of each property (street address, district, city, and country please).  
*/ 

SELECT * FROM staff;

SELECT staff.first_name AS "Manager First Name",
staff.last_name "Manager Last Name",
address.address AS Address,
address.district AS District,
city.city AS City,
country.country AS Country
FROM store
	LEFT JOIN staff ON store.store_id = staff.store_id
	LEFT JOIN address ON staff.address_id = address.address_id
	LEFT JOIN city ON address.city_id = city.city_id
	LEFT JOIN country ON city.country_id = country.country_id;

	
/*
10.	I would like to get a better understanding of all of the inventory that would come along with the business. 
Please pull together a list of each inventory item you have stocked, including the store_id number, 
the inventory_id, the name of the film, the film’s rating, its rental rate and replacement cost. 
*/

SELECT
 inventory.store_id AS "Store ID number",
 inventory.inventory_id AS "Inventory ID",
 film.title AS "Film Name",
 film.rating AS "Ratings",
 film.replacement_cost AS "Replacement Cost"
FROM inventory
	LEFT JOIN film ON inventory.film_id = film.film_id;
 

/* 
11.	From the same list of films you just pulled, please roll that data up and provide a summary level overview 
of your inventory. We would like to know how many inventory items you have with each rating at each store. 
*/

SELECT film.rating, inventory.store_id, COUNT(inventory_id) AS "Inventory Count"
FROM inventory
LEFT JOIN film ON inventory.film_id = film.film_id
    GROUP BY film.rating, inventory.store_id
    ORDER BY film.rating, inventory.store_id;


/* 
12. Similarly, we want to understand how diversified the inventory is in terms of replacement cost. We want to 
see how big of a hit it would be if a certain category of film became unpopular at a certain store.
We would like to see the number of films, as well as the average replacement cost, and total replacement cost, 
sliced by store and film category. 
*/ 

SELECT inventory_id
FROM inventory;

SELECT 
	store_id AS "Store ID",
	category.name "Category Name",
	COUNT(inventory_id) "Inventory Count",
	AVG(replacement_cost) "Avg Replacement Cost",
	SUM(replacement_cost) "Total Replacement Cost"
FROM inventory
	LEFT JOIN film
		ON inventory.film_id = film.film_id
	LEFT JOIN film_category
		ON film.film_id = film_category.film_id
	LEFT JOIN category
		ON film_category.category_id = category.category_id
GROUP BY 
	store_id,
	category.name
    
ORDER BY
	SUM(replacement_cost) DESC;


/*
13.	We want to make sure you folks have a good handle on who your customers are. Please provide a list 
of all customer names, which store they go to, whether or not they are currently active, 
and their full addresses – street address, city, and country. 
*/

SELECT
	customer.first_name AS "Customer Names",
	customer.store_id AS "Store ID",
	customer.active AS "Active Status",
	address.address AS "Address",
    city.city AS "City",
	country.country AS "Country"
FROM customer
	LEFT JOIN address
		ON customer.address_id = address.address_id
	LEFT JOIN city
		ON address.city_id = city.city_id
	LEFT JOIN country
		ON city.country_id = country.country_id;


/*
14.	We would like to understand how much your customers are spending with you, and also to know 
who your most valuable customers are. Please pull together a list of customer names, their total 
lifetime rentals, and the sum of all payments you have collected from them. It would be great to 
see this ordered on total lifetime value, with the most valuable customers at the top of the list. 
*/

SELECT
	customer.first_name AS "Customer First Name",
	customer.last_name AS "Customer Last Name",
	COUNT(rental.rental_id) AS "Total Rentals",
	SUM(payment.amount) AS "Total Payments"
FROM customer
	LEFT JOIN rental 
		ON customer.customer_id = rental.customer_id
	LEFT JOIN payment
		ON rental.rental_id = payment.rental_id
GROUP BY
	customer.first_name,
	customer.last_name
ORDER BY
	SUM(payment.amount) DESC;
  
  
/*
15. My partner and I would like to get to know your board of advisors and any current investors.
Could you please provide a list of advisor and investor names in one table? 
Could you please note whether they are an investor or an advisor, and for the investors, 
it would be good to include which company they work with. 
*/

SELECT 
'investor' AS Type,
first_name,
last_name,
company_name
FROM investor
UNION
SELECT 
'advisor' AS Type,
first_name,
last_name,
'N/A'
FROM advisor;


/*
16. We're interested in how well you have covered the most-awarded actors. 
Of all the actors with three types of awards, for what % of them do we carry a film?
And how about for actors with two types of awards? Same questions. 
Finally, how about actors with just one award? 
*/

SELECT * FROM actor_award;

SELECT
CASE 
WHEN actor_award.awards = 'Emmy, Oscar, Tony ' THEN '3 Awards'
WHEN actor_award.awards IN ('Emmy, Oscar','Emmy, Tony','Oscar, Tony') THEN '2 Awards'
ELSE '1 Award'
END AS 'Number of Awards',
AVG(CASE WHEN actor_award.actor_id IS NULL THEN 0 ELSE 1 END) AS pct_w_one_film

FROM actor_award

GROUP BY 
CASE 
WHEN actor_award.awards = 'Emmy, Oscar, Tony ' THEN '3 Awards'
WHEN actor_award.awards IN ('Emmy, Oscar','Emmy, Tony','Oscar, Tony') THEN '2 Awards'
ELSE '1 Award'
END;

