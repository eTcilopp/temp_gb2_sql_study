-- Создаем таблицу для статусов блокирования

create table blocking_status(
	id INT not null AUTO_INCREMENT,
	status VARCHAR(50),
	primary key (id)
);


-- Создаем запись для таблицы
insert into blocking_status (status)
values 
	('blocked');


-- Создаем таблицу "черный список"
CREATE TABLE user_blacklist (
    blocking_user_id BIGINT UNSIGNED NOT NULL,
    blocked_user_id BIGINT unsigned NOT NULL,
    status INT,
    requested_at DATETIME,
    updated_at DATETIME,
    PRIMARY KEY (blocking_user_id, blocked_user_id),
    FOREIGN KEY (blocking_user_id) REFERENCES users(id),
    FOREIGN KEY (blocked_user_id) REFERENCES users(id),
    FOREIGN KEY (status) references blocking_status(id)
);


Создаем таблицу "предупреждения от администраторов"

CREATE TABLE admin_warnings (
    id INT NOT null AUTO_INCREMENT,
    media_id BIGINT UNSIGNED,
    admin_id BIGINT UNSIGNED,
    created_at DATETIME,
    updated_at DATETIME,
    warning_message TEXT,
    PRIMARY key (id),
    FOREIGN KEY (media_id) REFERENCES media(id),
    FOREIGN KEY (admin_id) REFERENCES users(id)
);

-- Заполняем таблицу "Пользователи" данными

INSERT INTO users 
	(firstname, lastname, email, password_hash, phone)
VALUES
    ('John', 'Doe', 'john.doe@example.com', 'hashed_password_1', 1234567890),
    ('Jane', 'Smith', 'jane.smith@example.com', 'hashed_password_2', 9876543210),
    ('Alex', 'Johnson', 'alex.johnson@example.com', 'hashed_password_3', 5551234567),
    ('Emily', 'Brown', 'emily.brown@example.com', 'hashed_password_4', 8887776666),
    ('Michael', 'Wilson', 'michael.wilson@example.com', 'hashed_password_5', 1112223333),
    ('Sarah', 'Lee', 'sarah.lee@example.com', 'hashed_password_6', 9998887777),
    ('David', 'Martinez', 'david.martinez@example.com', 'hashed_password_7', 4445556666),
    ('Linda', 'Garcia', 'linda.garcia@example.com', 'hashed_password_8', 7773331111),
    ('Chris', 'Jackson', 'chris.jackson@example.com', 'hashed_password_9', 2221114444),
    ('Amanda', 'Harris', 'amanda.harris@example.com', 'hashed_password_10', 6669993333);
   


-- Заполняем таблицу "черный список" данными
INSERT INTO user_blacklist (blocking_user_id, blocked_user_id, status, requested_at, updated_at)
VALUES
    (11, 12, 1, '2023-09-10 08:00:00', '2023-09-10 08:30:00'),
    (12, 13, 1, '2023-09-09 14:30:00', '2023-09-09 15:00:00'),
    (13, 14, 1, '2023-09-08 11:15:00', '2023-09-08 11:45:00'),
    (14, 15, 1, '2023-09-07 16:45:00', '2023-09-07 17:15:00'),
    (15, 16, 1, '2023-09-06 09:30:00', '2023-09-06 10:00:00'),
    (16, 17, 1, '2023-09-05 13:20:00', '2023-09-05 13:50:00'),
    (17, 18, 1, '2023-09-04 18:10:00', '2023-09-04 18:40:00'),
    (18, 19, 1, '2023-09-03 10:45:00', '2023-09-03 11:15:00'),
    (19, 20, 1, '2023-09-02 21:55:00', '2023-09-02 22:25:00'),
    (20, 11, 1, '2023-09-01 12:30:00', '2023-09-01 13:00:00');

