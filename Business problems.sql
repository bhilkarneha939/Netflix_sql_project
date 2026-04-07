Select * from netflix

1. Count the number of Movies vs TV Shows

Select 
	type,
	count(*) as total_content
from netflix
group by type

2. Find the most common rating for movies and TV shows
select 
type,
rating
from
(select 
 type,
 rating,
 count(*),
 RANK() Over(Partition by type order by count(*) desc) as ranking
from netflix
group by 1,2) as t1
where ranking=1


3. List all movies released in a specific year (e.g., 2020)

Select * from netflix
where 
	type='Movie' 
	and 
	release_year=2020;


4. Find the top 5 countries with the most content on Netflix

Select 
	unnest(string_to_array(country,',') )as new_country,
	count(show_id) as total_content
	
from netflix
group by 1
order by 2 desc
limit 5

5. Identify the longest movie

Select * from netflix
where 
	--type='movie'
	--and
	duration= (select max(duration) from netflix)




6. Find content added in the last 5 years

Select * 
from netflix
where
     to_date(date_added,'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 YEARS'

SELECT CURRENT_DATE - INTERVAL '5 YEARS'



7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

SELECT * 
FROM NETFLIX
WHERE DIRECTOR LIKE '%Rajiv Chilaka%'


8. List all TV shows with more than 5 seasons
SELECT * 
FROM NETFLIX
where
 	SPLIT_PART(duration,' ',1) ::numeric >5


9. Count the number of content items in each genre
SELECT 
	UNNEST(STRING_TO_ARRAY(LISTED_IN,',')) AS GENRE,
	COUNT(SHOW_ID) AS TOTAL_CONTENT
FROM NETFLIX
GROUP BY 1



10.Find each year and the average numbers of content release in India on netflix.  return top 5 year with highest avg content release!

SELECT 
	extract(year from to_date(date_added,'Month DD,YYYY')) As year,
	count(*) as yearly_content,
	round(
	count(*):: numeric/(select count(*) from netflix where country ='India'):: numeric *100,2) as avg_content_per_year
	
	
FROM NETFLIX
 where country ='India'
group by 1
limit 5




11. List all movies that are documentaries
SELECT * 
FROM NETFLIX
where listed_in ILIKe '%documentaries%'



12. Find all content without a director

SELECT * 
FROM NETFLIX 
where director isnull



13. Find how many movies actor 'Salman Khan' appeared in last 10 years!

SELECT * 
FROM NETFLIX
where casts ilike '%Salman khan%'
and
release_year > extract(year from current_date)-10


14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

SELECT 
Unnest(string_to_array(casts,',')) as actors,
count(*) as total_count
FROM NETFLIX
where country ilike '%India%'
group by 1
order by 2 desc
limit 10



15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.

with new_table
as
(select *,
case 
	when 
		description ILIKE '%kill%' or
		description ILIKE '%violence%' then 'bad_content'
	else 'good_content'
end category
from netflix
)
select 
	category,
	count(*) as total_content
from new_table
group by 1
		
		





