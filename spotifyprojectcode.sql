#DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);)



SELECT * FROM public.spotify
LIMIT 100;

-- EDA
select count(*) from spotify;


select count(distinct artist) from spotify;

select count(distinct album) from spotify;

select distinct album_type from spotify;

select duration_min from spotify;



select max(duration_min) from spotify;

select min(duration_min) from spotify;


select * from spotify
where duration_min = 0;



delete from spotify
where duration_min = 0;


select * from spotify
where duration_min = 0;

select distinct channel from spotify;


select distinct  most_played_on from spotify;


-- Data Analysis questions Part 1 
/*

Retrieve the names of all tracks that have more than 1 billion streams.
List all albums along with their respective artists.
Get the total number of comments for tracks where licensed = TRUE.
Find all tracks that belong to the album type single.
Count the total number of tracks by each artist.  */


-- Retrieve the names of all tracks that have more than 1 billion streams.
SELECT * FROM spotify;

SELECT track
FROM spotify
WHERE stream > 1000000000;

-- List all albums along with their respective artists.

SELECT * FROM spotify;

SELECT distinct album, artist
FROM spotify
ORDER BY 1;

--Get the total number of comments for tracks where licensed = TRUE.

SELECT * FROM spotify;

-- just to make sure we only have true and false in data
SELECT DISTINCT(licensed) FROM spotify;

SELECT SUM(comments) AS total_count
FROM spotify
WHERE licensed = 'true';


-- Find all tracks that belong to the album type single.

SELECT * 
FROM spotify;

SELECT DISTINCT(album_type) FROM spotify;

SELECT track
FROM spotify
WHERE album_type = 'single'


-- Count the total number of tracks by each artist.

SELECT * 
FROM spotify;

SELECT artist, COUNT(track)
FROM spotify
GROUP BY artist
ORDER BY 2;

-- QUESTION SET 2

/* Calculate the average danceability of tracks in each album.
Find the top 5 tracks with the highest energy values.
List all tracks along with their views and likes where official_video = TRUE.
For each album, calculate the total views of all associated tracks.
Retrieve the track names that have been streamed on Spotify more than YouTube. */

--  Calculate the average danceability of tracks in each album.

SELECT *
FROM spotify;

SELECT album, AVG(danceability) as avg_danceability
FROM spotify
GROUP BY album
ORDER BY 2 DESC;

-- Find the top 5 tracks with the highest energy values.

SELECT *
FROM spotify;

SELECT track, MAX(energy)
FROM spotify
GROUP BY 1
ORDER BY 2 DESC 
LIMIT 5;

-- List all tracks along with their views and likes where official_video = TRUE.

SELECT *
FROM spotify;




SELECT DISTINCT official_video
FROM spotify;



SELECT track, 'views' as total_views, likes
FROM spotify
WHERE official_video = 'true';



SELECT track, 
SUM(views) as total_views, 
SUM(likes) as toatal_likes
FROM spotify
WHERE official_video = 'true'
GROUP BY track
ORDER BY 2 DESC;


--For each album, calculate the total views of all associated tracks.

SELECT * from spotify;

SELECT album, track,
SUM(views) as total_views
FROM spotify
GROUP BY album, track
ORDER BY 3 DESC;


-- Retrieve the track names that have been streamed on Spotify more than YouTube.

SELECT * from spotify;


SELECT * 
FROM	
(SELECT  
	track,
	COALESCE (SUM (CASE WHEN most_played_on = 'Spotify' then stream END), 0) as streamed_on_spotify,
	COALESCE (SUM (CASE WHEN most_played_on = 'Youtube' then stream END), 0) as streamed_on_youtube
	FROM spotify
	GROUP BY 1) as t1
WHERE 
	streamed_on_spotify < streamed_on_youtube
AND 
	streamed_on_spotify <> 0 ;



/*
Find the top 3 most-viewed tracks for each artist using window functions.
Write a query to find tracks where the liveness score is above the average.
Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.
*/


-- Find the top 3 most-viewed tracks for each artist using window functions.


SELECT * from spotify;


WITH ranking_artist
AS
(
SELECT artist, track, SUM(views) as total_view,
	DENSE_RANK() OVER(PARTITION BY artist ORDER BY SUM(views) DESC) as Rank
FROM spotify
GROUP BY 1,2
ORDER BY 1,3 DESC
)
SELECT * FROM ranking_artist
WHERE Rank <=3


-- Write a query to find tracks where the liveness score is above the average.

SELECT * 
FROM spotify;


SELECT AVG(liveness)
FROM spotify; -- 0.19


SELECT track,
	artist,
	liveness
FROM spotify 
WHERE liveness > (SELECT AVG(liveness)
FROM spotify);


-- Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.


SELECT * 
FROM spotify;


WITH cte
AS
(	
SELECT 
	album,
	MAX(energy) as highest_energy,
	MIN(energy) as lowest_energy	
FROM spotify
GROUP BY 1)
	
SELECT 
	album,
	highest_energy - lowest_energy as energy_diff
FROM cte
ORDER BY 2 DESC;


