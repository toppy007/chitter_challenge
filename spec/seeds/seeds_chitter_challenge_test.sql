--# table names: 'users'
TRUNCATE TABLE users RESTART IDENTITY CASCADE; 

--cannot truncate a table referenced in a foreign key constraint-- Solution is to as (CASCADE)

INSERT INTO users (email, password, username) VALUES ('chris_@hotmail.com', '1234567890abc', 'toppy');
INSERT INTO users (email, password, username) VALUES ('sunny_@gmail.com', '0987654321abc', 'sunny');
INSERT INTO users (email, password, username) VALUES ('rich_@gmail.com', '22222222abc', 'richy');

-- table names: 'messages'
TRUNCATE TABLE messages RESTART IDENTITY; 

INSERT INTO messages (
    title, 
    content, 
    tags, 
    user_id
    ) 
VALUES (
    'paired programming', 
    'learning to pair program',
    ARRAY [2, 3],
    1
    );

INSERT INTO messages (
    title, 
    content, 
    tags, 
    user_id
    ) 
VALUES (
    'TDD learning', 
    'methods to writing a program',
    ARRAY [1],
    2
    );

INSERT INTO messages (
    title, 
    content, 
    tags, 
    user_id
    ) 
VALUES (
    'OOP', 
    'learning object orintated programing',
    ARRAY [2, 3],
    1
    );