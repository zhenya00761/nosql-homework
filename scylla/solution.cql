-- TODO: Implementation
create keyspace homework
    with replication = {'class': 'SimpleStrategy', 'replication_factor': 1};

use homework;

--Задание 1

create table posts_by_user_id(
    post_id int,
    user_id int,
    username varchar,
    content text,
    created_at timestamp,
    PRIMARY KEY (user_id, created_at, post_id)
)with clustering order by (created_at DESC, post_id ASC);


insert into posts_by_user_id (post_id, user_id, content, created_at, username)
    VALUES (1, 1, '1', '2023-01-01 10:30:00', '1');
insert into posts_with_username_for_last_post (post_id, user_id, content, created_at, username)
    VALUES (2, 1,  '2', '2023-01-02 09:00:00', '1');
insert into posts_with_username_for_last_post (post_id, user_id, content, created_at, username)
    VALUES (3, 1,  '3', '2023-01-03 09:30:00', '1');

insert into posts_by_user_id (post_id, user_id, content, created_at, username)
    VALUES (4, 2,  '4', '2023-01-01 16:00:00', '2');
insert into posts_by_user_id (post_id, user_id, content, created_at, username)
    VALUES (5, 2,  '5', '2023-01-02 10:50:00', '2');
insert into posts_by_user_id (post_id, user_id, content, created_at, username)
    VALUES (6, 2,  '6', '2023-01-03 13:20:00', '2');

insert into posts_by_user_id (post_id, user_id, content, created_at, username)
    VALUES (7, 3,  '7', '2023-01-01 15:30:00', '3');
insert into posts_by_user_id (post_id, user_id, content, created_at, username)
    VALUES (8, 3,  '8', '2023-01-02 15:00:00', '3');
insert into posts_by_user_id (post_id, user_id, content, created_at, username)
    VALUES (9, 3,  '9', '2023-01-03 18:00:00', '3');


select
    post_id,
    content,
    toDate(created_at) as post_date
from posts_by_user_id
where user_id = 2;

--Задание 2


select
    post_id,
    content,
    toDate(created_at) as post_date,
    username
from posts_by_user_id
where user_id = 3
limit 1;

--Задание 3

select
    post_id,
    content,
    toDate(created_at) as post_date
from posts_by_user_id
where user_id = 1 and created_at > '2023-01-01 08:00:00';

--Задание 4

create table posts_by_topic(
    post_id int,
    user_id int,
    username varchar,
    topic_id int,
    content text,
    post_date date,
    post_time time,
    PRIMARY KEY ((post_date, topic_id), post_time, post_id)
) with clustering order by (post_time ASC, post_id ASC);


insert into posts_by_topic
(post_id, user_id, username, topic_id, content, post_date, post_time)
VALUES (1, 1, 'username1', 1, '1', '2023-01-01', '10:30:00');
insert into posts_by_topic
(post_id, user_id, username, topic_id, content, post_date, post_time)
VALUES (2, 1, 'username1', 2, '2', '2023-01-02', '09:00:00');
insert into posts_by_topic
(post_id, user_id, username, topic_id, content, post_date, post_time)
VALUES (3, 1, 'username1', 1, '3', '2023-01-03', '09:30:00');
insert into posts_by_topic
(post_id, user_id, username, topic_id, content, post_date, post_time)
VALUES (4, 2, 'username2', 2, '4', '2023-01-01', '16:00:00');
insert into posts_by_topic
(post_id, user_id, username, topic_id, content, post_date, post_time)
VALUES (5, 2, 'username2', 3, '5', '2023-01-02', '10:50:00');
insert into posts_by_topic
(post_id, user_id, username, topic_id, content, post_date, post_time)
VALUES (6, 2, 'username2', 2, '6', '2023-01-03', '13:20:00');
insert into posts_by_topic
(post_id, user_id, username, topic_id, content, post_date, post_time)
VALUES (7, 3, 'username3', 3, '7', '2023-01-01', '15:30:00');
insert into posts_by_topic
(post_id, user_id, username, topic_id, content, post_date, post_time)
VALUES (8, 3, 'username3', 1, '8', '2023-01-02', '15:00:00');
insert into posts_by_topic
(post_id, user_id, username, topic_id, content, post_date, post_time)
VALUES (9, 3, 'username3', 3, '9', '2023-01-03', '18:00:00');

select
    user_id,
    username,
    post_id,
    post_time
from posts_by_topic
where post_date = '2023-01-01' and topic_id = 1
