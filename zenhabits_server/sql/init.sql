CREATE TABLE IF NOT EXISTS Users (
    user_id INT UNIQUE NOT NULL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS Habits (
    habit_id INT UNIQUE NOT NULL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    frequency VARCHAR(50),
    completed BOOLEAN NOT NULL,
    start_date BIGINT NOT NULL,
    end_date BIGINT NOT NULL,
    user_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);