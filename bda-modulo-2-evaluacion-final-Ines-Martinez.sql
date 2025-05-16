# Después del enunciado de cada ejercicio he puesto las tablas que he usado para realizar cada función, 
-- en el orden que las voy a necesitar para relacionar las tablas y obtener los resultados pertinentes.

USE sakila;
# 1. Selecciona todos los nombres de las películas sin que aparezcan duplicados.

SELECT DISTINCT(title) AS Títulos_Películas
FROM film;

# 2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".

SELECT title AS Títulos_Películas 
FROM film
WHERE rating = 'PG-13';

# 3. Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.

SELECT title AS Título, description AS Descripción
FROM film
WHERE description LIKE '%amazing%';

# 4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.
# SELECT * FROM film; 

SELECT title AS Título
FROM film
WHERE length > 120;

# 5. Encuentra los nombres de todos los actores, muéstralos en una sola columna que se llame nombre_actor y contenga nombre y apellido.
# SELECT * FROM film;
# SELECT * FROM actor;

SELECT CONCAT(first_name,' ', last_name) AS nombre_actor
FROM actor;

# 6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.
# SELECT * FROM actor;

SELECT first_name AS Nombre, last_name AS Apellidos
FROM actor
WHERE last_name = 'Gibson';

# 7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.
# SELECT * FROM actor;

SELECT first_name AS Nombre, last_name AS Apellido
FROM actor
WHERE actor_id BETWEEN 10 AND 20;

# 8. Encuentra el título de las películas en la tabla film que no tengan clasificacion "R" ni "PG-13".
# SELECT * FROM film;

SELECT title AS Título
FROM film
WHERE rating != 'R' 
AND rating != 'PG-13';

# 9.  Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento.
# SELECT * FROM film;

SELECT rating AS Clasificación, COUNT(film_id) AS Recuento
FROM film
GROUP BY rating
ORDER BY rating;

# 10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente,
-- su nombre y apellido junto con la cantidad de películas alquiladas.

# SELECT * FROM rental;
# SELECT * FROM customer;

SELECT c.customer_id AS ID_Cliente, CONCAT(first_name,' ', last_name) AS Cliente, COUNT(r.rental_id) AS Total_Películas_Alquiladas
FROM customer c
INNER JOIN rental r
ON c.customer_id = r.customer_id
GROUP BY c.customer_id, first_name, last_name
ORDER BY first_name, last_name;

# El Count cuenta los alquileres por persona. Agrupo por las mismas columnas que he seleccionado.

# 11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.

# Necesitamos las siguientes categorías. Ya están ordenadas por orden, para saber con qué tabla tengo que unir la siguiente.
# SELECT * FROM category;
# SELECT * FROM film_category;
# SELECT * FROM film;
# SELECT * FROM inventory;
# SELECT * FROM rental;

SELECT c.name AS Nombre_Categoría, 
	c.category_id AS ID_Categoría, # Se puede quitar el ID_Categoría, pero me gusta ponerlo, porque es el nexo de unión entre las tablas
    COUNT(r.rental_id) AS Recuento_Alquileres
FROM category c
JOIN film_category fc ON fc.category_id = c.category_id
JOIN film f ON f.film_id = fc.film_id
JOIN inventory i ON i.film_id = f.film_id
JOIN rental r ON r.inventory_id = i.inventory_id
GROUP BY c.name, c.category_id;

# Agrupamos por las dos columnas que hemos solicitado al principio. Se excluye la que está en la función agregada.

# 12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.
# SELECT * FROM film;

SELECT rating AS Clasificación, AVG(length) AS promedio
FROM film AS Películas
GROUP BY rating -- Piden agrupar por la clasificación
ORDER BY rating; -- Al incluir el ORDER BY se ordenan alfabéticamente

# 13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".
# SELECT * FROM actor;
# SELECT * FROM film_actor;
# SELECT * FROM film;

SELECT a.first_name AS Nombre, a.last_name AS Apellido
FROM actor a
JOIN film_actor fa ON fa.actor_id = a.actor_id
JOIN film f ON f.film_id = fa.film_id
WHERE title = 'Indian Love';

# 14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.
# SELECT * FROM film;

SELECT title As Título
FROM film
WHERE description LIKE '%dog%'OR description LIKE '%cat%';

# Para comprobar que aparecían estas palabras en la descripción.
SELECT title As Título, description AS Descripción
FROM film
WHERE description LIKE '%dog%'OR description LIKE '%cat%';

# 15. ¿Hay algún actor o actriz que no aparezca en ninguna película en la tabla film_actor?
# SELECT * FROM actor;
# SELECT * FROM film_actor;
# SELECT * FROM film;

SELECT a.first_name AS Nombre, a.last_name AS Apellido
FROM actor a
LEFT JOIN film_actor fa ON fa.actor_id = a.actor_id
LEFT JOIN film f ON f.film_id = fa.film_id
WHERE f.film_id IS NULL;

# He querido comprobar que realmente la consulta anterior tuviese ese resultado y la consulta me diera 0.
SELECT COUNT(*) 
FROM actor a
LEFT JOIN film_actor fa ON fa.actor_id = a.actor_id
WHERE fa.film_id IS NULL;

# 16. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.
# SELECT * FROM film;

Select title AS Título
FROM film
WHERE release_year BETWEEN 2005 AND 2010;

# 17. Encuentra el título de todas las películas que son de la misma categoría que "Family".
# SELECT * FROM film;
# SELECT * FROM film_category;
# SELECT * FROM category;

SELECT f.title AS Título
FROM film f
INNER JOIN film_category fc ON fc.film_id = f.film_id
INNER JOIN category c ON c.category_id = fc.category_id
WHERE c.name = 'Family';

# 18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.
# SELECT * from film;
# SELECT * from film_actor;
# SELECT * from actor;

SELECT a.first_name AS Nombre, a.last_name AS Apellido
FROM actor a
INNER JOIN film_actor fa ON fa.actor_id = a.actor_id
INNER JOIN film f ON f.film_id = fa.film_id
GROUP BY a.actor_id  # Porque el actor_id es único
HAVING COUNT(f.film_id) >10; 

# 19. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film.
# SELECT * FROM film;

SELECT title AS Título
FROM film
WHERE rating = 'R' AND length > 120;

# 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos
--  y muestra el nombre de la categoría junto con el promedio de duración.
# SELECT * FROM category;
# SELECT * FROM film_category;
# SELECT * FROM film;

SELECT c.category_id AS ID_Categoría, 
	c.name AS Nombre_Categoría, 
	ROUND(AVG(f.length), 2) AS Promedio_Duración # He redondeado a dos decimales con la función COUNT
FROM category c
INNER JOIN film_category fa ON fa.category_id = c.category_id
INNER JOIN film f ON f.film_id = fa.film_id
GROUP BY c.category_id, c.name 
HAVING AVG(f.length) > 120
ORDER BY Promedio_Duración; # También funcionaría sin el ORDER BY

# 21. Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la cantidad de películas en las que han actuado.
# SELECT * FROM actor;
# SELECT * FROM film_actor;
# SELECT * FROM film;

SELECT a.actor_id AS ID_Actor, # Sé que no se necesita el actor_id y que funciona igual sin él, pero me ayuda a relacionar las tablas.
	a.first_name AS Nombre, 
    a.last_name AS Apellido, 
    COUNT(f.film_id) Número_Películas
FROM actor a
INNER JOIN film_actor fa ON fa.actor_id = a.actor_id
INNER JOIN film f ON f.film_id = fa.film_id
GROUP BY a.actor_id, a.first_name, a.last_name # Hay que agrupar por actor para que funcione el COUNT
HAVING COUNT(f.film_id) >=5
ORDER BY Número_Películas;

# 22. Encuentra el título de todas las películas que fueron alquiladas durante más de 5 días. 
-- Utiliza una subconsulta para encontrar los rental_ids con una duración superior a 5 días y luego selecciona
-- las películas correspondientes. Pista: Usamos DATEDIFF para calcular la diferencia entre una fecha y otra, ej: DATEDIFF(fecha_inicial, fecha_final)
# SELECT * FROM film;
# SELECT * FROM inventory;
# SELECT * FROM rental;

SELECT DISTINCT f.title AS Título # He puesto el "Distinct" para que no haya duplicados en los títulos
FROM film f
INNER JOIN inventory i ON i.film_id = f.film_id
INNER JOIN rental r ON r.inventory_id = i.inventory_id
WHERE r.rental_id IN(
	SELECT rental_id
    FROM rental 
		WHERE DATEDIFF(return_date, rental_date) > 5
);

# 23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película 
-- de la categoría "Horror". Utiliza una subconsulta para encontrar los actores
-- que han actuado en películas de la categoría "Horror" y luego exclúyelos de la lista de actores.
# SELECT * FROM actor;
# SELECT * FROM film_actor;
# SELECT * FROM film;
# SELECT * FROM film_category;
# SELECT * FROM category;

SELECT CONCAT(a.first_name,' ', a.last_name) AS Nombre_Apellido
FROM actor a
WHERE a.actor_id NOT IN (
	SELECT DISTINCT fa.actor_id
    FROM film_actor fa
	INNER JOIN film f ON f.film_id = fa.film_id
	INNER JOIN film_category fc ON fc.film_id = f.film_id
	INNER JOIN category c ON c.category_id = fc.category_id
	WHERE c.name = 'Horror'
);

# BONUS

# 24. Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla film con subconsultas.
# SELECT * FROM film;
# SELECT * FROM film_category;
# SELECT * FROM category;

SELECT f.title AS Título
FROM film f
WHERE length >180
	AND f.film_id IN (
		SELECT fc.film_id	
        FROM film_category fc
        INNER JOIN category c ON c.category_id = fc.category_id
        WHERE c.name = 'Comedy'
);
    
# 25. Encuentra todos los actores que han actuado juntos en, al menos, una película. 
-- La consulta debe mostrar el nombre y apellido de los actores y el número de películas 
-- en las que han actuado juntos. Pista: Podemos hacer un JOIN de una tabla consigo misma,
-- poniendole un alias diferente.

# SELECT * FROM actor;
# SELECT * FROM film_actor;
# Tenemos que buscar los pares de actores que sean únicos y hacer un SELF JOIN con la tabla film_actor

SELECT CONCAT(a1.first_name,' ', a1.last_name) AS Actor1, # Para que el resultado esté más limpio he concatenado los nombres y apellidos de los pares de actores
    CONCAT(a2.first_name,' ', a2.last_name) AS Actor2,
    COUNT(*) AS Películas_Comunes # Agrupa todas las coincidencias
FROM film_actor fa1
JOIN film_actor fa2 
	ON fa1.film_id = fa2.film_id
    AND fa1.actor_id < fa2.actor_id # Devuelve pares distintos de actores
JOIN actor a1 ON fa1.actor_id = a1.actor_id
JOIN actor a2 ON fa2.actor_id = a2.actor_id
GROUP BY a1.actor_id, a1.first_name, a1.last_name, 
		a2.actor_id, a2.first_name, a2.last_name
HAVING COUNT(*) > 1 # He añadido el HAVING para que muestre el par de actores que tienen más de una película en común. Sin él también funcionaría, porque coinciden en, al menos, tres películas.
ORDER BY Películas_Comunes DESC;




