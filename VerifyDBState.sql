-- BriTay2664 02/01/2026 VerfiyDBState

--Check Which Users have access by displaying USER Name

SELECT
    user_id,
    username,
    created,
    password_change_date
FROM
    user_users;


-- Check What tables are present in the database by displaying everything in USER_TABLE

SELECT
    *
FROM
    user_tables;

--Describe ORDERS table

SELECT
    column_name,
    data_type,
    nullable
FROM
    user_tab_columns
WHERE
    table_name = 'ORDERS'
ORDER BY
    column_id;

--Describe PRODUCTLIST table
SELECT
    column_name,
    data_type,
    nullable
FROM
    user_tab_columns
WHERE
    table_name = 'PRODUCTLIST'
ORDER BY
    column_id;

--Describe REVIEWS table
SELECT
    column_name,
    data_type,
    nullable
FROM
    user_tab_columns
WHERE

    table_name = 'REVIEWS'
ORDER BY
    column_id;

--Describe STOREFRONT table

SELECT
    column_name,
    data_type,
    nullable
FROM
    user_tab_columns
WHERE

    table_name = 'STOREFRONT'
ORDER BY
    column_id;

--Describe USERBASE table

SELECT
    column_name,
    data_type,
    nullable
FROM
    user_tab_columns
WHERE

    table_name = 'USERBASE'
ORDER BY
    column_id;

--Describe USERLIBRARY table

SELECT
    column_name,
    data_type,
    nullable
FROM
    user_tab_columns
WHERE

    table_name = 'USERLIBRARY'
ORDER BY
    column_id;

-- Display all datat

SELECT *
FROM orders;

SELECT *
FROM productlist;

SELECT *
FROM reviews;

SELECT *
FROM storefront;

SELECT *
FROM userbase;

SELECT *
FROM userlibrary;

-- Check What constraints are present in the data by displaying name

SELECT
    table_name,
    constraint_name,
    constraint_type,
    status
FROM
    user_constraints;

-- Check what views are present in the database

SELECT
    view_name,
    text
FROM
    user_views;

-- Display every usernaem in order by alphabet 

SELECT
    username
FROM
    user_users
ORDER BY
    username;

-- Display the firstname, lastname, username, of any user with yahoo email address

SELECT
    firstname,
    lastname,
    username,
    password,
    email
FROM
    userbase
WHERE
    UPPER(email) LIKE '%@YAHOO%';

-- Display the USERNAME, BIRTHDAY, and WALLETFUNDS of any user who has less than $25 in funds.

SELECT
    username,
    birthday,
    walletfunds
FROM
    userbase
WHERE
    walletfunds < 25;

-- Display the USERID and PRODUCTCODE of any user who has more than 100 HOURSPLAYED.

SELECT
    userid,
    productcode
FROM
    userlibrary
WHERE
    hoursplayed > 100;

-- Display the PRODUCTCODE of any game that has less than 10 HOURSPLAYED.

SELECT
    productcode
FROM
    userlibrary
WHERE
    hoursplayed < 10;

-- Display every unique PUBLISHER.

SELECT DISTINCT
    publisher
FROM
    productlist;

--Display the PRODUCTNAME, RELEASEDATE, PUBLISHER, and GENRE of all products, sorted by GENRE. 

SELECT
    productname,
    releasedate,
    publisher,
    genre
FROM
    productlist
ORDER BY
    genre;

--Display the PRODUCTCODE and PUBLISHER of any product in the ‘Strategy’ GENRE.

SELECT
    productcode,
    publisher
FROM
    productlist
WHERE
    genre = 'Strategy';

--Display the PRODUCTCODE and REVIEW of any product with a RATING of 1.

SELECT
    productcode,
    review
FROM
    reviews
WHERE
    rating = 1;

--Display the PRODUCTCODE and REVIEW of any product with a RATING of 4 or higher.
SELECT
    productcode,
    review
FROM
    reviews
WHERE
    rating >= 4;
--Display every unique USERID from users who have placed an order.

SELECT DISTINCT
    userid
FROM
    orders;

--Display all order data, sorted by the earliest PURCHASEDATE.
SELECT
    *
FROM
    orders
ORDER BY
    purchasedate;








