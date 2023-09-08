CREATE TABLE user_blacklist (
    blocking_user_id BIGINT UNSIGNED NOT NULL,
    blocked_user_id BIGINT unsigned NOT NULL,
    status VARCHAR(15),
    manufacturer TEXT,
    requested_at DATETIME,
    updated_at DATETIME,
    PRIMARY KEY (blocking_user_id, blocked_user_id),
    FOREIGN KEY (blocking_user_id) REFERENCES users(id),
    FOREIGN KEY (blocked_user_id) REFERENCES users(id)
);

