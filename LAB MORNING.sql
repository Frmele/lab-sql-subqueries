/*

How many copies of the film Hunchback Impossible exist in the inventory system?
List all films whose length is longer than the average of all the films.
Use subqueries to display all actors who appear in the film Alone Trip.
Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments
Customers who spent more than the average payments.
*/
Use sakila;
select*from film where title like 'Hunchback Impossible';
select count(inventory_id) as total_copies from inventory where film_id in
(select film_id from film where title like 'Hunchback Impossible');
#List all films whose length is longer than the average of all the films.
select avg(length) from sakila.film;
select film_id,title,length from film where length>(select avg(length) from sakila.film)
order by length desc;
#Use subqueries to display all actors who appear in the film Alone Trip.
select*from film where title like 'Alone Trip';
#film id 17
select*from film_actor where film_id like 17;
#actor_id
select*from actor where actor_id in
(select actor_id from film_actor where film_id in
(select film_id from film where title like 'Alone Trip'))
order by actor_id asc;
# Sales have been lagging among young families, and you wish to target all family movies for a promotion.
# Identify all movies categorized as family films.
select*from category where name like 'Family';
# category_id 8
select*from film_category where category_id like 8;

select title,film_id from film where film_id in
(select film_id from film_category where category_id in 
(select category_id from category where name like 'Family'))
order by film_id asc;

# Get name and email from customers from Canada using subqueries. Do the same with joins. 
# Note that to create a join, you will have to identify the correct tables with their 
# primary keys and foreign keys, that will help you get the relevant information.
select email, first_name, last_name from customer where address_id in(select address_id from address where 
city_id in(select city_id from city where country_id in
(select country_id from country where country like 'Canada')));

select
   cu.email,
   concat(cu.first_name, ' ', cu.last_name) as customer_name, 
   cou.country as country
from customer as cu
join address as ad
on cu.address_id=ad.address_id
join city as ci
on ad.city_id=ci.city_id
join country as cou
on ci.country_id=cou.country_id
where cou.country like'canada';

# Which are films starred by the most prolific actor? Most prolific actor is defined as the 
# actor that has acted in the most number of films. First you will have to find the most 
# prolific actor and then use that actor_id to find the different films that he/she starred.
select actor_id, count(actor_id) as total_movies from 
film_actor group by actor_id order by total_movies desc limit 1;
#107 returned actor_id and total movies 42
select * from film_actor where actor_id like 107;
#film_id to create last connection

select title from film
where film_id in (select film_id from film_actor
where actor_id = (select actor_id from film_actor
group by actor_id
order by count(film_id) desc
limit 1));


# Films rented by most profitable customer. You can use the customer table and payment table to find 
# the most profitable customer ie the customer that has made the largest sum of payments

select title from film 
where film_id in (select film_id from inventory 
where inventory_id in (select inventory_id from rental 
where customer_id = (select customer_id from payment 
group by customer_id 
order by sum(amount) desc 
limit 1)));

# Customers who spent more than the average payments.

select customer_id, sum(amount)from payment
group by customer_id
having sum(amount) > (select avg(sum_amount) from (select sum(amount) as sum_amount from payment
group by customer_id
order by sum(amount) desc)sub1)
order by sum(amount) desc;





