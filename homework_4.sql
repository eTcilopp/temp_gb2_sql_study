-- -- Подсчитать количество групп (сообществ), в которые вступил каждый пользователь.
SELECT
    us.id,
    us.firstname,
    us.lastname,
    count(community_id) as 'Количество групп'
FROM 
    users_communities as ucom
    JOIN users as us on us.id = ucom.user_id
GROUP BY us.id

-- Подсчитать количество пользователей в каждом сообществе.

SELECT
    com.id,
    com.name,
    count(ucom.user_id)
FROM
    users_communities as ucom
    JOIN communities com on com.id=ucom.community_id 
GROUP BY ucom.community_id

/* Пусть задан некоторый пользователь. Из всех пользователей соц. сети 
найдите человека, который больше всех общался с выбранным пользователем 
(написал ему сообщений). */

-- Ищем для пользователя с id=1

SELECT
    msg.from_user_id,
    us.email as from_email,
    count(msg.from_user_id) as msg_count
FROM
    messages as msg
    JOIN users as us on us.id = msg.from_user_id
WHERE
    msg.to_user_id = 1
GROUP BY
    msg.from_user_id
ORDER BY
    msg_count DESC
LIMIT 1

-- * Подсчитать общее количество лайков, которые получили пользователи младше 18 лет..

SELECT 
    COUNT(*) as number_of_likes_for_minors
FROM
    likes
    join profiles on profiles.user_id = likes.user_id
WHERE
    profiles.birthday > DATE_ADD(curdate(), INTERVAL -18 YEAR) 

--* Определить кто больше поставил лайков (всего): мужчины или женщины.

SELECT
    profiles.gender,
    count(likes.id) as likes_count
FROM 
    likes
    join profiles on profiles.user_id = likes.user_id 
GROUP BY profiles.gender
ORDER BY
    likes_count DESC
LIMIT 1
