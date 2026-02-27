--BriTay2664 Project Week 5: Displaying Assorted Data 02/26/2026

--Display the USERID of any users who have not made an order.

SELECT u.USERID
FROM USERBASE u
LEFT JOIN ORDERS o
  ON u.USERID = o.USERID
WHERE o.USERID IS NULL
ORDER BY u.USERID;

--Display the PRODUCTCODE of any products that have no reviews. 

SELECT p.PRODUCTCODE
FROM PRODUCTLIST p
LEFT JOIN REVIEWS r
  ON p.PRODUCTCODE = r.PRODUCTCODE
WHERE r.PRODUCTCODE IS NULL
ORDER BY p.PRODUCTCODE;

--Display all data in the USERBASE table. Show another column that states “Adult” for any user that is at least 18 years old, and “Minor'' for all other users.

SELECT u.*,
       CASE
           WHEN FLOOR(MONTHS_BETWEEN(SYSDATE, BIRTHDAY)/12) >= 18
                THEN 'Adult'
           ELSE 'Minor'
       END AS AGE_GROUP
FROM USERBASE u
ORDER BY USERID;

--Display all data in the PRODUCTLIST table. Show another column that states “On Sale” for any product that is priced at $20 or less, and “Base Price” for all other products. 

SELECT 
    p.*,
    CASE 
        WHEN p.price <= 20 THEN 'On Sale'
        ELSE 'Base Price'
    END AS sale_status
FROM productlist p;

--Display the USERID of any user who has played the product with a PRODUCTCODE of GAME6 and has a user profile image.

SELECT DISTINCT ul.userid
FROM userlibrary ul
JOIN userprofile up
  ON up.userid = ul.userid
WHERE ul.productcode = 'GAME6'
  AND up.imagefile IS NOT NULL;

--Display any PRODUCTCODE from the intersect of the WISHLIST and REVIEWS table, where the product is in POSITION 1 or 2, and has a review RATING of 3 or higher.

SELECT productcode
FROM wishlist
WHERE position IN (1, 2)

INTERSECT

SELECT productcode
FROM reviews
WHERE rating >= 3;

--Display both user’s USERNAME and BIRTHDAY for any users who share the same BIRTHDAY. 

SELECT username, birthday
FROM (
    SELECT ub.username,
           ub.birthday,
           COUNT(*) OVER (PARTITION BY ub.birthday) AS bday_count
    FROM userbase ub
)
WHERE bday_count > 1
ORDER BY birthday, username;

--Display the Cartesian Product of the USERLIBRARY table cross joined with the WISHLIST table.

SELECT *
FROM userlibrary
CROSS JOIN wishlist;

--Perform a union all on the USERBASE and PRODUCTLIST tables to generate data on all users and products. 

SELECT 
    'USER' AS record_type,
    TO_CHAR(userid) AS id,
    username AS name
FROM userbase

UNION ALL

SELECT
    'PRODUCT' AS record_type,
    productcode AS id,
    productname AS name
FROM productlist;

--Perform a union all on the CHATLOG and USERPROFILE tables to generate data on user activity

SELECT
    'PROFILE' AS activity_type,
    up.userid,
    up.imagefile AS info
FROM userprofile up

UNION ALL

SELECT
    'CHAT-SENT' AS activity_type,
    cl.senderid AS userid,
    cl.content AS info
FROM chatlog cl

UNION ALL

SELECT
    'CHAT-RECEIVED' AS activity_type,
    cl.receiverid AS userid,
    cl.content AS info
FROM chatlog cl;

--Display the USERNAME of all users who have not received an INFRACTION. 

SELECT ub.username
FROM userbase ub
WHERE NOT EXISTS (
    SELECT 1
    FROM infractions i
    WHERE i.userid = ub.userid
);

--Display the TITLE and DESCRIPTION of any COMMUNITYRULES that have not been broken.

-- Brian
SELECT cr.title, cr.description
FROM communityrules cr
WHERE NOT EXISTS (
    SELECT 1
    FROM infractions i
    WHERE i.rulenum = cr.rulenum
);

--Display the USERNAME and EMAIL of all users who have received a penalty for their INFRACTION.

SELECT DISTINCT ub.username, ub.email
FROM userbase ub
JOIN infractions i
  ON ub.userid = i.userid
WHERE i.penalty IS NOT NULL;

--Display the dates where an INFRACTION was assigned and a USERSUPPORT ticket was submitted on the same day.

SELECT DISTINCT TRUNC(i.dateassigned) AS activity_date
FROM infractions i
JOIN usersupport us
  ON TRUNC(us.datesubmitted) = TRUNC(i.dateassigned)
ORDER BY activity_date;

--Display every COMMUNITYRULES TITLE and PENALTY.

SELECT cr.title, i.penalty
FROM communityrules cr
JOIN infractions i
  ON cr.rulenum = i.rulenum
ORDER BY cr.title;

--Display all data in the COMMUNITYRULES table. Show another column that states “Bannable'' for any rule with a 10 or higher SEVERITYPOINT, and “Appealable” for all other rules.

SELECT
    cr.*,
    CASE
        WHEN cr.severitypoint >= 10 THEN 'Bannable'
        ELSE 'Appealable'
    END AS rule_status
FROM communityrules cr
ORDER BY cr.rulenum;

--Display all data in the USERSUPPORT table. Show another column that states “High Priority” for any ticket that is not closed and has not been updated in the past week.

SELECT
    us.*,
    CASE
        WHEN UPPER(us.status) <> 'CLOSED'
             AND TRUNC(SYSDATE) - TRUNC(us.dateupdated) > 7
        THEN 'High Priority'
        ELSE 'Normal'
    END AS priority_flag
FROM usersupport us;

--Display the Cartesian Product of the USERSUPPORT table cross joined with the INFRACTIONS table.

SELECT *
FROM usersupport
CROSS JOIN infractions;

--Display both TICKETIDs and DATEUPDATED for any support tickets that are ‘CLOSED’ and the last DATEUPDATED was on the same day.

SELECT DISTINCT
       u1.ticketid,
       u2.ticketid,
       TRUNC(u1.dateupdated) AS dateupdated
FROM usersupport u1
JOIN usersupport u2
     ON TRUNC(u1.dateupdated) = TRUNC(u2.dateupdated)
WHERE u1.status = 'CLOSED'
  AND u2.status = 'CLOSED'
  AND u1.ticketid < u2.ticketid
ORDER BY dateupdated;

--Perform a union all on the USERBASE and INFRACTIONS tables to generate data on user activity. 

SELECT
    'USER' AS activity_type,
    ub.userid,
    ub.username AS details
FROM userbase ub

UNION ALL

SELECT
    'INFRACTION' AS activity_type,
    i.userid,
    i.penalty AS details
FROM infractions i;
