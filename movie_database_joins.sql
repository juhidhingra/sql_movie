/*name of all reviewers who rated their rating with NULL value*/

SELECT reviewer.rev_name, rating.rev_stars 
   FROM reviewer
		JOIN rating 
			ON reviewer.rev_id = rating.rev_id
				WHERE rating.rev_stars IS NULL;




/*list the first & last names of all actors who were cast in the movie 'Annie Hall' and the roles they played in that production*/

SELECT act_fname,act_lname,role
  	FROM actor 
		JOIN movie_cast 
	  		ON actor.act_id=movie_cast.act_id
	 	JOIN movie 
	 		ON movie_cast.mov_id=movie.mov_id 
		  	AND movie.mov_title='Annie Hall';




/*find the name of movie and director (first and last names) who directed a movie that casted a role for 'Eyes Wide Shut'*/

SELECT dir_fname AS Name, dir_lname AS "Last Name", mov_title AS "Movie Title"
	FROM director 
		JOIN movie_direction 
			ON director.dir_id = movie_direction.dir_id
		JOIN movie_cast 
				ON movie_direction.mov_id = movie_cast.mov_id
		JOIN movie 
				ON movie_cast.mov_id = movie.mov_id
		WHERE mov_title = 'Eyes Wide Shut';



/*find the name of movie and director (first and last names) who directed a movie that casted a role as Sean Maguire*/


SELECT dir_fname, dir_lname, mov_title
	FROM  director 
		JOIN movie_direction 
  			ON director.dir_id=movie_direction.dir_id
		JOIN movie 
 			 ON movie_direction.mov_id=movie.mov_id
		JOIN movie_cast 
 			 ON movie_cast.mov_id=movie.mov_id
  		WHERE role='Sean Maguire';



/*list all the actors who acted in a movie before 1990 and also in a movie after 2000*/


SELECT act_fname, act_lname, mov_title, mov_year
		FROM actor
			JOIN movie_cast 
				ON actor.act_id=movie_cast.act_id
			JOIN movie 
				ON movie_cast.mov_id=movie.mov_id
			WHERE mov_year NOT BETWEEN 1990 and 2000;



/*list first and last name of all the directors with number of genres movies the directed with genres name, and arranged the result alphabetically with the first and last name of the director*/


SELECT dir_fname,dir_lname, gen_title,COUNT(gen_title)
		FROM director
			NATURAL JOIN movie_direction
			NATURAL JOIN movie_genres
			NATURAL JOIN genres
			GROUP BY dir_fname, dir_lname,gen_title
			ORDER BY dir_fname,dir_lname;



/*list all the movies with year, genres, and name of the director*/


SELECT mov_title, mov_year, gen_title, dir_fname, dir_lname
		FROM movie
			NATURAL JOIN movie_genres
			NATURAL JOIN genres
			NATURAL JOIN movie_direction
			NATURAL JOIN director;



/*list all the movies with title, year, date of release, movie duration, and first and last name of the director which released before 1st january 1989, and sort the result set according to release date from highest date to lowest*/


SELECT movie.mov_title, mov_year, mov_dt_rel, mov_time,dir_fname, dir_lname 
	FROM movie
			JOIN  movie_direction 
  				ON movie.mov_id = movie_direction.mov_id
			JOIN director 
  				 ON movie_direction.dir_id=director.dir_id
			WHERE mov_dt_rel <'01/01/1989'
			ORDER BY mov_dt_rel desc;



/*compute a report which contain the genres of those movies with their average time and number of movies for each genres*/


SELECT gen_title, AVG(mov_time), COUNT(gen_title) 
		FROM movie
			NATURAL JOIN  movie_genres
			NATURAL JOIN  genres
			GROUP BY gen_title;



/*find those lowest duration movies along with the year, director's name, actor's name and his/her role in that production*/


SELECT mov_title, mov_year, dir_fname, dir_lname, act_fname, act_lname, role 
	FROM  movie
		NATURAL JOIN movie_direction
		NATURAL JOIN movie_cast
		NATURAL JOIN director
		NATURAL JOIN actor
			WHERE mov_time=(SELECT MIN(mov_time) FROM movie);


/*find all the years which produced a movie that received a rating of 3 or 4, and sort the result in increasing order*/


SELECT DISTINCT mov_year
	FROM movie
		 JOIN rating 
			ON movie.mov_id = rating.mov_id
			WHERE rev_stars IN (3, 4)
			ORDER BY mov_year;


/*return the reviewer name, movie title, and stars in an order that reviewer name will come first, then by movie title, and lastly by number of stars*/


SELECT rev_name, mov_title, rev_stars
	FROM movie
		JOIN rating 
			ON movie.mov_id = rating.mov_id
		JOIN reviewer
			 ON reviewer.rev_id = rating.rev_id
			WHERE rev_name IS NOT NULL
			ORDER BY rev_name, mov_title, rev_stars;



/*find movie title and number of stars for each movie that has at least one rating and find the highest number of stars that movie received and sort the result by movie title*/


SELECT mov_title, MAX(rev_stars)
	FROM movie
		JOIN rating 
			ON movie.mov_id = rating.mov_id
			GROUP BY mov_title 
			HAVING MAX(rev_stars) >= 1
			ORDER BY mov_title;


/*find the director's first and last name together with the title of the movie(s) they directed and received the rating*/


SELECT mov_title, dir_fname,dir_lname, rev_stars
	FROM director
		JOIN movie_direction
			ON director.dir_id=movie_direction.dir_id
		JOIN movie
			ON movie_direction.mov_id=movie.mov_id
		JOIN rating
			ON movie.mov_id=rating.mov_id
		WHERE rev_stars is NOT NULL


/*find the movie title, actor first and last name, and the role for those movies where one or more actors acted in two or more movies*/


SELECT mov_title, act_fname, act_lname, role
	FROM movie 
		JOIN movie_cast 
 			 ON movie_cast.mov_id=movie.mov_id 
		JOIN actor 
 			 ON movie_cast.act_id=actor.act_id
				WHERE actor.act_id IN (
						SELECT act_id 
						FROM movie_cast 
						GROUP BY act_id HAVING COUNT(*)>=2);



