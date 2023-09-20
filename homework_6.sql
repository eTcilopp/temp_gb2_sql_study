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
	-- Удаляем лайки, которые поставили пользователю другие
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

	-- Заменяем фото аватаров, сделанные удаляемым пользователем и использованные другими пользователями на Null

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
	delete from media  where user_id=deleted_user_id;

	return deleted_user_id;
end

-- Вызов функции
select remove_user_data(4);
