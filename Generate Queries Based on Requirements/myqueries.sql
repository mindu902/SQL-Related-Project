----------------------------------------------------------------
--

----------------------------------------------------------------
--Please enter your answers to Q2.1-Q2.10 of Question 2 in the following section
----------------------------------------------------------------

-- Q2.1
SELECT title, production_year, run_time 
FROM Movie
WHERE run_time < 90 OR run_time > 180
ORDER BY run_time ASC;





-- Q2.2

-- The number of movies produced in Germany from 1995 to 2005 divided by the total number of movies 
-- produced from 1995 to 2005. The numbers are cast as float, so the result is decimal.

SELECT
    CAST(COUNT(M1.*) AS FLOAT) / 
    CAST( ( SELECT
        	COUNT(M2.*) 
    		FROM
        	Movie M2 
    		WHERE
        	production_year >= 1995 
        	AND production_year <= 2005) AS FLOAT) AS "percentage" 
    FROM
        Movie M1 
    WHERE
        production_year >= 1995 
        AND production_year <= 2005 
        AND country = 'Germany';





-- Q2.3
SELECT
(m.production_year - p.year_born) AS age_of_director 
FROM
    Person p 
    INNER JOIN
        Director d 
        ON p.id = d.id 
    INNER JOIN
        Movie m 
        ON m.title = d.title 
        AND m.production_year = d.production_year 
WHERE
    d.title = 'Titanic';





-- Q2.4

-- Join the Director table, Writer table and Role table to get the Person IDs that exist in all tables.

SELECT DISTINCT
    p.id,
    p.first_name,
    p.last_name 
FROM
    Person p 
    INNER JOIN
        Director d 
        ON p.id = d.id 
    INNER JOIN
        Writer w 
        ON d.id = w.id 
        AND d.title = w.title 
        AND d.production_year = w.production_year 
    INNER JOIN
        Role r 
        ON d.id = r.id 
        AND d.title = r.title 
        AND d.production_year = r.production_year;






-- Q2.5
SELECT
    d.title,
    d.production_year,
    p.first_name,
    p.last_name 
FROM
    Person p 
    INNER JOIN
        Director d 
        ON p.id = d.id 
    INNER JOIN
        Movie_Award m 
        ON m.title = d.title 
        AND m.production_year = d.production_year 
WHERE
    m.RESULT = 'won' 
    AND m.award_name = 'Oscar';





-- Q2.6

-- Exclude all actors who have performed in different movies.

SELECT DISTINCT
    p.first_name,
    p.last_name,
    r1.title,
    r1.production_year 
FROM
    Person p 
    INNER JOIN
        Role r1 
        ON p.id = r1.id 
WHERE
    NOT EXISTS 
    (
        SELECT
            * 
        FROM
            Role r2 
        WHERE
            r2.title <> r1.title 
            AND r2.production_year <> r1.production_year 
            AND r1.id = r2.id
    );





-- Q2.7

-- Find the largest number of distinct actors within a movie, 
-- and then find the movies with that same amount of distinct actors.

SELECT
    title,
    production_year,
    COUNT(DISTINCT id) AS num_of_distinct_actors 
FROM
    Role 
GROUP BY
    title,
    production_year 
HAVING
    COUNT(DISTINCT id) = 
    (
        SELECT
            COUNT(DISTINCT id) 
        FROM
            Role 
        GROUP BY
            title,
            production_year 
        ORDER BY
            COUNT(DISTINCT id) DESC LIMIT 1
    );





-- Q2.8
-- Inner join Role table, Actor_Award table and Appearance table, then find the actors whom appeared in
-- less than 5 distinct scenes in the movies that won the actor award.

SELECT DISTINCT
    r1.id,
    p.first_name,
    p.last_name 
FROM
    Person p 
    INNER JOIN
        Role r1 
        ON p.id = r1.id 
    INNER JOIN
        Actor_Award aa 
        ON r1.title = aa.title 
        AND r1.production_year = aa.production_year 
        AND r1.description = aa.description 
    INNER JOIN
        Appearance ap 
        ON aa.title = ap.title 
        AND aa.production_year = ap.production_year 
        AND aa.description = ap.description 
WHERE
    RESULT = 'won' 
GROUP BY
    r1.id,
    r1.title,
    r1.production_year,
    p.first_name,
    p.last_name 
HAVING
    COUNT(DISTINCT ap.scene_no) < 5;





-- Q2.9
-- To identify the writers who collaborated with others in each movie.
-- Find the movies with only one writer and then eliminate all those writers.
-- The remaining writers are the ones we are looking for.

SELECT DISTINCT
    w3.id,
    p.first_name,
    p.last_name 
FROM
    Person p 
    INNER JOIN
        Writer w3 
        ON p.id = w3.id 
WHERE
    w3.id NOT IN 
    (
        SELECT DISTINCT
            w2.id 
        FROM
            Writer w2 
        WHERE
            (
                w2.title,
                w2.production_year
            )
            IN 
            (
                SELECT
                    w1.title,
                    w1.production_year 
                FROM
                    Writer w1 
                GROUP BY
                    w1.title,
                    w1.production_year 
                HAVING
                    COUNT(*) = 1
            )
    );





-- Q2.10
-- To get the directors whom have starred in every movie directed by themselves.
-- Exclude all directors who have not appeared in at least one movie they directed.

SELECT DISTINCT
    d2.id,
    p.first_name,
    p.last_name 
FROM
    Person p 
    INNER JOIN
        Director d2 
        ON p.id = d2.id 
WHERE
    d2.id NOT IN 
    (
        SELECT
            d1.id 
        FROM
            Director d1 
            LEFT JOIN
                role r1 
                ON d1.id = r1.id 
                AND d1.title = r1.title 
                AND d1.production_year = r1.production_year 
        WHERE
            r1.id IS NULL
    );


-----------------------------------------------------------------
-- End of your answers
-----------------------------------------------------------------
