
/** 1a. Display the first and last names of all actors from the table `actor`.**/

SELECT 
    first_name, last_name
FROM
    actor;
    
/** 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`.**/

SELECT 
    UPPER(CONCAT(`first_name`, '  ', `last_name`)) as 'Actor Name'
FROM
    actor;
    

/** 2a. You need to find the ID number, first name, and last name of an actor, of whom you 
know only the first name, "Joe." What is one query would you use to obtain this information?**/

SELECT 
    actor.actor_id, actor.first_name, actor.last_name
FROM
    actor
WHERE
    UPPER(actor.first_name) = 'JOE';
    
/**  2b. Find all actors whose last name contain the letters `GEN`:**/

SELECT 
    *
FROM
    actor
WHERE
    UPPER(actor.last_name) LIKE '%G%'
        AND UPPER(actor.last_name) LIKE '%E%'
        AND UPPER(actor.last_name) LIKE '%N%';
              
/**  2c. Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order: **/

SELECT 
    actor.last_name, actor.first_name
FROM
    actor
WHERE
    UPPER(actor.last_name) LIKE '%L%'
        AND UPPER(actor.last_name) LIKE '%I%';
              
/** 2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China: **/
SELECT 
    country.country_id, country.country
FROM
    country
WHERE country.country in ("Afghanistan", "Bangladesh", "China");
			 
/** 3a. Add a `middle_name` column to the table `actor`. Position it between `first_name` and `last_name`. Hint: you will need to specify the data type. **/

/*add column name */
alter table actor
add middle_name varchar(45) not null; 

/*Move columns around */
alter table actor modify column middle_name varchar(45) after first_name;

/* 3b. You realize that some of these actors have tremendously long last names. Change the data type of the `middle_name` column to `blobs`. */
alter table actor modify column middle_name blob;

/*3c. Now delete the `middle_name` column. */
alter table actor drop column middle_name;

/** 4a. List the last names of actors, as well as how many actors have that last name. **/
SELECT DISTINCT
    actor.last_name, COUNT(actor.last_name)
FROM
    actor
GROUP BY actor.last_name;

/*4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors */
SELECT DISTINCT
    actor.last_name, COUNT(actor.last_name) as Count
FROM
    actor
GROUP BY actor.last_name
HAVING COUNT(actor.last_name) >= 2;

/** 4c. Oh, no! The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as 
`GROUCHO WILLIAMS`, the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.**/
SELECT 
    actor.actor_id, first_name, actor.last_name
FROM
    actor
WHERE
    UPPER(actor.first_name) = 'GROUCHO';

/*actor id = 127 */

UPDATE actor 
SET 
    actor.first_name = 'HARPO'
WHERE
    actor.actor_id = 127;

/** 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`.
 It turns out that `GROUCHO` was the correct name after all! In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`.
 Otherwise, change the first name to `MUCHO GROUCHO`, as that is exactly what the actor will be with the grievous error.
 BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO `MUCHO GROUCHO`, 
 HOWEVER! (Hint: update the record using a unique identifier.)**/
SET SQL_SAFE_UPDATES = 0;

    
UPDATE actor 
SET 
    first_name = 'GROUCHO'
WHERE
    first_name = 'HARPO';

/* 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it? */

CREATE TABLE `address` (
  `address_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `address` varchar(50) NOT NULL,
  `address2` varchar(50) DEFAULT NULL,
  `district` varchar(20) NOT NULL,
  `city_id` smallint(5) unsigned NOT NULL,
  `postal_code` varchar(10) DEFAULT NULL,
  `phone` varchar(20) NOT NULL,
  `location` geometry NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`address_id`),
  KEY `idx_fk_city_id` (`city_id`),
  SPATIAL KEY `idx_location` (`location`),
  CONSTRAINT `fk_address_city` FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`) ON UPDATE CASCADE
) 

/*  6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`: */

SELECT 
    actor.first_name, actor.last_name, address.address
FROM
    actor
        LEFT JOIN
    address ON actor.actor_id = address.address_id;


/** 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`. */

SELECT 
    staff.first_name, SUM(payment.amount) as 'Total Per Person'
FROM
    staff
        LEFT JOIN
    payment ON staff.staff_id = payment.staff_id
GROUP BY staff.first_name;

/** 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.**/
/**Could have just used the film_actor table **/


SELECT 
    film.title, COUNT(film.film_id)
FROM
    film
        INNER JOIN
    film_actor ON film.film_id = film_actor.film_id
GROUP BY film.title;

/*6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?*/
SELECT 
    film.title, COUNT(inventory.film_id)
FROM
   film
        JOIN
    inventory ON film.film_id = inventory.film_id
WHERE
    inventory.film_id = 439;
    

/*6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name:*/

SELECT 
    customer.last_name, SUM(payment.amount)
FROM
    customer
        JOIN
    payment ON customer.customer_id = payment.customer_id
GROUP BY customer.last_name
ORDER BY customer.last_name ASC;

/** 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
As an unintended consequence, films starting with the letters `K` and `Q` have also soared in popularity. 
Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English. **/

SELECT 
    film.title, language.name
FROM
    language
        LEFT JOIN
    film ON film.language_id = language.language_id
WHERE
    (film.title LIKE 'K%'
        OR film.title LIKE 'Q%')
        AND language.name = 'English';
        

/*7b. Use subqueries to display all actors who appear in the film `Alone Trip`.  */

SELECT 
    film.title,
    actor.first_name,
    actor.last_name,
    film_actor.actor_id
FROM
    film_actor
        LEFT JOIN
    film ON (film.film_id = film_actor.film_id)
        LEFT JOIN
    actor ON (actor.actor_id = film_actor.actor_id)
WHERE
    film.title = 'ALONE TRIP';


/* 7c. You want to run an email marketing campaign in Canada,
 for which you will need the names and email addresses of all Canadian customers. 
 Use joins to retrieve this information.*/

SELECT 
    customer.first_name,
    customer.last_name,
    customer.email,
    city.city,
    country.country
FROM
    address
        JOIN
    customer ON customer.address_id = address.address_id
        JOIN
    city ON city.city_id = address.city_id
        JOIN
    country ON country.country_id = city.country_id
WHERE
    country = 'CANADA';



/* 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion.
 Identify all movies categorized as famiy films.  */

SELECT 
    film.title, category.name
FROM
    film_category
        JOIN
    film ON film.film_id = film_category.film_id
        JOIN
    category ON category.category_id = film_category.category_id
WHERE
    category.name = 'Family';

 /*7e. Display the most frequently rented movies in descending order. */ 
SELECT 
    film.title, COUNT(film.title) AS count
FROM
    rental
        LEFT JOIN
    payment ON payment.customer_id = rental.customer_id
        LEFT JOIN
    inventory ON inventory.inventory_id = rental.inventory_id
        LEFT JOIN
    film ON film.film_id = inventory.film_id
GROUP BY film.title
ORDER BY count DESC;
 
 
/** 7f. Write a query to display how much business, in dollars, each store brought in. **/
/** No join was needed because there  are two stores 1 and 2 and two staff 1 and 2. Staff 1 works at store one and etc. **/
 
SELECT 
    staff.store_id AS Store, SUM(payment.amount) AS 'Total Sum'
FROM
    staff
        LEFT JOIN
    payment ON payment.staff_id = staff.staff_id
GROUP BY staff.store_id;

/**  7g. Write a query to display for each store its store ID, city, and country.   **/

SELECT 
    store.store_id AS 'Store ID', city.city, country.country
FROM
    address
        JOIN
    store ON store.address_id = address.address_id
        JOIN
    city ON city.city_id = address.city_id
        JOIN
    country ON country.country_id = city.country_id;
    
/**7h. List the top five genres in gross revenue in descending order.    **/

SELECT category.name as GENRES,  sum( payment.amount) as 'TOTAL SUM'

from rental 

left join payment on payment.rental_id = rental.rental_id

left join inventory on inventory.inventory_id = rental.inventory_id

left join film  on film.film_id = inventory.film_id

left join film_category on film_category.film_id = inventory.film_id

left join category on category.category_id = film_category.category_id

group by category.name

order by sum( payment.amount) desc

limit 5;

/** 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 
Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view. **/
CREATE VIEW TOP_GENRES_BY_GROSS AS
    SELECT 
        category.name AS GENRES, SUM(payment.amount) AS 'TOTAL SUM'
    FROM
        rental
            LEFT JOIN
        payment ON payment.rental_id = rental.rental_id
            LEFT JOIN
        inventory ON inventory.inventory_id = rental.inventory_id
            LEFT JOIN
        film ON film.film_id = inventory.film_id
            LEFT JOIN
        film_category ON film_category.film_id = inventory.film_id
            LEFT JOIN
        category ON category.category_id = film_category.category_id
    GROUP BY category.name
    ORDER BY SUM(payment.amount) DESC
    LIMIT 5;

/** 8b. How would you display the view that you created in 8a?  **/
SELECT * FROM  top_genres_by_gross;

/**8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it. **/
DROP VIEW top_genres_by_gross;

