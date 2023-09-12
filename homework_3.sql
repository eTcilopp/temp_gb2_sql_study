-- Написать скрипт, возвращающий список имен (только firstname) пользователей без повторений в алфавитном порядке. [ORDER BY]

select distinct 
	us.firstname 
from 
	users us
order by
	us.firstname

-- Выведите количество мужчин старше 35 лет [COUNT].

select 
	count(*)
from 
	profiles pr
where 
	pr.gender = 'm'
	and timestampdiff(year, pr.birthday, curdate()) > 35

-- Сколько заявок в друзья в каждом статусе? (таблица friend_requests) [GROUP BY]

select
	fr.status,
	count(fr.status )
from 
	friend_requests fr 
group by
	fr.status 

-- * Выведите номер пользователя, который отправил больше всех заявок в друзья (таблица friend_requests) [LIMIT].
select 
	fr.initiator_user_id as user_issued_max_friend_requests
from 
	friend_requests fr 
group by
	fr.initiator_user_id
order by 
	count(fr.initiator_user_id) desc
limit 1

--* Выведите названия и номера групп, имена которых состоят из 5 символов [LIKE].


select
com.id,	
com.name
from 
	communities com
where 
	com.name like '_____'

