--BriTay2664 DisplayRelationalData 02/22/2026

--Display every USERNAME and the lowest RATING they have left in a review

SELECT u.USERNAME,
       MIN(r.RATING) AS LOWEST_RATING_LEFT
FROM USERBASE u
JOIN REVIEWS r
  ON r.USERID = u.USERID
GROUP BY u.USERNAME
ORDER BY u.USERNAME;

--Display every user’s EMAIL, QUESTION, and ANSWER

SELECT u.EMAIL,
       s.QUESTION,
       s.ANSWER
FROM USERBASE u
JOIN SECURITYQUESTION s
  ON u.USERID = s.USERID
ORDER BY u.EMAIL;

--Display the FIRSTNAME, EMAIL, and WALLETFUNDS of every user that does not have a WISHLIST.

SELECT u.FIRSTNAME,
       u.EMAIL,
       u.WALLETFUNDS
FROM USERBASE u
LEFT JOIN WISHLIST w
  ON u.USERID = w.USERID
WHERE w.USERID IS NULL
ORDER BY u.FIRSTNAME;

--Display every USERNAME and number of products they have ordered.

SELECT u.USERNAME,
       COUNT(o.ORDERID) AS NUMBER_OF_ORDERS
FROM USERBASE u
LEFT JOIN ORDERS o
  ON u.USERID = o.USERID
GROUP BY u.USERNAME
ORDER BY u.USERNAME;

--Display the age of any user who has ordered a product within the last 6 months.

SELECT DISTINCT
       u.USERNAME,
       FLOOR(MONTHS_BETWEEN(SYSDATE, u.BIRTHDAY)/12) AS AGE
FROM USERBASE u
JOIN ORDERS o
  ON u.USERID = o.USERID
WHERE o.PURCHASEDATE >= ADD_MONTHS(SYSDATE, -6)
ORDER BY u.USERNAME;

--Display the USERNAME and BIRTHDAY of the user who has the highest friend count.

SELECT u.USERNAME,
       u.BIRTHDAY
FROM USERBASE u
JOIN
(
    SELECT USERID
    FROM FRIENDS
    GROUP BY USERID
    ORDER BY COUNT(*) DESC
) f
ON u.USERID = f.USERID
WHERE ROWNUM = 1;

--Display the PRODUCTNAME, RELEASEDATE, PRICE, and DESCRIPTION for any product found in the WISHLIST table.

SELECT DISTINCT
       p.PRODUCTNAME,
       p.RELEASEDATE,
       p.PRICE,
       p.DESCRIPTION
FROM PRODUCTLIST p
JOIN WISHLIST w
  ON p.PRODUCTCODE = w.PRODUCTCODE
ORDER BY p.PRODUCTNAME;


--Display the PRODUCTNAME, highest RATING, and number of reviews for each product in the REVIEWS table. Order the results in descending order of the RATING.

SELECT p.PRODUCTNAME,
       MAX(r.RATING) AS HIGHEST_RATING,
       COUNT(*) AS REVIEW_COUNT
FROM PRODUCTLIST p
JOIN REVIEWS r
  ON p.PRODUCTCODE = r.PRODUCTCODE
GROUP BY p.PRODUCTNAME
ORDER BY HIGHEST_RATING DESC;

--Create a view that displays the PRODUCTNAME, GENRE, and RATING for every product with a 5 or a 1 RATING. Order the results in ascending order of the RATING.

CREATE VIEW VW_EXTREME_REVIEWS AS
SELECT p.PRODUCTNAME,
       p.GENRE,
       r.RATING
FROM PRODUCTLIST p
JOIN REVIEWS r
  ON p.PRODUCTCODE = r.PRODUCTCODE
WHERE r.RATING IN (1,5)
ORDER BY r.RATING ASC;

--Display the count of products ordered, grouped by GENRE. Order the results in alphabetical order of GENRE.

SELECT p.GENRE,
       COUNT(o.ORDERID) AS PRODUCTS_ORDERED
FROM PRODUCTLIST p
JOIN ORDERS o
  ON p.PRODUCTCODE = o.PRODUCTCODE
GROUP BY p.GENRE
ORDER BY p.GENRE;

--Create a view that displays each PUBLISHER, the average PRICE, and the sum of HOURSPLAYED for their products. 

CREATE VIEW VW_PUBLISHER_PRICE_PLAYTIME AS
SELECT p.PUBLISHER,
       ROUND(AVG(p.PRICE), 2) AS AVG_PRICE,
       NVL(SUM(ul.HOURSPLAYED), 0) AS TOTAL_HOURSPLAYED
FROM PRODUCTLIST p
LEFT JOIN USERLIBRARY ul
  ON ul.PRODUCTCODE = p.PRODUCTCODE
GROUP BY p.PUBLISHER;

--Display the sum of money spent on products and their corresponding PUBLISHER, from the ORDERS table. Order the results in descending order of the sum of money spent.

SELECT p.PUBLISHER,
       SUM(o.PRICE) AS TOTAL_SPENT
FROM ORDERS o
JOIN PRODUCTLIST p
  ON o.PRODUCTCODE = p.PRODUCTCODE
GROUP BY p.PUBLISHER
ORDER BY TOTAL_SPENT DESC;

--13.	Display the TICKETID, USERNAME, EMAIL, and ISSUE only for tickets with a STATUS of ‘NEW’ or ‘IN PROGRESS’, sorted by the latest DATEUPDATED.

SELECT t.TICKETID,
       u.USERNAME,
       t.EMAIL,
       t.ISSUE
FROM USERSUPPORT t
JOIN USERBASE u
  ON t.EMAIL = u.EMAIL
WHERE UPPER(t.STATUS) IN ('NEW','IN PROGRESS')
ORDER BY t.DATEUPDATED DESC;

--Display the USERNAME and count of TICKETID that users have submitted for user support.

SELECT u.USERNAME,
       COUNT(t.TICKETID) AS TICKET_COUNT
FROM USERBASE u
LEFT JOIN USERSUPPORT t
  ON u.EMAIL = t.EMAIL
GROUP BY u.USERNAME
ORDER BY u.USERNAME;

--Display the USERID and EMAIL of any user who has submitted a support ticket that used their FIRSTNAME, LASTNAME, or combination of the two in their EMAIL address.

SELECT DISTINCT
       u.USERID,
       u.EMAIL
FROM USERBASE u
JOIN USERSUPPORT t
  ON u.EMAIL = t.EMAIL
WHERE UPPER(u.EMAIL) LIKE '%' || UPPER(u.FIRSTNAME) || '%'
   OR UPPER(u.EMAIL) LIKE '%' || UPPER(u.LASTNAME) || '%'
   OR UPPER(u.EMAIL) LIKE '%' || UPPER(u.FIRSTNAME || u.LASTNAME) || '%';

--Display the EMAIL address of any user who has a ‘NEW’ or ‘IN PROGRESS’ support ticket STATUS, where the EMAIL is not currently saved in the USERBASE table.

SELECT DISTINCT t.EMAIL
FROM USERSUPPORT t
LEFT JOIN USERBASE u
  ON t.EMAIL = u.EMAIL
WHERE UPPER(t.STATUS) IN ('NEW','IN PROGRESS')
  AND u.EMAIL IS NULL
ORDER BY t.EMAIL;

--Display the TICKETID, FIRSTNAME, LASTNAME, and USERNAME of any user whose USERNAME is mentioned in the ISSUE of a support ticket.

SELECT t.TICKETID,
       u.FIRSTNAME,
       u.LASTNAME,
       u.USERNAME
FROM USERSUPPORT t
JOIN USERBASE u
  ON t.EMAIL = u.EMAIL
WHERE INSTR(UPPER(t.ISSUE), UPPER(u.USERNAME)) > 0
ORDER BY t.TICKETID;

--Display the USERNAME and PASSWORD associated with the EMAIL address provided in the support tickets

SELECT DISTINCT
       u.USERNAME,
       u.PASSWORD
FROM USERBASE u
JOIN USERSUPPORT t
  ON u.EMAIL = t.EMAIL
ORDER BY u.USERNAME;

--Create a view that displays the USERNAME, DATEASSIGNED, and PENALTY for any user whose PENALTY is not null and the infraction was assigned within the last month.

CREATE VIEW VW_RECENT_USER_PENALTIES AS
SELECT u.USERNAME,
       i.DATEASSIGNED,
       i.PENALTY
FROM USERBASE u
JOIN INFRACTIONS i
  ON u.USERID = i.USERID
WHERE i.PENALTY IS NOT NULL
  AND i.DATEASSIGNED >= ADD_MONTHS(SYSDATE, -1);

--Display the USERNAME and EMAIL of any user who is at least 18 years old and has not received an infraction within the last 4 months.

SELECT u.USERNAME,
       u.EMAIL
FROM USERBASE u
WHERE FLOOR(MONTHS_BETWEEN(SYSDATE, u.BIRTHDAY)/12) >= 18
AND NOT EXISTS
(
    SELECT 1
    FROM INFRACTIONS i
    WHERE i.USERID = u.USERID
      AND i.DATEASSIGNED >= ADD_MONTHS(SYSDATE, -4)
)
ORDER BY u.USERNAME;

--Display the USERNAME, DATEASSIGNED, and full guideline name (RULENUM and TITLE with a blank space inbetween) for any user who has violated the community rules.

SELECT u.USERNAME,
       i.DATEASSIGNED,
       TO_CHAR(r.RULENUM) || ' ' || r.TITLE AS FULL_GUIDELINE_NAME
FROM INFRACTIONS i
JOIN USERBASE u
  ON i.USERID = u.USERID
JOIN COMMUNITYRULES r
  ON i.RULENUM = r.RULENUM
ORDER BY u.USERNAME, i.DATEASSIGNED;

--Display the USERID, USERNAME, EMAIL, and sum of all SEVERITYPOINTS each user has received.

SELECT u.USERID,
       u.USERNAME,
       u.EMAIL,
       NVL(SUM(r.SEVERITYPOINT),0) AS TOTAL_SEVERITY_POINTS
FROM USERBASE u
LEFT JOIN INFRACTIONS i
  ON u.USERID = i.USERID
LEFT JOIN COMMUNITYRULES r
  ON i.RULENUM = r.RULENUM
GROUP BY u.USERID, u.USERNAME, u.EMAIL
ORDER BY TOTAL_SEVERITY_POINTS DESC;

--Display the TITLE, DESCRIPTION, and PENALTY for all infractions assigned.

SELECT r.TITLE,
       r.DESCRIPTION,
       i.PENALTY
FROM INFRACTIONS i
JOIN COMMUNITYRULES r
  ON i.RULENUM = r.RULENUM
ORDER BY r.TITLE;

--Display the USERNAME and count of infractions for users who have violated the community rules at least 15 times.

SELECT u.USERNAME,
       COUNT(*) AS INFRACTION_COUNT
FROM USERBASE u
JOIN INFRACTIONS i
  ON u.USERID = i.USERID
GROUP BY u.USERNAME
HAVING COUNT(*) >= 15
ORDER BY INFRACTION_COUNT DESC;