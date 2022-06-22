-- 1. List all customers who live in Texas
SELECT customer_id, first_name, last_name, customer.address_id
FROM customer
INNER JOIN address
on customer.address_id = address.address_id
WHERE address.district = 'Texas'

-- 2. Get all payments above $6.99 with the Customer's Full Name
SELECT first_name, last_name, customer.customer_id
FROM customer
INNER JOIN payment
ON customer.customer_id = payment.customer_id
WHERE payment.amount > 6.99
ORDER BY customer_id ASC

-- 3. Show all customers names who have made payments over $175
SELECT first_name, last_name, store_id
FROM customer
WHERE customer_id IN (
    SELECT customer_id
    FROM payment
    GROUP BY customer_id
    HAVING SUM(amount) > 175.00
    ORDER BY SUM(amount) DESC
);

-- 4. List all customers that live in Nepal
SELECT first_name, last_name, customer_id
FROM customer
INNER JOIN address
ON address.address_id = customer.address_id
INNER JOIN city
ON city.city_id = address.city_id
INNER JOIN country
ON country.country_id = city.country_id
WHERE country.country = 'Nepal';

-- 5. Which staff member had the most transactions? A: Mike Hillyer by 36
SELECT first_name, last_name, (SELECT COUNT(*) FROM rental WHERE staff_id = staff.staff_id) AS number_of_transactions
FROM staff

-- 6. How many movies fo each rating are there? A: R=195, NC-17=210, G=178, PG=194, PG-13=223
SELECT rating, COUNT (rating)
FROM film
GROUP BY rating;

-- 7. Show all customers who have made a single payment above $6.99
SELECT first_name, last_name, customer.customer_id, (SELECT COUNT(*) FROM payment WHERE payment.amount>6.99 AND customer.customer_id = payment.customer_id) as transactions
FROM customer
INNER JOIN payment
ON customer.customer_id = payment.customer_id
WHERE payment.amount > 6.99 
GROUP BY customer.customer_id
ORDER BY (SELECT COUNT(*) FROM payment WHERE payment.amount>6.99 AND customer.customer_id = payment.customer_id)
-- This is the best I could do. Could not figure out how to limit it to showing only the ones that made
-- only one transaction above 6.99.

-- 8.0 How many free rentals did our stores give away? A: Store 1 gave 15 for free, Store 2 gave away 9
SELECT store_id, (SELECT COUNT(*) FROM payment WHERE payment.amount < 0.01 AND staff.staff_id = payment.staff_id) as freebies
FROM staff
