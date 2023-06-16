USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/

-- Segment 1:

-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

SELECT COUNT(*) AS director_mapping_Total_rows FROM director_mapping;
-- RESULT: 3867
SELECT COUNT(*) AS genre_Total_rows FROM genre;
-- RESULT: 14662
SELECT COUNT(*) AS Total_rows FROM movie;
-- RESULT: 7997
SELECT COUNT(*) AS names_Total_rows FROM imdb.names;
-- RESULT: 25735
SELECT COUNT(*) AS ratings_Total_rows FROM ratings;
-- RESULT: 7997
SELECT COUNT(*) AS role_mapping_Total_rows FROM role_mapping;
-- RESULT: 15615


-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT 
		COUNT(*) - COUNT(id) AS id_nullval_count, 
		COUNT(*) - COUNT(title) AS title_nullval_count,
		COUNT(*) - COUNT(year) AS year_nullval_count,
		COUNT(*) - COUNT(date_published) AS date_nullval_count,
		COUNT(*) - COUNT(duration) AS duration_nullval_count,
		COUNT(*) - COUNT(country) AS country_nullval_count,
		COUNT(*) - COUNT(worlwide_gross_income) AS grossincome_nullval_count,
		COUNT(*) - COUNT(languages) AS language_nullval_count,
		COUNT(*) - COUNT(production_company) AS prod_company_nullvalcount 
FROM movie;

/* RESULT:
id_nullval_count	title_nullval_count	year_nullval_count	date_nullval_count	duration_nullval_count	country_nullval_count	grossincome_nullval_count	language_nullval_count	prod_company_nullvalcount
0					0					0					0					0						20						3724						194						528
*/


-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT 
		movie.year AS Year, 
        COUNT(id) 
FROM movie
GROUP BY year
ORDER BY movie.year;
/*  Result -->
+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	3052     		|
|	2018		|	2944    		|
|	2019		|	2001    		|
+---------------+-------------------+
*/

SELECT 
		MONTH(date_published) AS month_num, 
        COUNT(id) AS number_of_movies
FROM movie
GROUP BY MONTH(date_published)
ORDER BY COUNT(id) DESC;
/* RESULT:
month_num	number_of_movies
3			824
9			809
1			804
10			801
4			680
8			678
2			640
11			625
5			625
6			580
7			493
12			438
*/


/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT 
		year, 
		COUNT(id) AS total_movies
FROM movie
WHERE (country REGEXP 'USA' OR country REGEXP 'INDIA') AND year = 2019;

/* RESULT:
year	total_movies
2019	1059
*/


/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
SELECT DISTINCT genre AS GENRE
FROM genre;
/* RESULT:
GENRE
Drama
Fantasy
Thriller
Comedy
Horror
Family
Romance
Adventure
Action
Sci-Fi
Crime
Mystery
Others
*/


/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT 
		g.Genre AS GENRE, 
		COUNT(m.id) AS MOVIE_COUNT
FROM 
		movie AS m INNER JOIN genre AS g 
        ON m.id = g.movie_id
GROUP BY GENRE
ORDER BY MOVIE_COUNT DESC LIMIT 1;
/* RESULT:
GENRE	MOVIE_COUNT
Drama	4285 	
*/


/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH movie_single_genre AS (
SELECT 
		m.id, 
        COUNT(g.genre) AS genre_count
FROM 
		movie AS m INNER JOIN genre AS g 
        ON m.id = g.movie_id
GROUP BY m.id
HAVING genre_count = 1
)
SELECT COUNT(id) AS MOVIE_COUNT_SINGLE_GENRE
FROM movie_single_genre;
-- RESULT: 3289


/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
		g.genre, 
        ROUND(AVG(m.duration),2) AS avg_duration
FROM 
		genre AS g INNER JOIN movie AS m 
        ON g.movie_id = m.id
GROUP BY g.genre;
/* RESULT:
genre		avg_duration
Drama		106.77
Fantasy		105.14
Thriller	101.58
Comedy		102.62
Horror		92.72
Family		100.97
Romance		109.53
Adventure	101.87
Action		112.88
Sci-Fi		97.94
Crime		107.05
Mystery		101.80
Others		100.16
*/


/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)

/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT 
		g.genre, 
        COUNT(m.id) AS movie_count, 
		RANK() OVER (ORDER BY count(m.id) DESC) AS genre_rank
FROM 
		genre AS g INNER JOIN movie AS m 
        ON g.movie_id = m.id
GROUP BY g.genre;
/* RESULT:
genre		movie_count	genre_rank
Drama		4285		1
Comedy		2412		2
Thriller	1484		3
Action		1289		4
Horror		1208		5
Romance		906			6
Crime		813			7
Adventure	591			8
Mystery		555			9
Sci-Fi		375			10
Fantasy		342			11
Family		302			12
Others		100			13
*/


/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/

-- Segment 2:

-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT 	
		MIN(avg_rating) AS min_avg_rating,
		MAX(avg_rating) AS max_avg_rating,
        MIN(total_votes) AS min_total_votes,
		MAX(total_votes) AS max_total_votes,
        MIN(median_rating) AS min_median_rating,
		MAX(median_rating) AS max_median_rating
FROM ratings;
/* RESULT:
min_avg_rating	max_avg_rating	min_total_votes	max_total_votes	min_median_rating	max_median_rating
1.0				10.0			100				725138			1					10
*/
    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too
WITH top_10 AS (
SELECT 	
		m.title, 
		r.avg_rating, 
		RANK() OVER (ORDER BY r.avg_rating DESC) AS movie_rank
FROM 
		movie AS m INNER JOIN ratings AS r
        ON m.id = r.movie_id
)
SELECT * FROM top_10
WHERE movie_rank <= 10;

/* RESULT:
title							avg_rating	movie_rank
Kirket							10.0		1
Love in Kilnerry				10.0		1
Gini Helida Kathe				9.8			3
Runam							9.7			4
Fan								9.6			5
Android Kunjappan Version 5.25	9.6			5
Yeh Suhaagraat Impossible		9.5			7
Safe							9.5			7
The Brighton Miracle			9.5			7
Shibu							9.4			10
Our Little Haven				9.4			10
Zana							9.4			10
Family of Thakurganj			9.4			10
Ananthu V/S Nusrath				9.4			10
*/

/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT
		median_rating, 
		COUNT(m.title) AS movie_count
FROM 
		ratings AS r INNER JOIN movie AS m 
		ON r.movie_id = m.id 
GROUP BY median_rating
ORDER BY movie_count DESC;

/* OUTPUT -------------------
median_ rating   movie_count
7	              2257
6	              1975
8	              1030
5	              985
4	              479
9	              429
10	              346
3	              283
2	              119
1	              94
------------------------------*/


/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

WITH cte_production_company AS
(
	SELECT 
			production_company, 
			COUNT(id) AS movie_count, 
			RANK() OVER (ORDER BY COUNT(id) DESC) AS prod_company_rank 
	FROM 
			movie AS m INNER JOIN ratings AS r 
			ON m.id = r.movie_id
	WHERE avg_rating > 8 AND production_company IS NOT NULL
	GROUP BY production_company
)
SELECT 
		production_company, 
		movie_count, 
		prod_company_rank 
FROM cte_production_company 
WHERE prod_company_rank=1;

/* RESULT:
production_company		movie_count	prod_company_rank
Dream Warrior Pictures	3			1
National Theatre Live	3			1
*/

-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
		genre, 
		COUNT(id) AS movie_count
FROM 
		movie INNER JOIN genre ON movie.id = genre.movie_id
		INNER JOIN ratings ON movie.id = ratings.movie_id
WHERE 
		MONTH(movie.date_published) = 3 AND
		movie.year = 2017 AND
		movie.country = "USA" AND
		ratings.total_votes > 1000
GROUP BY genre
ORDER BY movie_count DESC;
/*-----OUTPUT--------------
genre   movie_count
Drama	    16
Comedy	    8
Crime	    5
Horror	    5
Action	    4
Sci-Fi      4
Thriller	4
Romance	    3
Fantasy	    2
Mystery	    2
Family	    1
----------------------*/


-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
SELECT 
		title,
		avg_rating,
		genre
FROM 
		movie INNER JOIN genre ON movie.id = genre.movie_id
		INNER JOIN ratings ON movie.id = ratings.movie_id
WHERE 
		title LIKE "The%" AND 
		avg_rating > 8
ORDER BY 
		genre DESC, 
        avg_rating DESC;
/* RESULT:
title									avg_rating	genre
Theeran Adhigaaram Ondru				8.3			Thriller
The King and I							8.2			Romance
The Blue Elephant 2						8.8			Mystery
The Blue Elephant 2						8.8			Horror
The Brighton Miracle					9.5			Drama
The Colour of Darkness					9.1			Drama
The Blue Elephant 2						8.8			Drama
The Irishman							8.7			Drama
The Mystery of Godliness: The Sequel	8.5			Drama
The Gambinos							8.4			Drama
The King and I							8.2			Drama
The Irishman							8.7			Crime
The Gambinos							8.4			Crime
Theeran Adhigaaram Ondru				8.3			Crime
Theeran Adhigaaram Ondru				8.3			Action
*/


-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT 
		COUNT(ID), 
		median_rating
FROM 
		ratings INNER JOIN movie 
        ON ratings.movie_id = movie.id
WHERE date_published BETWEEN '2018-04-01' AND '2019-04-01'
GROUP BY median_rating
HAVING median_rating = 8;
/*----OUTPUT-----------------
movie_count    Median_rating
361	             8
----------------------------*/


-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

WITH german_votes_summary AS (
SELECT 
		m.languages, 
		SUM(r.total_votes) AS german_votes
FROM 	
		movie AS m INNER JOIN ratings AS r 
		ON m.id = r.movie_id
WHERE languages REGEXP 'German'
GROUP BY m.languages
)
SELECT SUM(german_votes) AS German_total_votes
FROM german_votes_summary;
-- RESULT: 4421525

WITH Italian_votes_summary AS (
SELECT 
	m.languages, SUM(r.total_votes) AS Italian_votes
FROM 	
	movie AS m INNER JOIN ratings AS r 
	ON m.id = r.movie_id
WHERE languages REGEXP 'Italian'
GROUP BY m.languages
)

SELECT SUM(Italian_votes) AS Italian_total_votes
FROM Italian_votes_summary;
-- RESULT: 2559540
-- Yes, German movies get more votes than Italian movies.


-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/

-- Segment 3:

-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
SELECT 
		COUNT(*) - COUNT(name) AS name_nulls, 
		COUNT(*) - COUNT(height) AS height_nulls,
		COUNT(*) - COUNT(date_of_birth) AS date_of_birth_nulls,
		COUNT(*) - COUNT(known_for_movies) AS known_for_movies_nulls
FROM imdb.names;

/* RESULT:
name_nulls	height_nulls	date_of_birth_nulls		known_for_movies_nulls
0			17335			13431					15226
*/


/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


WITH top3_genre AS (
SELECT 	g.genre, 
		COUNT(g.movie_id) AS genre_movie_count
FROM 	
		genre AS g INNER JOIN ratings AS r 
        ON g.movie_id = r.movie_id
WHERE avg_rating > 8
GROUP BY genre
ORDER BY genre_movie_count DESC LIMIT 3
),

top3genre_rating_summary AS (
SELECT 
		g.movie_id, 
		g.genre, 
        r.avg_rating
FROM 
		ratings AS r INNER JOIN genre AS g ON r.movie_id = g.movie_id
		INNER JOIN top3_genre AS t ON g.genre = t.genre
WHERE g.genre IN (t.genre) AND avg_rating > 8
ORDER BY avg_rating
)

SELECT 
		n.name, 	
        count(s.movie_id) AS movie_count
FROM 
		names AS n INNER JOIN director_mapping AS d ON n.id= d.name_id
		INNER JOIN top3genre_rating_summary AS s ON d.movie_id = s.movie_id
GROUP BY n.name
HAVING movie_count >= 2
ORDER BY movie_count DESC LIMIT 3;

/* RESULT:
name					movie_count
James Mangold			4
Soubin Shahir			3
Joe Russo				3
Anthony Russo			3
*/


/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
		n.name AS actor_name, 
        COUNT(rm.movie_id) AS movie_count
FROM 
		names AS n INNER JOIN role_mapping AS rm ON n.id = rm.name_id
		INNER JOIN ratings AS r ON rm.movie_id = r.movie_id
WHERE category = 'ACTOR' AND median_rating >= 8
GROUP BY actor_name
ORDER BY movie_count DESC
LIMIT 2;

/* RESULT:
# actor_name	movie_count
Mammootty		8
Mohanlal		5
*/


/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:


SELECT
		production_company, 
        SUM(total_votes) AS vote_count,
		RANK() OVER (ORDER BY SUM(total_votes) DESC) AS prod_comp_rank
FROM 
		movie AS m INNER JOIN ratings AS r ON m.id = r.movie_id
GROUP BY production_company 
LIMIT 3;

/* RESULT:

production_company		vote_count	prod_comp_rank
Marvel Studios			2656967		1
Twentieth Century Fox	2411163		2
Warner Bros.			2396057		3

*/


/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT
		n.name AS actor_name,
		SUM(total_votes) AS total_votes, 
		COUNT(rm.movie_id) AS movie_count,
		ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) AS actor_avg_rating,
		RANK () OVER ( ORDER BY ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) DESC) AS actor_rank
FROM 
		names AS n INNER JOIN role_mapping AS rm ON n.id = rm.name_id
		INNER JOIN movie AS m ON rm.movie_id = m.id 
		INNER JOIN ratings AS r ON m.id = r.movie_id
WHERE rm.category = "actor" AND m.country REGEXP "INDIA"
GROUP BY actor_name
HAVING movie_count >= 5;
-- YES, top actor is Vijay Sethupathi



-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT 
		n.name AS actress_name,
		SUM(total_votes) AS total_votes, 
		COUNT(rm.movie_id) AS movie_count,
		ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) AS actress_avg_rating,
		RANK () OVER ( ORDER BY ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) DESC) AS actress_rank
FROM 
		names AS n INNER JOIN role_mapping AS rm ON n.id = rm.name_id
		INNER JOIN movie AS m ON rm.movie_id = m.id 
		INNER JOIN ratings AS r ON m.id = r.movie_id
WHERE rm.category = "actress" AND m.country REGEXP "INDIA" AND m.languages REGEXP "HINDI" 
GROUP BY actress_name
HAVING movie_count >= 3
LIMIT 5;
-- Yes, Taapsee Pannu tops with average rating 7.74


/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:
    
WITH classification_movies AS
(
	SELECT 
			genre,
			avg_rating
	FROM genre INNER JOIN ratings USING (movie_id)
	WHERE genre = 'Thriller'
)
SELECT * ,
CASE WHEN avg_rating > 8 THEN "Superhit Movies"
	 WHEN avg_rating BETWEEN 7 AND 8 THEN "Hit Movies"
     WHEN avg_rating BETWEEN 5 AND 7 THEN "One-time Watch Movies"
     ELSE "Flop Movies"
END AS "Classification of Movies"
FROM classification_movies;


/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT 
		genre,
		ROUND(avg(duration),2) AS avg_duration,
        SUM(ROUND(AVG(duration), 2)) OVER (ORDER BY genre ROWS UNBOUNDED PRECEDING) AS running_total_duration,
		AVG(ROUND(AVG(duration),2)) OVER (ORDER BY genre ROWS UNBOUNDED PRECEDING) AS moving_avg_duration
FROM 
		genre AS g INNER JOIN movie AS m ON g.movie_id = m.id
GROUP BY genre;
/* RESULT:
genre		avg_duration	running_total_duration	moving_avg_duration
Action		112.88			112.88					112.880000
Adventure	101.87			214.75					107.375000
Comedy		102.62			317.37					105.790000
Crime		107.05			424.42					106.105000
Drama		106.77			531.19					106.238000
Family		100.97			632.16					105.360000
Fantasy		105.14			737.30					105.328571
Horror		92.72			830.02					103.752500
Mystery		101.80			931.82					103.535556
Others		100.16			1031.98					103.198000
Romance		109.53			1141.51					103.773636
Sci-Fi		97.94			1239.45					103.287500
Thriller	101.58			1341.03					103.156154
*/

-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

WITH top3_genre AS (
SELECT 	g.genre, 
		COUNT(g.movie_id) AS genre_movie_count
FROM 	
		genre AS g INNER JOIN ratings AS r ON g.movie_id = r.movie_id
GROUP BY genre
ORDER BY genre_movie_count DESC LIMIT 3
),

gross_income_summary AS (
SELECT 
		g.genre,
        m.year,
        title AS movie_name,
        worlwide_gross_income,
        DENSE_RANK() OVER (PARTITION BY year ORDER BY worlwide_gross_income DESC) AS movie_rank
FROM
		top3_genre AS t INNER JOIN genre AS g ON t.genre = g.genre 
        INNER JOIN movie AS m ON g.movie_id = m.id
WHERE g.genre IN (t.genre)
)
SELECT * FROM gross_income_summary
WHERE movie_rank <= 5;

/* RESULT:
genre		year	movie_name					worlwide_gross_income	movie_rank
Drama		2017	Shatamanam Bhavati			INR 530500000			1
Drama		2017	Winner						INR 250000000			2
Drama		2017	Thank You for Your Service	$ 9995692				3
Comedy		2017	The Healer					$ 9979800				4
Drama		2017	The Healer					$ 9979800				4
Thriller	2017	Gi-eok-ui bam				$ 9968972				5
Thriller	2018	The Villain					INR 1300000000			1
Drama		2018	Antony & Cleopatra			$ 998079				2
Comedy		2018	La fuitina sbagliata		$ 992070				3
Drama		2018	Zaba						$ 991					4
Comedy		2018	Gung-hab					$ 9899017				5
Thriller	2019	Prescience					$ 9956					1
Thriller	2019	Joker						$ 995064593				2
Drama		2019	Joker						$ 995064593				2
Comedy		2019	Eaten by Lions				$ 99276					3
Comedy		2019	Friend Zone					$ 9894885				4
Drama		2019	Nur eine Frau				$ 9884					5

*/

-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT
		production_company,
		COUNT(m.id) AS movie_count,
        RANK() OVER (ORDER BY COUNT(m.id) DESC) AS prod_comp_rank
FROM
		movie AS m INNER JOIN ratings AS r ON m.id = r.movie_id
WHERE median_rating >= 8 AND production_company IS NOT NULL AND POSITION(',' IN languages)>0
GROUP BY production_company
LIMIT 2;
/* RESULT:
production_company		movie_count	prod_comp_rank
Star Cinema				7			1
Twentieth Century Fox	4			2
*/


-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT
		name AS actress_name,
        SUM(total_votes) AS total_votes,
        COUNT(rm.movie_id) AS movie_count,
        AVG(avg_rating) AS actress_avg_rating,
        DENSE_RANK() OVER (ORDER BY AVG(avg_rating) DESC) AS actress_rank
FROM
		names AS n INNER JOIN role_mapping AS rm ON n.id = rm.name_id
        INNER JOIN ratings AS r ON rm.movie_id = r.movie_id
        INNER JOIN genre AS g ON r.movie_id = g.movie_id
WHERE rm.category = 'actress' AND avg_rating > 8 AND g.genre REGEXP 'DRAMA'
	
GROUP BY n.name
LIMIT 3;

/* RESULT:
actress_name		total_votes	movie_count	actress_avg_rating	actress_rank
Sangeetha Bhat		1010		1			9.60000				1
Fatmire Sahiti		3932		1			9.40000				2
Adriana Matoshi		3932		1			9.40000				2
*/


/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:


WITH days_diff_summary AS (
SELECT 
		dm.name_id AS director_id, 
        n.name AS director_name, 
        dm.movie_id AS movieid, 
        date_published,
		LEAD(m.date_published) OVER(PARTITION BY dm.name_id ORDER BY date_published, dm.movie_id) AS next_date_published,
        DATEDIFF(LEAD(m.date_published) OVER(PARTITION BY dm.name_id ORDER BY date_published), date_published) AS days_diff
        
FROM 
		names AS n INNER JOIN director_mapping AS dm ON n.id = dm.name_id
		INNER JOIN movie AS m ON dm.movie_id = m.id
)

SELECT 	
			dds.director_id AS director_id,
			dds.director_name AS director_name,
			COUNT(dds.movieid) AS number_of_movies,
			ROUND(AVG(dds.days_diff),2) AS avg_inter_movie_days,
			ROUND(AVG(r.avg_rating),2) AS avg_rating,
			SUM(r.total_votes) AS total_votes,
			MIN(r.avg_rating) AS min_rating,
			MAX(r.avg_rating) AS max_rating,
			SUM(m.duration) AS total_duration

FROM
			days_diff_summary AS dds INNER JOIN movie AS m ON dds.movieid = m.id
			INNER JOIN ratings AS r ON m.id = r.movie_id		
       
GROUP BY
			dds.director_id, 
			dds.director_name
ORDER BY 
			count(dds.movieid) DESC, 
			ROUND(AVG(dds.days_diff),2) DESC
LIMIT 9;   

/* RESULT:
director_id	director_name		number_of_movies	avg_inter_movie_days	avg_rating	total_votes	min_rating	max_rating	total_duration
nm2096009	Andrew Jones		5					190.75					3.02		1989		2.7			3.2			432
nm1777967	A.L. Vijay			5					176.75					5.42		1754		3.7			6.9			613
nm0814469	Sion Sono			4					331.00					6.03		2972		5.4			6.4			502
nm2691863	Justin Price		4					315.00					4.50		5343		3.0			5.8			346
nm0425364	Jesse V. Johnson	4					299.00					5.45		14778		4.2			6.5			383
nm0515005	Sam Liu				4					260.33					6.23		28557		5.8			6.7			312
nm0001752	Steven Soderbergh	4					254.33					6.48		171684		6.2			7.0			401
nm0831321	Chris Stokes		4					198.33					4.33		3664		4.0			4.6			352
nm6356309	Özgür Bakar			4					112.00					3.75		1092		3.1			4.9			374
