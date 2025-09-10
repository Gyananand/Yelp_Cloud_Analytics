-- =====================================================
-- Load Data into Snowflake from AWS S3
-- This script stages Yelp JSON files (reviews + business data)
-- into Snowflake raw tables for further transformation
-- =====================================================

-- 1️. Load Review Data
-- -----------------------------------------------------
-- The Yelp Review dataset (~5GB) was split into 10 smaller JSON files
-- for faster ingestion. These files were uploaded to an S3 bucket.
-- The COPY command loads the JSON into a VARIANT column in Snowflake.
-- -----------------------------------------------------

COPY INTO yelp_reviews (review_text)
FROM 's3://namastesqlbucket/review_splits/'   -- folder with split review files
CREDENTIALS = (
    AWS_KEY_ID = 'XXXXXXXX'                   -- replace with AWS key 
    AWS_SECRET_KEY = 'YYYYYYYY'               -- replace with AWS secret key 
)
FILE_FORMAT = (TYPE = JSON);


-- 2️. Load Business Data
-- -----------------------------------------------------
-- The Yelp Business dataset (business details, categories, location, etc.)
-- is a single JSON file. This COPY command ingests it into a raw table.
-- -----------------------------------------------------

COPY INTO yelp_business (business_text)
FROM 's3://namastesqlbucket/yelp_academic_dataset_business.json'
CREDENTIALS = (
    AWS_KEY_ID = 'XXXXXXXX'
    AWS_SECRET_KEY = 'YYYYYYYY'
)
FILE_FORMAT = (TYPE = JSON);

-- =====================================================
-- After running these COPY commands:
-- Raw JSON data is stored in yelp_reviews and yelp_business tables
-- Next step: Flatten the VARIANT column into structured tables
--    (handled in create_tables.sql)
-- =====================================================

