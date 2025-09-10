-- Create raw review table
CREATE OR REPLACE TABLE yelp_reviews (review_text VARIANT);

-- Create structured review table
CREATE OR REPLACE TABLE tbl_yelp_reviews AS
SELECT
    review_text:business_id::string AS business_id,
    review_text:date::date AS review_date,
    review_text:user_id::string AS user_id,
    review_text:stars::number AS review_stars,
    review_text:text::string AS review_text,
    analyze_sentiment(review_text) AS sentiments
FROM yelp_reviews;

-- Create raw business table
CREATE OR REPLACE TABLE yelp_business (business_text VARIANT);

-- Create structured business table
CREATE OR REPLACE TABLE tbl_yelp_business AS
SELECT
    business_text:business_id::string AS business_id,
    business_text:name::string AS name,
    business_text:city::string AS city,
    business_text:state::string AS state,
    business_text:review_count::string AS review_count,
    business_text:stars::number AS stars,
    business_text:categories::string AS categories
FROM yelp_business;
