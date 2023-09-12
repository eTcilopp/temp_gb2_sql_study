-- Подсчитать количество групп (сообществ), в которые вступил каждый пользователь.
SELECT
    us.id,
    us.firstname,
    us.lastname,
    count(community_id) as 'Количество групп'
FROM 
    users_communities as ucom
    join users as us on us.id = ucom.user_id
GROUP BY us.id


