-- Advanced SQL Project -- Spotify Database
-- create table
DROP TABLE IF EXISTS spotify;
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
);


--EDA

select count(*) from spotify;
select count(distinct artist) from spotify;
select count(distinct album) from spotify;
select distinct album_type from spotify;
select duration_min from spotify;
select max(duration_min) from spotify;
select min(duration_min) from spotify;
select * from spotify 
where duration_min =0;
delete from spotify
where duration_min =0;
select distinct most_played_on from spotify;
select distinct channel from spotify;


--QUestions EASY CATEGORY--

-- Retrieve the names of all tracks that have more than 1 billion streams.
-- List all albums along with their respective artists.
-- Get the total number of comments for tracks where licensed = TRUE.
-- Find all tracks that belong to the album type single.
-- Count the total number of tracks by each artist.

--1
select * from spotify
where stream > 1000000000;
--2
select album,artist
from spotify;
--3
select count(comments) from spotify
where licensed=true;
--4
select track from spotify
where album_type='single';
--5
select artist,count(*) as No_of_songs from spotify
group by artist
order by 2 desc;


--MEDIUM LEVEL 

-- Calculate the average danceability of tracks in each album.
-- Find the top 5 tracks with the highest energy values.
-- List all tracks along with their views and likes where official_video = TRUE.
-- For each album, calculate the total views of all associated tracks.
-- Retrieve the track names that have been streamed on Spotify more than YouTube.

--1
select album,avg(danceability) as Average_Danceability from spotify
group by album;

--2
select track,max(energy) as highest_energy
from spotify
group by 1
limit 5;

--3
select * from spotify;
select track,views,likes
from spotify
where official_video=True;

--4
select album,track,sum(views)
from spotify 
group by 1,2
order by 3 desc;

--5
select * from spotify;
select track,stream

--ADVANCE LEVEL

-- Find the top 3 most-viewed tracks for each artist using window functions.
-- Write a query to find tracks where the liveness score is above the average.
-- Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.

--1
WITH ranking_artist
AS
(select artist,album,sum(views) as total_views,
dense_rank() over(Partition by artist order by sum(views) desc) as rank 
from spotify
group by 1,2
order by 1,3 desc) select * from ranking_artist where rank <=3;

--each artist and total view for each track
--we need top 3 viewed tracks
--dense rank
--cte and filter 


--2
select avg(liveness) from spotify;

select track,album,liveness from spotify
where liveness > (select avg(liveness) from spotify);

--3
WITH cte
as 
(select album,max(energy) as highest_energy,min(energy) as lowest_energy
from spotify
group by 1)
select album,highest_energy-lowest_energy as energy_difference
from cte;