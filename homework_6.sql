/*

    Написать функцию, которая удаляет всю информацию об указанном пользователе из БД vk. Пользователь задается по id. Удалить нужно все сообщения, лайки, медиа записи, профиль и запись из таблицы users. Функция должна возвращать номер пользователя.
    Предыдущую задачу решить с помощью процедуры и обернуть используемые команды в транзакцию внутри процедуры.
    * Написать триггер, который проверяет новое появляющееся сообщество. Длина названия сообщества (поле name) должна быть не менее 5 символов. Если требование не выполнено, то выбрасывать исключение с пояснением.

*/

/*
Написать функцию, которая удаляет всю информацию об указанном пользователе из БД vk. 
Пользователь задается по id. Удалить нужно все сообщения, лайки, медиа записи, профиль
 и запись из таблицы users. 
Функция должна возвращать номер пользователя. 
*/

drop function if exists vk.remove_user_data;
create function vk.remove_user_data(deleted_user_id BIGINT UNSIGNED)
returns INT reads sql data
begin
	-- Удаляем сообщения, где удаляемый пользователь был отправителем или получателем
	delete from messages where from_user_id = deleted_user_id;
	delete from messages where to_user_id =deleted_user_id;

	-- Удаляем лайки, которые поставил удаляемый пользователь
	delete from likes where user_id=deleted_user_id;
	-- Удаляем лайки, которые поставиль пользователю другие
	delete
	from 
		likes l 
	where l.id in (select t1.id from 
		(
            select
                l.id
            from 
                likes l
                join media m on m.id = l.media_id and m.user_id = deleted_user_id
		) as t1
	);

	-- удаляем профиль пользователя
	delete from profiles where user_id=deleted_user_id;

	-- Заменяем фото аватары, сделанные удаляемым пользователем и использованные другими пользователями на Null

	update profiles p
	set p.photo_id=null
	where p.photo_id in (select t2.id from 
		(
            select m.id
            from media m 
            where 
                m.user_id = deleted_user_id
		)as t2);

	-- Удаляем медиа файлы пользователя
	delete from media where user_id=deleted_user_id;

	-- Удаляем отправленные или принятые запросы в друзья
	delete
	from 
		friend_requests
	where
		initiator_user_id = deleted_user_id or target_user_id = deleted_user_id;
	
	-- Удаляем сообщества, в которых состоял пользователь
	delete
	from users_communities
	where users_communities.user_id = deleted_user_id;

	-- Удаляем аккаунт пользователя
	delete from users where id=deleted_user_id;

	return deleted_user_id;
end


-- Вызов функции
select remove_user_data(4);


/*
Предыдущую задачу решить с помощью процедуры и обернуть используемые
команды в транзакцию внутри процедуры.
*/

drop procedure if exists `sp_remove_user`;
DELIMITER $$

create procedure `sp_remove_user`(deleted_user_id INT unsigned,
out tran_result varchar(200))

BEGIN
    DECLARE `_rollback` BOOL DEFAULT 0;
   	DECLARE code varchar(100);
   	DECLARE error_string varchar(100);

	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
	begin
    	SET `_rollback` = 1;
		GET stacked DIAGNOSTICS CONDITION 1
        code = RETURNED_SQLSTATE, error_string = MESSAGE_TEXT;
    	set tran_result := concat('Error occured. Code: ', code, '. Text: ', error_string);
	end;
		        
	START TRANSACTION;
	-- Удаляем сообщения, где удаляемый пользователь был отправителем или получателем
	delete from messages where from_user_id = deleted_user_id;
	delete from messages where to_user_id =deleted_user_id;

	-- Удаляем лайки, которые поставил удаляемый пользователь
	delete from likes where user_id=deleted_user_id;
	-- Удаляем лайки, которые поставили пользователю другие
	delete
	from likes l
	where l.id in (select t1.id from 
		(
		select l.id
		from 
			likes l
			join media m on m.id = l.media_id and m.user_id = deleted_user_id
		) as t1
	);

	-- удаляем профиль пользователя
	delete from profiles where user_id=deleted_user_id;

	-- Заменяем фото аватары, сделанные удаляемым пользователем и использованные другими пользователями на Null

	update profiles p
	set p.photo_id=null
	where p.photo_id in (select t2.id from 
		(
		select m.id
		from media m 
		where 
			m.user_id = deleted_user_id
		)as t2);

	-- Удаляем медиа файлы пользователя
	delete from media where user_id=deleted_user_id;

	-- Удаляем отправленные или принятые запросы в друзья
	delete
	from 
		friend_requests
	where
		initiator_user_id = deleted_user_id or target_user_id = deleted_user_id;
	
	-- Удаляем сообщества, в которых состоял пользователь
	delete
	from users_communities
	where users_communities.user_id = deleted_user_id;

	-- Удаляем аккаунт пользователя
	delete from users where id=deleted_user_id;
	
    IF `_rollback` THEN
        ROLLBACK;
    ELSE
        set tran_result := concat('user_id ', deleted_user_id, ' deleted ok');
        COMMIT;
    END IF;
END$$
DELIMITER ;


-- Вызов процедуры

call sp_remove_user(19, @tran_result)
select @tran_result;


/*
* Написать триггер, который проверяет новое появляющееся сообщество. 
Длина названия сообщества (поле name) должна быть не менее 5 символов. 
Если требование не выполнено, то выбрасывать исключение с пояснением.
*/

CREATE TRIGGER `check_new_community_name_length` 
BEFORE INSERT ON `communities` 
FOR EACH ROW 
begin
    IF length(NEW.name) < 5 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Обновление отменено. Имя группы должно состоять минимум из 5 букв.';
    END IF;
end

-- Проверка
insert into communities 
values(100, 'test')

/* Результат

SQL Error [1644] [45000]: Обновление отменено. Имя группы должно состоять минимум из 5 букв.

*/