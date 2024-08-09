# Creating Database for Project:
CREATE DATABASE video_game_project;

USE video_game_project;


# Importing Data:
CREATE TABLE video_game_sales(
id INT PRIMARY KEY,
Ranks INT,
GameTitle VARCHAR(200),
Platform VARCHAR(100),
Years VARCHAR(10),  
Genre VARCHAR(100),
Publisher VARCHAR(100),
NorthAmerica DOUBLE,
Europe DOUBLE,
Japan DOUBLE,
Rest_of_World DOUBLE,
Global_sale DOUBLE,
Review DOUBLE
);
# Error Code: 1366. Incorrect integer value: '' for column 'Year' at row 144
# As null values in Year, we will deal with it later.

LOAD DATA INFILE "Video Games Sales.csv"
INTO TABLE video_game_sales
FIELDS TERMINATED BY ','
ENCLOSED BY '"' 
IGNORE 1 LINES 
;
# Error Code: 1265. Data truncated for column 'NorthAmerica' at row 750
# without ENCLOSED BY '"'


# Data Cleaning :

SELECT * FROM video_game_sales;

DESCRIBE video_game_sales;

SELECT COUNT(*) AS Total_Records FROM video_game_sales;
# Total_Records = '1907'

# Finding Blank values in Year Column:
SELECT * 
FROM 
	video_game_sales
WHERE 
	Years = ''
;

# Replacing Blank Values:
SET SQL_SAFE_UPDATES = 0;
UPDATE video_game_sales 
SET Years = NULL WHERE Years = '';

# Modifying the Data-type of Years Column:
ALTER TABLE video_game_sales MODIFY Years YEAR;

# Checking the Data-types:
DESCRIBE video_game_sales;

# Checking Duplicates:
SELECT * 
FROM 
	video_game_sales
GROUP BY 
	id
HAVING 
	COUNT(id) <> 1;

-- --------------------------------------------------------------------------
# Analysis:

# Total number of Unique Games/Platforms/Genre/Publisher/:
SELECT 
	COUNT(DISTINCT GameTitle) AS unique_games,
    COUNT(DISTINCT Platform) AS unique_platforms,
    COUNT(DISTINCT Genre) AS unique_genre,
    COUNT(DISTINCT Publisher) AS unique_publisher
FROM
	video_game_sales; 
# unique_games = 1519; unique_platforms = 22; unique_genre = 12; 
# unique_publisher = 95


# QUE : Overall Regional Sales and Global Sales 
SELECT 
    CONCAT(ROUND(SUM(NorthAmerica),2),'M') AS North_America_Sales, 
	CONCAT(ROUND(SUM(Europe),2),'M') AS Europe_Sales, 
	CONCAT(ROUND(SUM(Japan),2),'M') AS Japan_Sales, 
	CONCAT(ROUND(SUM(Rest_of_World),2),'M') AS Rest_of_World_Sales,
    CONCAT(ROUND(SUM(Global_sale),2),'M') AS Global_sales
FROM 
	video_game_sales;

# North_America_Sales = 2400.51, Europe_Sales = 1347.63, 
# Japan_Sales = 605.46, Rest_of_World_Sales = 393.74, Global_sale = 4746.98


# QUE : Yearly Sales Trends
SELECT 
	Years, 
	round(SUM(Global_sale),2) AS Global_Sales
FROM 
	video_game_sales
WHERE 
	Years IS NOT NULL
GROUP BY 
	1
ORDER BY 
	1
;


# QUE: Year-wise distribution of games 
SELECT 
	Years,
    COUNT(id) AS Total_games
FROM
	video_game_sales
GROUP BY 
	1
ORDER BY 
	1
;


# QUE: Highest Global_Sales year
SELECT 
	Years,
    SUM(Global_Sale)
FROM 
	video_game_sales
GROUP BY 
	1
ORDER BY 
	2 DESC
LIMIT
	1
;
-- Year 2008 = highest sales.


# QUE: Best Selling Video Game
SELECT
	GameTitle,
	Global_Sale
FROM 
	video_game_sales
ORDER BY 
	2 DESC
LIMIT 
	1;
-- 	Wii Sports	= 81.12


# Second Highest Popular Genre 
SELECT 
	Genre,
    AVG(Review)
FROM
	video_game_sales
GROUP BY 
	1
ORDER BY 
	2 DESC
LIMIT 
	1,1
;
-- Strategy	= 82.43724999999999


# QUE : Total number of games launched by different platforms 
SELECT 
	DISTINCT Platform,
    COUNT(id) AS Total_games_launched
FROM 
	video_game_sales
GROUP BY 1
ORDER BY 2 DESC
;


# QUE : Average Review 
SELECT 
	ROUND(AVG(Review),2) AS Average_review
FROM 
	video_game_sales;
# Average_review = '79.04'


# QUE : Top 10 Games by Highest Review
SELECT 
	GameTitle,
    Review
FROM 
	video_game_sales
ORDER BY 
	1 DESC
LIMIT
	10
;
-- 'Zumba Fitness 2', '78'


# QUE: Bottom 10 videogames by Lowest Reviews
SELECT
	GameTitle,
    Review
FROM 
	video_game_sales
ORDER BY 
	2
LIMIT 
	10 
;
-- 	AMF Bowling Pinbusters!	30.5


# Top 5 Popular publishers based on Global Sales

SELECT 
	Publisher,
    ROUND(SUM(Global_sale),2) AS Global_Sales
FROM 
	video_game_sales
GROUP BY 
	1
ORDER BY 
	2 DESC 
LIMIT 
	5
;
-- 	Nintendo = 1448.84


# QUE : Top 5 Platforms who have Highest demand Based on Global Sales
SELECT 
	Platform,
    ROUND(SUM(Global_Sale),2) AS Global_Sales
FROM
	video_game_sales
GROUP BY 
	1
ORDER BY 
	2 DESC
LIMIT 
	5
;
-- 	PS2	= 823.79


# QUE : Top 5 videogames with genre based on Global Sales
SELECT 
	GameTitle,
	Genre,
    Global_sale
FROM 
	video_game_sales
ORDER BY 
	3 DESC
LIMIT 
	5
;


# QUE : Top 10 publishers in north america by sales 
SELECT 
	Publisher,
    CONCAT(ROUND(SUM(NorthAmerica),3)," M") AS Total_NorthAmerica_Sales
FROM
	video_game_sales
GROUP BY 
	1
ORDER BY 
	2 DESC
LIMIT 
	10
;


# Top 10 games by ranking 
SELECT 
	GameTitle,
    Ranks
FROM 
	video_game_sales
ORDER BY 
	2 DESC
LIMIT
	10
;


# QUE : Genres Wise Avg_Reviews and Total_Sales:
SELECT 
	Genre,
    ROUND(AVG(Review),2) AS Avg_Review,
    ROUND(SUM(Global_sale),2) AS Total_Sales
FROM 
	video_game_sales
GROUP BY 1
ORDER BY 2 DESC
;


# QUE: Which Publisher Launched Maximum Number of Games?
SELECT 
	DISTINCT Publisher,
    COUNT(id) AS Total_games_launched
FROM 
	video_game_sales
GROUP BY 
	1
ORDER BY 
	2 DESC
LIMIT 
	1
;
# 'Electronic Arts' = 341 


# QUE : Genre-wise Total games, Total_Sales, Avg_Reviews 
SELECT
	DISTINCT Genre,
    COUNT(id) AS Total_Games,
    ROUND(SUM(NorthAmerica),2) AS NorthAmerica_Total_Sales,
    ROUND(SUM(Europe),2) AS Europe_Total_Sales,
    ROUND(SUM(Japan),2) AS Japan_Total_Sales,
    ROUND(SUM(Rest_of_World),2) AS Rest_of_World_Total_Sales,
    ROUND(SUM(Global_sale),2) AS Total_Global_sales,
    ROUND(AVG(Review),2) AS Avg_Reviews 
FROM
	video_game_sales
GROUP BY 
	1
ORDER BY 
	2 DESC
;

# QUE: Max Global Sales of a each platform
SELECT 
	Platform,
    MAX(Global_sale) AS Maximum_Sales
FROM 
	video_game_sales
GROUP BY 
	1
ORDER BY 
	2 DESC
;


# QUE : Which Game have maximum Global Sale 
SELECT
    id,
    GameTitle,
    Publisher,
    Years,
    Global_sale
FROM
	video_game_sales
WHERE 
	Global_sale = (SELECT MAX(Global_sale) FROM video_game_sales)
;


# QUE : Popular games having ratings more than average rating 
SELECT 
	id,
    GameTitle,
    Publisher,
    Review
FROM 
	video_game_sales
WHERE 
	Review >= (SELECT AVG(Review) FROM video_game_sales)
ORDER BY 4 DESC
;


# Find the top 3 genres by average global sales, 
# but only consider games with average review scores above 75.
SELECT 
	Genre,
    ROUND(AVG(Global_sale),2) AS Avg_Sales,
    ROUND(AVG(Review),2)
FROM 
	video_game_sales
GROUP BY 
	1
HAVING 
	AVG(Review) > 75
ORDER BY 
	2 DESC
LIMIT 
	3
;


# Fetching each Game Info by id : 
DELIMITER //
CREATE PROCEDURE GameInfo(IN insert_id INT)
BEGIN
	SELECT 
		*
	FROM 
		video_game_sales
	WHERE 
		id = insert_id;
END //

CALL GameInfo(1300);
CALL GameInfo(1760);


# Fetch the Data of games with their names(partial match)
DELIMITER //
CREATE PROCEDURE GameName(IN Input_Name VARCHAR(200))
BEGIN
	SELECT
		* 
	FROM 
		video_game_sales
	WHERE 
		GameTitle LIKE CONCAT('%',Input_Name'%');
END //

CALL GameName('Call of Duty');
CALL GameName('mario');
CALL GameName('evil');


# Creating View for YOY % Growth of Publishers 
CREATE VIEW publisher_yoy_sales AS
	SELECT 
		Publisher,
        Years,
		CONCAT(
			ROUND(
					(
						(SUM(Global_sale)-
							LAG(SUM(Global_sale),1) 
							OVER(PARTITION BY Publisher ORDER BY Years))/
						LAG(SUM(Global_sale),1)
						OVER(PARTITION BY Publisher ORDER BY Years)
					)*100
				,2)
            ,"%")
		AS YOY_Growth
    FROM 
		video_game_sales
	GROUP BY 
		1,2
	ORDER BY 
		1,2
;
SELECT * FROM publisher_yoy_sales
;


# Calculate the percentage of total sales that each region 
# (North America, Europe, Japan, Rest of World) contributes 
# for each publisher.
WITH CTE AS
(
	SELECT 
		Publisher,
		SUM(NorthAmerica) AS NA_Sales,
		SUM(Europe) AS Europe_Sales,
		SUM(Japan) AS Japan_Sales,
		SUM(Rest_of_World) AS Rest_Sales,
		SUM(Global_sale) AS Global_Sales
	FROM
		video_game_sales
	GROUP BY 
		1
)
SELECT 
	Publisher,
	CONCAT(ROUND((NA_Sales / Global_Sales)* 100,2),'%') AS '%NA_Sales',
    CONCAT(ROUND((Europe_Sales / Global_Sales)*100,2),'%') AS '%Europe_Sales',
    CONCAT(ROUND((Japan_Sales / Global_Sales)* 100,2),'%') AS '%Japan_Sales',
    CONCAT(ROUND((Rest_Sales / Global_Sales)* 100,2),'%') AS '%Rest_Sales'
FROM 
	CTE
;


# Find games that have sold more in Europe than in North America, 
# and rank them by the difference.
SELECT 
	id,
    GameTitle,
    Publisher,
    NorthAmerica,
    Europe,
    ROUND(Europe - NorthAmerica,4) AS Sales_Diff
FROM
	video_game_sales
WHERE 
	Europe > NorthAmerica
ORDER BY 
	6 DESC
;


# Identify publishers who have released games in all genres.
SELECT 
	DISTINCT Publisher,
    COUNT(DISTINCT Genre) AS Total_Genre
FROM 
	video_game_sales
GROUP BY 
	1
HAVING 
	Total_Genre = (SELECT COUNT(DISTINCT Genre) FROM video_game_sales)
;


# For each year, find the game that had the highest ratio of North America 
# sales to Global sales.

WITH CTE AS
(
	SELECT
		Years,
        GameTitle,
		ROUND(NorthAmerica/Global_Sale,2) AS Sales_ratio,
        DENSE_RANK() OVER(PARTITION BY Years 
			ORDER BY NorthAmerica/Global_Sale DESC) AS Ranks
	FROM 
		video_game_sales
	WHERE Years IS NOT NULL
	ORDER BY 
		1
)
SELECT
	Years,
    GameTitle,
    Sales_ratio
FROM
	CTE
WHERE 
	Ranks = 1
;


# Create a ranking of platforms based on their total global sales, 
# but only for games released in the last 5 years of your dataset.

SELECT 
    Years,
    Platform,
    ROUND(SUM(Global_Sale), 2) AS Total_Sales,
    DENSE_RANK() OVER(ORDER BY SUM(Global_Sale) DESC) AS Ranks
FROM
    video_game_sales
WHERE 
    Years >= (SELECT DISTINCT Years
                FROM video_game_sales
                ORDER BY Years DESC
                LIMIT 1 OFFSET 4) 
GROUP BY
    Years, Platform
ORDER BY 
    4;


# Find the genre that has the most consistent sales across all regions 
# (i.e., the smallest variance in percentage of sales across regions).

# Solution 1 :

WITH cte AS
(
	SELECT 
		Genre,
		(SUM(NorthAmerica) / SUM(Global_sale))* 100
		AS NA_Sales,
		(SUM(Europe) / SUM(Global_sale))* 100
		AS Europe_Sales,
		(SUM(Japan) / SUM(Global_sale))* 100
		AS Japan_Sales,
		(SUM(Rest_of_World) / SUM(Global_sale))* 100
		AS Rest_Sales
	FROM 
		video_game_sales
	GROUP BY 
		1
),
cte_1 AS 
(
	SELECT 
	Genre,
		(GREATEST(NA_Sales,Europe_Sales,Japan_Sales,Rest_Sales) -
		LEAST(NA_Sales,Europe_Sales,Japan_Sales,Rest_Sales)) 
        AS Diff_MaxMin_Sales
	FROM 
		cte
)
SELECT 
	Genre,
    Diff_MaxMin_Sales
FROM
	cte_1
ORDER BY 
	2
LIMIT
	1
; # 'Role-Playing'


# Solution 2 :
WITH cte AS
(
    SELECT 
        Genre,
        (SUM(NorthAmerica) / SUM(Global_sale)) * 100 AS NA_Sales,
        (SUM(Europe) / SUM(Global_sale)) * 100 AS Europe_Sales,
        (SUM(Japan) / SUM(Global_sale)) * 100 AS Japan_Sales,
        (SUM(Rest_of_World) / SUM(Global_sale)) * 100 AS Rest_Sales
    FROM 
        video_game_sales
    GROUP BY 
        Genre
),
mean_cte AS
(
    SELECT 
        Genre,
        (NA_Sales + Europe_Sales + Japan_Sales + Rest_Sales) / 4 AS 
        Mean_Sales
    FROM 
        cte
),
variance_cte AS
(
    SELECT 
        cte.Genre,
        (POWER((NA_Sales - Mean_Sales), 2) +
         POWER((Europe_Sales - Mean_Sales), 2) +
		 POWER((Japan_Sales - Mean_Sales), 2) +
         POWER((Rest_Sales - Mean_Sales), 2) ) / 4 
        AS Variance_Sales
    FROM 
        cte
    JOIN 
        mean_cte ON cte.Genre = mean_cte.Genre
),
stddev_cte AS
(
    SELECT 
        Genre,
        SQRT(Variance_Sales) AS StdDev_Sales
    FROM 
        variance_cte
)
SELECT 
    Genre,
    StdDev_Sales
FROM
    stddev_cte
ORDER BY 
    StdDev_Sales
LIMIT 
	1;
# 'Role-Playing'


# For each publisher, find the genre in which they have the highest 
# average review score.

WITH cte AS 
(
    SELECT 
		Publisher,
		Genre,
		Avg(Review) AS Avg_Review
	FROM 
		video_game_sales
	GROUP BY 
		1,2
)

SELECT 
	Publisher,
	Genre
FROM
	(SELECT 
		*,
		DENSE_RANK() OVER(PARTITION BY Publisher ORDER BY Avg_Review DESC)
		AS Ranks
	FROM 
		cte) 
        AS temp_table 
WHERE 
	Ranks = 1
;


# Identify games that have significantly outperformed (more than 2 standard 
# deviations above) the average sales for their genre.



 
