--Создайте представление с произвольным SELECT-запросом из прошлых уроков [CREATE VIEW]

CREATE OR REPLACE VIEW  adult_users_with_likes AS
	SELECT 
	    likes.user_id
	    , concat(users.firstname, ' ', users.lastname)
	    , count(likes.id)
	FROM
	    likes
	    JOIN profiles ON profiles.user_id = likes.user_id
	    JOIN users ON users.id=profiles.user_id 
	WHERE
	    profiles.birthday < DATE_ADD(curdate(), INTERVAL -18 YEAR) 
	GROUP BY likes.user_id;

-- Выведите данные, используя написанное представление [SELECT]

SELECT *
FROM 
	adult_users_with_likes;


-- Удалите представление [DROP VIEW]

DROP VIEW adult_users_with_likes;

/* 
Сколько новостей (записей в таблице media) у каждого пользователя? 
Вывести поля: news_count (количество новостей), user_id (номер пользователя), 
user_email (email пользователя). Попробовать решить с помощью CTE или с помощью 
обычного JOIN.
*/

create or replace view user_news_count as
select
	m.user_id as user_id
	, count(*) as news_count
from media m
group by m.user_id


select
	unc.news_count
	, u.id as user_id
	, u.email as user_email
from 
	user_news_count unc
	join users u on u.id = unc.user_id

