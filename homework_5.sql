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
	GROUP BY likes.user_id

SELECT *
FROM 
	adult_users_with_likes

