create database netflix_project;
use netflix_project;
CREATE TABLE Users (
    user_id INT PRIMARY KEY,
    name VARCHAR(50),
    email VARCHAR(100),
    country VARCHAR(50),
    subscription_type VARCHAR(20),
    join_date DATE
);

CREATE TABLE Movies (
    movie_id INT PRIMARY KEY,
    title VARCHAR(100),
    release_year INT,
    duration INT
);

CREATE TABLE Genres (
    genre_id INT PRIMARY KEY,
    genre_name VARCHAR(50)
);

CREATE TABLE Movie_Genre (
    movie_id INT,
    genre_id INT,
    FOREIGN KEY (movie_id) REFERENCES Movies(movie_id),
    FOREIGN KEY (genre_id) REFERENCES Genres(genre_id)
);

CREATE TABLE Watch_History (
    history_id INT PRIMARY KEY,
    user_id INT,
    movie_id INT,
    watch_date DATE,
    watch_time INT,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (movie_id) REFERENCES Movies(movie_id)
);

CREATE TABLE Ratings (
    rating_id INT PRIMARY KEY,
    user_id INT,
    movie_id INT,
    rating INT,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (movie_id) REFERENCES Movies(movie_id)
);

show tables;

CREATE TABLE netflix_titles (
    show_id VARCHAR(10),
    title VARCHAR(200),
    director VARCHAR(200),
    country VARCHAR(100),
    date_added VARCHAR(50),
    release_year INT,
    rating VARCHAR(20),
    duration VARCHAR(20),
    listed_in VARCHAR(100)
);

select * from netflix_titles limit 10;

SELECT COUNT(*) AS total_titles
FROM netflix_titles;

SELECT release_year, COUNT(*) AS total
FROM netflix_titles
GROUP BY release_year
ORDER BY release_year;

SELECT country, COUNT(*) AS total
FROM netflix_titles
GROUP BY country
ORDER BY total DESC
LIMIT 10;

SELECT listed_in, COUNT(*) AS total
FROM netflix_titles
GROUP BY listed_in
ORDER BY total DESC
LIMIT 10;

SELECT title, release_year
FROM netflix_titles
WHERE release_year > 2015;

select country, count(*) as count_of_movies
from netflix_titles
group by country
order by count_of_movies desc
limit 5;

select listed_in, count(*) as count_of_genre
from netflix_titles 
group by listed_in
order by count_of_genre desc
limit 5;


select release_year, count(*) count_of_release
from netflix_titles
group by release_year
order by count_of_release desc
limit 5;

select movie_id, avg(watch_time) as avg_watching_time
from Watch_History 
group by movie_id
order by avg_watching_time desc
limit 5;

select title, release_year, dense_rank() over(order by release_year) as ranking
from netflix_titles
limit 10;

select title, country, release_year,
rank() over(partition by country order by release_year desc) as country_rank
from netflix_titles
limit 100;


select country, title
from (select title,release_year,country ,rank() over(partition by country order by release_year) as rnk from netflix_titles)t
where rnk<=3; 

with movie_count as(
	select country, count(*) as total_movies
	from netflix_titles
	group by country
)

select * from movie_count order by total_movies desc;

select title, listed_in from netflix_titles
where listed_in = (
select listed_in
from netflix_titles
group by listed_in
order by count(*) desc
limit 1);

DELIMITER //

CREATE PROCEDURE GetMoviesByCountry(IN country_name VARCHAR(50))
BEGIN
    SELECT title, country, release_year
    FROM netflix_titles
    WHERE country = country_name;
END //

DELIMITER ;

CALL GetMoviesByCountry('India');


DELIMITER //

CREATE PROCEDURE LatestMovies()
BEGIN
    SELECT title, release_year
    FROM netflix_titles
    ORDER BY release_year DESC
    LIMIT 10;
END //

DELIMITER ;

CALL LatestMovies();

select title from netflix_titles
where listed_in like 'Action%';


select * from netflix_titles;