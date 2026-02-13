--BriTay2664 RI 02/12/2026 Project Week 3

--Enforce referential integrity by adding foreign key constraints to: ORDERS, REVIEWS, and USERLIBRARY.

ALTER TABLE ORDERS
ADD CONSTRAINT FK_ORDERS_USER
FOREIGN KEY (USERID)
REFERENCES USERBASE(USERID);


ALTER TABLE ORDERS
ADD CONSTRAINT FK_ORDERS_PRODUCT
FOREIGN KEY (PRODUCTCODE)
REFERENCES PRODUCTLIST(PRODUCTCODE);


--display the full name and USERNAME of every user who is at least 18 years old

SELECT FIRSTNAME || ' ' || LASTNAME AS FULLNAME,
       USERNAME
FROM USERBASE
WHERE FLOOR(MONTHS_BETWEEN(SYSDATE, BIRTHDAY)/12) >= 18;


--find the maximum length of a USERNAME and the average length of a USERNAME in the USERBASE table. 

SELECT MAX(LENGTH(USERNAME)) AS MAX_USERNAME_LENGTH,
       AVG(LENGTH(USERNAME)) AS AVG_USERNAME_LENGTH
FROM USERBASE;

--display every QUESTION that starts with ‘What is’ or ‘What was’ in the SECURITYQUESTION table.

SELECT QUESTION
FROM SECURITYQUESTION
WHERE QUESTION LIKE 'What is%'
   OR QUESTION LIKE 'What was%';


--display the PRODUCTCODE, lowest RATING, and number of reviews for each product in the REVIEWS table. Order the results in descending order of the REVIEW count.

SELECT PRODUCTCODE,
       MIN(RATING) AS LOWEST_RATING,
       COUNT(*) AS REVIEW_COUNT
FROM REVIEWS
GROUP BY PRODUCTCODE
ORDER BY REVIEW_COUNT DESC;

--display any PRODUCTCODE that is ranked at POSITION 1, as well as the number of users who have the product ranked at that position.

SELECT PRODUCTCODE,
       COUNT(*) AS USER_COUNT
FROM WISHLIST
WHERE POSITION = 1
GROUP BY PRODUCTCODE
ORDER BY USER_COUNT DESC;

--to display the USERID and the total amount each user has spent in ORDERS.

SELECT USERID,
       SUM(PRICE) AS TOTAL_SPENT
FROM ORDERS
GROUP BY USERID
ORDER BY TOTAL_SPENT DESC;

--most profitable days of the site by showing the gross profits of all orders categorized by their PURCHASEDATE, sorted in descending order of profit.
SELECT TRUNC(PURCHASEDATE) AS PURCHASE_DAY,
       SUM(PRICE) AS GROSS_PROFIT
FROM ORDERS
GROUP BY TRUNC(PURCHASEDATE)
ORDER BY GROSS_PROFIT DESC;

--to identify games with the most play time amongst the user base.
SELECT *
FROM
(
    SELECT PRODUCTCODE,
           SUM(HOURSPLAYED) AS TOTAL_HOURS
    FROM USERLIBRARY
    GROUP BY PRODUCTCODE
    ORDER BY TOTAL_HOURS DESC
)
WHERE ROWNUM <= 5;

--Create a view showing a list of each USERID and the count of infractions they have received, sorted with the highest infraction count first.

CREATE VIEW VW_USER_INFRACTION_COUNT AS
SELECT USERID,
       COUNT(*) AS INFRACTION_COUNT
FROM INFRACTIONS
GROUP BY USERID
ORDER BY INFRACTION_COUNT DESC;
--Use View

SELECT *
FROM VW_USER_INFRACTION_COUNT;

--Create a view showing a list of each USERID, RULENUM, and number of times the user broke that RULENUM, sorted by USERID.

CREATE VIEW VW_USER_RULE_VIOLATIONS AS
SELECT USERID,
       RULENUM,
       COUNT(*) AS VIOLATION_COUNT
FROM INFRACTIONS
GROUP BY USERID, RULENUM
ORDER BY USERID;

--Display View

SELECT *
FROM VW_USER_RULE_VIOLATIONS;

--display every RULENUM, PENALTY that has been assigned for breaking said rule, and the number of times that PENALTY has been assigned to that RULENUM.

SELECT RULENUM,
       PENALTY,
       COUNT(*) AS TIMES_ASSIGNED
FROM INFRACTIONS
GROUP BY RULENUM, PENALTY
ORDER BY RULENUM;

--display the average, maximum, and minimum time between the DATEUPDATED and DATESUBMITTED for all tickets with a STATUS of ‘CLOSED’.

SELECT ROUND(AVG(DATEUPDATED - DATESUBMITTED),2) AS AVG_RESOLUTION_DAYS,
       MAX(DATEUPDATED - DATESUBMITTED) AS MAX_RESOLUTION_DAYS,
       MIN(DATEUPDATED - DATESUBMITTED) AS MIN_RESOLUTION_DAYS
FROM USERSUPPORT
WHERE UPPER(STATUS) = 'CLOSED';

-- display the EMAIL, ISSUE, and the count of times that ISSUE has been submitted, for all tickets with a STATUS of ‘NEW’, grouped by the DATESUBMITTED and ordered by the count.

SELECT TRUNC(DATESUBMITTED) AS DATESUBMITTED,
       EMAIL,
       ISSUE,
       COUNT(*) AS ISSUE_COUNT
FROM USERSUPPORT
WHERE STATUS = 'Open'
GROUP BY TRUNC(DATESUBMITTED), EMAIL, ISSUE
ORDER BY ISSUE_COUNT DESC;

-- Verify if any current users do not comply with these protocols by displaying any user who has their FIRSTNAME or LASTNAME in their PASSWORD.

SELECT USERID,
       USERNAME,
       FIRSTNAME,
       LASTNAME,
       PASSWORD
FROM USERBASE
WHERE INSTR(UPPER(PASSWORD), UPPER(FIRSTNAME)) > 0
   OR INSTR(UPPER(PASSWORD), UPPER(LASTNAME)) > 0;


--Display every PUBLISHER and average PRICE of their products, sorted in alphabetical order of PUBLISHER.

SELECT PUBLISHER,
       AVG(PRICE) AS AVG_PRODUCT_PRICE
FROM PRODUCTLIST
GROUP BY PUBLISHER
ORDER BY PUBLISHER;

--Create a view that displays the PRODUCTNAME and PRICE for all products with a RELEASEDATE over 5 years ago. Apply a 25% discount to the PRICE.

CREATE VIEW VW_DISCOUNTED_OLD_GAMES AS
SELECT PRODUCTNAME,
       ROUND(PRICE * 0.75, 2) AS DISCOUNTED_PRICE
FROM PRODUCTLIST
WHERE RELEASEDATE < ADD_MONTHS(SYSDATE, -60);

--Test View

SELECT *
FROM VW_DISCOUNTED_OLD_GAMES;

--Calculate the maximum and minimum PRICE of all products based on GENRE.

SELECT GENRE,
       MAX(PRICE) AS MAX_PRICE,
       MIN(PRICE) AS MIN_PRICE
FROM PRODUCTLIST
GROUP BY GENRE
ORDER BY GENRE;

-- create a view that displays everything in the CHATLOG table from any messages with a DATESENT between now and the previous week.

CREATE VIEW VW_RECENT_CHATLOG AS
SELECT *
FROM CHATLOG
WHERE DATESENT BETWEEN SYSDATE - 7 AND SYSDATE;

--Test View

SELECT *
FROM VW_RECENT_CHATLOG;

-- Calculate the maximum and minimum PRICE of all products based on GENRE. 

SELECT GENRE,
       MAX(PRICE) AS MAX_PRICE,
       MIN(PRICE) AS MIN_PRICE
FROM PRODUCTLIST
GROUP BY GENRE
ORDER BY GENRE;

--create a view that displays everything in the CHATLOG table from any messages with a DATESENT between now and the previous week.

CREATE VIEW VW_RECENT_CHATLOG AS
SELECT *
FROM CHATLOG
WHERE DATESENT BETWEEN SYSDATE - 7 AND SYSDATE;

--Test View

SELECT *
FROM VW_RECENT_CHATLOG;

-- Create a view that displays the USERID, DATEASSIGNED, and PENALTY for any user whose PENALTY is not null and the infraction was assigned within the last month.

CREATE VIEW VW_RECENT_PENALTIES AS
SELECT USERID,
       DATEASSIGNED,
       PENALTY
FROM INFRACTIONS
WHERE PENALTY IS NOT NULL
  AND DATEASSIGNED >= ADD_MONTHS(SYSDATE, -1);

  --Test View

 SELECT *
FROM VW_RECENT_PENALTIES
ORDER BY DATEASSIGNED DESC;
 






