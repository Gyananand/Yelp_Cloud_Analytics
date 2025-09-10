-- 10 Questions

-- 1. Find number of businesses in each category
 WITH CTE AS
  (SELECT business_id,
          trim(A.value) AS category
   FROM tbl_yelp_business,
        LATERAL split_to_table(categories, ',') AS A)
SELECT category,
       COUNT(business_id) AS Number_of_business
FROM CTE
GROUP BY category
ORDER BY Number_of_business DESC ;


-- 2. Find the top 10 users who have reviewed the most businesses in the "Restaurant" category

SELECT user_id,
       count(DISTINCT r.business_id)
FROM tbl_yelp_reviews r
JOIN tbl_yelp_business b ON r.business_id = b.business_id
WHERE categories ilike '%restaurants%'
  AND user_id IS NOT NULL
GROUP BY user_id
ORDER BY 2 DESC
LIMIT 10;


-- 3. Find the most popular categories of businesses (based on the number of reviews)
 WITH cte AS
  (SELECT business_id,
          trim(A.value) AS category
   FROM tbl_yelp_business,
        LATERAL split_to_table(categories, ',') AS A)
SELECT category,
       count(*)
FROM tbl_yelp_reviews r
JOIN cte ON cte.business_id = r.business_id
GROUP BY category
ORDER BY 2 DESC;


-- 4. Find the top 3 most recent reviews for each business

WITH cte AS
  (SELECT r.*,
          b.name,
          row_number() over(PARTITION BY r.business_id
                            ORDER BY review_date DESC) AS rn
   FROM tbl_yelp_reviews r
   JOIN tbl_yelp_business b ON r.business_id = b.business_id)
SELECT *
FROM cte
WHERE rn <= 3;


-- 5. Find the month with the highest number of reviews

SELECT month(review_date) AS review_month,
       count(*) AS no_of_reviews
FROM tbl_yelp_reviews
GROUP BY 1
ORDER BY 2 DESC;


-- 6. Find the percentage of 5-star review for each business

SELECT b.business_id,
       name,
       count(*) AS total_review,
       sum(CASE
               WHEN review_stars = 5 THEN 1
               ELSE 0
           END) AS five_star_review,
       round(five_star_review*100/total_review, 2) AS persentage_5_star
FROM tbl_yelp_reviews r
INNER JOIN tbl_yelp_business b ON b.business_id = r.business_id
GROUP BY b.business_id, name;


-- 7. Find the top 5 most reviewed businesses in each city
 WITH cte AS
  (SELECT b.city,
          b.business_id,
          name,
          count(*) AS total_review,
          row_number() over(PARTITION BY city
                            ORDER BY total_review DESC) AS rn
   FROM tbl_yelp_reviews r
   INNER JOIN tbl_yelp_business b ON b.business_id = r.business_id
   GROUP BY b.city,
            b.business_id,
            name)
SELECT city,
       business_id,
       name,
       total_review
FROM cte
WHERE rn <= 5
ORDER BY city,
         total_review DESC;


-- 8. find the average rating of businesses that have atleast 100 reviews

SELECT b.business_id,
       name,
       count(*) AS total_review,
       avg(review_stars) average_rating
FROM tbl_yelp_reviews r
INNER JOIN tbl_yelp_business b ON b.business_id = r.business_id
GROUP BY b.business_id,
         name
HAVING count(*) >= 100;


-- 9. list the top 10 users who have written the most reviews, along with the businesses they reviewed.

WITH cte AS
  (SELECT r.user_id,
          count(*) AS total_review
   FROM tbl_yelp_reviews r
   INNER JOIN tbl_yelp_business b ON b.business_id = r.business_id
   GROUP BY r.user_id
   ORDER BY total_review DESC
   LIMIT 10)
SELECT user_id,
       business_id
FROM tbl_yelp_reviews
WHERE user_id IN
    (SELECT user_id
     FROM cte)
ORDER BY user_id;


-- 10. find top 10 businesses with highest positive sentiment reviews

SELECT r.business_id,
       name,
       count(*) AS total_review
FROM tbl_yelp_reviews r
INNER JOIN tbl_yelp_business b ON b.business_id = r.business_id
GROUP BY 1, 2
ORDER BY 3 DESC
LIMIT 10;
