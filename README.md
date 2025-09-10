# Yelp Cloud Data Analytics Project

## 📌 Overview

This project demonstrates an **end-to-end cloud-based data analytics pipeline** using:

* **Python** for data preprocessing
* **AWS S3** for storage
* **Snowflake** for scalable querying & UDFs
* **SQL** for insights generation

The dataset used is the **[Yelp Open Dataset](https://business.yelp.com/data/resources/open-dataset/)** (\~5GB), which contains millions of user reviews, businesses, and ratings.

Due to its large size, the dataset cannot be processed efficiently on a local machine. Instead, the workflow leverages cloud platforms to handle ingestion, storage, transformation, and analysis.

---

## ⚙️ Project Workflow

1. **Data Preparation**

   * Split `review.json` (\~5GB) into 10 smaller files using Python.
   * Uploaded split files + `business.json` into an AWS S3 bucket.

2. **Data Ingestion to Snowflake**

   * Loaded raw JSON from S3 into Snowflake using `COPY INTO`.
   * Created staging tables with **VARIANT** columns to hold semi-structured data.
   * Flattened JSON into relational tables (`yelp_reviews`, `yelp_business`).

3. **UDF – Sentiment Analysis**

   * Implemented a Python UDF inside Snowflake for **sentiment classification** of reviews (Positive / Negative / Neutral).

4. **SQL Analysis**

   * Ran 10+ analysis queries including:

     * Top-rated businesses by city
     * Most active users
     * Sentiment distribution of reviews
     * Categories with highest average ratings

---

## 📊 Tools & Tech Stack

* **Python (pandas, json)** → Preprocessing
* **AWS S3** → Cloud storage
* **Snowflake** → Data warehouse
* **SQL** → Querying & analysis
* **Snowflake UDF (Python)** → Sentiment Analysis

---

## 📜 Yelp Dataset Documentation & Terms

* **License & Terms of Use**:

  > The Yelp dataset is provided **solely for academic and research purposes**. Commercial usage is not permitted. By using this dataset, you agree to abide by Yelp’s [Dataset Terms of Use](https://www.yelp.com/dataset/terms).

---

## 🚀 How to Reproduce

1. Clone this repo

   ```bash
   git clone https://github.com/yourusername/yelp-cloud-analytics.git
   cd yelp-cloud-analytics
   ```
2. Split Yelp JSON locally

   ```bash
   python python/split_json.py
   ```
3. Upload files to S3 bucket
4. Run `sql/create_tables.sql` and `sql/load_data.sql` in Snowflake
5. Explore insights with `sql/analysis_queries.sql`




